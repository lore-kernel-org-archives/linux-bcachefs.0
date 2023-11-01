Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2FFC4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed,  1 Nov 2023 19:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbjKATDE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjKATDE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 15:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C35C1
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 12:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698865331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/doic4YH8bEbkS2I0XgsYAF10LPRlZYBBAokNmM5FXE=;
        b=bN7SeNHFQZdaXiiQHBiA/hUORyHDyMIXiKykwtHEBB66PDsvzjodWJnf8u1gUk85PRoybM
        W8L+ifFBYQRFkgRzZy5N46CiCOPsBU6RBVq3p+7aGWKbREF4Rg8NyzjwCE313w3jDbt/kl
        /GVKNYi5jyzAs1xlz3HJzvuoM0NPH+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-prWLDGdNN3edAbRQdxUbfw-1; Wed, 01 Nov 2023 15:02:09 -0400
X-MC-Unique: prWLDGdNN3edAbRQdxUbfw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2236A101A52D
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:09 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07B7140C6EBC
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:08 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/2] bcachefs: serialize on cached key in early bucket allocator
Date:   Wed,  1 Nov 2023 15:02:44 -0400
Message-ID: <20231101190245.478567-2-bfoster@redhat.com>
In-Reply-To: <20231101190245.478567-1-bfoster@redhat.com>
References: <20231101190245.478567-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs had a transient bug where freespace_initialized was not
properly being set, which lead to unexpected use of the early bucket
allocator at runtime. This issue has been fixed, but the existence
of it uncovered a coherency issue in the early bucket allocation
code that is somewhat related to how uncached iterators deal with
the key cache.

The problem itself manifests as occasional failure of generic/113
due to corruption, often seen as a duplicate backpointer or multiple
data types per-bucket error. The immediate cause of the error is a
racing bucket allocation along the lines of the following sequence:

- Task 1 selects key A in bch2_bucket_alloc_early() and schedules.
- Task 2 selects the same key A, but proceeds to complete the
  allocation and associated I/O, after which it releases the
  open_bucket.
- Task 1 resumes with key A, but does not recognize the bucket is
  now allocated because the open_bucket has been removed
  from the hash when it was released in the previous step.

This generally shouldn't happen because the allocating task updates
the alloc btree key before releasing the bucket. This is not
sufficient in this particular instance, however, because an uncached
iterator for a cached btree doesn't actually lock the key cache slot
when no key exists for a given slot in the cache. Thus the fact that
the allocation side updates the cached key means that multiple
uncached iters can stumble across the same alloc key and duplicate
the bucket allocation as described above.

This is something that probably needs a longer term fix in the
iterator code. As a short term fix, close the race through explicit
use of a cached iterator for likely allocation candidates. We don't
want to scan the btree with a cached iterator because that would
unnecessarily pollute the cache. This mitigates cache pollution by
primarily scanning the tree with an uncached iterator, but closes
the race by creating a key cache entry for any prospective slot
prior to the bucket allocation attempt (also similar to how
_alloc_freelist() works via try_alloc_bucket()). This survives many
iterations of generic/113 on a kernel hacked to always use the early
bucket allocator.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/alloc_foreground.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 3bc4abd3d7d5..75ecfc3472ce 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -399,12 +399,22 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 			struct bucket_alloc_state *s,
 			struct closure *cl)
 {
-	struct btree_iter iter;
-	struct bkey_s_c k;
+	struct btree_iter iter, citer;
+	struct bkey_s_c k, ck;
 	struct open_bucket *ob = NULL;
 	u64 alloc_start = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
 	u64 alloc_cursor = max(alloc_start, READ_ONCE(ca->alloc_cursor));
 	int ret;
+
+	/*
+	 * Scan with an uncached iterator to avoid polluting the key cache. An
+	 * uncached iter will return a cached key if one exists, but if not
+	 * there is no other underlying protection for the associated key cache
+	 * slot. To avoid racing bucket allocations, look up the cached key slot
+	 * of any likely allocation candidate before attempting to proceed with
+	 * the allocation. This provides proper exclusion on the associated
+	 * bucket.
+	 */
 again:
 	for_each_btree_key_norestart(trans, iter, BTREE_ID_alloc, POS(ca->dev_idx, alloc_cursor),
 			   BTREE_ITER_SLOTS, k, ret) {
@@ -419,13 +429,25 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 			continue;
 
 		a = bch2_alloc_to_v4(k, &a_convert);
-
 		if (a->data_type != BCH_DATA_free)
 			continue;
 
+		/* now check the cached key to serialize concurrent allocs of the bucket */
+		ck = bch2_bkey_get_iter(trans, &citer, BTREE_ID_alloc, k.k->p, BTREE_ITER_CACHED);
+		ret = bkey_err(ck);
+		if (ret)
+			break;
+
+		a = bch2_alloc_to_v4(ck, &a_convert);
+		if (a->data_type != BCH_DATA_free)
+			goto next;
+
 		s->buckets_seen++;
 
 		ob = __try_alloc_bucket(trans->c, ca, k.k->p.offset, watermark, a, s, cl);
+next:
+		citer.path->preserve = false;
+		bch2_trans_iter_exit(trans, &citer);
 		if (ob)
 			break;
 	}
-- 
2.41.0

