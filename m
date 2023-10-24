Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47344C00A8F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343967AbjJXTO0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbjJXTOZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:25 -0400
Received: from out-195.mta1.migadu.com (out-195.mta1.migadu.com [IPv6:2001:41d0:203:375::c3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE4410C3
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:23 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9HIZ0AhBH/IWdGvxAiO/UuVKsFVQDUZcJqRG/Nja+hQ=;
        b=UfLEcHuVqlT8WFEPK4Uzyzao1MpStGCK/0lGU0PIvXyBEajHrZhYACb0NT9iMEQIu538sS
        BmrAqtc+onvPEgYt2bQiWyXu2WC1f0T1h+dY/y/y/Q1fwzLIuW3/6TYccQnc+TECvY8bJU
        8DFWMIjmAPM4EAEV5mZy80axXHsldaU=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/6] rebalance_work btree
Date:   Tue, 24 Oct 2023 15:14:05 -0400
Message-ID: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Here's the rebalance_work patchset, which I expect to merge shortly.

It eliminates most scanning by the rebalance thread, which is a nice
scalabality improvement. Cheers :)

Kent Overstreet (6):
  bcachefs: move.c exports, refactoring
  bcachefs: moving_context now owns a btree_trans
  bcachefs: move: convert to bbpos
  bcachefs: move: move_stats refactoring
  bcachefs: bch2_inum_opts_get()
  bcachefs: rebalance_work

 fs/bcachefs/bbpos.h           |  14 +-
 fs/bcachefs/bbpos_types.h     |  18 ++
 fs/bcachefs/bcachefs.h        |   4 +-
 fs/bcachefs/bcachefs_format.h |  34 +--
 fs/bcachefs/buckets.c         |  10 +
 fs/bcachefs/chardev.c         |   4 +-
 fs/bcachefs/compress.c        |  18 +-
 fs/bcachefs/compress.h        |   2 +
 fs/bcachefs/data_update.c     |  21 +-
 fs/bcachefs/data_update.h     |   1 +
 fs/bcachefs/extents.c         | 155 +++++++++-
 fs/bcachefs/extents.h         |  20 ++
 fs/bcachefs/inode.c           |  12 +
 fs/bcachefs/inode.h           |   1 +
 fs/bcachefs/io_misc.c         |  11 +-
 fs/bcachefs/io_write.c        |  20 +-
 fs/bcachefs/move.c            | 277 ++++++++---------
 fs/bcachefs/move.h            |  36 ++-
 fs/bcachefs/move_types.h      |   8 +-
 fs/bcachefs/movinggc.c        |  37 ++-
 fs/bcachefs/rebalance.c       | 553 ++++++++++++++++++++--------------
 fs/bcachefs/rebalance.h       |   9 +-
 fs/bcachefs/rebalance_types.h |  31 +-
 fs/bcachefs/recovery.c        |   1 +
 fs/bcachefs/recovery_types.h  |   1 +
 fs/bcachefs/reflink.c         |  19 +-
 fs/bcachefs/sysfs.c           |  14 +-
 fs/bcachefs/trace.c           |   1 +
 fs/bcachefs/trace.h           |  31 +-
 fs/bcachefs/xattr.c           |   2 +-
 30 files changed, 848 insertions(+), 517 deletions(-)
 create mode 100644 fs/bcachefs/bbpos_types.h

-- 
2.42.0

