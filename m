Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B996CEDEC5A
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Sep 2023 14:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239249AbjIMOQI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 10:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241204AbjIMOQH (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 10:16:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 660D19E
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 07:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694614458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0D0+WkmJC86scsKVjmt/ONzojEA2KMByifrWT+pZy5M=;
        b=WrXIBICyTtz7wh2TFj2dNgZwSi4gfN/pkLzSQQjlT5aI3BVr8ttG19DVe5Ru+65vCaGO8l
        bK71iRZPyPhYN8h91lWENZjunTCTM2pq3DLETffz8wh1Nfwe8HrHvpxU/MoKnR6MJ2HyBp
        /RIhlXTpocupMVtJMRPulDzA/jYbsIE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-yL2Y_dULMUSH2JtfG3DQfA-1; Wed, 13 Sep 2023 10:14:17 -0400
X-MC-Unique: yL2Y_dULMUSH2JtfG3DQfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B708C88B7A6
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:14:16 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9980F40C2009
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 14:14:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: add module description to fix modpost warning
Date:   Wed, 13 Sep 2023 10:14:30 -0400
Message-ID: <20230913141430.179294-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

modpost produces the following warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in fs/bcachefs/bcachefs.o

Add a module description for bcachefs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Another one for the warn pile..

I'm not really sure if we want anything more descriptive here, but this
addresses the warning.

Brian

 fs/bcachefs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index a00dc4a4a2c9..94e296397e32 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -69,6 +69,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
+MODULE_DESCRIPTION("bcachefs filesystem");
 
 #define KTYPE(type)							\
 static const struct attribute_group type ## _group = {			\
-- 
2.41.0

