Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6019D898
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732921028; cv=none; b=eMCt8cFSHDM88BaOTzkwSrSJ8WEfzCZeNELfAMKiUHFdv+FnVosAVOSNB31+IudWFldf/EiwNAjzFN18MmJTYnAs13orhWcnZwXEp/1lYp8u6IfZSKTmiOegM3gjXNUwqK2NO9ATCrVLvTGBbFrNcsiRgN26iGdaoxNbGba6BeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732921028; c=relaxed/simple;
	bh=yfB8CjLILU+eXCbs6FhXC1fkERSC975vxcC0xbDWO2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IitJY9s/TPIivYGs4y0LHg0q43S919zYcZ8wgSJETwIYKsyyszKe8dtFVrjMUnByoPv5q8gphzHx8g11Y/LtvGPTMze0UgPsMyv+SMEGCK3SzOnl8xJXf2UjJBgfbCNxHzs/oPizinUJy6IDJFBg3LLYnrl8nBQ3zF1Obts2K+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 29 Nov 2024 17:56:54 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] possible deadlock in trans_set_locked
Message-ID: <rykdmzcn6v34ss36cpff6i7cssityfmvipu7evxoklhsagb4py@7lwtulreg5o5>
References: <6749f54c.050a0220.253251.00bc.GAE@google.com>
 <vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz@5hibgcwmd3go>
 <CANp29Y65AipY2cNPV3opLjUdPxJ8tWGesBm6mkkN4HZ2K+gcxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y65AipY2cNPV3opLjUdPxJ8tWGesBm6mkkN4HZ2K+gcxQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 29, 2024 at 11:02:16PM +0100, Aleksandr Nogikh wrote:
> Hi Kent,
> 
> For reopened bugs, syzbot appends (2), (3), etc. at the end of the
> title. In this case, there are no numbers, so it has never reported
> anything with such a title before.
> 
> But it can well be the case that the underlying problem here is the
> same as in some other syzbot report (you could then "#syz dup" the new
> to the older one). If you happen to see patterns in such duplicate
> reports, please let us know and we'll try to improve the crash report
> parsing logic.

It looks identical to this one which I closed last night 

https://syzkaller.appspot.com/bug?extid=e088be3c2d5c05aaac35

Is that a parsing issue? The lockdep splats don't just look similar to
me, they look identical.

I've got another one that I closed last night that it seems might be
confusing for syzbot:
https://syzkaller.appspot.com/bug?extid=64e6509c7f777aec3a24

I fixed the patch that introduced the bug (it was only in -next), but I
don't seem to have a way to tell syzbot not to reopen it unless it sees
the updated patch.

Probably not a real issue with this particular bug - this exact situation
is pretty rare, but I do have bugs accumulating in my dashboard that
seem to have been fixed but I don't have a good way to close since I
don't know the patch that fixed them (not going to bisect 20+ fixes...)

> 
> -- 
> Aleksandr
> 
> On Fri, Nov 29, 2024 at 9:25 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Nov 29, 2024 at 09:09:32AM -0800, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/smmu'..
> > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=17d6af78580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=9bc44a6de1ceb5d6
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=78f4eb354f5ca6c1e6eb
> > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > > userspace arch: arm64
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107bdf5f980000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ae49e8580000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/4d4a0162c7c3/disk-7b1d1d4c.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/a8c47a4be472/vmlinux-7b1d1d4c.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/0e173b91f83e/Image-7b1d1d4c.gz.xz
> > > mounted in repro #1: https://storage.googleapis.com/syzbot-assets/5ab7b24d2900/mount_0.gz
> > > mounted in repro #2: https://storage.googleapis.com/syzbot-assets/fbfbb60588c1/mount_2.gz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com
> > >
> > > ======================================================
> > > WARNING: possible circular locking dependency detected
> > > 6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
> > > ------------------------------------------------------
> > > syz-executor203/6432 is trying to acquire lock:
> > > ffff0000da100128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x5c/0x21c fs/bcachefs/btree_locking.h:193
> > >
> > > but task is already holding lock:
> > > ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > >
> > > which lock already depends on the new lock.
> > >
> > >
> > > the existing dependency chain (in reverse order) is:
> > >
> > > -> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
> > >        __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
> > >        __mutex_lock kernel/locking/mutex.c:752 [inline]
> > >        mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
> > >        __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
> > >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
> > >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
> > >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
> > >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> > >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> > >        kthread+0x288/0x310 kernel/kthread.c:389
> > >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > >
> > > -> #0 (bcachefs_btree){+.+.}-{0:0}:
> > >        check_prev_add kernel/locking/lockdep.c:3161 [inline]
> > >        check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> > >        validate_chain kernel/locking/lockdep.c:3904 [inline]
> > >        __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> > >        lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> > >        trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> > >        __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> > >        bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> > >        __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> > >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
> > >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
> > >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
> > >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
> > >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> > >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> > >        kthread+0x288/0x310 kernel/kthread.c:389
> > >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > >
> > > other info that might help us debug this:
> > >
> > >  Possible unsafe locking scenario:
> > >
> > >        CPU0                    CPU1
> > >        ----                    ----
> > >   lock(&c->fsck_error_msgs_lock);
> > >                                lock(bcachefs_btree);
> > >                                lock(&c->fsck_error_msgs_lock);
> > >   lock(bcachefs_btree);
> > >
> > >  *** DEADLOCK ***
> > >
> > > 3 locks held by syz-executor203/6432:
> > >  #0: ffff0000dc600278 (&c->state_lock){++++}-{3:3}, at: bch2_run_online_recovery_passes+0x3c/0x174 fs/bcachefs/recovery_passes.c:204
> > >  #1: ffff0000dc604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:150
> > >  #2: ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > >
> > > stack backtrace:
> > > CPU: 1 UID: 0 PID: 6432 Comm: syz-executor203 Not tainted 6.12.0-syzkaller-g7b1d1d4cfac0 #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> > > Call trace:
> > >  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
> > >  dump_stack+0x1c/0x28 lib/dump_stack.c:129
> > >  print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
> > >  check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
> > >  check_prev_add kernel/locking/lockdep.c:3161 [inline]
> > >  check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> > >  validate_chain kernel/locking/lockdep.c:3904 [inline]
> > >  __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> > >  lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> > >  trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> > >  __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> > >  bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> > >  __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> > >  bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
> > >  bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
> > >  bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
> > >  bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
> > >  bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> > >  thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> > >  kthread+0x288/0x310 kernel/kthread.c:389
> > >  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > >
> > > If the report is already addressed, let syzbot know by replying with:
> > > #syz fix: exact-commit-title
> > >
> > > If you want syzbot to run the reproducer, reply with:
> > > #syz test: git://repo/address.git branch-or-commit-hash
> > > If you attach or paste a git patch, syzbot will apply it before testing.
> > >
> > > If you want to overwrite report's subsystems, reply with:
> > > #syz set subsystems: new-subsystem
> > > (See the list of subsystem names on the web dashboard)
> > >
> > > If the report is a duplicate of another one, reply with:
> > > #syz dup: exact-subject-of-another-report
> > >
> > > If you want to undo deduplication, reply with:
> > > #syz undup
> >
> > syzbot seems to now be re-opening bugs just because the patch hasn't
> > been merged into the branch it's testing?
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz%405hibgcwmd3go.
