Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25292C678D4
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Mar 2023 19:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjCBTuj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjCBTuX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Mar 2023 14:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF09C15C8A
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Mar 2023 11:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677786572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qj4GlE3RzvPRG6FpuE1Yb3oDgA+bP1PmXs4/9WZYPhA=;
        b=bRMwkBtEzu11wMR4Ep90IC4eRK4gN7Lq9mwO+ifsNKqiuVbgDUe07YmmA6wQE0u8hixXpt
        WX9vWpvjIq9XytYALakzX1SRVK6+ba4hUpu3BcYFipOflDdRrdr7yX50vX3vFpDLbsI5nn
        qcPq+atPiLEvAxVjTWPXQ7ePy7i61lU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-z703vusUNbOsW9GcgrR6kA-1; Thu, 02 Mar 2023 14:49:30 -0500
X-MC-Unique: z703vusUNbOsW9GcgrR6kA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDDD53804527;
        Thu,  2 Mar 2023 19:49:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.9.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CFBD1121315;
        Thu,  2 Mar 2023 19:49:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH RFC] bcachefs: don't bump key cache journal seq on nojournal commits
Date:   Thu,  2 Mar 2023 14:51:10 -0500
Message-Id: <20230302195110.217282-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

fstest generic/388 occasionally reproduces corruptions where an
inode has extents beyond i_size. This is a deliberate crash and
recovery test, and the post crash+recovery characteristics are
usually the same: the inode exists on disk in an early (i.e. just
allocated) state based on the journal sequence number associated
with the inode. Subsequent inode updates exist in the journal at
higher sequence numbers, but the inode hadn't been written back
before the associated crash and the post-crash recovery processes a
set of journal sequence numbers that doesn't include updates to the
inode. In fact, the sequence with the most recent inode key update
always happens to be the sequence just before the front of the
journal processed by recovery.

This last bit is a significant hint that the problem relates to an
on-disk journal update of the front of the journal. The root cause
of this problem is basically that the inode is updated (multiple
times) in-core and in the key cache, each time bumping the key cache
sequence number used to control the cache flush. The cache flush
skips one or more times, bumping the associated key cache journal
pin to the key cache seq value. This has a side effect of holding
the inode in memory a bit longer than normal, which helps exacerbate
this problem, but is also unsafe in certain cases where the key
cache seq may have been updated by a transaction commit that didn't
journal the associated key.

For example, consider an inode that has been allocated, updated
several times in the key cache, journaled, but not yet written back.
At this stage, everything should be consistent if the fs happens to
crash because the latest update has been journal. Now consider a key
update via bch2_extent_update_i_size_sectors() that uses the
BTREE_UPDATE_NOJOURNAL flag. While this update may not change inode
state, it can have the side effect of bumping ck->seq in
bch2_btree_insert_key_cached(). In turn, if a subsequent key cache
flush skips due to seq not matching the former, the ck->journal pin
is updated to ck->seq even though the most recent key update was not
journaled. If this pin happens to reside at the front (tail) of the
journal, this means a subsequent journal write can update last_seq
to a value beyond that which includes the most recent update to the
inode. If this occurs and the fs happens to crash before the inode
happens to flush, recovery will see the latest last_seq, fail to
recover the inode and leave the inode in the inconsistent state
described above.

To avoid this problem, skip the key cache seq update on NOJOURNAL
commits. Pass the insert entry directly to
bch2_btree_insert_key_cached() to make the associated flag available
and be consistent with btree_insert_key_leaf().

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi Kent,

As noted on IRC, this patch is RFC because it's definitely broken. I
reproduce a generic/036 unmount hang related to pin flushing. I tweaked
the logic to also skip the bch2_journal_pin_add() call, which seems to
fix generic/036 but then results in a generic/127 panic where
atomic_long_read(&bc->nr_keys) == 1 on exit. So this all kind of smells
like I'm breaking the journal pin/key cache flushing logic here and so
need to grok this a bit better to see what this is getting wrong.

FWIW, I also ran a quick test to just drop the usage of NOJOURNAL from
the inode update in the extent update path. That seems to also address
the generic/388 problem, but I haven't tested that one more broadly.

One other thing is I know we proved the commit that introduced ck->seq
was not the root cause of this problem a week or so ago. I suspect this
still occurs prior to that commit because that one also relocated the
pin update from the commit path to the journal reclaim (i.e. cache
flush) path. IOW, the problem still occurs, it just depends on the
NOJOURNAL commit itself to bump the pin and a journal write to race with
a cache flush.

Anyways, I still want to play around with this some more but it might
take me some time and I wanted to at least post the problem description
in the meantime. I'm curious if you have any thoughts on the analysis
above and/or the initial attempt to fix..

Brian

 fs/bcachefs/btree_key_cache.c   | 9 +++++----
 fs/bcachefs/btree_key_cache.h   | 2 +-
 fs/bcachefs/btree_update_leaf.c | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 13df0d408634..272e66437ffc 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -770,11 +770,11 @@ int bch2_btree_key_cache_flush(struct btree_trans *trans,
 
 bool bch2_btree_insert_key_cached(struct btree_trans *trans,
 				  unsigned flags,
-				  struct btree_path *path,
-				  struct bkey_i *insert)
+				  struct btree_insert_entry *insert_entry)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_cached *ck = (void *) path->l[0].b;
+	struct bkey_cached *ck = (void *) insert_entry->path->l[0].b;
+	struct bkey_i *insert = insert_entry->k;
 	bool kick_reclaim = false;
 
 	BUG_ON(insert->u64s > ck->u64s);
@@ -804,7 +804,8 @@ bool bch2_btree_insert_key_cached(struct btree_trans *trans,
 
 	bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
 			     &ck->journal, bch2_btree_key_cache_journal_flush);
-	ck->seq = trans->journal_res.seq;
+	if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL))
+		ck->seq = trans->journal_res.seq;
 
 	if (kick_reclaim)
 		journal_reclaim_kick(&c->journal);
diff --git a/fs/bcachefs/btree_key_cache.h b/fs/bcachefs/btree_key_cache.h
index c86d5e48f6e3..be3acde2caa0 100644
--- a/fs/bcachefs/btree_key_cache.h
+++ b/fs/bcachefs/btree_key_cache.h
@@ -30,7 +30,7 @@ int bch2_btree_path_traverse_cached(struct btree_trans *, struct btree_path *,
 				    unsigned);
 
 bool bch2_btree_insert_key_cached(struct btree_trans *, unsigned,
-			struct btree_path *, struct bkey_i *);
+			struct btree_insert_entry *);
 int bch2_btree_key_cache_flush(struct btree_trans *,
 			       enum btree_id, struct bpos);
 void bch2_btree_key_cache_drop(struct btree_trans *,
diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index c93c132dd815..456375fed276 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -765,7 +765,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 		if (!i->cached)
 			btree_insert_key_leaf(trans, i);
 		else if (!i->key_cache_already_flushed)
-			bch2_btree_insert_key_cached(trans, flags, i->path, i->k);
+			bch2_btree_insert_key_cached(trans, flags, i);
 		else {
 			bch2_btree_key_cache_drop(trans, i->path);
 			btree_path_set_dirty(i->path, BTREE_ITER_NEED_TRAVERSE);
-- 
2.39.2

