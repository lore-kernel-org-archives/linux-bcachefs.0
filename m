Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6247ECD5BCA
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 14:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbjISOcO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjISOcN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 10:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DFDDD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 07:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695133886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lz9YUo7v9YE7Tx2bRFlzIsrMPIwsTgzeUQryYswyeIc=;
        b=XkpjZCQKs5Sf95Gt2yAIptezBAOorzTpoczBTwPWgVE59z2yqGmNuewgCVunoF3J4AWTER
        VPMmbXCLqFISROZdKnO8KkR05F/ksJ1oXNERiY/W7joF/jdCnZPHyiP6UvfV9Kt+RoP/fd
        3qpK34Yu4ZEDs4pnQlR5rKwTHjQK4Mw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-i1OTJoqxPkOBbq9V1c1pIw-1; Tue, 19 Sep 2023 10:31:24 -0400
X-MC-Unique: i1OTJoqxPkOBbq9V1c1pIw-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-65825867403so17815826d6.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 07:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695133883; x=1695738683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lz9YUo7v9YE7Tx2bRFlzIsrMPIwsTgzeUQryYswyeIc=;
        b=IM4aGX/gP2PZ6Nv8PxaC4cu7PYFu++MP8MlgTe5B19eO0sNUGV1aPMbMI6wcO/FI1m
         QdLo4PirpVhF2wY+lLpry5PL8DNCwiZ/WwQf+m02xa/wlzKSu8h55hbyE2Ujc6aGlub+
         gZshxZjrXH19IcVKz+mv0PldqZ4/3y6P6dE2Fkz+k7WNK2qgaJ7cmyKPEfoWl17JFCzM
         SO0dZ/NfnbKoW1oeajSYL6DA0N7RRDbt7IcW3ooBLnlc4nIR2yNPllqCzNZCawrAS3Qe
         VkVV4Je/UHQLVFYKq9T34Aj47pQ8348w5FI263VW9dmb9LrzQ3za7NbiN5JZoRWGq/2T
         2Jrg==
X-Gm-Message-State: AOJu0Yz8aEdVhwteoH/u7ZsbFnR5uTOz9bNqPYNP2UFZkCFQ+8xkHeKL
        6QWmlbSUKOZEe1bADwU1FveqWVFtJA/+7kEYHbQ+gT0/Wyfp8/NH4YfzkSNDw8ppV4fIBeWxo+7
        eWxWQt09ZgFPD1r4sQGa7V3vyszZIP7kh3mc=
X-Received: by 2002:a0c:e9c1:0:b0:653:5bed:83d4 with SMTP id q1-20020a0ce9c1000000b006535bed83d4mr12711876qvo.30.1695133883459;
        Tue, 19 Sep 2023 07:31:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCC04yjVNvbbPbXz4VXfz4YDdTfZgzDJ4aVVWpokwpf42ZLs+vCKg8GhliHfdsxeQ5GjynTA==
X-Received: by 2002:a0c:e9c1:0:b0:653:5bed:83d4 with SMTP id q1-20020a0ce9c1000000b006535bed83d4mr12711863qvo.30.1695133883256;
        Tue, 19 Sep 2023 07:31:23 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id r1-20020a0c9e81000000b00653589babcbsm3655850qvd.87.2023.09.19.07.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 07:31:22 -0700 (PDT)
Date:   Tue, 19 Sep 2023 10:31:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Change bucket_lock() to use bit_spin_lock()
Message-ID: <ZQmwymI1SfIyouFM@bfoster>
References: <20230914003746.1039787-1-kent.overstreet@linux.dev>
 <ZQMDD89w++6vnLP/@bfoster>
 <20230914194706.to2wdiipcjxy44v2@moria.home.lan>
 <ZQQ3Fo3PWwWphcmz@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQQ3Fo3PWwWphcmz@bfoster>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Sep 15, 2023 at 06:51:02AM -0400, Brian Foster wrote:
> On Thu, Sep 14, 2023 at 03:47:06PM -0400, Kent Overstreet wrote:
> > On Thu, Sep 14, 2023 at 08:56:47AM -0400, Brian Foster wrote:
> > > > +/*
> > > > + * Ugly hack alert:
> > > > + *
> > > > + * We need to cram a spinlock in a single byte, because that's what we have left
> > > > + * in struct bucket, and we care about the size of these - during fsck, we need
> > > > + * in memory state for every single bucket on every device.
> > > > + *
> > > > + * We used to do
> > > > + *   while (xchg(&b->lock, 1) cpu_relax();
> > > > + * but, it turns out not all architectures support xchg on a single byte.
> > > > + *
> > > > + * So now we use bit_spin_lock(), with fun games since we can't burn a whole
> > > > + * ulong for this.
> > > > + */
> > > > +
...

Hi Kent,

So FYI reviewing this prompted me to do some "less common" arch testing
on s390x. bcachefs format currently fails in this environment, which
prompted the couple of related byte ordering patches I've posted (also
susceptible to the problem fixed by this bucket lock patch). The most
recent [1] seems rather closely related to this one as it pertains to
how bit_spin_lock() and friends work in userspace. Still no unspin
locking use case I'm afraid ;P, but curious on your thoughts on that
one..

Brian

[1] https://lore.kernel.org/linux-bcachefs/20230919142611.36445-1-bfoster@redhat.com/

