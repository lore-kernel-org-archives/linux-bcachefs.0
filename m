Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E698BEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjGSMvC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjGSMvB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4BA113
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FFTun1k9zvGeZIbrDuj/7VTJlPqxyhaW8xraGAaiHLQ=;
        b=Dtapp/9854BAeG4ZZG/Y28LVLw1sGeUy/lpf3F3eqn+0bMAvIKbXcT9s661b8TTBc8NNkU
        v40fo16HhG8a4ShZmhUsAzIquWvvuz5kVvyNOSDivK49jOJYiGJl3zAXHY2Gp2j3ieZkrS
        Dqwh+ahQZlsCrXelCxoyyPcMX5NmvTw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-Rvwh6rG0Nned22vyyW6iEA-1; Wed, 19 Jul 2023 08:50:10 -0400
X-MC-Unique: Rvwh6rG0Nned22vyyW6iEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A5A0185A793
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32F22200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/5] bcachefs: remove unnecessary btree_insert_key_leaf() wrapper
Date:   Wed, 19 Jul 2023 08:53:03 -0400
Message-Id: <20230719125306.109342-3-bfoster@redhat.com>
In-Reply-To: <20230719125306.109342-1-bfoster@redhat.com>
References: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This is in preparation to support prejournaled keys. We want the
ability to optionally pass a seq stored in the btree update rather
than the seq of the committing transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/btree_update_leaf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index 3638cef211b2..11b992282032 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -290,12 +290,6 @@ inline void bch2_btree_insert_key_leaf(struct btree_trans *trans,
 		bch2_trans_node_reinit_iter(trans, b);
 }
 
-static void btree_insert_key_leaf(struct btree_trans *trans,
-				  struct btree_insert_entry *insert)
-{
-	bch2_btree_insert_key_leaf(trans, insert->path, insert->k, trans->journal_res.seq);
-}
-
 /* Cached btree updates: */
 
 /* Normal update interface: */
@@ -753,7 +747,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 		i->k->k.needs_whiteout = false;
 
 		if (!i->cached)
-			btree_insert_key_leaf(trans, i);
+			bch2_btree_insert_key_leaf(trans, i->path, i->k, trans->journal_res.seq);
 		else if (!i->key_cache_already_flushed)
 			bch2_btree_insert_key_cached(trans, flags, i);
 		else {
-- 
2.40.1

