Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D783EE645C
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 13:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjIONlD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 09:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbjIONk6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 09:40:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C358D1FF5
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 06:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694785213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=amWV+ghR/qdj9wU/JRu7Q6Bm9pKbZUhgPB+bQV+Cx1k=;
        b=KKRlS4b3jzg1/FA49fmOdRsLh83NcYZvKdjo9UHiXke74QyLSmXEsNhmKvR6ZqZAC3F/oT
        MAZ7Av25iZ30jgt1DyyTMStRTiVQigyRg9+cYajDbV9AClfCWT+E1nkgqTctLDX1ALKL1s
        fsRCW4NMxgJh1hwkiE5mIHnxhITjsL0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-sKllsTE-OEWUWDEczFBpCQ-1; Fri, 15 Sep 2023 09:40:11 -0400
X-MC-Unique: sKllsTE-OEWUWDEczFBpCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFF29809F91
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 13:40:10 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4FDC1C64A
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 13:40:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] libbcachefs: convert sb features mask to little endian
Date:   Fri, 15 Sep 2023 09:40:25 -0400
Message-ID: <20230915134025.317931-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bch_sb.features is an array of __le64. Convert the native endian format
of the features mask appropriately. This causes a bcachefs format to
produce an unmountable fs when run from a big endian system.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libbcachefs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libbcachefs.c b/libbcachefs.c
index bac772b..44a5fbf 100644
--- a/libbcachefs.c
+++ b/libbcachefs.c
@@ -193,7 +193,7 @@ struct bch_sb *bch2_format(struct bch_opt_strs	fs_opt_strs,
 	sb.sb->nr_devices	= nr_devs;
 
 	if (opts.version == bcachefs_metadata_version_current)
-		sb.sb->features[0] |= BCH_SB_FEATURES_ALL;
+		sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
 
 	uuid_generate(sb.sb->uuid.b);
 
-- 
2.41.0

