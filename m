Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41832E7D0A0
	for <linux-bcachefs@archiver.kernel.org>; Thu, 21 Sep 2023 17:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjIURYa (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjIURYI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 21 Sep 2023 13:24:08 -0400
Received: from out-219.mta0.migadu.com (out-219.mta0.migadu.com [IPv6:2001:41d0:1004:224b::db])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A624867
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Sep 2023 10:11:31 -0700 (PDT)
Date:   Thu, 21 Sep 2023 11:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695311165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gkv167QTHnU7obQtnvZbOacJ/psFb0rjSQ+UEO6GLBM=;
        b=m29Eo42p41c0fxwlgf2EkuRuESPaSg4qW+EhSNJkLBbLlyCED2IfV6Jl+wG5i4TLFpbryF
        EIeBbunDysLaRIDE8en26TcfrXhbUpN3S7iSHnByDuNZrT6hRGGp8lta44RTDdPrVqWiOJ
        YERfEGPbkoXS1usy7iDaiTT6Su4rBS8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Message-ID: <20230921154601.dykijqmxajy3kezf@moria.home.lan>
References: <20230915125154.307450-1-bfoster@redhat.com>
 <20230915125154.307450-5-bfoster@redhat.com>
 <20230920012116.pi7nw5ziebrdffkq@moria.home.lan>
 <ZQrzjG5T2jSthuB9@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQrzjG5T2jSthuB9@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Sep 20, 2023 at 09:28:44AM -0400, Brian Foster wrote:
> On Tue, Sep 19, 2023 at 09:21:16PM -0400, Kent Overstreet wrote:
> > Pulled this into the testing branch and then got
> > 
> > https://evilpiepirate.org/~testdashboard/c/de4ea1e2a9ceec5d55fffbc1acab89f0dc8f90b6/xfstests.generic.459/log.br
> > 
> > So I'll likely kick this patch back out for now, let me know when you
> > have a fixed version :)
> > 
> 
> Ah, sorry.. I should have mentioned this in the cover letter. I'm aware
> of this failure but my initial triage has it as an unrelated problem.
> That test basically induces I/O errors by explicitly overprovisioning a
> dm-thin volume for the fs. The original bug was a livelock issue on XFS
> related to metadata writeback failure/retry in this particular scenario.
> 
> The test relies on freeze in that it basically consumes all of the
> initially provisioned space, issues a freeze in the background (which
> will start off hanging because not everything can write back until more
> storage is available), and then grows available space so freeze can
> proceed to completion. It uses the success/failure of the freeze to
> determine pass/failure, and if the freeze fails it looks like it expects
> the filesystem to have been remounted ro (which I believe is ext4's way
> of dealing with this).
> 
> My notes say that freeze failed because the fs shutdown, which I think
> is due to the whole overprovision/flush thing leading to I/O errors
> (i.e. expected behavior, probably similar to ext4). But TBH I hadn't dug
> into it further than initial triage to rule out the core freeze
> mechanism itself. I'll dig more into that soon to see whether we need to
> change the test or something in the kernel, though I don't think it
> necessarily needs to gate freeze support..

Ah ok - and regardless, this is a new test being enabled. Pulling this
patch back in...
