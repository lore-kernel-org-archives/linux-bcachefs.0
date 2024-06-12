Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA212C816
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jun 2024 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718234977; cv=none; b=p1+lcji6SexCVex6WAZi7v7GRNg5tpu2m+QwEtiHreAWvJQByXUvptlX3KvKqhi+OZV7G2FkUnGYDqUBDOlpGzr5a/WKi8Kiw9oW5FXpxgXg0/jdamC4RFHNA2PevGOfqzwlMqmgCVgH3CeaHTEqqf3hP0sJ/WbArsUlb3d0ohY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718234977; c=relaxed/simple;
	bh=jg2Hi9k6fwxW2IpyOYwdjHzjY2x3RN1zTqa9ZNVIbhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkCOvDzVrY7ipKXXvoomecohwj3cp8hWDekcORVWNHeWjm5I3ZjeGJ6HXnLtnYL/AXN8+OSN3XyQmU9Ly/xjTMD+BgQsBAV43cz0vu5nIpn1AnZSFMDtTbyA68L6Scd2l9YJyWNP/p6Z2/7BQHosuAK545x5CxoQy7TtUORLZMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YLpr5uXR; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YLpr5uXR"
X-Envelope-To: syzbot+3cca837c2183f8f6fcaf@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718234973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yOh52ckwej5r18PRkVmjQlcSDns7+NZmhFSFXWhw010=;
	b=YLpr5uXRd/Nq2sg5r/RsshqLJkRrlm+FrmBkeYopcBuJKceSco8Fmzprh4ajLz4pjFxmDP
	CgwOz3kqL3x5XqYFhapTWaBUA1/Sh2CHAFhIovDShNWd0OZkLo2Z1jJpDEFJecnUAbL2ma
	KrSmM990lu4GD+iiWpJxNU35dn42FRM=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Wed, 12 Jun 2024 19:29:28 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+3cca837c2183f8f6fcaf@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING: locking bug in
 srcu_gp_start_if_needed
Message-ID: <6jwebqun2sbikkdeum7sxuhtqmiiergyj6tseuk6lbwtqipukg@g5jr4svt5pyd>
References: <0000000000002b1e82061a94aaef@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002b1e82061a94aaef@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 10, 2024 at 08:14:32PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d30d0e49da71 Merge tag 'net-6.10-rc3' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f5d896980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=96fd46a1ee1615e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=3cca837c2183f8f6fcaf
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d30d0e49.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/970e3906a552/vmlinux-d30d0e49.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d80af4a76ff6/bzImage-d30d0e49.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3cca837c2183f8f6fcaf@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(1)
> WARNING: CPU: 1 PID: 111 at kernel/locking/lockdep.c:232 hlock_class kernel/locking/lockdep.c:232 [inline]
> WARNING: CPU: 1 PID: 111 at kernel/locking/lockdep.c:232 hlock_class+0xfa/0x130 kernel/locking/lockdep.c:221
> Modules linked in:
> CPU: 1 PID: 111 Comm: kswapd0 Not tainted 6.10.0-rc2-syzkaller-00222-gd30d0e49da71 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:hlock_class kernel/locking/lockdep.c:232 [inline]
> RIP: 0010:hlock_class+0xfa/0x130 kernel/locking/lockdep.c:221
> Code: b6 14 11 38 d0 7c 04 84 d2 75 43 8b 05 b3 2e 77 0e 85 c0 75 19 90 48 c7 c6 80 be 2c 8b 48 c7 c7 20 b9 2c 8b e8 97 47 e5 ff 90 <0f> 0b 90 90 90 31 c0 eb 9e e8 98 f6 7f 00 e9 1c ff ff ff 48 c7 c7
> RSP: 0018:ffffc90000e9f338 EFLAGS: 00010086
> RAX: 0000000000000000 RBX: 00000000000018c4 RCX: ffffffff81511229
> RDX: ffff888019f8a440 RSI: ffffffff81511236 RDI: 0000000000000001
> RBP: 0000000000008000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 000000002d2d2d2d R12: 0000000000000000
> R13: 0000000000000000 R14: ffff888019f8afe8 R15: 00000000000018c4
> FS:  0000000000000000(0000) GS:ffff88802c100000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000eeb14000 CR3: 0000000046f74000 CR4: 0000000000350ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  check_wait_context kernel/locking/lockdep.c:4773 [inline]
>  __lock_acquire+0x3f2/0x3b30 kernel/locking/lockdep.c:5087
>  lock_acquire kernel/locking/lockdep.c:5754 [inline]
>  lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
>  __raw_spin_trylock include/linux/spinlock_api_smp.h:90 [inline]
>  _raw_spin_trylock+0x63/0x80 kernel/locking/spinlock.c:138
>  spin_lock_irqsave_sdp_contention kernel/rcu/srcutree.c:373 [inline]
>  srcu_gp_start_if_needed+0x75e/0xf00 kernel/rcu/srcutree.c:1233
>  bkey_cached_free fs/bcachefs/btree_key_cache.c:90 [inline]
>  bch2_btree_key_cache_scan+0xb90/0x1820 fs/bcachefs/btree_key_cache.c:886
>  do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
>  shrink_slab+0x18a/0x1310 mm/shrinker.c:662
>  shrink_one+0x493/0x7c0 mm/vmscan.c:4790
>  shrink_many mm/vmscan.c:4851 [inline]
>  lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4951
>  shrink_node mm/vmscan.c:5910 [inline]
>  kswapd_shrink_node mm/vmscan.c:6720 [inline]
>  balance_pgdat+0x1105/0x1970 mm/vmscan.c:6911
>  kswapd+0x5ea/0xbf0 mm/vmscan.c:7180
>  kthread+0x2c1/0x3a0 kernel/kthread.c:389
>  ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
#syz fix: bcachefs: Fix initialization order for srcu barrier
