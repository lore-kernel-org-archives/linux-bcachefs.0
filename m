Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BADC1D12E0
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415615; cv=none; b=AC7vljUJuHgA/SbvpggXyU2DtAvhmMdZC7WQzy0QG2DwXf1XoHfPr4HiJdY02hE8WpNgfSU1dTYSHptHWx3waseJ5qc7pW7/M8qB3L0oMKViA1fQZkzSmBajUUGNUnsbB896VVaKVOhMOGuxX7eSsQJxq2dK9G9Ku3MI4l+Cfws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415615; c=relaxed/simple;
	bh=EiO49XY+kbFRO+kTGMfz9xwblGIAnuYTQljdZrMgM44=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWkvs/RVNIke+wxT99aC0f5bUQJDmfEtEdPg4LAGVUCJnJTEd3E5Ll/Zvp/Op/MdUXMpLnLwEMItvL1OFLdvjivT0EooPjgSgQCuwi+oPgNkickLTIdxd8LX98zzWbyLeU0v8bbM6ZEO44rXhSnyuU8/fsVVBJ2Yc4/vsOV6puo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=WuNIzWu/; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="WuNIzWu/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1730415605; x=1730674805;
	bh=EiO49XY+kbFRO+kTGMfz9xwblGIAnuYTQljdZrMgM44=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WuNIzWu/eJIlw01v87eGpeZHScRJn1V79Kp3MZD2zfWKM6IRZ3zuwaVD4eaw2VIXY
	 Ts6erIdffTjHra6W4N/uEIlgfXj8iksBsSCdhFeaLHf4GXi8x0/tGMfNDlwAfoZqS9
	 CJMUqzLFaWvJLps9aiOPXdBkTReUHmCWDQmG0kJz6ENx3Mi6FoCMhPF9jvmIZpEoWg
	 mILIz2584y8Qb4lHzr5eBlu6tL2tcsXv5sYXF7kUs9gxLrajc54qO574TunFtBC/e8
	 KuF72C11uHG9qgo6nl5AHQQ9AL++NkE2W1TYkrgflm0v6WkVtjDRA5CmjL8loF3adz
	 V+PJkSZOIKYzw==
Date: Thu, 31 Oct 2024 23:00:02 +0000
To: Piotr Zalewski <pZ010001011111@proton.me>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: syzbot <syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com>, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_inconsistent_error
Message-ID: <Mf1g1gE7A6sfjlLvzpLxDMS7KTRfpsuFiwjMbXvzGKw775mxCTQoEJHnrDudQk79k4HS7h7HCgA4muxOjyDF4TlPz75FH47A8TzK5DhApRg=@proton.me>
In-Reply-To: <xWUrkQdz22oyF70btKkFvnHqFVu1-HlxAus6ppSVOtgv5ElyqdWca-q4pJAKiCIeKKrplp6EkfCRtpzoa_U7DbJL8QtaFdk67xRXIVr7T0k=@proton.me>
References: <671db974.050a0220.2b8c0f.01c0.GAE@google.com> <xWUrkQdz22oyF70btKkFvnHqFVu1-HlxAus6ppSVOtgv5ElyqdWca-q4pJAKiCIeKKrplp6EkfCRtpzoa_U7DbJL8QtaFdk67xRXIVr7T0k=@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 73e3b73b591339dcea106680810e35bac94de6b3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thursday, October 31st, 2024 at 10:09 PM, Piotr Zalewski <pZ010001011111=
@proton.me> wrote:

> It reads garbage error options from superblock. Proper way to handle this
> seems to be checking if read option value is valid (within range, error
> options are represented on 4 bits but <=3D 3 values are used) and if it's=
 not
> - set/leave the default.

Found that options are already validated in bch2_sb_validate but max is
wrong for option type OPT_STR.

Will send a patch.

>
> On Sunday, October 27th, 2024 at 4:54 AM, syzbot syzbot+bee87a0c3291c06aa=
8c6@syzkaller.appspotmail.com wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit: c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi=
..
> > git tree: upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14202a5f980=
000
> > kernel config: https://syzkaller.appspot.com/x/.config?x=3Dfc6f8ce8c536=
9043
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbee87a0c3291c=
06aa8c6
> > compiler: Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian)=
 2.40
> > syz repro: https://syzkaller.appspot.com/x/repro.syz?x=3D11468c30580000
> > C reproducer: https://syzkaller.appspot.com/x/repro.c?x=3D166fa64058000=
0
> >
> > Downloadable assets:
> > disk image (non-bootable): https://storage.googleapis.com/syzbot-assets=
/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmli=
nux-c2ee9f59.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604=
/bzImage-c2ee9f59.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/7da30fa8=
6689/mount_0.gz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > kernel BUG at fs/bcachefs/error.c:29!
> > Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> > CPU: 0 UID: 0 PID: 5094 Comm: syz-executor353 Not tainted 6.12.0-rc4-sy=
zkaller-00047-gc2ee9f594da8 #0
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-=
1.16.3-2~bpo12+1 04/01/2014
> > RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
> > Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48=
 c7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 =
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
> >
> > RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
> > RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
> > RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
> > RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
> > R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
> > R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
> > FS: 00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:000000000000=
0000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > <TASK>
> >
> > bch2_topology_error+0x83/0xc0 fs/bcachefs/error.c:37
> > __btree_err+0x610/0x760 fs/bcachefs/btree_io.c:597
> > validate_bset+0x157b/0x2640 fs/bcachefs/btree_io.c:807
> > bch2_btree_node_read_done+0x2108/0x5e90 fs/bcachefs/btree_io.c:1126
> > btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
> > bch2_btree_node_read+0x2433/0x2a10
> > __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
> > bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
> > read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
> > bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
> > bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
> > bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
> > vfs_get_tree+0x90/0x2b0 fs/super.c:1800
> > do_new_mount+0x2be/0xb40 fs/namespace.c:3507
> > do_mount fs/namespace.c:3847 [inline]
> > __do_sys_mount fs/namespace.c:4057 [inline]
> > __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
> > do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f1aa39038fa
> > Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> >
> > RSP: 002b:00007ffddefb1b08 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00007ffddefb1b20 RCX: 00007f1aa39038fa
> > RDX: 0000000020000300 RSI: 0000000020005900 RDI: 00007ffddefb1b20
> > RBP: 0000000000000004 R08: 00007ffddefb1b60 R09: 00000000000058c4
> > R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
> > R13: 00007ffddefb1b60 R14: 0000000000000003 R15: 0000000001000000
> > </TASK>
> >
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
> > Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48=
 c7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 =
90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
> >
> > RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
> > RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
> > RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
> > RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
> > R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
> > R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
> > FS: 00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:000000000000=
0000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
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
