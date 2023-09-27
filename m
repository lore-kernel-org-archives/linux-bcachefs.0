Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9522CE810D5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 11:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjI0LYM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbjI0LYM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 07:24:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C78F198
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 04:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695813802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PsCzaWEhmz9QIPcCk7PvlsRWAKTfJyLb/w3DZQ4hV0g=;
        b=hv3sLZ74H/Tj9yLWAckEKMdd5ge0n1tMccUO8yrpadtp68xv+yEOzpBRMxjH7nbIC33wiS
        mQpz9oeoYL9CWFJjjtQpngkKyd+sjqTwO26MhugaSa5l+inPHQn/EOPpVnzOHXi/2j8D1U
        YXWkTz43U+0ZW4u28erSdvp3nLqVgyw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-2GE4-jm4MNeeSxdN-zmmfA-1; Wed, 27 Sep 2023 07:23:20 -0400
X-MC-Unique: 2GE4-jm4MNeeSxdN-zmmfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EB4B3800A1C
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 821FB2156702
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/2] bcachefs: checksum merge and writeback fix
Date:   Wed, 27 Sep 2023 07:23:36 -0400
Message-ID: <20230927112338.262207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

A couple more small fixes. The first patch fixes a byte order problem in
the boundary code between bcachefs and the crc32c library related to
extent (and thus checksum) merges. The second patch addresses a small
logic wart that leads to more split writeback behavior than necessary,
which is how the problem addressed by patch 1 was observed. Patch 2 was
more of a "I'm not clear on why this size check is here, so let's try to
remove it and see what happens" patch. ;)

From chatting a bit in the meeting yesterday, I think we've already
established this isn't exactly what we want to do here. Instead, we
should still have some sort of bound on the size of a writeback op.
This is discussed a bit in the commit log description, but the consensus
seemed to be that this should just be replaced with a moderately less
conservative size check, such as 16MB or so. That's notably better than
the current limit of 1MB, so unless discussion on this patch leads in a
different direction, I'll probably follow up with a v2 to do that once
I've had a bit more chance to test it. Therefore, patch 2 is included
here mainly for posterity.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  bcachefs: fix crc32c checksum merge byte order problem
  bcachefs: remove writeback bio size limit

 fs/bcachefs/checksum.c       | 4 ++--
 fs/bcachefs/fs-io-buffered.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

-- 
2.41.0

