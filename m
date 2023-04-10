Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078DBC77B73
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Apr 2023 13:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjDJNpB (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Apr 2023 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDJNo6 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Apr 2023 09:44:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149D830FA
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Apr 2023 06:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681134250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKoh29qI6BbjCqIkK/qXs63ANmnBK5tbi3DEq9q6Fjk=;
        b=EvPJuQXhtJSpp8THYZZKELaYTNRLCp+7gPx0ZQnH0885jnd24q72+nivFazAKzR93Cr9Hj
        CzrSMjsrHSiGMRKjG8VMJu1dslTUopEWQCkC+DGvSlXEhvLZAhqmL/ge7F1z0Uzl/geuxT
        C1DJoXqESxN/PcT5uYsO9AlJ07w2STQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-kTVucLeMMbGsxlYey6ZcVg-1; Mon, 10 Apr 2023 09:44:09 -0400
X-MC-Unique: kTVucLeMMbGsxlYey6ZcVg-1
Received: by mail-qt1-f198.google.com with SMTP id i3-20020ac85c03000000b003e38e0a3cc3so4171995qti.14
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Apr 2023 06:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681134248; x=1683726248;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKoh29qI6BbjCqIkK/qXs63ANmnBK5tbi3DEq9q6Fjk=;
        b=O6SpWSsiTJNm4uu1FcY1Z3tW77VdTPp2phJn90pOuA3IVAK6+xxYroq/1PCa0WLL7y
         zjDZ6IC+/yP7ICAwP/2vbVkV8D7tvvTh1uNFXsrQVRxAI0SzfwPucN9KtKnt7WRYEx8W
         lzriH4+vpEfvrYQpRd5R0spbX577FtS3h4bjnEaju8YA2vYjy4eCi01ooTsbuNL+eQu5
         stjZrOSo/o5Q+aciR2pQs1+bkjTizTeDbfkIERQR7OH4eNVr+xvDEdVB1vh7nqarecFF
         BRjd3PDoKU69E3/5jVnZ3ajtOdvTXXUtlwVdlATU78uP+99D8vLI01cyX1DBb6MDaMnR
         5Zdg==
X-Gm-Message-State: AAQBX9enHGEQVb5lkMECTtDdKT4VNDuUkCxrXcZoMhFATmMRujI0RQQr
        slrEriM90kz1ZYGWPTd1VAVaE70w9TLNXXyJNYX/mZZG5Py0OBAVuMAmkV49Nb8UPi0SMIrTmMX
        P4EfVXJ4U672YftkPtPjbSZ7HjtacSRzKQs0=
X-Received: by 2002:ac8:5ac9:0:b0:3bf:daa8:cad3 with SMTP id d9-20020ac85ac9000000b003bfdaa8cad3mr18210031qtd.15.1681134248229;
        Mon, 10 Apr 2023 06:44:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350a7NB/vEbexotVOduLbNrHxMCSLWJzs7tsR2F8tRz3/bQ/N27TN+r6n3qbyJuZkLFIkUg6gkw==
X-Received: by 2002:ac8:5ac9:0:b0:3bf:daa8:cad3 with SMTP id d9-20020ac85ac9000000b003bfdaa8cad3mr18209994qtd.15.1681134247853;
        Mon, 10 Apr 2023 06:44:07 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id i14-20020ac8488e000000b003d5aae2182dsm3000969qtq.29.2023.04.10.06.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 06:44:07 -0700 (PDT)
Date:   Mon, 10 Apr 2023 09:46:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     =?iso-8859-1?Q?Dr=2E-Ing=2E_Heiko_M=FCnkel?= 
        <heiko.muenkel@arcor.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs as a caching filesystem
Message-ID: <ZDQTI4Ep7yzw3g95@bfoster>
References: <103b31f5-677c-caf8-f556-4a9c67c37ec4@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <103b31f5-677c-caf8-f556-4a9c67c37ec4@arcor.de>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Apr 10, 2023 at 01:51:07PM +0200, Dr.-Ing. Heiko Münkel wrote:
> Hello,
> 

FYI, there's no need to send multiple mails to the list. If you aren't
sure whether your mail was delivered, you can always reference the
archive at: https://lore.kernel.org/linux-bcachefs/.

> I am in the process of testing bcachefs. I have two partitions
> /dev/nvme0n1p1 and /dev/sde1. The first (internal SSD) should be as cache
> for the second (is an SSD on a USB3 port).
> 
> First I created the bcachefs file system with:
>   sudo bcachefs format \
>        --label=Shotwell-3 /dev/sde1 \
>        --label=Shotwell-Cache-1 /dev/nvme0n1p1 \
>        --foreground_target /dev/nvme0n1p1 \
>        --promote_target /dev/nvme0n1p1 \
> --background_target /dev/sde1
> and then mount the disks with
>  sudo mount -t bcachefs /dev/nvme0n1p1:/dev/sde1 /mnt
> 
> This worked fine so far. I then used dd to create a 100GB file on /mnt and
> found, as expected, that the file was written much faster.
> 

Hm. I don't have that amount of storage on my test box and I've not
played around that much with multi-device support yet, but I gave your
configuration a quick test with a couple smaller devices in my test
environment.

The first thing I see is that writes seem to hit the foreground target
first, but very quickly move out to the background target. I.e., within
a few seconds of completing a 10GB write with dd, the entire content
seems to have been moved out to the background device.

Is that consistent with what you observe, or is there a longer tail
background copy going on? 'bcachefs fs usage <mnt>' should show how much
data resides on each device, and you can watch it to see if data is
still migrating around.

> Since I occasionally want to use the external disk on another machine, I
> then tried disconnecting the cache from the array.
> 
> Since I didn't really find anything in the documentation about this, I tried
> the following command (after the external disk had come to rest and thus the
> 100GB file was presumably also on the disk):
>     bcachefs device evacuate /dev/nvme0n1p1
> 
> After this command, it took what felt like hours for the external disk to
> come to rest again. Is this normal?
> 

It's not clear to me if the use case is to move the background disk
(sde1 w/ bcachefs+data) or to clear out the nvme drive to be repurposed.
In any event, in my test a 'bcachefs device evacuate' of my foreground
drive completes almost instantly (since data was quickly moved off). If
I repeat the process with my background drive, the userspace tool shows
a progress meter and data migrates off the background device in ~30s or
so. From there, I'm able to 'bcachefs device remove' the empty device
without disruption [1], so I assume that's the appropriate process (if
not, then I'm sure Kent can chime in..).

I'm wondering if the background device is slow enough such the initial
migrate is still going on when the evacuate starts. Do you see fs usage
still adjusting after your copy completes? If not, what does the
evacuate command show? Is it making progress or does it appear stuck? If
the latter, does top show any activity, or is there a consistent stack
trace shown in /proc/<pid of bcachefs evacuate cmd>/stack?

[1] FWIW, I have managed to reproduce a locked up evacuate command in my
attempts to repeat the test a couple times by removing/readding a
device, monitoring usage, etc. Looking at my syslogs, I've hit a BUG
report in the usage reporting path:

BUG: unable to handle page fault for address: ffff99e55343b000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0003) - permissions violation
PGD 213e01067 P4D 213e01067 PUD 101c33063 PMD 113408063 PTE 800000011343b061
Oops: 0003 [#1] PREEMPT SMP PTI
CPU: 60 PID: 7440 Comm: bcachefs Tainted: G            E      6.2.0+ #30
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc36 04/01/2014
RIP: 0010:memcpy_erms+0x6/0x10
...
Call Trace:
 <TASK>
 bch2_fs_usage_read+0x12d/0x270 [bcachefs]
...

... so I'll have to see if/how to reproduce that one. It might be wise
to check your dmesg for unexpected events as well.

Brian

> Is this the right command for this case, or do I have to use the command
>   bcachefs device offline /dev/nvme0n1p1
> to disconnect the cache and
>   bcachefs device online /dev/nvme0n1p1
> to reconnect?
> 
> 
> Thanks for your help,
> 
> Heiko
> 
> 
> 
> 
> 
> 

