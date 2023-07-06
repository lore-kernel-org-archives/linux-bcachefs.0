Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF36EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Thu,  6 Jul 2023 16:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjGFQ0i (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 6 Jul 2023 12:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjGFQ0h (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 6 Jul 2023 12:26:37 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E21EDC
        for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jul 2023 09:26:36 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-3461b58c61dso719095ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jul 2023 09:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688660796; x=1691252796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xsUQiinDQbgs1GWC6x88zZ62UTNshdq3ifdf5wffGck=;
        b=FN0aM49NSkNhOMms1+7NZw0wJlPcATTOWjUIc+nNdMqL7TeysiAX8gXgAr7TERX8v8
         9tu5RtbVaTIO9f+1O+aGbR5sOIcif1gtjX9Oo/6RUj6VQKhugOtyOl/kRtYZjEY24X/g
         ViXEVBVWBYS7Av7ReprwqE0g5WGMzsLXHd+3lDfF9csV0+EDKx0IuMNxneGue6LZrHzT
         9joGEnWA8nzWVxD1ZbYr/GFwOhvwchkZL0rgBADvjq5vlTHjAEBj4L1Cpo38ULC25MUB
         ibTp7dNvjZCVWBmtLKPPjozOZ1cedwBRlhTGxoixwD5ZkTGyQ+C3snRnXyBmzeEjzlRQ
         2I/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688660796; x=1691252796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsUQiinDQbgs1GWC6x88zZ62UTNshdq3ifdf5wffGck=;
        b=DleWBn5SrHgOJLqtN0WJbVEFcL+8Ss7HTuDZflRk97/Tf+V3d8/Gfvek7Zc8RuHeib
         K/IyP/tZ4q65XvBkNsT0ErO329GsBb7HvzlwHi/P2fYbr/m0sUavEUh1yECbcOOjrVUf
         AMqcwbraJAV4i65dOzCf11BMneB3vlljkbahH+gxXq38PFcN4ZwacmJz+e/c5znZVLvY
         IWzsBTtZIJWL/MyCrNMlXykeSVRsgge5708n2cf8odH5j5lLNuGjLtLvi0KFK7/j6AKR
         aPukAzqI4O72PclIM9cSDlFLpYEY2uYr7cVgAyZQNOUBWnSI7N/NpM29g+KQorJ/Zm51
         lqPQ==
X-Gm-Message-State: ABy/qLaSUV1cS4THwwVGoJKZV+RSYD5qiDhGkBDrDSuiLkF7BHIfBhHO
        c2I95EIlv8mW3pTQkW+cXCWMpg==
X-Google-Smtp-Source: APBJJlG19lT5NjfnCu4VGDwOcKgkeaoTxH2wv/dSelvO8UX8aLJXZVc1dSRWK+cnH4BcIOHxcM2aZQ==
X-Received: by 2002:a92:c688:0:b0:346:3173:2374 with SMTP id o8-20020a92c688000000b0034631732374mr3181024ilg.0.1688660796002;
        Thu, 06 Jul 2023 09:26:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m14-20020a924b0e000000b0033e62b47a49sm617857ilg.41.2023.07.06.09.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jul 2023 09:26:35 -0700 (PDT)
Message-ID: <48d69cae-902a-a746-e73b-a5b8fdf694b4@kernel.dk>
Date:   Thu, 6 Jul 2023 10:26:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] bcachefs
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Christian Brauner <brauner@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20230628221342.4j3gr3zscnsu366p@moria.home.lan>
 <d697ec27-8008-2eb6-0950-f612a602dcf5@kernel.dk>
 <20230628225514.n3xtlgmjkgapgnrd@moria.home.lan>
 <1e2134f1-f48b-1459-a38e-eac9597cd64a@kernel.dk>
 <20230628235018.ttvtzpfe42fri4yq@moria.home.lan>
 <ZJzXs6C8G2SL10vq@dread.disaster.area>
 <d6546c44-04db-cbca-1523-a914670a607f@kernel.dk>
 <20230629-fragen-dennoch-fb5265aaba23@brauner>
 <20230629153108.wyn32bvaxmztnakl@moria.home.lan>
 <20230630-aufwiegen-ausrollen-e240052c0aaa@brauner>
 <20230706152059.smhy7jdbim4qlr6f@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230706152059.smhy7jdbim4qlr6f@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 7/6/23 9:20?AM, Kent Overstreet wrote:
>> My earlier mail clearly said that io_uring can be changed by Jens pretty
>> quickly to not cause such test failures.
> 
> Jens posted a fix that didn't actually fix anything, and after that it
> seemed neither of you were interested in actually fixing this. So
> based on that, maybe we need to consider switching fstests back to AIO
> just so we can get work done...

Yeah let's keep misrepresenting... I already showed how to hit this
easily with aio, and you said you'd fix aio. But nothing really happened
there, unsurprisingly.

You do what you want, as per usual these threads just turn into an
unproductive (and waste of time) shit show. Muted on my end from now on.

-- 
Jens Axboe

