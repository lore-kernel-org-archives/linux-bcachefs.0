Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCB3193435
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482093; cv=none; b=LG8hfB0eqaaWMhc8e94Bo22IBZLT8tgqiJOLwGhTYgtXElgP9AUIWmDHoNG8vbl04KMCMDFwCC2lfBpttO4qS4Qc0iMcdBTGVQbGrXZ9FbyeHAXaMVXC8gLn6o4FoWDC7NfINy7sSpUkvaC4q3RNuokzssT3wBm7mgyuk3vrCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482093; c=relaxed/simple;
	bh=2hjsBo1D8yeV5GCByOu+CUuskQaIBwvcgDAzg4UJ7Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfJUmlx1hFBel+UWPtXrx6isOOB8Auavxw7YsmfGQ4YpBmzO0Dy4MWMea0nS/Qtuxkgmw0BUq9dIMfL6eBYf5NGSuhqt4CTpawFrKrYEBDXZ4nxnQxPLuMp1PIfYUma/FdWoVSWg8NWMpb3KqA5CsOFmzKUAJwP32QZRARfIspk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kz0Ubc80; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kz0Ubc80"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OEvKFw/lmzUAzb7jgXzu4R3b22E+hhcWGJpihJxjzVI=;
	b=kz0Ubc80Zht87z7XFwmDo5/EVQj+b0iQYPlH6sYJnpv1P8mLywc1K8ArcX1oMnJQ2uVsmA
	hqGid4TYbdFM8EEdbo//Uudj/pKnmLJDCJH1QGU3s4BwP9gKU3pVyVwplw+YkZ6pTidRq2
	xGJaHOCBNqBuC18HlaDoXtwPBKrVVU8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/12] bcachefs: bch2_write_inode() now checks for changing rebalance options
Date: Sun, 20 Oct 2024 23:41:03 -0400
Message-ID: <20241021034106.384756-13-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, BCHFS_IOC_REINHERIT_ATTRS didn't trigger rebalance scans
when changing rebalance options - it had been missed, only the xattr
interface triggered them.

Ideally they'd be done by the transactional trigger, but unpacking the
inode to get the options is too heavy to be done in the low level
trigger - the inode trigger is run on every extent update, since the
bch_inode.bi_journal_seq has to be updated for fsync.

bch2_write_inode() is a good compromise, it already unpacks and repacks
and is not run in any super-fast paths.

Additionally, creating the new rebalance entry to trigger the scan is
now done in the same transaction as the inode update that changed the
options.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c        | 26 +++++++++++++++++++++-----
 fs/bcachefs/inode.h     |  8 ++++++++
 fs/bcachefs/rebalance.c |  4 ++--
 fs/bcachefs/rebalance.h |  1 +
 fs/bcachefs/xattr.c     |  7 -------
 5 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 79bc54e779ab..9ca001a1d0cb 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -23,6 +23,7 @@
 #include "journal.h"
 #include "keylist.h"
 #include "quota.h"
+#include "rebalance.h"
 #include "snapshot.h"
 #include "super.h"
 #include "xattr.h"
@@ -89,10 +90,25 @@ int __must_check bch2_write_inode(struct bch_fs *c,
 retry:
 	bch2_trans_begin(trans);
 
-	ret   = bch2_inode_peek(trans, &iter, &inode_u, inode_inum(inode),
-				BTREE_ITER_intent) ?:
-		(set ? set(trans, inode, &inode_u, p) : 0) ?:
-		bch2_inode_write(trans, &iter, &inode_u) ?:
+	ret = bch2_inode_peek(trans, &iter, &inode_u, inode_inum(inode), BTREE_ITER_intent);
+	if (ret)
+		goto err;
+
+	struct bch_extent_rebalance old_r = bch2_inode_rebalance_opts_get(c, &inode_u);
+
+	ret = (set ? set(trans, inode, &inode_u, p) : 0);
+	if (ret)
+		goto err;
+
+	struct bch_extent_rebalance new_r = bch2_inode_rebalance_opts_get(c, &inode_u);
+
+	if (memcmp(&old_r, &new_r, sizeof(new_r))) {
+		ret = bch2_set_rebalance_needs_scan_trans(trans, inode_u.bi_inum);
+		if (ret)
+			goto err;
+	}
+
+	ret   = bch2_inode_write(trans, &iter, &inode_u) ?:
 		bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
 
 	/*
@@ -101,7 +117,7 @@ int __must_check bch2_write_inode(struct bch_fs *c,
 	 */
 	if (!ret)
 		bch2_inode_update_after_write(trans, inode, &inode_u, fields);
-
+err:
 	bch2_trans_iter_exit(trans, &iter);
 
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index bdeb6be76038..f52336cb298f 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -262,6 +262,14 @@ void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
 int bch2_inum_opts_get(struct btree_trans*, subvol_inum, struct bch_io_opts *);
 
+static inline struct bch_extent_rebalance
+bch2_inode_rebalance_opts_get(struct bch_fs *c, struct bch_inode_unpacked *inode)
+{
+	struct bch_io_opts io_opts;
+	bch2_inode_opts_get(&io_opts, c, inode);
+	return io_opts_to_rebalance_opts(&io_opts);
+}
+
 int bch2_inode_rm_snapshot(struct btree_trans *, u64, u32);
 int bch2_delete_dead_inodes(struct bch_fs *);
 
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index d094dcd72fb4..7ebf71ad0358 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -33,7 +33,7 @@ static const char * const bch2_rebalance_state_strs[] = {
 #undef x
 };
 
-static int __bch2_set_rebalance_needs_scan(struct btree_trans *trans, u64 inum)
+int bch2_set_rebalance_needs_scan_trans(struct btree_trans *trans, u64 inum)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -73,7 +73,7 @@ int bch2_set_rebalance_needs_scan(struct bch_fs *c, u64 inum)
 	int ret = bch2_trans_commit_do(c, NULL, NULL,
 				       BCH_TRANS_COMMIT_no_enospc|
 				       BCH_TRANS_COMMIT_lazy_rw,
-			    __bch2_set_rebalance_needs_scan(trans, inum));
+			    bch2_set_rebalance_needs_scan_trans(trans, inum));
 	rebalance_wakeup(c);
 	return ret;
 }
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 28a52638f16c..791649c04ff5 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -4,6 +4,7 @@
 
 #include "rebalance_types.h"
 
+int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
 int bch2_set_fs_needs_rebalance(struct bch_fs *);
 
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index bf3c6bb50495..ed418a747cdd 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -565,13 +565,6 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 	ret = bch2_write_inode(c, inode, inode_opt_set_fn, &s, 0);
 err:
 	mutex_unlock(&inode->ei_update_lock);
-
-	if (value &&
-	    (opt_id == Opt_background_target ||
-	     opt_id == Opt_background_compression ||
-	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
-		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
-
 err_class_exit:
 	return bch2_err_class(ret);
 }
-- 
2.45.2

