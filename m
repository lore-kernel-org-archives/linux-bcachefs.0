Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6726EB4A
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Oct 2024 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728841319; cv=none; b=JBX3dY3Er/MY6aTiAFATl8Y/HsQQu/PhLaJCcUb39CoOoJdUhL/HsmhqjEIRLVmcb7sid7/Trw6VoVSA+Ae15/3XHG4nDdjbXeTa9DU3Y2lJJLS6GYKgFxC5ZO+zDGm3q+CuMLJ3rrt+41gc+p6XmxAtvzW0sUHNSLhm1PSKyyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728841319; c=relaxed/simple;
	bh=O4uW8akvvmzAo72QeAFXUtgDelr8w/chh5v8VoD+qq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARhMIb4NtWOZtZEbIfJ9AN6iMdf7X9+9KQEFXhoo2uJ6SJxXCvepd7hxdivrp2nnjaO/P3JIr2zCh4YGavMe4JZXuGNHTTzpPINnJ5/xGm01577XI/Ip6ZpC5sutFnO8moa/vO4IZDjQtGwZrBucPGFBYqZvFTsVdUjriArwe6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KexFyJvr; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KexFyJvr"
Date: Sun, 13 Oct 2024 13:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728841315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uUu58mQSkd3A6BWUP5j1gRYOiio92hZ5GCB80tr8lOg=;
	b=KexFyJvr3IJg740RuSSDImNJz3TYXHI8t0HPVsPRJlEj5MKSuE7W0Zwn2E7yHS1573Hkge
	aGPdShX/myjRU8NxKXYRAOOas9PLgew9+TSEOBbGMQ/xr2DArYfMvpZRO9xhn6DaOFARUW
	lSB4qCD6SAUpNWUPSchsEDcRbotoyRs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel panic: bcachefs (loop3): panic after
 error
Message-ID: <emzzftryhlyksbc7w5sx7rn3vrrp4rwnwwa45fn4o3rexdk6z7@umhqszrnbsnp>
References: <670bd8cc.050a0220.4cbc0.0031.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <670bd8cc.050a0220.4cbc0.0031.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 13, 2024 at 07:27:24AM GMT, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    75b607fab38d Merge tag 'sched_ext-for-6.12-rc2-fixes' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10d35780580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7a3fccdd0bb995
> dashboard link: https://syzkaller.appspot.com/bug?extid=e6ea15c610261d2106ba
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14560f07980000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/283eaf72a57c/disk-75b607fa.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a721235f5b80/vmlinux-75b607fa.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f5219ace4d70/bzImage-75b607fa.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/c65430058ea3/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com
> 
> bcachefs (loop3): starting version 1.7: mi_btree_bitmap opts=errors=panic,metadata_checksum=crc64,data_checksum=none,compression=lz4,background_compression=gzip,no_splitbrain_check,nocow
> superblock marked clean but clean section not present, shutting down
> Kernel panic - not syncing: bcachefs (loop3): panic after error
> CPU: 1 UID: 0 PID: 5433 Comm: syz.3.18 Not tainted 6.12.0-rc2-syzkaller-00058-g75b607fab38d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>  panic+0x349/0x880 kernel/panic.c:354
>  bch2_inconsistent_error+0x146/0x150 fs/bcachefs/error.c:26
>  __bch2_fsck_err+0x1167/0x15f0 fs/bcachefs/error.c:422
>  bch2_read_superblock_clean+0x3b4/0x520 fs/bcachefs/sb-clean.c:152
>  bch2_fs_recovery+0x1f4/0x39c0 fs/bcachefs/recovery.c:639
>  bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
>  bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2080
>  vfs_get_tree+0x90/0x2b0 fs/super.c:1800
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3507
>  do_mount fs/namespace.c:3847 [inline]
>  __do_sys_mount fs/namespace.c:4055 [inline]
>  __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb67417f79a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb674f20e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fb674f20ef0 RCX: 00007fb67417f79a
> RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007fb674f20eb0
> RBP: 00000000200058c0 R08: 00007fb674f20ef0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020000100
> R13: 00007fb674f20eb0 R14: 0000000000005957 R15: 0000000020000080
>  </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

This isn't a bug, you enabled errors=panic. You'll want to update the
syzbot driver...
