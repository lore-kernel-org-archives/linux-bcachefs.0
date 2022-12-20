Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD95C4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 20 Dec 2022 01:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiLTB5C (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 19 Dec 2022 20:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiLTB5A (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 19 Dec 2022 20:57:00 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735B0104
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 17:56:59 -0800 (PST)
Date:   Mon, 19 Dec 2022 20:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671501418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tKl9LVKiKO5KiaPPAdyKDtE/l9Ip+rO5qq87/68yWpI=;
        b=aGs5m3K/HHIUe97/44sXpA78vqgsWWANm9Q5B0TEELUMOwnsOSrQKHwm5Hq4k7WwtoaSmg
        ia+RQrIkXXW8cZu1IKZKu+F1llPVeYP8Eg/Ftcl5ON6WOKslcC7PP5lLj1yAu6BPDFM8Np
        DLdImkYnVj+bbP16w8DgtzrTvr0iW7E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6EWZ3IODBa0e0lT@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y5wYjUhTAzhSIvM3@moria.home.lan>
 <Y6CGUZhqs5ABBIbO@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6CGUZhqs5ABBIbO@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Dec 19, 2022 at 10:42:09AM -0500, Brian Foster wrote:
> On Fri, Dec 16, 2022 at 02:04:45AM -0500, Kent Overstreet wrote:
> > On Thu, Dec 15, 2022 at 07:09:58PM -0500, Kent Overstreet wrote:
> > > I do think we could probably be doing something more than using the pid for the
> > > writepoint, I've just been waiting until we see specific workloads where the
> > > current behaviour falls over or have a specific complaint before designing
> > > something new.
> > 
> > Random late night thoughts:
> > 
> > Say we introduce a new object, 'writepoint_handle' or somesuch.
> > 
> > Allocate them when opening a file for write, close them when close the file.
> > 
> > Then we'd be explicitly picking which writepoint to use when allocating the
> > writepoint_handle; it would be easy to add logic for "if there's a writepoint
> > which was last used by this process and doesn't currently have any handles
> > pointing to it, use that".
> > 
> 
> Ok, but if we alloc the handle at open (or first write or whatever),
> we'd still need to potentially keep it around after ->release() (i.e.
> userspace close()) while the mapping is dirty and thus still needs to be
> written back, right? 

Yeah, very much just spitballing here, it's not a fully formed thought :)

> If so, perhaps this would need some additional state to track an
> "active" writepoint, explicitly defined as a "writepoint with currently
> open files" as opposed to simply a handle pointer? IOW, if the task is
> no longer writing to the previous file, it's probably Ok to reuse that
> writepoint even though the handle might still have a reference..?

Yeah, I'm envisioning explicitly allocating writepoints instead of just using a
hash function to pick them, and then when we allocate a writepoint we'd try to
pick one that isn't currently being used.

> But generally I think I get the idea: preserve the current ability for a
> single sequential writer to use the same writepoint across N files, but
> fall back to a separate writepoint where we otherwise detect multi-file
> activity. I think that makes sense, though I'd probably have to think a
> bit more about an explicit open() -> close() handle lifecycle and
> whether that's robust enough for fileserver like use cases. I.e., I'd be
> a little concerned about whether that workload might make inter-spersed
> sub-file writes look a bit too much like the single user open -> write
> -> close -> repeat use case..

If an application closes a file, perhaps that should be an explicit hint that we
don't expect more writes to it...?

> > One of the things that needs to be considered is - what do we do when there's
> > more writepoint_handles than writepoints?
> > 
> 
> Does bcachefs have to deal with something like that today? For example
> if there is some max number of writepoints, what happens if there might
> be some greater number of tasks doing allocations at the same time?

There's a hardcoded number of writepoints (32, IIRC?) - if we have more tasks
doing writes than writepoints then writes are going to end up interspresed.

We have to be careful about increasing this or making it dynamic, since it's
inherently pinning other resources - although when the filesystem is very nearly
full there's code to steal from other writepoints, so we're not deadlocking
because all our free space is stranded on other writepoints.
