Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37E8C0015E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjGSMvD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjGSMvB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDFA10B
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+yFi7Ry5W4v5aEwmQZMx9noWtFKANdNoYpv1CFs1go=;
        b=TSx+vnsYQyah4izSTaLSJhc032egzMB9JCOwPa9ZzBaTMzjVOMXx0LKVRejGpXWRn5/Eiz
        kFlt9RdCyXU3PIXtAZGBTCXAV7tkXyS3/7RTI0jGsixjfhl4fJ1OA14Nr2rRO85amyEMMF
        rat62maThTOpQDibhTcONrb5VJ1qmXA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-KjgbQ79TPq-_R6ROtt3LJg-1; Wed, 19 Jul 2023 08:50:11 -0400
X-MC-Unique: KjgbQ79TPq-_R6ROtt3LJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 938B2185A7A5
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B126200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 4/5] bcachefs: support btree updates of prejournaled keys
Date:   Wed, 19 Jul 2023 08:53:05 -0400
Message-Id: <20230719125306.109342-5-bfoster@redhat.com>
In-Reply-To: <20230719125306.109342-1-bfoster@redhat.com>
References: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Introduce support for prejournaled key updates. This allows a
transaction to commit an update for a key that already exists (and
is pinned) in the journal. This is required for btree write buffer
updates as the current scheme of journaling both on write buffer
insertion and write buffer (slow path) flush is unsafe in certain
crash recovery scenarios.

Create a small trans update wrapper to pass along the seq where the
key resides into the btree_insert_entry. From there, trans commit
passes the seq into the btree insert path where it is used to manage
the journal pin for the associated btree leaf.

Note that this patch only introduces the underlying mechanism and
otherwise includes no functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/bkey_methods.h      |  2 ++
 fs/bcachefs/btree_types.h       |  1 +
 fs/bcachefs/btree_update.h      |  2 ++
 fs/bcachefs/btree_update_leaf.c | 34 ++++++++++++++++++++++++++++++---
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bkey_methods.h b/fs/bcachefs/bkey_methods.h
index 0f3dc156adf6..f4e60d2e6677 100644
--- a/fs/bcachefs/bkey_methods.h
+++ b/fs/bcachefs/bkey_methods.h
@@ -97,6 +97,7 @@ static inline int bch2_mark_key(struct btree_trans *trans,
 enum btree_update_flags {
 	__BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE = __BTREE_ITER_FLAGS_END,
 	__BTREE_UPDATE_NOJOURNAL,
+	__BTREE_UPDATE_PREJOURNAL,
 	__BTREE_UPDATE_KEY_CACHE_RECLAIM,
 
 	__BTREE_TRIGGER_NORUN,		/* Don't run triggers at all */
@@ -111,6 +112,7 @@ enum btree_update_flags {
 
 #define BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE (1U << __BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE)
 #define BTREE_UPDATE_NOJOURNAL		(1U << __BTREE_UPDATE_NOJOURNAL)
+#define BTREE_UPDATE_PREJOURNAL		(1U << __BTREE_UPDATE_PREJOURNAL)
 #define BTREE_UPDATE_KEY_CACHE_RECLAIM	(1U << __BTREE_UPDATE_KEY_CACHE_RECLAIM)
 
 #define BTREE_TRIGGER_NORUN		(1U << __BTREE_TRIGGER_NORUN)
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 4efc69492612..d953601608d5 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -390,6 +390,7 @@ struct btree_insert_entry {
 	u8			old_btree_u64s;
 	struct bkey_i		*k;
 	struct btree_path	*path;
+	u64			seq;
 	/* key being overwritten: */
 	struct bkey		old_k;
 	const struct bch_val	*old_v;
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index f794c9d108b8..256da97f721c 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -111,6 +111,8 @@ int bch2_bkey_get_empty_slot(struct btree_trans *, struct btree_iter *,
 
 int __must_check bch2_trans_update(struct btree_trans *, struct btree_iter *,
 				   struct bkey_i *, enum btree_update_flags);
+int __must_check bch2_trans_update_seq(struct btree_trans *, u64, struct btree_iter *,
+				       struct bkey_i *, enum btree_update_flags);
 int __must_check bch2_trans_update_buffered(struct btree_trans *,
 					    enum btree_id, struct bkey_i *);
 
diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index 319286294d6a..609780f0ce8e 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -747,9 +747,14 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 	trans_for_each_update(trans, i) {
 		i->k->k.needs_whiteout = false;
 
-		if (!i->cached)
-			bch2_btree_insert_key_leaf(trans, i->path, i->k, trans->journal_res.seq);
-		else if (!i->key_cache_already_flushed)
+		if (!i->cached) {
+			u64 seq = trans->journal_res.seq;
+
+			if (i->flags & BTREE_UPDATE_PREJOURNAL)
+				seq = i->seq;
+
+			bch2_btree_insert_key_leaf(trans, i->path, i->k, seq);
+		} else if (!i->key_cache_already_flushed)
 			bch2_btree_insert_key_cached(trans, flags, i);
 		else {
 			bch2_btree_key_cache_drop(trans, i->path);
@@ -1571,12 +1576,21 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 {
 	struct bch_fs *c = trans->c;
 	struct btree_insert_entry *i, n;
+	u64 seq = 0;
 	int cmp;
 
 	EBUG_ON(!path->should_be_locked);
 	EBUG_ON(trans->nr_updates >= BTREE_ITER_MAX);
 	EBUG_ON(!bpos_eq(k->k.p, path->pos));
 
+	/*
+	 * The transaction journal res hasn't been allocated at this point.
+	 * That occurs at commit time. Reuse the seq field to pass in the seq
+	 * of a prejournaled key.
+	 */
+	if (flags & BTREE_UPDATE_PREJOURNAL)
+		seq = trans->journal_res.seq;
+
 	n = (struct btree_insert_entry) {
 		.flags		= flags,
 		.bkey_type	= __btree_node_type(path->level, path->btree_id),
@@ -1585,6 +1599,7 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 		.cached		= path->cached,
 		.path		= path,
 		.k		= k,
+		.seq		= seq,
 		.ip_allocated	= ip,
 	};
 
@@ -1612,6 +1627,7 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 		i->cached	= n.cached;
 		i->k		= n.k;
 		i->path		= n.path;
+		i->seq		= n.seq;
 		i->ip_allocated	= n.ip_allocated;
 	} else {
 		array_insert_item(trans->updates, trans->nr_updates,
@@ -1709,6 +1725,18 @@ int __must_check bch2_trans_update(struct btree_trans *trans, struct btree_iter
 	return bch2_trans_update_by_path(trans, path, k, flags, _RET_IP_);
 }
 
+/*
+ * Add a transaction update for a key that has already been journaled.
+ */
+int __must_check bch2_trans_update_seq(struct btree_trans *trans, u64 seq,
+				       struct btree_iter *iter, struct bkey_i *k,
+				       enum btree_update_flags flags)
+{
+	trans->journal_res.seq = seq;
+	return bch2_trans_update(trans, iter, k, flags|BTREE_UPDATE_NOJOURNAL|
+						 BTREE_UPDATE_PREJOURNAL);
+}
+
 int __must_check bch2_trans_update_buffered(struct btree_trans *trans,
 					    enum btree_id btree,
 					    struct bkey_i *k)
-- 
2.40.1

