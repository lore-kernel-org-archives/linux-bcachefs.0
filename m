Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F34EEAA6A
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 19:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjINTrP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 15:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjINTrP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 15:47:15 -0400
Received: from out-215.mta1.migadu.com (out-215.mta1.migadu.com [IPv6:2001:41d0:203:375::d7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8707D2698
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 12:47:10 -0700 (PDT)
Date:   Thu, 14 Sep 2023 15:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694720828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IF4IY4I5Frrl58bpsq7SQWhjB1XulFaBAMhS5Jy15O4=;
        b=MnqOxq3aQB9V3ZdTcrkBWJtzVbOdv8ybhIvLTJyxuU6b7VCTt3kv8eoW15ecJhvq++0L/Y
        oziOaVbmETMYd0eISBkxZr43SsvTmqpJ5bfjrDqTTvijYxcZKSDjMVFBDNPd9sxIsm5IRg
        Lm+dHPo+EEopGkCAf082UEcOr5H+Lgw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Change bucket_lock() to use bit_spin_lock()
Message-ID: <20230914194706.to2wdiipcjxy44v2@moria.home.lan>
References: <20230914003746.1039787-1-kent.overstreet@linux.dev>
 <ZQMDD89w++6vnLP/@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQMDD89w++6vnLP/@bfoster>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 08:56:47AM -0400, Brian Foster wrote:
> > +/*
> > + * Ugly hack alert:
> > + *
> > + * We need to cram a spinlock in a single byte, because that's what we have left
> > + * in struct bucket, and we care about the size of these - during fsck, we need
> > + * in memory state for every single bucket on every device.
> > + *
> > + * We used to do
> > + *   while (xchg(&b->lock, 1) cpu_relax();
> > + * but, it turns out not all architectures support xchg on a single byte.
> > + *
> > + * So now we use bit_spin_lock(), with fun games since we can't burn a whole
> > + * ulong for this.
> > + */
> > +
> 
> Oof. :P Well I think I understand what this is doing, but it would be
> helpful if this last sentence were a little more direct. For example:
> 
> "So now we use bit_spin_lock(). We can't burn a whole ulong for this, so
> cast and define the lock bit such that it always lands in the b->lock
> byte."
> 
> ... but feel free to reword that, of course.

yeah, that's good

> 
> > +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> > +#define BUCKET_LOCK_BITNR	0
> > +#else
> > +#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
> > +#endif
> > +
> >  static inline void bucket_unlock(struct bucket *b)
> >  {
> > -	smp_store_release(&b->lock, 0);
> > +	bit_unspin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);
> 
> This doesn't compile.. bit_spin_unlock() I assume.

that's what I get for writing code right before my flight. Now I'm going
to have to try to think of a legit usage for unspin_lock() :)

> Also, is there any good way to add a simple debug mode check here just
> to confirm the external code does what we expect on whatever
> obscure/otherwise untested arch somebody might try to use? I.e.
> EBUG_ON(b->lock != 1) or some such after acquiring the lock..?

How about:

union ulong_byte_assert {                                                                                                                                                                                                                                                                
        ulong   ulong;                                                                                                                                                                                                                                                                   
        u8      byte;                                                                                                                                                                                                                                                                    
};

BUILD_BUG_ON(!((union ulong_byte_assert) { .ulong = 1UL << BUCKET_LOCK_BITNR }).byte);                                                                                                                                                                                           

