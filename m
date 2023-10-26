Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C60C25B48
	for <linux-bcachefs@archiver.kernel.org>; Thu, 26 Oct 2023 19:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbjJZTPD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 26 Oct 2023 15:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjJZTO7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 26 Oct 2023 15:14:59 -0400
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [IPv6:2001:41d0:203:375::b6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0180A10E2
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Oct 2023 12:14:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698347680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dzxA/YlQ0pT5dh5N7Ot454wSWo4oxiTU+SY5wexff9U=;
        b=rweAukNv6DpmT3p5rkwZROWiYaVn1t7mNaNLvSaofe1w9ogwwQN52P+HKkY+ho64cUhXhB
        1/jX0DMWJsF5g1AJIFiaJtJ9YexUovGCsQeP5Jfw1ItbK6sitlb1smZ7kaJ5s9jGfTPTU/
        6T2sNm9wUJTEsGbIOdG/Uo3KgU9KDY0=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/2] superblock error counters
Date:   Thu, 26 Oct 2023 15:14:29 -0400
Message-ID: <20231026191434.2976460-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Two patches for tracking errors a filesystem has seen since creation:

 - per-device IO error counts were requested recently; members_v2 made
   adding this easy. We have separate counters for read, write and
   checksum errors, ZFS style.

 - personal wishlist item of mine for some time: enumarate all distinct
   fcsk errors and add persistent counters for them, so that show-super
   can show what inconsistencies have been getting found and fixed.

In my experience, users will often not report issues that fsck can
repair - but I still want to know about them, as generally speaking
anything fsck needed to repair resulted from a filesystem bug.

I might add a bit of telemetry for this, so that I know what bugs I
still need to be looking for :)

There's another patch in the series after this that plumbs the new
BCH_SB_ERR codes into fsck_err() - not mailing that patch to the list
because it's massive.

Cheers,
Kent

Kent Overstreet (2):
  bcachefs: Add IO error counts to bch_member
  bcachefs: bch_sb_field_errors

 fs/bcachefs/Makefile          |   1 +
 fs/bcachefs/bcachefs.h        |  16 +++-
 fs/bcachefs/bcachefs_format.h |  27 +++++-
 fs/bcachefs/btree_io.c        |   6 +-
 fs/bcachefs/ec.c              |   6 +-
 fs/bcachefs/errcode.h         |   1 +
 fs/bcachefs/error.c           |  25 ++---
 fs/bcachefs/error.h           |  10 +-
 fs/bcachefs/io_read.c         |   4 +-
 fs/bcachefs/io_write.c        |   2 +-
 fs/bcachefs/journal_io.c      |   5 +-
 fs/bcachefs/opts.c            |   5 -
 fs/bcachefs/opts.h            |   1 -
 fs/bcachefs/sb-errors.c       | 175 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-errors.h       |  26 +++++
 fs/bcachefs/sb-errors_types.h |  16 ++++
 fs/bcachefs/sb-members.c      |  70 ++++++++++----
 fs/bcachefs/sb-members.h      |  41 +++++++-
 fs/bcachefs/super-io.c        |  12 ++-
 fs/bcachefs/super-io.h        |  40 +-------
 fs/bcachefs/super.c           |  17 +++-
 fs/bcachefs/sysfs.c           |  27 +++++-
 22 files changed, 430 insertions(+), 103 deletions(-)
 create mode 100644 fs/bcachefs/sb-errors.c
 create mode 100644 fs/bcachefs/sb-errors.h
 create mode 100644 fs/bcachefs/sb-errors_types.h

-- 
2.42.0

