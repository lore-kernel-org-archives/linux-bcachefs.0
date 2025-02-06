Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F753235363
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738861286; cv=none; b=Y9SymgwI0WyAGZ7tYJ0SKB1sExH8HtuSjBObdJT3ArriC3xCydWfUNks3pmCWQd6EBYHPRmP2K2OdAOrCgMRdcFhWQ/SpTVOvvZlq8r64bYLnVWLJXsBIkJgF+oLOscqokZfk4LSHEs3lWW9fh9w3lN9uyPRgdI0/6k551r4M9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738861286; c=relaxed/simple;
	bh=IxCy0Bv35znIXGsOnISSe0MUVj3bfa9aKhZ0ISWI4LY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E78vnURk52GH1TMnQjTgk3R9t1Crbp7i2j1oyvYH1lfg9rP76Yj0sPqlRGwiaC2FCgW2mXRFfGssW5BR5gOuNv9ZJwztm3B7sTA1R9y0cDvVJdZKB1xXyJnoOEHDzFA54tHGnBATPH3YxNhw2l3JNTs/aNqeLHkj6u/TInflgPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d0225c44e8so18282855ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Feb 2025 09:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738861283; x=1739466083;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R4LQTwPwR8oUTAtQpcOsHBcS9kWbTsQjfuYltYUwGq0=;
        b=UucEKsiZEyfst9WbaNesXIVhDwUppgqs/PVkU1MDOLMr7vOvE3UrTPDrlbXHcG89DA
         zrHnMI+52IxvzWLUxuxGf4yFFHYZ9s3Fo2L3Oad2ALIeqqBrbn7HrZ1NbQfnRv6yOgAy
         Mcjt/sM/vPY+rU0CnE+jDT4McMtdfHVD9U56kb2rM5dKzpD2DV+Dqmh4EA91fAgZUzHM
         ARtvUa70NIY7fNyYvkFvzKmNQ4r+9gtBhgMYluz9m2vbBgxVv0xJyv+m14F3ElGTDbd2
         N24RMUYhHlNAhALJpiKHSlJ67otFBK5dyJomVTBbiVUHvY550HsiBe6gst0pdo8q7twH
         yISw==
X-Forwarded-Encrypted: i=1; AJvYcCVn/ig/H9R1uz5RZbUOAODlhRDpG04MaUlvPk4VUGplV7tdzmKf/ENJhZAPoYC4HiQp4QfAFqH6x3JB1KvEFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOGG8SpfiTHyADtWdL5Q/oQADyB+9srtBWbF+49bPIxzqoWcZV
	HkZnNnr5rV3Uzn8Mp/wWZz0C270Zec+A8j/wAqRSit3MjcMBlesLZNwlXomGLYn9Yve66fyU4vx
	l+yliJ3gY2fb8vTRkIXlSMrBbZhGT+CIUnegp2COHvYR+9K7j6QUkf4A=
X-Google-Smtp-Source: AGHT+IELEzyMZ55l3RWra1VCkQY83te5PA6Tnfor92oXce0RWPF/nDwZuEvOKqKVIcaGXRUgdbOhrAACmd382G2Wv9wF1ENb9bY3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a69:b0:3d0:24c0:bd45 with SMTP id
 e9e14a558f8ab-3d04f97ba77mr67602455ab.20.1738861283610; Thu, 06 Feb 2025
 09:01:23 -0800 (PST)
Date: Thu, 06 Feb 2025 09:01:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a4eae3.050a0220.65602.0001.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] KASAN: slab-use-after-free Read in list_lru_del
From: syzbot <syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    92514ef226f5 Merge tag 'for-6.14-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=126aa4a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=6663075ddb9be85fa6e5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14926df8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-92514ef2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c4d8b91f8769/vmlinux-92514ef2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c24ec4365966/bzImage-92514ef2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/efb05b29bf18/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com

 slab radix_tree_node start ffff8880411d9600 pointer offset 24 size 576
list_del corruption. next->prev should be ffff88803f847358, but was 0000000008000105. (next=ffff8880411d9618)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:67!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5628 Comm: modprobe Not tainted 6.14.0-rc1-syzkaller-00034-g92514ef226f5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x18c/0x190 lib/list_debug.c:65
Code: ba 56 15 fd 42 80 3c 2b 00 74 08 4c 89 e7 e8 7b 02 37 fd 49 8b 56 08 48 c7 c7 20 8f 60 8c 4c 89 fe 4c 89 f1 e8 65 10 38 fc 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f
RSP: 0018:ffffc9000cdced10 EFLAGS: 00010046
RAX: 000000000000006d RBX: 1ffff1100823b2c4 RCX: a96f20814868f300
RDX: 0000000000000000 RSI: 0000000080000002 RDI: 0000000000000000
RBP: ffff888032fbde80 R08: ffffffff819f146c R09: fffffbfff1cfa588
R10: dffffc0000000000 R11: fffffbfff1cfa588 R12: ffff8880411d9620
R13: dffffc0000000000 R14: ffff8880411d9618 R15: ffff88803f847358
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff0ee1cb270 CR3: 0000000000712000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del_init include/linux/list.h:287 [inline]
 list_lru_del+0x9a/0x1f0 mm/list_lru.c:206
 list_lru_del_obj+0x17b/0x250 mm/list_lru.c:223
 workingset_update_node+0x174/0x230 mm/workingset.c:636
 xas_update lib/xarray.c:356 [inline]
 update_node lib/xarray.c:764 [inline]
 xas_store+0xb89/0x1870 lib/xarray.c:851
 __filemap_add_folio+0xab1/0x1320 mm/filemap.c:925
 filemap_add_folio+0x155/0x380 mm/filemap.c:981
 __filemap_get_folio+0x52b/0xae0 mm/filemap.c:1980
 grow_dev_folio fs/buffer.c:1039 [inline]
 grow_buffers fs/buffer.c:1105 [inline]
 __getblk_slow fs/buffer.c:1131 [inline]
 bdev_getblk+0x1d4/0x670 fs/buffer.c:1431
 getblk_unmovable include/linux/buffer_head.h:369 [inline]
 ext4_getblk+0x31b/0x880 fs/ext4/inode.c:864
 ext4_bread_batch+0x63/0x4e0 fs/ext4/inode.c:933
 __ext4_find_entry+0xfab/0x1eb0 fs/ext4/namei.c:1627
 ext4_lookup_entry fs/ext4/namei.c:1729 [inline]
 ext4_lookup+0x15f/0x750 fs/ext4/namei.c:1797
 __lookup_slow+0x296/0x400 fs/namei.c:1793
 lookup_slow+0x53/0x70 fs/namei.c:1810
 walk_component fs/namei.c:2114 [inline]
 link_path_walk+0x99b/0xea0 fs/namei.c:2479
 path_openat+0x266/0x3590 fs/namei.c:3985
 do_filp_open+0x27f/0x4e0 fs/namei.c:4016
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1427
 do_sys_open fs/open.c:1442 [inline]
 __do_sys_openat fs/open.c:1458 [inline]
 __se_sys_openat fs/open.c:1453 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1453
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff0ee472a46
Code: 10 00 00 00 44 8b 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 48 89 44 24 c8 44 89 c2 4c 89 ce bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 76 0c f7 d8 89 05 0a 48 01 00 48 83 c8 ff c3 31
RSP: 002b:00007ffdd50a1c28 EFLAGS: 00000287 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007ffdd50a1e88 RCX: 00007ff0ee472a46
RDX: 0000000000080000 RSI: 00007ffdd50a1ca0 RDI: 00000000ffffff9c
RBP: 00007ffdd50a1c90 R08: 0000000000080000 R09: 00007ffdd50a1ca0
R10: 0000000000000000 R11: 0000000000000287 R12: 00007ffdd50a1ca0
R13: 0000000000000000 R14: 00007ffdd50a1e6f R15: 00000000ffffffff
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x18c/0x190 lib/list_debug.c:65
Code: ba 56 15 fd 42 80 3c 2b 00 74 08 4c 89 e7 e8 7b 02 37 fd 49 8b 56 08 48 c7 c7 20 8f 60 8c 4c 89 fe 4c 89 f1 e8 65 10 38 fc 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f
RSP: 0018:ffffc9000cdced10 EFLAGS: 00010046
RAX: 000000000000006d RBX: 1ffff1100823b2c4 RCX: a96f20814868f300
RDX: 0000000000000000 RSI: 0000000080000002 RDI: 0000000000000000
RBP: ffff888032fbde80 R08: ffffffff819f146c R09: fffffbfff1cfa588
R10: dffffc0000000000 R11: fffffbfff1cfa588 R12: ffff8880411d9620
R13: dffffc0000000000 R14: ffff8880411d9618 R15: ffff88803f847358
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff0ee1cb270 CR3: 0000000000712000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
