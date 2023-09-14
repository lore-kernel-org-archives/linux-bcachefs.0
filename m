Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 003CFEDE9A4
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 11:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbjINLvG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 07:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjINLvF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 07:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F35EACC3
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 04:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694692215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zqlm9iMBtNS1PjmHaJ9GqgopJ/ckxwBCFE8E9Iz3HQc=;
        b=N2AAPhkr787HuAC61QMbv/RPCiYObym7Z8ODfal7ypk9dX/F81FXvhzwPW+Jgb39b3hNK0
        wvUxtIW7I/Msg4uJfWsw7Py+YJYtL4wXYRIQNajn8r6JVarSKCD2nzeOHYn+Fvn65BRkV9
        eJu1Po87h8mTyz9e2nsoDr38nSGTbKI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-YzZDw5XGP4S9MdGQMdVqyg-1; Thu, 14 Sep 2023 07:50:13 -0400
X-MC-Unique: YzZDw5XGP4S9MdGQMdVqyg-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-412ede7897aso9045761cf.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 04:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694692213; x=1695297013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqlm9iMBtNS1PjmHaJ9GqgopJ/ckxwBCFE8E9Iz3HQc=;
        b=Vm2rBo9kZF7yBqAkdlAsxK1G1Q/j02AaJMEWS8EOp2mte2YVtjooH39XxJWGp68K/X
         rcDUPHf0vJjp63f2I7muvz6eNPBo0g7L9GQ95jqNXaDCEzitb2Oy5Als12FPHUy5zAgu
         NJbKssmLsvWw18FnraUp/ZYe9D6UpMMXSwIY2NneGmuqaz9FKczQZhT8bmvA3AEPKDDr
         B/NUlnGTBEa6dWRbYy+4yDxMuqjcOr6ZD6JNZgPiV+euPKZoeqH1J+9b7ZtG4qqzIZP2
         vWTffCirvVT9OPPJhdqIXtRJ/bXzA7rGWsVRXqyFIzcwnUrfzii0U6vxaK81cRquBe6h
         smnA==
X-Gm-Message-State: AOJu0YyJbGAPrbLhNoopT9ud0mqilwrioLAbLp/INTHjo+ds0guu+9UD
        HwM4PdlTETix8x/5+1xB6AveyKHiRZSlc58LNVCnR/fzCyYnW8lhs2qpltWW5+ng4PzCThkyol7
        3NogMvggbwUVv0qM9fpOq+5+gpLseKTF2U58=
X-Received: by 2002:a05:622a:1206:b0:400:a2b8:1c97 with SMTP id y6-20020a05622a120600b00400a2b81c97mr6208632qtx.17.1694692213109;
        Thu, 14 Sep 2023 04:50:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIST+VWymPtjcyLzlckChTxGcmftCDlv+gr6HzDznFoMA4RzAxmotmJGW3yMqVA+frqaykSw==
X-Received: by 2002:a05:622a:1206:b0:400:a2b8:1c97 with SMTP id y6-20020a05622a120600b00400a2b81c97mr6208618qtx.17.1694692212804;
        Thu, 14 Sep 2023 04:50:12 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id h5-20020ac87765000000b0041514d1da65sm400675qtu.20.2023.09.14.04.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 04:50:12 -0700 (PDT)
Date:   Thu, 14 Sep 2023 07:50:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix error checking in bch2_fs_alloc()
Message-ID: <ZQLzgaYY0pWX7y07@bfoster>
References: <a0032f97-333a-41ec-97b0-62f0b6135d54@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0032f97-333a-41ec-97b0-62f0b6135d54@moroto.mountain>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 12:47:44PM +0300, Dan Carpenter wrote:
> There is a typo here where it uses ";" instead of "?:".  The result is
> that bch2_fs_fs_io_direct_init() is called unconditionally and the errors
> from it are not checked.
> 
> Fixes: 0060c68159fc ("bcachefs: Split up fs-io.[ch]")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 29cd71445a94..4831010c0dfd 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -856,7 +856,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
>  	    bch2_fs_compress_init(c) ?:
>  	    bch2_fs_ec_init(c) ?:
>  	    bch2_fs_fsio_init(c) ?:
> -	    bch2_fs_fs_io_buffered_init(c);
> +	    bch2_fs_fs_io_buffered_init(c) ?:
>  	    bch2_fs_fs_io_direct_init(c);
>  	if (ret)
>  		goto err;
> -- 
> 2.39.2
> 

