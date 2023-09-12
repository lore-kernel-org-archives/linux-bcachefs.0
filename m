Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5133CA0EC6
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 00:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbjILAzO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Sep 2023 20:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjILAzI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Sep 2023 20:55:08 -0400
Received: from out-230.mta0.migadu.com (out-230.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990C818E287
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Sep 2023 17:52:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694478250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SDuodpqtPrKd6qvv+9L+F4jV2e8OfkOdegWr87wu3rM=;
        b=uUTGf4BxbFKEkKRRmxnNHyVCQU6p35Vh2fGEj228Im6VZ5wsKo3Yfo5GiTW7HdDVucMvaz
        AuBJDuqeSj/9DFpxw4dLXlSxaNlDDsbzD3JYOqzp9l4jwCe59xN+9hbBlLIDPU/uXrW+/j
        qyaTxk1eHJofXxEj7gsdawkaDwxulWY=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/3] (More complex) logged operations
Date:   Mon, 11 Sep 2023 20:23:53 -0400
Message-Id: <20230912002356.566674-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

this patch series introduces a logged operations btree, for operations
that are too big to be done in a single btree transaction, and then
changes truncate and finsert/fcollapse to use it.

This fixes a recently noticed bug where the deleted inodes btree broke
truncate atomicity after unclean shutdown, because that was relying on
scanning the inodes btree for BCH_INODE_I_SIZE_DIRTY inodes...

Kent Overstreet (3):
  bcachefs: BTREE_ID_logged_ops
  bcachefs: Log truncate operations
  bcachefs: Log finsert/fcollapse operations

 fs/bcachefs/Makefile          |   1 +
 fs/bcachefs/bcachefs.h        |   1 +
 fs/bcachefs/bcachefs_format.h |  40 ++++-
 fs/bcachefs/bkey_methods.c    |   1 +
 fs/bcachefs/btree_update.c    |  18 +++
 fs/bcachefs/btree_update.h    |   1 +
 fs/bcachefs/io_misc.c         | 275 ++++++++++++++++++++--------------
 fs/bcachefs/io_misc.h         |  19 +++
 fs/bcachefs/logged_ops.c      | 110 ++++++++++++++
 fs/bcachefs/logged_ops.h      |  20 +++
 fs/bcachefs/recovery.c        |   1 +
 fs/bcachefs/recovery_types.h  |   1 +
 fs/bcachefs/super.c           |   1 +
 13 files changed, 376 insertions(+), 113 deletions(-)
 create mode 100644 fs/bcachefs/logged_ops.c
 create mode 100644 fs/bcachefs/logged_ops.h

-- 
2.40.1

