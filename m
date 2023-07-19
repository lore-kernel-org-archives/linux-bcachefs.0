Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BF7C001DE
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjGSMvD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjGSMvB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9504F7
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sTS8ElWYI2fGmrRa7cag/OgsfUgtNhAwtHq6Plh7BDQ=;
        b=XOtlpX2kALFZsIO+xrOsfhxxxuvGOcMDppy56tOcHT2JMClL1UkA0hIrGc0d9g/i/6flc0
        gKB75nLKWi+zk8lZlwQMCQvGPJDe1I4Xf6Zlpf6MTLUfzB4xtwXlHWKjfhC8ukB/bRCmqr
        TdoRwPmAJ9GKgXEVYfci5ii2tg9kGEo=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-4Q9UQSd3P5OpwjYyuADhXg-1; Wed, 19 Jul 2023 08:50:11 -0400
X-MC-Unique: 4Q9UQSd3P5OpwjYyuADhXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA78D29ABA11
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1053200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 5/5] bcachefs: use prejournaled key updates for write buffer flushes
Date:   Wed, 19 Jul 2023 08:53:06 -0400
Message-Id: <20230719125306.109342-6-bfoster@redhat.com>
In-Reply-To: <20230719125306.109342-1-bfoster@redhat.com>
References: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The write buffer mechanism journals keys twice in certain
situations. A key is always journaled on write buffer insertion, and
is potentially journaled again if a write buffer flush falls into
either of the slow btree insert paths. This has shown to cause
journal recovery ordering problems in the event of an untimely
crash.

For example, consider if a key is inserted into index 0 of a write
buffer, the active write buffer switches to index 1, the key is
deleted in index 1, and then index 0 is flushed. If the original key
is rejournaled in the btree update from the index 0 flush, the (now
deleted) key is journaled in a seq buffer ahead of the latest
version of key (which was journaled when the key was deleted in
index 1). If the fs crashes while this is still observable in the
log, recovery sees the key from the btree update after the delete
key from the write buffer insert, which is the incorrect order. This
problem is occasionally reproduced by generic/388 and generally
manifests as one or more backpointer entry inconsistencies.

To avoid this problem, never rejournal write buffered key updates to
the associated btree. Instead, use prejournaled key updates to pass
the journal seq of the write buffer insert down to the btree insert,
which updates the btree leaf pin to reflect the seq of the key.

Note that tracking the seq is required instead of just using
NOJOURNAL here because otherwise we lose protection of the write
buffer pin when the buffer is flushed, which means the key can fall
off the tail of the on-disk journal before the btree leaf is flushed
and lead to similar recovery inconsistencies.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/btree_write_buffer.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 6c30a72e6eee..5f96db539fd7 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -75,7 +75,7 @@ static int bch2_btree_write_buffer_flush_one(struct btree_trans *trans,
 	}
 	return 0;
 trans_commit:
-	return  bch2_trans_update(trans, iter, &wb->k, 0) ?:
+	return  bch2_trans_update_seq(trans, wb->journal_seq, iter, &wb->k, 0) ?:
 		bch2_trans_commit(trans, NULL, NULL,
 				  commit_flags|
 				  BTREE_INSERT_NOCHECK_RW|
@@ -103,6 +103,32 @@ static union btree_write_buffer_state btree_write_buffer_switch(struct btree_wri
 	return old;
 }
 
+/*
+ * Update a btree with a write buffered key using the journal seq of the
+ * original write buffer insert.
+ *
+ * It is not safe to rejournal the key once it has been inserted into the write
+ * buffer because that may break recovery ordering. For example, the key may
+ * have already been modified in the active write buffer in a seq that comes
+ * before the current transaction. If we were to journal this key again and
+ * crash, recovery would process updates in the wrong order.
+ */
+static int
+btree_write_buffered_insert(struct btree_trans *trans,
+			  struct btree_write_buffered_key *wb)
+{
+	struct btree_iter iter;
+	int ret;
+
+	bch2_trans_iter_init(trans, &iter, wb->btree, bkey_start_pos(&wb->k.k),
+			     BTREE_ITER_CACHED|BTREE_ITER_INTENT);
+
+	ret   = bch2_btree_iter_traverse(&iter) ?:
+		bch2_trans_update_seq(trans, wb->journal_seq, &iter, &wb->k, 0);
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
 int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_flags,
 				    bool locked)
 {
@@ -238,7 +264,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 				commit_flags|
 				BTREE_INSERT_NOFAIL|
 				BTREE_INSERT_JOURNAL_RECLAIM,
-				__bch2_btree_insert(trans, i->btree, &i->k, 0));
+				btree_write_buffered_insert(trans, i));
 		if (bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret)))
 			break;
 	}
-- 
2.40.1

