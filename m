Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961B0CDB47E
	for <linux-bcachefs@archiver.kernel.org>; Fri, 20 Oct 2023 11:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377147AbjJTLsF (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 20 Oct 2023 07:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377351AbjJTLsA (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 20 Oct 2023 07:48:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA6211D
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 04:38:12 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ca052ec63bso5721205ad.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 20 Oct 2023 04:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1697801890; x=1698406690; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHc4Q7aNLDfKDMEpMkUlEYG6owovem3B/txsOLe61Kk=;
        b=fGAwJgWClOMTXj/GPBgYw/PPekWiRMMiuDvxus4Kh2+ZKQ+SD4/m8ISwbaj0xN4R9X
         K6dUNEBHkx+46ngn6mzjY5Cz/VNXPVftr6j4UttnLvIkJcSNvF6H+TOHL9ro7BMRIB4F
         J7bG6xpZSxuD3g274JIh7kgTejmJnG0213y6Xdke5Fa36xvTdWhWfTdgG2uFlQUAXDY6
         TQsu1l5I37N5qNNOwKu2IzbxlJHfpsDY/4O1Uw7OkWAdcY5Gm07dFFiEVr3J8mzjV8tf
         awKFANJV4ojsz7Yts7wmqo7hancBaZBHqxpcIAxlSoyIcPVtRAQJaXgY9rxd+mfkNZ2M
         kKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697801890; x=1698406690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHc4Q7aNLDfKDMEpMkUlEYG6owovem3B/txsOLe61Kk=;
        b=Ne9+R22gJwGvmoUUDLJCZYK1Ywx20x/LTY/rWBvPc5aUuqM+BnGpy9kiyonpZAyb5w
         Le9Yqkzu+MqGE4yGbsShekjG2ifaahEFn9jnzpvoJ0l07lXw91YDA2oWxgiJLnrthB7V
         UAIbKvKDjMXE07hK60L6pUYlKbhkSG4Xc5qvM16t//0Gw8GeKOt6Kt821CLhCl43s8U9
         IDzI/DqFU6IeT7ib3919bIMRiALUMb8oLEEwQ2U/n/8Vv0RmELXxbDofSiDo1kQG40rW
         QnucHCftxOyhI+rhozZDlPZ2OyD7rWv3bmnFnhmwN+XNmHKscPFe4iCJ6NGZgmaxnYbi
         rDMQ==
X-Gm-Message-State: AOJu0YzsjnALSJlSkKB0tLqZRnmRTzaCpivyIH1zj03CXPz6jtX/ttX/
        GpnIOi+SwMGlcXNX9dCq134Glg==
X-Google-Smtp-Source: AGHT+IHUpNmeTOpQidbdUgCos1qKRsn99on/JSt7Z4rUgyZa0bTb+iBZXSnvJkeNczJcNMs80YRlZA==
X-Received: by 2002:a17:903:1210:b0:1c6:2dbb:e5fa with SMTP id l16-20020a170903121000b001c62dbbe5famr1875051plh.44.1697801890145;
        Fri, 20 Oct 2023 04:38:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902ed0100b001b392bf9192sm1323598pld.145.2023.10.20.04.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 04:38:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qtnpO-001Ylg-31;
        Fri, 20 Oct 2023 22:38:06 +1100
Date:   Fri, 20 Oct 2023 22:38:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Mateusz Guzik <mjguzik@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: (subset) [PATCH 22/32] vfs: inode cache conversion to hash-bl
Message-ID: <ZTJmnsAxGDnks2aj@dread.disaster.area>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-23-kent.overstreet@linux.dev>
 <20230523-zujubeln-heizsysteme-f756eefe663e@brauner>
 <20231019153040.lj3anuescvdprcq7@f>
 <20231019155958.7ek7oyljs6y44ah7@f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019155958.7ek7oyljs6y44ah7@f>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Oct 19, 2023 at 05:59:58PM +0200, Mateusz Guzik wrote:
> On Thu, Oct 19, 2023 at 05:30:40PM +0200, Mateusz Guzik wrote:
> > On Tue, May 23, 2023 at 11:28:38AM +0200, Christian Brauner wrote:
> > > On Tue, 09 May 2023 12:56:47 -0400, Kent Overstreet wrote:
> > > > Because scalability of the global inode_hash_lock really, really
> > > > sucks.
> > > > 
> > > > 32-way concurrent create on a couple of different filesystems
> > > > before:
> > > > 
> > > > -   52.13%     0.04%  [kernel]            [k] ext4_create
> > > >    - 52.09% ext4_create
> > > >       - 41.03% __ext4_new_inode
> > > >          - 29.92% insert_inode_locked
> > > >             - 25.35% _raw_spin_lock
> > > >                - do_raw_spin_lock
> > > >                   - 24.97% __pv_queued_spin_lock_slowpath
> > > > 
> > > > [...]
> > > 
> > > This is interesting completely independent of bcachefs so we should give
> > > it some testing.
> > > 
> > > I updated a few places that had outdated comments.
> > > 
> > > ---
> > > 
> > > Applied to the vfs.unstable.inode-hash branch of the vfs/vfs.git tree.
> > > Patches in the vfs.unstable.inode-hash branch should appear in linux-next soon.
> > > 
> > > Please report any outstanding bugs that were missed during review in a
> > > new review to the original patch series allowing us to drop it.
> > > 
> > > It's encouraged to provide Acked-bys and Reviewed-bys even though the
> > > patch has now been applied. If possible patch trailers will be updated.
> > > 
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > > branch: vfs.unstable.inode-hash
> > > 
> > > [22/32] vfs: inode cache conversion to hash-bl
> > >         https://git.kernel.org/vfs/vfs/c/e3e92d47e6b1
> > 
> > What, if anything, is blocking this? It is over 5 months now, I don't
> > see it in master nor -next.

Not having a test machine that can validate my current vfs-scale
patchset for 4 of the 5 months makes it hard to measure and
demonstrate the efficacy of the changes on a current kernel....

> > To be clear there is no urgency as far as I'm concerned, but I did run
> > into something which is primarily bottlenecked by inode hash lock and
> > looks like the above should sort it out.
> > 
> > Looks like the patch was simply forgotten.
> > 
> > tl;dr can this land in -next please
> 
> In case you can't be arsed, here is something funny which may convince
> you to expedite. ;)
> 
> I did some benching by running 20 processes in parallel, each doing stat
> on a tree of 1 million files (one tree per proc, 1000 dirs x 1000 files,
> so 20 mln inodes in total).  Box had 24 cores and 24G RAM.
> 
> Best times:
> Linux:          7.60s user 1306.90s system 1863% cpu 1:10.55 total
> FreeBSD:        3.49s user 345.12s system 1983% cpu 17.573 total
> OpenBSD:        5.01s user 6463.66s system 2000% cpu 5:23.42 total
> DragonflyBSD:   11.73s user 1316.76s system 1023% cpu 2:09.78 total
> OmniosCE:       9.17s user 516.53s system 1550% cpu 33.905 total
> 
> NetBSD failed to complete the run, OOM-killing workers:
> http://mail-index.netbsd.org/tech-kern/2023/10/19/msg029242.html
> OpenBSD is shafted by a big kernel lock, so no surprise it takes a long
> time.
> 
> So what I find funny is that Linux needed more time than OmniosCE (an
> Illumos variant, fork of Solaris).
> 
> It also needed more time than FreeBSD, which is not necessarily funny
> but not that great either.
> 
> All systems were mostly busy contending on locks and in particular Linux
> was almost exclusively busy waiting on inode hash lock.

Did you bother to test the patch, or are you just complaining
that nobody has already done the work for you?

Because if you tested the patch, you'd have realised that by itself
it does nothing to improve performance of the concurrent find+stat
workload. The lock contention simply moves to the sb_inode_list_lock
instead.

Patches to get rid of the  sb_inode_list_lock contention were
written by smarter people than me long before I wrote the hash-bl
patches. However, the problem the dlist stuff was written to address
(sync iterating all inodes causing sb inode list lock contention
when we have a hundred million cached inodes in memory) was better
fixed by changing the sync algorithm not to iterate all cached
inodes just to find the handful of dirty ones it needed to sync.

IOWs, those sb_inode_list_lock changes haven't been included for the
same reason as the hash-bl patches: outside micro-benchmarks, these
locks just don't show up in profiles on production machines.
Hence there's no urgency to "fix" these lock contention
problems despite the ease with which micro-benchmarks can reproduce
it...

I've kept the patches current for years, even though there hasn't
been a pressing need for them. The last "vfs-scale" version I did
some validation on is here:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/log/?h=vfs-scale

5.17 was the last kernel I did any serious validation and
measurement against, and that all needs to be repeated before
proposing it for inclusion because lots of stuff has changed since I
last did some serious multi-filesystem a/b testing of this code....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
