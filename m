Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60514C433F5
	for <linux-bcachefs@archiver.kernel.org>; Thu, 17 Mar 2022 23:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiCQXlZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 17 Mar 2022 19:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiCQXlY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 17 Mar 2022 19:41:24 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F18C74B5
        for <linux-bcachefs@vger.kernel.org>; Thu, 17 Mar 2022 16:40:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 88FC247;
        Thu, 17 Mar 2022 16:40:05 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id gmhOxhwUt7Fa; Thu, 17 Mar 2022 16:40:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8644940;
        Thu, 17 Mar 2022 16:40:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8644940
Date:   Thu, 17 Mar 2022 16:40:02 -0700 (PDT)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs filesystem corruption
In-Reply-To: <20220317010742.dm35ejttjbjrddsi@moria.home.lan>
Message-ID: <df529764-f2d4-9c23-23ca-581155df7e@ewheeler.net>
References: <a55372e3-c4d5-ecb0-782e-242d166140c5@lists.ewheeler.net> <20220317010742.dm35ejttjbjrddsi@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 16 Mar 2022, Kent Overstreet wrote:
> On Wed, Mar 16, 2022 at 03:58:34PM -0700, Eric Wheeler wrote:
> > Hi Kent,
> > 
> > The MySQL+snapshots deployment we has become corrupt and InnoDB is 
> > crashing with a stack trace and lots of borken database noise.
> > 
> > We are going to rebuild it from other replicas and see if it happens 
> > again.  We started using your new-allocator code (commit 
> > 3985f5f4eff86ee667da7da6e36ca2c346f56be3) after the original deployment 
> > and we haven't re-loaded since you fixed the snapshot iterator issue, or 
> > maybe it broke during the allocator conversion, can't be certain.
> > 
> > There isn't any especially obvious problem but there are some WARNING's 
> > below that you might look at.
> > 
> > There were lots of these:
> > 	WARNING: CPU: 0 PID: 7796 at fs/bcachefs/fs-io.c:1290 
> > 	  bch2_writepage_io_done (fs/bcachefs/fs-io.c:1290 (discriminator 1)) bcachefs
> 
> So the warnings are just a symptom, and not terribly interesting. I'm changing
> them to WARN_ON_ONCE().
> 
> > bcachefs (dm-6): initializing new filesystem
> > bcachefs (dm-6): going read-write
> > bucket 0:10 gen 0 different types of data in same bucket: btree, journal
> > while marking journal
> 
> ^ That's probably the real culprit - we're using the same bucket for both
> journal and btree, no wonder things got hosed.
> 
> Interesting bug, something strange must have happened for us to not catch this
> right away.

The deployment would have been like this:

1. Make lots of subvolumes
2. Deploy mysql instances with their --datadir pointing to the subvols
3. Snapshot every 4 hrs
4. Crash because of iterator issue
5. Reboot with iterator+new allocator.  This would have done the allocator 
   upgrade to add the new structures.
6. The rest is in this email thread.

Also we have a weird problem where mkfs hangs, not sure if it is 
relavent, maybe mkfs isn't finishing, but we think it is because it mounts 
wihout error:

We have to run mkfs then ctrl-c.  It seems to finish and mount, not sure 
what the problem is there.  These are the RPM versions of the libraries 
reported by `ldd bcachefs` that we are using in el7 build:

	bzip2-libs-1.0.6-13.el7.x86_64
	elfutils-libelf-0.176-5.el7.x86_64
	elfutils-libs-0.176-5.el7.x86_64
	glibc-2.17-325.el7_9.x86_64
	keyutils-libs-1.5.8-3.el7.x86_64
	libaio-0.3.109-13.el7.x86_64
	libattr-2.4.46-13.el7.x86_64
	libblkid-2.23.2-65.el7.x86_64
	libcap-2.22-11.el7.x86_64
	libgcc-4.8.5-44.el7.x86_64
	libsodium-1.0.18-1.el7.x86_64
	libuuid-2.23.2-65.el7.x86_64
	libzstd-1.5.0-1.el7.x86_64
	lz4-1.8.3-1.el7.x86_64
	systemd-libs-219-78.el7.x86_64
	userspace-rcu-0.10.1-4.el7.x86_64
	xz-libs-5.2.2-1.el7.x86_64
	zlib-1.2.7-19.el7_9.x86_64

Haven't investigated with gdb, not sure where it is stuck.

> Would it be possible for you to dump the filesystem metadata for me, with the
> bcachefs dump tool? I might get some clues from examining it.

Does bcachefs dump include any user data?  Metadata is fine, but the 
content needs to stay private.

Please confirm that there is no metadata and I'll send the meta.

> Also, how long was the system in use before this happened? How many reboots?

Only 1 or 2 reboots.  Basically we set it up and it crashed because of the 
iterator issue. Then we rebooted into the new kernel with both your 
iterator fix and the new allocater update.  I think that's about it 
though.

> Were you by chance running the resize-journal command?

Nope.  

--
Eric Wheeler


