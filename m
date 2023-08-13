Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3D5C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjHMPnI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHMPnI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:43:08 -0400
Received: from out-88.mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A49E60
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:43:10 -0700 (PDT)
Date:   Sun, 13 Aug 2023 11:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691941388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W+qKYS8f2wekkZhZBAvz37h1hnY2xgnbDNfKmlsuPV0=;
        b=eXdhZntcrhWZMuJZatdEWelScGavpvAhXNXM4zmrT4Zmu9bGgh3GbwxA1P6UoQo9poG1xC
        V5Dn3vtsiv0HM7yLyUluCn5WK1YSYAQRFLL7NBrzIbzAqPdXMTgnyCcGvSzQrywAPoCIFg
        0RYCUqycAvGJ3zgBNnvT+X6NSvYE3OA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Lower BCH_NAME_MAX to 512
Message-ID: <20230813154304.srlikmsf7melqcda@moria.home.lan>
References: <20230812235947.557433-1-joshua@froggi.es>
 <20230813151034.rgzwbyhwwqudjuk6@moria.home.lan>
 <cba61c5b-efc8-4456-b325-fee85e066f1a@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cba61c5b-efc8-4456-b325-fee85e066f1a@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 04:29:52PM +0100, Joshua Ashton wrote:
> 
> 
> On 8/13/23 16:10, Kent Overstreet wrote:
> > On Sun, Aug 13, 2023 at 12:59:17AM +0100, Joshua Ashton wrote:
> > > To ensure we aren't shooting ourselves in the foot after merge for
> > > potentially doing future revisions for dirent or for storing multiple
> > > names for casefolding, limit this to 512 for now.
> > 
> > Any time you're changing something - always grep to see how it's used:
> 
> Was aware it was used here, but wasn't sure what you were willing to accept
> in terms of compat.

Make sure to mention things you aren't sure about in the commit message
then, don't leave surprises :)

> > bch2_dirent_invalid():
> > 
> >          if (d_name.len > BCH_NAME_MAX) {
> >                  prt_printf(err, "dirent name too big (%u > %u)",
> >                         d_name.len, BCH_NAME_MAX);
> >                  return -BCH_ERR_invalid_bkey;
> >          }
> > 
> > We'll need to either delete that check, or only run it for new keys
> > (flags & BKEY_INVALID_COMMIT), we don't want to be deleting existing
> > dirents
> 
> It isn't actually possible for this check to even trigger with the old
> BCH_NAME_MAX given how the length was calculated and the value of it.

Yes, but after your patch this check will trigger on any dirents longer
than the new BCH_NAME_MAX, and they'll be deleted.

> Makes sense to just change it to a check on COMMIT for new keys with the new
> size..
> (Should also never happen, but makes sense for sanity.)

Yeah, that's what the .invalid() methods are for - catching bugs before
we write garbage out to disk.
