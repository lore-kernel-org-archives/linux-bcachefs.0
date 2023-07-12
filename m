Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6D2C0015E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 16:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjGLQu2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjGLQu1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 12:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A14411B
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 09:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689180575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=81Gk2azL+Ks4i6ALINfln2LesEg26vuGFxrRHW2NT14=;
        b=H3vFmT6dJe+XAT2569vLLy+YJG9v3/rbdK4oudH98uD6TsK8Eb2qKuxSYdx6vUCzaDdO+F
        gKKFTIl14VoV4kGM6DYcIRs4P/7HY5fGLTE5ZcGQYLkXEg0qpPKV8ER4C+61kIquHJU/c1
        fVBWzM/iVaFHIYTZiVA1FepwksXFlJM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-Ok1e5iSHORedQtZkysn0Bw-1; Wed, 12 Jul 2023 12:49:34 -0400
X-MC-Unique: Ok1e5iSHORedQtZkysn0Bw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7623d5cb0caso812958485a.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 09:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689180573; x=1691772573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81Gk2azL+Ks4i6ALINfln2LesEg26vuGFxrRHW2NT14=;
        b=lipeF8/TwM7qd+I/vahrmwpKb9E4Nkuu75FvYr3XMWfATU6J22lWK8Adyz6y6AY7QJ
         RZ/NwhxxNiphbweZmpLAJ4Kb2morpZn+fSBPz5ySFRPep+RdaXasbSAnTWT1wKm+K00I
         cP7sGfBP43mbQwgku1O5dPZiQNXNnqJqAS4GxhPPcQNDlhC39Igab0FZTSPis7bHJKLZ
         LLfN1JAL2KU0SJ7pz4ALRDCQXsadExEnL2x41uRVIvU2wARC/FEmNGIUrwvmgxIVSmyy
         0YSwJT9TyvQ3RmihsAjsYnL6sjLF6cTbkVRD4ml9HR4GkGKZ8Dwa6h+7zWISh9PL+TLZ
         nAfg==
X-Gm-Message-State: ABy/qLbODtKqqpJylJWH4L5EoMW0vAO1/ohs29DQEFjmUeg8wDDtSnMd
        dxEWhOsfzamnI7AUI1PA6L+HnXNmad/i1+QW+2RX4qKTWkDyTLzLVSvwPSE+xUO0BFRstgprC7K
        nbiZJgUQeJSHNsOZl8VnlLnqVMvlRlgJEanQ=
X-Received: by 2002:a05:620a:390f:b0:767:3c06:d1b9 with SMTP id qr15-20020a05620a390f00b007673c06d1b9mr19005759qkn.72.1689180573194;
        Wed, 12 Jul 2023 09:49:33 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEivBGmcmSWWzOnQZGEyb9UezYGw0L9ULkPy7l9x5/MFi3UULaMCZTnAf7uS2hmT0HPO1cACQ==
X-Received: by 2002:a05:620a:390f:b0:767:3c06:d1b9 with SMTP id qr15-20020a05620a390f00b007673c06d1b9mr19005747qkn.72.1689180572869;
        Wed, 12 Jul 2023 09:49:32 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id j6-20020a0cf306000000b00635dd8a2ca9sm2297853qvl.60.2023.07.12.09.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:49:32 -0700 (PDT)
Date:   Wed, 12 Jul 2023 12:52:14 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <ZK7aPhB9QV+56R/J@bfoster>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
 <ZKwJk/JBoZzizU4p@bfoster>
 <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
 <ZK7AMu6MBLoLX8vJ@bfoster>
 <20230712154047.hqw7rdwjxasjvsdn@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712154047.hqw7rdwjxasjvsdn@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:40:47AM -0400, Kent Overstreet wrote:
> On Wed, Jul 12, 2023 at 11:01:06AM -0400, Brian Foster wrote:
> > Yep. I think I have a general idea of what's going on here. The first
> > thing I realized after looking through some tracing was that this seems
> > to correlate with the non-fast fallback paths for write buffer flushing.
> > For example, if I unconditionally redirect wb key flushes to the
> > trans_commit path in flush_one(), that 1. dramatically increases the
> > reproduction rate and 2. also reproduces a similar issue for lru
> > entries. I think the only reason we don't reproduce the lru variant of
> > the problem with generic/388 alone is that I don't see nearly as many
> > lru updates as backpointer updates, and so the workload just doesn't
> > happen to facilitate it.
> 
> Fantastic :)
> 
> I just pulled dynamic fault injection into the bcachefs tree - to make
> sure this path gets tested better in the future we can add a
> dynamic_fault("race") here.
> 
> (first, I have to dust off the fault injection test integration...)
> 
> > With that, I tweaked my kernel to unconditionally redirect backpointer
> > btree updates to the non-fast flush paths for debug purposes. From
> > there, I've seen a few different variants of the problem that I think
> > just happen to relate to the different extent modifying operations that
> > fsstress happens to be running. The most simple example that describes
> > the fundamental problem is as follows:
> > 
> > 1. Extent allocated and associated bp inserted to write buffer index 0.
> > 2. Flush begins on idx 0, active idx switches to 1.
> > 3. Previously alloc'd extent is deleted. Associated deleted bp key
> > inserted to buffer idx 1.
> > 4. Flush of idx 0 lands on the initial bp key for the extent. The
> > trans_commit path rejournals the key for the backpointer btree update.
> > 5. The fs shuts down. Recovery finds the key updates in the order they
> > were journaled by this sequence (update->delete->update), which doesn't
> > match the actual runtime changes of the extent btree (update->delete).
> > This puts an entry in the backpointers btree that doesn't reflect
> > reality.
> > 
> > So essentially the current rejournaling by the non-fast write buffer
> > flush paths creates an on-disk journal ordering inconsistency wrt
> > changes in associated btrees.
> 
> Yep, sounds like you nailed it.
> 
> > I tried to skip journaling in the write buffer flush commit path as a
> > quick experiment, but that doesn't work on its own because we can then
> > lose key updates in the journal held by the write buffer pin. I.e., the
> > tail of the journal can then move past the key before it's been updated
> > in the btree because the latter update hasn't journaled it (this results
> > in similar backpointer errors and I can see the key getting lost by
> > looking at list_journal vs. list_journal -a).
> 
> Correct
> 
> > OTOH, it looks like the fast flush path gets this right without
> > rejournaling because it adds a pin to the btree buffer based on the seq
> > of the already journaled key. IIUC, this essentially allows the btree
> > update to refer to the journal entry created when the key was inserted
> > into the write buffer. I'm wondering if the right way to fix this is to
> > allow the trans update/commit path to basically do the same thing. I.e.,
> > somehow or another allow a trans update of an already journaled key to
> > inherit the seq of the key for a btree pin rather than explicitly
> > rejournal it at the current seq of the transaction. Thoughts?
> 
> I think that could work.
> 
> What if the entry being flushed is already at the tail of the journal,
> and journal reclaim is already trying to flush everything at that
> sequence number? Since we'll often have multiple write buffer keys per
> journal entry, and per btree node, this might lead to btree nodes
> getting flushed multiple times redundantly.
> 

I think I follow what you mean, but isn't this what the fast path is
doing already? (Not to say that it isn't a potential issue to be aware
of.)

BTW, I haven't dug much into the btree code... If a btree node has a
bunch of pins of different sequence numbers for whatever key updates are
pending, is the whole set flushed out on the first pin flush (releasing
all pins)? Or is it an incremental flush to update keys just up to the
specified pin seq?

> I suspect this would only happen in artificial circumstances - it'll be
> based on the ratio of write buffer size:journal size - so if we add a
> slowpath tracepoint/counter, and make sure to to some testing where we
> provoke this condition that'll be sufficient.
> 
> Maybe write a small journal, large write buffer test?
> 

Yeah, I was wondering if/what sort of non-default configuration might
more reliably reproduce this issue. That sounds like something to try.

> I was also looking at adding the same "skip rejournalling" optimization
> to key cache flushing - this could take care of that too.
> 

Indeed. Even if that is an optimization for key cache vs. more of a
correctness issue for write buffer, it sounds like quite a bit of
functional overlap.

Anyways, I'll see if I can prototype something to verify whether this
addresses the backpointer issue before getting too far into the weeds.
;) Thanks for the feedback.

Brian

