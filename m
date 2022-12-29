Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6086C3DA79
	for <linux-bcachefs@archiver.kernel.org>; Thu, 29 Dec 2022 21:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbiL2VAQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbiL2VAK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 29 Dec 2022 16:00:10 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D9C17054
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Dec 2022 13:00:00 -0800 (PST)
Date:   Thu, 29 Dec 2022 15:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672347598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EePGHoIVS+QHFNp9sm6gg9WSYcpai7BHmBXdfmM7V/w=;
        b=cSSIYKxe5XbWCEfT7e8l8fJemt7gVyj5mvoXF+7I3BUmw+3g4YpsW5De90xgmXLAXeOPQi
        Ad2UdLLFvkcfpsDXe/d8cc4BNRyTvxOSqvLyfSD4eA26/0nOZutCbhK1tBzsh9Je06/R6B
        NeQbf18J8sppS7ck4+xGEPfEQhLNI3U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y63/ygc7d4S97JtM@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y5wYjUhTAzhSIvM3@moria.home.lan>
 <Y6CGUZhqs5ABBIbO@bfoster>
 <Y6EWZ3IODBa0e0lT@moria.home.lan>
 <1bfa9aed-44c1-8217-9d6a-a594524ab0a0@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bfa9aed-44c1-8217-9d6a-a594524ab0a0@ewheeler.net>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Dec 28, 2022 at 02:24:45PM -0800, Eric Wheeler wrote:
 
> This reminds me of an LWN article I read many years ago about how SD cards 
> handle "open segments" in their FTL:
> 	https://lwn.net/Articles/428584/
> 
> 	"Restrictions on open segments: One major difference between
> 	the various [sdcard] manufacturers is how many segments they
> 	can write to at any given time.  Starting to write a segment
> 	requires another physical segment, or two in case of a data
> 	logging algorithm, to be reserved, and requires some RAM on the
> 	embedded microcontroller to maintain the segment. Writing to a
> 	new segment will cause garbage collection on a previously open
> 	segment. That can lead to thrashing as the drive must repeatedly
> 	switch open segments"
> 
> SD cards are often used on today's low-end embedded ARM hardware for 
> during prototyping (such as Raspberry Pi and others), so this may still be 
> relevant today.  If bcachefs is capable of operating with very few 
> writepoints (ie, if max writepoints were configurable), then it may 
> perform much better on low-end SD cards.

It is. When the filesystem is close to full we effectively operate with fewer
writepoints to avoid stranded free space, adding a config option would be pretty
trivial.

> Making the bcachefs bucket size equal to the segment size would help a 
> lot, I'm sure, but this data is rarely published by manufacturers.  
> However, it can be probed:
> 	https://git.linaro.org/people/arnd/flashbench.git/about/
> 
> It might be useful to make the writepoints limit configurable at mkfs 
> time.  mkfs could even probe the storage volume to find out when 
> increasing the number of possible writepoints causes write latency to 
> spike.  The flash "segment size" could be probed similarly and 
> auto-configure some of the bcachefs tunables.

More interesting to me would be finishing ZNS support - that's going to be
considerably more robust than any probing, any time there's an FTL underneath we
can't know that data is being laid out the way we want it to. Perhaps SD card
FTLs are simple enough that this could be made to work, but we'd be at the mercy
of opaque implementation details.

But if we get ZNS support finished, perhaps we could get SD card manufacturers
to start exposing that interface or something equivalent, and that should get us
not only better performance but potentially better reliability too - we'd be
able to implement proper wear leveling, something SD cards at least historically
haven't generally done.
