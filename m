Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A85C433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed, 13 Apr 2022 22:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiDMWq0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Apr 2022 18:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiDMWqZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Apr 2022 18:46:25 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CD157495
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Apr 2022 15:44:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0B9B446;
        Wed, 13 Apr 2022 15:44:03 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id t45xQWj8_4mB; Wed, 13 Apr 2022 15:43:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9C1FE45;
        Wed, 13 Apr 2022 15:43:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9C1FE45
Date:   Wed, 13 Apr 2022 15:43:54 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Demi Marie Obenour <demi@invisiblethingslab.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS
In-Reply-To: <Yk05Sk4ztxLMpgrt@itl-email>
Message-ID: <3038961d-118f-24cb-e559-d3d7a7d918f3@ewheeler.net>
References: <Yk05Sk4ztxLMpgrt@itl-email>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 6 Apr 2022, Demi Marie Obenour wrote:
> How does bcachefs manage to outperform ZFS and BTRFS?  Obviously being
> licensed under GPL-compatible terms is an advantage for inclusion in
> Linux, but I am more interested in the technical aspects.

Hi Demi,

It sounds like you are curious about the technical implementation details, 
you might have a look at the architecture writeup and related 
documentation:
	https://bcachefs.org/Architecture/

> - How does bcachefs avoid the dreaded RAID write hole? 

I believe erasure coding will handle this, the Wiki says EC is still in 
dev.  However RAID1/10 works.

> - How does bcachefs avoid the nasty performance pitfalls that plague
>   BTRFS?  Are VM disks and databases on bcachefs fast?
> - How does an O_DIRECT loop device on bcachefs compare to a zvol on ZFS?

It would be great to see some benchmarks!  Demi, can you setup a disk 
benchmark on the Phoronix Test Suite and send us your findings?

Including NVMe-tiered bcachefs vs non-tiered benchmarks against ZFS+ARC 
and without ARC vs. btrfs would be interesting.  Including XFS and EXT4 as 
a baseline would be good to see to.

A second benchmark showing performance across snapshots would be 
informative as well; it would indicate the COW performance behavior of 
bcachefs vs zfs bs btrfs.

Kent might be interested in updating the performance page on the Wiki if 
you can provide numbers!

> - Is there a good description of the bcachefs on-disk format anywhere?

Same link: https://bcachefs.org/Architecture/ and also see these on the 
right side of the page:
    BtreeIterators
    BtreeNodes
    BtreeWhiteouts
    Encryption
    Transactions
    Snapshots
    Allocator
    Fsck
    Roadmap


> - What are the internal abstraction layers used in bcachefs?  Is it a
>   key-value store with a filesystem on top of it, the way ZFS is?

b-tree :)

> - Is it possible to shrink a bcachefs filesystem?  Does bcachefs have
>   any restrictions regarding the size of disks in a pool, or can I just
>   throw a bunch of varying-size disks at bcachefs and have it spread the
>   data around automatically to provide the level of redundancy I want?

Kent?

> - Can bcachefs use faster storage as a cache for slower storage, or
>   otherwise move data around based on usage patterns?

Tiered storage.  See "Feature Status" here:
	https://bcachefs.org/

> - Can bcachefs saturate your typical NVMe drive on realistic workloads?
>   Can it do so with encryption enabled?

Benchmarks welcome ;)

> - Is support for swap files on bcachefs planned?  That would require
>   being able to perform O_DIRECT asynchronous writes without any memory
>   allocations.

Its on the roadmap:
	https://bcachefs.org/Todo/

> - Is bcachefs being used in production anywhere?

I believe there are users with bcachefs running as the root filesystem 
(Kent, didn't you say you boot from bcachefs?).

We are experimenting with using it as a MySQL database filesystem but do 
not yet have data on that subject.

-Eric
