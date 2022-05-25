Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE876C433EF
	for <linux-bcachefs@archiver.kernel.org>; Wed, 25 May 2022 17:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiEYRW3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 25 May 2022 13:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiEYRW2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 25 May 2022 13:22:28 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5F195A34
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 May 2022 10:22:26 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id s31so2061605qtc.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 May 2022 10:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AMh4DjIyCdpooyxZ1k6wKBDJk1dR0Gk9/TJEibnBc3I=;
        b=LyvvQ/V7q2/V3KgLWbU9danEpM1kcGInVRfRE8bseWqKawrAwHBbU/08Q6D5Vd4dFc
         V2eH/O2DqF2/JwAq7tg/gLpQhjrUeft4R4wZ2mrsAL1hk2fRNDLHtn6fq8SvdcT4ZT/i
         cvMAq/yLo7AZ4mJ+kKmeRYUmZvwBul/CFwnoNeNjQE3S3D1phdc1xXZ6n1LjsjaWTgA3
         TP6p/BKowot2HZ0V58fpdDEcbVB9Nk6A6fK9jH5wlMTqc11uez7FLhrPa0SJoIMvgxWR
         w10ThGghWn4b89MCcLmrDziUUm1dj2c8LrA2PbspIH4uRcNL7/PucK1wY+YYxs/7H/jq
         0Wrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AMh4DjIyCdpooyxZ1k6wKBDJk1dR0Gk9/TJEibnBc3I=;
        b=FT0m+YWCtxUNjyKnfeGimZhAzmzj/e7fZqQ3kwwWGVy6YX9op8gDu9EGw57gIqORqt
         Pm1vR1jUleeMyHy4ZEM2UAYt7z0jgfiMLd1qLoqW8EH5gDBZm+9l6twNdt1m6dbPMwnz
         bqTiAVEMDw3Kj3U7d+fHYtkWU5zANbos+4t81GLVaDzBxBLbDt26qWrkzAsOjoyQuis1
         YH91M+D6ACnDp4NovvOXbl56QKKDupILfuatwmrFG9uF9ITeNDvzmErX4ol9MZo9liOu
         pyrEaNZXgaBmEb3vUvr6RIvaMMWh3fvKAkNGBjPkfoowdd2wyJnFdU6m3du5iserHuEb
         pSUA==
X-Gm-Message-State: AOAM531NbFcb0poVYyvAnxzUwkNWgwD8DlOFRi4J3lMG3faitJEG/tC9
        yaXtz4x1T2hgyI3b1Pi0iSbnNSnguA==
X-Google-Smtp-Source: ABdhPJwoVFmRCY/W4Ml6sBkcU33AqVKramwV/pWAwAjrgRfENKmmBwbxchg/OnnUyfvY+91hx8bezA==
X-Received: by 2002:a05:622a:1448:b0:2fb:6ebd:734b with SMTP id v8-20020a05622a144800b002fb6ebd734bmr2210414qtx.108.1653499346018;
        Wed, 25 May 2022 10:22:26 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id q8-20020a05620a024800b006a34f6a7840sm1578181qkn.57.2022.05.25.10.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:22:25 -0700 (PDT)
Date:   Wed, 25 May 2022 13:22:23 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Generic Plant <cmclfairbairn@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Command mistype on bcachefs.org
Message-ID: <20220525172223.gng6e7nfi5jn7hav@moria.home.lan>
References: <CAM8=fNeR1rLw2puAtmY+3dTd0ekmUaCMj6Gjzb6MHoMvzNt3OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8=fNeR1rLw2puAtmY+3dTd0ekmUaCMj6Gjzb6MHoMvzNt3OQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, May 21, 2022 at 08:19:11PM +0100, Generic Plant wrote:
> Hi,
> 
> I noticed there was a mistype on https://bcachefs.org/. Specifically the
> command:
> 
> bcachefs format /dev/sd[ab]1 \
>     --foreground_target /dev/sda1 \*    --promote-target /dev/sda1 \
> *    --background_target /dev/sdb1
> mount -t bcachefs /dev/sda1:/dev/sdb1 /mnt

Thanks, fixed - the --target options now take sda1, not /dev/sda1

> Also, it's a weird edge case but has anyone attempted a multi device with
> USB sticks? I've tried to but I can only create a folder then I get a file
> system is read only error (mounting with -o rw).

What dmesg do you get?
