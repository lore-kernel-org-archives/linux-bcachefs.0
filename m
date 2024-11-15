Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4046018E047
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731669086; cv=none; b=Y/i771qaBmh1DjN2+UtjsfxCog+3lrvvjGtVXWKyeoVgww/ibTYayDwRIYe37WNgCkZwqWrtdq3Qtf7Etr0cbzuG5L/qj66RKo3meXnxNHaWYX/T7GenXqBN+KhdVPQCSJylbT+Z18XO/Py/oadRhlM3cqfyhs3xftuJrJbbbuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731669086; c=relaxed/simple;
	bh=r0LRs6BBLyFgffLGcLI2FizbPZ0oLeCKfALogOeD3b4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CyQz05SbHYhQ2sj4fXBBk2v6qof391XageAoX12pDtU7I4bM1D+VJQLLGTj/ugG0niv4SEnnMkUYmTQDvi6QCuGkdozBVylbgIHjm7nLL/g/247z2ZDyxdSfPbK1cXaEeV4y7gl44ewCKEX9L1NWIQ+G0M9puinYGFX8B+GwrU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7162d1485so18735185ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 03:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731669084; x=1732273884;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A2D+iGtXtlP5BGY78Rq7ex2Vqvh3pR2KhBDu2cd56gg=;
        b=Dte0uPXcns7FwRcXuFLApywhBzUvWKvTqR3pY/LQnCPXw6nwiqrSkvZWA4O+r6Zym7
         tZN3lqGGpB882aOThYnHpI8290JWOjVXbbTJuiurA5d0ryDBh0VC366LWUzxkNf/UAOz
         nn0s6y+Kym67oiv51yznL4Uoa+UutzL0BntNskLlt4WT0QS2s+2wJqTF9I4haPatrgCf
         c918x0Bb+sa1mL6THy9jCX/5o8AE8HzqdpKq+VqylRqcd9rRSxhtE5vQDPthXqA0xR/Z
         +mF02IBmim+rcwruSJ6dzXVz4C6krwxzcoauVX9QKU8mepUd0yF0RwzQLYk6L8APN2PE
         jV+w==
X-Forwarded-Encrypted: i=1; AJvYcCWMy9/utByzs5ch3SaHQo2IBBF+oZ+VGPSNHUHcm1QzlSLVAQctOLf092VtTPTANwZOan0yx1umyJzHSEDz6g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2U5vsH5hbyb2cLPbUf8oE4nWpBPF+xbC7zQ2iG7tkTJm4fLZu
	v5qhZABtGvtsy9IUtgci0cFIsa3FMxBh51ik4uyPvkdI9GR2rKiFB1dNQLnG13BLeQJzPaV9roa
	mQjyWwjrLcdovWHzjPEtRwfDaBS/cUFZkpSQo6gd9oGR+nEhQlw8pFq4=
X-Google-Smtp-Source: AGHT+IG3mi5FRMsAsGpRmoLMSOB46ihxMO365XyCO0tY4/OnnekeZ63KR1FiP+b6wl9sBCnZhGbzNHuAproE9dJw2D3py9wiKlkr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:388d:b0:3a6:bd97:96bf with SMTP id
 e9e14a558f8ab-3a7480c1d9fmr24418445ab.24.1731669084328; Fri, 15 Nov 2024
 03:11:24 -0800 (PST)
Date: Fri, 15 Nov 2024 03:11:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67372c5c.050a0220.1324f8.00aa.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_check_dirents
From: syzbot <syzbot+fea0322882c0cba65f11@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168f02e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1503500c6f615d24
dashboard link: https://syzkaller.appspot.com/bug?extid=fea0322882c0cba65f11
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112b1130580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1256ab5f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54bc03ad6b5e/disk-cfaaa7d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/310213a259a7/vmlinux-cfaaa7d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ad864691b9a0/bzImage-cfaaa7d0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/856c46853b28/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fea0322882c0cba65f11@syzkaller.appspotmail.com

dirent points to missing inode:
u64s 8 type dirent 4096:8130059955150870709:U32_MAX len 0 ver 0: lost+found -> 4097 type dir, fixing
==================================================================
BUG: KASAN: use-after-free in check_dirent fs/bcachefs/fsck.c:2528 [inline]
BUG: KASAN: use-after-free in bch2_check_dirents+0x1fee/0x2570 fs/bcachefs/fsck.c:2552
Read of size 1 at addr ffff88805da80160 by task syz-executor262/6243

CPU: 0 UID: 0 PID: 6243 Comm: syz-executor262 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 check_dirent fs/bcachefs/fsck.c:2528 [inline]
 bch2_check_dirents+0x1fee/0x2570 fs/bcachefs/fsck.c:2552
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
RIP: 0033:0x7f669fe0863a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f669fdaefd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f669fdaeff0 RCX: 00007f669fe0863a
RDX: 00000000200058c0 RSI: 0000000020000000 RDI: 00007f669fdaeff0
RBP: 0000000000000004 R08: 00007f669fdaf030 R09: 0000000000005917
R10: 0000000000010000 R11: 0000000000000282 R12: 00007f669fdaf030
R13: 0000000000010000 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5da80
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f0(buddy)
raw: 00fff00000000000 ffff88813fffc788 ffffea00015da808 0000000000000000
raw: 0000000000000000 0000000000000005 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Unmovable, gfp_mask 0x52800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP), pid 6243, tgid 6242 (syz-executor262), ts 88543202500, free_ts 96575602066
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x363e/0x3790 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4750
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 ___kmalloc_large_node+0x8b/0x1d0 mm/slub.c:4209
 __kmalloc_large_node_noprof+0x1a/0x80 mm/slub.c:4236
 __do_kmalloc_node mm/slub.c:4252 [inline]
 __kmalloc_node_noprof+0x2d2/0x440 mm/slub.c:4270
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:658
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 bch2_btree_node_read_done+0x3808/0x5e90 fs/bcachefs/btree_io.c:1188
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
page last free pid 6243 tgid 6242 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0xc91/0xf90 mm/page_alloc.c:1269
 __folio_put+0x2c7/0x440 mm/swap.c:112
 folio_put include/linux/mm.h:1478 [inline]
 free_large_kmalloc+0x105/0x1c0 mm/slub.c:4698
 kfree+0x21c/0x440 mm/slub.c:4721
 btree_bounce_free fs/bcachefs/btree_io.c:112 [inline]
 btree_node_sort+0x1100/0x1830 fs/bcachefs/btree_io.c:380
 bch2_btree_post_write_cleanup+0x11a/0xa70 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_prep_for_write+0x55b/0x8f0 fs/bcachefs/btree_trans_commit.c:93
 bch2_trans_lock_write+0x68e/0xc60 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x26f2/0x93c0 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 check_dirent fs/bcachefs/fsck.c:2524 [inline]
 bch2_check_dirents+0x1431/0x2570 fs/bcachefs/fsck.c:2552
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814

Memory state around the buggy address:
 ffff88805da80000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88805da80080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88805da80100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                       ^
 ffff88805da80180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88805da80200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


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
