Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55558224FA
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Jul 2025 21:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751837427; cv=none; b=Jy6O0yBalCR+RuWUG4hmWST9VXPJCLftCLBThbip/JCyDMT5UViJZyVz8/+iM6HAN6BRnmChGWBg5MVqQlJ0nT1q0awVOjkalATOJd5cT/JdQfsXvjBMhoNsonmvWDvTCPBBgctcBV//RPVakZpzkBw1IhUpovLW6FaiYXcOQf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751837427; c=relaxed/simple;
	bh=tXaGITA0/0XKX+miIZYvHe7kR9e4fSJruF1Pm857A34=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OA6ClGMFsqc1Zf4AtMRnX5/VG3Doh82hh6oroNGqplGoooSEQg0M1cPtf7bLNI958s3k9EiQLI7/lyFrxkYcTtm1UnPDALrWbaRUdzEzORscgvusA9ldqZrutLb4UBfFtDGSDPPDfLIBAFgpAUYseqFD/m6X9QPdM2unnvn4mS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-86d07944f29so548640639f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 06 Jul 2025 14:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751837424; x=1752442224;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RrjMT1Wj24+rLr8+0c1itao75RJEnt0jPKn6Ilo3Yg0=;
        b=qOTB9h3M3OMBHrCfD6P1vWH5ExkVsFwotCSSm5i4YFnMoX0soJeGoUvSr53B1b3C5y
         8uz8+nUmeURIflkr3HBpKzGJpO8mMQSLIf4LDyDuA3gP45RScXOfR5aeO31qD05OIekX
         MGHecIMfF0FZlajNCuMaJxzLlYmkfisnjjIGNXixRJ1eYFLMRLv1nfPL3SBYGo4mri+U
         8/KOPOgSRnyU6xxEoVF6NTBgC85h3ipykx9nXu2L60MZZWO5nv/QAZIrliRbQuk7eF3O
         txkXBSJiXzMozn+1KRSChq420sDiwvbnM3Jc0UFBSN1wzJ1RWEHBwh0IlDgZUBIEXp6/
         D6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKZU0v8iDAQ36WUeUy45bkLvBoZ7jHaG1eHQeG6ZQwWofrWtGspEwGHJy3E2/Tg34+DcKx/yyjzOdp4JOuBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXZEt6IKYA9voIbujyzpXcnzCukYRqFhBmEOIgblSv6hkzFJ4m
	1XixUrK8miy7BxoXN9ZiA54x0FYWk7SSXey1zWy/nydUR7XpSRK58HtWDGaeGIH0R2IK31aHWvL
	+apNy9bGrZhJC94ClRmFnvdIvxLSdrlFMCWnC/ZvjQFoTTNwJGKvGEYgcG5A=
X-Google-Smtp-Source: AGHT+IEN+ea1FxCBj/zHweJDdhdodocuj4KLF975a55OIzzMCKsfH4nfQpZFSrj3838KYHwF3o2G8tFmXQPwL+y+Z4w9xmmuK1MH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24f:0:b0:3df:29c8:49ff with SMTP id
 e9e14a558f8ab-3e13724def5mr92799755ab.22.1751837424455; Sun, 06 Jul 2025
 14:30:24 -0700 (PDT)
Date: Sun, 06 Jul 2025 14:30:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686aeaf0.a00a0220.c7b3.0065.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in __bch2_alloc_to_v4
From: syzbot <syzbot+487dd8c670b175dd59ed@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c435a4f487e8 Merge tag 'riscv-for-linus-6.16-rc5' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127673d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b29b1a0d7330d4a8
dashboard link: https://syzkaller.appspot.com/bug?extid=487dd8c670b175dd59ed
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c435a4f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3a184d1ad283/vmlinux-c435a4f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db5931917c56/bzImage-c435a4f4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+487dd8c670b175dd59ed@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __bch2_alloc_to_v4+0x7b/0x8b0 fs/bcachefs/alloc_background.c:388
Read of size 64 at addr ffff888055140ba8 by task kworker/u4:5/1035

CPU: 0 UID: 0 PID: 1035 Comm: kworker/u4:5 Not tainted 6.16.0-rc4-syzkaller-00286-gc435a4f487e8 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: btree_update btree_interior_update_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 __bch2_alloc_to_v4+0x7b/0x8b0 fs/bcachefs/alloc_background.c:388
 bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:236 [inline]
 bch2_trigger_alloc+0x323/0x4090 fs/bcachefs/alloc_background.c:871
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:-1 [inline]
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:554 [inline]
 __bch2_trans_commit+0xa84/0x8870 fs/bcachefs/btree_trans_commit.c:1023
 bch2_trans_commit fs/bcachefs/btree_update.h:241 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:729 [inline]
 btree_interior_update_work+0x1082/0x27d0 fs/bcachefs/btree_update_interior.c:867
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5334:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4340
 kmalloc_noprof include/linux/slab.h:909 [inline]
 bch2_journal_key_insert+0x50/0x140 fs/bcachefs/btree_journal_iter.c:342
 do_bch2_trans_commit_to_journal_replay+0x127/0xd70 fs/bcachefs/btree_trans_commit.c:966
 __bch2_trans_commit+0x1b67/0x8870 fs/bcachefs/btree_trans_commit.c:1030
 bch2_trans_commit fs/bcachefs/btree_update.h:241 [inline]
 bch2_gc_alloc_done fs/bcachefs/btree_gc.c:951 [inline]
 bch2_check_allocations+0x2ee0/0x57b0 fs/bcachefs/btree_gc.c:1100
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:484 [inline]
 __bch2_run_recovery_passes+0x395/0x1010 fs/bcachefs/recovery_passes.c:539
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:610
 bch2_fs_recovery+0x2690/0x3a50 fs/bcachefs/recovery.c:1005
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888055140b80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 40 bytes inside of
 allocated 88-byte region [ffff888055140b80, ffff888055140bd8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x55140
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801a441280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 13, tgid 13 (kworker/u4:1), ts 69427733463, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2619
 new_slab mm/slub.c:2673 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
 __slab_alloc mm/slub.c:3949 [inline]
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4340
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 cfg80211_inform_single_bss_data+0x905/0x1ac0 net/wireless/scan.c:2339
 cfg80211_inform_bss_data+0x1fb/0x3b20 net/wireless/scan.c:3222
 cfg80211_inform_bss_frame_data+0x3d7/0x730 net/wireless/scan.c:3313
 ieee80211_bss_info_update+0x746/0x9e0 net/mac80211/scan.c:226
 ieee80211_rx_bss_info net/mac80211/ibss.c:1094 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1573 [inline]
 ieee80211_ibss_rx_queued_mgmt+0xa36/0x2ae0 net/mac80211/ibss.c:1600
 ieee80211_iface_process_skb net/mac80211/iface.c:1668 [inline]
 ieee80211_iface_work+0x806/0xfe0 net/mac80211/iface.c:1722
 cfg80211_wiphy_work+0x2df/0x460 net/wireless/core.c:435
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888055140a80: 00 00 00 00 00 00 00 00 00 00 03 fc fc fc fc fc
 ffff888055140b00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff888055140b80: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
                                                    ^
 ffff888055140c00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888055140c80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


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
