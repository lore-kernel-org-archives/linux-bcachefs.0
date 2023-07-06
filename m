Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C74E2EB64DC
	for <linux-bcachefs@archiver.kernel.org>; Thu,  6 Jul 2023 16:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjGFQeL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjGFQeK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 6 Jul 2023 12:34:10 -0400
Received: from out-1.mta1.migadu.com (out-1.mta1.migadu.com [IPv6:2001:41d0:203:375::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024D71727
        for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jul 2023 09:34:08 -0700 (PDT)
Date:   Thu, 6 Jul 2023 12:34:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688661246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XBn/mkChlZxb0dNmfL30mgqBPNGEmA84yaKWnN34ndQ=;
        b=emVQYAm5Dv/NFKC7yFbnHt6GKAd2RVpbw8V+2KvJCDKSTIrZDk/KnM16DbgHerM8iKVUYG
        cRgIqPD65wsytvdmEkjdc8uV1bHF+gFEpL6cx1jN/vTRl36Bw7K0WaYZpntpZCEoyI34Vn
        slIsd4IuwHS9WwMG1xSFve28Hr9C1+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230706163403.4w5iyeu6n6ug4x2p@moria.home.lan>
References: <20230628225514.n3xtlgmjkgapgnrd@moria.home.lan>
 <1e2134f1-f48b-1459-a38e-eac9597cd64a@kernel.dk>
 <20230628235018.ttvtzpfe42fri4yq@moria.home.lan>
 <ZJzXs6C8G2SL10vq@dread.disaster.area>
 <d6546c44-04db-cbca-1523-a914670a607f@kernel.dk>
 <20230629-fragen-dennoch-fb5265aaba23@brauner>
 <20230629153108.wyn32bvaxmztnakl@moria.home.lan>
 <20230630-aufwiegen-ausrollen-e240052c0aaa@brauner>
 <20230706152059.smhy7jdbim4qlr6f@moria.home.lan>
 <48d69cae-902a-a746-e73b-a5b8fdf694b4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d69cae-902a-a746-e73b-a5b8fdf694b4@kernel.dk>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jul 06, 2023 at 10:26:34AM -0600, Jens Axboe wrote:
> On 7/6/23 9:20?AM, Kent Overstreet wrote:
> >> My earlier mail clearly said that io_uring can be changed by Jens pretty
> >> quickly to not cause such test failures.
> > 
> > Jens posted a fix that didn't actually fix anything, and after that it
> > seemed neither of you were interested in actually fixing this. So
> > based on that, maybe we need to consider switching fstests back to AIO
> > just so we can get work done...
> 
> Yeah let's keep misrepresenting... I already showed how to hit this
> easily with aio, and you said you'd fix aio. But nothing really happened
> there, unsurprisingly.

Jens, your test case showing that this happens on aio too was
appreciated: I was out of town for the holiday weekend, and I'm just now
back home catching up and fixing your test case is the first thing I'm
working on.

But like I said, this wasn't causing test failures when we were using
AIO, it's only since we switched to io_uring that this has become an
issue, and I'm not the only one telling you this is an issue, so ball
very much in your court.

> You do what you want, as per usual these threads just turn into an
> unproductive (and waste of time) shit show. Muted on my end from now on.

Ok.
