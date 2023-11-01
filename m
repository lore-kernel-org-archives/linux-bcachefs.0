Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD72CC4167D
	for <linux-bcachefs@archiver.kernel.org>; Wed,  1 Nov 2023 19:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjKATDF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjKATDE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 15:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6E102
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698865332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9nBL5Lx4hW4tl/AdEbokXLLfrj8kWTeWE0yGSNjAVcE=;
        b=YITVlY1XMR2S0m9voYiFMuqxXR/1n17jIQAGeYG7BzaKMArhW82hpjk7iMp6NEv8WrbIcC
        Q8UFdyMzz5hsUYeaZj4g/QptHPW5K6hEwAYX8gm2DHGDGLTu+XqYHsr8DTSB06yhvWOeM5
        TOGROGeVrlV8xhjsyo7PnjsWh/6tj0U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-421-rn59d4UiP9imeXLa7M63Ng-1; Wed, 01 Nov 2023 15:02:09 -0400
X-MC-Unique: rn59d4UiP9imeXLa7M63Ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9D8104E882
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:08 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3CBB40C6EBC
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:08 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/2] bcachefs: early bucket allocator fixes
Date:   Wed,  1 Nov 2023 15:02:43 -0400
Message-ID: <20231101190245.478567-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

Here's a couple isolated fixes to the early bucket allocator. Both of
these address issues that were uncovered due to an unrelated bug that
temporarily caused the early bucket allocator to run indefinitely. Patch
1 addresses a race where multiple tasks can attempt to allocate the same
bucket due to lack of exclusion when the target bucket is not resident
in the key cache. Patch 2 fixes up an issue where the allocation cursor
is never properly updated, which made early bucket allocator performance
far worse than it should have been.

These have been tested in an ad hoc fashion on a kernel hacked up to use
the early bucket allocator as well as on CI via my test branch [1].
Thoughts, reviews, flames appreciated.

Brian

[1] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian Foster (2):
  bcachefs: serialize on cached key in early bucket allocator
  bcachefs: update alloc cursor in early bucket allocator

 fs/bcachefs/alloc_foreground.c | 38 +++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

-- 
2.41.0

