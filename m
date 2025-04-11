Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5C81DFE8
	for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744385739; cv=none; b=C7415OMTGOPsWoD0r0/77v+Voyn7tWih7tGFiqMISBX2rw27Gl2mOdDsU7jIdNKapntezMRz/iNmlBiAaJXBf/C9RfvP+W8y//FGUraPSKOhdPVL/bfqPDvubUg79RAiWLJBDkfOwBqg3Srtg/UHl1StHtaJTksWTEfDa4HdtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744385739; c=relaxed/simple;
	bh=pnjuot0PRjHdDOdm8RowAL3yao/N9rw2tuNoMgHgtBw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ha33Li/EzZuC00hZCAi3GcT3Dwj1Os3RABXkdBjlAm/21XoYPG9njqx+5k3GaOLrnVbgeMGFtkPW0QLXT1ghCArl8k3Rt4G4O9fD8Ua+urJ2l79yEsS6iAhPtIdrGrK6Dzpszy1Ipla2r7kYdqSpodBJJnqp/5Bng0kzgVr0zXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=F2Z1wP46; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="F2Z1wP46"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 4E857240105
	for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 17:35:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1744385728; bh=pnjuot0PRjHdDOdm8RowAL3yao/N9rw2tuNoMgHgtBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 From;
	b=F2Z1wP46sL3dhrsqd/KtCZiEgobtfMAugWoEy+QaDiD5QD7IIYhRVxArMFdFJcEG3
	 gCxsAnpEYN7gjv1aP4V8nYGsYR1TpECnamhsDP8Pe03OZ8+1sTp2+WPp3q7QNSOYXF
	 OJW9r5aLZpMZ9teFFPG0lpHj3OunjwXl3kCMwXR3KlrP0qd87dlKNSSPUY0psF1dSb
	 ByCG/5HEl2XKnGZ31TB81qmDo3qVw36Zcl30VFuKWcffBEcaPjzkif58Cdj5Drs6Wv
	 0mQHDvDqW0H9ymbFtx75ZyfvcPOEGc4nI5n9gPqHPJJzUcM1sr5WCMcFrDWhF/vXUp
	 UUv45Fi76ACeQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZZ13M1M9zz6tw1;
	Fri, 11 Apr 2025 17:35:27 +0200 (CEST)
From: Charalampos Mitrodimas <charmitro@posteo.net>
To: syzbot <syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev,  linux-bcachefs@vger.kernel.org,
  linux-kernel@vger.kernel.org,  syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] general protection fault in
 bch2_snapshot_tree_oldest_subvol
In-Reply-To: <67eef48d.050a0220.9040b.0262.GAE@google.com> (syzbot's message
	of "Thu, 03 Apr 2025 13:50:21 -0700")
References: <67eef48d.050a0220.9040b.0262.GAE@google.com>
Date: Fri, 11 Apr 2025 15:35:26 +0000
Message-ID: <m2o6x2r9s1.fsf@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

syzbot <syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    a2cc6ff5ec8f Merge tag 'firewire-updates-6.15' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12482fb0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe3b5e6a2cb1cc2
> dashboard link: https://syzkaller.appspot.com/bug?extid=baee8591f336cab0958b
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10530be4580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d6d404580000
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a2cc6ff5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c58c1555aab7/vmlinux-a2cc6ff5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/61fb9d013359/bzImage-a2cc6ff5.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/86cf46d3a5d9/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com
>
>  done
> bcachefs (loop0): accounting_read... done
> bcachefs (loop0): alloc_read... done
> bcachefs (loop0): snapshots_read... done
> bcachefs (loop0): check_allocations...
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 0 UID: 0 PID: 5318 Comm: syz-executor394 Not tainted 6.14.0-syzkaller-12966-ga2cc6ff5ec8f #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:bch2_snapshot_tree_oldest_subvol+0x1d3/0x6a0 fs/bcachefs/snapshot.c:400
> Code: e6 e8 81 dd 36 fd 4c 39 e5 0f 86 c9 03 00 00 e8 13 db 36 fd 49 6b c4 38 49 01 c6 49 83 c6 18 49 83 c6 20 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 c6 03 00 00 41 8b 2e 31 ff 89 ee e8 24
> RSP: 0018:ffffc9000d46e020 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000001 RCX: ffff888000f98000
> RDX: 0000000000000000 RSI: 00000000ffeb487f RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffffffff848c7c5f R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffeb487f
> R13: dffffc0000000000 R14: 0000000000000020 R15: 000000000014b780
> FS:  0000555584fe3380(0000) GS:ffff88808c599000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055835cf3c000 CR3: 0000000044318000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bch2_inum_snap_offset_err_msg_trans+0x374/0x680 fs/bcachefs/error.c:691
>  bch2_indirect_extent_missing_error+0x411/0x1290 fs/bcachefs/reflink.c:192
>  gc_trigger_reflink_p_segment fs/bcachefs/reflink.c:392 [inline]
>  __trigger_reflink_p+0x196c/0x1cc0 fs/bcachefs/reflink.c:432
>  bch2_trigger_reflink_p+0x299/0x380 fs/bcachefs/reflink.c:451
>  bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
>  bch2_gc_mark_key+0x6bd/0x1180 fs/bcachefs/btree_gc.c:639
>  bch2_gc_btree fs/bcachefs/btree_gc.c:677 [inline]
>  bch2_gc_btrees fs/bcachefs/btree_gc.c:740 [inline]
>  bch2_check_allocations+0x1488/0x6ab0 fs/bcachefs/btree_gc.c:1042
>  bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
>  bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:285
>  bch2_fs_recovery+0x292a/0x3e20 fs/bcachefs/recovery.c:936
>  bch2_fs_start+0x2fb/0x610 fs/bcachefs/super.c:1060
>  bch2_fs_get_tree+0x113e/0x18f0 fs/bcachefs/fs.c:2253
>  vfs_get_tree+0x90/0x2b0 fs/super.c:1759
>  do_new_mount+0x2cf/0xb70 fs/namespace.c:3878
>  do_mount fs/namespace.c:4218 [inline]
>  __do_sys_mount fs/namespace.c:4429 [inline]
>  __se_sys_mount+0x38c/0x400 fs/namespace.c:4406
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f22f815ae2a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd84c61a58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffd84c61a70 RCX: 00007f22f815ae2a
> RDX: 0000200000000040 RSI: 0000200000000000 RDI: 00007ffd84c61a70
> RBP: 0000200000000000 R08: 00007ffd84c61ab0 R09: 0000000000005995
> R10: 0000000000800001 R11: 0000000000000282 R12: 0000200000000040
> R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffd84c61ab0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bch2_snapshot_tree_oldest_subvol+0x1d3/0x6a0 fs/bcachefs/snapshot.c:400
> Code: e6 e8 81 dd 36 fd 4c 39 e5 0f 86 c9 03 00 00 e8 13 db 36 fd 49 6b c4 38 49 01 c6 49 83 c6 18 49 83 c6 20 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 c6 03 00 00 41 8b 2e 31 ff 89 ee e8 24
> RSP: 0018:ffffc9000d46e020 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000001 RCX: ffff888000f98000
> RDX: 0000000000000000 RSI: 00000000ffeb487f RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffffffff848c7c5f R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffeb487f
> R13: dffffc0000000000 R14: 0000000000000020 R15: 000000000014b780
> FS:  0000555584fe3380(0000) GS:ffff88808c599000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000556b9781f0c8 CR3: 0000000044318000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	e6 e8                	out    %al,$0xe8
>    2:	81 dd 36 fd 4c 39    	sbb    $0x394cfd36,%ebp
>    8:	e5 0f                	in     $0xf,%eax
>    a:	86 c9                	xchg   %cl,%cl
>    c:	03 00                	add    (%rax),%eax
>    e:	00 e8                	add    %ch,%al
>   10:	13 db                	adc    %ebx,%ebx
>   12:	36 fd                	ss std
>   14:	49 6b c4 38          	imul   $0x38,%r12,%rax
>   18:	49 01 c6             	add    %rax,%r14
>   1b:	49 83 c6 18          	add    $0x18,%r14
>   1f:	49 83 c6 20          	add    $0x20,%r14
>   23:	4c 89 f0             	mov    %r14,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
>   2f:	84 c0                	test   %al,%al
>   31:	0f 85 c6 03 00 00    	jne    0x3fd
>   37:	41 8b 2e             	mov    (%r14),%ebp
>   3a:	31 ff                	xor    %edi,%edi
>   3c:	89 ee                	mov    %ebp,%esi
>   3e:	e8                   	.byte 0xe8
>   3f:	24                   	.byte 0x24
>
>

#syz test

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 0c65065b08ec..8862714b1806 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -397,7 +397,11 @@ u32 bch2_snapshot_tree_oldest_subvol(struct bch_fs *c, u32 snapshot_root)
 
 	rcu_read_lock();
 	while (id) {
-		s = snapshot_t(c, id)->subvol;
+		const struct snapshot_t *snap = snapshot_t(c, id);
+		if (!snap)
+			break;
+
+		s = snap->subvol;
 
 		if (s && (!subvol || s < subvol))
 			subvol = s;
