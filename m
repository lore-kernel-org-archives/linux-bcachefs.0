Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6908CC001DC
	for <linux-bcachefs@archiver.kernel.org>; Wed, 19 Jul 2023 12:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjGSMvC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 19 Jul 2023 08:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjGSMvB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 19 Jul 2023 08:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B61E10FE
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 05:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689771011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+x3XJlrhqHd6b09DfvIX9wmwQVagwJnfMpoj++a7xJQ=;
        b=BzuzgnKJ0eFhWHOEJ+GNAobvXBsMSebuq7RO8YAV1G2IjO4UHz856SYccS8vR1kGeEfvuq
        /7J1gv3m8NHABPgUqbL3LT5w95lT92KfXV8GJmsUOgbbRTIET4ejC6JdajVxy784UsjIuX
        wo8cBfUxdhDDhT359zvBMWfDRsIaFDM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-OaPxM4U8NDi1HTdNI97ZUQ-1; Wed, 19 Jul 2023 08:50:10 -0400
X-MC-Unique: OaPxM4U8NDi1HTdNI97ZUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04BBD936D37
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1EB0200AD6E
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jul 2023 12:50:09 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/5] bcachefs: write buffer journaling fixes
Date:   Wed, 19 Jul 2023 08:53:01 -0400
Message-Id: <20230719125306.109342-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

Here are a few patches to try and address the write buffer journaling
issue that occasionally produces backpointer inconsistency errors via
generic/388. The issue is described in more detail in patch 5.

Patches 1-3 are just a few cleanup/prep patches that fell out of
perusing the code. Patch 4 adds the ability to plumb a known seq for a
journaled key into a transaction and down through to the btree update.
Patch 5 updates write buffer key flushing to use the wb key journal seq
for the key in the flush transaction.

This survived ~100 or so iterations of generic/388 in my last test and
the series is also pushed to the CI [1]. Thoughts, reviews, flames
appreciated.

Brian

[1] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster&commit=130f60a69f0c2cce14ac5c0de6257b4a4cae39f0

Brian Foster (5):
  bcachefs: remove duplicate code between backpointer update paths
  bcachefs: remove unnecessary btree_insert_key_leaf() wrapper
  bcachefs: fold bch2_trans_update_by_path_trace() into callers
  bcachefs: support btree updates of prejournaled keys
  bcachefs: use prejournaled key updates for write buffer flushes

 fs/bcachefs/backpointers.c       | 18 +--------
 fs/bcachefs/backpointers.h       |  8 ++--
 fs/bcachefs/bkey_methods.h       |  2 +
 fs/bcachefs/btree_types.h        |  1 +
 fs/bcachefs/btree_update.h       |  2 +
 fs/bcachefs/btree_update_leaf.c  | 67 +++++++++++++++++++-------------
 fs/bcachefs/btree_write_buffer.c | 30 +++++++++++++-
 7 files changed, 77 insertions(+), 51 deletions(-)

-- 
2.40.1

