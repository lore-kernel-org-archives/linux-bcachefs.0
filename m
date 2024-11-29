Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B728C1A3AB1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912081; cv=none; b=jiTsoJDLacI3NXuQyRDIrCKlz9zb75rdRHbPTSmBsHLFqMTWDGLRSGmKcO0hH0/DyDlqiY7G6k+QjowlSo/dmasZJMg+PfD8PQ8x9520uRkbfGHdYyVJ6DJulZUMVRq1uTlv8JO35o1GprfJhWPpJmsXF5VBZyVc0JHbzFGKPgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912081; c=relaxed/simple;
	bh=mtGmNGqMjyA576bvbEEPztS4fDHiCElqJCLEFkJNcWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvMH5uwyAoiPLQJp2XE6sSibHA5/9oeNsFuvYIolNod+fecZ57/tcRiLcyxO68S3yrpI4HG/bBrSQCBXIsqIeJhzodMx9LvclFRxbLEAGSKmWaiXcwTARUH/eXnMaQQN5DHOyMwTX0KVyLsn58dIr1zE7ihJLessV18tSZdJFhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com
Subject: [PATCH 16/34] bcachefs: Ignore empty btree root journal entries
Date: Fri, 29 Nov 2024 15:27:15 -0500
Message-ID: <20241129202736.2713679-17-kent.overstreet@linux.dev>
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

There's no reason to treat them as errors: just ignore them, and go with
a previous btree root if we had one.

Reported-by: syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 547c78a323f7..727e894762f5 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -442,7 +442,9 @@ static int journal_replay_entry_early(struct bch_fs *c,
 
 	switch (entry->type) {
 	case BCH_JSET_ENTRY_btree_root: {
-		struct btree_root *r;
+
+		if (unlikely(!entry->u64s))
+			return 0;
 
 		if (fsck_err_on(entry->btree_id >= BTREE_ID_NR_MAX,
 				c, invalid_btree_id,
@@ -456,15 +458,11 @@ static int journal_replay_entry_early(struct bch_fs *c,
 				return ret;
 		}
 
-		r = bch2_btree_id_root(c, entry->btree_id);
+		struct btree_root *r = bch2_btree_id_root(c, entry->btree_id);
 
-		if (entry->u64s) {
-			r->level = entry->level;
-			bkey_copy(&r->key, (struct bkey_i *) entry->start);
-			r->error = 0;
-		} else {
-			r->error = -BCH_ERR_btree_node_read_error;
-		}
+		r->level = entry->level;
+		bkey_copy(&r->key, (struct bkey_i *) entry->start);
+		r->error = 0;
 		r->alive = true;
 		break;
 	}
-- 
2.45.2

