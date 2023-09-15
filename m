Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59EDEE645D
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbjIOMwf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbjIOMwd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:52:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADF341713
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694782301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=mG7MNtTLTYzyNiuAfzba4+pjp5pk70uVjs9IIAyPEPM=;
        b=DdR4eDqJk04gRF9G8NykhY/+QVqjudo86qG4HG7jSxZ6j6aHDX9IvE3AycAHdDU8vPhhQJ
        bu692bpPbKyFInvMAjnI9s7GZG84lc0DFaOSK8anbpkTaM7S3QxHEpIll70M1ZQ1YKF8hZ
        mCYNiW1RtV7VSD+AXWn+IlkVVauI25c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-lMJTgcNeOMOqxk494m1koQ-1; Fri, 15 Sep 2023 08:51:40 -0400
X-MC-Unique: lMJTgcNeOMOqxk494m1koQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E493385A5A8
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C866610F1BE7
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 0/4] bcachefs: journal bug fixes / freeze support
Date:   Fri, 15 Sep 2023 08:51:50 -0400
Message-ID: <20230915125154.307450-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

Here's v2 of the bcachefs freeze and related bugfix patches. Patch 1 of
the original series has been merged. Patches 1-3 of this series have
been reworked a bit to address some of Kent's concerns, particularly
around increasing the amount of inline code. The factoring has been
reworked a bit to address that, but otherwise the fundamental fix in
patch 3 is the same: allow journal reservation to hold an indirect
reference on the pin list via the journal buffer.

Patch 4 adds initial support for the vfs freeze mechanism. This is
technically still a bit incomplete because we don't include intwrite
freeze protection, but technically afaict things still function
correctly mainly due to bcachefs' nearly overlapping write reference
mechanism. So all in all while it seems like this could still be
improved, that requires further thought and doesn't seem to warrant
further gating. Further details and caveats are discussed in the commit
log.

This survives all of the usual regression tests with the only observable
failure being generic/459. This is a newly enabled (freeze dependent)
test that intentionally produces I/O errors via dm-thin
overprovisioning. The reason for the occasional test failure is that the
filesystem shuts down due to these I/O errors. This is generally
expected behavior for bcachefs and so not an immediate freeze issue.
Finally, CI regression is ongoing and observable here:

 https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Thoughts, reviews, flames appreciated.

Brian

v2:
- Reworked approach to final journal buffer processing.
- Appended initial freeze support patch.
v1: https://lore.kernel.org/linux-bcachefs/20230831110734.787212-1-bfoster@redhat.com/

Brian Foster (4):
  bcachefs: refactor pin put helpers
  bcachefs: prepare journal buf put to handle pin put
  bcachefs: fix race between journal entry close and pin set
  bcachefs: initial freeze/unfreeze support

 fs/bcachefs/fs.c              | 31 +++++++++++++++++++++++++++++--
 fs/bcachefs/journal.c         | 20 +++++++++++++-------
 fs/bcachefs/journal.h         | 34 ++++++++++++++++++++++++++++------
 fs/bcachefs/journal_reclaim.c | 11 ++++-------
 fs/bcachefs/journal_reclaim.h |  3 ++-
 5 files changed, 76 insertions(+), 23 deletions(-)

-- 
2.41.0

