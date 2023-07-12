Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE8FEB64D9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 14:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjGLO7Q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 10:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjGLO7N (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 10:59:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1521BC6
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 07:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689173908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aK50yDgPfj2SqTfveHZpuPhrJIKGy+9FvleIB3QxyfA=;
        b=ZNLUu+n7sNm2c1qyOse0sv3MQcnf2dZUyviliPj/YRZbrlcNLEJoaV4CirjjC5/yj7qo6Z
        OXfYf0tJhWYyr3rKqDTvgbk20l4/BT6CkK/6Kqr4sXtHZgD6a3SacVQZ6VSO1DwZ/pCrvc
        lQP/Xkl95SZDQfQPqZKlVLSR15ZAedo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-oqdFKJd-Mku7ym6FIVmrgA-1; Wed, 12 Jul 2023 10:58:26 -0400
X-MC-Unique: oqdFKJd-Mku7ym6FIVmrgA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-635e91cba88so79709646d6.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 07:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689173906; x=1691765906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aK50yDgPfj2SqTfveHZpuPhrJIKGy+9FvleIB3QxyfA=;
        b=ac1JFKjOMwB6Dl0K4UxJcWKNy92nAlf9DH+sWn3gVAqEVlK4xKAr98LUqLmzLX9eEQ
         8G6Tj6KJYX0wL8Y8VUkrJT3l4Z9zkOXbwgNxQN5HWZ83NDOn5iVCM2mQkXUBNF0fefrr
         1s5WMljP/JJlESnxV8S5vyKp83pSoRvJF6EAKxh033eP8LLED6G6fxL0Wa9uXeCrm659
         RtYoQcA4BstSQ7H6TwC3Jh9SvHPaqJxJwWbKVei4iN2n2xcZSptRcEkTeBoUM/oDztkS
         AZn69Syk7H7LTj19pTYVHiLc2KUl/u7VtN50fiT+1TFSeOznIvdcu8VfAZC+pqcHsyYs
         RKAQ==
X-Gm-Message-State: ABy/qLZgxuPZEKdgPfR9waFegCw/IkMD8jl8It4DlxxSk9z4cBp+seOf
        l9yudk0fQZrvHQxyf4SBXjFlZF5vhvqZyZhV56+i84N6EfxSVzPHgdiw0N1jbJcrf4fCEy1iLOP
        rAGCrjfv2z4ROQplf8M1TSFhZTt6QkI9eymw=
X-Received: by 2002:a0c:8f11:0:b0:635:f3db:52b3 with SMTP id z17-20020a0c8f11000000b00635f3db52b3mr18046418qvd.25.1689173906059;
        Wed, 12 Jul 2023 07:58:26 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEznUtCrc8LgNDN2o19ds47tnP5wdoM7G1v6UF9UauGOjJy9Ddfm3GQiD/5xMP34P07+B/8qA==
X-Received: by 2002:a0c:8f11:0:b0:635:f3db:52b3 with SMTP id z17-20020a0c8f11000000b00635f3db52b3mr18046408qvd.25.1689173905684;
        Wed, 12 Jul 2023 07:58:25 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x20-20020a0cda14000000b00636047c276csm2243548qvj.126.2023.07.12.07.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 07:58:25 -0700 (PDT)
Date:   Wed, 12 Jul 2023 11:01:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs backpointers errors in no write buf mode
Message-ID: <ZK7AMu6MBLoLX8vJ@bfoster>
References: <ZKhMGZBokKMq5p1P@bfoster>
 <20230707175823.3tct7p2blqrzr7wo@moria.home.lan>
 <ZKwJk/JBoZzizU4p@bfoster>
 <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710145646.3vzxwzvrbbmxc57h@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Jul 10, 2023 at 10:56:46AM -0400, Kent Overstreet wrote:
> On Mon, Jul 10, 2023 at 09:37:23AM -0400, Brian Foster wrote:
> > This wording is a little confusing.. it's not clear to me why the lack
> > of ref counts directly means they have to run in reverse order. What
> > happens if such triggers are not run in reverse order? From the old (now
> > removed) ordering fix patch, I take it the issue is that a backpointer
> > (for example) key would be added and then immediately removed, right?
> > 
> > I wonder if this bit of docs would be more clear to do something like 1.
> > explain what specific key types have particular ordering rules (and why,
> > such as the reference count example given above), and then 2.  explain
> > why the high level trigger invocation code has the current ordering (if
> > it matters). I suspect the part below just goes away with that write buf
> > ordering patch, at least for the time being..
> 
> Yeah, that sounds like a better documentation approach.
> 
> I'll work up a new patch (and try to do some git spelunking to make sure
> I remember all the context).
> 
> > > Yeah I tend to think adding a bch2_trans_update_ordered() that matches
> > > the behaviour of bch2_trans_update_buffered() is the way to go - the
> > > whole point of the nowritebuffer path is to give us something simpler
> > > but with matching behaviour of the write buffer path, to aid in
> > > isolating bugs, so that only makes sense if they actually do behave the
> > > same way.
> > > 
> > 
> > I take it your follow up reply (re: the ordering patch) invalidates the
> > thought around bch2_trans_update_ordered(), but this is useful context
> > on !writebuffer nonetheless. I'll see if I can just bypass these
> > existing backpointer errors and narrow further in on the actual missing
> > bp issue...
> 
> Yeah, it turned out the recent trigger ordering patches were definitely
> to blame. With those patches yanked, I was able to run the
> merge_torture_flakey test for ~24 hours in
> backpointers_no_use_write_buffer mode - and with the write buffer on,
> we're not hitting the "backpointer not found" errors as often as we were
> before.
> 

Ok, I realized after the fact that those patches caused the runtime
bp errors. I've not seen them since those patches were removed.

> So we probably need to think a bit more about what happens differently
> when the write buffer is in use; we're doing exactly the same updates,
> but flushing them to the btree is a bit delayed and the ordering is
> different. I think we need to hone in on that.
> 

Yep. I think I have a general idea of what's going on here. The first
thing I realized after looking through some tracing was that this seems
to correlate with the non-fast fallback paths for write buffer flushing.
For example, if I unconditionally redirect wb key flushes to the
trans_commit path in flush_one(), that 1. dramatically increases the
reproduction rate and 2. also reproduces a similar issue for lru
entries. I think the only reason we don't reproduce the lru variant of
the problem with generic/388 alone is that I don't see nearly as many
lru updates as backpointer updates, and so the workload just doesn't
happen to facilitate it.

With that, I tweaked my kernel to unconditionally redirect backpointer
btree updates to the non-fast flush paths for debug purposes. From
there, I've seen a few different variants of the problem that I think
just happen to relate to the different extent modifying operations that
fsstress happens to be running. The most simple example that describes
the fundamental problem is as follows:

1. Extent allocated and associated bp inserted to write buffer index 0.
2. Flush begins on idx 0, active idx switches to 1.
3. Previously alloc'd extent is deleted. Associated deleted bp key
inserted to buffer idx 1.
4. Flush of idx 0 lands on the initial bp key for the extent. The
trans_commit path rejournals the key for the backpointer btree update.
5. The fs shuts down. Recovery finds the key updates in the order they
were journaled by this sequence (update->delete->update), which doesn't
match the actual runtime changes of the extent btree (update->delete).
This puts an entry in the backpointers btree that doesn't reflect
reality.

So essentially the current rejournaling by the non-fast write buffer
flush paths creates an on-disk journal ordering inconsistency wrt
changes in associated btrees.

I tried to skip journaling in the write buffer flush commit path as a
quick experiment, but that doesn't work on its own because we can then
lose key updates in the journal held by the write buffer pin. I.e., the
tail of the journal can then move past the key before it's been updated
in the btree because the latter update hasn't journaled it (this results
in similar backpointer errors and I can see the key getting lost by
looking at list_journal vs. list_journal -a).

OTOH, it looks like the fast flush path gets this right without
rejournaling because it adds a pin to the btree buffer based on the seq
of the already journaled key. IIUC, this essentially allows the btree
update to refer to the journal entry created when the key was inserted
into the write buffer. I'm wondering if the right way to fix this is to
allow the trans update/commit path to basically do the same thing. I.e.,
somehow or another allow a trans update of an already journaled key to
inherit the seq of the key for a btree pin rather than explicitly
rejournal it at the current seq of the transaction. Thoughts?

Brian

