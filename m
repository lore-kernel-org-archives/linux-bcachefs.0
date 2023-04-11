Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B38BC7619A
	for <linux-bcachefs@archiver.kernel.org>; Tue, 11 Apr 2023 21:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjDKVU4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 11 Apr 2023 17:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKVUz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 11 Apr 2023 17:20:55 -0400
Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E85A5255
        for <linux-bcachefs@vger.kernel.org>; Tue, 11 Apr 2023 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-mb-mr2-21dec; t=1681248042;
        bh=bAd34qRmAW4rq3MqlxfWBoIhNCUk+FARssGrIZYrflA=;
        h=Message-ID:Date:User-Agent:Subject:Content-Language:To:References:
         From:In-Reply-To:Content-Type:From;
        b=BCD+tA72XLMqU+iwJNM7QpkERTAACbT6EHTlHkNnTCLHI+sVVbzEY0HjA+OW0fWMG
         LzKXRjgwIbOvzVDzK1nzw12f42w80LIQLFAe4zhyOl5a51hpknKWs31Ot1rFKpeJ1g
         0z9ZKr++JtrDn9uCXDoaopBVkP0P0lMDuGTQ/SKQ=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr4.vodafonemail.de (Postfix) with ESMTPS id 4PwzK66BJ6z20qF;
        Tue, 11 Apr 2023 21:20:42 +0000 (UTC)
Received: from [192.168.1.8] (ip1f12f8d3.dynamic.kabel-deutschland.de [31.18.248.211])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4PwzJz4RsJzKm4L;
        Tue, 11 Apr 2023 21:20:32 +0000 (UTC)
Message-ID: <e874a1d9-07f0-b977-673b-44da95a55363@arcor.de>
Date:   Tue, 11 Apr 2023 23:20:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: bcachefs as a caching filesystem
Content-Language: de-DE
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
References: <103b31f5-677c-caf8-f556-4a9c67c37ec4@arcor.de>
 <ZDQTI4Ep7yzw3g95@bfoster>
From:   =?UTF-8?Q?Dr=2e-Ing=2e_Heiko_M=c3=bcnkel?= <heiko.muenkel@arcor.de>
In-Reply-To: <ZDQTI4Ep7yzw3g95@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 5611
X-purgate-ID: 155817::1681248038-937FD4F8-42D5E402/0/0
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

On 10.04.23 15:46, Brian Foster wrote:
> FYI, there's no need to send multiple mails to the list. If you aren't
> sure whether your mail was delivered, you can always reference the
> archive at: https://lore.kernel.org/linux-bcachefs/.

Thanks for the hint. I had assumed that I would get the emails from the 
list including my own emails as well. Is that possible?


>> I am in the process of testing bcachefs. I have two partitions
>> /dev/nvme0n1p1 and /dev/sde1. The first (internal SSD) should be as cache
>> for the second (is an SSD on a USB3 port).
>>
>> First I created the bcachefs file system with:
>>    sudo bcachefs format \
>>         --label=Shotwell-3 /dev/sde1 \
>>         --label=Shotwell-Cache-1 /dev/nvme0n1p1 \
>>         --foreground_target /dev/nvme0n1p1 \
>>         --promote_target /dev/nvme0n1p1 \
>> --background_target /dev/sde1
>> and then mount the disks with
>>   sudo mount -t bcachefs /dev/nvme0n1p1:/dev/sde1 /mnt
>>
>> This worked fine so far. I then used dd to create a 100GB file on /mnt and
>> found, as expected, that the file was written much faster.
>>
> Hm. I don't have that amount of storage on my test box and I've not
> played around that much with multi-device support yet, but I gave your
> configuration a quick test with a couple smaller devices in my test
> environment.
>
> The first thing I see is that writes seem to hit the foreground target
> first, but very quickly move out to the background target. I.e., within
> a few seconds of completing a 10GB write with dd, the entire content
> seems to have been moved out to the background device.
>
> Is that consistent with what you observe, or is there a longer tail
> background copy going on? 'bcachefs fs usage <mnt>' should show how much
> data resides on each device, and you can watch it to see if data is
> still migrating around.

Yes, it's the same here.

>> Since I occasionally want to use the external disk on another machine, I
>> then tried disconnecting the cache from the array.
>>
>> Since I didn't really find anything in the documentation about this, I tried
>> the following command (after the external disk had come to rest and thus the
>> 100GB file was presumably also on the disk):
>>      bcachefs device evacuate /dev/nvme0n1p1
>>
>> After this command, it took what felt like hours for the external disk to
>> come to rest again. Is this normal?
>>
> It's not clear to me if the use case is to move the background disk
> (sde1 w/ bcachefs+data) or to clear out the nvme drive to be repurposed.

The goal is to occasionally use the external (background) disk on 
another PC. For this I need to be able to disconnect it from the cache 
and add it again later.


> In any event, in my test a 'bcachefs device evacuate' of my foreground
> drive completes almost instantly (since data was quickly moved off). If
> I repeat the process with my background drive, the userspace tool shows
> a progress meter and data migrates off the background device in ~30s or
> so. From there, I'm able to 'bcachefs device remove' the empty device
> without disruption [1], so I assume that's the appropriate process (if
> not, then I'm sure Kent can chime in..).

I thought that it is enough to evacuate the disk with the cache 
(foreground disk). Isn't it?

> I'm wondering if the background device is slow enough such the initial
> migrate is still going on when the evacuate starts. Do you see fs usage
> still adjusting after your copy completes? If not, what does the
> evacuate command show? Is it making progress or does it appear stuck? If
> the latter, does top show any activity, or is there a consistent stack
> trace shown in /proc/<pid of bcachefs evacuate cmd>/stack?

I've repeated the test, but now with only 10GB. The evacuate command 
needed only a few second to evacuate the foreground disk, but the 
background disk was again still working after the command finished (it's 
LED was still flickering for at least 36 minutes).

The background disk is also a SSD, so it's not realy slow.

The fs usage was still adjusting after the evacuate command ended. The 
number of buckets increased very slowly and the fragmented btree size 
droped also very slowly.

>
> [1] FWIW, I have managed to reproduce a locked up evacuate command in my
> attempts to repeat the test a couple times by removing/readding a
> device, monitoring usage, etc. Looking at my syslogs, I've hit a BUG
> report in the usage reporting path:
>
> BUG: unable to handle page fault for address: ffff99e55343b000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0003) - permissions violation
> PGD 213e01067 P4D 213e01067 PUD 101c33063 PMD 113408063 PTE 800000011343b061
> Oops: 0003 [#1] PREEMPT SMP PTI
> CPU: 60 PID: 7440 Comm: bcachefs Tainted: G            E      6.2.0+ #30
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc36 04/01/2014
> RIP: 0010:memcpy_erms+0x6/0x10
> ...
> Call Trace:
>   <TASK>
>   bch2_fs_usage_read+0x12d/0x270 [bcachefs]
> ...
>
> ... so I'll have to see if/how to reproduce that one. It might be wise
> to check your dmesg for unexpected events as well.
I didn't see this bug entry.
>
> Brian
>
>> Is this the right command for this case, or do I have to use the command
>>    bcachefs device offline /dev/nvme0n1p1
>> to disconnect the cache and
>>    bcachefs device online /dev/nvme0n1p1
>> to reconnect?
>>
>>
>> Thanks for your help,
>>
>> Heiko
>>
>>
>>
>>
>>
>>
