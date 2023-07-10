Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F3EEB64D9
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Jul 2023 13:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjGJNf4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Jul 2023 09:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbjGJNfq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Jul 2023 09:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE2112B
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 06:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688996090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PAmc4ecOrftrjqZ7O6Ja1X6W/e0yVxUxb8OKsyNZ9Go=;
        b=LpGpdf/V9CVO6XGZwMxIxFf/pdfFeMTJ/rEAQDqD+RyLL/KCpW3l4plsUEL32zPyhGA5oc
        jX5Eeu4I3PVkvqdWqiSG6GOE1KXShorOqrGOoBW2fKTvepUbM61HVcQI196HMAK+OK1gTo
        KK/B1icXgDLTqZ4PzFP8mO+h2sfL+sw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-hkrm5u4SMcePS7QzubYgVg-1; Mon, 10 Jul 2023 09:34:49 -0400
X-MC-Unique: hkrm5u4SMcePS7QzubYgVg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7623a4864c2so591123385a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 06:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688996089; x=1691588089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAmc4ecOrftrjqZ7O6Ja1X6W/e0yVxUxb8OKsyNZ9Go=;
        b=SWHEnIzUf+eK7ZhtCoXireUNu3/udKg8+qEzoJ5oB1/wEjqBVG5tnPyAZN+2Ki5ne2
         d1GYyoJyfLhCbLrC9gwfd5IOjFRdmyLFxcfT6M30IRa/ba55Mx/P4dyJzKDG4PTEk7h4
         ucbLAwQt9Ka6psxHGzBiVvPZA2N978MnKFczjjBlMBAMopxndn2p+Z7pR4DXVimixqON
         5XJ4TpKuzSMi1wkVOamouT9lLGuYF8KY7E+Q5Dlx3AkyTWCtvc4r5ZD8AaeeUmlc5Orv
         7zu54Xg9KMJ4ApW9gjab/ipU5sExKJSFdAyTbnxX5Bqx8hCzrfkqPewOUrZ5GmOA0sLM
         yL2w==
X-Gm-Message-State: ABy/qLYR7OOQMRCGgjuoG3Da6S830ktb2KSDbFqZk3Gcwp/U2i0J3LeU
        WWYL4n7wgLDMA0Bup2hsA3q8CXQMYB85rdniXy1ygT55Cpwcx5VPhnC9G4a7yuZenAON7UFkGmK
        vrST/bX8X1p2VGfIvdxc2xS9dqwXKpPaW0d0=
X-Received: by 2002:a0c:e449:0:b0:635:fb19:2ebd with SMTP id d9-20020a0ce449000000b00635fb192ebdmr11803229qvm.13.1688996088640;
        Mon, 10 Jul 2023 06:34:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG8Lf6I+q4M4paQehCCi0kRledvSIYcCRscr0ax/e0m/8QYTpYI+bSDo1CD/YKvDB/vJcHAhg==
X-Received: by 2002:a0c:e449:0:b0:635:fb19:2ebd with SMTP id d9-20020a0ce449000000b00635fb192ebdmr11803199qvm.13.1688996088086;
        Mon, 10 Jul 2023 06:34:48 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id e4-20020a0caa44000000b006300e92ea02sm5639250qvb.121.2023.07.10.06.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 06:34:47 -0700 (PDT)
Date:   Mon, 10 Jul 2023 09:37:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <ZKwJk/JBoZzizU4p@bfoster>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Jul 07, 2023 at 01:58:23PM -0400, Kent Overstreet wrote:
> On Fri, Jul 07, 2023 at 01:32:09PM -0400, Brian Foster wrote:
> > Hi Kent,
> > 
> > I'm doing some analysis of these "existing backpointer found when
> > inserting" errors observed when running generic/388 in
> > backpointers_no_use_write_buffer=1 mode. To start with context, here's
> > what I see in one particular variant of the issue...
> > 
> > We're in read bio completion path doing a CRC narrow. The commit for
> > that transaction runs trans triggers on the extent key, which then falls
> > into bch2_trans_mark_extent() and attempts backpointer updates from
> > there. I stuck a warning in the backpointer error checking code just to
> > get a stack trace for the error context, which is appended below for
> > reference.
> > 
> > On IRC Kent mentioned this was likely a trigger ordering issue and that
> > something similar was addressed in the normal backpointer write buffer
> > update path. I think I follow what's going on there from commit
> > 0a1b82456400 ("bcachefs: btree write buffer update ordering"), but the
> > context for the no write buf path seems a bit different..
> > 
> > WRT ordering, if I follow the code correctly, run_btree_triggers() in
> > the commit path basically implements an overwrite followed by !overwrite
> > pass, except if the old and new key type/triggers match we call into
> > bch2_trans_mark_key() with both the old and new keys. This calls into
> > bch2_trans_mark_extent(), which then implements an explicit insert ->
> > overwrite order. If that falls into the backpointer write buffer path,
> > that then has to reorder the updates in the write buffer by putting the
> > overwrite update at the head, presumably so it won't remove the
> > backpointer insert that is about to be added. (I assume there are
> > legitimate design reasons for the update ordering at each level here,
> > but the reordering back and forth seems like unfortunate complexity.)
> 
> You've pretty much got it, except it's !overwrite then overwrite.
> 

Hmm.. for which case? run_btree_triggers() does this:

	for (overwrite = 1; overwrite >= 0; --overwrite)

... whereas bch2_trans_mark_key() sees both keys, but uses
trigger_run_insert_then_overwrite().

> This definitely merits some documentation, how does this look to you?
> 

Agree. :)

> diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
> index f7ffd68f56..a9c6bbeebe 100644
> --- a/fs/bcachefs/btree_update_leaf.c
> +++ b/fs/bcachefs/btree_update_leaf.c
> @@ -401,6 +401,43 @@ static int btree_key_can_insert_cached(struct btree_trans *trans, unsigned flags
>  
>  /* Triggers: */
>  
> +/*
> + * Trigger ordering has some subtleties:
> + *
> + * Extent triggers will add a reference to an alloc key (for a bucket) on
> + * insert, and delete that reference when the extent is removed.
> + *
> + * When the last reference to a bucket or indirect extent is deleted, the bucket
> + * will transition states to need_discard or the indirect extent will be
> + * deleted. This means that when an extent is being moved (by e.g. the
> + * finsert/fcollapse paths, or by the reflink code turning an extent into an
> + * indirect extent), if we process the trigger for the delete before the trigger
> + * for the insert Bad Things (tm) will happen.
> + *
> + * To avoid this, we always run triggers for inserts before triggers for
> + * overwrites.
> + *

So I think you mentioned offline that this was stale reasoning (or
something). So does the above essentially refer to why extent key
triggers are ordered insert -> overwrite? If so, then I think this is
still useful content, perhaps the comment just needs to be swizzled
around a bit.

> + * There's a complication: various triggers need to see both the old and the new
> + * key at the same time, if they're keys that have the same trigger - this
> + * breaks our strict insert-before-overwrite ordering, but not in a way that
> + * breaks moving extents (XXX: why?)
> + *
> + * Additionally, we run alloc triggers last - XXX, also why?
> + *
> + * Another, related trigger ordering issue not handled here: backpointers (as
> + * well as LRU entries) are inserted/removed by triggers that do simple
> + * inserts/updates - i.e. they don't increment/decrement usage counts, like
> + * alloc key/reflink btree updates.
> + *
> + * This means they have to run in the reverse order, overwrites before inserts:
> + * but the backpointers and LRU btrees do not themselves have triggers so the
> + * delete-then-recreate issue for alloc btree references does not happen here.
> + *

This wording is a little confusing.. it's not clear to me why the lack
of ref counts directly means they have to run in reverse order. What
happens if such triggers are not run in reverse order? From the old (now
removed) ordering fix patch, I take it the issue is that a backpointer
(for example) key would be added and then immediately removed, right?

I wonder if this bit of docs would be more clear to do something like 1.
explain what specific key types have particular ordering rules (and why,
such as the reference count example given above), and then 2.  explain
why the high level trigger invocation code has the current ordering (if
it matters). I suspect the part below just goes away with that write buf
ordering patch, at least for the time being..

> + * To get the correct ordering for LRU/backpointer updates, we explicitly put
> + * the update on either the head or the tail of the list of pending updates, if
> + * it was an overwrite or an insert, respectively.
> + */
> +
>  static int run_one_mem_trigger(struct btree_trans *trans,
>  			       struct btree_insert_entry *i,
>  			       unsigned flags)
> 
> > This raises a few questions wrt the non write buffer path. First, the
> > existing bp error check lives in
> > bch2_bucket_backpointer_mod_nowritebuffer() before we even call into
> > bch2_trans_update(), so changing the order of trans updates doesn't seem
> > like it would avoid this particular error. I don't think we want to
> > change the high level order of the extent key trigger, so that means we
> > probably need to do something with the error check itself.
> 
> Yeah, I'm not sure offhand how best to fix that; it's seeing an existing
> backpointer because the update deleting it hasn't happened yet.
> 
> We can consider deleting the check - it's redundant, since we also have
> fsck. If the check worked it would be preferable to keep it, since it
> would let us catch backpointer errors when they first occured, but we
> can still look at the journal to see what tranaction commit caused the
> error even if it's not caught until fsck.
> 

Ok, that is good to know. Initially I was inundated with these errors
and so wanted to work past this first. If these are more like
overzealous checks than coherency issues, then that might be the
simplest option..

> > It also seems like this is possibly different from whatever issue lead
> > to the ordering fix in the write buf path, though I'm not quite sure how
> > that one manifests or is reproduced. A missing backpointer due to
> > unexpected bp removal, perhaps? If so, I suppose I could see why the
> > updates should be reordered in the non-buf trans, assuming the overwrite
> > would delete the just inserted bp key from the trans (and then btree on
> > commit), and perhaps I'm just not seeing that because I hit the existing
> > bp error check first.
> 
> Yeah I tend to think adding a bch2_trans_update_ordered() that matches
> the behaviour of bch2_trans_update_buffered() is the way to go - the
> whole point of the nowritebuffer path is to give us something simpler
> but with matching behaviour of the write buffer path, to aid in
> isolating bugs, so that only makes sense if they actually do behave the
> same way.
> 

I take it your follow up reply (re: the ordering patch) invalidates the
thought around bch2_trans_update_ordered(), but this is useful context
on !writebuffer nonetheless. I'll see if I can just bypass these
existing backpointer errors and narrow further in on the actual missing
bp issue...

Brian

> > So I'm still trying to piece high level things together such that an
> > appropriate fix is not yet clear to me. I'm wondering if perhaps the
> > high level (narrow crc) trans needs a flag to modify the bp checking
> > behavior to indicate we aren't actually inserting a new bp here (so
> > seeing an existing one is fine/expected), and then subsequently
> > bch2_bucket_backpointer_mod_nowritebuffer() needs to do something to
> > turn the "insert" into a bp key overwrite, and perhaps ignore the higher
> > level overwrite, or something *handwavy* along those lines.
> > 
> > I need to think about this some more, but wanted to put some thoughts
> > down in case I'm misunderstanding things or there's an obvious fix I'm
> > just not seeing yet..
> 
> I think we also need to check if my recent trigger ordering patches were
> at fault here - the rebalance_work btree trigger is going to require
> _extent_ triggers to now be "wants old and new" triggers - so I
> recently switched _all_ triggers to "wants old and new", which then
> required the write buffer ordering parameter.
> 
> I'm going to loop merge_torture_flakey on a version prior to that
> change, without the write buffer, and see what comes up.
>

