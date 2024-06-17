Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1983719AA68
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718631473; cv=none; b=loxjpdPlWngIUew6yMEIxXiHLSiXROdt6LU7ePkM3g4eplaHlwRDvJHdv9ZD6TG0ybhyFfvt9HFeqHHnTDm+uvRifGk4czM9rlWizzoS31NwAa9Cu/LMnkONgtnLD5WGkwMBt8mtHnW3vQIV9jpuRlzwzcek2i6KeNkByJpww9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718631473; c=relaxed/simple;
	bh=NQdNeU4qXN5u/cvfa4YmP9hOej+wTGdqze0LpXU32tc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fse+em9myAyYG/QMV1LHmh2KX2El6tlSy3c5UCbd0A3hdmDolNtoF+w2lBUc3eBAzBoGfGvaO7w4uXEujCBh/fgO6IIb0pvfLGiJVGPYGw69rUOwNtTtjPTgGJqteuvK8ZnJL0yU9KwAbK5zDYqHHmdDrcwnH+AY1oc8c7PMXZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmmNUZEl; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmmNUZEl"
X-Envelope-To: syzbot+ffd2270f0bca3322ee00@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718631469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4jP1+vtfIGE42YbPzKjJ+ikH9kugd8yGrOn34t3cgUc=;
	b=JmmNUZEl/Of1JNkmG8XVZJWeQJtG0IROqBW7YJXev4MQAT+otKKXKh29t4Wt+NY8TORvR3
	8pft0C5TeV4BTGcWaV7OntJKJfxYGl8ytkMVshf4wpkQXQEblnuHlVq8lI1bhSWcxonccZ
	Xv0YVHc97dYQNhzMSc/2mpu0fRPmeV0=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 09:37:46 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+ffd2270f0bca3322ee00@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_journal_res_get
Message-ID: <kewuj4cgmjbmetwovhdmltrgsfeqd7zdsfll3szgb3shkpmtm3@ocpkmxty4man>
References: <000000000000aaf271061ac4c9ab@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000aaf271061ac4c9ab@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 13, 2024 at 05:39:19AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1210c3fc980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3b4350cf56c61c80
> dashboard link: https://syzkaller.appspot.com/bug?extid=ffd2270f0bca3322ee00
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16aecfba980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=171b3126980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/6ea21f50498b/disk-8867bbd4.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e2fed09364aa/vmlinux-8867bbd4.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4860173c7a18/Image-8867bbd4.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/bd29adaaf7ea/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ffd2270f0bca3322ee00@syzkaller.appspotmail.com
> 
> bcachefs (loop0): flushing journal and stopping allocators, journal seq 11
> bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 11
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/journal.h:375!
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Modules linked in:
> CPU: 1 PID: 6249 Comm: syz-executor102 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
> lr : bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
> sp : ffff80009b3076e0
> x29: ffff80009b3076e0 x28: 1fffe0001bf4957f x27: 0000000000000002
> x26: dfff800000000000 x25: 1ffff00013660ee8 x24: dfff800000000000
> x23: 1ffff00013660eec x22: dfff800000000000 x21: 0000000000000005
> x20: ffff0000dfa4a5c0 x19: ffff80009b307760 x18: 0000000000000008
> x17: 6c706d6f63207372 x16: ffff80008ae4f3c0 x15: 0000000000000002
> x14: 1ffff00013660eec x13: 0000000000000000 x12: 0000000000000000
> x11: ffff700013660eee x10: 0000000000ff0100 x9 : 0000000000000000
> x8 : ffff0000d62fbc80 x7 : 0000000000000000 x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000010
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>  bch2_journal_res_get+0x1a8/0x1b4 fs/bcachefs/journal.h:375
>  bch2_journal_meta+0x9c/0x268 fs/bcachefs/journal.c:828
>  bch2_fs_journal_stop+0x188/0x348 fs/bcachefs/journal.c:1179
>  __bch2_fs_read_only+0x2a4/0x3d0 fs/bcachefs/super.c:291
>  __bch2_fs_read_write+0x2f0/0x434 fs/bcachefs/super.c:507
>  bch2_fs_read_write+0xa8/0xf0 fs/bcachefs/super.c:520
>  bch2_remount+0x2bc/0x460 fs/bcachefs/fs.c:1731
>  legacy_reconfigure+0xfc/0x114 fs/fs_context.c:685
>  reconfigure_super+0x1d0/0x6f0 fs/super.c:1072
>  vfs_cmd_reconfigure fs/fsopen.c:267 [inline]
>  vfs_fsconfig_locked fs/fsopen.c:296 [inline]
>  __do_sys_fsconfig fs/fsopen.c:476 [inline]
>  __se_sys_fsconfig fs/fsopen.c:349 [inline]
>  __arm64_sys_fsconfig+0x8b8/0xc40 fs/fsopen.c:349
>  __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
>  invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
>  el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
>  do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
>  el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
>  el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
> Code: 17ffffab 9770cd61 d4210000 9770cd5f (d4210000) 
> ---[ end trace 0000000000000000 ]---
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
#syz fix: bcachefs: Fix early init error path in journal code
