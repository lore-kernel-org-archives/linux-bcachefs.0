Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11D3199E96
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 13:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630995; cv=none; b=htFOb+2wOcM25H37JWlVZp3WrTHZgvm0mA+sGC5iRhhypf4Mq0RfvAuEwXqJngoh1ecY5Qu+iO+oJKl/UWpwBlV9a4QIPlWfsoznRPiyu0RwK17hcuHperPwIgVRRRu37iii46ffvKqaEYRjFK/05VgktOdfIDXJLxElRJxqB1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630995; c=relaxed/simple;
	bh=mNYo8XxzwcBots3Eauz51GHKXnkqqdLvGz8WsU8GYA4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzbGqvWkX3Wyl6rfn9F7lmkqvEYffCGTFeF21Vfxn39f0okJ6YJVJPK3XHg1b60zhXRDRbR8TSmb3FwhAgMoBpWWGvLkgRvt+W2BIYfMPPRVxD0Wfc9nPwxESy24UVWLUft7uJ2S8jTNRZInhjVyh7yMROfcgMOY7hPvzWibO4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zf4Pgsm3; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zf4Pgsm3"
X-Envelope-To: syzbot+e6332ce6aa831184a0eb@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718630991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BDywsyDZsB83JPUteg6tKfFYJf2ez0t3lcHh4VBGFBU=;
	b=Zf4Pgsm3CGh73rwBAd+akAyuVzXQY3uARUnbgG72T/6EeiGGP4d0ImBRQpz7qj/VJR9o3Y
	Y2W6hAGq7gqwl2+sLdZ89nfXVHAa9nah4lLMYP3bSXx0Wyjjx0calHrZZIeanLuuCmq2nk
	8+YtAOpzz/am1Q3Q/R9GRi46HQooBw4=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 09:29:48 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e6332ce6aa831184a0eb@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_btree_node_read_done
Message-ID: <5yjeaaweds7ap7s4hrxlhg53mftdyzwe4uvl7opqna43rnr2tl@chbf2ehpimng>
References: <0000000000000de83f06191f79ad@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000de83f06191f79ad@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 23, 2024 at 07:00:25AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b6394d6f7159 Merge tag 'pull-misc' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17cd3df4980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=713476114e57eef3
> dashboard link: https://syzkaller.appspot.com/bug?extid=e6332ce6aa831184a0eb
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e8e1377d4772/disk-b6394d6f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/19fbbb3b6dd5/vmlinux-b6394d6f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4dcce16af95d/bzImage-b6394d6f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e6332ce6aa831184a0eb@syzkaller.appspotmail.com
> 
> bcachefs (loop2): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
> bcachefs (loop2): recovering from clean shutdown, journal seq 8
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:770:13
> shift exponent 128 is too large for 32-bit type 'unsigned int'
> CPU: 1 PID: 18326 Comm: syz-executor.2 Not tainted 6.9.0-syzkaller-10729-gb6394d6f7159 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
>  ubsan_epilogue lib/ubsan.c:231 [inline]
>  __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
>  btree_node_type_is_extents fs/bcachefs/btree_types.h:770 [inline]
>  bch2_btree_node_read_done+0x35bf/0x6770 fs/bcachefs/btree_io.c:1088
>  btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1340
>  bch2_btree_node_read+0x2467/0x2a40
>  __bch2_btree_root_read fs/bcachefs/btree_io.c:1764 [inline]
>  bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1788
>  read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:472
>  bch2_fs_recovery+0x2346/0x3700 fs/bcachefs/recovery.c:800
>  bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
>  bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
>  bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
>  legacy_get_tree+0xee/0x190 fs/fs_context.c:662
>  vfs_get_tree+0x90/0x2a0 fs/super.c:1780
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3352
>  do_mount fs/namespace.c:3692 [inline]
>  __do_sys_mount fs/namespace.c:3898 [inline]
>  __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f76c307e5ea
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f76c2bbcef8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f76c2bbcf80 RCX: 00007f76c307e5ea
> RDX: 0000000020000040 RSI: 00000000200001c0 RDI: 00007f76c2bbcf40
> RBP: 0000000020000040 R08: 00007f76c2bbcf80 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000202 R12: 00000000200001c0
> R13: 00007f76c2bbcf40 R14: 0000000000005b22 R15: 0000000020000240
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
#syz fix: bcachefs: Check for invalid btree IDs
