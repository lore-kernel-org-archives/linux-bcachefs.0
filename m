Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EA423D7D8
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756963323; cv=none; b=MR8K0j+WSHqlb1bfch82m5Fp3R0Ikp9j9WS5UB/Pm+D/jf56JlKtCYoasXwHX5lhPVi5yHIMYltv6rBPfnNLfuJSXPXnnprxKbeo0Xo7csMnh7mBGl5ecPDKCweBmUqMj/nau6nWUQKU444TFg+08VGl/5y7YsLBCqOAEdNcqcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756963323; c=relaxed/simple;
	bh=ifdpNcMey2Q85pcafRa0vyZmTq9MWSUVg2wkhpoG4Uk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WTHQghJDZG+bwgnCc7eELJBt2xaU9IdTSAMO/rjTWyhOGcmkyx0qv5Tsv1nkGW7lzUa1l5c2RwIK6kgaC9A3tb7xldPQVIaV+ry9q7aSQZAEtkYOma+5amAYqEiyGn3nMlAxT7yjqQXXpmle3vE86xcXNYQBPrVHKmGjb4SDP10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYDOMJr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYDOMJr/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A313C4CEF1;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756963323;
	bh=ifdpNcMey2Q85pcafRa0vyZmTq9MWSUVg2wkhpoG4Uk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kYDOMJr/MgSmiF/LItpAw0NijyrftuGPtQHiY6UR49asBUCHSuoyyDHqz0KvQ5z8Q
	 UCKnGKYeMya9ZchcZtPmoG5cRlg4IiEJc1e5QzL0Av4stchKb0AqPzSDvkSyO4Jne3
	 e+lrPzES1tr6+IwbOeianOzTTT+dsOk7D+k/MQc0Y1BSx/UByFj+4OAopnImQ9QGkO
	 Ali6lWXlMJCrQrGReEEPd43E4PLYfbOTLpc+jrI2weOUInwJIN4ZTls+TKoZM7P07n
	 O6WsUFoqr8PSf+qlODWZgUOy7InbIlUCqkJi/+ZkUwr7WJgMFzXX2F72xVcfAwj+Wv
	 bwSokmHWf82rQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6D1CA1012;
	Thu,  4 Sep 2025 05:22:03 +0000 (UTC)
From: Nikita Ofitserov via B4 Relay <devnull+himikof.gmail.com@kernel.org>
Date: Thu, 04 Sep 2025 08:20:36 +0300
Subject: [PATCH v3 5/7] bcachefs: Use explicit node counts in progress
 reporting
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250904-better-progress-v3-5-6cc4edf543f4@gmail.com>
References: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
In-Reply-To: <20250904-better-progress-v3-0-6cc4edf543f4@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Nikita Ofitserov <himikof@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1742; i=himikof@gmail.com;
 h=from:subject:message-id;
 bh=W0+LRH5XYqdB0aj9wQSy1UVKyJFpf8VMp390jsXj01M=;
 b=owGbwMvMwCW2edHtzWZP9DIYT6slMWTsVPzJFvpSQspoUsXMa7FPvsfYctz2FdpybHpoZO/PR
 yaNxv9/dpSyMIhxMciKKbJ8WPL1z5pM6z+WQnsNYeawMoEMYeDiFICJrL3F8D/vsq8Z2/mDyrKV
 O86k/W+RV/xnbeZYkVsUFrnrrtqh9a2MDMsKtqlv4ruxIGXGB+n0tRcic7a2/fp59SyrUsDOOaU
 PutkB
X-Developer-Key: i=himikof@gmail.com; a=openpgp;
 fpr=F0A4F5FCAC693BFC3912BD31B3A2DBB336E42E68
X-Endpoint-Received: by B4 Relay for himikof@gmail.com/default with
 auth_id=452
X-Original-From: Nikita Ofitserov <himikof@gmail.com>
Reply-To: himikof@gmail.com

From: Nikita Ofitserov <himikof@gmail.com>

Also, consider the metadata_replicas option when better
accounting is not available.

Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
---
 fs/bcachefs/progress.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/progress.c b/fs/bcachefs/progress.c
index 541ee951d1c9fc3f11b5a5ac40f1d366829a5c97..8181f6d2ca3808f57bef179383bd969d9a375d5f 100644
--- a/fs/bcachefs/progress.c
+++ b/fs/bcachefs/progress.c
@@ -12,6 +12,10 @@ void bch2_progress_init(struct progress_indicator_state *s,
 
 	s->next_print = jiffies + HZ * 10;
 
+	/* This is only an estimation: nodes can have different replica counts */
+	const u32 expected_node_disk_sectors =
+		READ_ONCE(c->opts.metadata_replicas) * btree_sectors(c);
+
 	for (unsigned i = 0; i < btree_id_nr_alive(c); i++) {
 		if (!(btree_id_mask & BIT_ULL(i)))
 			continue;
@@ -19,9 +23,23 @@ void bch2_progress_init(struct progress_indicator_state *s,
 		struct disk_accounting_pos acc;
 		disk_accounting_key_init(acc, btree, .id = i);
 
-		u64 v;
-		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc), &v, 1);
-		s->nodes_total += div64_ul(v, btree_sectors(c));
+		struct {
+			u64 disk_sectors;
+			u64 total_nodes;
+			u64 inner_nodes;
+		} v = {0};
+		bch2_accounting_mem_read(c, disk_accounting_pos_to_bpos(&acc),
+			(u64 *)&v, sizeof(v) / sizeof(u64));
+
+		/*
+		 * We check for zeros to degrade gracefully when run
+		 * with un-upgraded accounting info (missing some counters).
+		 */
+
+		if (v.total_nodes != 0)
+			s->nodes_total += v.total_nodes - v.inner_nodes;
+		else
+			s->nodes_total += div_u64(v.disk_sectors, expected_node_disk_sectors);
 	}
 }
 

-- 
2.50.1


