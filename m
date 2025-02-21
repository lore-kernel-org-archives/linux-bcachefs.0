Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0471DE4E5
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155306; cv=none; b=UMN6wFmeL+cBNWcCyKXNofbRZsjdu6uiPC3u03vc6MEbyfJqeE+Vevh+hz4RWReeH8e/Gb9zQlOyl4m2dvEfTA+O+VS88tD9BptMKLl4teYRwbWW8pEDxT4iNi2rFI3UODMiA8JBRQ6Oegz64xPLbUd0eYJSEr1JYwlWSHkwr/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155306; c=relaxed/simple;
	bh=qia/fCiVLcWt+Z32zlYwdz6ktO5i18TyK4pCNNXyj9Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HBHRjvLe7nwuOIFqzZVcAr+FkTpKSXNXsOIDBKJhQQ5DM4gNZEb7BihAJXMjNxnllVh+Cua9ALHI+w9l3HVxr6yXHjbWNpapzVV5WbTMuNuHqCIFJX60QVAVDSc0lJGKBAn/30ISfLgCOXABPvGhzZw4rr8tdaXGrHtf2AjC5wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3cf64584097so19938845ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Feb 2025 08:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740155304; x=1740760104;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DuKxzuycpWm3A5WKBgS5xxc6Dq/6hI3I1jkFkc+KTlo=;
        b=ombNiUEzfwiKAJLaOjt8OqYnald55FFMU7Liu1nNikptabuE+kiGTfERiqrHoMsa8J
         FK6d+2027+0OkFvG9Z/KqkMm0mnDSTD8RTl4Psd60V1JBHFAvBnsRDl1cweYrgdFIjJt
         wtH3Oztm5zqy5l649Ijovz+9RBFPMiZ1quHmJgdV/o4RItZ5ih3Vpyzth6djHKWzbNOd
         TQWg3es4jCAjBHreVGj/otpU0v5V/3JUXTotcfXDnB+OioxfPRXiQHWM5qBvuaA1O3Sw
         zVpAGRMjcgNgdW9oLxtiWAqiIVBzzVnkuN/6xgeBTHgkPEPzGf2JB2Cs3OGTkvjj4VNN
         7ynw==
X-Forwarded-Encrypted: i=1; AJvYcCXVT3bWuqTiQ6j4/KesIT7ayArEGoLOKtUfeQ2z+wlsS3U78uq93pFwmtqOr/Onm64t0KddWSQEOeBaQDjW9g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1cD+oq6kua5W9mMzA2Jedn9/4n4LCMgWzdAMgwdwXFFCodYv+
	0OgTdKf3bNvonfc8xxE26llp1pxrWnrL7StsRykX9fOFRdDtPHpPmv+3KY4ZmN68YpsA3luezgj
	Bia+NRlpJUa4w7kghKRMb/qQevPhTNi32ezgz0DRQU0OTT0IJz9HAkjQ=
X-Google-Smtp-Source: AGHT+IG1NnmGS24t5E/TeZO/+FqVFN/dkaCW2fzkM3aAuvIDRGA6V00ohH+ordMxRfb5iaRoOhfwzzH/gRoqUivY2744g2gYWRfd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1908:b0:3d0:21aa:a752 with SMTP id
 e9e14a558f8ab-3d2cae47e92mr43504955ab.2.1740155303877; Fri, 21 Feb 2025
 08:28:23 -0800 (PST)
Date: Fri, 21 Feb 2025 08:28:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b8a9a7.050a0220.14d86d.0578.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in check_dirent
From: syzbot <syzbot+87078ad27cd8af3263cc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    27eddbf34490 Merge tag 'net-6.14-rc4' of git://git.kernel..=
.
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D10e33ae4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db03346163189483=
c
dashboard link: https://syzkaller.appspot.com/bug?extid=3D87078ad27cd8af326=
3cc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Deb=
ian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14ce6ba458000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11300db0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/352b56907a7c/disk-=
27eddbf3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b46eb02d0be1/vmlinux-=
27eddbf3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db572e905b96/bzI=
mage-27eddbf3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a13c47175ab5=
/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+87078ad27cd8af3263cc@syzkaller.appspotmail.com

bcachefs (loop4): check_dirents...
dirent points to missing inode:
u64s 8 type dirent 4096:6728544935518790663:U32_MAX len 0 ver 0: lost+found=
=07 -> 4097 type dir, fixing
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in check_dirent+0x2455/0x2620 fs/bcachefs/fsck.c=
:2443
Read of size 1 at addr ffff888078964048 by task syz-executor115/5937

CPU: 1 UID: 0 PID: 5937 Comm: syz-executor115 Not tainted 6.14.0-rc3-syzkal=
ler-00137-g27eddbf34490 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xc3/0x670 mm/kasan/report.c:521
 kasan_report+0xd9/0x110 mm/kasan/report.c:634
 check_dirent+0x2455/0x2620 fs/bcachefs/fsck.c:2443
 bch2_check_dirents+0x409/0x780 fs/bcachefs/fsck.c:2468
 bch2_run_recovery_pass+0x91/0x1a0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x3f4/0x8f0 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x3c1b/0x43d0 fs/bcachefs/recovery.c:973
 bch2_fs_start+0x343/0x660 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x1118/0x1760 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x8e/0x340 fs/super.c:1814
 do_new_mount fs/namespace.c:3560 [inline]
 path_mount+0x14e6/0x1f10 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount fs/namespace.c:4088 [inline]
 __x64_sys_mount+0x28f/0x310 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8021a8861a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcadd266b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8021a8861a
RDX: 0000400000000000 RSI: 0000400000000040 RDI: 00007ffcadd26700
RBP: 0000000000000004 R08: 00007ffcadd26740 R09: 0000000000005956
R10: 0000000001000001 R11: 0000000000000282 R12: 0000000001000000
R13: 00007ffcadd26740 R14: 0000400000000000 R15: 0000000000000003
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78964
flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Unmovable, gfp_mask 0x52800(GF=
P_NOWAIT|__GFP_NORETRY|__GFP_COMP), pid 5937, tgid 5937 (syz-executor115), =
ts 106777006193, free_ts 107291852583
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x181/0x1b0 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0xfce/0x2f80 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x221/0x2470 mm/page_alloc.c:4739
 __alloc_pages_noprof+0xb/0x1b0 mm/page_alloc.c:4773
 __alloc_pages_node_noprof include/linux/gfp.h:265 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:292 [inline]
 ___kmalloc_large_node+0x84/0x1b0 mm/slub.c:4239
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:4266
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_noprof.cold+0x5/0x5f mm/slub.c:4300
 __kvmalloc_node_noprof+0x6f/0x1a0 mm/util.c:662
 btree_bounce_alloc+0x11e/0x210 fs/bcachefs/btree_io.c:123
 btree_node_sort+0x1104/0x14f0 fs/bcachefs/btree_io.c:322
 bch2_btree_post_write_cleanup fs/bcachefs/btree_io.c:2293 [inline]
 bch2_btree_post_write_cleanup+0x145/0x600 fs/bcachefs/btree_io.c:2267
 bch2_btree_node_prep_for_write+0x35b/0x550 fs/bcachefs/btree_trans_commit.=
c:93
 bch2_trans_lock_write+0x6c5/0x8e0 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:862 [inline]
 __bch2_trans_commit+0x2264/0x7d70 fs/bcachefs/btree_trans_commit.c:1070
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 __bch2_str_hash_check_key+0x2097/0x3800 fs/bcachefs/str_hash.c:292
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:415 [inline]
 check_dirent+0x12d3/0x2620 fs/bcachefs/fsck.c:2373
page last free pid 5937 tgid 5937 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0x62b/0xe50 mm/page_alloc.c:1271
 __folio_put+0x32a/0x450 mm/swap.c:112
 kvfree+0x47/0x50 mm/util.c:705
 btree_bounce_free fs/bcachefs/btree_io.c:111 [inline]
 btree_node_sort+0xf9f/0x14f0 fs/bcachefs/btree_io.c:379
 bch2_btree_post_write_cleanup fs/bcachefs/btree_io.c:2293 [inline]
 bch2_btree_post_write_cleanup+0x145/0x600 fs/bcachefs/btree_io.c:2267
 bch2_btree_node_prep_for_write+0x35b/0x550 fs/bcachefs/btree_trans_commit.=
c:93
 bch2_trans_lock_write+0x6c5/0x8e0 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:862 [inline]
 __bch2_trans_commit+0x2264/0x7d70 fs/bcachefs/btree_trans_commit.c:1070
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 check_dirent+0xff1/0x2620 fs/bcachefs/fsck.c:2438
 bch2_check_dirents+0x409/0x780 fs/bcachefs/fsck.c:2468
 bch2_run_recovery_pass+0x91/0x1a0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x3f4/0x8f0 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x3c1b/0x43d0 fs/bcachefs/recovery.c:973
 bch2_fs_start+0x343/0x660 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x1118/0x1760 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x8e/0x340 fs/super.c:1814

Memory state around the buggy address:
 ffff888078963f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888078963f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888078964000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                              ^
 ffff888078964080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888078964100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
directory 4096:4294967295 with wrong i_size: got 288, should be 352, fixing
 done
bcachefs (loop4): resume_logged_ops... done
bcachefs (loop4): delete_dead_inodes... done
bcachefs (loop4): Second fsck run was not clean
bcachefs (loop4): going read-only
bcachefs (loop4): finished waiting for writes to stop
bcachefs (loop4): flushing journal and stopping allocators, journal seq 22
bcachefs (loop4): flushing journal and stopping allocators complete, journa=
l seq 23
bcachefs (loop4): clean shutdown complete, journal seq 24
bcachefs (loop4): marking filesystem clean
bcachefs (loop4): done starting filesystem


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
