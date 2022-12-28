Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B586C4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed, 28 Dec 2022 22:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiL1WbB (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 28 Dec 2022 17:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiL1Wa7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 28 Dec 2022 17:30:59 -0500
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Dec 2022 14:30:58 PST
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A674725F7
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Dec 2022 14:30:58 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 707A045;
        Wed, 28 Dec 2022 14:24:52 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id nRle1sy3Yqpe; Wed, 28 Dec 2022 14:24:48 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EEDDB40;
        Wed, 28 Dec 2022 14:24:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net EEDDB40
Date:   Wed, 28 Dec 2022 14:24:45 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@linux.dev>
cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
In-Reply-To: <Y6EWZ3IODBa0e0lT@moria.home.lan>
Message-ID: <1bfa9aed-44c1-8217-9d6a-a594524ab0a0@ewheeler.net>
References: <20221212190602.1388127-1-bfoster@redhat.com> <20221213183743.3m6ntfnu7n3yebng@moria.home.lan> <Y5oLlLcHmS2EWp8n@bfoster> <Y5u3VlkA3AbhQKav@moria.home.lan> <Y5wYjUhTAzhSIvM3@moria.home.lan> <Y6CGUZhqs5ABBIbO@bfoster>
 <Y6EWZ3IODBa0e0lT@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, 19 Dec 2022, Kent Overstreet wrote:
> On Mon, Dec 19, 2022 at 10:42:09AM -0500, Brian Foster wrote:
> > On Fri, Dec 16, 2022 at 02:04:45AM -0500, Kent Overstreet wrote:
> > > On Thu, Dec 15, 2022 at 07:09:58PM -0500, Kent Overstreet wrote:
> > > > I do think we could probably be doing something more than using the pid for the
> > > > writepoint, I've just been waiting until we see specific workloads where the
> > > > current behaviour falls over or have a specific complaint before designing
> > > > something new.
> > > 
> > > Random late night thoughts:
> > > 
> > > Say we introduce a new object, 'writepoint_handle' or somesuch.
> > > 
> > > Allocate them when opening a file for write, close them when close the file.
> > > 
> > > Then we'd be explicitly picking which writepoint to use when allocating the
> > > writepoint_handle; it would be easy to add logic for "if there's a writepoint
> > > which was last used by this process and doesn't currently have any handles
> > > pointing to it, use that".
> > > 
> > 
> > Ok, but if we alloc the handle at open (or first write or whatever),
> > we'd still need to potentially keep it around after ->release() (i.e.
> > userspace close()) while the mapping is dirty and thus still needs to be
> > written back, right? 
> 
> Yeah, very much just spitballing here, it's not a fully formed thought :)
> 
> > If so, perhaps this would need some additional state to track an
> > "active" writepoint, explicitly defined as a "writepoint with currently
> > open files" as opposed to simply a handle pointer? IOW, if the task is
> > no longer writing to the previous file, it's probably Ok to reuse that
> > writepoint even though the handle might still have a reference..?
> 
> Yeah, I'm envisioning explicitly allocating writepoints instead of just using a
> hash function to pick them, and then when we allocate a writepoint we'd try to
> pick one that isn't currently being used.
> 
> > But generally I think I get the idea: preserve the current ability for a
> > single sequential writer to use the same writepoint across N files, but
> > fall back to a separate writepoint where we otherwise detect multi-file
> > activity. I think that makes sense, though I'd probably have to think a
> > bit more about an explicit open() -> close() handle lifecycle and
> > whether that's robust enough for fileserver like use cases. I.e., I'd be
> > a little concerned about whether that workload might make inter-spersed
> > sub-file writes look a bit too much like the single user open -> write
> > -> close -> repeat use case..
> 
> If an application closes a file, perhaps that should be an explicit hint that we
> don't expect more writes to it...?
> 
> > > One of the things that needs to be considered is - what do we do when there's
> > > more writepoint_handles than writepoints?
> > > 
> > 
> > Does bcachefs have to deal with something like that today? For example
> > if there is some max number of writepoints, what happens if there might
> > be some greater number of tasks doing allocations at the same time?
> 
> There's a hardcoded number of writepoints (32, IIRC?) - if we have more tasks
> doing writes than writepoints then writes are going to end up interspresed.
> 
> We have to be careful about increasing this or making it dynamic, since it's
> inherently pinning other resources - although when the filesystem is very nearly
> full there's code to steal from other writepoints, so we're not deadlocking
> because all our free space is stranded on other writepoints.

This reminds me of an LWN article I read many years ago about how SD cards 
handle "open segments" in their FTL:
	https://lwn.net/Articles/428584/

	"Restrictions on open segments: One major difference between
	the various [sdcard] manufacturers is how many segments they
	can write to at any given time.  Starting to write a segment
	requires another physical segment, or two in case of a data
	logging algorithm, to be reserved, and requires some RAM on the
	embedded microcontroller to maintain the segment. Writing to a
	new segment will cause garbage collection on a previously open
	segment. That can lead to thrashing as the drive must repeatedly
	switch open segments"

SD cards are often used on today's low-end embedded ARM hardware for 
during prototyping (such as Raspberry Pi and others), so this may still be 
relevant today.  If bcachefs is capable of operating with very few 
writepoints (ie, if max writepoints were configurable), then it may 
perform much better on low-end SD cards.

Making the bcachefs bucket size equal to the segment size would help a 
lot, I'm sure, but this data is rarely published by manufacturers.  
However, it can be probed:
	https://git.linaro.org/people/arnd/flashbench.git/about/

It might be useful to make the writepoints limit configurable at mkfs 
time.  mkfs could even probe the storage volume to find out when 
increasing the number of possible writepoints causes write latency to 
spike.  The flash "segment size" could be probed similarly and 
auto-configure some of the bcachefs tunables.

Anyway, food for thought.

--
Eric Wheeler


 
