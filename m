Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B5CC001DE
	for <linux-bcachefs@archiver.kernel.org>; Fri, 11 Aug 2023 02:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjHKCkN (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Aug 2023 22:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjHKCkN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Aug 2023 22:40:13 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC102D48
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 19:40:11 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso19016239f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 19:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691721611; x=1692326411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eGMw5dRH/Dn1o5RMvHbPyVXLZWn5aPRdckLaI9JG+kM=;
        b=2ZMeeI/vpBk6rUcLSnhM1dWgCvoniCYkmTpzDPdjs3Y34fxxxVyGIxS8JJlMfA9A5x
         fiWEVv3n5BxhxYkPkQehoIBQSWVdQhcG+JduDHe+WnAQKH16sF3wbAvHUWeBfpNSgkTn
         lRrmATG0adoVnyd0S7rtnjUjljGLj3+uF7LIhq5V4Qn9ExoeVGGHQTqyVuhSHQk1T0YM
         3ho4TggdSn8tPGnlT1kTqf0XZD1CMF2+8/OtY/Oy6XTRC6pM455a4zb4DULfsgKiRqfP
         8c8abpIKt8JMSwdpssvd4Nm6NshY9v6nl2/pXXK5n+n1P8rtA8I3XXSItBG8TTVkg4zC
         usfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691721611; x=1692326411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGMw5dRH/Dn1o5RMvHbPyVXLZWn5aPRdckLaI9JG+kM=;
        b=PnkosX6NKLpwbQfYTriuVwYfmRc4/g0a96SvA4iOZ82VameMFnYYEPMBPbNI6O2XwW
         hn4GJCcTnbbmIeiluRuPAbQaOmQLVgnifMCJyUP67zIN1R4Xi5zbobytRzF5pBOgm2tw
         DtMwiFN1Ag4GptpnIcoO9f1T58Y7Ar0vGTSKasOO19cx490OFDypsm3zCWAX3k82u1hm
         KHQuG2S6hFbGi0SwdiHDHCkvUBurkldI8xqye4XGd1Z949ao2ojzGZaiXNK+D3r7FfNP
         qN2SC+3cRNaWyccgnmtbaxMYi8pRCqMil6DzgNrsPoRIAE+IN4wQkiMMKMXJYl/bduKf
         m0tA==
X-Gm-Message-State: AOJu0YxiVRjUP/bQEPfhWGnaaWbfKIdJP3ZtR3BzN2twWuRHKv9jA8Et
        PlWolF+bSE9Rxl2v7eZv2XR+CQ==
X-Google-Smtp-Source: AGHT+IGV787jHB0MawLqyMGlF8gM5uZPK2TzATXPYrFqNWAyA3TyP1YbNFc1UeQ4QjgyAMDRS/EOVg==
X-Received: by 2002:a92:c6ce:0:b0:349:7518:4877 with SMTP id v14-20020a92c6ce000000b0034975184877mr658909ilm.0.1691721610842;
        Thu, 10 Aug 2023 19:40:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u14-20020a170903124e00b001b8b26fa6c1sm2501772plh.115.2023.08.10.19.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 19:40:09 -0700 (PDT)
Message-ID: <e6fb621e-1cae-46ba-bc39-3d7a671421ed@kernel.dk>
Date:   Thu, 10 Aug 2023 20:40:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] bcachefs
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org, dchinner@redhat.com,
        sandeen@redhat.com, willy@infradead.org, josef@toxicpanda.com,
        tytso@mit.edu, bfoster@redhat.com, jack@suse.cz,
        andreas.gruenbacher@gmail.com, brauner@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, snitzer@kernel.org
References: <20230626214656.hcp4puionmtoloat@moria.home.lan>
 <20230706155602.mnhsylo3pnief2of@moria.home.lan>
 <20230712025459.dbzcjtkb4zem4pdn@moria.home.lan>
 <CAHk-=whaFz0uyBB79qcEh-7q=wUOAbGHaMPofJfxGqguiKzFyQ@mail.gmail.com>
 <20230810155453.6xz2k7f632jypqyz@moria.home.lan>
 <20230810223942.GG11336@frogsfrogsfrogs>
 <CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wj8RuUosugVZk+iqCAq7x6rs=7C-9sUXcO2heu4dCuOVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 8/10/23 5:47 PM, Linus Torvalds wrote:
> On Thu, 10 Aug 2023 at 15:39, Darrick J. Wong <djwong@kernel.org> wrote:
>>
>> FWIW I recently fixed all my stupid debian package dependencies so that
>> I could actually install liburing again, and rebuilt fstests.  The very
>> next morning I noticed a number of new test failures in /exactly/ the
>> way that Kent said to expect:
>>
>> fsstress -d /mnt & <sleep then simulate fs crash>; \
>>         umount /mnt; mount /dev/sda /mnt
>>
>> Here, umount exits before the filesystem is really torn down, and then
>> mount fails because it can't get an exclusive lock on the device.
> 
> I agree that that obviously sounds like mount is just returning either
> too early. Or too eagerly.
> 
> But I suspect any delayed fput() issues (whether from aio or io_uring)
> are then just a way to trigger the problem, not the fundamental cause.
> 
> Because even if the fput() is delayed, the mntput() part of that
> delayed __fput action is the one that *should* have kept the
> filesystem mounted until it is no longer busy.
> 
> And more importantly, having some of the common paths synchronize
> *their* fput() calls only affects those paths.
> 
> It doesn't affect the fundamental issue that the last fput() can
> happen in odd contexts when the file descriptor was used for something
> a bit stranger.
> 
> So I do feel like the fput patch I saw looked more like a "hide the
> problem" than a real fix.

The fput patch was not pretty, nor is it needed. What happens on the
io_uring side is that pending requests (which can hold files referenced)
are canceled on exit. But we don't wait for the references to go away,
which then introduces this race.

I've used this to trigger it:

#!/bin/bash

DEV=/dev/nvme0n1
MNT=/data
ITER=0

while true; do
	echo loop $ITER
	sudo mount $DEV $MNT
	fio --name=test --ioengine=io_uring --iodepth=2 --filename=$MNT/foo --size=1g --buffered=1 --overwrite=0 --numjobs=12 --minimal --rw=randread --thread=1 --output=/dev/null &
	Y=$(($RANDOM % 3))
	X=$(($RANDOM % 10))
	VAL="$Y.$X"
	sleep $VAL
	ps -e | grep fio > /dev/null 2>&1
	while [ $? -eq 0 ]; do
		killall -9 fio > /dev/null 2>&1
		wait > /dev/null 2>&1
		ps -e | grep "fio " > /dev/null 2>&1
	done
	sudo umount /data
	if [ $? -ne 0 ]; then
		break
	fi
	((ITER++))
done

and can make it happen pretty easily, within a few iterations.

Contrary to how it was otherwise presented in this thread, I did take a
look at this a month ago and wrote up some patches for it. Just rebased
them on the current tree:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-exit-cancel

Since we have task_work involved for both the completions and the
__fput(), ordering is a concern which is why it needs a bit more effort
than just the bare bones stuff. The way the task_work list works, we
llist_del_all() and run all items. But we do encapsulate that in
io_uring anyway, so it's possible to run our pending local items and
avoid that particular snag.

WIP obviously, the first 3-4 prep patches were posted earlier today, but
I'm not happy with the last 3 yet in the above branch. Or at least not
fully confident, so will need a bit more thinking and testing. Does pass
the above test case, and the regular liburing test/regression cases,
though.

-- 
Jens Axboe

