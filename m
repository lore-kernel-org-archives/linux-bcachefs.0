Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FA0145324
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317969; cv=none; b=L0qljhqGysRqcIb6I2GAW0kU3eza61bGnNvLsrBZHLRtg6ERzEWaRXnhom9/Mp51cDfupGtGXSpu7cbFF6zgpPOFJZDovuVxzC7PG/a8BxKBkpOdX7pY3Rdon5F/4L670E7T+vGy3DspeXRBGRMLHitBM8KUXTIUOPdB9/O7szk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317969; c=relaxed/simple;
	bh=lTD1P3tCgg5S3yJIsX6jPoiJ9dwBjqcoYbYtvsEm5G4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Co501WnoSdXuiZDoJPhJkzKS5XzifVmtF9d74ch3ZKjCYUy1NvVvEL1CCSdIpbq18caoYm7yiVs/KKrf9GlkFzXw2j5JwUWgcViW8yTd3QhVNjWMP8rsLifnm7y4y6iYpwQ64u7NNSC7y9FTwSxPzAmw4sanI/tPPowgSsSM+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3b506c87cso54150255ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 01:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731317967; x=1731922767;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JCSbdSqMsa6vIYKv72RO0xVkn3c/ngVgoErGoKJHg9I=;
        b=eaYaMwNXj6mWuDgSRBbsffCHbvvGcSfrosXIgMlH24BWyBc4CC+DU/WEqBA3o7ptj0
         v7obctowWxKO1luxPx5nPRbd7C8Uqgk3N/T2lDunfHLzD1bCaRRD9SFOMoa0VnPVCcqr
         9G2v7VOVbOJhnbWzo/3rcm2R1yD0QDKac0ECzLc5AgdQTq0S3p/7moflipSHVidCYSFp
         50QEKlR0ru+bJ6JYAVUnrjap0jQba6+qd+qBQfoX87nNPekWMwtCDASBr3R5zfWGxvk6
         trei3hPPsDMeJg7GBAT7B0BPtS9IoVgdf3efJue8cFfLpgHuESFRq0Qt+LYUDhvKDPxj
         LrnA==
X-Forwarded-Encrypted: i=1; AJvYcCV0N/zcq7Dfh7SKQMP/LJ3AD7rcy2xgBgL1eZLTJz2fBjHU1SfqWBadQvIsaEEY5jlgF+qshkBliYRwFJ7YbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUwIoVtIQIUkpR4inTVkHJCo1K3ud0v2K737jlb2ymRAY4e8J6
	VrC/6NYtj1VmlXXGQ66JVCy5nabePzxT+RQGTv5x7fHUeQAcwO68qWi9x9Mexv8fiqmd9iInT6Q
	aJWE5Qw1X7KtJhs1nBW0HOv+/yee7P0vh+MSNNuOd3BFsF16Vbhqr3vk=
X-Google-Smtp-Source: AGHT+IGtqwNgP+nN+Zw9CAS2FDKoMLDcISnOWfj2J/GXdijiyD36pOXQzzaUsz3G+mld3HcUQy2xGUuoHu33JYJJhut5yzavRsA1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26d:0:b0:3a5:e1f5:157c with SMTP id
 e9e14a558f8ab-3a6f1a21eadmr122800815ab.15.1731317967059; Mon, 11 Nov 2024
 01:39:27 -0800 (PST)
Date: Mon, 11 Nov 2024 01:39:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6731d0cf.050a0220.138bd5.0063.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in six_lock_ip_waiter
From: syzbot <syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f1dce1f09380 Merge tag 'slab-for-6.12-rc7' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e99e30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=13b85e45ca365499aad5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-f1dce1f0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c2f2da35f667/vmlinux-f1dce1f0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/31f60f71e8a7/bzImage-f1dce1f0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,compression=lz4,str_hash=crc64,journal_flush_disabled,norecovery,nojournal_transaction_names,allocator_stuck_timeout=32767,no_data_io
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5331 Comm: syz.0.0 Not tainted 6.12.0-rc6-syzkaller-00192-gf1dce1f09380 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:53 [inline]
 should_fail_ex+0x3b0/0x4e0 lib/fault-inject.c:154
 should_failslab+0xac/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4038 [inline]
 slab_alloc_node mm/slub.c:4114 [inline]
 kmem_cache_alloc_noprof+0x6c/0x2a0 mm/slub.c:4141
 __bkey_cached_alloc+0x26/0xe0 fs/bcachefs/btree_key_cache.c:123
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:149 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:220 [inline]
 btree_key_cache_fill+0x2043/0x2920 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x84e/0xbe0 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x45d/0x2940 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_trans_update_get_key_cache+0x6c0/0x1230 fs/bcachefs/btree_update.c:494
 bch2_trans_update+0x9b1/0x2550 fs/bcachefs/btree_update.c:539
 bch2_inode_write fs/bcachefs/inode.h:139 [inline]
 bch2_create_trans+0xdfb/0x1af0 fs/bcachefs/fs-common.c:179
 __bch2_create+0x7ae/0xf60 fs/bcachefs/fs.c:522
 bch2_mknod fs/bcachefs/fs.c:673 [inline]
 bch2_create+0xea/0x1b0 fs/bcachefs/fs.c:687
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f061377e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f061457d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f0613935f80 RCX: 00007f061377e719
RDX: 0000000000000000 RSI: 000000000014927e RDI: 0000000020000180
RBP: 00007f061457d090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f0613935f80 R15: 00007ffdaceeed98
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 5331 Comm: syz.0.0 Not tainted 6.12.0-rc6-syzkaller-00192-gf1dce1f09380 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__lock_acquire+0x69/0x2050 kernel/locking/lockdep.c:5065
Code: b6 04 30 84 c0 0f 85 9b 16 00 00 45 31 f6 83 3d e8 ed ac 0e 00 0f 84 b6 13 00 00 89 54 24 54 89 5c 24 68 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a9 51 8e 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000d9a60d0 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a146 R12: ffff888000adc880
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000070
FS:  00007f061457d6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f9c4079148 CR3: 0000000042e60000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 six_lock_ip_waiter+0x9e/0x160 fs/bcachefs/six.c:553
 six_lock_ip fs/bcachefs/six.h:253 [inline]
 six_lock_ip_intent fs/bcachefs/six.h:366 [inline]
 six_lock_intent fs/bcachefs/six.h:366 [inline]
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:169 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:220 [inline]
 btree_key_cache_fill+0x59a/0x2920 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x84e/0xbe0 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x45d/0x2940 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_trans_update_get_key_cache+0x6c0/0x1230 fs/bcachefs/btree_update.c:494
 bch2_trans_update+0x9b1/0x2550 fs/bcachefs/btree_update.c:539
 bch2_inode_write fs/bcachefs/inode.h:139 [inline]
 bch2_create_trans+0xdfb/0x1af0 fs/bcachefs/fs-common.c:179
 __bch2_create+0x7ae/0xf60 fs/bcachefs/fs.c:522
 bch2_mknod fs/bcachefs/fs.c:673 [inline]
 bch2_create+0xea/0x1b0 fs/bcachefs/fs.c:687
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f061377e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f061457d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f0613935f80 RCX: 00007f061377e719
RDX: 0000000000000000 RSI: 000000000014927e RDI: 0000000020000180
RBP: 00007f061457d090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f0613935f80 R15: 00007ffdaceeed98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x69/0x2050 kernel/locking/lockdep.c:5065
Code: b6 04 30 84 c0 0f 85 9b 16 00 00 45 31 f6 83 3d e8 ed ac 0e 00 0f 84 b6 13 00 00 89 54 24 54 89 5c 24 68 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a9 51 8e 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000d9a60d0 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a146 R12: ffff888000adc880
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000070
FS:  00007f061457d6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f9c4079148 CR3: 0000000042e60000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 9b 16 	xor    %al,0x169b850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d e8 ed ac 0e 00 	cmpl   $0x0,0xeacede8(%rip)        # 0xeacedfd
  15:	0f 84 b6 13 00 00    	je     0x13d1
  1b:	89 54 24 54          	mov    %edx,0x54(%rsp)
  1f:	89 5c 24 68          	mov    %ebx,0x68(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 a9 51 8e 00       	call   0x8e51e1
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
