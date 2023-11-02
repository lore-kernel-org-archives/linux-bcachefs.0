Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB112C4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 02:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbjKBCuC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 22:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbjKBCuB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 22:50:01 -0400
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [IPv6:2001:41d0:203:375::aa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E82D6D
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:49:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698893371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qYhbDEbRImDFxWLyQ5jW3LGLBp49+S6xGSZrrMSPQPc=;
        b=YUUpfFEofwjU/yc4dxtn3G1PzUasr6QgkPeObGMLGadf1aiTgcGaYdDiXx90gk7/vL4CZW
        k5XepKy0d1BGZclaMXhG9PniOAOzqEU+wIxW23wqF0jZuTv5ipQkVF0UIfKJf5FdjXRG7L
        VRXppRRBgJQFcDwn1ZKD0W7Zd/6Mo6Y=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/2] Split brain detection
Date:   Wed,  1 Nov 2023 22:49:18 -0400
Message-ID: <20231102024924.4107287-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Two patch series for split brain detection: that is, detect when
different members of a filesystem have been used, independently, in
degraded mode and diverged - when that happens we can no longer use
those members in combination.

First patch adds superblock facilities: we add a superblock sequence
number field to bch_member, and a write time field to the superblock to
detect cases when sb->seq is equal but they actually have diverged.

Second patch does the actual split brain detection and kicking out of
devices when necessary.

Kent Overstreet (2):
  bcachefs: bch_member->seq
  bcachefs: Split brain detection

 fs/bcachefs/bcachefs_format.h |  4 ++-
 fs/bcachefs/errcode.h         |  1 +
 fs/bcachefs/sb-members.c      |  5 ++++
 fs/bcachefs/super-io.c        | 10 +++++++
 fs/bcachefs/super.c           | 56 ++++++++++++++++++++++++++++-------
 5 files changed, 64 insertions(+), 12 deletions(-)

-- 
2.42.0

