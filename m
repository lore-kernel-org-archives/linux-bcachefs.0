Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9D3263C7F
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582934; cv=none; b=UmXYReFKtXywGaEpDGSKTMKVTs+HlYBs3BKA4fuUkXBKMai0CIzaf4U7IzV21UfQ8KAYEsP6TdPfbly8e+nr+IFngiW5T9mNSV1C5CkMMluyNIiVT43SZJplzFenVXktZHgh4aRti6N7f1PwhPFeFCidjQki4litkRi1D2xAvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582934; c=relaxed/simple;
	bh=hT50CgJ2AjgpTWwPcQ13jcnmjf9GAY4KcEENLMCnRkQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rxyyacBugHNdhVHaC3HlMyI0da+zdlaubmauyW8ENwHcoJ6bIWpcHUNT6yyr3oOYa0nePaqxyRxQDIioissj7KM6S4uIDWZ3yBS4dMydL9ncS5YlbYJOZ5YdeXdl+AFvbqk7oSo1PG75GR5z+5oTyrdLcfKaUF0urJBt8enC1KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddc4908c4dso79128365ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 12:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749582931; x=1750187731;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrK8Wy1KyI3rV3XRftEnw+hwnuz5px36hgQq5DVtDiQ=;
        b=WaLEjN3MnKWhvPyJvXu2khXygXEckY9ySVExPmAvMEw07ba7NuLKMfaxG6M9yVUQR5
         IwUbW/3Oy1ZiJWtDEYHrMXEnVk39pTEk3WJ7+GwOkAMx0xeAd08H0fFLEdvgiWksWwmM
         AZgZQDboQqDG6bGBLdLdEozmPsu5EF+99Md8RZejAaYEFO6RMcNhQckYo1kBMt7MPLWG
         eZsZfaldyKsi9IaypHPDhdhhIM+/013dTa3TUMZeLsqz0UlHSji8sTI1u3bNjYtI6Faw
         K/G3QCUMg+WA1TcH5zRRdqgdbMqnlEyMa3JQnGv3rjWOSi5mm1SqHC8Au1FRBzaWSGnt
         30Wg==
X-Forwarded-Encrypted: i=1; AJvYcCXfYqqsRehmRWIEaySfkqrqVlhSvUUMYoIEx9ehnsrvZgyEsnNNw+zDm158u/FKwnoV7qJ1Kl6vADvfxvAWLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyER5dvWGkHFTsY6jW2pW/clLAUVGPxDvKO0Jrx/DWyk5BPBCqm
	r+M5amNRKzSlI3WIpbF34MhLH2tUbzjNLLLEsPrIWbx9duu8sTuUc1l0XAmqoXs9belHlQe54MN
	MW2qgE3SXW0jwvuDp7/AI+G2XowvF3Ke4q57y4IdamImDglb5WWwm+HfCIpY=
X-Google-Smtp-Source: AGHT+IHQ3/9Ff8xfDfL1ambFig8YVQGKYfZ/+nFsBXRuor6+McPaHA1hBDWG7q7REboBxdzaWN6nbPdzy33iXEBv+PeuUtb0vq56
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2589:b0:3dd:a55b:39dd with SMTP id
 e9e14a558f8ab-3ddf4312328mr5764155ab.19.1749582931481; Tue, 10 Jun 2025
 12:15:31 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:15:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68488453.a70a0220.27c366.0066.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_str_hash_repair_key
From: syzbot <syzbot+7b5ffa68b7af11821176@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    19272b37aa4f Linux 6.16-rc1
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D162a0d70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D162faeb2d1eaefb=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3D7b5ffa68b7af11821=
176
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-=
1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12cb29d458000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16b22a0c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/63fc98170cdb/disk-=
19272b37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7f53e0c9076b/vmlinux-=
19272b37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/249526f4900a/bzI=
mage-19272b37.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/f7ee3e40b=
a3a/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/9520854df=
2b1/mount_1.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=3D10=
4cf20c580000)

The issue was bisected to:

commit f402d9710b3e55fa2e47a939f69e4267d6d4406f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed May 28 20:34:42 2025 +0000

    bcachefs: bch2_readdir() now calls str_hash_check_key()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D12f44d705800=
00
final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D11f44d705800=
00
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16f44d70580000

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+7b5ffa68b7af11821176@syzkaller.appspotmail.com
Fixes: f402d9710b3e ("bcachefs: bch2_readdir() now calls str_hash_check_key=
()")

bcachefs (loop0): hash table key at wrong offset: should be at 860706077345=
7356477
  u64s 7 type dirent 4096:4330382808765833931:U32_MAX len 0 ver 0: =01 -> 5=
36870912 type unknown, fixing
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in bch2_str_hash_repair_key+0x2d42/0x3fa0 f=
s/bcachefs/str_hash.c:335
Read of size 8 at addr ffff888027ef7128 by task syz-executor205/5826

CPU: 1 UID: 0 PID: 5826 Comm: syz-executor205 Not tainted 6.16.0-rc1-syzkal=
ler #0 PREEMPT(full)=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 bch2_str_hash_repair_key+0x2d42/0x3fa0 fs/bcachefs/str_hash.c:335
 __bch2_str_hash_check_key+0xa65/0xd40 fs/bcachefs/str_hash.c:394
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:429 [inline]
 bch2_readdir+0x11cd/0x16f0 fs/bcachefs/dirent.c:685
 bch2_vfs_readdir+0x4d0/0x6c0 fs/bcachefs/fs.c:1581
 iterate_dir+0x5af/0x770 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64+0xe4/0x260 fs/readdir.c:396
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45bfdee2a3
Code: c1 66 0f 1f 44 00 00 48 83 c4 08 48 89 ef 5b 5d e9 a2 48 fb ff 66 90 =
b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 05 c3 0f 1f 40 00 48 c7 c2 b8 ff ff ff f7 d8
RSP: 002b:00007ffdec01fb88 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
RAX: ffffffffffffffda RBX: 0000555564676730 RCX: 00007f45bfdee2a3
RDX: 0000000000008000 RSI: 0000555564676730 RDI: 0000000000000004
RBP: 0000555564676704 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000293 R12: ffffffffffffffb8
R13: 0000000000000010 R14: 0000555564676700 R15: 00007ffdec021e00
 </TASK>

Allocated by task 5826:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kmalloc_node_track_caller_noprof+0x271/0x4e0 mm/slub.c:4347
 __do_krealloc mm/slub.c:4905 [inline]
 krealloc_noprof+0x124/0x340 mm/slub.c:4958
 __bch2_trans_kmalloc+0x26c/0xc80 fs/bcachefs/btree_iter.c:3187
 bch2_trans_kmalloc_ip fs/bcachefs/btree_iter.h:604 [inline]
 bch2_trans_kmalloc fs/bcachefs/btree_iter.h:616 [inline]
 bch2_str_hash_repair_key+0x2a65/0x3fa0 fs/bcachefs/str_hash.c:251
 __bch2_str_hash_check_key+0xa65/0xd40 fs/bcachefs/str_hash.c:394
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:429 [inline]
 bch2_readdir+0x11cd/0x16f0 fs/bcachefs/dirent.c:685
 bch2_vfs_readdir+0x4d0/0x6c0 fs/bcachefs/fs.c:1581
 iterate_dir+0x5af/0x770 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64+0xe4/0x260 fs/readdir.c:396
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5826:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2381 [inline]
 slab_free mm/slub.c:4643 [inline]
 kfree+0x18e/0x440 mm/slub.c:4842
 krealloc_noprof+0x1cd/0x340 mm/slub.c:-1
 __bch2_trans_kmalloc+0x26c/0xc80 fs/bcachefs/btree_iter.c:3187
 bch2_trans_kmalloc_nomemzero_ip fs/bcachefs/btree_iter.h:586 [inline]
 bch2_trans_kmalloc_nomemzero fs/bcachefs/btree_iter.h:621 [inline]
 __bch2_bkey_make_mut_noupdate fs/bcachefs/btree_update.h:285 [inline]
 bch2_bkey_make_mut_noupdate fs/bcachefs/btree_update.h:300 [inline]
 bch2_str_hash_repair_key+0x2a96/0x3fa0 fs/bcachefs/str_hash.c:267
 __bch2_str_hash_check_key+0xa65/0xd40 fs/bcachefs/str_hash.c:394
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:429 [inline]
 bch2_readdir+0x11cd/0x16f0 fs/bcachefs/dirent.c:685
 bch2_vfs_readdir+0x4d0/0x6c0 fs/bcachefs/fs.c:1581
 iterate_dir+0x5af/0x770 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64+0xe4/0x260 fs/readdir.c:396
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888027ef7100
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 40 bytes inside of
 freed 64-byte region [ffff888027ef7100, ffff888027ef7140)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x27ef7
anon flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801a4418c0 ffffea0000a2cb00 dead000000000005
raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 12, tgid 12 (kworker/u=
8:0), ts 12002718519, free_ts 11909463502
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21d5/0x22b0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2619
 new_slab mm/slub.c:2673 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
 __slab_alloc mm/slub.c:3949 [inline]
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __kmalloc_cache_noprof+0x296/0x3d0 mm/slub.c:4354
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 percpu_ref_init+0xc5/0x360 lib/percpu-refcount.c:76
 blk_alloc_queue+0x419/0x620 block/blk-core.c:447
 blk_mq_alloc_queue+0x15c/0x290 block/blk-mq.c:4396
 scsi_alloc_sdev+0x76d/0xb50 drivers/scsi/scsi_scan.c:339
 scsi_probe_and_add_lun+0x1cb/0x4520 drivers/scsi/scsi_scan.c:1210
 __scsi_scan_target+0x1dd/0xd10 drivers/scsi/scsi_scan.c:1775
 scsi_scan_channel drivers/scsi/scsi_scan.c:1863 [inline]
 scsi_scan_host_selected+0x372/0x690 drivers/scsi/scsi_scan.c:1892
 do_scsi_scan_host drivers/scsi/scsi_scan.c:2031 [inline]
 do_scan_async+0x124/0x760 drivers/scsi/scsi_scan.c:2041
 async_run_entry_fn+0xa5/0x3f0 kernel/async.c:129
page last free pid 24 tgid 24 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0xc65/0xe60 mm/page_alloc.c:2706
 vfree+0x25a/0x400 mm/vmalloc.c:3426
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3345
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888027ef7000: 00 00 00 00 00 00 00 06 fc fc fc fc fc fc fc fc
 ffff888027ef7080: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>ffff888027ef7100: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                  ^
 ffff888027ef7180: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888027ef7200: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisectio=
n

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
