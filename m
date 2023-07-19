Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E203C04A6A
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjGSMvD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjGSMvB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160901711
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9U6eavRmzwhBUeQHUbpBZ7HVbiJ1XM4UMe3BWdAY80=;
        b=OGeb3Wy8jVy6UvioWC41EsNkPATzzRUWCdDa2ngUa6FPEuBlHFbRkUbVx7f8WHXDhphpF4
        gH418CN1Csf5yIWt6h1omRGXgcfTazDajjOX5WAZjQRPs2qvXdMfoWrk8mLMIc7XonjFZs
        nmFLY1NxsiRbyg/e+eMW1NaRFiS9XfY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-GC2bU0pXOK660Qn500b7ow-1; Wed, 19 Jul 2023 08:50:10 -0400
X-MC-Unique: GC2bU0pXOK660Qn500b7ow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 275C9891F24
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1080C200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/5] bcachefs: remove duplicate code between backpointer update paths
Date:   Wed, 19 Jul 2023 08:53:02 -0400
Message-Id: <20230719125306.109342-2-bfoster@redhat.com>
In-Reply-To: <20230719125306.109342-1-bfoster@redhat.com>
References: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/backpointers.c | 18 +-----------------
 fs/bcachefs/backpointers.h |  8 ++++----
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 7c1e6546d054..8747c5e19f99 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -134,31 +134,15 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 }
 
 int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *trans,
-				struct bpos bucket,
+				struct bkey_i_backpointer *bp_k,
 				struct bch_backpointer bp,
 				struct bkey_s_c orig_k,
 				bool insert)
 {
-	struct bch_fs *c = trans->c;
-	struct bkey_i_backpointer *bp_k;
 	struct btree_iter bp_iter;
 	struct bkey_s_c k;
 	int ret;
 
-	bp_k = bch2_trans_kmalloc_nomemzero(trans, sizeof(struct bkey_i_backpointer));
-	ret = PTR_ERR_OR_ZERO(bp_k);
-	if (ret)
-		return ret;
-
-	bkey_backpointer_init(&bp_k->k_i);
-	bp_k->k.p = bucket_pos_to_bp(c, bucket, bp.bucket_offset);
-	bp_k->v = bp;
-
-	if (!insert) {
-		bp_k->k.type = KEY_TYPE_deleted;
-		set_bkey_val_u64s(&bp_k->k, 0);
-	}
-
 	k = bch2_bkey_get_iter(trans, &bp_iter, BTREE_ID_backpointers,
 			       bp_k->k.p,
 			       BTREE_ITER_INTENT|
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 87e31aa1975c..547e0617602a 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -54,7 +54,7 @@ static inline struct bpos bucket_pos_to_bp(const struct bch_fs *c,
 	return ret;
 }
 
-int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *, struct bpos,
+int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *, struct bkey_i_backpointer *,
 				struct bch_backpointer, struct bkey_s_c, bool);
 
 static inline int bch2_bucket_backpointer_mod(struct btree_trans *trans,
@@ -67,9 +67,6 @@ static inline int bch2_bucket_backpointer_mod(struct btree_trans *trans,
 	struct bkey_i_backpointer *bp_k;
 	int ret;
 
-	if (unlikely(bch2_backpointers_no_use_write_buffer))
-		return bch2_bucket_backpointer_mod_nowritebuffer(trans, bucket, bp, orig_k, insert);
-
 	bp_k = bch2_trans_kmalloc_nomemzero(trans, sizeof(struct bkey_i_backpointer));
 	ret = PTR_ERR_OR_ZERO(bp_k);
 	if (ret)
@@ -84,6 +81,9 @@ static inline int bch2_bucket_backpointer_mod(struct btree_trans *trans,
 		set_bkey_val_u64s(&bp_k->k, 0);
 	}
 
+	if (unlikely(bch2_backpointers_no_use_write_buffer))
+		return bch2_bucket_backpointer_mod_nowritebuffer(trans, bp_k, bp, orig_k, insert);
+
 	return bch2_trans_update_buffered(trans, BTREE_ID_backpointers, &bp_k->k_i);
 }
 
-- 
2.40.1

