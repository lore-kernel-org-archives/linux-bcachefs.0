Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEFDC4332F
	for <linux-bcachefs@archiver.kernel.org>; Tue, 13 Dec 2022 18:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiLMSpr (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 13 Dec 2022 13:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiLMSpo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 13 Dec 2022 13:45:44 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 10:45:18 PST
Received: from out-213.mta0.migadu.com (out-213.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A16124F21
        for <linux-bcachefs@vger.kernel.org>; Tue, 13 Dec 2022 10:45:18 -0800 (PST)
Date:   Tue, 13 Dec 2022 13:38:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670956716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0jKc7pW6uA/CYHDG4rCs1T4LwOO/8p+4ev8AVY3ZjoI=;
        b=JSgcvhAoPc+QB1A7arPGU6ldA1t0RyaY61XJqPnwPdfdOQ+kshRoJWVjkl50LKiD+YvDCh
        lqm5h+DnbgMJoglqbSqzhwa6dfIGEpI/KJy71iVw0cc94kdBJkcNNlJTLYsbqf+Yiy58qj
        vdv2XEwoKMIS4IbKbyxIsvfoAqXqnPg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212190602.1388127-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Dec 12, 2022 at 02:06:02PM -0500, Brian Foster wrote:
> Use the pointer to the current in-core inode object as the hash of
> the write point associated with block allocation for buffered
> writes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi bcachefs folks,
> 
> I'm posting this RFC more as a discussion point than a direct proposal.
> I've been poking around a bit at bcachefs just to grok some of the
> basics and whatnot and ended up digging down into the block allocation
> code a bit. From there I was trying to make sense of the bucket and
> write point abstractions, and then noticed that the write point
> structure used to track allocation/write contexts is hashed by task.
> IIUC, that means a single task that might be writing to multiple files
> will do so via a single write point, or conversely multiple tasks that
> might be writing to a single file would do so with multiple write points
> (one associated with each task). In turn, that means the allocation
> layout of a particular file might be a characteristic of the set of
> tasks that initially wrote the file as opposed to something more
> traditional based on inode locality.
> 
> In thinking about this a bit more, it seems logical that this derives
> from bcache because it seems like a perfectly good cache allocation
> policy. I suppose it might make sense in certain filesystem workloads
> where per-file contiguity might no longer necessarily be the most
> important thing in the world, but I'm curious if that is intentional for
> bcachefs (the approach is documented, after all) and if there are any
> particular workloads or use cases in mind for that sort of approach?
> 
> Even if it makes sense in some cases, I wonder whether it's the ideal
> approach across the board. For example, consider how the task is tracked
> through the inode from buffered write to writeback contexts so the
> latter can locate the write point for the last task that wrote to the
> file. Even if multiple tasks perform buffered writes to a file, we only
> really use the last task that wrote to the file before the current
> writeback cycle. Absent frequent writebacks, wouldn't it make some sense
> to just associate the write point with the current inode pointer and use
> that to minimize per-inode fragmentation?

Fundamentally, what we're doing is trying to preserve locality, the idea is that
data written by the same process is likely related and should be written out
together.

Consider a cp -r of many small files, or any sort of process that's writing out
to many small files. Using the pid for the writepoint preserves locality, using
the inode number would not.

> FWIW, I was able to run some oddball workloads that produce excessive
> fragmentation by forcing frequent writeback activity, but my tests so
> far are ad hoc and moreso just playing around to help understand
> behavior. To be fair, more traditional filesystems don't necessarily
> handle the same sort of tests terribly well either. What I found more
> interesting is that with the small tweak from this RFC, the allocation
> layout from bcachefs went from notably worse to notably better in that
> kind of pathological workload. Thoughts?

Could you describe more what you were seeing and what the changes were? I think
there is room for improvement here, but we're going to have to carefully think
about and describe what we're trying to acheive.

It's not clear to me how this would have an effect at all in the test you're
describing; forcing frequent writebacks is going to hurt in a COW filesystem,
since every write is an allocation - need more information here.
