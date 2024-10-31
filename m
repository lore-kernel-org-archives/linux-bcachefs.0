Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC10D14831D
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Oct 2024 07:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730358265; cv=none; b=Syx7R77GltZsO2ZWdd7FOk1/IyINmZ44mgp57/jP5E7EwQPiXqPoZTIMsahitnW2gqOciLFqm7xUPjIdPk/nQ3ux1UQNspUX2KDTLLbTxSNeJuw+wU7wrqEnof0tcw8frSXvtee47EWG2EOmJzy2VuEMVnNOT+YpuMRjCzv+Y9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730358265; c=relaxed/simple;
	bh=lSzvawx5sLa63l++myP4DV/MegkWshek2ZXi9pZ8MEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GY9hwPqRfcjxuP4mWmgj2NMJRGnAFDfj+8ReAlhh5+rDM5iDgq4CqDSHCESsTP4Owdhzq0o45J40YYp495YFUuhM7tAmy+5KD16T+E0Zt2GAnZdxgWCDH+FZedLQoqVhaP/J/c0tORhTDU2gQPW4GuMDqlD4NzLkF8Epgf3MGM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hARDGmuB; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hARDGmuB"
Date: Thu, 31 Oct 2024 03:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730358250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f8tgJxtDFneVuohN89fEM+pzmdzRCA/NbGzLbql6E1g=;
	b=hARDGmuBETD0p9IZ/IwaxP5qvUZ3l/wzPUL/QIg0Hgt3LB6nTNs4Uw3wHie8y3ZGmxLdmu
	CY7ZO4845nmKe9Fr/nfjlTAZgAZkC6T95oxKzIzUAe5omGBozYb9caX4X406aacZ91ePlJ
	uuO3YUoGVSw3vvN/gXvoCp4ZBKwQhbE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+4d722d3c539d77c7bc82@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bkey_unpack_pos
Message-ID: <noznkuwmznodskgral7ttq7dvncygedxuvuzq5xk5boldtqr7f@k75s5ldxcfxy>
References: <67226139.050a0220.35b515.0070.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67226139.050a0220.35b515.0070.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 30, 2024 at 09:39:21AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    850925a8133c Merge tag '9p-for-6.12-rc5' of https://github..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13772a87980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
> dashboard link: https://syzkaller.appspot.com/bug?extid=4d722d3c539d77c7bc82
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160c44a7980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120e7e40580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-850925a8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c831c931f29c/vmlinux-850925a8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/85f584e52a7f/bzImage-850925a8.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/b2e9e371ca38/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4d722d3c539d77c7bc82@syzkaller.appspotmail.com
> 
> bcachefs (loop0): accounting_read... done
> bcachefs (loop0): alloc_read... done
> bcachefs (loop0): stripes_read... done
> bcachefs (loop0): snapshots_read...
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/bkey.c:297!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5311 Comm: syz-executor213 Not tainted 6.12.0-rc4-syzkaller-00261-g850925a8133c #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:__bkey_unpack_pos+0x779/0x790 fs/bcachefs/bkey.c:297
> Code: b6 e4 00 e9 ad fb ff ff e8 24 ea 83 fd 48 c7 c7 40 b1 f3 8e 4c 89 e6 48 89 da e8 f2 b5 e4 00 e9 f4 fc ff ff e8 08 ea 83 fd 90 <0f> 0b e8 00 ea 83 fd 90 0f 0b e8 f8 e9 83 fd 90 0f 0b 0f 1f 44 00
> RSP: 0018:ffffc9000cdfe360 EFLAGS: 00010293
> RAX: ffffffff84110068 RBX: 0000000000000001 RCX: ffff888000d4a440
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
> RBP: 0000000000000000 R08: ffffffff8410f998 R09: 0000000000000000
> R10: ffffc9000cdfe400 R11: fffff520019bfc82 R12: ffffc9000cdfe400
> R13: dffffc0000000000 R14: 0000000000000001 R15: ffffc9000cdfe840
> FS:  0000555574f49380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc52831f40 CR3: 000000004475a000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  bkey_unpack_pos_format_checked fs/bcachefs/bkey.h:456 [inline]
>  __bch2_bkey_cmp_left_packed_format_checked fs/bcachefs/bkey.c:1029 [inline]
>  __bch2_bkey_cmp_left_packed+0xed/0x790 fs/bcachefs/bkey.c:1049
>  bkey_cmp_left_packed fs/bcachefs/bkey.h:88 [inline]
>  bch2_bkey_pack_pos_lossy+0xa08/0x1990 fs/bcachefs/bkey.c:532
>  bch2_btree_node_iter_init+0x894/0x4280 fs/bcachefs/bset.c:1313
>  __btree_path_level_init fs/bcachefs/btree_iter.c:615 [inline]
>  bch2_btree_path_level_init+0x4d2/0x9f0 fs/bcachefs/btree_iter.c:635
>  btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
>  bch2_btree_path_traverse_one+0x10de/0x2940 fs/bcachefs/btree_iter.c:1170
>  bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
>  __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2197 [inline]
>  bch2_btree_iter_peek_upto+0xb58/0x70e0 fs/bcachefs/btree_iter.c:2297
>  bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:685 [inline]
>  bch2_snapshots_read+0x4ac/0x15f0 fs/bcachefs/snapshot.c:1785
>  bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
>  bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
>  bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
>  bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
>  bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
>  vfs_get_tree+0x90/0x2b0 fs/super.c:1800
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3507
>  do_mount fs/namespace.c:3847 [inline]
>  __do_sys_mount fs/namespace.c:4057 [inline]
>  __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe43d8e1cba
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff67207cf8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fff67207d10 RCX: 00007fe43d8e1cba
> RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007fff67207d10
> RBP: 0000000000000004 R08: 00007fff67207d50 R09: 0000000000005946
> R10: 0000000001000000 R11: 0000000000000282 R12: 0000000001000000
> R13: 00007fff67207d50 R14: 0000000000000003 R15: 0000000001000000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__bkey_unpack_pos+0x779/0x790 fs/bcachefs/bkey.c:297
> Code: b6 e4 00 e9 ad fb ff ff e8 24 ea 83 fd 48 c7 c7 40 b1 f3 8e 4c 89 e6 48 89 da e8 f2 b5 e4 00 e9 f4 fc ff ff e8 08 ea 83 fd 90 <0f> 0b e8 00 ea 83 fd 90 0f 0b e8 f8 e9 83 fd 90 0f 0b 0f 1f 44 00
> RSP: 0018:ffffc9000cdfe360 EFLAGS: 00010293
> RAX: ffffffff84110068 RBX: 0000000000000001 RCX: ffff888000d4a440
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
> RBP: 0000000000000000 R08: ffffffff8410f998 R09: 0000000000000000
> R10: ffffc9000cdfe400 R11: fffff520019bfc82 R12: ffffc9000cdfe400
> R13: dffffc0000000000 R14: 0000000000000001 R15: ffffc9000cdfe840
> FS:  0000555574f49380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc52831f40 CR3: 000000004475a000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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

#syz test

commit ebd089435e043938bab81d6810ab43505adb8fb3
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Oct 31 02:36:21 2024 -0400

    bcachefs: Ancient versions with bad bkey_formats are no longer supported
    
    Syzbot found an assertion pop, by generating an ancient filesystem
    version with an invalid bkey_format (with fields that can overflow) as
    well as packed keys that aren't representable unpacked.
    
    This breaks key comparisons in all sorts of painful ways.
    
    Filesystems have been automatically rewriting nodes with such invalid
    formats for years; we can safely drop support for them.
    
    Reported-by: syzbot+8a0109511de9d4b61217@syzkaller.appspotmail.com
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/bkey.c b/fs/bcachefs/bkey.c
index 587d7318a2e8..995ba32e9b6e 100644
--- a/fs/bcachefs/bkey.c
+++ b/fs/bcachefs/bkey.c
@@ -643,7 +643,7 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 			     enum bch_validate_flags flags,
 			     struct printbuf *err)
 {
-	unsigned i, bits = KEY_PACKED_BITS_START;
+	unsigned bits = KEY_PACKED_BITS_START;
 
 	if (f->nr_fields != BKEY_NR_FIELDS) {
 		prt_printf(err, "incorrect number of fields: got %u, should be %u",
@@ -655,9 +655,8 @@ int bch2_bkey_format_invalid(struct bch_fs *c,
 	 * Verify that the packed format can't represent fields larger than the
 	 * unpacked format:
 	 */
-	for (i = 0; i < f->nr_fields; i++) {
-		if ((!c || c->sb.version_min >= bcachefs_metadata_version_snapshot) &&
-		    bch2_bkey_format_field_overflows(f, i)) {
+	for (unsigned i = 0; i < f->nr_fields; i++) {
+		if (bch2_bkey_format_field_overflows(f, i)) {
 			unsigned unpacked_bits = bch2_bkey_format_current.bits_per_field[i];
 			u64 unpacked_max = ~((~0ULL << 1) << (unpacked_bits - 1));
 			unsigned packed_bits = min(64, f->bits_per_field[i]);
