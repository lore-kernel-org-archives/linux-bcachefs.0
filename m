Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54638199BC
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 May 2025 12:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746968250; cv=none; b=B6p6ZxJG+sN6Mhco2GZx2ercJkzxjVW58gQr36UqxGI0zGxEkZlc1MqqyYD4hamGXOcuI2oyD3LeJO1SG3wal+4ChOFL0hkvIjWbKB1dy9EfYSKrxC2/tmLoyCbS7s8JMRKxje0sJpxE+b2I+nJS2IIwfMCGmjUc3wDyE1LW3N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746968250; c=relaxed/simple;
	bh=+K8EpEt/CAfUZIpi+myO239tu4+rRh/te3TXNqWUtBs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jzHOPhxwgy0BSa4KDMtuHFx+uZAjacNy0MVpg/VLLlsoZCCRl4Cw3Pi6xUcO3uztpcbxiap7lR9vxQUOi2B6GtS0lgjVWsGYMsewH2KUmEHoPjceZbu0BycqQ26FgQLI58+dh9hFGiSYdZIU+6PW9ii13vrF6pT+yl4NNT2fqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d91a0d3e15so39032265ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 11 May 2025 05:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746968247; x=1747573047;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o2Kjh5x3/9gdh2OrYxRLL/LdpbR1cvRGAthvDpJx7Rw=;
        b=Zrb+UKqeURupDAXqP6NtK4n+pZKK0BeGeGgIUy0AaXa4TxHdjQ/7w0PnECZYaDsAJp
         BCuJHUlHE4sKWq0nvd5lZZVjxEmNQSrSlImEK6dXaYlqe3gvHZ1HRfW1yijO/OwssvFe
         Kgqdm6JF57/q041Mifj5UP7KrZYRPzMLWmNsAyUUEO/bnXqztbPXkYSCfRHiFvrsA40p
         ZbFaEVgXoMvSz6oTRuELetML7PMB96Drw1BeK16m00XdfZVy19k5rkmM5HIC3YQn5mXY
         XOaXVy+BrcbaIKi83ycLiOycTHiGrAA13NXqynuZMkYxvEaB7ICphFRgBOlvDQQaO/ap
         Y2dg==
X-Forwarded-Encrypted: i=1; AJvYcCWu7qjg651mqe4aCsM80ZghWpvOc/8KaUVrBJ8oRp2bRE3Yf5on2QrtRX1VSiyYd69pgLz0yUim9YSFUMu3JA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNI1J6+dyKfJ0G9kctJEVhHBohWi5I+UCJpQpFT5Z/4g/mHuNR
	hVXdM5m+HGdTsYOPbFnB+UVHN44P6JZbtTu6VP04sDOXPrWQqr23UZIJ/Kj+GcsRYS6hHfH+3Sg
	j72CziM5l7ZH7FkZ/10uxCtshWvyRL0SWHxA67L0F3KOv4jCAc14SA+w=
X-Google-Smtp-Source: AGHT+IHJAOVb+NecMT3GEA06eMj3k6igcjqoWpYdRTLciZYKMYYHri8MF6N1PVY4BTSmSu5UmlMjltwWCKcbSHyW2PxNPvkNiknB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c245:0:b0:3d4:2a4e:1272 with SMTP id
 e9e14a558f8ab-3da7e2173dbmr109754535ab.19.1746968247449; Sun, 11 May 2025
 05:57:27 -0700 (PDT)
Date: Sun, 11 May 2025 05:57:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68209eb7.050a0220.f2294.0035.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_checksum
From: syzbot <syzbot+7d5c34b9ec9fe139fc0c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d76bb1ebb558 Merge tag 'erofs-for-6.15-rc6-fixes' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1594e4f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9683d529ec1b880
dashboard link: https://syzkaller.appspot.com/bug?extid=7d5c34b9ec9fe139fc0c
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123544d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11870768580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8c8c524d8686/disk-d76bb1eb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c89d5e1e7d6f/vmlinux-d76bb1eb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/923d0906d02c/bzImage-d76bb1eb.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/af55279b702f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7d5c34b9ec9fe139fc0c@syzkaller.appspotmail.com

  node offset 8/40 bset u64s 375: checksum error, type chacha20_poly1305_128: got eb21ae8bf0ac3fa53472f8290f6e6780 should be 61ec379a8789477e76ff1a5280fd6dbd, fixing
==================================================================
BUG: KASAN: use-after-free in poly1305_update include/crypto/poly1305.h:83 [inline]
BUG: KASAN: use-after-free in bch2_checksum+0x209/0x490 fs/bcachefs/checksum.c:157
Read of size 8 at addr ffff888070915af0 by task syz-executor367/5826

CPU: 1 UID: 0 PID: 5826 Comm: syz-executor367 Not tainted 6.15.0-rc5-syzkaller-00043-gd76bb1ebb558 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/29/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xb4/0x290 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x29a/0x2b0 mm/kasan/generic.c:189
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 poly1305_update include/crypto/poly1305.h:83 [inline]
 bch2_checksum+0x209/0x490 fs/bcachefs/checksum.c:157
 bch2_btree_node_read_done+0x1003/0x5470 fs/bcachefs/btree_io.c:1132
 btree_node_read_work+0x565/0xef0 fs/bcachefs/btree_io.c:1366
 bch2_btree_node_read+0x2151/0x27a0 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1797 [inline]
 bch2_btree_root_read+0x5e7/0x750 fs/bcachefs/btree_io.c:1819
 read_btree_roots+0x2cb/0x800 fs/bcachefs/recovery.c:582
 bch2_fs_recovery+0x2356/0x37b0 fs/bcachefs/recovery.c:929
 bch2_fs_start+0x70b/0xae0 fs/bcachefs/super.c:1091
 bch2_fs_get_tree+0xd99/0x13a0 fs/bcachefs/fs.c:2570
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
 do_new_mount+0x24a/0xa40 fs/namespace.c:3884
 do_mount fs/namespace.c:4224 [inline]
 __do_sys_mount fs/namespace.c:4435 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4412
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff05760c2fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff0575c1088 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ff0575c10a0 RCX: 00007ff05760c2fa
RDX: 000020000000f640 RSI: 0000200000000080 RDI: 00007ff0575c10a0
RBP: 0000200000000080 R08: 00007ff0575c10e0 R09: 000000000000f5fe
R10: 0000000000010000 R11: 0000000000000282 R12: 000020000000f640
R13: 00007ff0575c10e0 R14: 0000000000000003 R15: 0000000000010000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x70915
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Reclaimable, gfp_mask 0x452cd0(GFP_KERNEL_ACCOUNT|__GFP_RECLAIMABLE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5826, tgid 5825 (syz-executor367), ts 88234860937, free_ts 88442709891
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1d8/0x230 mm/page_alloc.c:1718
 prep_new_page mm/page_alloc.c:1726 [inline]
 get_page_from_freelist+0x21c7/0x22a0 mm/page_alloc.c:3688
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4970
 __alloc_pages_noprof+0xa/0x30 mm/page_alloc.c:5004
 __alloc_pages_node_noprof include/linux/gfp.h:284 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:311 [inline]
 ___kmalloc_large_node+0x85/0x200 mm/slub.c:4271
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:4299
 __do_kmalloc_node mm/slub.c:4315 [inline]
 __kvmalloc_node_noprof+0x74/0x5e0 mm/slub.c:5012
 btree_node_data_alloc+0xd5/0x260 fs/bcachefs/btree_cache.c:156
 __bch2_btree_node_mem_alloc+0x1ed/0x410 fs/bcachefs/btree_cache.c:201
 bch2_fs_btree_cache_init+0x2c9/0x680 fs/bcachefs/btree_cache.c:656
 bch2_fs_alloc fs/bcachefs/super.c:909 [inline]
 bch2_fs_open+0x235e/0x2820 fs/bcachefs/super.c:2205
 bch2_fs_get_tree+0x45d/0x13a0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
 do_new_mount+0x24a/0xa40 fs/namespace.c:3884
 do_mount fs/namespace.c:4224 [inline]
 __do_sys_mount fs/namespace.c:4435 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4412
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
page last free pid 5826 tgid 5825 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_pages_ok+0x910/0xac0 mm/page_alloc.c:1438
 __folio_put+0x21b/0x2c0 mm/swap.c:112
 folio_put include/linux/mm.h:1580 [inline]
 free_large_kmalloc+0x145/0x200 mm/slub.c:4767
 btree_bounce_free fs/bcachefs/btree_io.c:112 [inline]
 bch2_btree_node_read_done+0x3450/0x5470 fs/bcachefs/btree_io.c:1245
 btree_node_read_work+0x565/0xef0 fs/bcachefs/btree_io.c:1366
 bch2_btree_node_read+0x2151/0x27a0 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1797 [inline]
 bch2_btree_root_read+0x5e7/0x750 fs/bcachefs/btree_io.c:1819
 read_btree_roots+0x2cb/0x800 fs/bcachefs/recovery.c:582
 bch2_fs_recovery+0x2356/0x37b0 fs/bcachefs/recovery.c:929
 bch2_fs_start+0x70b/0xae0 fs/bcachefs/super.c:1091
 bch2_fs_get_tree+0xd99/0x13a0 fs/bcachefs/fs.c:2570
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
 do_new_mount+0x24a/0xa40 fs/namespace.c:3884
 do_mount fs/namespace.c:4224 [inline]
 __do_sys_mount fs/namespace.c:4435 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4412
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888070915980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888070915a00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888070915a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                             ^
 ffff888070915b00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888070915b80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
