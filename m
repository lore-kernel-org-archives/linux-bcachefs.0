Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D12DEB64DC
	for <linux-bcachefs@archiver.kernel.org>; Sat,  8 Jul 2023 04:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjGHEbr (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 8 Jul 2023 00:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjGHEbq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 8 Jul 2023 00:31:46 -0400
Received: from out-10.mta1.migadu.com (out-10.mta1.migadu.com [IPv6:2001:41d0:203:375::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C1C1FEA
        for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jul 2023 21:31:42 -0700 (PDT)
Date:   Sat, 8 Jul 2023 00:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688790701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MPVT67gN7ujA4VBNbmeWyGDovqohI1BOlI1/KLrNAYc=;
        b=AugBxODy4XO+i5cEvKSEgmKRdOkEPAC475o9lFSsYGCgHzFqs5SZZ5xK9iXAItWjtsSJ9m
        1T/QAzs2ji9X9+JpW9lnEqR9Nxacz0AnWLIze+9Zher2QtyR5MxXLQl2n9kP6cP7HQaZ7w
        oErGZkxYp7U0dCAobi9K9B8mUxkT8y4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        dchinner@redhat.com, sandeen@redhat.com, tytso@mit.edu,
        bfoster@redhat.com, jack@suse.cz, andreas.gruenbacher@gmail.com,
        peterz@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230708043136.xj4u7mhklpblomqd@moria.home.lan>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan>
 <20230706164055.GA2306489@perftesting>
 <20230706173819.36c67pf42ba4gmv4@moria.home.lan>
 <20230706211914.GB11476@frogsfrogsfrogs>
 <20230707-badeverbot-gekettet-19ce3c238dac@brauner>
 <20230707091810.bamrvzcif7ncng46@moria.home.lan>
 <30661670c55601ff475f2f0698c2be2958e45c38.camel@HansenPartnership.com>
 <ZKjd7nQxvzRDA2tK@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKjd7nQxvzRDA2tK@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Jul 08, 2023 at 04:54:22AM +0100, Matthew Wilcox wrote:
> On Fri, Jul 07, 2023 at 12:26:19PM -0400, James Bottomley wrote:
> > On Fri, 2023-07-07 at 05:18 -0400, Kent Overstreet wrote:
> > > Christain, the hostility I'm reading is in your steady passive
> > > aggressive accusations, and your patronizing attitude. It's not
> > > professional, and it's not called for.
> > 
> > Can you not see that saying this is a huge red flag?  With you every
> > disagreement becomes, as Josef said, "a hill to die on" and you then
> > feel entitled to indulge in ad hominem attacks, like this, or be
> > dismissive or try to bury whoever raised the objection in technical
> > minutiae in the hope you can demonstrate you have a better grasp of the
> > details than they do and therefore their observation shouldn't count.
> > 
> > One of a maintainer's jobs is to nurture and build a community and
> > that's especially important at the inclusion of a new feature.  What
> > we've seen from you implies you'd build a community of little Kents
> > (basically an echo chamber of people who agree with you) and use them
> > as a platform to attack any area of the kernel you didn't agree with
> > technically (which, apparently, would be most of block and vfs with a
> > bit of mm thrown in), leading to huge divisions and infighting.  Anyone
> > who had the slightest disagreement with you would be out and would
> > likely behave in the same way you do now leading to internal community
> > schisms and more fighting on the lists.
> > 
> > We've spent years trying to improve the lists and make the community
> > welcoming.  However technically brilliant a new feature is, it can't
> > come with this sort of potential for community and reputational damage.
> 
> I don't think the lists are any better, tbh.  Yes, the LF has done a great
> job of telling people not to use "bad words" any more.  But people are
> still arseholes to each other.  They're just more subtle about it now.
> I'm not going to enumerate the ways because that's pointless.

I've long thought a more useful CoC would start with "always try to
continue the technical conversation in good faith, always try to build
off of what other people are saying; don't shut people down".

The work we do has real consequences. There are consequences for the
people doing the work, and consequences for the people that use our work
if we screw things up. Things are bound to get heated at times; that's
expected, and it's ok - as long as we can remember to keep doing the
work and pushing forward.
