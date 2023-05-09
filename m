Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703FBC77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 21:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjEIVkU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 17:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbjEIVkU (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 17:40:20 -0400
Received: from out-63.mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29C9C9
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 14:40:18 -0700 (PDT)
Date:   Tue, 9 May 2023 17:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683667754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7BLmDLz3BiMEr2LiLldeMxPISO3gLTAAmsfZ3LAk8jY=;
        b=VsfqGbr4zmcegdCNeOps8Tym8iTSXsp82l46/RQQeimltbUGVyaxe0SRmZCKkOhjp/WOGo
        6STHO1rpPpMOgnZ2guu4NVaqHLb0JSo5iwlLOvqhpgKezzpIXgHuBYtnYwjflDEofwV98s
        Hz6z9dW8EYVZ3k7IfvXGRc55GJUSZS4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH 07/32] mm: Bring back vmalloc_exec
Message-ID: <ZFq7JhrhyrMTNfd/@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-8-kent.overstreet@linux.dev>
 <ZFqxEWqD19eHe353@infradead.org>
 <ZFq3SdSBJ_LWsOgd@murray>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFq3SdSBJ_LWsOgd@murray>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 02:12:41PM -0700, Lorenzo Stoakes wrote:
> On Tue, May 09, 2023 at 01:46:09PM -0700, Christoph Hellwig wrote:
> > On Tue, May 09, 2023 at 12:56:32PM -0400, Kent Overstreet wrote:
> > > From: Kent Overstreet <kent.overstreet@gmail.com>
> > >
> > > This is needed for bcachefs, which dynamically generates per-btree node
> > > unpack functions.
> >
> > No, we will never add back a way for random code allocating executable
> > memory in kernel space.
> 
> Yeah I think I glossed over this aspect a bit as it looks ostensibly like simply
> reinstating a helper function because the code is now used in more than one
> place (at lsf/mm so a little distracted :)
> 
> But it being exported is a problem. Perhaps there's another way of acheving the
> same aim without having to do so?

None that I see.

The background is that bcachefs generates a per btree node unpack
function, based on the packed format for that btree node, for unpacking
keys within that node. The unpack function is only ~50 bytes, and for
locality we want it to be located with the btree node's other in-memory
lookup tables so they can be prefetched all at once.

Here's the codegen:

https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/bkey.c#n727
