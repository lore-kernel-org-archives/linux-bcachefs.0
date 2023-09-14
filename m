Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8C0CA553C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 12:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbjINM5b (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 08:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbjINM5a (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 08:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 832B51FD0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 05:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694696198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yA3SfK08DiRSAbnBE7MQ+ayvXnUm2HtVJvINMu1e4tw=;
        b=LSTLm4yxbP3/1bEZiLADsiW389zqo2u92YQVmVrCgwnPvVBPiZxlQrrT1y01y9hsLEXDk8
        Pz+NwVyoZ4AHgZjbtqhjqhBWkeQuN8gNVg9E4NV3CVUKBFkHyBIOkgFEtVXVxqMYZohoAh
        lzbkLHVwgmvG1Sc0lTL3D2TgB/KMyPo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-6DNQW_srMgetN-cnBMnffA-1; Thu, 14 Sep 2023 08:56:37 -0400
X-MC-Unique: 6DNQW_srMgetN-cnBMnffA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-412136f4706so9436941cf.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 05:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696196; x=1695300996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yA3SfK08DiRSAbnBE7MQ+ayvXnUm2HtVJvINMu1e4tw=;
        b=QVGXckp01hlfZ2vHg6/ar6/ToTAb3I8xGh6+3crjJK39D0rLs9lrDAFU/xZmj98KjO
         /QKLmNN0qVeI48oARgINpNpyYKrzzaKpNyV8d1L1xS3ofpCdtK2Hh2O4UxvE9Q79PBAx
         oMzAMA1lGx/lXGsa574XHhJc8DNnNWYmHDBPLUtByBGVOb9ejfF+yANSxmvG2M2EkYll
         nZb8W763kRmsD4ZKQbxIAZ/bwjnu1CoKsdENhupeXZQu6+sFJOO1CdUDDQA/lxxngIiy
         48AeDWawqmXqYnvfiaJybvhwJfOttRJfmUJF/IK+F8V/taANAfypE7g4gnslehMZhXOz
         2Aiw==
X-Gm-Message-State: AOJu0Yxg8q7kzc/gi1wuTjqxokg3Kp30sN5xYmudVBTbat+9T4bxJdF7
        Q/5BmPAK1zVdio5HvjUHfnyxrVtoAc/7yFZigsJNaE96c3Gem05evqAXR6NXBu4u0/FP1ABWHHV
        F67jmm22dm9HH3V1NtNa59WejKwI=
X-Received: by 2002:a05:622a:60b:b0:412:cd66:f65d with SMTP id z11-20020a05622a060b00b00412cd66f65dmr5638336qta.13.1694696196599;
        Thu, 14 Sep 2023 05:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVYeRw67tpdb4cHVV9/6aW6HnrU6Ue4kQnhRHfdt9mJsPUAcrvAz/AVxpfWQzQrmOh6TtKxA==
X-Received: by 2002:a05:622a:60b:b0:412:cd66:f65d with SMTP id z11-20020a05622a060b00b00412cd66f65dmr5638326qta.13.1694696196297;
        Thu, 14 Sep 2023 05:56:36 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id x20-20020ac85f14000000b00415224d1877sm436769qta.33.2023.09.14.05.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 05:56:35 -0700 (PDT)
Date:   Thu, 14 Sep 2023 08:56:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Change bucket_lock() to use bit_spin_lock()
Message-ID: <ZQMDD89w++6vnLP/@bfoster>
References: <20230914003746.1039787-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914003746.1039787-1-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hmm.. seems like something is wrong either with a mailer (yours or mine)
or the list. I initially thought I replied to this and accidentally
dropped the list cc, but now that I try again, mutt drops the list on
reply-to-all. It shows the following for the original mail, so somehow
this ends up garbled in the cc list for whatever reason.

  To: unlisted-recipients: no To-header on input <;

Anyways, here's a resend of my previous reply that unintentionally
dropped the list.

On Wed, Sep 13, 2023 at 08:37:46PM -0400, Kent Overstreet wrote:
> bucket_lock() previously open coded a spinlock, because we need to cram
> a spinlock into a single byte.
> 
> But it turns out not all archs support xchg() on a single byte; since we
> need struct bucket to be small, this means we have to play fun games
> with casts and ifdefs for endianness.
> 
> This fixes building on 32 bit arm, and likely other architectures.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: linux-bcachefs@vger.kernel.org
> ---
>  fs/bcachefs/buckets.h | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
> index f192809f50cf..e055c1076e63 100644
> --- a/fs/bcachefs/buckets.h
> +++ b/fs/bcachefs/buckets.h
> @@ -40,15 +40,35 @@ static inline size_t sector_to_bucket_and_offset(const struct bch_dev *ca, secto
>  	for (_b = (_buckets)->b + (_buckets)->first_bucket;	\
>  	     _b < (_buckets)->b + (_buckets)->nbuckets; _b++)
>  
> +/*
> + * Ugly hack alert:
> + *
> + * We need to cram a spinlock in a single byte, because that's what we have left
> + * in struct bucket, and we care about the size of these - during fsck, we need
> + * in memory state for every single bucket on every device.
> + *
> + * We used to do
> + *   while (xchg(&b->lock, 1) cpu_relax();
> + * but, it turns out not all architectures support xchg on a single byte.
> + *
> + * So now we use bit_spin_lock(), with fun games since we can't burn a whole
> + * ulong for this.
> + */
> +

Oof. :P Well I think I understand what this is doing, but it would be
helpful if this last sentence were a little more direct. For example:

"So now we use bit_spin_lock(). We can't burn a whole ulong for this, so
cast and define the lock bit such that it always lands in the b->lock
byte."

... but feel free to reword that, of course.

> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +#define BUCKET_LOCK_BITNR	0
> +#else
> +#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
> +#endif
> +
>  static inline void bucket_unlock(struct bucket *b)
>  {
> -	smp_store_release(&b->lock, 0);
> +	bit_unspin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);

This doesn't compile.. bit_spin_unlock() I assume.

Also, is there any good way to add a simple debug mode check here just
to confirm the external code does what we expect on whatever
obscure/otherwise untested arch somebody might try to use? I.e.
EBUG_ON(b->lock != 1) or some such after acquiring the lock..?

Brian

>  }
>  
>  static inline void bucket_lock(struct bucket *b)
>  {
> -	while (xchg(&b->lock, 1))
> -		cpu_relax();
> +	bit_spin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);
>  }
>  
>  static inline struct bucket_array *gc_bucket_array(struct bch_dev *ca)
> -- 
> 2.40.1
> 

