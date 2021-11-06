Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C2EC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 16:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86E7D61165
	for <linux-bcachefs@archiver.kernel.org>; Sat,  6 Nov 2021 16:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhKFQtM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhKFQtL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 6 Nov 2021 12:49:11 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2EFC061570
        for <linux-bcachefs@vger.kernel.org>; Sat,  6 Nov 2021 09:46:30 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id g13so9616448qtk.12
        for <linux-bcachefs@vger.kernel.org>; Sat, 06 Nov 2021 09:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6rHuXJSLOZ79tkI1aP5gYJMYkOafVLNZKP3vDjSNsrI=;
        b=RXEBvSwGOBL9RDP9xBq0HOIR2+wgW/NEeVm9Hh4qYxb2xjnzwajy00lw9lU628VPf+
         4mP88gPdVziJ+RcSFKfndhx4szX6DdCH+jG7jgE35r0y79pa4mmc4skmLdpmN5kyLz5m
         WgzZanRh+jwXCYxor/hBtpQuDmyLRMyM0256o9ra0cVxj0lmc61bWYIbonvX7NieIfYX
         D0xiUV2G/tfa8QHutgKhcCDFkzfUX9lWTbL12o7lN4zqMMhDr4i2gtbzrIrGr7berJf2
         nl2G+khAFv7+Q0Tp2odlOb3PqUdPidBO4UG+tz8Jun+yho7ZU/FmGDCQKpqmpfdfBLA3
         gLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6rHuXJSLOZ79tkI1aP5gYJMYkOafVLNZKP3vDjSNsrI=;
        b=XdDYQEX1yTRzsVhM0SijX9GgzfLtulkInkMGcseONt0KMqWR8IdOGe7wwNM+p+V9yJ
         bA2Ovd8CY4A4gBCsaXi1dtMyAzbXLvX6RrT06XfwioWk4yLCI0oNjvJ0iv3MyHNGHugv
         Z1To020rwlRykerzZw0+DuBL8OLQBxL2KRQ69/tDr4AItDRqw5C9mse5JKgrmjno5Qhd
         1ZTePDxIv0p60L41vGt1Hi60kuUCWaJxwVsyEG7LrQNW09AqvziZQwFa3RM8XOGB6u2r
         IuObGriLSFFPLSPRSnHzywFjlwmCduzuDBWiKbmSb2n4Jt1cL91XXt07H1lSZYlbn4W/
         B52w==
X-Gm-Message-State: AOAM530vQ2cEU4qHIv9hYlPLtXpMh5U3U0NMGOJ+5prUXEYIDGTwn+Os
        IheWs5eW7sawYqHiWmiNIDnHvW5Y3g==
X-Google-Smtp-Source: ABdhPJxaq5pM7jL71KJput2KjTHFNz9Wd3hYqFcIioiUufj6Ore1BUJaxuqHTdUvMQJJszD7XXI6FA==
X-Received: by 2002:ac8:590d:: with SMTP id 13mr51551293qty.167.1636217189168;
        Sat, 06 Nov 2021 09:46:29 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id u15sm7614314qki.99.2021.11.06.09.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 09:46:28 -0700 (PDT)
Date:   Sat, 6 Nov 2021 12:46:26 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Chris Webb <chris@arachsys.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Return -ENOKEY/EINVAL when mount decryption
 fails
Message-ID: <YYaxYg1hSAR01/Lk@moria.home.lan>
References: <20211104210316.GA22353@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104210316.GA22353@arachsys.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Nov 04, 2021 at 09:03:16PM +0000, Chris Webb wrote:
> bch2_fs_encryption_init() correctly passes back -ENOKEY from request_key()
> when no unlock key is found, or -EINVAL if superblock decryption fails
> because of an invalid key. However, these get absorbed into a generic NULL
> return from bch2_fs_alloc() and later returned to user space as -ENOMEM,
> leading to a misleading error from mount(1):
> 
>   mount(2) system call failed: Out of memory.
> 
> Return explicit error pointers out of bch2_fs_alloc() and handle them in
> both callers, so the user instead sees
> 
>   mount(2) system call failed: Required key not available.
> 
> when attempting to mount a filesystem which is still locked.
> 
> Signed-off-by: Chris Webb <chris@arachsys.com>

Thanks! Applied - I did some more cleanups on top of your patch, too.
