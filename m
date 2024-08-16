Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E011BBBD3
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723825843; cv=none; b=ODnRqygb0CPhRCjE7Q14PWsgiUEKDP4rjgdKcEXczexCa+Oi65WE8kR/lwYXK4l4thQyivzeYFCYGe88VKpM2Z3mhYN8E/gwjPOUDtMf67rhljocuhqvfpIUc+oqZTYesYBU3V+Bu/B2qoFt5pxkfO8AU8Hg5GEqW2axXWiC2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723825843; c=relaxed/simple;
	bh=fhI+AxJgodRhBrVpx6YMJdjD3ujLIPuHAR24o9HAg7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iqf9eeTsiAstV8Bid/0vG1zwkEFfqljWbJkmZhVZxHF6zzpvqwUM/ubFCG6iWPcajND5bEv/jBXIG+4Fr8sxTdz0v/NfcrG9gJPleSp37D5o2J7MPNveECwqqPhsNU1JYa4DHJDxgb0Cdi5vIVG7FJi5wO2c71mvgrYU+k0vh0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AIRkl7VR; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AIRkl7VR"
Date: Fri, 16 Aug 2024 12:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723825837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FcSFXJuNQqMeWMujhgpMJbeShZbtz0jO3Qs40ohVmpo=;
	b=AIRkl7VRdTcWWhzlSU3pf6rImoMdkKPTcib/PFNsGZozIiQZb+GI1WuTltK0ZXDfRxJbay
	5Yyvd7NwKUNRXDLXIvJvtLcCB02uRYyYoWMRPATV61z/jpUf05fk9P2LVipiMB32zDTtBZ
	wZPjwCNXBbafemw7lIP8rDlLS3Tcods=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in discard_new_inode
Message-ID: <ho6vtmwtscjszkoceusnf6rff72svhtbj6kbbqupl76dkvpybv@zmjaeybnmqsw>
References: <0000000000005bb657061fc9e31e@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005bb657061fc9e31e@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 16, 2024 at 02:50:23AM GMT, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d7a5aa4b3c00 Merge tag 'perf-tools-fixes-for-v6.11-2024-08..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=131e27c5980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
> dashboard link: https://syzkaller.appspot.com/bug?extid=95e40eae71609e40d851
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150be3c5980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=165c93cb980000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d7a5aa4b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/af15738cca6c/vmlinux-d7a5aa4b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/62dacb1384ee/bzImage-d7a5aa4b.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/92de1b01cc1a/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+95e40eae71609e40d851@syzkaller.appspotmail.com
> 
> R13: 00007f7d2a233210 R14: 0000000000000001 R15: 0032656c69662f2e
>  </TASK>

Dmitry, this bug has been fixed upstream, and I've been seeing others
where syzbot appears to be generating reports for bugs that have been
fixed (e.g. BUG() in bch2_fs_journal_stop() long after that was changed
to a warning).

I don't know what's going on, but the report appears to be in error.

> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5116 at fs/inode.c:1143 discard_new_inode+0x217/0x2a0 fs/inode.c:1143
> Modules linked in:
> CPU: 0 UID: 0 PID: 5116 Comm: syz-executor345 Not tainted 6.11.0-rc3-syzkaller-00156-gd7a5aa4b3c00 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:discard_new_inode+0x217/0x2a0 fs/inode.c:1143
> Code: 00 e8 ad d7 59 ff 4c 89 f7 e8 e5 98 ad 09 4c 89 e7 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 9f 00 00 00 e8 ba 6e 80 ff 90 <0f> 0b 90 42 80 3c 2b 00 75 ae eb b4 44 89 e1 80 e1 07 fe c1 38 c1
> RSP: 0018:ffffc90002d1f1e0 EFLAGS: 00010293
> RAX: ffffffff82131c36 RBX: 1ffff110078521f2 RCX: ffff888018a94880
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff82131bdd R09: fffff520005a3e2c
> R10: dffffc0000000000 R11: fffff520005a3e2c R12: ffff88803c290ec0
> R13: dffffc0000000000 R14: ffff88803c290f40 R15: ffff88803c290f90
> FS:  00007f7d2a2336c0(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4c62ac2440 CR3: 000000003a4be000 CR4: 0000000000350ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bch2_inode_insert+0x35b/0x3d0 fs/bcachefs/fs.c:203
>  bch2_lookup_trans fs/bcachefs/fs.c:465 [inline]
>  bch2_lookup+0x1014/0x16c0 fs/bcachefs/fs.c:483
>  lookup_open fs/namei.c:3556 [inline]
>  open_last_lookups fs/namei.c:3647 [inline]
>  path_openat+0x11cc/0x3470 fs/namei.c:3883
>  do_filp_open+0x235/0x490 fs/namei.c:3913
>  do_sys_openat2+0x13e/0x1d0 fs/open.c:1416
>  do_sys_open fs/open.c:1431 [inline]
>  __do_sys_openat fs/open.c:1447 [inline]
>  __se_sys_openat fs/open.c:1442 [inline]
>  __x64_sys_openat+0x247/0x2a0 fs/open.c:1442
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7d2a2861a9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 71 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7d2a233208 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f7d2a30c6a8 RCX: 00007f7d2a2861a9
> RDX: 0000000000000000 RSI: 0000000020004280 RDI: ffffffffffffff9c
> RBP: 00007f7d2a30c6a0 R08: 00007f7d2a232fa7 R09: 0000000000000038
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7d2a2d9090
> R13: 00007f7d2a233210 R14: 0000000000000001 R15: 0032656c69662f2e
>  </TASK>
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
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
