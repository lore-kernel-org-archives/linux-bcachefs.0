Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D47C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Thu,  4 May 2023 14:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjEDOKI (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 4 May 2023 10:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbjEDOKG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 4 May 2023 10:10:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9113B86A6
        for <linux-bcachefs@vger.kernel.org>; Thu,  4 May 2023 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683209359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tGLT+BYosY502uGT4Ey2SNRKUTRg4ruLXgqQ1qmpQYg=;
        b=CwmURhnoiGMTOlBqdT/KNEYAy9c3nI/QudIXfBmnrmDG7nmm8JNHq0i+P8CX8R7K8FJjnW
        ZSt+aO4ictF7RTJ1vbgtR3IQY3MMVM6IWLPK+e6xX5yiv1F9lmDL467AliLxQxdSWMEbHI
        v4N5fBlC2JR0Udho+oQ8zh+aABI9RKw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-B56parM0PsOEAzlB0O-Vqw-1; Thu, 04 May 2023 10:09:18 -0400
X-MC-Unique: B56parM0PsOEAzlB0O-Vqw-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-74e47b6e044so26752385a.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 04 May 2023 07:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683209357; x=1685801357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGLT+BYosY502uGT4Ey2SNRKUTRg4ruLXgqQ1qmpQYg=;
        b=OwAf9ba/ZBBhOkOzKtQV47ZZ7L2QsTcPUz++5QjhjB0fJ3ykc/EpkAFCEvx6GuuC01
         8WoWpIzZnMCymIOZo8rQeRhe4EhUQZlgpBPxaJ5jFPah4CF1rmOWHhgBNAltC8bS4zxb
         arswjz8k7XgdUhS6NRH7U+GgyhVgm6za8DKxa7SRBvB5pzxLONmI5Kpg5ozGWDEODSL3
         Rrgce6Z0hAeITkHnyCns9iyRqKPS74DZbWtmZEUH6oPhn4SGcEkvOlDeAB27TpBT6aPd
         1Os2zD1yEWLkYSWb9Tjvj1oo6PMXFDtKXqUDF8nn1r9E4q7SB86aYRt0zPXyeG3QBZIo
         Ivvw==
X-Gm-Message-State: AC+VfDwbpKSd+xq8MRlIkjVsdIf2beVVUcJmpZiq+JbStoqr1A6HvbFb
        jnICdUvmOa1Oo8KbOVWcbuOUgsqrwQ+0P3I4C0R26OjW2pMUlG/Wkdw3KeDnqDfThV+k7Ye2w5g
        KKZmJCc7TyQELqcR5Pp/dDq8LwfuZLOjJGvI=
X-Received: by 2002:a05:6214:1307:b0:5ef:8c79:fe99 with SMTP id pn7-20020a056214130700b005ef8c79fe99mr17740095qvb.7.1683209357387;
        Thu, 04 May 2023 07:09:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ByPFKB7x7DAMpZLTETw6PPMa8KHCIEq6J9AOiAtYLDPN0pwXtSqryAYE6Rp+R+tSV2d9Hlw==
X-Received: by 2002:a05:6214:1307:b0:5ef:8c79:fe99 with SMTP id pn7-20020a056214130700b005ef8c79fe99mr17740037qvb.7.1683209356775;
        Thu, 04 May 2023 07:09:16 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id f14-20020a0caa8e000000b0061b5b399d1csm3245780qvb.104.2023.05.04.07.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 07:09:16 -0700 (PDT)
Date:   Thu, 4 May 2023 10:11:37 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs replica garbage collection
Message-ID: <ZFO9GVPHLyyFJO6P@bfoster>
References: <ZFEjdJE8Q/wzGF7w@bfoster>
 <ZFGZMl/0GGFwajoz@moria.home.lan>
 <ZFJqG43IUQIaMDMr@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFJqG43IUQIaMDMr@bfoster>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 03, 2023 at 10:05:15AM -0400, Brian Foster wrote:
> On Tue, May 02, 2023 at 07:13:54PM -0400, Kent Overstreet wrote:
> > On Tue, May 02, 2023 at 10:58:50AM -0400, Brian Foster wrote:
> > > Hi Kent,
> > > 
> > > I'm tracking an issue that seems to be related to bch_replica garbage
> > > collection, where fsck reports the following:
> > > 
> > >   superblock not marked as containing replicas journal: 1/1 [1], not fixing
> > > 
> > > ... and the fs doesn't want to mount (until repaired).
> > > 
> > > The short of it looks like there's a window where we write out the sb
> > > replica info with no BCH_DATA_journal usage where a shutdown/recovery
> > > doesn't otherwise expect it. I've not fully root caused the problem yet,
> > > but when looking into the code it looks like we have a couple different
> > > mechanisms for clearing out unused replicas...
> > > 
> > > The "old" _start/_end mechanism handles journal data only and is invoked
> > > after pin flush. I presume the start/end calls wrap marking journal dev
> > > replicas to ensure usage accounting is up to date, but I'm not totally
> > > sure. Is that the case?
> > 
> > It's not anything to do with usage accounting - we don't really do usage
> > accounting for the journal, not in a way that would work for replicas
> > tracking.
> > 
> > So the old style replicas gc mechanism that
> > bch2_journal_flush_device_pins() uses is your traditional mark and sweep
> > gc - clear everything, then walk and remark everything that's currently
> > in use.
> > 
> 
> Yeah, I think I grokked the fundamentals from the implementation. It
> looks like it basically clears out the journal replica entries from the
> _gc container, repopulates based on c->usage->replicas, and then updates
> the sb/primary tables based on the result.
> 
> > > If so, any reason the marking via journal_write_done() isn't
> > > sufficient?
> > 
> > This might be the bug you're looking for - the journal write path should
> > be doing the marking before the write, not after.
> > 
> 
> Quite possible. That certainly could be a vector to this transient
> state. I'll look into it..
> 

Just a note on this bit.. I made a change to mark for the journal before
the journal write, but still managed to hit this problem. It was
slightly harder to reproduce, so I suspect there might just be a couple
different instances of the problem.

AFAICT from looking at the mount time recovery code, it pretty much
expects to see at least one device marked for journal data so long as
the filesystem is not clean. It looks like clean state is removed at
mount time and restored during clean unmount, so that means we probably
don't ever want to have this "no devices marked with journal data" state
at runtime.

However, this is exactly what I see from the journal gc mechanism
invoked during device evacuate or remove. On an otherwise idle fs, the
gc sees no journal usage and clears every replica entry for journal data
on the fs. The next journal writes fairly quickly restore new entries
for unrelated replicas, so this appears to be a small window of
opportunity. But indeed, a quick hack to instrument this path and
shutdown the fs during that window makes it trivial to reproduce the
subsequent mount failure.

Given all of the above context and that this only seems to be invoked
via data job paths, I think this variant can be fixed by simply
tightening up the filtering in bch2_replicas_gc_start() to also consider
the target device. IOW, if the device flush only sweeps out replica
entries for which the target device is a participant, we won't ever have
this transient (!clean && no journal replicas) state that leads to mount
failure in the event of a crash.

So unless that all sounds like a Bad Idea(tm), I'm planning to give
something like that some testing..

Brian

> I am still a bit unclear on the marks in the flush path
> (bch2_journal_flush_device_pins()), though. Am I following correctly
> that this code marks the devices still backing journal entries? If so
> and given the submit time marking, is that basically gc algorithmic
> boilerplate where in context we'd expect all of those devices to already
> be marked, or is there some particular situation where you'd expect that
> path to mark a device that isn't already marked with journal data?
> 
> > > The "new" bch2_replicas_gc2() mechanism is invoked from various other
> > > places and always propagates journal data replica entries. Is that
> > > filter on journal data by design, or temporary because journal replica
> > > gc is handled separately as above? If the latter, is there some explicit
> > > reason the old mechanism was left around to handle journal data like
> > > this?
> > > 
> > > As noted above, I still need to track down the root cause of the
> > > unexpectedly absent journal data replica sb field. It may be agnostic to
> > > either gc mechanism, but I'm trying to understand the higher level
> > > situation here a bit better before getting too deep into the weeds...
> > > thanks.
> > 
> > Applying this...
> > 
> 
> ACK.. that's useful context. Thanks.
> 
> Brian
> 
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> > Date: Tue, 2 May 2023 18:22:12 -0400
> > Subject: [PATCH] bcachefs: Improved comment for bch2_replicas_gc2()
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > 
> > diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
> > index 8935ff5899..8ae50dfd8c 100644
> > --- a/fs/bcachefs/replicas.c
> > +++ b/fs/bcachefs/replicas.c
> > @@ -550,8 +550,14 @@ int bch2_replicas_gc_start(struct bch_fs *c, unsigned typemask)
> >  	return 0;
> >  }
> >  
> > -/* New much simpler mechanism for clearing out unneeded replicas entries: */
> > -
> > +/*
> > + * New much simpler mechanism for clearing out unneeded replicas entries - drop
> > + * replicas entries that have 0 sectors used.
> > + *
> > + * However, we don't track sector counts for journal usage, so this doesn't drop
> > + * any BCH_DATA_journal entries; the old bch2_replicas_gc_(start|end) mechanism
> > + * is retained for that.
> > + */
> >  int bch2_replicas_gc2(struct bch_fs *c)
> >  {
> >  	struct bch_replicas_cpu new = { 0 };
> > 

