Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCC5EB64D7
	for <linux-bcachefs@archiver.kernel.org>; Wed, 28 Jun 2023 23:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjF1XLX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 28 Jun 2023 19:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjF1XLW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 28 Jun 2023 19:11:22 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AC8268F
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Jun 2023 16:11:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-54f73ef19e5so14798a12.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Jun 2023 16:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687993880; x=1690585880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4mAlkGVC6JAtru60kOWkScqz21y3nSrjMBZrOZwK24E=;
        b=cCIiVFLSsDYMimXtqEXoM+Cwm7kWQe+PDnQmI/r9gx2thYq34e2jU4iltQdf/3vYy8
         QnIYAvwgmzoIWALeH3BHoF0IH+uKmXZwvV3TrxFlvhVmCOGqFq1d6MMgjiAfNk6OF5sP
         FYe7r/yFOFOPf0Kj2F7sUQLsb+76nZhyGW9ifgK744pLvJVvNQYkQUoRQxFQu2h77y1D
         rpfsjPmubMS93n3KDBiP2f9TyDAJjqUY+MPSkdBIu8tBQGFkgjSd1dzJEaI6L8y/QMyB
         UWo8i2pYo1Tj6YlCRUnxzZgQwiN+tGgIY9IzOHCM19u0opIiJHUTZsWd9FYEhu7Dh8wt
         pm9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687993880; x=1690585880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mAlkGVC6JAtru60kOWkScqz21y3nSrjMBZrOZwK24E=;
        b=aJKin/bMyonuxBSylP6X1Nw+kGsdgDzrxpFK7QcPLS0G4wCc3Fwr7gmh5AvhRkB/2e
         PnOtjf0/JWvVuqCJxyR7Sr0TMzmknOlQKgYNikN13/zVdARV/srVQG0kbp8hZHmCiRXD
         iFwrp0aIDE+MJrxsBFCDkD5yuJTTaDhJWLdnX6R6myqh1lqjLf4Dshuv9ixpNc4CMSdJ
         Ui0+g6YXog4dk/46iUKQqosf9WoanQaxpbg0OeUQz2Coa/gvLg/kNVu9GndZMD1SVDTf
         IxUmJDrQDHb/nCYQ5SB+K/Mjhwnnm6kfnw0EHIPLpwINM0+mqzOkoCVAPET2wGPScKOZ
         3TYQ==
X-Gm-Message-State: AC+VfDyXDeqCGXTM0YnZ2xhJNzqSFOB1hhRiDC2xtttmaDvyttDzT1ON
        5Wjff/Nfz20erjBHfRiXBekT2w==
X-Google-Smtp-Source: ACHHUZ52vvH0sBl7aB+MXWrJbIo0E155xerI4JAzF4CriPP7IF1ldJmlmPEt/LqVoltEI+VEPuvh2Q==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id a6-20020a170902ecc600b001ae13646086mr43838204plh.2.1687993879969;
        Wed, 28 Jun 2023 16:11:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e8::106b? ([2620:10d:c090:400::5:e20])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902da8300b001ab13f1fa82sm2857083plx.85.2023.06.28.16.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 16:11:19 -0700 (PDT)
Message-ID: <5f94327d-29e6-0707-95c1-8e6f0ebfd08b@kernel.dk>
Date:   Wed, 28 Jun 2023 17:11:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] bcachefs
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20230627020525.2vqnt2pxhtgiddyv@moria.home.lan>
 <b92ea170-d531-00f3-ca7a-613c05dcbf5f@kernel.dk>
 <23922545-917a-06bd-ec92-ff6aa66118e2@kernel.dk>
 <20230627201524.ool73bps2lre2tsz@moria.home.lan>
 <c06a9e0b-8f3e-4e47-53d0-b4854a98cc44@kernel.dk>
 <20230628040114.oz46icbsjpa4egpp@moria.home.lan>
 <b02657af-5bbb-b46b-cea0-ee89f385f3c1@kernel.dk>
 <20230628175421.funhhfbx5kdvhclx@moria.home.lan>
 <4d3efe17-e114-96c1-dca8-a100cc6f7fc6@kernel.dk>
 <131fdf9b-bd31-fc0d-8fe9-8f68592306e5@kernel.dk>
 <20230628230407.nvi7us7eeya4yl2s@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230628230407.nvi7us7eeya4yl2s@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 6/28/23 5:04 PM, Kent Overstreet wrote:
> On Wed, Jun 28, 2023 at 04:14:44PM -0600, Jens Axboe wrote:
>> Got a whole bunch more running that aio reproducer I sent earlier. I'm
>> sure a lot of these are dupes, sending them here for completeness.
> 
> Are you running 'echo scan > /sys/kernel/debug/kmemleak' while the test
> is running? I see a lot of spurious leaks when I do that that go away if
> I scan after everything's shut down.

Nope, and they remain in there. The cat dump I took was an hour later.

-- 
Jens Axboe


