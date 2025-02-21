Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48311E5B78;
	Fri, 21 Feb 2025 06:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740118775; cv=none; b=HA0pDyRj86/SRmOrBAV18wArnvtdRjBVX4Ux4G/1ZrrsRwL8fed9tAltoErOFVLnXArq+I+aiBm540igp2da9D0FPJgsWrDQomDV1dVRYroAEzxAIEU0P4glikzVoN+ZuVlxzjl4whlNfC7utaXrBcGK50MJKy+PYHErH4b2KTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740118775; c=relaxed/simple;
	bh=9L4DQ2nJwlPnST/BntgX/tdcyG7B1tCMejlGYQoNhXE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MS7sLeOyolJyWKhFomPLpMejkll4KBy18KBm+BJwxNiq+1hVYawRWqPXCHJwuuuQiuyiIizwSaWK/QcM/IySsrxO1WhFBlpiaZcqgraKWGq/Q8mzudzlGDF3774T5p2UMTt9zTuLml9PwZcKA0kcSNUr+8vdzvziJpF/BsAiVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=TRGkV4il; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="TRGkV4il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1740118747;
	bh=8O5CWu2pUIk59RfMimIWyLFxOn6ChVypQAOh3D0nSwg=;
	h=Mime-Version:Subject:From:Date:Message-Id:To;
	b=TRGkV4ilBbMdic/pWLO5374i0sFHyIG4aqmdKUk0x093J7V9Hxqf3mh+rVHP3BbmN
	 HPjThkDS812DOFTvN4ciQCHG3W7mxXQoWG61j8TmSeAIIthPfpiwiID0aG7tE+Z43K
	 /Wdm4kl/TZNV7PpaN6u7ETTIB5uo5n3G92ZPKzyE=
X-QQ-mid: bizesmtpip3t1740118742ty86u0u
X-QQ-Originating-IP: v5xM0Nwhwvvwqu1TY9QLbHw5KuIsA1ymjtDnskZR93s=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 21 Feb 2025 14:19:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 6257787454314045098
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: UBSAN_ shift-out-of-bounds in bch2_trans_iter_init_outlined
From: Kun Hu <huk23@m.fudan.edu.cn>
In-Reply-To: <DB301B35-8966-4CB7-AE21-9A792CE4AC6C@m.fudan.edu.cn>
Date: Fri, 21 Feb 2025 14:18:50 +0800
Cc: syzkaller@googlegroups.com,
 linux-bcachefs@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3C4AC793-1EC9-4891-9280-8E35B954B681@m.fudan.edu.cn>
References: <DB301B35-8966-4CB7-AE21-9A792CE4AC6C@m.fudan.edu.cn>
To: kent.overstreet@linux.dev
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: OcC8+NPK8lgMPd0+T0YtrqgHT4QXi40hgL2zAFD6qODKxQraFIQWIeVc
	nEpt/l4xNkuHMiuwTQQ5LLQnbGEusum1MNu0ODT0CJ8sFVQImr2imsw1NJz8bHAM11dInS9
	MUR+sqhPdVPvfaPzud6A6w2QBUCKwyudmFUeD/3ls3kYuhw66Zcak2FxOt+nuI6lttNM1n7
	U4u81bJxYAAuCgqwn/y4ZcbRRWERh4mGzdQ9uAxojLW0mmAh+eh8LA7nBzwQJ8LL8UTWen5
	Ai3xtpIg6Fyk+9gjYxeyyikSTa3875nVG7naJrFjbSUTflawuRL4uzxDe8efgSuNv+awuCP
	4RYoavOU/suD2bZvKx9Qv2q+7l/fMQu34rxlpB1V0Goq3VoGckk2b1dB/sFKy+3i6b6DzV/
	aGEPs/bWQw5V3HwR+D6Cd4zugngQTh74j0Ljvb2ADZXVrX0h8HPSbyvtgyPbWSch7r8hacB
	y2t+ql72U2/QLBh3g1yRqok8iVgjg4X2Eej4FkMNBHvtMWB0KRBB/W0cGoiCTw6B+6iQMOa
	+VQqZE3XWC3aWgaJ5Bve9mZnnAlnThHF8CpDnJDavw+4C30PrMH500EBDZK8ZcexOCEu5I0
	wCX2y2SbwaiUueTh3EE7t1JXQ5aL57qDK5nCrVC6P6R00NoSVDdmIAsIjxS+lL52McsFRlh
	zqeZlBIBsYmr69djqPuxPAsR5rE0ZXa5U4DX0Uf1fDQ8lXzbzpbNV1MKn1xVwAuGtatNCV7
	FnyZm3QLNvRMl2+ohPCeRNpuk/hHG9exvZSpUFM4YideiiXCbEIqD7zPpY4ZST2T1s9MeIq
	1qcEnhsf7dGHwXfqFsSrvHG/i8LC6vDM/5KpnPnIP4NECY7YfVVPxwyS8MSi83n9MAjFRjw
	ohgVht1+d6Uwa4/UPy9PmgZZ2Hj2zv0jnC69Pet0beeRboQO42+RasgquccZOTgmpv2mKeA
	egh8Tym8e3tSgMriSO7bSi9mHBseCrkY32F8=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0



> 2025=E5=B9=B42=E6=9C=8820=E6=97=A5 15:08=EF=BC=8CKun Hu =
<huk23@m.fudan.edu.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Kent,
>=20
> When using our customized Syzkaller to fuzz the latest Linux kernel, =
the following crash (76s)
> was triggered.
>=20
> HEAD commit: 6537cfb395f352782918d8ee7b7f10ba2cc3cbf2
> git tree: upstream
> Console output: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/report%20on%20=
6.14-r3.txt
> Kernel config: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/config.tx=
t=20
> C reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/repro.c
> Syzlang reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/repro.syz.txt
>=20
> We have reproduced this issue repeatedly in 6.14-rc3. =46rom the =
syscall reproducer, the syscall syz_mount_image mounts a constructed =
bcachefs image. When the file system attempted to parse these =
parameters, it caused the btree_id_is_extents, btree_type_has_snapshots, =
and btree_type_has_snapshot_field functions in btree_types.h to shift =
out of bounds. It is speculated that the constructed mirror may have =
caused the btree_id to exceed the u64 bit width, which in turn triggered =
the shift out-of-bounds. Also, the report shows that the =
bch2_time_to_timespec function in bcachefs.h also undergoes a shift =
operation, but this does not seem to be the case when I look at the =
source code. If you think this issue has little impact on your system, =
please ignore it =E2=98=BA.
>=20
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin =
<jjtan24@m.fudan.edu.cn>
>=20
> 2025/02/19 18:35:12 reproducing crash 'UBSAN: shift-out-of-bounds in =
bch2_trans_iter_init_outlined': final repro crashed as =
(corrupted=3Dfalse):
>  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
>  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/bcachefs.h:1193:41
> shift exponent 128 is too large for 32-bit type 'unsigned int'
> CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
> __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
> btree_id_cached fs/bcachefs/bcachefs.h:1193 [inline]
> bch2_btree_iter_flags fs/bcachefs/btree_iter.h:472 [inline]
> bch2_trans_iter_init_outlined.cold+0x55/0x78 =
fs/bcachefs/btree_iter.c:2904
> bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
> bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
> drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
> check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
> check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
> bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
> bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
> bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
> bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
> bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
> bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x93/0x340 fs/super.c:1814
> do_new_mount fs/namespace.c:3511 [inline]
> path_mount+0x1272/0x1ba0 fs/namespace.c:3838
> do_mount+0xf8/0x110 fs/namespace.c:3851
> __do_sys_mount fs/namespace.c:4061 [inline]
> __se_sys_mount fs/namespace.c:4038 [inline]
> __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75b6feb51e
> Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
> RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
> RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
> R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
> </TASK>
> ---[ end trace ]---
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:798:9
> shift exponent 129 is too large for 64-bit type 'long long unsigned =
int'
> CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
> __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
> btree_node_type_is_extents fs/bcachefs/btree_types.h:798 [inline]
> btree_id_is_extents fs/bcachefs/btree_types.h:803 [inline]
> __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:451 [inline]
> bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
> bch2_trans_iter_init_outlined.cold+0x37/0x78 =
fs/bcachefs/btree_iter.c:2904
> bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
> bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
> drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
> check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
> check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
> bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
> bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
> bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
> bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
> bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
> bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x93/0x340 fs/super.c:1814
> do_new_mount fs/namespace.c:3511 [inline]
> path_mount+0x1272/0x1ba0 fs/namespace.c:3838
> do_mount+0xf8/0x110 fs/namespace.c:3851
> __do_sys_mount fs/namespace.c:4061 [inline]
> __se_sys_mount fs/namespace.c:4038 [inline]
> __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75b6feb51e
> Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
> RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
> RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
> R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
> </TASK>
> ---[ end trace ]---
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:825:9
> shift exponent 128 is too large for 64-bit type 'long long unsigned =
int'
> CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
> __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
> btree_type_has_snapshot_field fs/bcachefs/btree_types.h:825 [inline]
> __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:455 [inline]
> bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
> bch2_trans_iter_init_outlined.cold+0x19/0x78 =
fs/bcachefs/btree_iter.c:2904
> bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
> bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
> drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
> check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
> check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
> bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
> bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
> bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
> bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
> bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
> bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x93/0x340 fs/super.c:1814
> do_new_mount fs/namespace.c:3511 [inline]
> path_mount+0x1272/0x1ba0 fs/namespace.c:3838
> do_mount+0xf8/0x110 fs/namespace.c:3851
> __do_sys_mount fs/namespace.c:4061 [inline]
> __se_sys_mount fs/namespace.c:4038 [inline]
> __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75b6feb51e
> Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
> RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
> RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
> R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
> </TASK>
> ---[ end trace ]---
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:814:9
> shift exponent 128 is too large for 64-bit type 'long long unsigned =
int'
> CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
> __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
> btree_type_has_snapshots fs/bcachefs/btree_types.h:814 [inline]
> __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:459 [inline]
> bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
> bch2_trans_iter_init_outlined.cold+0x73/0x78 =
fs/bcachefs/btree_iter.c:2904
> bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
> bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
> drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
> check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
> check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
> bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
> bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
> bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
> bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
> bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
> bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x93/0x340 fs/super.c:1814
> do_new_mount fs/namespace.c:3511 [inline]
> path_mount+0x1272/0x1ba0 fs/namespace.c:3838
> do_mount+0xf8/0x110 fs/namespace.c:3851
> __do_sys_mount fs/namespace.c:4061 [inline]
> __se_sys_mount fs/namespace.c:4038 [inline]
> __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75b6feb51e
> Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
> RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
> RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
> R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
> </TASK>
> ---[ end trace ]---
> bcachefs (loop1): duplicate versions of same extent, deleting smaller
>  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
>  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:814:9
> shift exponent 128 is too large for 64-bit type 'long long unsigned =
int'
> CPU: 0 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
> ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
> __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
> btree_type_has_snapshots fs/bcachefs/btree_types.h:814 [inline]
> bch2_trans_update_extent_overwrite.cold+0x1d/0x66 =
fs/bcachefs/btree_update.c:254
> bch2_trans_update_extent+0x65d/0x1000 fs/bcachefs/btree_update.c:318
> bch2_trans_update+0x360/0x5b0 fs/bcachefs/btree_update.c:518
> bch2_btree_insert_trans+0x223/0x290 fs/bcachefs/btree_update.c:650
> drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
> check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
> check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
> bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
> bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
> bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
> bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
> bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
> bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x93/0x340 fs/super.c:1814
> do_new_mount fs/namespace.c:3511 [inline]
> path_mount+0x1272/0x1ba0 fs/namespace.c:3838
> do_mount+0xf8/0x110 fs/namespace.c:3851
> __do_sys_mount fs/namespace.c:4061 [inline]
> __se_sys_mount fs/namespace.c:4038 [inline]
> __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f75b6feb51e
> Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
> RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
> RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
> R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
> </TASK>
>=20
> ---------------
> thanks,
> Kun Hu


Sorry for this report.

We just noticed that the wrong kernel version is being used, it's still =
6.13-rc7, so please ignore this report and let's retest on the latest =
kernel.

=E2=80=94=E2=80=94
Best
Kun=
