Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBB8C4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 16:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345170AbjJaQZK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345151AbjJaQZJ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Oct 2023 12:25:09 -0400
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1A1F1;
        Tue, 31 Oct 2023 09:25:05 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698769503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2/WqVk2ZLmZJ6bgdjF1aGMs2a9ubs62YR4GPwL+7LDI=;
        b=Pm0ogUfAr1KunimWLPdFW+wIyni6jlMAfmX2xekYUo2NrYptSIi+SqiGgvUuzeqZ6L/eQC
        EWpXSR3DIR0CWH+SSPTYkcCyBRKX+AE3tgoLZN2Mi4avD9d9/YU1CA18Nq0ZE0DfkmbJkw
        q8Fgez5OCtEcFfBHxr8RCgsAV4JOGjI=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 0/2] Two small closures patches
Date:   Tue, 31 Oct 2023 12:24:50 -0400
Message-ID: <20231031162454.3761482-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

I'll be sending these to Linus in my next pull request, sending them to
linux-bcache so Coly gets a chance to see them.

Kent Overstreet (2):
  closures: Better memory barriers
  closures: Fix race in closure_sync()

 fs/bcachefs/fs-io-direct.c |  1 +
 include/linux/closure.h    | 12 +++++++++---
 lib/closure.c              |  9 +++++++--
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.42.0

