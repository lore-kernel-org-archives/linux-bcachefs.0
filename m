Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B713D161321
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732869813; cv=none; b=Vg754EYgqJeHSSxt/EO/yzFgWPYYrMrJV53lWVxqCSQZeX9dTaCnSMEKDOka87YnH3E5o8yeEr+Gtf9V7jVzGPIel686aqN+G/Z8nDnWt2GL3MJfOFmbtocbmYqH/ldam/PvckdFXCoKfjGMWFaHCdXxGthManTk0bacAPxD2zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732869813; c=relaxed/simple;
	bh=X5cZmF3sKdKZ/11P4Xrg2m+J/4nRwWRdWayTHAeD+v8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dS5HvYp+B2ov7l4ew089vSjW+BcJMmSdpMVZuzNCY5rCYPrr6DNHMsC+jecDSM2x7bXe5BtZzRLHPVMu8PHYaKne0BgAZTrUwr6PZPeGgguKGOyBaAUjvVzjVc5FeoDIk0RSQmgE+IbKlGAqvYpFqIm4iUXifhIJL6k1I69BVOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a743d76ed9so18999305ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 00:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732869811; x=1733474611;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZNmF7hiqjY9cFJP1jfzFT+we4wM1EDwCOPvDeiSUlVE=;
        b=Mj3JvHafInmlyWeJljMYNv/SWuMmW4lD63iNBWVFSYhe/pO08xaX6oNgh2+MwDDP8q
         XVfGB4ncQEOS/26HqnbHxlb9XFjYHFnSE0G+p8bAboyka9WvgkGwZTdq2FJa3WcizK4H
         ssUviGkN4miuNZGwfDxP3GoGpe5jwP4GyFLehyqKjcmpSN2CT2x70CM7UYujjJ2tadeJ
         RYFvW/dpRl9ygPgZsTaSCyl9ViK7lQfKAforPhSeUlxt3LE6Wzhzo3mUSI+EwteGKG7s
         pJ25N+3KJ5+U1pCzUS2SvGwkldZqPafyWdnzuFFPICPbbByJoejhE3yPo0qmAeG/WJIL
         2CPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJ65O0IOInu6XXK2WhyqCtUgbAu3s+pjctgEJL5M+TUP4GyLJ1zeBFajpjno5OgMnLh4XLQ4j7gxiYQbo10A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj3OcqAFevZUYc1KTU04DzTbEmuJFw5E7A68fZCH6ndvb3vRIs
	IEqz1LaNWcVHlDNn+euPdYR0vGEztw86QMDSEfKsy4wtrdJT0Gv+xkPvWud82P2PcLU0RutPcSV
	WN7N/hf6tBerRqxUjhsjPkSksCrgor5TRGtzM6hdCeCeSVACaYLVCI1k=
X-Google-Smtp-Source: AGHT+IGbgTdQFYYRpu2yXJoYLMiKtiKG3dyKHSjHfG51Yx1rwC4z6FLH55U5nJoonwfX0VbsZ55a67m0zf66hKP/Gr2ntOl7GmP0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a7:b0:3a7:cfee:2112 with SMTP id
 e9e14a558f8ab-3a7cfee216fmr34120655ab.1.1732869810957; Fri, 29 Nov 2024
 00:43:30 -0800 (PST)
Date: Fri, 29 Nov 2024 00:43:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67497eb2.050a0220.253251.00a7.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_prt_vprintf
From: syzbot <syzbot+03b7bb8ca037d17926dc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    65ae975e97d5 Merge tag 'net-6.13-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1478df5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3891b550f14aea0f
dashboard link: https://syzkaller.appspot.com/bug?extid=03b7bb8ca037d17926dc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140d100f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123b4d30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-65ae975e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/53fd215a7a86/vmlinux-65ae975e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/589c729ff0b2/bzImage-65ae975e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3e4078bce33b/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03b7bb8ca037d17926dc@syzkaller.appspotmail.com

  bi_fields_set=0
  bi_dir=4096
  bi_dir_offset=2695648408715017799
  bi_subvol=0
  bi_parent_subvol=0
  bi_nocow=0, fixing
Oops: general protection fault, probably for non-canonical address 0xec6408ae4eae6c2e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0x6320657275736170-0x6320657275736177]
CPU: 0 UID: 0 PID: 5321 Comm: syz-executor191 Not tainted 6.12.0-syzkaller-10681-g65ae975e97d5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:string_nocheck lib/vsprintf.c:646 [inline]
RIP: 0010:string+0x1a5/0x2b0 lib/vsprintf.c:728
Code: 85 c0 0f 84 db 00 00 00 4c 89 7c 24 08 49 89 c7 49 ff cf 31 db 49 8d 3c 1c 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 75 5d 4c 8d 6c 1d 00 41 0f b6 2c 1c 31 ff 89 ee
RSP: 0018:ffffc9000d116570 EFLAGS: 00010206
RAX: 0c640cae4eae6c2e RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801f26a440 RSI: ffffffffffffffff RDI: 6320657275736172
RBP: 0000000000000020 R08: ffffffff8bcc7827 R09: ffffffff8bcc3ec4
R10: 0000000000000012 R11: ffff88801f26a440 R12: 6320657275736172
R13: 0000000000000000 R14: 0000000000000020 R15: fffffffffffffffe
FS:  000055555da89380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c1e8516098 CR3: 000000003c578000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vsnprintf+0x1101/0x1da0 lib/vsprintf.c:2848
 bch2_prt_vprintf+0x1a2/0x700 fs/bcachefs/printbuf.c:166
 __bch2_fsck_err+0x2c2/0x1570 fs/bcachefs/error.c:266
 check_dirent_inode_dirent+0xf3b/0x1a30 fs/bcachefs/fsck.c:2214
 check_dirent_target+0x117/0xf70 fs/bcachefs/fsck.c:2244
 check_dirent fs/bcachefs/fsck.c:2518 [inline]
 bch2_check_dirents+0x12e9/0x2570 fs/bcachefs/fsck.c:2552
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8e3858cdea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe695cd7a8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe695cd7c0 RCX: 00007f8e3858cdea
RDX: 00000000200058c0 RSI: 0000000020000000 RDI: 00007ffe695cd7c0
RBP: 0000000000000004 R08: 00007ffe695cd800 R09: 00000000000059aa
R10: 0000000000010040 R11: 0000000000000282 R12: 0000000000010040
R13: 00007ffe695cd800 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:string_nocheck lib/vsprintf.c:646 [inline]
RIP: 0010:string+0x1a5/0x2b0 lib/vsprintf.c:728
Code: 85 c0 0f 84 db 00 00 00 4c 89 7c 24 08 49 89 c7 49 ff cf 31 db 49 8d 3c 1c 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 75 5d 4c 8d 6c 1d 00 41 0f b6 2c 1c 31 ff 89 ee
RSP: 0018:ffffc9000d116570 EFLAGS: 00010206
RAX: 0c640cae4eae6c2e RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801f26a440 RSI: ffffffffffffffff RDI: 6320657275736172
RBP: 0000000000000020 R08: ffffffff8bcc7827 R09: ffffffff8bcc3ec4
R10: 0000000000000012 R11: ffff88801f26a440 R12: 6320657275736172
R13: 0000000000000000 R14: 0000000000000020 R15: fffffffffffffffe
FS:  000055555da89380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c1e8516098 CR3: 000000003c578000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	85 c0                	test   %eax,%eax
   2:	0f 84 db 00 00 00    	je     0xe3
   8:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
   d:	49 89 c7             	mov    %rax,%r15
  10:	49 ff cf             	dec    %r15
  13:	31 db                	xor    %ebx,%ebx
  15:	49 8d 3c 1c          	lea    (%r12,%rbx,1),%rdi
  19:	48 89 f8             	mov    %rdi,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	75 5d                	jne    0x8f
  32:	4c 8d 6c 1d 00       	lea    0x0(%rbp,%rbx,1),%r13
  37:	41 0f b6 2c 1c       	movzbl (%r12,%rbx,1),%ebp
  3c:	31 ff                	xor    %edi,%edi
  3e:	89 ee                	mov    %ebp,%esi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
