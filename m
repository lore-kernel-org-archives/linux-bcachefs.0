Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4DF2E717C
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752860246; cv=none; b=JZB5XKJABeLSBggocWb3E/D7U5y9XxaVJdnC++UobGRb940oqiL5SNMHvgv83SMNzEdTtI6rbnbn+fjv4pHUamLz4nn/F2R0WT25rqerEs1gwBZ+UPIRobd7i9axy0o8mU/r7Ipql9noN06w9b1p8jmXW6XtfAaDFuj/kF2FB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752860246; c=relaxed/simple;
	bh=tWCH+7nHAnqzfj0ojazfxwJFzsAFhTiujcugqKzO44U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJ6fll7kaqN0Tz+XpO97XfkQlAjfThjE7AB3tLZ0LM3SzEZW2VUC3J66ClChSTz8k8bMEy3cMS7gYztgI2YEr11Ymy4oaWyd2JfmwfKKCrJG8wO6btHRXxq/ssF9hkkd1QHDBbsS2l279mhAs8zStgh8CgqjcO7Q0vzTkfn4ZDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K33kMjgr; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K33kMjgr"
Date: Fri, 18 Jul 2025 13:37:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752860239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T85ulL4EQRbU4aC3T/H9/jzvxYYAKGzHBdK/tLq6QRs=;
	b=K33kMjgrc8Dsz0WB1jCs4knqQgtAYPF5VcVrfyhY7J+JbFI8DVtivQIzVqGTtiyYPZr+2c
	XvGM9HJhI4uMHIpE8tKodrVUBVDucLoSWj5e6SnQBNGlaFzJz0eRT33V+iMVNHxws2d9GW
	XzMPHE6CT8oA2UAOuv50FxdckuCElLw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+1faf405b707c6475482f@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_printbuf_exit
Message-ID: <hdi3ckgaae2flafmvu7vzoeqy3iwj24wiqrgbeu4tjtxcrnjiy@atxbodbaqf3g>
References: <68794b5c.a70a0220.693ce.004f.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68794b5c.a70a0220.693ce.004f.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 17, 2025 at 12:13:32PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e8352908bdcd Add linux-next specific files for 20250716
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=100e158c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2594af20939db736
> dashboard link: https://syzkaller.appspot.com/bug?extid=1faf405b707c6475482f
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b1e382580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8e7d4580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c5f2b597f40f/disk-e8352908.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0d56411fc215/vmlinux-e8352908.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7f800652df04/bzImage-e8352908.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/24f97c1c6123/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1faf405b707c6475482f@syzkaller.appspotmail.com
> 
>     bi_fields_set=0
>     bi_dir=0
>     bi_dir_offset=0
>     bi_subvol=0
>     bi_parent_subvol=0
>     bi_nocow=0
>     bi_depth=0
>     bi_inodes_32bit=0
>     bi_casefold=0, fixing
> bcachefs (loop0): hash table key at wrong offset: should be at 6053843396831044271
>   u64s 7 type dirent 4096:4330382808765833931:U32_MAX len 0 ver 0: ����1 -> 536870912 type reg, fixing
> ------------[ cut here ]------------
> kernel BUG at arch/x86/mm/physaddr.c:23!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5848 Comm: syz-executor288 Not tainted 6.16.0-rc6-next-20250716-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
> Code: 50 fe fa 8d 48 89 de 4c 89 f2 e8 80 15 8b 03 e9 4d ff ff ff e8 e6 32 4b 00 90 0f 0b e8 de 32 4b 00 90 0f 0b e8 d6 32 4b 00 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> RSP: 0018:ffffc90003e0dfa8 EFLAGS: 00010293
> RAX: ffffffff817473fa RBX: 000000007ffffffc RCX: ffff888031bf8000
> RDX: 0000000000000000 RSI: 000000007ffffffc RDI: 000000001fffffff
> RBP: 0000000000000002 R08: fffffffffffffffc R09: fffffffffffffffc
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003e0e530
> R13: ffffc90003e0ee00 R14: 000000007ffffffc R15: dffffc0000000000
> FS:  000055558a225380(0000) GS:ffff888125ce2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f740dd9b000 CR3: 0000000071cd2000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  virt_to_folio include/linux/mm.h:1178 [inline]
>  kfree+0x77/0x440 mm/slub.c:4871
>  bch2_printbuf_exit+0x6f/0xb0 fs/bcachefs/printbuf.c:219
>  class_printbuf_destructor fs/bcachefs/printbuf.h:148 [inline]
>  bch2_str_hash_repair_key+0xf2b/0x4030 fs/bcachefs/str_hash.c:336
>  __bch2_str_hash_check_key+0xa85/0xd60 fs/bcachefs/str_hash.c:391
>  bch2_str_hash_check_key fs/bcachefs/str_hash.h:427 [inline]
>  check_dirent fs/bcachefs/fsck.c:2310 [inline]
>  bch2_check_dirents+0x21fe/0x3440 fs/bcachefs/fsck.c:2449
>  bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:479 [inline]
>  __bch2_run_recovery_passes+0x39d/0x1050 fs/bcachefs/recovery_passes.c:535
>  bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:606
>  bch2_fs_recovery+0x2544/0x3860 fs/bcachefs/recovery.c:995
>  bch2_fs_start+0x957/0xbf0 fs/bcachefs/super.c:1216
>  bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2456
>  vfs_get_tree+0x8f/0x2b0 fs/super.c:1804
>  do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>  do_mount fs/namespace.c:4133 [inline]
>  __do_sys_mount fs/namespace.c:4344 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe9b6ab4e2a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc69216268 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffc69216280 RCX: 00007fe9b6ab4e2a
> RDX: 00002000000000c0 RSI: 0000200000000340 RDI: 00007ffc69216280
> RBP: 0000200000000340 R08: 00007ffc692162c0 R09: 000000000000597e
> R10: 0000000001014040 R11: 0000000000000282 R12: 00002000000000c0
> R13: 00007ffc692162c0 R14: 0000000000000003 R15: 0000000001014040
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
> Code: 50 fe fa 8d 48 89 de 4c 89 f2 e8 80 15 8b 03 e9 4d ff ff ff e8 e6 32 4b 00 90 0f 0b e8 de 32 4b 00 90 0f 0b e8 d6 32 4b 00 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> RSP: 0018:ffffc90003e0dfa8 EFLAGS: 00010293
> RAX: ffffffff817473fa RBX: 000000007ffffffc RCX: ffff888031bf8000
> RDX: 0000000000000000 RSI: 000000007ffffffc RDI: 000000001fffffff
> RBP: 0000000000000002 R08: fffffffffffffffc R09: fffffffffffffffc
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90003e0e530
> R13: ffffc90003e0ee00 R14: 000000007ffffffc R15: dffffc0000000000
> FS:  000055558a225380(0000) GS:ffff888125be2000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f740e4bed30 CR3: 0000000071cd2000 CR4: 00000000003526f0
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

fixed in the updated version of the patch

#syz fix: bcachefs: convert str_hash.c to CLASS
