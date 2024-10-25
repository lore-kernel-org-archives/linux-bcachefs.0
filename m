Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A5718F2C3
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 06:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838913; cv=none; b=EtCQIuoedW4QlBKrLhAKd/bxXjrMKozHB34hRBvB7TouXCVkgzZ/6zWC6qHk1D8p88czXnAjlaw4I0eu3Nma9AudEusSTd3Bf3j2hslMI7YiM1MRjTOulCznvXk7agx7KKCv/rSqR6azR+ZD4QbHPLnj1lFaSdFbhSo36zEgpKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838913; c=relaxed/simple;
	bh=Jfv1H2pdoAk2W+LBXXbM7IbwiSfhZJ/Nzxj6rBONxjY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pgQ/ic0FUlqfNSmJ1WEfSz/UCURcJlBkayiB8YpWwW7McfrncxfejqacnSiVM5kYiGPlh++Fi0VL4Q/NQc+6i3E+qdo1z+3gHZOVB8HYEbVPCGPvvWaGCgG95NO9VScWfGFaNQWXAAEzgVQiJ8I/Juh8hFu3EseJa1gAoWykX1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ae0af926dso169591439f.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 23:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838910; x=1730443710;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GnGjB+MgRHTi4yQUaJs0ufPp7MWRWldyac6Zcq9oeJM=;
        b=mad2VODPDQ721ibhODrsFVtx2nDsHnqK95zBp0oaKmyLZysTHZR9l65cvB1KpFRLCP
         3EtD2U4Kmo521aOSt73uW11nVFBthD7GAg+gTiUGawjI79Ely9E33eh0OSaqarAn8sW8
         MQb2u+TDDGj7QklhNRIAX+BrRiBEhEnXD09CgAzur+W8RW8OVcq16EKd3oWks5brG8bw
         qjaNA1Fb4bt07IUsutyqKYB8lIvf5reBftQz9Bax6w1fGEAK1eWoU36XHa9tyFdLcmN3
         2Mu4Yb7Se2k+aONMdOCbGJTmWixXK/cOjvRGt6sKnrlv03kGsdiVABqrKx8zuBNGbCwS
         fUVA==
X-Forwarded-Encrypted: i=1; AJvYcCUa9YAOAhSGvSLJ2bu+UC/82uO8qKA9zJa0Nt2zfJ/Tv1f5KR+n7N+u1aIi6yk6EMTWZldpCW/Xml7RJ+cdWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDQWUGzwBWg+ez+EyKIGL6gAsvKNpeOji3r5G6xvDOJdihLBau
	Y/ZtBU9LUsNiTDb6AxMqnJ4cy2abWKA1CSjJ/h5NTy12O14TGJgo8wJLYdZJaxUvPPhEcIXkby7
	CFwkCdqSK73KS+tRRieOlbeLcinZTyymP8qwzdDTjoOhAmqzOIJcJMpw=
X-Google-Smtp-Source: AGHT+IE3igcQzVF7/dE/d1TatnlXTt+lNc8KNl7wQb9PYGvToesRtg2DbqbijHeTYRhLgxHKQc0ohPuGgIguGBEdZeGwwimgTjwZ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3428:b0:83a:a305:d9ee with SMTP id
 ca18e2360f4ac-83af61f3ca0mr945535939f.12.1729838910380; Thu, 24 Oct 2024
 23:48:30 -0700 (PDT)
Date: Thu, 24 Oct 2024 23:48:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671b3f3e.050a0220.2eb763.00d5.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bkey_cmp_packed
From: syzbot <syzbot+8a0109511de9d4b61217@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cb50a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=8a0109511de9d4b61217
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b54a5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=148c0c30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/daabab57e77d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8a0109511de9d4b61217@syzkaller.appspotmail.com

bcachefs (loop0): going read-write
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey_cmp.h:104!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5098 Comm: syz-executor272 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_bkey_cmp_packed_format_checked_inlined fs/bcachefs/bkey_cmp.h:103 [inline]
RIP: 0010:bch2_bkey_cmp_packed_inlined fs/bcachefs/bkey_cmp.h:116 [inline]
RIP: 0010:bch2_bkey_cmp_packed+0xc9c/0xcb0 fs/bcachefs/bkey.c:1037
Code: 8a 0c b5 07 e8 85 7d 83 fd 90 0f 0b e8 7d 7d 83 fd 90 0f 0b e8 75 7d 83 fd 90 0f 0b e8 6d 7d 83 fd 90 0f 0b e8 65 7d 83 fd 90 <0f> 0b e8 5d 7d 83 fd 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc9000af44f00 EFLAGS: 00010293
RAX: ffffffff84115a7b RBX: 1ffff920015e89e8 RCX: ffff88801f132440
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000001
RBP: ffffc9000af45090 R08: ffffffff8411531e R09: 0000000000000000
R10: ffffc9000af44fa0 R11: fffff520015e89f6 R12: 0000000000000001
R13: ffffffffffffffff R14: 0000000000000000 R15: ffffc9000af44fa0
FS:  00005555623d6380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c295070510 CR3: 000000003d786000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bkey_packed_successor fs/bcachefs/bkey.c:428 [inline]
 bch2_bkey_pack_pos_lossy+0xc94/0x1990 fs/bcachefs/bkey.c:537
 bch2_btree_node_iter_init+0x894/0x4280 fs/bcachefs/bset.c:1313
 __btree_path_level_init fs/bcachefs/btree_iter.c:615 [inline]
 bch2_btree_path_level_init+0x4d2/0x9f0 fs/bcachefs/btree_iter.c:635
 btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
 bch2_btree_path_traverse_one+0x10de/0x2940 fs/bcachefs/btree_iter.c:1170
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_slot+0x84f/0x2550 fs/bcachefs/btree_iter.c:2616
 bchfs_read+0x988/0x2be0 fs/bcachefs/fs-io-buffered.c:182
 bch2_readahead+0x1154/0x1930 fs/bcachefs/fs-io-buffered.c:277
 read_pages+0x17e/0x840 mm/readahead.c:160
 page_cache_ra_order+0xb00/0xdb0 mm/readahead.c:508
 page_cache_sync_readahead include/linux/pagemap.h:1394 [inline]
 filemap_get_pages+0x621/0x2540 mm/filemap.c:2547
 filemap_read+0x454/0xf90 mm/filemap.c:2645
 bch2_read_iter+0x1122/0x1470 fs/bcachefs/fs-io-direct.c:208
 __kernel_read+0x513/0x9d0 fs/read_write.c:527
 integrity_kernel_read+0xb0/0x100 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
 ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
 ima_calc_file_hash+0xae6/0x1b30 security/integrity/ima/ima_crypto.c:568
 ima_collect_measurement+0x520/0xb10 security/integrity/ima/ima_api.c:293
 process_measurement+0x1351/0x1fb0 security/integrity/ima/ima_main.c:372
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0xb9/0x280 security/security.c:3129
 do_open fs/namei.c:3776 [inline]
 path_openat+0x2ccd/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f103ee0b9b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee6340028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007ffee6340208 RCX: 00007f103ee0b9b9
RDX: 0000000000000042 RSI: 0000000020000100 RDI: 00000000ffffff9c
RBP: 00007f103ee84610 R08: 0000000000005959 R09: 0000000000000000
R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffee63401f8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_bkey_cmp_packed_format_checked_inlined fs/bcachefs/bkey_cmp.h:103 [inline]
RIP: 0010:bch2_bkey_cmp_packed_inlined fs/bcachefs/bkey_cmp.h:116 [inline]
RIP: 0010:bch2_bkey_cmp_packed+0xc9c/0xcb0 fs/bcachefs/bkey.c:1037
Code: 8a 0c b5 07 e8 85 7d 83 fd 90 0f 0b e8 7d 7d 83 fd 90 0f 0b e8 75 7d 83 fd 90 0f 0b e8 6d 7d 83 fd 90 0f 0b e8 65 7d 83 fd 90 <0f> 0b e8 5d 7d 83 fd 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc9000af44f00 EFLAGS: 00010293
RAX: ffffffff84115a7b RBX: 1ffff920015e89e8 RCX: ffff88801f132440
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000001
RBP: ffffc9000af45090 R08: ffffffff8411531e R09: 0000000000000000
R10: ffffc9000af44fa0 R11: fffff520015e89f6 R12: 0000000000000001
R13: ffffffffffffffff R14: 0000000000000000 R15: ffffc9000af44fa0
FS:  00005555623d6380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd9c51ad88 CR3: 000000003d786000 CR4: 0000000000352ef0
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
