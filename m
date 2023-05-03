Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D45EC77B75
	for <linux-bcachefs@archiver.kernel.org>; Wed,  3 May 2023 14:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjECOE0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 3 May 2023 10:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjECOEZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 3 May 2023 10:04:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADE13C3C
        for <linux-bcachefs@vger.kernel.org>; Wed,  3 May 2023 07:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683122617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/X02f6oApqwhHhyVyxdeGchkXrsVccRNAYs1RpTK9Bo=;
        b=BbL5YSeeG83tPN7wwBAmEiGfgRHiVZbkpiMsoPejxId+Kc5ZQx4POOjxcE1FTPYKhADV0n
        9pV2Ud88XlAOHIiDAAijerCDPC/s0GKJiobUsKIsnbXoxBhbb53fDxsgpXzbNnwgZsUQs9
        X97Bb24W1DrUM/5HLtyFpYHwvGE6GDA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-eMzV9i1QOau6uLTWzHFm0g-1; Wed, 03 May 2023 10:03:05 -0400
X-MC-Unique: eMzV9i1QOau6uLTWzHFm0g-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-61b5f526a79so41478916d6.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 03 May 2023 07:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683122577; x=1685714577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/X02f6oApqwhHhyVyxdeGchkXrsVccRNAYs1RpTK9Bo=;
        b=jxWwDhpwIj12EQhqNVJPxIOKYXseEICeFA8ANw6yW0eJjbK9cExB+5Wm4MGHhevfUn
         Ihu1bgfzgNlA/IdUErsnnvE1632q2oEBoJE7ln9VGxziFvc15jLcgAak8sBuORNlZpdR
         OQkbHpchNwMrIRr+cTQkZF1Fa7XNQdgJhq5uxD79O34C8diBoNAGN8XBju0p+Q6etFp3
         clSE73VNCQldoPuDrGXqDk10amM0+Lf0Bn0dxOMiB3yeA1rHGjfom6QMpMu2jqhtOE0D
         ScMxuNtAmrc03vIsrmJ+5M0ntAW0uTQ6H6O7Rp4kItXZ+LBh5bYCbrS4FaTcPPZ5HNRd
         aGPw==
X-Gm-Message-State: AC+VfDxgMECDfzTIWL6ZlRGJSsKPvQ6/4vQen29FVCz+aXk/hU5F4yj8
        0J0BZen8rwu8vEY5t79zzwxlMMlDoYjBFu4gUODxWsAevcibkYPqbOKzkVUWwU/qqvewWwQVpEc
        5b8FDzCAs2xGuIQvPlb3KTofBl08=
X-Received: by 2002:a05:6214:202b:b0:5e0:3825:9ad9 with SMTP id 11-20020a056214202b00b005e038259ad9mr12246058qvf.2.1683122576925;
        Wed, 03 May 2023 07:02:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63B4oURUbWfkEp2diodqVEug9ttRixSyk4QX2UIJeipYfAX4aP1avNA2F9xgDSSw7c6IFV/Q==
X-Received: by 2002:a05:6214:202b:b0:5e0:3825:9ad9 with SMTP id 11-20020a056214202b00b005e038259ad9mr12246014qvf.2.1683122576386;
        Wed, 03 May 2023 07:02:56 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q9-20020a0ce209000000b005f5b71f75f3sm2024718qvl.125.2023.05.03.07.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 07:02:55 -0700 (PDT)
Date:   Wed, 3 May 2023 10:05:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs replica garbage collection
Message-ID: <ZFJqG43IUQIaMDMr@bfoster>
References: <ZFEjdJE8Q/wzGF7w@bfoster>
 <ZFGZMl/0GGFwajoz@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFGZMl/0GGFwajoz@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 02, 2023 at 07:13:54PM -0400, Kent Overstreet wrote:
> On Tue, May 02, 2023 at 10:58:50AM -0400, Brian Foster wrote:
> > Hi Kent,
> > 
> > I'm tracking an issue that seems to be related to bch_replica garbage
> > collection, where fsck reports the following:
> > 
> >   superblock not marked as containing replicas journal: 1/1 [1], not fixing
> > 
> > ... and the fs doesn't want to mount (until repaired).
> > 
> > The short of it looks like there's a window where we write out the sb
> > replica info with no BCH_DATA_journal usage where a shutdown/recovery
> > doesn't otherwise expect it. I've not fully root caused the problem yet,
> > but when looking into the code it looks like we have a couple different
> > mechanisms for clearing out unused replicas...
> > 
> > The "old" _start/_end mechanism handles journal data only and is invoked
> > after pin flush. I presume the start/end calls wrap marking journal dev
> > replicas to ensure usage accounting is up to date, but I'm not totally
> > sure. Is that the case?
> 
> It's not anything to do with usage accounting - we don't really do usage
> accounting for the journal, not in a way that would work for replicas
> tracking.
> 
> So the old style replicas gc mechanism that
> bch2_journal_flush_device_pins() uses is your traditional mark and sweep
> gc - clear everything, then walk and remark everything that's currently
> in use.
> 

Yeah, I think I grokked the fundamentals from the implementation. It
looks like it basically clears out the journal replica entries from the
_gc container, repopulates based on c->usage->replicas, and then updates
the sb/primary tables based on the result.

> > If so, any reason the marking via journal_write_done() isn't
> > sufficient?
> 
> This might be the bug you're looking for - the journal write path should
> be doing the marking before the write, not after.
> 

Quite possible. That certainly could be a vector to this transient
state. I'll look into it..

I am still a bit unclear on the marks in the flush path
(bch2_journal_flush_device_pins()), though. Am I following correctly
that this code marks the devices still backing journal entries? If so
and given the submit time marking, is that basically gc algorithmic
boilerplate where in context we'd expect all of those devices to already
be marked, or is there some particular situation where you'd expect that
path to mark a device that isn't already marked with journal data?

> > The "new" bch2_replicas_gc2() mechanism is invoked from various other
> > places and always propagates journal data replica entries. Is that
> > filter on journal data by design, or temporary because journal replica
> > gc is handled separately as above? If the latter, is there some explicit
> > reason the old mechanism was left around to handle journal data like
> > this?
> > 
> > As noted above, I still need to track down the root cause of the
> > unexpectedly absent journal data replica sb field. It may be agnostic to
> > either gc mechanism, but I'm trying to understand the higher level
> > situation here a bit better before getting too deep into the weeds...
> > thanks.
> 
> Applying this...
> 

ACK.. that's useful context. Thanks.

Brian

> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Tue, 2 May 2023 18:22:12 -0400
> Subject: [PATCH] bcachefs: Improved comment for bch2_replicas_gc2()
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
> index 8935ff5899..8ae50dfd8c 100644
> --- a/fs/bcachefs/replicas.c
> +++ b/fs/bcachefs/replicas.c
> @@ -550,8 +550,14 @@ int bch2_replicas_gc_start(struct bch_fs *c, unsigned typemask)
>  	return 0;
>  }
>  
> -/* New much simpler mechanism for clearing out unneeded replicas entries: */
> -
> +/*
> + * New much simpler mechanism for clearing out unneeded replicas entries - drop
> + * replicas entries that have 0 sectors used.
> + *
> + * However, we don't track sector counts for journal usage, so this doesn't drop
> + * any BCH_DATA_journal entries; the old bch2_replicas_gc_(start|end) mechanism
> + * is retained for that.
> + */
>  int bch2_replicas_gc2(struct bch_fs *c)
>  {
>  	struct bch_replicas_cpu new = { 0 };
> 

