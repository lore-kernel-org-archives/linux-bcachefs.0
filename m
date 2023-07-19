Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC94C001E0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjGSMvE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjGSMvC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC2F11C
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5ESInnp+JRJ4k5rBlkPEd/glhymRGAIdHOy68APHQU=;
        b=el8oGouHIaCVW7aeZ+X+m39H99vuVaDFzXCLlB/M8vqN5fEdVaEyVXqKQJke43tuujrdi5
        vsliHQfmCEcMdzEtg35S6S4CbJaIUmS717L89cw1Lq90gRCt/wVXgL4yQ5VP26yOQc+KqM
        Hu/97Rd4j9VsXxZYKzdDyfeELZj9Ymo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-WILptThZPOeXOZj_7Gnwmw-1; Wed, 19 Jul 2023 08:50:10 -0400
X-MC-Unique: WILptThZPOeXOZj_7Gnwmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F4C41C172A7
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56564200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 3/5] bcachefs: fold bch2_trans_update_by_path_trace() into callers
Date:   Wed, 19 Jul 2023 08:53:04 -0400
Message-Id: <20230719125306.109342-4-bfoster@redhat.com>
In-Reply-To: <20230719125306.109342-1-bfoster@redhat.com>
References: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

There is only one other caller so eliminate some boilerplate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/btree_update_leaf.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index 11b992282032..319286294d6a 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -66,7 +66,8 @@ static void verify_update_old_key(struct btree_trans *trans, struct btree_insert
 
 static int __must_check
 bch2_trans_update_by_path(struct btree_trans *, struct btree_path *,
-			  struct bkey_i *, enum btree_update_flags);
+			  struct bkey_i *, enum btree_update_flags,
+			  unsigned long ip);
 
 static inline int btree_insert_entry_cmp(const struct btree_insert_entry *l,
 					 const struct btree_insert_entry *r)
@@ -1489,7 +1490,7 @@ int bch2_trans_update_extent(struct btree_trans *trans,
 
 			ret = bch2_trans_update_by_path(trans, iter.path, update,
 						  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE|
-						  flags);
+						  flags, _RET_IP_);
 			if (ret)
 				goto err;
 			goto out;
@@ -1527,11 +1528,6 @@ int bch2_trans_update_extent(struct btree_trans *trans,
 	return ret;
 }
 
-static int __must_check
-bch2_trans_update_by_path_trace(struct btree_trans *trans, struct btree_path *path,
-				struct bkey_i *k, enum btree_update_flags flags,
-				unsigned long ip);
-
 static noinline int flush_new_cached_update(struct btree_trans *trans,
 					    struct btree_path *path,
 					    struct btree_insert_entry *i,
@@ -1562,16 +1558,16 @@ static noinline int flush_new_cached_update(struct btree_trans *trans,
 	i->flags |= BTREE_TRIGGER_NORUN;
 
 	btree_path_set_should_be_locked(btree_path);
-	ret = bch2_trans_update_by_path_trace(trans, btree_path, i->k, flags, ip);
+	ret = bch2_trans_update_by_path(trans, btree_path, i->k, flags, ip);
 out:
 	bch2_path_put(trans, btree_path, true);
 	return ret;
 }
 
 static int __must_check
-bch2_trans_update_by_path_trace(struct btree_trans *trans, struct btree_path *path,
-				struct bkey_i *k, enum btree_update_flags flags,
-				unsigned long ip)
+bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
+			  struct bkey_i *k, enum btree_update_flags flags,
+			  unsigned long ip)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_insert_entry *i, n;
@@ -1650,13 +1646,6 @@ bch2_trans_update_by_path_trace(struct btree_trans *trans, struct btree_path *pa
 	return 0;
 }
 
-static inline int __must_check
-bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
-			  struct bkey_i *k, enum btree_update_flags flags)
-{
-	return bch2_trans_update_by_path_trace(trans, path, k, flags, _RET_IP_);
-}
-
 int __must_check bch2_trans_update(struct btree_trans *trans, struct btree_iter *iter,
 				   struct bkey_i *k, enum btree_update_flags flags)
 {
@@ -1717,7 +1706,7 @@ int __must_check bch2_trans_update(struct btree_trans *trans, struct btree_iter
 		path = iter->key_cache_path;
 	}
 
-	return bch2_trans_update_by_path(trans, path, k, flags);
+	return bch2_trans_update_by_path(trans, path, k, flags, _RET_IP_);
 }
 
 int __must_check bch2_trans_update_buffered(struct btree_trans *trans,
-- 
2.40.1

