Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B83C6FD18
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 15:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbjDYPdi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 11:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjDYPdg (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 11:33:36 -0400
Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [IPv6:2001:41d0:1004:224b::13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8704CC17
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 08:33:34 -0700 (PDT)
Date:   Tue, 25 Apr 2023 11:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682436811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LWPe97++GEAl0lda/rvv22xp/bNEmnhnt2+46rnnBB4=;
        b=U0mOQlxDSTHWQQUQmLmhDPfYKR+rmJYRivAoiGThFT85GqIaBZQ5c7rCL5Pdy2bmrln3c9
        sPrx8AhuNuIz59IdYV8c4zgiD/I98ycfiAOetX0Zth8gEdM/yPK+nEY3iBAVNCOmDAb6kR
        swOZBllpDDH9BzU6yfyu2mk4bVOgIGQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: PR contribution
Message-ID: <ZEfyx+JWCtR3Yl9W@moria.home.lan>
References: <CAMy36z4rxgcNUmxrtapBx_LY-ZYuB0_r2pEVSf27REodE4R3Sw@mail.gmail.com>
 <CAMy36z7GKiv5_u=WmoDpzFMUeRaWPaAme2eFmdgDdDJ+g-sROQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z7GKiv5_u=WmoDpzFMUeRaWPaAme2eFmdgDdDJ+g-sROQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 24, 2023 at 10:05:05AM -0700, TruongSinh Tran-Nguyen wrote:
> Hi, I have 2 PRs on GitHub for bcachfs-tools [1] [2], but I don't know
> whether it's more likely to be discussed and reviewed on this mailing
> list. I can also submit git patch on this mailing list if it is easier
> for the maintainer.

Yeah we use github for issue tracking but I'm not as big of a fan of
github's PR interface. Could you send the patches to the list?
