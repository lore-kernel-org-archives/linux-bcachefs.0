Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E389EAE7
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759175141; cv=none; b=QYKrWSwXpk+T4vLZZ/1I8xtkqrbfSAWQqQitDc/AO5iy66uUsmsbndsf9dbl6R/sapu6FfkMF03PvMaWy173kjQq5V1MCxv5nv9OhhKXoYFhZdfZ9jVJj5r3GwIGu1BecnPW45O7tmTlwr8oCSLU9i35iRDh/kaTUwm6YjyxPG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759175141; c=relaxed/simple;
	bh=HzaBOZ90cpiDM+DUjJS/09BdAkKNP2hxCgECisZt8ls=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Dp1pctrEq/XeUtOUflqXfnQdA9PfEEDV5gY1hrSgGsHor14No4ZWyhAlPg1i4/8UBbQa9V0zQMmh5TbEg5CX3Soo1UE1CThYTk58SWMcpw2YK7NAn6sbW5W+b1aNT6djN6gj9V8Kv2O0/uVbKEypW5piL7RbntEu79SWccaSIWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-8875a8663d0so558750539f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 12:45:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759175139; x=1759779939;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W5ojLU+xcbKkFknjCNg7RCvS/KtwJGhrBeAlBDPqvgM=;
        b=XxTYXjEsXa7lNc+q8uy/lLwxlD9af2+HNn1/9qREsd09N5vjCWZHHquInZcWZGYYLa
         PzZviI58VOtxstqe2uWatEm/NyBt14aDf7/xFSKuXzBWSXUtz4/UdIqOiE7BkFMcZSnj
         ywbq73MR0uGe/W3sBw/JNNNxlv9j9v6ToAW89ppfenaa92l8Ti27LULNELaHcvnnCg3t
         WnJiXMqmUB2HYxB8MLiIk51CF55m7wfrgh/k3xbryigd0/KNKme2rp6yI1Xr0eFExFzd
         iLURIdJKLlntbr94rpW0O+LEwLUP3J0qYP0TvrKpt3r9YzAQ+iTKryWY8hzsUsh5LLUP
         BgjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvj70c2OEn8bKW2O1w3fIedbxHD0UQfgAf9g/VzRcV2/m9bu3TKRhhO09JH1mUT7mUCfGcdt6kmMMin4Ti0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy659tjNmeEpACAWgUM4rL1wMc/0Su5Sz+92Ku5xNdAk6Zom1pU
	RtiE/5wjOgd2Sb6Q4ip+3vToBZ3iiXJ37C9pEwDxtkB2PlhQCYJybruI9I+BCtg67zO3FrB2vyK
	e6Q0qiorc9SfBiMCKVNpkW93HcA+d1plMnkj5Tt+m53uZ9KYM6EWTuLFxvG0=
X-Google-Smtp-Source: AGHT+IEl8GTOEqMHZ+cPkJkFc4CKCwrgPjgqYfJywb9Xq2KIJfgwAdFEd1M09BEgWOwZhfYl7NPrV3vpIQ+spJxrdQBlM98HKWTo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3e8c:b0:425:799b:e05a with SMTP id
 e9e14a558f8ab-4259565519cmr277061735ab.27.1759175138691; Mon, 29 Sep 2025
 12:45:38 -0700 (PDT)
Date: Mon, 29 Sep 2025 12:45:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dae1e2.050a0220.1696c6.001e.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_extent_ptr_to_text
From: syzbot <syzbot+564efbe31172fe908429@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f9736633f8c Merge tag 'trace-v6.17-rc7' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14e7bf12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=564efbe31172fe908429
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d48334580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12e7bf12580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/71acd8344a66/disk-8f973663.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6bd6a8e43904/vmlinux-8f973663.xz
kernel image: https://storage.googleapis.com/syzbot-assets/55867795337c/bzImage-8f973663.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5d5f27e3c00d/mount_0.gz

The issue was bisected to:

commit d97de0d017cde0d442c3d144b4f969f43064cc0f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Aug 13 01:31:25 2024 +0000

    bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c37f12580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13c37f12580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c37f12580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")

  allowing incompatible features above 0.0: (unknown version)
  features: lz4,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
bcachefs (loop0): Using encoding defined by superblock: utf8-12.1.0
bcachefs (loop0): invalid bkey in superblock btree=extents level=1: u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 16 min_key POS_MIN durability: 1 ptr: 0:27:0 gen 0
  pointer before first bucket (27 < 1024), deleting
==================================================================
BUG: KASAN: use-after-free in bucket_gen_get_rcu fs/bcachefs/buckets.h:82 [inline]
BUG: KASAN: use-after-free in dev_ptr_stale_rcu fs/bcachefs/buckets.h:147 [inline]
BUG: KASAN: use-after-free in bch2_extent_ptr_to_text+0x883/0x890 fs/bcachefs/extents.c:1247
Read of size 1 at addr ffff8880992caf4e by task syz.0.17/6104

CPU: 0 UID: 0 PID: 6104 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 bucket_gen_get_rcu fs/bcachefs/buckets.h:82 [inline]
 dev_ptr_stale_rcu fs/bcachefs/buckets.h:147 [inline]
 bch2_extent_ptr_to_text+0x883/0x890 fs/bcachefs/extents.c:1247
 bch2_bkey_ptrs_to_text+0xd75/0x1310 fs/bcachefs/extents.c:1335
 __bch2_bkey_fsck_err+0x3f7/0x540 fs/bcachefs/error.c:691
 extent_ptr_validate fs/bcachefs/extents.c:-1 [inline]
 bch2_bkey_ptrs_validate+0x1d56/0x24c0 fs/bcachefs/extents.c:1442
 bch2_btree_ptr_v2_validate+0x406/0x8d0 fs/bcachefs/extents.c:345
 bch2_bkey_val_validate fs/bcachefs/bkey_methods.c:143 [inline]
 bch2_bkey_validate+0x291/0x4e0 fs/bcachefs/bkey_methods.c:251
 journal_validate_key+0x631/0xe50 fs/bcachefs/journal_io.c:388
 journal_entry_btree_root_validate+0x22a/0x620 fs/bcachefs/journal_io.c:480
 bch2_journal_entry_validate+0x15b/0x220 fs/bcachefs/journal_io.c:874
 bch2_sb_clean_validate_late+0x16c/0x330 fs/bcachefs/sb-clean.c:44
 bch2_read_superblock_clean+0xd9/0x260 fs/bcachefs/sb-clean.c:172
 bch2_fs_recovery+0x158/0x3a50 fs/bcachefs/recovery.c:738
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa145eb066a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa145515e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fa145515ef0 RCX: 00007fa145eb066a
RDX: 0000200000005b40 RSI: 0000200000000000 RDI: 00007fa145515eb0
RBP: 0000200000005b40 R08: 00007fa145515ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000000
R13: 00007fa145515eb0 R14: 000000000000594b R15: 0000200000000080
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x992ca
flags: 0x80000000000000(node=0|zone=1)
raw: 0080000000000000 ffffea000264b288 ffffea000264b288 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffff8880992cae00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880992cae80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880992caf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                              ^
 ffff8880992caf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880992cb000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
