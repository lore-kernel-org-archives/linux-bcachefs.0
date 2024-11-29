Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4942E14D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912093; cv=none; b=kOAOVP4jKduuS1ZBTMkXuPTyhepAPW6RFmxtqolwqMvhv0IaYVOtLBHodKPDR4NxbLbX7XgL6HyOx81AG1hbiqo77Ioj3L9IIqAwWfHNZLGDOjANxdGZhFoOp98wOjKRXF57gyL5DxUDFZ/Gc15XV5JgVRurSJt+YxCOL+JujOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912093; c=relaxed/simple;
	bh=gEZmS7loRDr/prnz+g/ZLoGEBBJNOk/L91FoOpgBb9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay8L6N/BPFq/TbwW3mVkxXpSTdQU7MdcfVvpbvaUNh77XBosh98XAp8olrkqLyQCDRdLCKlgO7xMVNbM9rsW30Da+H9C/OjKRnu8BVODif85jnPz8gEqk7KloBXDzZLBH7bKzV0fTIjzBeUVsX/vIZ/3ImJ1EU5lLx5yJR0yWH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 27/34] bcachefs: Don't error out when logging fsck error
Date: Fri, 29 Nov 2024 15:27:26 -0500
Message-ID: <20241129202736.2713679-28-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  8 +++++---
 fs/bcachefs/error.c            | 29 +++++++++++++++++------------
 fs/bcachefs/error.h            | 14 +++++++++-----
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 79af226ca609..6de0387ede99 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -676,6 +676,10 @@ static int __need_discard_or_freespace_err(struct btree_trans *trans,
 				  set ? "" : "un",
 				  bch2_btree_id_str(btree),
 				  buf.buf);
+	if (ret == -BCH_ERR_fsck_ignore ||
+	    ret == -BCH_ERR_fsck_errors_not_fixed)
+		ret = 0;
+
 	printbuf_exit(&buf);
 	return ret;
 }
@@ -1901,10 +1905,8 @@ static int bch2_do_discards_fast_one(struct btree_trans *trans,
 	if (log_fsck_err_on(discard_k.k->type != KEY_TYPE_set,
 			    trans, discarding_bucket_not_in_need_discard_btree,
 			    "attempting to discard bucket %u:%llu not in need_discard btree",
-			    ca->dev_idx, bucket)) {
-		/* log it in the superblock and continue: */
+			    ca->dev_idx, bucket))
 		goto out;
-	}
 
 	ret = bch2_discard_one_bucket(trans, ca, &need_discard_iter, discard_pos_done, s, true);
 out:
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 5b67361b0cf1..23b9ecbcf3cf 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -227,7 +227,7 @@ int __bch2_fsck_err(struct bch_fs *c,
 {
 	struct fsck_err_state *s = NULL;
 	va_list args;
-	bool print = true, suppressing = false, inconsistent = false;
+	bool print = true, suppressing = false, inconsistent = false, exiting = false;
 	struct printbuf buf = PRINTBUF, *out = &buf;
 	int ret = -BCH_ERR_fsck_ignore;
 	const char *action_orig = "fix?", *action = action_orig;
@@ -320,13 +320,19 @@ int __bch2_fsck_err(struct bch_fs *c,
 		prt_printf(out, bch2_log_msg(c, ""));
 #endif
 
-	if ((flags & FSCK_CAN_FIX) &&
-	    (flags & FSCK_AUTOFIX) &&
+	if ((flags & FSCK_AUTOFIX) &&
 	    (c->opts.errors == BCH_ON_ERROR_continue ||
 	     c->opts.errors == BCH_ON_ERROR_fix_safe)) {
 		prt_str(out, ", ");
-		prt_actioning(out, action);
-		ret = -BCH_ERR_fsck_fix;
+		if (flags & FSCK_CAN_FIX) {
+			prt_actioning(out, action);
+			ret = -BCH_ERR_fsck_fix;
+		} else {
+			prt_str(out, ", continuing");
+			ret = -BCH_ERR_fsck_ignore;
+		}
+
+		goto print;
 	} else if (!test_bit(BCH_FS_fsck_running, &c->flags)) {
 		if (c->opts.errors != BCH_ON_ERROR_continue ||
 		    !(flags & (FSCK_CAN_FIX|FSCK_CAN_IGNORE))) {
@@ -396,14 +402,13 @@ int __bch2_fsck_err(struct bch_fs *c,
 	     !(flags & FSCK_CAN_IGNORE)))
 		ret = -BCH_ERR_fsck_errors_not_fixed;
 
-	bool exiting =
-		test_bit(BCH_FS_fsck_running, &c->flags) &&
-		(ret != -BCH_ERR_fsck_fix &&
-		 ret != -BCH_ERR_fsck_ignore);
-
-	if (exiting)
+	if (test_bit(BCH_FS_fsck_running, &c->flags) &&
+	    (ret != -BCH_ERR_fsck_fix &&
+	     ret != -BCH_ERR_fsck_ignore)) {
+		exiting = true;
 		print = true;
-
+	}
+print:
 	if (print) {
 		if (bch2_fs_stdio_redirect(c))
 			bch2_print(c, "%s\n", out->buf);
diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
index 3b278f28e56b..12ca5287e20a 100644
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -45,12 +45,11 @@ int bch2_topology_error(struct bch_fs *);
 	bch2_inconsistent_error(c);					\
 })
 
-#define bch2_fs_inconsistent_on(cond, c, ...)				\
+#define bch2_fs_inconsistent_on(cond, ...)				\
 ({									\
 	bool _ret = unlikely(!!(cond));					\
-									\
 	if (_ret)							\
-		bch2_fs_inconsistent(c, __VA_ARGS__);			\
+		bch2_fs_inconsistent(__VA_ARGS__);			\
 	_ret;								\
 })
 
@@ -146,8 +145,13 @@ void bch2_flush_fsck_errs(struct bch_fs *);
 #define log_fsck_err(c, _err_type, ...)					\
 	__fsck_err(c, FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
 
-#define log_fsck_err_on(cond, c, _err_type, ...)				\
-	__fsck_err_on(cond, c, FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
+#define log_fsck_err_on(cond, ...)					\
+({									\
+	bool _ret = unlikely(!!(cond));					\
+	if (_ret)							\
+		log_fsck_err(__VA_ARGS__);				\
+	_ret;								\
+})
 
 enum bch_validate_flags;
 __printf(5, 6)
-- 
2.45.2

