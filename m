Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB07CDB47E
	for <linux-bcachefs@archiver.kernel.org>; Fri, 13 Oct 2023 12:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjJMMpN (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 13 Oct 2023 08:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjJMMpN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 13 Oct 2023 08:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74BFBD
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 05:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697201065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3fXt2DVf96cg1S0m6SaEQq/Yuj8WjwbFTNMAMBhB9Q=;
        b=Mn0ftJ/4P+VtbDs3iZ2vS+6O0RmI70TKeASieNfISiJ6pP54h5dUf6F5yria1UgTEiPlq5
        D5jMw5ATquHBWysBfg7IdJPzztEcgcH137G2Jlcqvcn0w+a7w1RHc3xMfU164lCi64QLwF
        I+dgJdSyX0pr9ic95nci7typyw/twLY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-UT-qq1YfP8qqSeElhTumsQ-1; Fri, 13 Oct 2023 08:44:14 -0400
X-MC-Unique: UT-qq1YfP8qqSeElhTumsQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-66d03dcdc6bso22705316d6.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Oct 2023 05:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697201053; x=1697805853;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+3fXt2DVf96cg1S0m6SaEQq/Yuj8WjwbFTNMAMBhB9Q=;
        b=iEfh85XG/bzCID2bYuk/jy3qwV14vCVRJEmAQMYhYlEOQIoaCBQcylR6hyuxvBJlPV
         mufjJANCHcNq2UV7iBi5Id4kjSkYb4Oodh+SXQhyLhGI3wLIa4kqIkDhjbjI1E70ASc7
         6KBSePzsadaTAkVObWLoIzQ3EgTrGzn7/jrJOsOKIP/2FppKtyDnb3vySXtKtr1o99Hh
         yI4vkb5FCeGFY6NK0/AENYJoiKqSh1agA1uW9WEiIjnE0EECLbFWFg/HZYNHMMcbaBv0
         mdkKBgVZufqYiJLf0O5wMWXfluzm9Nem8JXTYaNtjsMNjDyw62R5umIjY+KK4cHEXkIK
         rKyQ==
X-Gm-Message-State: AOJu0YwZ3yVQ33Qzx+kEv2Oc/0F4Qe2XJEZB6H8ZWAMNwQd2hfDF+dwS
        Du2s2/tIzfoWE9vpbQ2zNDgy9dW1EMJdY2WaYamhtjk3CjUMC9jQ/ayEMQ+i9EikQd4KR0Qp3Wg
        KAxESI6NodPMS4TtWaUc551Q9ERHuJhCm+0k=
X-Received: by 2002:ad4:5ba3:0:b0:66d:2fda:c9e0 with SMTP id 3-20020ad45ba3000000b0066d2fdac9e0mr522814qvq.61.1697201053381;
        Fri, 13 Oct 2023 05:44:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHN/QAjroxFuZ0aSPQFyzVehzUSHj1mpbManmdgsOS3pHTd1qeHbLKy53uq6saZDb984xjQSA==
X-Received: by 2002:ad4:5ba3:0:b0:66d:2fda:c9e0 with SMTP id 3-20020ad45ba3000000b0066d2fdac9e0mr522796qvq.61.1697201053079;
        Fri, 13 Oct 2023 05:44:13 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id du10-20020a05621409aa00b0065d105f6931sm642305qvb.59.2023.10.13.05.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Oct 2023 05:44:12 -0700 (PDT)
Date:   Fri, 13 Oct 2023 08:44:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Daniel J Blueman <daniel@quora.org>
Cc:     Coly Li <colyli@suse.de>, linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: trans path overflow during metadata replication with lockdep
Message-ID: <ZSk7tq/4Ah8EE2an@bfoster>
References: <CAMVG2sun2sqFXt=H-0cVWnATGMMFpe-0ksRWy3uhUZXbA5m1qA@mail.gmail.com>
 <72438765-AD46-4C8A-975F-982223CE7A40@suse.de>
 <ZSkk0W9Dk5q5hUge@bfoster>
 <CAMVG2svBFVkjnEJRdC5H=uXxL6T_mYH8XdQQcBrUP7mqrsh61Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMVG2svBFVkjnEJRdC5H=uXxL6T_mYH8XdQQcBrUP7mqrsh61Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Oct 13, 2023 at 07:52:54PM +0800, Daniel J Blueman wrote:
> On Fri, 13 Oct 2023 at 19:06, Brian Foster <bfoster@redhat.com> wrote:
> > On Tue, Oct 10, 2023 at 11:20:59PM +0800, Coly Li wrote:
> > > Forward it to linux-bcachefs@vger.kenrel.org <mailto:linux-bcachefs@vger.kenrel.org>
> > >
> > > > 2023年10月10日 07:43，Daniel J Blueman <daniel@quora.org> 写道：
> > > >
> > > > Firstly, bcachefs introduces a new era of in-tree filesystems with
> > > > some monumental features (sorry, ZFS); hats off to Kent for landing
> > > > this!
> > > >
> > > > My testing finds it is in great shape; far better than BTRFS was when
> > > > it landed. Testing on linux next-20231005 with additional debug checks
> > > > atop the Ubuntu 23.04 kernel generic config [1], I was able to provoke
> > > > a btree trans path overflow cornercase [2].
> >
> > Thanks for testing and for the bug report. I'm curious what kind of
> > testing you've been doing in general and perhaps if you have any more
> > interesting results to share? ;)
> 
> Thanks for asking Brian! My validation seeks to exercise edge cases by
> triggering multiple conditions in parallel, then working backwards to
> identify a minimal and reliable reproducer.
> 
> I'll prepare a post with additional early findings in the coming days.
> 
> > > > The minimal reproducer is:
> > > > # modprobe brd rd_nr=2 rd_size=1048576
> > > > # bcachefs format --metadata_replicas=2 --label=tier1.1 /dev/ram0
> > > > --label=tier1.2 /dev/ram1
> > > > # mount -t bcachefs /dev/ram0:/dev/ram1 /mnt
> > > > # dd if=/dev/zero of=/mnt/test bs=128M
> > > >
> > > > The issue doesn't reproduce with metadata_replicas=1 or a single block device.
> >
> > My naive assumption would be that the higher replica count increases the
> > size of some of these transactions due to having to update multiple
> > devices, but this is not an area I've dug into in depth tbh. I've not
> > seen this yet myself, but I think most of the multi device testing I've
> > done so far has still been with replicas=1.
> 
> With the stock Ubuntu kernel config (no CONFIG_LOCKDEP, likely similar
> to your codebase), my testing eventually provoked a crash; I'll see if
> I can reproduce this later in case it's the same path as this report
> with CONFIG_LOCKDEP.
> 

Ah, Ok. It would be interesting to know whether LOCKDEP is more of an
overhead or timing contributing factor (as opposed to functional).

> > > > At debug entry, I couldn't determine why BTREE_ITER_MAX must be 64
> > > > rather than 32 when CONFIG_LOCKDEP is set, however the panic doesn't
> > > > occur without CONFIG_LOCKDEP, so it appears related; keeping it at
> > > > value 32 with CONFIG_LOCKDEP doesn't prevent the panic also.
> > > >
> > > > @Kent/anyone?
> >
> > Hmm, that is interesting. I'm not sure why lockdep would be a factor
> > here. Where did you come up with the notion that ITER_MAX could be 32
> > (and the idea to test it) with CONFIG_LOCKDEP=y? It looks like it's
> > hardcoded to 64, but perhaps I'm missing something.
> 
> See https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/fs/bcachefs/btree_types.h#n390
> 
> #ifndef CONFIG_LOCKDEP
> #define BTREE_ITER_MAX 64
> #else
> #define BTREE_ITER_MAX 32
> #endif
> 

Oh, I was looking at the master branch. I didn't realize this was
different in for-next. That looks like a relatively old commit as well.
Kent might have to chime in on what the deal is with that.

So my guess would be that this is a bit of a whack-a-mole between
accommodating lockdep and workloads that stress the transaction data
structure in this way. For the purposes of your testing, I think it's
probably more useful to either set this to 64 (and accept the more
graceful lockdep overflow situation) or just disable lockdep and confirm
whether things work correctly.

For the purposes of bcachefs, I think this means that either this
setting is not suitable for !BCACHEFS_DEBUG kernels (regardless of
lockdep state) or alternatively that handling of this limit condition
needs to be improved to be more graceful one way or another, because we
probably don't want to trade the lockdep overflow behavior (which IIRC
just splats and disables lockdep) for a kernel panic in most cases.

Brian

> > We'll see if Kent can make more sense of the crash signature whenever
> > he's back around. Otherwise I'll make a note to try and reproduce it
> > once I work through some other things...
> 
> It would be good to get some independent confirmation on this.
> 
> Thanks again!
>   Dan
> -- 
> Daniel J Blueman
> 

