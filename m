Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317885C4A
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Jul 2025 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752525760; cv=none; b=dXs6Y1YOFqgj4GSrbV9wXzUSge/tfvvJyj2tms3HXUjanf79fn0gVSY0/io8YL9uOlzPIcPRECL7lOoUmt+vQMaxKlcwFu/taw+mXWg3LvP/repDksZZKd9f0kg8t6JCPz+UZ/WEf9ymPIdcD/LENdjaSiIc6DW2Dy3y7FATRnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752525760; c=relaxed/simple;
	bh=tB4NVytz8PRnCn5mwEP45bFz4wDXF8af5Cjn1c6MNt4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ckMpjsqOVGJ7zkZkN8m48l6kxisK4fWclu526jcP8nxWKICLiHGbDPK0fzQzd85FpOF5b3XmIsXz1nSajD7u+eH+YIxL+euVBkNa9swrOl+3KlyDF66dV23EZbLCm3KVCyBD2gW02VbBEnQdkVQzR+IK3mJKZEmDcLA1WCz4aUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-876a65a7157so436697439f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Jul 2025 13:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752525757; x=1753130557;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=khgQwb4Lf5fISYW7c4wlubCCxntor31tFAiaaSt8sbQ=;
        b=QpBIHhmUszkIhktJ+b/0yun1D3ZLhMn9j6GQ1MlKaGiuDOhft2vwZIbIQu4uzNan5S
         F57X6eXBeMPJm4N4EqImalS7QgJTtFBA9zW6oODYcfTVLfYghzdUo2T9Zhz88FdxAlLD
         JeRyDYqYeX/gEURa5BtAm42f6k7r5+gu7nG1zL7FrgLG1HgQIC3PgHpU7dmhLWnMdu7d
         yJ4C3lxeoU6wArYITdHiFm/rmsGRpZBpU+Q1pcu6NTgLNA0Oo+6ZY+mXodh6ri3KCA8N
         RYRbykuEo4SN5meyQOq/1K+Oog+kUPyVg8t7lgrzUyzWOl9584/+iFeyVAG9MAVGWFpP
         ZObw==
X-Forwarded-Encrypted: i=1; AJvYcCV2c7RhETkO4S3zeIDuJ3pxNeUucJHDt+RIaoexGjm/Lqr0uIWMyqGD1mEX9pzkm3fRDrsLxEFMqppyZBdrNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvSSrDHnz2JyE7Pbx9clq+zDVMcGAHyUuCeoQDbkf0pEw0U0Wj
	e5s4Jxgr3P7D/u56m+WKRd83nBjGV9Riep0OStSoYnW3J+nbFMeLKgMEd6eDdeNOJZnTF1SKWhe
	We+djm/LqJDJxlLeFk1sZfUqdXn78e99drRMtWrerTitjz946QeWDHmuaE/g=
X-Google-Smtp-Source: AGHT+IH2Mf1WHw/sImPwrW4AmL2TE2x3/l3QC5LrSJLOkJOPiu5AUQbS1v7fwu31vwalVgUnjobLOTWNMkvB6em/FWdyNFygHRzN
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:8208:b0:879:39eb:988f with SMTP id
 ca18e2360f4ac-879aee2706bmr90378239f.2.1752525757279; Mon, 14 Jul 2025
 13:42:37 -0700 (PDT)
Date: Mon, 14 Jul 2025 13:42:37 -0700
In-Reply-To: <6851902b.a70a0220.395abc.0223.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68756bbd.a70a0220.18f9d4.0008.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Write in bch2_dirent_init_name
From: syzbot <syzbot+894877f2c4dd5fdea634@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    347e9f5043c8 Linux 6.16-rc6
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13c670f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f09d04131ef56b22
dashboard link: https://syzkaller.appspot.com/bug?extid=894877f2c4dd5fdea634
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133cc7d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a4518c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7d8e110455be/disk-347e9f50.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4dee9ae820cb/vmlinux-347e9f50.xz
kernel image: https://storage.googleapis.com/syzbot-assets/26ea07888a9b/bzImage-347e9f50.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/df51adb1876e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+894877f2c4dd5fdea634@syzkaller.appspotmail.com

bcachefs (loop0): done starting filesystem
==================================================================
BUG: KASAN: slab-out-of-bounds in bch2_dirent_init_name+0x396/0x8b0 fs/bcachefs/dirent.c:273
Write of size 1985 at addr ffff8881496a3041 by task syz-executor478/5839

CPU: 0 UID: 0 PID: 5839 Comm: syz-executor478 Not tainted 6.16.0-rc6-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x230 mm/kasan/report.c:480
 kasan_report+0x118/0x150 mm/kasan/report.c:593
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
 bch2_dirent_init_name+0x396/0x8b0 fs/bcachefs/dirent.c:273
 bch2_dirent_create_key+0x2a1/0x5f0 fs/bcachefs/dirent.c:315
 bch2_dirent_create+0xc5/0xc80 fs/bcachefs/dirent.c:358
 bch2_link_trans+0x39e/0x560 fs/bcachefs/namei.c:241
 __bch2_link+0x231/0x3f0 fs/bcachefs/fs.c:776
 bch2_link+0x197/0x220 fs/bcachefs/fs.c:805
 vfs_link+0x4ea/0x6e0 fs/namei.c:4863
 do_linkat+0x272/0x560 fs/namei.c:4933
 __do_sys_link fs/namei.c:4967 [inline]
 __se_sys_link fs/namei.c:4965 [inline]
 __x64_sys_link+0x82/0x90 fs/namei.c:4965
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5e63959b19
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee09b8bd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000056
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f5e63959b19
RDX: 00007f5e63959b19 RSI: 0000200000000240 RDI: 00002000000001c0
RBP: 00007f5e639d25f0 R08: 00005555839934c0 R09: 00005555839934c0
R10: 0000000000005a9b R11: 0000000000000246 R12: 00007ffee09b8c00
R13: 00007ffee09b8e28 R14: 431bde82d7b634db R15: 00007f5e639a203b
 </TASK>

Allocated by task 5839:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4340
 kmalloc_noprof include/linux/slab.h:909 [inline]
 __bch2_trans_kmalloc+0x396/0x9d0 fs/bcachefs/btree_iter.c:3242
 bch2_trans_kmalloc_ip fs/bcachefs/btree_iter.h:604 [inline]
 bch2_trans_kmalloc fs/bcachefs/btree_iter.h:616 [inline]
 bch2_dirent_create_key+0x113/0x5f0 fs/bcachefs/dirent.c:298
 bch2_dirent_create+0xc5/0xc80 fs/bcachefs/dirent.c:358
 bch2_link_trans+0x39e/0x560 fs/bcachefs/namei.c:241
 __bch2_link+0x231/0x3f0 fs/bcachefs/fs.c:776
 bch2_link+0x197/0x220 fs/bcachefs/fs.c:805
 vfs_link+0x4ea/0x6e0 fs/namei.c:4863
 do_linkat+0x272/0x560 fs/namei.c:4933
 __do_sys_link fs/namei.c:4967 [inline]
 __se_sys_link fs/namei.c:4965 [inline]
 __x64_sys_link+0x82/0x90 fs/namei.c:4965
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881496a3000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 65 bytes inside of
 allocated 2048-byte region [ffff8881496a3000, ffff8881496a3800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1496a0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff88801a442000 0000000000000000 dead000000000001
raw: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff88801a442000 0000000000000000 dead000000000001
head: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 057ff00000000003 ffffea000525a801 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 13597243606, free_ts 0
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
 __media_device_register+0x58/0x280 drivers/media/mc/mc-device.c:720
 vivid_create_devnodes+0x2037/0x2bf0 drivers/media/test-drivers/vivid/vivid-core.c:1749
 vivid_create_instance drivers/media/test-drivers/vivid/vivid-core.c:2042 [inline]
 vivid_probe+0x5035/0x7180 drivers/media/test-drivers/vivid/vivid-core.c:2095
 platform_probe+0x148/0x1d0 drivers/base/platform.c:1404
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x26a/0x9a0 drivers/base/dd.c:657
 __driver_probe_device+0x18c/0x2f0 drivers/base/dd.c:799
 driver_probe_device+0x4f/0x430 drivers/base/dd.c:829
 __driver_attach+0x452/0x700 drivers/base/dd.c:1215
 bus_for_each_dev+0x230/0x2b0 drivers/base/bus.c:370
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8881496a3700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881496a3780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8881496a3800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff8881496a3880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881496a3900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
