Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9F6CDB47E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 00:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjJSArL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjJSArK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 18 Oct 2023 20:47:10 -0400
Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EB611D
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Oct 2023 17:47:08 -0700 (PDT)
Date:   Wed, 18 Oct 2023 20:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697676427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtXigvra3uMrcnmgWyGLQ6J3ZMbpvV/wkbimsc4hBHI=;
        b=nbhlrYSnpl1IAEOYAPY/pRP9tQp2yhpULJTPMMRtJIXI0EOW/LV2CIpmXvjvKJwbU2W9lJ
        7iUHgTJ8WNBADRl37X1YTlJOgfm7stSCfS2dgHwgKELufx4uDiS2Egiv1FN1AZsA5bfanS
        Xlo08JIkJcpPV7FfRjLu/Wj+aEl954I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Parke <parke.nexus@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Bcachefs: export a different st_dev for each subvolume
Message-ID: <20231019004704.ehjplvjlhzqgnyx6@moria.home.lan>
References: <CAPxz1+Yt644v4q-ahjE46Sh_ZZSE2r=wwSaup4nYC4uYgQy+rA@mail.gmail.com>
 <20231018202955.i2xjqqpd7cubunvg@moria.home.lan>
 <CAPxz1+ZTODcUt=nbToDtpsHr1LW04VNVqDPJNV2QhuXb-=+CnQ@mail.gmail.com>
 <20231019002654.cgsmfhu6pxnh4vro@moria.home.lan>
 <CAPxz1+YcGd23wH4J+Vo1ES6-ncMaW0ga6DSxehS8Ty=t6rTbNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPxz1+YcGd23wH4J+Vo1ES6-ncMaW0ga6DSxehS8Ty=t6rTbNg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Oct 18, 2023 at 05:35:33PM -0700, Parke wrote:
> On Wed, Oct 18, 2023 at 5:27 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > What about testing if st_dev is different from the parent directory?
> 
> That was my first thought.
> 
> Unfortunately, there are complications due to symlinks, bind mounts,
> and possibly other factors.
> 
> Discussion here:
> https://lists.gnu.org/archive/html/coreutils/2023-10/msg00013.html

So, in that case, you just need a single bit reported via stat() or
statx().

Unfortunately, I don't see a flags field in struct statx...
