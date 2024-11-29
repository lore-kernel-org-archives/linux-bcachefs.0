Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9F41A0BE1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912095; cv=none; b=Y+04DAM1bmcf22piIDrZiNWEioKIVVz2kcg8GCBmalYQKaeK+ECXcIZJGgWpqEqCeVIrHgQXMfktFRqDrUhi2VP4LZLsiFVL0rzI+ZKQby7T6HaY4KwRtyu8ojT1/av41L99oHqJRtrQxwZVDDq51wJmHJIEgGFGWsz1lVsHU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912095; c=relaxed/simple;
	bh=7NOEcjxhjVHr7Oelh8AoIjYs44ND+ZFyFOzHuOepDlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzcjLZyHbTeMFhZJfqOLPClOS0iuIqVb+4yd4fkmuaukCqIYJAhGi249nc/OYZXfH98+If4GYwCSitLwt8MrF3deF+1+eqbuy/B7ZxhvqHlqPZqEqbtwn+/T2R0uRQGPFiQ9mu2zh65s7V5b5jOaSqjq6rZ8I4/8WH86XVZOgOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+d119b445ec739e7f3068@syzkaller.appspotmail.com
Subject: [PATCH 30/34] bcachefs: Check for inode journal seq in the future
Date: Fri, 29 Nov 2024 15:27:29 -0500
Message-ID: <20241129202736.2713679-31-kent.overstreet@linux.dev>
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

More check and repair code: this fixes a warning in
bch2_journal_flush_seq_async()

Reported-by: syzbot+d119b445ec739e7f3068@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io.c            | 35 +++++++++++++++++++++++++++++++---
 fs/bcachefs/fsck.c             | 13 ++++++++++++-
 fs/bcachefs/sb-errors_format.h |  3 ++-
 3 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index c6fdfec51082..33d0e7080bf6 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -167,6 +167,34 @@ void __bch2_i_sectors_acct(struct bch_fs *c, struct bch_inode_info *inode,
 
 /* fsync: */
 
+static int bch2_get_inode_journal_seq_trans(struct btree_trans *trans, subvol_inum inum,
+					    u64 *seq)
+{
+	struct printbuf buf = PRINTBUF;
+	struct bch_inode_unpacked u;
+	struct btree_iter iter;
+	int ret = bch2_inode_peek(trans, &iter, &u, inum, 0);
+	if (ret)
+		return ret;
+
+	u64 cur_seq = journal_cur_seq(&trans->c->journal);
+	*seq = min(cur_seq, u.bi_journal_seq);
+
+	if (fsck_err_on(u.bi_journal_seq > cur_seq,
+			trans, inode_journal_seq_in_future,
+			"inode journal seq in future (currently at %llu)\n%s",
+			cur_seq,
+			(bch2_inode_unpacked_to_text(&buf, &u),
+			buf.buf))) {
+		u.bi_journal_seq = cur_seq;
+		ret = bch2_inode_write(trans, &iter, &u);
+	}
+fsck_err:
+	bch2_trans_iter_exit(trans, &iter);
+	printbuf_exit(&buf);
+	return ret;
+}
+
 /*
  * inode->ei_inode.bi_journal_seq won't be up to date since it's set in an
  * insert trigger: look up the btree inode instead
@@ -180,9 +208,10 @@ static int bch2_flush_inode(struct bch_fs *c,
 	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_fsync))
 		return -EROFS;
 
-	struct bch_inode_unpacked u;
-	int ret = bch2_inode_find_by_inum(c, inode_inum(inode), &u) ?:
-		  bch2_journal_flush_seq(&c->journal, u.bi_journal_seq, TASK_INTERRUPTIBLE) ?:
+	u64 seq;
+	int ret = bch2_trans_commit_do(c, NULL, NULL, 0,
+			bch2_get_inode_journal_seq_trans(trans, inode_inum(inode), &seq)) ?:
+		  bch2_journal_flush_seq(&c->journal, seq, TASK_INTERRUPTIBLE) ?:
 		  bch2_inode_flush_nocow_writes(c, inode);
 	bch2_write_ref_put(c, BCH_WRITE_REF_fsync);
 	return ret;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index e10abd2e6c69..f2174528ee5f 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1392,7 +1392,7 @@ static int check_inode(struct btree_trans *trans,
 
 			if (fsck_err_on(!ret,
 					trans, inode_unlinked_and_not_open,
-				      "inode %llu%u unlinked and not open",
+				      "inode %llu:%u unlinked and not open",
 				      u.bi_inum, u.bi_snapshot)) {
 				ret = bch2_inode_rm_snapshot(trans, u.bi_inum, iter->pos.snapshot);
 				bch_err_msg(c, ret, "in fsck deleting inode");
@@ -1441,6 +1441,17 @@ static int check_inode(struct btree_trans *trans,
 			do_update = true;
 		}
 	}
+
+	if (fsck_err_on(u.bi_journal_seq > journal_cur_seq(&c->journal),
+			trans, inode_journal_seq_in_future,
+			"inode journal seq in future (currently at %llu)\n%s",
+			journal_cur_seq(&c->journal),
+			(printbuf_reset(&buf),
+			 bch2_inode_unpacked_to_text(&buf, &u),
+			buf.buf))) {
+		u.bi_journal_seq = journal_cur_seq(&c->journal);
+		do_update = true;
+	}
 do_update:
 	if (do_update) {
 		ret = __bch2_fsck_write_inode(trans, &u);
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 8e3a6c5da10d..342eda8ab69f 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -233,6 +233,7 @@ enum bch_fsck_flags {
 	x(inode_wrong_nlink,					209,	FSCK_AUTOFIX)	\
 	x(inode_has_child_snapshots_wrong,			287,	0)		\
 	x(inode_unreachable,					210,	FSCK_AUTOFIX)	\
+	x(inode_journal_seq_in_future,				299,	FSCK_AUTOFIX)	\
 	x(deleted_inode_but_clean,				211,	FSCK_AUTOFIX)	\
 	x(deleted_inode_missing,				212,	FSCK_AUTOFIX)	\
 	x(deleted_inode_is_dir,					213,	FSCK_AUTOFIX)	\
@@ -309,7 +310,7 @@ enum bch_fsck_flags {
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
-	x(MAX,							299,	0)
+	x(MAX,							300,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

