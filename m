Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC2EC32771
	for <linux-bcachefs@archiver.kernel.org>; Wed, 28 Sep 2022 09:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiI1J5l (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 28 Sep 2022 05:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiI1J50 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 28 Sep 2022 05:57:26 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6B8A7DA
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Sep 2022 02:57:23 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id s6so19552347lfo.7
        for <linux-bcachefs@vger.kernel.org>; Wed, 28 Sep 2022 02:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=temp123.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fIB5nsxLSDJJ39HngwPbaXjuaUMwASlm9ULh6uRbxi0=;
        b=lb/HnB/FTtc8OPikz52SGWDs/eGf6XSQKUcYiZYkaTTTk6wGfJ5uQa8ohzz7mQIW7i
         9ppASPRihi8J5bt1Wu8ZI3tQEQG+FUdQUT3Tv6vSnhgbkugRWPsQPwcjq4seaqGaeaPO
         5Jjwr5fbDscq6u2/cbGMv/2Rq9bRQlnzd1byQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fIB5nsxLSDJJ39HngwPbaXjuaUMwASlm9ULh6uRbxi0=;
        b=V8mB8D5JJcLEymHPCTpw5bgVb2qyVKjRN/Egjs3Pp5HqtaEoLkUm9SS2JeY7Uh+UG1
         FtWbMCCnQ3We7jJlwdrDBjBir0h7b8WXsahZuIeCMZZQ7+9zO+2FglQJdumj3vhd9rmO
         MPd5P/HopPdyP9iDenCABnNfS9wHSw3zTVWIWq4q5Z6xmvg9Z0yVq0fYubxLGnIMNqxJ
         r/q/qzY+0gNUqShe9p7jBo5PTnITABk/2FBzxydk5DJkK8RJL0MN6wldwtswGKc0mPOm
         4QPhT9I2CikC4tN/EvJtrs8fSZw4FYe/oEfqOH5KXuutijmOzz3yMsHrC+xEDElHkQ6s
         qeUA==
X-Gm-Message-State: ACrzQf0eo39tKx7+3dq/vr9WuE7lG2lWSBv5MeU+FsAEqam/9eTnUtwm
        JLoTMJ2dFQ3wY6iezdmsNEH/GaJ/UTsMtGTXbg0pAT1YjNmxaw==
X-Google-Smtp-Source: AMsMyM6P964I6zC4IYYahBmI75AVT1//0ruY1AFcYhxlBG9Rf5wMXw83kFBd+fdtLVL1sKsDNNvQv3GaF0guvbwSBAs=
X-Received: by 2002:a05:6512:224b:b0:49f:9e09:584e with SMTP id
 i11-20020a056512224b00b0049f9e09584emr12864156lfu.524.1664359041648; Wed, 28
 Sep 2022 02:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAKib_wJJCYxOzNqCAQOBBn2Y5mNgVXk-0Oow9Y0_=JNJvbgeDg@mail.gmail.com>
 <20220924232746.jii5xobipya7acbd@moria.home.lan>
In-Reply-To: <20220924232746.jii5xobipya7acbd@moria.home.lan>
From:   Josh Litherland <josh@temp123.org>
Date:   Wed, 28 Sep 2022 05:57:10 -0400
Message-ID: <CAKib_w+BtrwA60fhuS3dBK9Vr4orhigehvaPAkp_epUCfQ-v4g@mail.gmail.com>
Subject: Re: Secondary Superblock?
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Thank you!

I managed to recover my bcachefs filesystem with zero data loss by
running the following to restore the backup superblock:

for disk in sda sdb sdc sdd nvme0n1 nvme1n1 ; do
    dd if=/dev/$disk bs=512 count=2048 skip=4096 | dd of=/dev/$disk
bs=512 count=2048 seek=8 oflag=direct
done

(Naturally to anyone finding this in the future, don't copy and paste
that without knowing what it's doing.  High risk of data loss, etc
etc).

The issue I encountered was actually a bug in the "cryptsetup" tool,
and I'm going to be sending them a patch soon.  Essentially, when you
format a device with LUKS, it writes one superblock at position 0
(tagged with LUKS in ascii) and a second copy (tagged with SKUL) at
0x4000.  Then when you do "cryptsetup open", which you might
reasonably expect to be a safe and read-only operation, it will look
for the primary superblock.  Failing that, it will look for the
secondary and then, if it finds one,  will _silently and without
prompting the user_ restore the primary superblock, overwriting
whatever is there.  So, if a disk previously had LUKS on it, then was
formatted with bcachefs and used for a while, then you accidentally
run "cryptsetup open" on it again, it will destroy bcachefs's primary
superblock before even prompting for the LUKS passphrase.

You can reproduce this issue like so:

dd if=/dev/zero of=file bs=1M count=100
sudo cryptsetup luksFormat file
sudo mkfs.bcachefs file
sudo cryptsetup open file file-luks
sudo cryptsetup close file-luks

While it's clearly 100% cryptsetup's bug, you might consider
explicitly zeroing the region at 0x4000 during bcachefs format, just
to stop somebody else getting bitten by it.  It looks like, possibly
by sheer luck, every other filesystem I tested with happens to wipe
out the secondary LUKS superblock when formatting, so if somebody was
running ext2/3/4 or btrfs, they'd have never noticed this issue in
cryptsetup.

Thanks again for your advice on how to revive my system!

-- 
Josh Litherland (josh@temp123.org)


On Sat, Sep 24, 2022 at 7:27 PM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Sat, Sep 10, 2022 at 12:20:35AM -0400, Josh Litherland wrote:
> > Is there a secondary superblock somewhere on a bcachefs volume that I
> > can recover from in the event the primary gets overwritten?
> >
> > Context: I have/had an encrypted bcachefs laid across 4 hard drives
> > and 2 ssds.  Prior to experimenting with bcachefs, I had LUKS
> > encryption on the same drives.  I accidentally ran an old script that
> > ran "cryptsetup open" on all the drives, which astonishingly (1)
> > worked at all, and (2) overwrote the bcachefs superblock with a LUKS
> > one.  I'm still investigating how the hell that happened, but I have
> > reproduced it in testing.
> >
> > Is there any chance of finding a working copy of my bcachefs
> > superblock and restoring it?
>
> Yes - if you look at libbcachefs.c line 303 in bcachefs-tools, it allocates a
> backup superblock at the end of the disk (in addition to two at the start of the
> disk), which starts at the start of the last bucket.
>
> Maybe we could add some code to probe for the superblock at the end of the disk,
> and/or write the layout to the last sector in the partition.
>
> If you know the bucket size you formatted with and can calculate where the
> backup superblock should be, you can mount with the sb_offset= parameter.



-- 
Josh Litherland (josh@temp123.org)
