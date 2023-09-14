Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F75BEDE9B6
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 12:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbjINMTY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 08:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238119AbjINMTX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 08:19:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED5F51BE8
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 05:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694693913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m16z/ewKg95tn0la0oT2JApF9/p4f/9Xhfy6GUGRCOQ=;
        b=a+bt7OMiYjHEpE3AlHftal/GpvyGudzInjYpPtVqwaHDR74NYIc0yhEeg4uPhpOk9pYOqC
        zRuoW5cyF5YqDEomxHX4vvdakH0Ly5/YoRUAESqHu3diHW27EIKFJgHFeRB77TIRfjcsS3
        bsOdGKi3dByYXktr9uZpWIKbVQ2vw8Y=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-p82dH79ONsGZO7oLgj30mw-1; Thu, 14 Sep 2023 08:18:31 -0400
X-MC-Unique: p82dH79ONsGZO7oLgj30mw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-414bd030211so9383951cf.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 05:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694693911; x=1695298711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m16z/ewKg95tn0la0oT2JApF9/p4f/9Xhfy6GUGRCOQ=;
        b=UYfmCrc/dESHYcTfKJbaikRQlBF8f85N1TymaodfCoFrGGjebrQfBYLGJK3PoP3Has
         GK48xrkguEowhoTlFQtafNYErXlhCjjWhim8P9CCgm0VzS6PHCRY/SyEk5P/5iYWtG6b
         lN0cKysN6UIkX7uZHtWdVYM33qfVGrwWWRSIjtoEB5Q5woheKscfQs+P29myjuaysdLP
         6SONrGyjOI6yeJjBe10M1kCqhbZHXSOBsX036xB9lTH16w/JRQSWw8hjWCoxzfWQKwOt
         fedQVGkfRdHulJYbdQtaZbIwBBOPUK9LC6fOHGWDLPM3PGC/TX1V7C6mDcA4m26G+ou6
         wVHg==
X-Gm-Message-State: AOJu0YxfCZj/lbHZClqb4h/UyDb66jgT9QD6E0VsjlmK8cNTEChkhK9w
        rsdO0d3Nuappn8PG50iScd3+71xJwpgg2mAfWudlhpGlpQ7gmtxTAfww4mZ/pwum9jIR8L3JMsW
        IVR5u5DQ/UqtGxsmRXVPTy6glSVI=
X-Received: by 2002:a05:622a:1b89:b0:412:6e6:b45b with SMTP id bp9-20020a05622a1b8900b0041206e6b45bmr4606196qtb.38.1694693911313;
        Thu, 14 Sep 2023 05:18:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYwG9newgxoh8ajW4pGLxXSkaK0lHXU3KRPfceQZ6yon65N2SSR0jrRAhaTv6Z1H8bjQH/Qw==
X-Received: by 2002:a05:622a:1b89:b0:412:6e6:b45b with SMTP id bp9-20020a05622a1b8900b0041206e6b45bmr4606184qtb.38.1694693911083;
        Thu, 14 Sep 2023 05:18:31 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id j14-20020ac84f8e000000b004009f6e7e7csm417491qtw.31.2023.09.14.05.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 05:18:30 -0700 (PDT)
Date:   Thu, 14 Sep 2023 08:18:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH 9/9] bcachefs: Modify mismatched function name
Message-ID: <ZQL6ItDgXFgJyU+M@bfoster>
References: <20230914090457.32325-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914090457.32325-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 05:04:49PM +0800, Jiapeng Chong wrote:
> No functional modification involved.
> 
> fs/bcachefs/alloc_foreground.c:514: warning: expecting prototype for bch_bucket_alloc(). Prototype was for bch2_bucket_alloc_trans() instead.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6584
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---

JFYI, it seems like the patch series is oddly threaded with patch 9/9
being the "cover letter..?"

Also, what's the granularity of the patches here? Per robot filed bug?
Per source file? I don't think it really matters for this particular
series, though personally I would probably squash these down into one
upon merge (and prefer to see any further patches of this nature
similarly condensed).

Brian

>  fs/bcachefs/alloc_foreground.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
> index e02749ddc362..10a7979707ef 100644
> --- a/fs/bcachefs/alloc_foreground.c
> +++ b/fs/bcachefs/alloc_foreground.c
> @@ -502,7 +502,7 @@ static struct open_bucket *bch2_bucket_alloc_freelist(struct btree_trans *trans,
>  }
>  
>  /**
> - * bch_bucket_alloc - allocate a single bucket from a specific device
> + * bch2_bucket_alloc_trans - allocate a single bucket from a specific device
>   *
>   * Returns index of bucket on success, 0 on failure
>   */
> -- 
> 2.20.1.7.g153144c
> 

