Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F2318DB2B
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810655; cv=none; b=hE8mg8J2rb9wVx86ybBo3Us5Iaa7KsN78+CDK9U9Tj1HgUB1VLVXYkL8xvOsoHgbqcLjY4G6dbXy0bpUIx+OrZtvGTnBS2Knw6WJjuqeVD4myGQ+3NCOWtpD6dGLW0BoV4Np6U6aAJXw7EDcvbPTPvf5IrCEi+1yzlXBdx1gIDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810655; c=relaxed/simple;
	bh=j69LS3FQ9k1FqJ/U7FpNSZK1UqQ5l0E2n+UjReNiVn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLmYCuIMpTrdJR+SEVRuwd63fuYvXuKEaPGzLQKPqtXu7L3ZdINQ+bssYt0f/FaGkjS5IkA+vKy2pqdJ9w6YnvY5A5cPpGP5XI2DsVKlJ5TJ7+M08VGwBY/12slNok5QBUyKNI1xls/uuKIe2d9cYPUJwNRKpe21SR7+hVFGks4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gCBbIIwg; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gCBbIIwg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XqPGITcrxC9TSO9JAq4A3Kr6Zoi5EcQzs9X8smh5nc=;
	b=gCBbIIwg7Px5/138XvB4iwbdLXY0i5HUG2K9ItMyy0J/m6tK7Yg98VbVKOzUEuVXSzlbyO
	9Syd6YMvncediJjk+4wfsuWpAPceY4iv/G2iikUTDxaHJ4rciMq1Q4xkG7UYc3ywDHe570
	Z2Nis8o3Gkoh6MLd8GnBGLOS2IUhDnI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/6] bcachefs: Flag for repair on missing subvolume
Date: Wed, 16 Apr 2025 09:37:23 -0400
Message-ID: <20250416133724.3653606-5-kent.overstreet@linux.dev>
In-Reply-To: <20250416133724.3653606-1-kent.overstreet@linux.dev>
References: <20250416133724.3653606-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Instead of going emegency read only with a bch2_fs_inconsistent() call,
log the error and recovery pass appropriately.

If we're still in recovery it'll be repaired immediately, otherwise
it'll be repaired on the next mount.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/sb-errors_format.h |  3 ++-
 fs/bcachefs/subvolume.c        | 44 ++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index dc53d25c7cbb..83acfd9cd5f7 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -298,6 +298,7 @@ enum bch_fsck_flags {
 	x(btree_ptr_v2_written_0,				268,	0)		\
 	x(subvol_snapshot_bad,					269,	0)		\
 	x(subvol_inode_bad,					270,	0)		\
+	x(subvol_missing,					308,	FSCK_AUTOFIX)	\
 	x(alloc_key_stripe_sectors_wrong,			271,	FSCK_AUTOFIX)	\
 	x(accounting_mismatch,					272,	FSCK_AUTOFIX)	\
 	x(accounting_replicas_not_marked,			273,	0)		\
@@ -317,7 +318,7 @@ enum bch_fsck_flags {
 	x(directory_size_mismatch,				303,	FSCK_AUTOFIX)	\
 	x(dirent_cf_name_too_big,				304,	0)		\
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
-	x(MAX,							308,	0)
+	x(MAX,							309,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index c9acaf139a13..1b9fb60c05be 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -6,6 +6,7 @@
 #include "errcode.h"
 #include "error.h"
 #include "fs.h"
+#include "recovery_passes.h"
 #include "snapshot.h"
 #include "subvolume.h"
 
@@ -13,6 +14,22 @@
 
 static int bch2_subvolume_delete(struct btree_trans *, u32);
 
+static int bch2_subvolume_missing(struct bch_fs *c, u32 subvolid)
+{
+	struct printbuf buf = PRINTBUF;
+	bch2_log_msg_start(c, &buf);
+
+	prt_printf(&buf, "missing subvolume %u", subvolid);
+	bool print = bch2_count_fsck_err(c, subvol_missing, &buf);
+
+	int ret = bch2_run_explicit_recovery_pass_printbuf(c, &buf,
+					BCH_RECOVERY_PASS_check_inodes);
+	if (print)
+		bch2_print_str(c, KERN_ERR, buf.buf);
+	printbuf_exit(&buf);
+	return ret;
+}
+
 static struct bpos subvolume_children_pos(struct bkey_s_c k)
 {
 	if (k.k->type != KEY_TYPE_subvolume)
@@ -291,9 +308,8 @@ bch2_subvolume_get_inlined(struct btree_trans *trans, unsigned subvol,
 	int ret = bch2_bkey_get_val_typed(trans, BTREE_ID_subvolumes, POS(0, subvol),
 					  BTREE_ITER_cached|
 					  BTREE_ITER_with_updates, subvolume, s);
-	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT) &&
-				inconsistent_if_not_found,
-				trans->c, "missing subvolume %u", subvol);
+	if (bch2_err_matches(ret, ENOENT) && inconsistent_if_not_found)
+		ret = bch2_subvolume_missing(trans->c, subvol) ?: ret;
 	return ret;
 }
 
@@ -343,8 +359,8 @@ int __bch2_subvolume_get_snapshot(struct btree_trans *trans, u32 subvolid,
 					  subvolume);
 	ret = bkey_err(subvol);
 
-	bch2_fs_inconsistent_on(warn && bch2_err_matches(ret, ENOENT), trans->c,
-				"missing subvolume %u", subvolid);
+	if (bch2_err_matches(ret, ENOENT))
+		ret = bch2_subvolume_missing(trans->c, subvolid) ?: ret;
 
 	if (likely(!ret))
 		*snapid = le32_to_cpu(subvol.v->snapshot);
@@ -417,8 +433,8 @@ static int __bch2_subvolume_delete(struct btree_trans *trans, u32 subvolid)
 				BTREE_ITER_cached|BTREE_ITER_intent,
 				subvolume);
 	int ret = bkey_err(subvol);
-	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), trans->c,
-				"missing subvolume %u", subvolid);
+	if (bch2_err_matches(ret, ENOENT))
+		ret = bch2_subvolume_missing(trans->c, subvolid) ?: ret;
 	if (ret)
 		goto err;
 
@@ -552,11 +568,10 @@ int bch2_subvolume_unlink(struct btree_trans *trans, u32 subvolid)
 			BTREE_ID_subvolumes, POS(0, subvolid),
 			BTREE_ITER_cached, subvolume);
 	ret = PTR_ERR_OR_ZERO(n);
-	if (unlikely(ret)) {
-		bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), trans->c,
-					"missing subvolume %u", subvolid);
+	if (bch2_err_matches(ret, ENOENT))
+		ret = bch2_subvolume_missing(trans->c, subvolid) ?: ret;
+	if (unlikely(ret))
 		return ret;
-	}
 
 	SET_BCH_SUBVOLUME_UNLINKED(&n->v, true);
 	n->v.fs_path_parent = 0;
@@ -595,11 +610,10 @@ int bch2_subvolume_create(struct btree_trans *trans, u64 inode,
 				BTREE_ID_subvolumes, POS(0, src_subvolid),
 				BTREE_ITER_cached, subvolume);
 		ret = PTR_ERR_OR_ZERO(src_subvol);
-		if (unlikely(ret)) {
-			bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), c,
-						"subvolume %u not found", src_subvolid);
+		if (bch2_err_matches(ret, ENOENT))
+			ret = bch2_subvolume_missing(trans->c, src_subvolid) ?: ret;
+		if (unlikely(ret))
 			goto err;
-		}
 
 		parent = le32_to_cpu(src_subvol->v.snapshot);
 	}
-- 
2.49.0

