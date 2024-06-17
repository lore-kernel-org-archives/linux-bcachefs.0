Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC8F1A3BC7
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630488; cv=none; b=P9DEoqffzIuIKGAmOAef77GmOpg//pprNd2IgUJKtEZLx2mp1fc5FFZkLxOwIjSgZtHIF1rq0l2/Ffm1rd+DJkXxQr8X0fGsB0vfLgbcgYKMi03DSkf986z21wOENKAwK2LL3s5v1XJNdd9u/v9d4Fh6X3XSCC7+C+6O5t25edM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630488; c=relaxed/simple;
	bh=2F3D4ViPK/1/0WFA+bQj22QbsbJhhW9+IG40Nypkr9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VwGmFFh1JpV9cpaf7tdiwQDRw9N2w/HUHa96k9tcDjHrgbDp7Hn1cam8JWe09KRKRLAuvF31SbGfbY95+Z6PtC9zqxmTKudKj0HIfGkNdD+ZDPiuDDmBCZ5Qi+QoB97mQ8P0fQHX3kUoNEvJW5JGJWGXYbmr/qlDBoJy8fv3XR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=URnxip1Q; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="URnxip1Q"
X-Envelope-To: syzbot+9f74cb4006b83e2a3df1@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718630484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CF8ncAOSZZUP14yQYZNhIjrPI6G3/InI6dmPBgZ8X6c=;
	b=URnxip1QgMFKqwHKtkQvpXXnXd8shMqasi5zjrxVZWtU7tnYvFdrEK/fXtrQmzjdcOMJjl
	e3ejlL+DBOyuYIjmMaNM94yRgjHxXC/KJxlt31gGxoCHsRR0nU+19wXuDYNK+h1KRB7SI2
	G5Z1T3kRVVsq+mYL9JgkLm83AYQnmRs=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 09:21:20 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+9f74cb4006b83e2a3df1@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 read_one_super (2)
Message-ID: <dx5mkmikbckgxyeiq5aru6wvgkx4h63uvvkb72r37ipsczxrux@s56rz3r4yy4v>
References: <0000000000003565fc061b122e02@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003565fc061b122e02@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 17, 2024 at 01:59:18AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15286f7a980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0ce06dcc735711
> dashboard link: https://syzkaller.appspot.com/bug?extid=9f74cb4006b83e2a3df1
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/27e64d7472ce/disk-2ccbdf43.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e1c494bb5c9c/vmlinux-2ccbdf43.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/752498985a5e/bzImage-2ccbdf43.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9f74cb4006b83e2a3df1@syzkaller.appspotmail.com
> 
> loop2: detected capacity change from 0 to 32789
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/super-io.c:653:3
> shift exponent 106 is too large for 64-bit type 'unsigned long'
> CPU: 0 PID: 9174 Comm: syz-executor.2 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
>  ubsan_epilogue lib/ubsan.c:231 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
>  read_one_super+0xfb5/0xfc0 fs/bcachefs/super-io.c:653
>  __bch2_read_super+0x65a/0x1460 fs/bcachefs/super-io.c:750
>  bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2074
>  bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
>  legacy_get_tree+0xf0/0x190 fs/fs_context.c:662
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1780
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3352
>  do_mount fs/namespace.c:3692 [inline]
>  __do_sys_mount fs/namespace.c:3898 [inline]
>  __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f82b087e5aa
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f82b1586ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f82b1586f80 RCX: 00007f82b087e5aa
> RDX: 0000000020011a00 RSI: 0000000020000780 RDI: 00007f82b1586f40
> RBP: 0000000020011a00 R08: 00007f82b1586f80 R09: 0000000001200014
> R10: 0000000001200014 R11: 0000000000000206 R12: 0000000020000780
> R13: 00007f82b1586f40 R14: 00000000000119fa R15: 00000000200007c0
>  </TASK>
> ---[ end trace ]---
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
#syz fix: bcachefs: Fix shift overflow in read_one_super()
