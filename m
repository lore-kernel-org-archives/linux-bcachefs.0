Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416B82AD2F
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751319089; cv=none; b=Okmoa5i0aZ+uu3V2mcMoEg4e9LLsFsa5chDQRqjPKXQsKpnNEmg6RHYmeGNKPiPm9Lqv31MrJ75YhyjouOsiEfzDvKyKpaA/I8mfNRnTlYmwhb1SN+pgYQDSjht4gmL/Ot7XAjmGkspMC4KnZchU7a5n29ZlvFHvZwQMwz6io88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751319089; c=relaxed/simple;
	bh=jlUma7hoTVI6G7YLS3IgSjayOc6y7HGJz0HBybErSxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNvyNdKgFVdxwWFrP4FJ/k352fcUwthI0OF0O+UGcWoTvnRx9PkTUcj+z7F0xOPbtvyoZ6u3XrxaGaeEfrdgzmWV2RHCXRTPY050qltAoAZ3IYOPuTKx7AkD41rJVYfRcUtwOVGWFgQ9mssKVCDCqA8seFTfOyUqHxNdxCrJmnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e5SLF9OE; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e5SLF9OE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751319085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Ec0n2dpUynZ3JzpaFDrfFUjfhafqjTZAKSeMOoQf6Q=;
	b=e5SLF9OEwcHtAaFgBT0z8Pt8hVzS0QFrTI0df5TS1kpf7U7yQ+LQodotuu53mSdAtIx4ka
	7fC3pVyFtvVdFxDsqJIW26dyXISiU6kKKR0vpAMW3dbAXowjtXVnc7bAfStuJKF0mx5ySH
	n7DhOWWXa3+p8KZvpBvckLRtVXPYyZU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Before removing dangling dirents, check for contents
Date: Mon, 30 Jun 2025 17:31:17 -0400
Message-ID: <20250630213118.2063622-2-kent.overstreet@linux.dev>
In-Reply-To: <20250630213118.2063622-1-kent.overstreet@linux.dev>
References: <20250630213118.2063622-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we find a dirent pointing to a missing inode, check for
dirents/extents assocatiated with that inode number: if present,
reconstruct the inode insead of deleting the dirent.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c             | 44 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-errors_format.h |  3 ++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 453a5c3184ea..a94dea16e4cf 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1572,6 +1572,43 @@ static int check_key_has_inode(struct btree_trans *trans,
 	goto out;
 }
 
+static int maybe_reconstruct_inum_btree(struct btree_trans *trans,
+					u64 inum, u32 snapshot,
+					enum btree_id btree)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret = 0;
+
+	for_each_btree_key_max_norestart(trans, iter, btree,
+					 SPOS(inum, 0, snapshot),
+					 POS(inum, U64_MAX),
+					 0, k, ret) {
+		ret = 1;
+		break;
+	}
+	bch2_trans_iter_exit(trans, &iter);
+
+	if (ret <= 0)
+		return ret;
+
+	if (fsck_err(trans, missing_inode_with_contents,
+		     "inode %llu:%u missing, but contents found: reconstruct?",
+		     inum, snapshot))
+		return  reconstruct_inode(trans, btree, snapshot, inum) ?:
+			bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc) ?:
+			bch_err_throw(trans->c, transaction_restart_commit);
+fsck_err:
+	return ret;
+}
+
+static int maybe_reconstruct_inum(struct btree_trans *trans,
+				  u64 inum, u32 snapshot)
+{
+	return  maybe_reconstruct_inum_btree(trans, inum, snapshot, BTREE_ID_extents) ?:
+		maybe_reconstruct_inum_btree(trans, inum, snapshot, BTREE_ID_dirents);
+}
+
 static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_walker *w)
 {
 	struct bch_fs *c = trans->c;
@@ -2368,6 +2405,13 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 		if (ret)
 			goto err;
 
+		if (!target->inodes.nr) {
+			ret = maybe_reconstruct_inum(trans, le64_to_cpu(d.v->d_inum),
+						     d.k->p.snapshot);
+			if (ret)
+				return ret;
+		}
+
 		if (fsck_err_on(!target->inodes.nr,
 				trans, dirent_to_missing_inode,
 				"dirent points to missing inode:\n%s",
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 3ecac2524118..02605976a114 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -291,6 +291,7 @@ enum bch_fsck_flags {
 	x(inode_points_to_missing_dirent,			249,	FSCK_AUTOFIX)	\
 	x(inode_points_to_wrong_dirent,				250,	FSCK_AUTOFIX)	\
 	x(inode_bi_parent_nonzero,				251,	0)		\
+	x(missing_inode_with_contents,				321,	FSCK_AUTOFIX)	\
 	x(dirent_to_missing_parent_subvol,			252,	0)		\
 	x(dirent_not_visible_in_parent_subvol,			253,	0)		\
 	x(subvol_fs_path_parent_wrong,				254,	0)		\
@@ -332,7 +333,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							321,	0)
+	x(MAX,							322,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.50.0

