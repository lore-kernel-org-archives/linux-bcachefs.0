Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D346E7E643
	for <linux-bcachefs@archiver.kernel.org>; Tue, 26 Sep 2023 14:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjIZOmy (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbjIZOmx (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 26 Sep 2023 10:42:53 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7897C121
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:42:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-532c66a105bso10341017a12.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Sep 2023 07:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695739365; x=1696344165; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7xm82wFz4V1bzcbVORQIAoicoXL8HhdPjGxAZwqe1TY=;
        b=FOyPbAxbfT4THJxizR69zl1W/ha4L2D05dRpp5d8C3UH8YmoAdHMXY1Q9zwC4+4BIE
         IOk7kn9AKUDEOZO/xC1ptK7YYmxeYLkHZo0k6JRHxOYnqZhP1BZX3vLR4ApkmnkqzEIm
         hI3peGcNrgxJh6CQM0kT3fXtSYo9ycz+BRPQ7oL16JkleaAsVHAx5Op0NKEHsfAl7Cym
         3b+cJYoPTRFVobHqHTs7J79BfHLqUN6Y0icDlabficITv7G96hVJsfDvGZ83r7/USUSM
         VfkHQRCWN+eAlSvTFDQ/P02x8244uGCfMa0tf+xFIhVQ4DUBQIfl0rPiQRsnnVCKduIr
         OYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695739365; x=1696344165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xm82wFz4V1bzcbVORQIAoicoXL8HhdPjGxAZwqe1TY=;
        b=U6vjtCynGAaalBiHpjov32Yda6urr9Vj3bmnrR/epNYqszDizRq8jWZzGWm6pakn1l
         rcrxJfV2ipwNOuv6jZAcwX/SocGpkqbF5/4HIAwClMio2j4vDVA4+1CiqmhpLSyiEo1v
         gFBt30ZHfL43/7W1ezc1/d3HpjUx1i/BttoaF97nR9MOUK6x7xHoGFVxLgfcju3iLoSr
         Ftbq0z7LhLEIz1dZMpCNwlc0NB5JQNikQYa2ek6fEq4MVl3R6y9LFfIkRCvRxYvx54fC
         cIvpGGPo/PsFeN7O8iC9g6vDLWmbVJMjgVP357znFP3Rhee55/r3Q8kILgAK0Gxej3fk
         dISA==
X-Gm-Message-State: AOJu0YzBp29zWMHP90MrWu5Ui5Gck99UzsWqpFGyg3XI+wcwA+4Mkj5/
        EAqa/75XA79yQMIgD2RsKbUrewnvJWYbEbrpSco=
X-Google-Smtp-Source: AGHT+IFuz4hWc74IHBCK5PQ3lHZhDjgzz6ojg1CE8IPCRiq9C55Tg8e86Ed+uIXBdo5P30GDdACqLQ==
X-Received: by 2002:aa7:c542:0:b0:532:e39b:8c05 with SMTP id s2-20020aa7c542000000b00532e39b8c05mr7269617edr.42.1695739364937;
        Tue, 26 Sep 2023 07:42:44 -0700 (PDT)
Received: from localhost (h3221.n1.ips.mtn.co.ug. [41.210.178.33])
        by smtp.gmail.com with ESMTPSA id c19-20020a056402121300b0052e9b50dafdsm6810744edw.33.2023.09.26.07.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 07:42:44 -0700 (PDT)
Date:   Tue, 26 Sep 2023 17:42:40 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: debug: Fix copy_to_user() error code in
 flush_buf()
Message-ID: <686bdcb4-c872-4d95-82b6-c6813cd56de2@kadam.mountain>
References: <3036fd4e-5d22-44f2-9f51-6eb137452984@moroto.mountain>
 <20230919211209.5zc422kjdquql35e@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919211209.5zc422kjdquql35e@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 05:12:09PM -0400, Kent Overstreet wrote:
> On Fri, Sep 15, 2023 at 03:56:26PM +0300, Dan Carpenter wrote:
> > The copy_to_user() function returns the number of bytes remaining to
> > be copied but we want to return -EFAULT to the user.
> > 
> > Fixes: e0750d947352 ("bcachefs: Initial commit")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >  fs/bcachefs/debug.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
> > index 404148bd348a..e65c0ab0c9ad 100644
> > --- a/fs/bcachefs/debug.c
> > +++ b/fs/bcachefs/debug.c
> > @@ -319,10 +319,9 @@ static ssize_t flush_buf(struct dump_iter *i)
> >  {
> >  	if (i->buf.pos) {
> >  		size_t bytes = min_t(size_t, i->buf.pos, i->size);
> > -		int err = copy_to_user(i->ubuf, i->buf.buf, bytes);
> >  
> > -		if (err)
> > -			return err;
> > +		if (copy_to_user(i->ubuf, i->buf.buf, bytes))
> > +			return -EFAULT;
> >  
> >  		i->ret	 += bytes;
> >  		i->ubuf	 += bytes;
> > -- 
> > 2.39.2
> > 
> 
> Applying this fix instead:
> 
> >From 60a714b71846c3ea95ccad6699658890b24969c2 Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Tue, 19 Sep 2023 17:09:22 -0400
> Subject: [PATCH] bcachefs: Fix copy_to_user() usage in flush_buf()
> 
> copy_to_user() returns the number of bytes successfully copied - not an
> errcode.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 

Perfect.  Thanks!

regards,
dan carpenter

