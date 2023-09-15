Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C03EE6456
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 10:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjIOKwb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234270AbjIOKwT (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 06:52:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01B8ACE5
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 03:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694775053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WwFGm5TkUVvKFFRQjnBdYrn3J+fNrKov99XejNhvpy4=;
        b=geMK1j9HTOuPo8EScUvPN+tVxfIbjNc4HAQQoNJxQ2hD1Rxj/x/FJYXLpUuNT7zJFStpzE
        regUiHLmeVU1t3A6hOQRYd9OYWrwy0okgpewoh7zZC9iWwwWCa6R0HxBfxRkvWfqncddYZ
        YnS4kNA8bjgB2G4QKIh9HQMgtRtRe6c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-ssywg8yUPb2XvTo9nrYCoA-1; Fri, 15 Sep 2023 06:50:51 -0400
X-MC-Unique: ssywg8yUPb2XvTo9nrYCoA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76dcf1d8905so247951185a.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 03:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694775050; x=1695379850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwFGm5TkUVvKFFRQjnBdYrn3J+fNrKov99XejNhvpy4=;
        b=F0YLyYlqq3JaCnZPgdFtHBr5EeFIUGHlBtFpd9QHLqZboIPtuffwjKW1FQexaKn6mk
         zu/LDr5Yqcea9AxbWjnpQGi/Urnqucxbhlq8En1YLDYx8a6mWIZZr1TOcPh6r8WRvYkS
         tPQLl2Fhcu1Y5ECy7mY9xl/KmbCiddj+oJkgXZaoONrKqR/W4dhQLePvwsgqLW/MZV0o
         7NUZ07VjbjbhXAiRRup/cQOntIk1a61acfGOSBx5DEQ66Z2ebdGBWZtbRZbz1OU1gn8e
         ThMA87BVXxB0E62LWSDGLjCYFw/Heby/VvUyTBtg8acKCIYBX2dr/me80adSGyBwRiiX
         ElVw==
X-Gm-Message-State: AOJu0Yxn4NkijqsaKvvCkT0ya4oiTOoeQpNjL8+fJTGLxhGmtgD4+3Kq
        TERWK0XDQtkIIJvqb12k4cE9yn7Zt0f1c/27RFCz2Vm9pWiBqCJNJnnrr7ZVtw0Lhg+2iH2Ps/i
        m8IejfhieqF9irVENc6L6QeD/zyLoXzNZ2Y8=
X-Received: by 2002:a05:620a:404a:b0:76f:1272:2aa8 with SMTP id i10-20020a05620a404a00b0076f12722aa8mr1069605qko.6.1694775050723;
        Fri, 15 Sep 2023 03:50:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFHCslrejGj3sCEBOEAD8fsAGLVVM0TLgJASkOpMgv5x/UvGtxUOXzFxP8p91ZTxKClC6p1xw==
X-Received: by 2002:a05:620a:404a:b0:76f:1272:2aa8 with SMTP id i10-20020a05620a404a00b0076f12722aa8mr1069591qko.6.1694775050463;
        Fri, 15 Sep 2023 03:50:50 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id i16-20020a05620a145000b00767721aebc0sm1144353qkl.32.2023.09.15.03.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:50:50 -0700 (PDT)
Date:   Fri, 15 Sep 2023 06:51:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Change bucket_lock() to use bit_spin_lock()
Message-ID: <ZQQ3Fo3PWwWphcmz@bfoster>
References: <20230914003746.1039787-1-kent.overstreet@linux.dev>
 <ZQMDD89w++6vnLP/@bfoster>
 <20230914194706.to2wdiipcjxy44v2@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914194706.to2wdiipcjxy44v2@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 03:47:06PM -0400, Kent Overstreet wrote:
> On Thu, Sep 14, 2023 at 08:56:47AM -0400, Brian Foster wrote:
> > > +/*
> > > + * Ugly hack alert:
> > > + *
> > > + * We need to cram a spinlock in a single byte, because that's what we have left
> > > + * in struct bucket, and we care about the size of these - during fsck, we need
> > > + * in memory state for every single bucket on every device.
> > > + *
> > > + * We used to do
> > > + *   while (xchg(&b->lock, 1) cpu_relax();
> > > + * but, it turns out not all architectures support xchg on a single byte.
> > > + *
> > > + * So now we use bit_spin_lock(), with fun games since we can't burn a whole
> > > + * ulong for this.
> > > + */
> > > +
> > 
> > Oof. :P Well I think I understand what this is doing, but it would be
> > helpful if this last sentence were a little more direct. For example:
> > 
> > "So now we use bit_spin_lock(). We can't burn a whole ulong for this, so
> > cast and define the lock bit such that it always lands in the b->lock
> > byte."
> > 
> > ... but feel free to reword that, of course.
> 
> yeah, that's good
> 
> > 
> > > +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> > > +#define BUCKET_LOCK_BITNR	0
> > > +#else
> > > +#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
> > > +#endif
> > > +
> > >  static inline void bucket_unlock(struct bucket *b)
> > >  {
> > > -	smp_store_release(&b->lock, 0);
> > > +	bit_unspin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);
> > 
> > This doesn't compile.. bit_spin_unlock() I assume.
> 
> that's what I get for writing code right before my flight. Now I'm going
> to have to try to think of a legit usage for unspin_lock() :)
> 

Heh. :)

> > Also, is there any good way to add a simple debug mode check here just
> > to confirm the external code does what we expect on whatever
> > obscure/otherwise untested arch somebody might try to use? I.e.
> > EBUG_ON(b->lock != 1) or some such after acquiring the lock..?
> 
> How about:
> 
> union ulong_byte_assert {                                                                                                                                                                                                                                                                
>         ulong   ulong;                                                                                                                                                                                                                                                                   
>         u8      byte;                                                                                                                                                                                                                                                                    
> };
> 
> BUILD_BUG_ON(!((union ulong_byte_assert) { .ulong = 1UL << BUCKET_LOCK_BITNR }).byte);                                                                                                                                                                                           
> 

Nice idea. I like the build time check much better. Thanks!

Brian

