Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D49FC77B7A
	for <linux-bcachefs@archiver.kernel.org>; Mon, 17 Apr 2023 15:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbjDQPwQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 17 Apr 2023 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjDQPwO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 17 Apr 2023 11:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1DF6A56
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Apr 2023 08:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681746603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAnJfI7yyfifhsvJf/r5W9bHVyf8F2Uib6nZzXbksUk=;
        b=Sa2fe4qwlJvmQ2ZW2cdYVyE67KGrQEWY1LHnXNBoNHBwWOPm71pZRDgPsq6LIffLXxr2pg
        V+Xmx3ern9b4e4y5zhP6TJp032GiSOjkTkxzf5hOqeyh5FyJBnBYRfI7MO8PHcy2mcMpez
        AfnD+HP5HuyvphP7Ab/+Qj0RooSiCBM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-SAaKjtNdNOujS1WyrNJiOQ-1; Mon, 17 Apr 2023 11:50:02 -0400
X-MC-Unique: SAaKjtNdNOujS1WyrNJiOQ-1
Received: by mail-qk1-f199.google.com with SMTP id t23-20020a374617000000b0074a4dba4b5aso18785845qka.16
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Apr 2023 08:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681746602; x=1684338602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAnJfI7yyfifhsvJf/r5W9bHVyf8F2Uib6nZzXbksUk=;
        b=ghr11w28mNGUtYEzBv/wEvIZf/Sk+ioNZGjbJHFIZMmQ1xD+5g+092vlJ57VrSgLcr
         UYZS8hIG3S4QJdYWnmZorb4QWc/1ZTz6OBwu5vA6lsgLE9UhhvXp9BChKR2ZllJs7j9d
         VWgdc2rRsbkvwWe2YirjQikFRnrLjtbtjI4+uHlIyn8oYFLCw13AjDX9dGQgUs7qNWCi
         3m8AIbIlxcOb2/XlWWgUj1QakJq/8xpNU/Of3e+GKGGdJTlPsEjo6XJzvYmKHseBD5E8
         TYx9UliQBmj1n/1P+gsIsHDJZNQesZCS0Okyb9zRvfrXEKBZyFJ717hcDtZES5p1K4Ld
         hMug==
X-Gm-Message-State: AAQBX9ebV7N9xR1bu29o8FadWUOGl/xVo/We+T/+AOsaCFdd8chSWGfd
        +CVCs0iQLQCOYzooiakchUq9I4cJNg+/PJsTxmL19/Yebu8SUpTf8M5JABfqW/JMdT8Go0oE1vl
        +ImRStZ7uKoLopGLB7DigCNmthdU+cB5OFu8=
X-Received: by 2002:a05:622a:11d5:b0:3ef:2f81:7865 with SMTP id n21-20020a05622a11d500b003ef2f817865mr5896857qtk.33.1681746601689;
        Mon, 17 Apr 2023 08:50:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZdjddsZHSHvalYqAECtrc2jnzK/sNkYQH7CSOdJ/3lcrBH5LgDXkTauqSURfhwg7ON51wA5g==
X-Received: by 2002:a05:622a:11d5:b0:3ef:2f81:7865 with SMTP id n21-20020a05622a11d500b003ef2f817865mr5896772qtk.33.1681746600762;
        Mon, 17 Apr 2023 08:50:00 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id c204-20020a379ad5000000b0074ced3e0004sm650062qke.63.2023.04.17.08.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:50:00 -0700 (PDT)
Date:   Mon, 17 Apr 2023 11:52:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     =?iso-8859-1?Q?Dr=2E-Ing=2E_Heiko_M=FCnkel?= 
        <heiko.muenkel@arcor.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs as a caching filesystem
Message-ID: <ZD1rIxacR0I2HZbB@bfoster>
References: <103b31f5-677c-caf8-f556-4a9c67c37ec4@arcor.de>
 <ZDQTI4Ep7yzw3g95@bfoster>
 <e874a1d9-07f0-b977-673b-44da95a55363@arcor.de>
 <ZDhL1jHnZ36eBmzI@bfoster>
 <f5c268b2-d44c-c2d4-beba-12c5d0837365@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5c268b2-d44c-c2d4-beba-12c5d0837365@arcor.de>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Apr 15, 2023 at 06:54:42PM +0200, Dr.-Ing. Heiko Münkel wrote:
> 
> On 13.04.23 20:37, Brian Foster wrote:
> > On Tue, Apr 11, 2023 at 11:20:31PM +0200, Dr.-Ing. Heiko Münkel wrote:
> > > Hello,
> > > 
> > > On 10.04.23 15:46, Brian Foster wrote:
> > > > FYI, there's no need to send multiple mails to the list. If you aren't
> > > > sure whether your mail was delivered, you can always reference the
> > > > archive at: https://lore.kernel.org/linux-bcachefs/.
> > > Thanks for the hint. I had assumed that I would get the emails from the list
> > > including my own emails as well. Is that possible?
> > > 
> > > 
> > > > > I am in the process of testing bcachefs. I have two partitions
> > > > > /dev/nvme0n1p1 and /dev/sde1. The first (internal SSD) should be as cache
> > > > > for the second (is an SSD on a USB3 port).
> > > > > 
> > > > > First I created the bcachefs file system with:
> > > > >     sudo bcachefs format \
> > > > >          --label=Shotwell-3 /dev/sde1 \
> > > > >          --label=Shotwell-Cache-1 /dev/nvme0n1p1 \
> > > > >          --foreground_target /dev/nvme0n1p1 \
> > > > >          --promote_target /dev/nvme0n1p1 \
> > > > > --background_target /dev/sde1
> > > > > and then mount the disks with
> > > > >    sudo mount -t bcachefs /dev/nvme0n1p1:/dev/sde1 /mnt
> > > > > 
> > > > > This worked fine so far. I then used dd to create a 100GB file on /mnt and
> > > > > found, as expected, that the file was written much faster.
> > > > > 
> > > > Hm. I don't have that amount of storage on my test box and I've not
> > > > played around that much with multi-device support yet, but I gave your
> > > > configuration a quick test with a couple smaller devices in my test
> > > > environment.
> > > > 
> > > > The first thing I see is that writes seem to hit the foreground target
> > > > first, but very quickly move out to the background target. I.e., within
> > > > a few seconds of completing a 10GB write with dd, the entire content
> > > > seems to have been moved out to the background device.
> > > > 
> > > > Is that consistent with what you observe, or is there a longer tail
> > > > background copy going on? 'bcachefs fs usage <mnt>' should show how much
> > > > data resides on each device, and you can watch it to see if data is
> > > > still migrating around.
> > > Yes, it's the same here.
> > > 
> > > > > Since I occasionally want to use the external disk on another machine, I
> > > > > then tried disconnecting the cache from the array.
> > > > > 
> > > > > Since I didn't really find anything in the documentation about this, I tried
> > > > > the following command (after the external disk had come to rest and thus the
> > > > > 100GB file was presumably also on the disk):
> > > > >       bcachefs device evacuate /dev/nvme0n1p1
> > > > > 
> > > > > After this command, it took what felt like hours for the external disk to
> > > > > come to rest again. Is this normal?
> > > > > 
> > > > It's not clear to me if the use case is to move the background disk
> > > > (sde1 w/ bcachefs+data) or to clear out the nvme drive to be repurposed.
> > > The goal is to occasionally use the external (background) disk on another
> > > PC. For this I need to be able to disconnect it from the cache and add it
> > > again later.
> > > 
> > Hmm. IIUC, the foreground and promote targets specified above
> > essentially mark nvme0n1p1 as a fast/cache device and sde1 as the slower
> > background device. I'm a little confused why you would want to use sde1
> > in this sort of configuration. Assuming data is always going to flow
> > back into sde1 when it's part of the bcachefs volume, you'd end up
> > having to migrate data off and back on during every disconnect cycle.
> > 
> > That means that the foreground (nvme) device still has to be big enough
> > to hold all of the data in the fs, so what benefit is there to using
> > sde1 as a background device like this? Am I misunderstanding something
> > about the configuration or use case?
> 
> My idea was to take the faster internal (500GB size) disk nvme0n1p1 as a
> cache for the slower external (8TB size) disk sde1. This way I wanted to
> make it faster to work with the data on the external disk when it is
> attached to my PC. Occasionally I want to attach the external disk to my
> laptop, which of course then lacks the cache disk.
> I assumed that the cache disk can be smaller than the "actual" data disk,
> similar to the internal cache of a magnetic disk, for example.
> If I understood you correctly, the cache disk would have to be the same size
> as the main disk. Then the whole thing probably doesn't make sense.
> 

Ok. I was confused about whether you're trying to repurpose this device
to be used for something else or just to access the bcachefs data from
another system. It sounds more like the latter. Therefore, you
remove/drain the cache device from the volume such that everything
flushes to the slower backing dev, then can relocate that back and
forth. Sorry for the confusion.

With my limited knowledge of the interface and mechanism, I think your
use case makes sense and doesn't have any special size requirements for
the cache device. It just seems that frequent device
migrate/remove/re-add sequences might have some bugs that need attention
so this can be done reliably.

> > 
> > > > In any event, in my test a 'bcachefs device evacuate' of my foreground
> > > > drive completes almost instantly (since data was quickly moved off). If
> > > > I repeat the process with my background drive, the userspace tool shows
> > > > a progress meter and data migrates off the background device in ~30s or
> > > > so. From there, I'm able to 'bcachefs device remove' the empty device
> > > > without disruption [1], so I assume that's the appropriate process (if
> > > > not, then I'm sure Kent can chime in..).
> > > I thought that it is enough to evacuate the disk with the cache (foreground
> > > disk). Isn't it?
> > > 
> > That seems to be the case from my tests. Evacuate should mark the device
> > read-only and migrate data off so when complete, the device can be
> > explicitly removed from the volume.
> > 
> > > > I'm wondering if the background device is slow enough such the initial
> > > > migrate is still going on when the evacuate starts. Do you see fs usage
> > > > still adjusting after your copy completes? If not, what does the
> > > > evacuate command show? Is it making progress or does it appear stuck? If
> > > > the latter, does top show any activity, or is there a consistent stack
> > > > trace shown in /proc/<pid of bcachefs evacuate cmd>/stack?
> > > I've repeated the test, but now with only 10GB. The evacuate command needed
> > > only a few second to evacuate the foreground disk, but the background disk
> > > was again still working after the command finished (it's LED was still
> > > flickering for at least 36 minutes).
> > > 
> > > The background disk is also a SSD, so it's not realy slow.
> > > 
> > > The fs usage was still adjusting after the evacuate command ended. The
> > > number of buckets increased very slowly and the fragmented btree size droped
> > > also very slowly.
> > > 
> > I've been playing around with some evac-remove-add tests the past few
> > days and have reproduced some varying potentially problematic behaviors
> > (that I haven't had a chance to dig into yet). I've seen some cases
> > where data copies, but it seems like there's some background discard
> > work going on keeping the device busy. In other cases it seems like data
> > partially copies, then grinds down to a halt for some unknown reason.
> 
> I've seen in the output of the fs usage command, that some values were
> changing after the end of the evacuate command and before the external disk
> stops working. For me it seems, that the bcachefs driver tried to defragment
> the disk, although I don't understand, why the disk should be fragmented in
> that situation. I had only copied one big file on the disk and ran the
> evacute after it.
> 

I suppose it's possible some background activity is going on. I couldn't
say off the top of my head. I want to say I saw some discard activity on
some of my tests, for example. The more interesting question is that if
the evacuate completes, does any of this prevent device removal?

Brian

> > 
> > FWIW, I do seem to be able to evac data back and forth between the two
> > devices without any issues at all if I don't actually remove, but once I
> > remove and re-add devices, things start to behave a bit odd, including
> > fsck starting to complain about various things. I'll probably have to
> > look into some of this before I can comment further...
> > 
> > Brian
> > 
> > > > [1] FWIW, I have managed to reproduce a locked up evacuate command in my
> > > > attempts to repeat the test a couple times by removing/readding a
> > > > device, monitoring usage, etc. Looking at my syslogs, I've hit a BUG
> > > > report in the usage reporting path:
> > > > 
> > > > BUG: unable to handle page fault for address: ffff99e55343b000
> > > > #PF: supervisor write access in kernel mode
> > > > #PF: error_code(0x0003) - permissions violation
> > > > PGD 213e01067 P4D 213e01067 PUD 101c33063 PMD 113408063 PTE 800000011343b061
> > > > Oops: 0003 [#1] PREEMPT SMP PTI
> > > > CPU: 60 PID: 7440 Comm: bcachefs Tainted: G            E      6.2.0+ #30
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc36 04/01/2014
> > > > RIP: 0010:memcpy_erms+0x6/0x10
> > > > ...
> > > > Call Trace:
> > > >    <TASK>
> > > >    bch2_fs_usage_read+0x12d/0x270 [bcachefs]
> > > > ...
> > > > 
> > > > ... so I'll have to see if/how to reproduce that one. It might be wise
> > > > to check your dmesg for unexpected events as well.
> > > I didn't see this bug entry.
> > > > Brian
> > > > 
> > > > > Is this the right command for this case, or do I have to use the command
> > > > >     bcachefs device offline /dev/nvme0n1p1
> > > > > to disconnect the cache and
> > > > >     bcachefs device online /dev/nvme0n1p1
> > > > > to reconnect?
> > > > > 
> > > > > 
> > > > > Thanks for your help,
> > > > > 
> > > > > Heiko
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> > > > > 
> 

