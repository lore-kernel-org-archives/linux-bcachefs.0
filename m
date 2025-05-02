Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC19E1F5851
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216019; cv=none; b=i8MopdcvABYTTGM/9cyh+u+esG/y89xuTFsg1LW9ltPyCcd3J0X0PeoGHmCIFxUHi6PU7ex/7o+IsElXhL7N5G0LY+uaW1my3qway3POLVse23HI2xYWyd8w2BqSwQP+pnldtdMewLmnTa9x4P5HamzAMXFJkn0k55u7Dq7BOJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216019; c=relaxed/simple;
	bh=qrcHTKc3T2CBYpInX5zoEg0eS8fpTDC/0Cr1IpF3WzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtgcPoVG4jHSdOeSL8ufwxQxx1N423RmBl366soOe727Vc629DHK7XNsfPv6+88gaUrnVk9r598HHsDDQzJP5MFNhiTXR3oRLk2bCJKIJc259LvVNk/LXsigwblXCx2UbPUd6wcDWMHkMqKPF69uJCIAOHBzFsqQIjZ5JKe4fwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HzFdNXNz; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HzFdNXNz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qIsio+xzgKh9uKa+u77mHFbVQuuvfgvskJa7iDsD9C4=;
	b=HzFdNXNzQWMDIpNvh7RLmhMhb0HQx4oyNbR017/a4XvFPtD3GNHfM5Ls9YeXJqww25ig9v
	ZjT7UDUmrqBmRAb+36Eryuo4NUD5VJEHSWrrs7zCZSGQmfj8yDSTE4Uy0V/lU6ZRz68nkh
	aWdCxkJbzhwgUA2ynCNEsHVEqyqy3mY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/8] bcachefs: BCH_SNAPSHOT_DELETED -> BCH_SNAPSHOT_WILL_DELETE
Date: Fri,  2 May 2025 15:59:58 -0400
Message-ID: <20250502200002.1309862-7-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're going to be speeding up snapshot deletion, by only having it
process the extents/dirents/xattrs btrees if an inode of a given
snapshot ID was present.

This raises the possibility of 'bkey_in_missing_snapshot' errors popping
up, if we ever accidentally don't do the corresponding inode update, or
if the new algorithm has bugs.

So we'll want to be able to differentiate more definitively between
'snapshot went missing' (and perhaps needs to be reconstructed), and
'key in snapshot that was deleted'.

So instead of deleting snapshot IDs, we'll be adding a new deleted flag
and leaving them permanently.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/snapshot.c        | 12 ++++++------
 fs/bcachefs/snapshot_format.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 219cba038778..7349f7f33a4f 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -213,7 +213,7 @@ void bch2_snapshot_to_text(struct printbuf *out, struct bch_fs *c,
 
 	prt_printf(out, "is_subvol %llu deleted %llu parent %10u children %10u %10u subvol %u tree %u",
 	       BCH_SNAPSHOT_SUBVOL(s.v),
-	       BCH_SNAPSHOT_DELETED(s.v),
+	       BCH_SNAPSHOT_WILL_DELETE(s.v),
 	       le32_to_cpu(s.v->parent),
 	       le32_to_cpu(s.v->children[0]),
 	       le32_to_cpu(s.v->children[1]),
@@ -339,7 +339,7 @@ static int __bch2_mark_snapshot(struct btree_trans *trans,
 		       parent - id - 1 < IS_ANCESTOR_BITMAP)
 			__set_bit(parent - id - 1, t->is_ancestor);
 
-		if (BCH_SNAPSHOT_DELETED(s.v)) {
+		if (BCH_SNAPSHOT_WILL_DELETE(s.v)) {
 			set_bit(BCH_FS_need_delete_dead_snapshots, &c->flags);
 			if (c->curr_recovery_pass > BCH_RECOVERY_PASS_delete_dead_snapshots)
 				bch2_delete_dead_snapshots_async(c);
@@ -748,7 +748,7 @@ static int check_snapshot(struct btree_trans *trans,
 	}
 
 	bool should_have_subvol = BCH_SNAPSHOT_SUBVOL(&s) &&
-		!BCH_SNAPSHOT_DELETED(&s);
+		!BCH_SNAPSHOT_WILL_DELETE(&s);
 
 	if (should_have_subvol) {
 		id = le32_to_cpu(s.subvol);
@@ -1062,10 +1062,10 @@ int bch2_snapshot_node_set_deleted(struct btree_trans *trans, u32 id)
 	}
 
 	/* already deleted? */
-	if (BCH_SNAPSHOT_DELETED(&s->v))
+	if (BCH_SNAPSHOT_WILL_DELETE(&s->v))
 		goto err;
 
-	SET_BCH_SNAPSHOT_DELETED(&s->v, true);
+	SET_BCH_SNAPSHOT_WILL_DELETE(&s->v, true);
 	SET_BCH_SNAPSHOT_SUBVOL(&s->v, false);
 	s->v.subvol = 0;
 err:
@@ -1770,7 +1770,7 @@ static int bch2_check_snapshot_needs_deletion(struct btree_trans *trans, struct
 		return 0;
 
 	struct bkey_s_c_snapshot snap = bkey_s_c_to_snapshot(k);
-	if (BCH_SNAPSHOT_DELETED(snap.v) ||
+	if (BCH_SNAPSHOT_WILL_DELETE(snap.v) ||
 	    interior_snapshot_needs_delete(snap))
 		set_bit(BCH_FS_need_delete_dead_snapshots, &trans->c->flags);
 
diff --git a/fs/bcachefs/snapshot_format.h b/fs/bcachefs/snapshot_format.h
index aabcd3a74cd9..685a9fe209ab 100644
--- a/fs/bcachefs/snapshot_format.h
+++ b/fs/bcachefs/snapshot_format.h
@@ -15,7 +15,7 @@ struct bch_snapshot {
 	bch_le128		btime;
 };
 
-LE32_BITMASK(BCH_SNAPSHOT_DELETED,	struct bch_snapshot, flags,  0,  1)
+LE32_BITMASK(BCH_SNAPSHOT_WILL_DELETE,	struct bch_snapshot, flags,  0,  1)
 
 /* True if a subvolume points to this snapshot node: */
 LE32_BITMASK(BCH_SNAPSHOT_SUBVOL,	struct bch_snapshot, flags,  1,  2)
-- 
2.49.0

