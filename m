Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E71C8FCF;
	Thu, 31 Oct 2024 21:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730408988; cv=none; b=r5sbzTlRQLjr1KpxQxLb6HMUkX1LGwS2+FIkTHA0j6VIcbOI0eYvKtY3azknMYMAyJJijDhMmiPhPPvweMMX+wXhMjglSUyqBvT+yt2UMguBRrL4or/X/xXWVjkFNIbz/rUamwdAIqh1tYGM4myeGM+upvpkCWa1fJC3jZbRlpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730408988; c=relaxed/simple;
	bh=NdurZ/NBP7x7LqrfoxvKIbp94Yk9bYEzP2yheuFUc0U=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/4ZZnRsw1XxOlqnuUfQsDmqNBIaVMmg9rfBFaMOOjoSlh5nKbHj5VcvNTQwf7E1I8kAz/RMlNHI88pi4QZiJFEAyTwcR9VAebZoR9GpTIMCJcRr7y69pYhn/oDhZY1xBlBNV35jz3Igt0GE5vH4IUkz5f3AG0GhAPBqhhxn67A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=QBUwCMA0; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="QBUwCMA0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=bazgfx7c4verjag4v5qvooaeem.protonmail; t=1730408970; x=1730668170;
	bh=NdurZ/NBP7x7LqrfoxvKIbp94Yk9bYEzP2yheuFUc0U=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=QBUwCMA0/d8beloFvNJumNwqaEhJx6kwdp1G3J/qwUcuWoxdXbgrHmhRL4mBinbcw
	 nV9R3cDi8/ztV0jqb8zz+CUg/x5bWmXyfSM4krWC2G0Fmr1W2MHsNIdCqtl1CGkjRd
	 AqzNXnrAK6k3kSuwbXojyXISEBUg5LU+Qjwu9WdEGluFxmgeOB6/Y+NKwBGwKUkNie
	 /obyiGmocfoYW0MvPuQjkXnQgxICOC7J+5jypNiAyWv+0d1QxdGGWRBmsQ/A3WFuoY
	 C31sYFmerXOutigInS+CWli/ycOamU/kXlkspubGAPrsSkVxERSOdFKnG3Cp1p/+DU
	 tTDMnVsmciQRQ==
Date: Thu, 31 Oct 2024 21:09:26 +0000
To: syzbot <syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_inconsistent_error
Message-ID: <xWUrkQdz22oyF70btKkFvnHqFVu1-HlxAus6ppSVOtgv5ElyqdWca-q4pJAKiCIeKKrplp6EkfCRtpzoa_U7DbJL8QtaFdk67xRXIVr7T0k=@proton.me>
In-Reply-To: <671db974.050a0220.2b8c0f.01c0.GAE@google.com>
References: <671db974.050a0220.2b8c0f.01c0.GAE@google.com>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: b9a99bbbf84d92d85f13e3b25fe4b1d9e30f8b82
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


It reads garbage error options from superblock. Proper way to handle this
seems to be checking if read option value is valid (within range, error
options are represented on 4 bits but <=3D 3 values are used) and if it's n=
ot=20
- set/leave the default.

Hacky way - treat error options of value >=3D 4 as BCH_ON_ERROR_fix_safe (t=
he
default) in bch2_inconsistent_error.

On Sunday, October 27th, 2024 at 4:54 AM, syzbot <syzbot+bee87a0c3291c06aa8=
c6@syzkaller.appspotmail.com> wrote:

> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit: c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
> git tree: upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14202a5f98000=
0
> kernel config: https://syzkaller.appspot.com/x/.config?x=3Dfc6f8ce8c53690=
43
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbee87a0c3291c06=
aa8c6
> compiler: Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2=
.40
> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=3D11468c30580000
> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=3D166fa640580000
>=20
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7=
feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinu=
x-c2ee9f59.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/b=
zImage-c2ee9f59.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/7da30fa866=
89/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
>=20
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/error.c:29!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5094 Comm: syz-executor353 Not tainted 6.12.0-rc4-syzk=
aller-00047-gc2ee9f594da8 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2~bpo12+1 04/01/2014
> RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
> Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48 c=
7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 90=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
>=20
> RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
> RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
> RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
> RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
> R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
> R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
> FS: 00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
>=20
> bch2_topology_error+0x83/0xc0 fs/bcachefs/error.c:37
> __btree_err+0x610/0x760 fs/bcachefs/btree_io.c:597
> validate_bset+0x157b/0x2640 fs/bcachefs/btree_io.c:807
> bch2_btree_node_read_done+0x2108/0x5e90 fs/bcachefs/btree_io.c:1126
> btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
> bch2_btree_node_read+0x2433/0x2a10
> __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
> bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
> read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
> bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
> bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
> bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
> vfs_get_tree+0x90/0x2b0 fs/super.c:1800
> do_new_mount+0x2be/0xb40 fs/namespace.c:3507
> do_mount fs/namespace.c:3847 [inline]
> __do_sys_mount fs/namespace.c:4057 [inline]
> __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1aa39038fa
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>=20
> RSP: 002b:00007ffddefb1b08 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffddefb1b20 RCX: 00007f1aa39038fa
> RDX: 0000000020000300 RSI: 0000000020005900 RDI: 00007ffddefb1b20
> RBP: 0000000000000004 R08: 00007ffddefb1b60 R09: 00000000000058c4
> R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
> R13: 00007ffddefb1b60 R14: 0000000000000003 R15: 0000000001000000
> </TASK>
>=20
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
> Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48 c=
7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 90=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
>=20
> RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
> RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
> RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
> RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
> R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
> R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
> FS: 00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:00000000000000=
00
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
