Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E20C3DA79
	for <linux-bcachefs@archiver.kernel.org>; Thu, 29 Dec 2022 22:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiL2W0K (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 29 Dec 2022 17:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiL2W0J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 29 Dec 2022 17:26:09 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BBC7679
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Dec 2022 14:26:08 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0FA1D49;
        Thu, 29 Dec 2022 14:26:08 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id P5gnfLc4xMPH; Thu, 29 Dec 2022 14:26:03 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 86CF940;
        Thu, 29 Dec 2022 14:26:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 86CF940
Date:   Thu, 29 Dec 2022 14:26:03 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
In-Reply-To: <Y63/ygc7d4S97JtM@moria.home.lan>
Message-ID: <461e41da-708b-8b10-8b96-341f4188a34@ewheeler.net>
References: <20221212190602.1388127-1-bfoster@redhat.com> <20221213183743.3m6ntfnu7n3yebng@moria.home.lan> <Y5oLlLcHmS2EWp8n@bfoster> <Y5u3VlkA3AbhQKav@moria.home.lan> <Y5wYjUhTAzhSIvM3@moria.home.lan> <Y6CGUZhqs5ABBIbO@bfoster> <Y6EWZ3IODBa0e0lT@moria.home.lan>
 <1bfa9aed-44c1-8217-9d6a-a594524ab0a0@ewheeler.net> <Y63/ygc7d4S97JtM@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, 29 Dec 2022, Kent Overstreet wrote:
> On Wed, Dec 28, 2022 at 02:24:45PM -0800, Eric Wheeler wrote:
>  
> > This reminds me of an LWN article I read many years ago about how SD cards 
> > handle "open segments" in their FTL:
> > 	https://lwn.net/Articles/428584/
> > 
> > 	"Restrictions on open segments: One major difference between
> > 	the various [sdcard] manufacturers is how many segments they
> > 	can write to at any given time.  Starting to write a segment
> > 	requires another physical segment, or two in case of a data
> > 	logging algorithm, to be reserved, and requires some RAM on the
> > 	embedded microcontroller to maintain the segment. Writing to a
> > 	new segment will cause garbage collection on a previously open
> > 	segment. That can lead to thrashing as the drive must repeatedly
> > 	switch open segments"
> > 
> > SD cards are often used on today's low-end embedded ARM hardware for 
> > during prototyping (such as Raspberry Pi and others), so this may still be 
> > relevant today.  If bcachefs is capable of operating with very few 
> > writepoints (ie, if max writepoints were configurable), then it may 
> > perform much better on low-end SD cards.
> 
> It is. When the filesystem is close to full we effectively operate with fewer
> writepoints to avoid stranded free space, adding a config option would be pretty
> trivial.
> 
> > Making the bcachefs bucket size equal to the segment size would help a 
> > lot, I'm sure, but this data is rarely published by manufacturers.  
> > However, it can be probed:
> > 	https://git.linaro.org/people/arnd/flashbench.git/about/
> > 
> > It might be useful to make the writepoints limit configurable at mkfs 
> > time.  mkfs could even probe the storage volume to find out when 
> > increasing the number of possible writepoints causes write latency to 
> > spike.  The flash "segment size" could be probed similarly and 
> > auto-configure some of the bcachefs tunables.
> 
> More interesting to me would be finishing ZNS support - that's going to be
> considerably more robust than any probing, any time there's an FTL underneath we
> can't know that data is being laid out the way we want it to. Perhaps SD card
> FTLs are simple enough that this could be made to work, but we'd be at the mercy
> of opaque implementation details.
> 
> But if we get ZNS support finished, perhaps we could get SD card manufacturers
> to start exposing that interface or something equivalent, and that should get us
> not only better performance but potentially better reliability too - we'd be
> able to implement proper wear leveling, something SD cards at least historically
> haven't generally done.

That would be great!

--
Eric Wheeler


