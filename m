Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C09CC61DA4
	for <linux-bcachefs@archiver.kernel.org>; Wed, 22 Feb 2023 19:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBVTqk (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 22 Feb 2023 14:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBVTqj (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 22 Feb 2023 14:46:39 -0500
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1773E628
        for <linux-bcachefs@vger.kernel.org>; Wed, 22 Feb 2023 11:46:38 -0800 (PST)
Date:   Wed, 22 Feb 2023 14:46:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677095194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=bY8dvU38oBviCwvwrZ9IrMov3d6B2NIfHaiAys0qSeU=;
        b=w9nf1qqqogEaOY0tiOq+XYgK6kL+VrxizsV1h6k2v7SAzRP3cmZMeXPososn8LHSafcSre
        JxF5EJWHD+btVBQcOQhNx43mdPtyWtxRQD38zbO+paIsoOWsVnZOdNaDCa6qnlVIsqoGi3
        yWthx2QrD7QCZ6AbiWiZM6iP+yxQaPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] bcachefs
Message-ID: <Y/ZxFwCasnmPLUP6@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi, I'd like to give an update on bcachefs progress and talk about
upstreaming.

There's been a lot of activity over the past year or so:
 - allocator rewrite
 - cycle detector for deadlock avoidance
 - backpointers
 - test infrastructure!
 - starting to integrate rust code (!)
 - lots more bug squashing, scalability work, debug tooling improvements

I'd like to talk more about where things are at, long term goals, and
finally upstreaming this beast.
