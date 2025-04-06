Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B79526289
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Apr 2025 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743965318; cv=none; b=R8qNyOQYwZKYbkIUZ6UviKAKj34k9BjUBxvJT/ghdqT9Uo55kq1bUrpBk9pr9y8iC0ZZhofP1jpBbzg89D5rs6QlGdPy/ZzSuCItVIpkNJHX6iDECNk6JFMsw/Z93GhwnC1zNVYrdrm87Vbn9kKDgFNA8vjW0aIN7nGrf1wnUJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743965318; c=relaxed/simple;
	bh=u9Kf3qowMlxU8RQDK76OOlcQddRSMyRSS4Z1eabxKVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEfBI54t7vXLbLYE76BH6DdSm/TAdby8ZOQapowtQFEBpATXtdCjvAo3W/meQOltI7fOrKOXqbqBnogsjrInKnJjEFTGDj0wWoNZqe2jXPUxEATprgvYqJZBkpd8Z1xL2BDs7xt4ePK+ibeJpOYPkYVQ6VsDLjXvOmuXelmAU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vJ3a7cFB; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vJ3a7cFB"
Date: Sun, 6 Apr 2025 14:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743965309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iogtLg1UXo9nSoVjAl3atukJO4dFMr2eGJKXZHkGJdg=;
	b=vJ3a7cFBns37ZHcB7EIc48rRiHYiintoREHUWrqub8GKbtjwaIpjzij0XFKVokOa0cRZ2w
	z56IYyoi/DUwviO4fqXaU+OaOiClMJfORrtlzqF2kZH6a9DSnS4zQOx9TulNhhpN3wiNfo
	rfx7DJDZw5tbduokG8RNEaNz/wOVRrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: syzbot <syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work
 (2)
Message-ID: <r7w5gnzuvx372uqkzqk6lwy74kcg64uxaccwmwetdd6ubtmlye@3xwnqo7peqlk>
References: <67f2bf20.050a0220.0a13.0270.GAE@google.com>
 <777BAF56-3BB9-4602-806D-7EF157183BA5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777BAF56-3BB9-4602-806D-7EF157183BA5@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 07, 2025 at 02:11:54AM +0800, Alan Huang wrote:
> On Apr 7, 2025, at 01:51, syzbot <syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com> wrote:
> > 
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    a2392f333575 drm/panthor: Clean up FW version information ..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17077c3f980000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=8cceedf2e27e877d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=674ccd0645d379ed5f80
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fd894c580000
> > 
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/7df8ceab3279/disk-a2392f33.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/42c5af403371/vmlinux-a2392f33.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/73599b849e20/Image-a2392f33.gz.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/fd7871ac7900/mount_0.gz
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com
> > 
> > INFO: task kworker/1:4:6586 blocked for more than 143 seconds.
> >      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:kworker/1:4     state:D stack:0     pid:6586  tgid:6586  ppid:2      task_flags:0x4208060 flags:0x00000008
> > Workqueue: events_long bch2_fs_read_only_work
> > Call trace:
> > __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
> > context_switch kernel/sched/core.c:5378 [inline]
> > __schedule+0x1360/0x257c kernel/sched/core.c:6765
> > __schedule_loop kernel/sched/core.c:6842 [inline]
> > schedule+0xbc/0x238 kernel/sched/core.c:6857
> > schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6914
> > rwsem_down_write_slowpath+0xd10/0x14c8 kernel/locking/rwsem.c:1176
> > __down_write_common kernel/locking/rwsem.c:1304 [inline]
> > __down_write kernel/locking/rwsem.c:1313 [inline]
> > down_write+0xb4/0xc0 kernel/locking/rwsem.c:1578
> 
> state_lock
> 
> > bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
> > process_one_work+0x810/0x1638 kernel/workqueue.c:3238
> > process_scheduled_works kernel/workqueue.c:3319 [inline]
> > worker_thread+0x97c/0xeec kernel/workqueue.c:3400
> > kthread+0x65c/0x7b0 kernel/kthread.c:464
> > ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > INFO: task syz.0.388:10111 blocked for more than 143 seconds.
> >      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > task:syz.0.388       state:D stack:0     pid:10111 tgid:10110 ppid:6583   task_flags:0x400140 flags:0x0000000d
> > Call trace:
> > __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
> > context_switch kernel/sched/core.c:5378 [inline]
> > __schedule+0x1360/0x257c kernel/sched/core.c:6765
> > __schedule_loop kernel/sched/core.c:6842 [inline]
> > schedule+0xbc/0x238 kernel/sched/core.c:6857
> > __closure_sync+0x198/0x29c lib/closure.c:146
> > closure_sync include/linux/closure.h:195 [inline]
> 
> sync with state_lock held

we're trying to go read only before recovery's finished

I just changed recovery to not run with state_lock held, this ought to
be fixed now

>  
> > bch2_journal_flush_pins+0x1e0/0x348 fs/bcachefs/journal_reclaim.c:911
> > bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
> > bch2_journal_replay+0x1c28/0x1f64 fs/bcachefs/recovery.c:442
> > bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:226
> > bch2_run_recovery_passes+0x260/0x92c fs/bcachefs/recovery_passes.c:291
> > bch2_fs_recovery+0x20e0/0x32ec fs/bcachefs/recovery.c:936
> > bch2_fs_start+0x32c/0x570 fs/bcachefs/super.c:1041
> > bch2_fs_get_tree+0xa50/0x11d4 fs/bcachefs/fs.c:2203
> > vfs_get_tree+0x90/0x28c fs/super.c:1814
> > do_new_mount+0x278/0x900 fs/namespace.c:3560
> > path_mount+0x590/0xe04 fs/namespace.c:3887
> > do_mount fs/namespace.c:3900 [inline]
> > __do_sys_mount fs/namespace.c:4111 [inline]
> > __se_sys_mount fs/namespace.c:4088 [inline]
> > __arm64_sys_mount+0x4f4/0x5d0 fs/namespace.c:4088
> > __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> > invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
> > el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
> > do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
> > el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
> > el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
> > el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
> > 
> > Showing all locks held in the system:
> > 1 lock held by khungtaskd/32:
> > #0: ffff80008ff22620 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0xc/0x44 include/linux/rcupdate.h:336
> > 1 lock held by udevd/6081:
> > 2 locks held by getty/6220:
> > #0: ffff0000d74fa0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
> > #1: ffff80009bf4e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41c/0x1228 drivers/tty/n_tty.c:2211
> > 3 locks held by kworker/1:4/6586:
> > #0: ffff0000c0029548 ((wq_completion)events_long){+.+.}-{0:0}, at: process_one_work+0x674/0x1638 kernel/workqueue.c:3212
> > #1: ffff80009f6b7ba0 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_one_work+0x708/0x1638 kernel/workqueue.c:3212
> > #2: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
> > 1 lock held by syz.0.388/10111:
> > #0: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_start+0x50/0x570 fs/bcachefs/super.c:1010
> > 2 locks held by kworker/1:5/11232:
> > #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:598 [inline]
> > #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock kernel/sched/sched.h:1521 [inline]
> > #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1852 [inline]
> > #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x2e0/0x257c kernel/sched/core.c:6688
> > #1: ffff0001b375d408 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x394/0x5e8 kernel/sched/psi.c:987
> > 2 locks held by syz.3.1147/16990:
> > 2 locks held by syz.4.1148/16993:
> > #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:833 [inline]
> > #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1238/0x299c fs/bcachefs/super.c:2065
> > #1: ffff0000fc5049b0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x198/0x290 fs/bcachefs/replicas.c:600
> > 3 locks held by syz.5.1149/17000:
> > 2 locks held by syz.2.1150/17009:
> > 
> > =============================================
> > 
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > 
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> > 
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
> > 
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> > 
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> > 
> > If you want to undo deduplication, reply with:
> > #syz undup
> > 
> 
