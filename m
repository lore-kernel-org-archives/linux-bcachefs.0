Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574B0C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 21:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjEIVyd (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 17:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjEIVyd (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 17:54:33 -0400
Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE7E30C4
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 14:54:31 -0700 (PDT)
Date:   Tue, 9 May 2023 17:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683669269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1n3YMxW+Zb7xSLAr/eeZIRD4PtBRt8sxu+5EqSQhpSY=;
        b=DnM8qOmeFjElK/7kmR9lrk8seVkOltc4T81yq9nzxwJ0tWrpzuZjphK0O0rFxUZuREoLjH
        4BGrtcWLzxP0pNXP/Rrv20VFYXzZePCsv+ToELAp1vj4npjoYANBuaQ9qfSjDvpQsbPq+u
        I+IxdbTG3un3iPQvVU9g3Lw60JsigXg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH 07/32] mm: Bring back vmalloc_exec
Message-ID: <ZFrBEsjrfseCUzqV@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-8-kent.overstreet@linux.dev>
 <ZFqxEWqD19eHe353@infradead.org>
 <ZFq3SdSBJ_LWsOgd@murray>
 <20230509214319.GA858791@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509214319.GA858791@frogsfrogsfrogs>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 09, 2023 at 02:43:19PM -0700, Darrick J. Wong wrote:
> On Tue, May 09, 2023 at 02:12:41PM -0700, Lorenzo Stoakes wrote:
> > On Tue, May 09, 2023 at 01:46:09PM -0700, Christoph Hellwig wrote:
> > > On Tue, May 09, 2023 at 12:56:32PM -0400, Kent Overstreet wrote:
> > > > From: Kent Overstreet <kent.overstreet@gmail.com>
> > > >
> > > > This is needed for bcachefs, which dynamically generates per-btree node
> > > > unpack functions.
> > >
> > > No, we will never add back a way for random code allocating executable
> > > memory in kernel space.
> > 
> > Yeah I think I glossed over this aspect a bit as it looks ostensibly like simply
> > reinstating a helper function because the code is now used in more than one
> > place (at lsf/mm so a little distracted :)
> > 
> > But it being exported is a problem. Perhaps there's another way of acheving the
> > same aim without having to do so?
> 
> I already trolled Kent with this on IRC, but for the parts of bcachefs
> that want better assembly code than whatever gcc generates from the C
> source, could you compile code to BPF and then let the BPF JIT engines
> turn that into machine code for you?

It's an intriguing idea, but it'd be a _lot_ of work and this is old
code that's never had a single bug - I'm not in a hurry to rewrite it.

And there would still be the issue that we've still got lots of little
unpack functions that go with other tables; we can't just burn a full
page per unpack function, that would waste way too much memory, and if
we put them together then we're stuck writing a whole nother allocator
- nope, and then we're also mucking with the memory layout of the data
structures used in the very hottest paths in the filesystem - I'm very
wary of introducing performance regressions there.

I think it'd be much more practical to find some way of making
vmalloc_exec() more palatable. What are the exact concerns?
