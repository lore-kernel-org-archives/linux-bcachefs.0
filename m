Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0714D1A3BD8
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912071; cv=none; b=efVkbYF7xey/0XjSHpSePjT2s4aYRDSyZBc2gTuEnn/Pdai3IHxls46A9MfPyYVF9ByXYmfF+W5Tj4qVVYebnvJWA2pVzW+CZtsQjXZr1MDH3bE/TyKcSv4JbR7fpFEsTE9SYUzqv2rm1qUBbtfy+ejTdKSjwuhlAPiDebY4PjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912071; c=relaxed/simple;
	bh=ucjXJcRl5XHkslKzAIqN7e/7PlnH4IVKdjJLTd0vWCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAg1IhsGmTLBTL75m/c1NrzzR4bUgPTpvpBo26LrJ/fsnbVybug8pNF5YNUoBy/mbsOzF2+Vbt6V49wfzDuzs7tvtdFjOovz5OnfcHQWiBnJdtIwbCarWF3UtRH+O3w0a9+GhgMuwApnL82Vvb7NG+7mub5MYTHn0UUbM158MR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/34] bcachefs: Fix accounting_read when we rewind
Date: Fri, 29 Nov 2024 15:27:04 -0500
Message-ID: <20241129202736.2713679-6-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we rewind recovery to run topology repair, that causes
accounting_read to run twice.

This fixes accounting being double counted.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index fa821d278c45..bb5dbbf71d04 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -700,6 +700,21 @@ int bch2_accounting_read(struct bch_fs *c)
 	struct btree_trans *trans = bch2_trans_get(c);
 	struct printbuf buf = PRINTBUF;
 
+	/*
+	 * We might run more than once if we rewind to start topology repair or
+	 * btree node scan - and those might cause us to get different results,
+	 * so we can't just skip if we've already run.
+	 *
+	 * Instead, zero out any accounting we have:
+	 */
+	percpu_down_write(&c->mark_lock);
+	darray_for_each(acc->k, e)
+		percpu_memset(e->v[0], 0, sizeof(u64) * e->nr_counters);
+	for_each_member_device(c, ca)
+		percpu_memset(ca->usage, 0, sizeof(*ca->usage));
+	percpu_memset(c->usage, 0, sizeof(*c->usage));
+	percpu_up_write(&c->mark_lock);
+
 	int ret = for_each_btree_key(trans, iter,
 				BTREE_ID_accounting, POS_MIN,
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k, ({
-- 
2.45.2

