Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CF6C83F01
	for <linux-bcachefs@archiver.kernel.org>; Thu, 31 Aug 2023 11:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345062AbjHaLIt (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245215AbjHaLIt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 31 Aug 2023 07:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0ECE5F
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 04:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693480048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XE491ZqzHq2bME7JKTOCNM0B45skCbNSOywCT0ABGRM=;
        b=Vb3M0DWFx0YZnEh7shlHHqFSklivv7dgUEKERQN08RDaelsKqnN1yPYTkchA54M3qJ3jBT
        /RPPtjZoV/xqkpUcxtH4TjyjsbGKUFDkRpnz6v6QaBmanNZHuYALsEUIBklOb9C8dqSST/
        3qoFFT5iJcP0pNloRJFNXkzpBQZuqb8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-q1BHDU4NOu6i66QgTbm5KQ-1; Thu, 31 Aug 2023 07:07:27 -0400
X-MC-Unique: q1BHDU4NOu6i66QgTbm5KQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3195823D67
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:26 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8E4740C6F4C
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/3] bcachefs: journal bug fixes
Date:   Thu, 31 Aug 2023 07:07:31 -0400
Message-ID: <20230831110734.787212-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

This series includes a couple bug fixes that fell out of ongoing
experimentation with freeze support. I think patch 1 is pretty
self-explanatory, patch 2 is a prepatory patch, and patch 3 addresses a
race in the journaling code.

All patches are available in my current test branch, with CI test
results below [1]. Note that branch also includes a patch to enable
freeze, but I'd rather not see that one land quite yet (which is why
it's not included here). It's so far only seen the type of testing
intended to shake these sorts of peripheral issues out, and I need to
run some more testing to confirm sane behavior.

Thoughts, reviews, flames appreciated.

Brian

[1] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian Foster (3):
  bcachefs: restart journal reclaim thread on ro->rw transitions
  bcachefs: prepare journal buf put to handle pin put
  bcachefs: fix race between journal entry close and pin set

 fs/bcachefs/journal.c | 13 +------------
 fs/bcachefs/journal.h | 39 +++++++++++++++++++++++++++++++++------
 fs/bcachefs/super.c   |  4 ++++
 3 files changed, 38 insertions(+), 18 deletions(-)

-- 
2.41.0

