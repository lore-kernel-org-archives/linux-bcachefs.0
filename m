Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85022F50B3
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681713; cv=none; b=B2BSI1B7AZ3fq/cjwIrx/nNLcN83U+2k1n8C45fIIVtKSrOii4kiOBihFSg81jvLAxd5RiwemzKLQqyVHhAwyLKbJWlgFMl3itsloAGpCumaUsfrJS5+IeDbv5kIdp99ccOfKGTOazIdYsdcLcMcwlqcbENzdw0srh19ujwpuXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681713; c=relaxed/simple;
	bh=S65UghuK42sCk2As6oiEQakA51IxaqyLY8O2rgEaWoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSIpSel39JMs5JH+RqwXaDlrN2+BfJQRN9o7SGURYOPR74kZuCmXMZOcAb/TCa2KvuAvrMATUuTi4TdDl2Gxd7X0TueGuddWZr6+8Qoz0whWHdFY1CDHjajn6UmHBFldzy7FPEBsrOm0SsphQ4uEPUa4bV3hp/iLb72izM/94jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i44rZ3Ue; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i44rZ3Ue"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAL/EHZXc0QkgTJbAvwSd1cq8DffA7LIvQKD02ajE2k=;
	b=i44rZ3UeVQMSWClSPg+W3RIxxwbDcqQCCjemZsgm1v8f/bX0+tKyuswlOsFU8E5fpoHt56
	7vd2BAz/27VsdZYF45AXqxVARoxCIcoeFD/hU6bmptWLq2F7K8L7N27UcU+WP8O48Ia2LD
	NVXFQ+cgIvGTI3d30/3nprBn+uSrIIE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com
Subject: [PATCH 5/7] bcachefs: Don't build aux search tree when still repairing node
Date: Wed, 16 Jul 2025 12:01:39 -0400
Message-ID: <20250716160141.1158722-5-kent.overstreet@linux.dev>
In-Reply-To: <20250716160141.1158722-1-kent.overstreet@linux.dev>
References: <20250716160141.1158722-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_btree_node_drop_keys_outside_node() will (re)build aux search
trees, because it's also called by topology repair.

bch2_btree_node_read_done() was calling it before validating individual
keys; invalid ones have to be dropped.

If we call drop_keys_outside_node() first, then
bch2_bset_build_aux_tree() doesn't run because the node already has an
aux search tree - which was invalidated by the repair.

Reported-by: syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index a4cc72986e36..590cd29f3e86 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1295,9 +1295,6 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 
 	btree_bounce_free(c, btree_buf_bytes(b), used_mempool, sorted);
 
-	if (updated_range)
-		bch2_btree_node_drop_keys_outside_node(b);
-
 	i = &b->data->keys;
 	for (k = i->start; k != vstruct_last(i);) {
 		struct bkey tmp;
@@ -1335,6 +1332,9 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 
 	btree_node_reset_sib_u64s(b);
 
+	if (updated_range)
+		bch2_btree_node_drop_keys_outside_node(b);
+
 	/*
 	 * XXX:
 	 *
-- 
2.50.0

