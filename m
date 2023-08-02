Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF4AC001E0
	for <linux-bcachefs@archiver.kernel.org>; Wed,  2 Aug 2023 16:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjHBQop (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjHBQop (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 2 Aug 2023 12:44:45 -0400
Received: from out-78.mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8606DE4D
        for <linux-bcachefs@vger.kernel.org>; Wed,  2 Aug 2023 09:44:43 -0700 (PDT)
Date:   Wed, 2 Aug 2023 12:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690994681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pZgu6VYBtVmDJxB8/yQqdmC5ll//zvqWRVFeO9x8huE=;
        b=fce+OLsEemL82w3gvvoTSKcithaQm7VhHQwGW1Rlpuf7kw3knwpOdgJ+tuUuunjiijUxHa
        5N6DI50igXJhCvKGa5fTTo9x5aho5jo0/fXftHomHmeD0u0LvDU2NigvOpU2xEFPcGEWQ5
        lZzSqKR+IqsPHWoPCg0YnnvAh13JbEc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 05/20] block: Allow bio_iov_iter_get_pages() with
 bio->bi_bdev unset
Message-ID: <20230802164437.jskidimw32dofxpi@moria.home.lan>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
 <20230712211115.2174650-6-kent.overstreet@linux.dev>
 <ZL62HKrAJapXfcaR@infradead.org>
 <20230725024312.alq7df33ckede2gb@moria.home.lan>
 <ZMEeOZZcOu2p0SDP@infradead.org>
 <20230801190450.3lbr2hjdi7t52anx@moria.home.lan>
 <ZMpCRpNyt0EJpg9G@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMpCRpNyt0EJpg9G@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Aug 02, 2023 at 04:47:18AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 01, 2023 at 03:04:50PM -0400, Kent Overstreet wrote:
> > > Because blk-cgroup not only works at the lowest level in the stack,
> > > but also for stackable block devices.  It's not a design decision I
> > > particularly agree with, but it's been there forever.
> > 
> > You're setting the association only to the highest block device in the
> > stack - how on earth is it supposed to work with anything lower?
> 
> Hey, ask the cgroup folks as they come up with it.  I'm not going to
> defend the logic here.
> 
> > And looking at bio_associate_blkg(), this code looks completely broken.
> > It's checking bio->bi_blkg, but that's just been set to NULL in
> > bio_init().
> 
> It's checking bi_blkg because it can also be called from bio_set_dev.

So bio_set_dev() has subtly different behaviour than passing the block
device to bio_init()?

That's just broken.

> 
> > And this is your code, so I think you need to go over this again.
> 
> It's "my code" in the sene of that I did one big round of unwinding
> the even bigger mess that was there.  There is another few rounds needed
> for the code to vaguely make sense.

Well, I'll watch for those patches then...
