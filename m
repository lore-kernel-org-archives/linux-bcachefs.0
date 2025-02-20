Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501E81E3DEF;
	Thu, 20 Feb 2025 07:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740035367; cv=none; b=DnrW9p+mY83efCSBLPl+Am3fzzZz5j/u6CJAc6vi1DoFXna/LVLKz+XAvBIw0JjN7JjUAsUGJvYNU70FBxEPqIYt/HOMGHgyH6KYoPTJL74mwh9CgxI5G6XEvI4FVZsOQTRIQF8LbY5ztkJdTuahpTLtVrF4+iw9r2EAoy/0bWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740035367; c=relaxed/simple;
	bh=T2rVqvm4zBroEsOPvSBM8CrAORbDgr9+Kt/EHWp8+lU=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=IJhuPZf91sFqYqMhhOYynrA/U+T6sc+a7Xn4ORR6NuJQrkNYaWASUM7cajWJPULq66um/6pfOAlsb1W4JY0yOLqcU9J+diMa9X5NaqUO5d0qtb8fTVQHa3GQTJRN4aycyBLjPdXJUWi/jRw0IEPectv3E5aTgDlX02wbJDNFH40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=hxaf8t82; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="hxaf8t82"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1740035333;
	bh=g2vHaIOAz4d5yt8VkIHIK73HFH3hA6hpTBt/zjEj4u4=;
	h=From:Mime-Version:Subject:Message-Id:Date:To;
	b=hxaf8t82flzmyJNliOTtvoXnJ4w9I+l9ZPQvdx4TFa7USI1pUiUuhxYmnTWoG2Ulz
	 tV9aNRkPTBmNdHAVH1rdzo0e8lv8xNmMdUbNPKz9m4Z5420/2v2NHgoXTpe01afznO
	 +p7TxaYGQxpa0jismfNv0sHbpxSjSs9fV/VvYi2U=
X-QQ-mid: bizesmtpip2t1740035327t2cr158
X-QQ-Originating-IP: EQmKbY0xtrJZswQcKG+cdPyDE3TgJwarTmkXYHDbnjQ=
Received: from smtpclient.apple ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 20 Feb 2025 15:08:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 7114628657633862664
From: Kun Hu <huk23@m.fudan.edu.cn>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: UBSAN_ shift-out-of-bounds in bch2_trans_iter_init_outlined
Message-Id: <DB301B35-8966-4CB7-AE21-9A792CE4AC6C@m.fudan.edu.cn>
Date: Thu, 20 Feb 2025 15:08:35 +0800
Cc: syzkaller@googlegroups.com,
 linux-bcachefs@vger.kernel.org,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 linux-kernel@vger.kernel.org
To: kent.overstreet@linux.dev
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpip:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: N2K7JO7TcIoE7X1ljt5Hm+PosNQPi5q19IZ0FPZwTVTrhqpCp9mxK9rW
	7qSsMWBs6py/tgCEevq0glZ2mCW1VKawe2iwJB72I+STqlUAvx4xRs9Ym/vv7cpuH911T7k
	QVWnki+sVTn5aRoO3o9FcoeXU5f+fQ+8XYxLarHt5eAo2MBNcPEzXIfwmn8JOuTUfpAZ3gF
	lHwXlhMIclADu28YBD0AGENk+ojMvY+CdAmvN/E91hUaTSsITRXuNRYrc0yQgqBqRyy2qUD
	dTa2p2TwnkFfSIkCbt4lZNQ4dNwS22Chnm52phWbyhx4IKd3eTnrZEp2H2f1vx68XeRLMG9
	g/7D68wc1YW69hdLdt7A1+wMg/htEesqHv4y+5ffawdaVb7OCVzhCU00f2LA47DJioRnrdp
	inXAITrUCJ8e6vpOgIBMFUR9Qa+jzq2RFYNlB4MZ5TLosumJhEvGGulvPQYK/sLGrNnIyvf
	sdd/FHumHmkQjwvXEar4DLtJLlJQESDhZfBILHM0/5RTToP32IoXsQFS5pK6zWequfi1EMD
	uEAhJqeuGafk1P/tHKw3HyRQ7swYURFp5onqs1WCAKUJ9238Pbvnfr7g/Br5E3hWLSfcpWB
	v6uZXXEm9zrN7LRqexmxajs/7jkT6Bf8GqUF3ZmW6g+9b4d4Bohk+VrOqIiK8PZCua5YS/Y
	sWcnkM0R6y85NYuqFRpZ7fuDk9d3njHBdNmgK4C/VqLCGF9eIxJVAQEaiUVnwehS3VS8nmS
	bKzdZflfXNEDxd9WflFbliwGtPWMgGyg3YxeDHoGdLwnqKRe8esoBEQKq39qa4sICkYbbj2
	eUBtZBjONTokcJoho8+xtoTdVhRx8JAOTg1v8iWpv+JcfziDtt+/f8Xb3OjZ98wPV+QW9x2
	GPcfWFl/GQ8HKIP+lUAFqP8xyG1qsDdwXWdgz8Pkwjf8cjia2T4DRVTy8wtL7Lw5EDMFja6
	PMcuWsEcX42ANp+T836HGkNgsC16yE3ciRZNN6Jgr0G9JOw==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

Hi Kent,

When using our customized Syzkaller to fuzz the latest Linux kernel, the =
following crash (76s)
was triggered.

HEAD commit: 6537cfb395f352782918d8ee7b7f10ba2cc3cbf2
git tree: upstream
Console output: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/report%20on%20=
6.14-r3.txt
Kernel config: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/config.tx=
t=20
C reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/repro.c
Syzlang reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0219_6.13rc7_todo/76-UBSAN_=
%20shift-out-of-bounds%20in%20bch2_trans_iter_init_outlined/repro.syz.txt

We have reproduced this issue repeatedly in 6.14-rc3. =46rom the syscall =
reproducer, the syscall syz_mount_image mounts a constructed bcachefs =
image. When the file system attempted to parse these parameters, it =
caused the btree_id_is_extents, btree_type_has_snapshots, and =
btree_type_has_snapshot_field functions in btree_types.h to shift out of =
bounds. It is speculated that the constructed mirror may have caused the =
btree_id to exceed the u64 bit width, which in turn triggered the shift =
out-of-bounds. Also, the report shows that the bch2_time_to_timespec =
function in bcachefs.h also undergoes a shift operation, but this does =
not seem to be the case when I look at the source code. If you think =
this issue has little impact on your system, please ignore it =E2=98=BA.

If you fix this issue, please add the following tag to the commit:
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin =
<jjtan24@m.fudan.edu.cn>

2025/02/19 18:35:12 reproducing crash 'UBSAN: shift-out-of-bounds in =
bch2_trans_iter_init_outlined': final repro crashed as =
(corrupted=3Dfalse):
  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/bcachefs.h:1193:41
shift exponent 128 is too large for 32-bit type 'unsigned int'
CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
 __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
 btree_id_cached fs/bcachefs/bcachefs.h:1193 [inline]
 bch2_btree_iter_flags fs/bcachefs/btree_iter.h:472 [inline]
 bch2_trans_iter_init_outlined.cold+0x55/0x78 =
fs/bcachefs/btree_iter.c:2904
 bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
 bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
 drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
 check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
 check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
 bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
 bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
 bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x93/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3511 [inline]
 path_mount+0x1272/0x1ba0 fs/namespace.c:3838
 do_mount+0xf8/0x110 fs/namespace.c:3851
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount fs/namespace.c:4038 [inline]
 __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75b6feb51e
Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 =
00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
 </TASK>
---[ end trace ]---
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:798:9
shift exponent 129 is too large for 64-bit type 'long long unsigned int'
CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
 __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
 btree_node_type_is_extents fs/bcachefs/btree_types.h:798 [inline]
 btree_id_is_extents fs/bcachefs/btree_types.h:803 [inline]
 __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:451 [inline]
 bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
 bch2_trans_iter_init_outlined.cold+0x37/0x78 =
fs/bcachefs/btree_iter.c:2904
 bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
 bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
 drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
 check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
 check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
 bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
 bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
 bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x93/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3511 [inline]
 path_mount+0x1272/0x1ba0 fs/namespace.c:3838
 do_mount+0xf8/0x110 fs/namespace.c:3851
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount fs/namespace.c:4038 [inline]
 __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75b6feb51e
Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 =
00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
 </TASK>
---[ end trace ]---
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:825:9
shift exponent 128 is too large for 64-bit type 'long long unsigned int'
CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
 __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
 btree_type_has_snapshot_field fs/bcachefs/btree_types.h:825 [inline]
 __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:455 [inline]
 bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
 bch2_trans_iter_init_outlined.cold+0x19/0x78 =
fs/bcachefs/btree_iter.c:2904
 bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
 bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
 drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
 check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
 check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
 bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
 bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
 bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x93/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3511 [inline]
 path_mount+0x1272/0x1ba0 fs/namespace.c:3838
 do_mount+0xf8/0x110 fs/namespace.c:3851
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount fs/namespace.c:4038 [inline]
 __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75b6feb51e
Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 =
00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
 </TASK>
---[ end trace ]---
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:814:9
shift exponent 128 is too large for 64-bit type 'long long unsigned int'
CPU: 2 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
 __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
 btree_type_has_snapshots fs/bcachefs/btree_types.h:814 [inline]
 __bch2_btree_iter_flags fs/bcachefs/btree_iter.h:459 [inline]
 bch2_btree_iter_flags fs/bcachefs/btree_iter.h:478 [inline]
 bch2_trans_iter_init_outlined.cold+0x73/0x78 =
fs/bcachefs/btree_iter.c:2904
 bch2_trans_iter_init fs/bcachefs/btree_iter.h:520 [inline]
 bch2_btree_insert_trans+0x18c/0x290 fs/bcachefs/btree_update.c:647
 drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
 check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
 check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
 bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
 bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
 bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x93/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3511 [inline]
 path_mount+0x1272/0x1ba0 fs/namespace.c:3838
 do_mount+0xf8/0x110 fs/namespace.c:3851
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount fs/namespace.c:4038 [inline]
 __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75b6feb51e
Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 =
00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
 </TASK>
---[ end trace ]---
bcachefs (loop1): duplicate versions of same extent, deleting smaller
  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
  u64s 6 type extent 1610612736:24:U32_MAX len 24 ver 0: durability: 1 =
ptr: 0:34:8 gen 0
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_types.h:814:9
shift exponent 128 is too large for 64-bit type 'long long unsigned int'
CPU: 0 UID: 0 PID: 877 Comm: syz.1.16 Not tainted 6.13.0-rc7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x180/0x1b0 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:231
 __ubsan_handle_shift_out_of_bounds+0xf2/0x1e0 lib/ubsan.c:468
 btree_type_has_snapshots fs/bcachefs/btree_types.h:814 [inline]
 bch2_trans_update_extent_overwrite.cold+0x1d/0x66 =
fs/bcachefs/btree_update.c:254
 bch2_trans_update_extent+0x65d/0x1000 fs/bcachefs/btree_update.c:318
 bch2_trans_update+0x360/0x5b0 fs/bcachefs/btree_update.c:518
 bch2_btree_insert_trans+0x223/0x290 fs/bcachefs/btree_update.c:650
 drop_dev_and_update+0x3d4/0x580 fs/bcachefs/backpointers.c:456
 check_bp_exists+0x1bd2/0x3140 fs/bcachefs/backpointers.c:603
 check_extent_to_backpointers+0x8d4/0x11f0 =
fs/bcachefs/backpointers.c:688
 bch2_check_extents_to_backpointers_pass+0xa6f/0xf20 =
fs/bcachefs/backpointers.c:884
 bch2_check_extents_to_backpointers+0x352/0xac0 =
fs/bcachefs/backpointers.c:937
 bch2_run_recovery_pass+0x94/0x1a0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x4a4/0x760 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x24d0/0x4f00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x2f6/0x610 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x4b6/0x2020 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x93/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3511 [inline]
 path_mount+0x1272/0x1ba0 fs/namespace.c:3838
 do_mount+0xf8/0x110 fs/namespace.c:3851
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount fs/namespace.c:4038 [inline]
 __x64_sys_mount+0x193/0x230 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xc3/0x1d0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f75b6feb51e
Code: ff ff ff 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 =
00 00 00 00 66 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffceb0a77a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005b13 RCX: 00007f75b6feb51e
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffceb0a7800
RBP: 00007ffceb0a7840 R08: 00007ffceb0a7840 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005b00
R13: 0000000020005b40 R14: 00007ffceb0a7800 R15: 0000000020000080
 </TASK>

---------------
thanks,
Kun Hu=
