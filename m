Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6A2CE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 02:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjITCWO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 22:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjITCWM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 22:22:12 -0400
Received: from out-212.mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC2DC5
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 19:22:03 -0700 (PDT)
Date:   Tue, 19 Sep 2023 22:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695176521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6qKLJdCzM4vN9QIp7aRPqKoHm0dk61BWJxhBLKoQteI=;
        b=ZuxTQMG/8tuIS2uXkVRyRaOXt+kYcWdw+2c/EAp6JBVYz/dh8o5CDxSxYYoMgnUDKoF7Ba
        YnzZ/877hVqaYHy6t4h32EXLytsezYNn5Tkw28YPUISZfkKvCo09R+8BwTNLyIM/UeSpZw
        mIZ1/Lq5xfIMlzijodPh3//ZE8SLaOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [bug report] bcachefs: Kill struct bucket_mark
Message-ID: <20230920022159.cxlscxm645hyzsje@moria.home.lan>
References: <04b27989-3804-4ac9-91d4-7cd19cc813c5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04b27989-3804-4ac9-91d4-7cd19cc813c5@moroto.mountain>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 14, 2023 at 04:40:03PM +0300, Dan Carpenter wrote:
> Hello Kent Overstreet,
> 
> The patch 43ae95661a99: "bcachefs: Kill struct bucket_mark" from Feb
> 14, 2022 (linux-next), leads to the following Smatch static checker
> warning:
> 
> 	fs/bcachefs/buckets.c:755 check_bucket_ref()
> 	warn: impossible condition '((bucket_sectors + sectors) > (~0)) => (0-u32max > u32max)'
> 
> fs/bcachefs/buckets.c
>     740         if (!data_type_is_empty(bucket_data_type) &&
>     741             ptr_data_type &&
>     742             bucket_data_type != ptr_data_type) {
>     743                 bch2_fsck_err(c, FSCK_CAN_IGNORE|FSCK_NEED_FSCK,
>     744                         "bucket %u:%zu gen %u different types of data in same bucket: %s, %s\n"
>     745                         "while marking %s",
>     746                         ptr->dev, bucket_nr, b_gen,
>     747                         bch2_data_types[bucket_data_type],
>     748                         bch2_data_types[ptr_data_type],
>     749                         (printbuf_reset(&buf),
>     750                          bch2_bkey_val_to_text(&buf, c, k), buf.buf));
>     751                 ret = -EIO;
>     752                 goto err;
>     753         }
>     754 
> --> 755         if ((unsigned) (bucket_sectors + sectors) > U32_MAX) {
> 
> Originally this was U16_MAX instead of U32_MAX so that made sense. 

thanks, fixed - we were also storing bucket_sectors in a u16 instead of
a u32 above.
