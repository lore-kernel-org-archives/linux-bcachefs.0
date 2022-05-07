Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A7DC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  7 May 2022 18:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386792AbiEGScc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 7 May 2022 14:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiEGScb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 7 May 2022 14:32:31 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589A5237ED
        for <linux-bcachefs@vger.kernel.org>; Sat,  7 May 2022 11:28:44 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id e128so8147644qkd.7
        for <linux-bcachefs@vger.kernel.org>; Sat, 07 May 2022 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=acssdg9LF/RHd1quj71mrWniLuURG/KImHcqcss3VVQ=;
        b=iBRg9AzoCHtD3pwEbeycCwKoAaeNhOOlW81ut8kkZiZjU9vi7oHYw1oVrSV/Zki4RP
         3RvifgrUuXQS68kmtYzkt+mkQyaV72DxqPIAxuaQ4FBOb6IwFRXlkF/PWpN8Mdj5hvmH
         rK2QS02hyKiA+S8D8nzuljGYA3PJ08IOyufVamNrDaqCWXqvbqbVRnGXPLsyfgbKHss0
         D+BjtDDeXbSjtq3womzlgWY9KQNSiRpfTaenpyDoZxtlDqk/4eYonhss2/udyrgWsW+/
         x6wqADldfmuK6eHQqYqXuI6E9swAtO5f8NUj6Y9onzMH6YVar4Sx2voF6pBT07BkwtE6
         EBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=acssdg9LF/RHd1quj71mrWniLuURG/KImHcqcss3VVQ=;
        b=ArlEhv3KotBfz/qfsoSCYNdRL8Obhy0Y5V/rEcQva9jGtijv5lWb5jaC3Pwmm0mmQL
         BLH5bKTo+q+6Ylx1Fob7QXQ+YG/lQLPsI4X0WTXy8fuAb4/PCfUFe/G2fek7or7980xf
         SC5klYglSgqhnibJMTbJxKWKXRQw9L3zK/z1ZQq1iawTr02NKfscGA315jQ/agUfdAVJ
         itY+Rq+Ssd3BuW2xwc1JtHsbRSzUIQvIDO5NAhAuxnRMJv1WW5eS6X6robyj5knWQAs+
         3/v6z/wLQJxKVCuXVwk/aDtFwhpmtrgsWmnynU3apo+fjm7crN5uHQVS2RlUGFY4m3Ax
         6pgA==
X-Gm-Message-State: AOAM531fl78KEJy/SrasY2Doydp9WUyhwavHtzdaCBXoluzgML4fl/jc
        L/6VPMQNZtE/3mvE6xxKcQ==
X-Google-Smtp-Source: ABdhPJxd1LmhPBeBSk3zvHAIN8Fcyw1cWeZYA2lOmUVFbIQ07pyQArDsG1YMTY1pv63RWJwYsfMMZQ==
X-Received: by 2002:a05:620a:4009:b0:6a0:4561:3989 with SMTP id h9-20020a05620a400900b006a045613989mr6241051qko.141.1651948123512;
        Sat, 07 May 2022 11:28:43 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id w2-20020a379402000000b0069fc13ce250sm4432650qkd.129.2022.05.07.11.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 11:28:42 -0700 (PDT)
Date:   Sat, 7 May 2022 14:28:41 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Coly Li <colyli@suse.de>, ming.lei@redhat.com,
        linux-bcachefs@vger.kernel.org
Subject: Re: bug in bcachefs -> bio_copy_data_iter
Message-ID: <20220507182841.erbdexnphra2f3iz@moria.home.lan>
References: <YYrwbksSPdtITbEs@moria.home.lan>
 <84ff96fe-ff4b-b58b-b732-88e87fe0b502@suse.de>
 <20220423173123.GA29024@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423173123.GA29024@lst.de>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Apr 23, 2022 at 07:31:23PM +0200, Christoph Hellwig wrote:
> On Wed, Nov 10, 2021 at 08:02:06PM +0800, Coly Li wrote:
> >> looks like it should be functionally equivalent), but clearly I'm missing
> >> something... wonder if there might be some relation to the bug you guys hit in
> >> bcache with bvec_virt.
> >>
> >> Any ideas?
> >
> > I experience similar one in bcache code during my recent development,
> 
> Can you try this patch?

Coly, did you look at this?

Christoph, the fix looks correct to me - let's get it in if you haven't sent it
to Jens yet.

> diff --git a/block/bio.c b/block/bio.c
> index 4259125e16ab2..ac29c87c6735c 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1336,10 +1336,12 @@ void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
>  		struct bio_vec src_bv = bio_iter_iovec(src, *src_iter);
>  		struct bio_vec dst_bv = bio_iter_iovec(dst, *dst_iter);
>  		unsigned int bytes = min(src_bv.bv_len, dst_bv.bv_len);
> -		void *src_buf;
> +		void *src_buf = bvec_kmap_local(&src_bv);
> +		void *dst_buf = bvec_kmap_local(&dst_bv);
>  
> -		src_buf = bvec_kmap_local(&src_bv);
> -		memcpy_to_bvec(&dst_bv, src_buf);
> +		memcpy(dst_buf, src_buf, bytes);
> +
> +		kunmap_local(dst_buf);
>  		kunmap_local(src_buf);
>  
>  		bio_advance_iter_single(src, src_iter, bytes);
