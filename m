Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED88C7EE22
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 20:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbjEIU73 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 16:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235326AbjEIU71 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 16:59:27 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E918C
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 13:58:42 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51f597c975fso5956548a12.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 May 2023 13:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20221208.gappssmtp.com; s=20221208; t=1683665879; x=1686257879;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=wGSlyNoNEgum+U70dHQogcXITA/6qezybzU+rcF2jfc=;
        b=KSsvD321cDPrU3Q6JPqXRZNf4XJtKylCcVay6B3lnHml5xEp3aWu8vMqY9Px5k5TWv
         sw3Yns4edSoTrkJLiPyfba6ulQ0/3/MwV8gFfulp0aD5MDmKsK9Wthdme6s9Vo1byoVe
         nkC4mhfRxI1jZnuTXD0K2vLHYC1N2nh/aKse2VXVyzcewHEKngxX81phn3DjN5IFuu4h
         5tJweuFpAbOlaspXSfGc+n9uMOhii/2g48P06D5nTwrwXzf5Nj1ld3TgSBSEH5wUqSge
         7RgjTl9lIv98MdubihUcitLbAAGvVPFRGakYxzHfNjvMqRlfzSXIyVBhcPgNhkq4pIyW
         2WWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683665879; x=1686257879;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGSlyNoNEgum+U70dHQogcXITA/6qezybzU+rcF2jfc=;
        b=Vm2dW/WvhhRgbMk+jrI4C6N/EbiywtQEBTNlosU9X46P0MC1zQcFcpujuwHZGpsIKN
         3VkEwLlTDnYyQikVbzlpW1rCc2idHYBfGh+ldUgVC/43wQWn/3QmehF4hQx8lvy9Vh+q
         hoFSTdQG38MpOvOsgqLg8Uu7rMgbWLScyptkCFNdHCVPJeGeIHiUtYYmeH3+dAFp/u9I
         GFKWd4mIIU6jZf8cGshkj9qVs6n370CJTN/DP6XQ7NYms4OhFo6XYHwwDSTvgz2gbu0j
         9NmVyXwKfCDZBjuRc0LMM1aTy9fQBlaQ/eh7rLZasIdstV/qMrutQEQmSqOsr2rHi3c2
         5Xzg==
X-Gm-Message-State: AC+VfDx0fOf+PjtV94TfjSAHbkvVluARHbj0tr5DNtE92VBcXm49nWIu
        D0IxCJYQ5rJHz4Zj64ZTpGc3yg==
X-Google-Smtp-Source: ACHHUZ73+zHi3Seg6S+4EiVpOsxhIS8YI33bLLJxkgjJKOgnOArbquvVNUNfB1Y6L9JlVUyaBURBrQ==
X-Received: by 2002:a17:902:ce82:b0:1a9:9a18:345c with SMTP id f2-20020a170902ce8200b001a99a18345cmr18784456plg.44.1683665878927;
        Tue, 09 May 2023 13:57:58 -0700 (PDT)
Received: from localhost ([72.28.92.215])
        by smtp.gmail.com with ESMTPSA id s8-20020a170902a50800b001ac8e0ea157sm2049135plq.144.2023.05.09.13.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 13:57:58 -0700 (PDT)
References: <20230503065354.19071-1-i@truongsinh.pro>
 <ZFqHFTMqetbQKtah@moria.home.lan>
 <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
User-agent: mu4e 1.10.3; emacs 28.2.50
From:   Andreas Hindborg <nmi@metaspace.dk>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] chore(util): minimal Rust build example
Date:   Tue, 09 May 2023 22:52:48 +0200
In-reply-to: <CAMy36z75N9obj0WM+OFhhnzXAPxqhg8PVY7_x8X6JbQABFnMQw@mail.gmail.com>
Message-ID: <87mt2dcje2.fsf@metaspace.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


TruongSinh Tran-Nguyen <i@truongsinh.pro> writes:

> On Tue, 9 May 2023 at 10:47, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
>> We pretty heavily use to_text() functions kernel side; these output to
>> printbufs, and in Rust they map nicely to the Display trait - do we have
>> that available in the kernel or is that in std?
>>
>
> https://doc.rust-lang.org/std/fmt/trait.Display.html Display trait is definitely
> in Rust `std`. As for the alternative from kernel, I am still searching.
> Worst case, there is nothing right now, Rust-for-linux folks would
> happy to take PR
> to include it.

Many traits and types in `std` are reexports from `core` or `alloc`.
To my knowledge, there is no way to see if an item is reexported when
browsing the documentation. Some ways discover reexports when browsing docs:

 - hit the `source` link at see where it is going
 - when searching for an item, see if it is present in multiple crates.

Best regards
Andreas

