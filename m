Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0949EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Fri,  7 Jul 2023 17:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjGGR0q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 7 Jul 2023 13:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbjGGR0m (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 7 Jul 2023 13:26:42 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405F82688
        for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jul 2023 10:26:36 -0700 (PDT)
Date:   Fri, 7 Jul 2023 13:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688750794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+fhYBe98Yp7ck/ha/HJfr6SRjqVS7qBuG/PuLcCjCk=;
        b=hNFNTvo4VaEOaCkebxW+T1dO0TA+w2qciZqmggXCIp6g/Kgr+/FZvCzYXpU+s6nleWS4oH
        1fdVhrZMyV2Svzi9pwookzUFRUM1HTKunLLZv5hnf1y2vQ3uhJuzvO/iCvQQ9Q+dj18dbx
        Kb4l+dO05VAKkxliVPv4znsiKaEn16M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        dchinner@redhat.com, sandeen@redhat.com, willy@infradead.org,
        tytso@mit.edu, bfoster@redhat.com, jack@suse.cz,
        andreas.gruenbacher@gmail.com, peterz@infradead.org,
        akpm@linux-foundation.org, dhowells@redhat.com
Subject: Re: [GIT PULL] bcachefs
Message-ID: <20230707172626.zlpdwyyko4trwcff@moria.home.lan>
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan>
 <20230706164055.GA2306489@perftesting>
 <20230706173819.36c67pf42ba4gmv4@moria.home.lan>
 <20230706211914.GB11476@frogsfrogsfrogs>
 <20230707-badeverbot-gekettet-19ce3c238dac@brauner>
 <20230707091810.bamrvzcif7ncng46@moria.home.lan>
 <30661670c55601ff475f2f0698c2be2958e45c38.camel@HansenPartnership.com>
 <20230707164808.nisoh3ia4xkdgjj3@moria.home.lan>
 <85ec096ee90e3d62ebb496b3faeb4dce25e3deab.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85ec096ee90e3d62ebb496b3faeb4dce25e3deab.camel@HansenPartnership.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jul 07, 2023 at 01:04:14PM -0400, James Bottomley wrote:
> On Fri, 2023-07-07 at 12:48 -0400, Kent Overstreet wrote:
> > On Fri, Jul 07, 2023 at 12:26:19PM -0400, James Bottomley wrote:
> > > On Fri, 2023-07-07 at 05:18 -0400, Kent Overstreet wrote:
> [...]
> > > > In that offlist thread, I don't recall much in the way of actual,
> > > > concrete concerns. I do recall Christoph doing his usual schpiel;
> > > > and to be clear, I cut short my interactions with Christoph
> > > > because in nearly 15 years of kernel development he's never been
> > > > anything but hostile to anything I've posted, and the criticisms
> > > > he posts tend to be vague and unaware of the surrounding
> > > > discussion, not anything actionable.
> > > 
> > > This too is a red flag.  Working with difficult people is one of a
> > > maintainer's jobs as well.  Christoph has done an enormous amount
> > > of highly productive work over the years.  Sure, he's prickly and
> > > sure there have been fights, but everyone except you seems to
> > > manage to patch things up and accept his contributions.  If it were
> > > just one personal problem it might be overlookable, but you seem to
> > > be having major fights with the maintainer of every subsystem you
> > > touch...
> > 
> > James, I will bend over backwards to work with people who will work
> > to continue the technical discussion.
> 
> You will?  Because that doesn't seem to align with your statement about
> Christoph being "vague and unaware of the surrounding discussions" and
> not posting "anything actionable" for the last 15 years.  No-one else
> has that impression and we've almost all had run-ins with Christoph at
> some point.

If I'm going to respond to this I'd have to start citing interactions
and I don't want to dig things that deep in public.

Can we either try to resolve this privately or drop it?
