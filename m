Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCC0CA0EDB
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 13:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbjILNxG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 12 Sep 2023 09:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235678AbjILNxE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 12 Sep 2023 09:53:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F0E810E6
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 06:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694526736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4ZDT0QRa1Q+8y0wTjNXL6JhVStydiLlcCxHKZqKT+w=;
        b=hLglHfqZfPb1Vx7ZHeWQYZRzgALWGbjCbDI2uxHFnmGDehKCukawwjYlM8UrAEIuK6SA7n
        TkL+CnrqehRy0Lu0vuslaQ3cSshBTRvmr15IZKlMuq8pVmjyD/4rKBHPSKQJG7Paf1W9mq
        eHbVO+hBr0bbXOW93E86vS/Ca8H9WBM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-jF_TuJd2PqqUgB_6lRapOw-1; Tue, 12 Sep 2023 09:52:15 -0400
X-MC-Unique: jF_TuJd2PqqUgB_6lRapOw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4122b472e43so44582351cf.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Sep 2023 06:52:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694526734; x=1695131534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C4ZDT0QRa1Q+8y0wTjNXL6JhVStydiLlcCxHKZqKT+w=;
        b=IC+/hpft8UM6leeJZDHLuVpuF2u1lBdf9xvF3qAmSiGUVMZu4ensWUb1fCrQquLTKk
         Rigar6hIHwHUJ3Jv79KdlZTPH1g3eBG1thQcE8250M+YN+P9c+oEl2cSUxOlh2M18Iba
         ZcEQij0PEqROUs1TIPrvodoBYaWcpBQBSGqc4Hf+avqq33N7kS0jOFA5K40HeTV3JT3Y
         Atl1BdIj4lvxScERELHwUdBCwOsY7b5T3dTqZKlPz2B+K7LepOYdFeeJiLRm1JkQ9Kp6
         cFS8w9HF6Y8d2/7fyy+eoM4ZpP0OeD9Hr2S8IPUzMlgVg9BETD8vDmEYUohDRgh0f9a6
         iy3w==
X-Gm-Message-State: AOJu0Yzvyljr/q9sa629gc86Q7gePBAavW2QRtBm9H58s6QcOSarnocX
        aELa1xvV9S3M01WBjew9KzgPfUhNWOAsBIY9tAfdD2zSpkQ66dJKQtyYSvnWlXnOSTjNI8a3tie
        LRgOinmS3Y16o9fZ+0LWGVsbWrDM=
X-Received: by 2002:ac8:5d88:0:b0:405:4816:6eef with SMTP id d8-20020ac85d88000000b0040548166eefmr3610259qtx.24.1694526734444;
        Tue, 12 Sep 2023 06:52:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM0G+zZdHUX5WBQDo4BBPF6QIKFHXDFwq50y2SceqPwU/KXuyxQ5nyOiwyZMqwk/DVhl5z7w==
X-Received: by 2002:ac8:5d88:0:b0:405:4816:6eef with SMTP id d8-20020ac85d88000000b0040548166eefmr3610242qtx.24.1694526734227;
        Tue, 12 Sep 2023 06:52:14 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id z17-20020ac84551000000b004108f6788a6sm3326401qtn.41.2023.09.12.06.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 06:52:13 -0700 (PDT)
Date:   Tue, 12 Sep 2023 09:52:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5][next] bcachefs: clean up some redundant assignments
Message-ID: <ZQBtGi+iLEglpt8x@bfoster>
References: <20230912123744.3929609-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912123744.3929609-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 12, 2023 at 01:37:39PM +0100, Colin Ian King wrote:
> Clean up some redundant assignments and variables based on warnings
> found by clang scan build static analysis.
> 

These all look good to me. For the series:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Colin Ian King (5):
>   bcachefs: remove redundant initialization of pointer d
>   bcachefs: remove redundant initialization of pointer dst
>   bcachefs: remove redundant initializations of variables start_offset
>     and end_offset
>   bcachefs: remove duplicated assignment to variable offset_into_extent
>   bcachefs: remove redundant pointer q
> 
>  fs/bcachefs/btree_update_interior.c | 2 +-
>  fs/bcachefs/buckets.c               | 2 +-
>  fs/bcachefs/disk_groups.c           | 3 +--
>  fs/bcachefs/fs-io.c                 | 4 ++--
>  fs/bcachefs/io.c                    | 1 -
>  fs/bcachefs/quota.c                 | 3 ---
>  6 files changed, 5 insertions(+), 10 deletions(-)
> 
> -- 
> 2.39.2
> 

