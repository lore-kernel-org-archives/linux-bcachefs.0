Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0452154C04
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912089; cv=none; b=KEgKe+Z698dkyy9/S41c5m61KGo8AxNzj8kxf4Jka91ue1FNhLrIhOkjIikb9mzk180aCAzjYNv7Y0qzB0TaQn9UimQIjvH31Cd0OUK4/dyLCzK37Rri+Q0T2QSObfR4JcYNm50KEQjsQ0cpJl7v84e+SuZHklQQkAw5ewR4Bms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912089; c=relaxed/simple;
	bh=M+YDCE8RwFNk9tZCW8xI+sLu9bf4duLz+xYU0iUV12c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaoqFw9Nugim5TgGJFIxsLuXPgbJlhB3lb/zuYp68NpUfluoYlnQvzGRqeyJEo9xHJiRWESjpaY8V03O4gMn8ftfkaxq2TmE94JpEEg5KJlpkGW0EDok7C462iP8BQebj+l73K35fXZf4/tTI1UOmg2oyceoF5KE79eDq7MqdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+997f0573004dcb964555@syzkaller.appspotmail.com
Subject: [PATCH 23/34] bcachefs: Guard against backpointers to unknown btrees
Date: Fri, 29 Nov 2024 15:27:22 -0500
Message-ID: <20241129202736.2713679-24-kent.overstreet@linux.dev>
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

Reported-by: syzbot+997f0573004dcb964555@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c     | 7 +++++--
 fs/bcachefs/sb-errors_format.h | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index ff08afd667a0..702bf62d7fa7 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -249,9 +249,12 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 					 struct btree_iter *iter,
 					 unsigned iter_flags)
 {
-	if (likely(!bp.v->level)) {
-		struct bch_fs *c = trans->c;
+	struct bch_fs *c = trans->c;
 
+	if (unlikely(bp.v->btree_id >= btree_id_nr_alive(c)))
+		return bkey_s_c_null;
+
+	if (likely(!bp.v->level)) {
 		bch2_trans_node_iter_init(trans, iter,
 					  bp.v->btree_id,
 					  bp.v->pos,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 917ef6aa4a23..e73d1c60198e 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -67,7 +67,7 @@ enum bch_fsck_flags {
 	x(btree_node_bkey_past_bset_end,			 54,	0)		\
 	x(btree_node_bkey_bad_format,				 55,	0)		\
 	x(btree_node_bad_bkey,					 56,	0)		\
-	x(btree_node_bkey_out_of_order,				 57,	0)		\
+	x(btree_node_bkey_out_of_order,				 57,	FSCK_AUTOFIX)	\
 	x(btree_root_bkey_invalid,				 58,	FSCK_AUTOFIX)	\
 	x(btree_root_read_error,				 59,	FSCK_AUTOFIX)	\
 	x(btree_root_bad_min_key,				 60,	0)		\
-- 
2.45.2

