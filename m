Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF34136347
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Sep 2025 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757660792; cv=none; b=Sab9djJv3gKF1Ce5lkXZAIe+/tWAxW048JvpYtcM6Fej29uhsWFAIjI77zvxEqOS+eEY4LxMPbvS8e36Vjcb2XzaO2AoYgXBUGO34GHTYR6FVwzTbqC9/15iH1n5/GX522dXVBIh0AhuUYvPk8Aeno0UF3fV10FGsiyMktkY+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757660792; c=relaxed/simple;
	bh=Y4aiKmvWkx6G6By0TM3doDi8LDZzC+XcCJeBWIo4Jo0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uawEoZm41Vw3ErTu/N/AJBuceCEXwMB8PVNoW0y8xIa112MafMkjR4Tpm8KTjVa1OJS/WSbM52nRFKqluYqb30v2bTExawH2Fd6jiVhvCGgUYywdPop0N4qFzx9zVLXuIagoLwEai6CGAtf4pkYzx6RPWjoVy64mgNbSh9dLGrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88a7b9c831aso273049239f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 12 Sep 2025 00:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757660790; x=1758265590;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZ7NEZlOFij2ci+qf76F0pjCJoN+xDm7sESWeyA4yO4=;
        b=l/yKNgJU67mBZudLEyFQGv+nUo1m+ZEQnuvgtJeUaHqIJdRPZbUgl8+CBkR1lD5/G7
         duco7m5Dtq1Su615+CMvoDUjtFI3rp8T+Q199+XTA0oKiPO2JJKH6S5+V/eib7S0tUNe
         712evHKbkcyrBy5KrTbL2U17+lgL1Cfdr66+jcE5DVMTORmwhLQZ5kfA6rJTgxAqjnm7
         3T+LMBw2Rdm/FeNaSnkQc2SOwKC0MAk4/zeEX4ZAQgb/NQnlFXVCIUxQsZXRO7Qx95Fu
         0nrUk17SKrU8cUbHVTFn9f4nn+7LUm7Kgibf+5jZ47DOFNwnb35gK+K0PO9lA9zQGFWm
         ameQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzsJBMYEb3JAwciZSNZ4paMA2N/x0xCl9HGWzQ+Cm7agg5mAq1BGx/dOC7q8KaS6e88sUxpRtP1T1NpzUwlQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKgIhtHfrCxX9XiGIvY/+meK26j2D4Jrw2AJkFrZ5jq99/soCl
	rSsZNS3wEXBMKm/5Ka8x3zpqutDchYoII4iUrSnN6YFxTOyqQ1f46nKBdakVAwteVflApcqeecK
	EIxb0SUAAWQ3LCPfe6o893uW03brtz4ql+ofNv+BlkuUKrslUiFjoRwmu81s=
X-Google-Smtp-Source: AGHT+IEIeJcB9JZNOK9zlUZv8PEScGn1I+fmElu+psW/Oq/4czoskpL+2NFF0w+o3Dm6EhRrsyv3rYU4tggTZcXvyhWcUHS01SCX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c8:b0:416:d8ba:8aff with SMTP id
 e9e14a558f8ab-4209e64b5f4mr33903055ab.11.1757660789887; Fri, 12 Sep 2025
 00:06:29 -0700 (PDT)
Date: Fri, 12 Sep 2025 00:06:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c3c675.050a0220.2ff435.0354.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_trans_update_by_path (2)
From: syzbot <syzbot+e7b9dfa79acffd3aabdd@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    02ffd6f89c50 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14789642580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=e7b9dfa79acffd3aabdd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-02ffd6f8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f0aa130ecc52/vmlinux-02ffd6f8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3649569ef2fb/bzImage-02ffd6f8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e7b9dfa79acffd3aabdd@syzkaller.appspotmail.com

 done
bcachefs (loop0): check_alloc_info...
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 25-26, fixing
bcachefs (loop0): bucket incorrectly unset in need_discard btree
  u64s 13 type alloc_v4 0:29:0 len 0 ver 0: 
    gen 0 oldest_gen 0 data_type need_discard
    journal_seq_nonempty 1
    journal_seq_empty    0
    need_discard         1
    need_inc_gen         1
    dirty_sectors        0
    stripe_sectors       0
    cached_sectors       0
    stripe               0
    stripe_redundancy    0
    io_time[READ]        1
    io_time[WRITE]       1
    fragmentation     0
    bp_start          8
  , fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 30-31, fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 33-34, fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 37-38, fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 42-47, fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 48-50, fixing
bcachefs (loop0): hole in alloc btree missing in freespace btree
  device 0 buckets 51-120, fixing
 done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
bcachefs (loop0): scanning for missing backpointers in 5/128 buckets
 done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
bcachefs (loop0): requested incompat feature 1.16: reflink_p_may_update_opts currently not enabled, allowed up to 1.16: reflink_p_may_update_opts
  set version_upgrade=incompat to enable
bcachefs (loop0): (disconnected) offset 0: write error: __bch2_write(): insufficient_devices
bcachefs (loop0): pointer to missing indirect extent in (disconnected) offset 0: -4096
  u64s 7 type reflink_p 4104:8:U32_MAX len 8 ver 0: idx 0 front_pad 0 back_pad 0
  missing reflink btree range 0-8, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_update.c:410!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5358 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_trans_update_by_path+0x1f2b/0x1f30 fs/bcachefs/btree_update.c:410
Code: fd 90 0f 0b e8 46 86 8f fd 90 0f 0b e8 3e 86 8f fd 90 0f 0b e8 36 86 8f fd 90 0f 0b e8 2e 86 8f fd 90 0f 0b e8 26 86 8f fd 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc9000d3c66c8 EFLAGS: 00010283
RAX: ffffffff8430488a RBX: 0000000000004000 RCX: 0000000000100000
RDX: ffffc9000e162000 RSI: 00000000000554a7 RDI: 00000000000554a8
RBP: ffff888055bfa4d8 R08: ffff88800032c880 R09: 0000000000000002
R10: 0000000000000006 R11: 0000000000000002 R12: 0000000000000000
R13: 1ffff1100ab7f49b R14: dffffc0000000000 R15: ffff888055bfa4d8
FS:  00007f461eb3d6c0(0000) GS:ffff88808d00a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f461a1f4fc8 CR3: 0000000043e03000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_trans_update_ip+0x9a6/0x1db0 fs/bcachefs/btree_update.c:531
 bch2_trans_update fs/bcachefs/btree_update.h:123 [inline]
 bch2_btree_insert_nonextent fs/bcachefs/btree_update.c:625 [inline]
 bch2_trans_update_extent fs/bcachefs/btree_update.c:321 [inline]
 bch2_trans_update_ip+0x17ef/0x1db0 fs/bcachefs/btree_update.c:503
 bch2_trans_update fs/bcachefs/btree_update.h:123 [inline]
 bch2_btree_insert_trans+0x1cd/0x330 fs/bcachefs/btree_update.c:637
 bch2_indirect_extent_missing_error+0xd2d/0x11b0 fs/bcachefs/reflink.c:239
 bch2_lookup_indirect_extent+0x38d/0x5c0 fs/bcachefs/reflink.c:279
 trans_trigger_reflink_p_segment fs/bcachefs/reflink.c:308 [inline]
 __trigger_reflink_p+0x395/0x19c0 fs/bcachefs/reflink.c:419
 bch2_trigger_reflink_p+0x1ea/0x3a0 fs/bcachefs/reflink.c:454
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:-1 [inline]
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:554 [inline]
 __bch2_trans_commit+0xa81/0x8870 fs/bcachefs/btree_trans_commit.c:1023
 bch2_trans_commit fs/bcachefs/btree_update.h:241 [inline]
 bch2_inode_delete_keys+0x525/0x700 fs/bcachefs/inode.c:1115
 bch2_inode_rm+0x282/0x820 fs/bcachefs/inode.c:1146
 bch2_evict_inode+0x220/0x520 fs/bcachefs/fs.c:2182
 evict+0x504/0x9c0 fs/inode.c:810
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 dput+0x19f/0x2b0 fs/dcache.c:911
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f461dd8eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f461eb3d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: fffffffffffffffb RBX: 00007f461dfd5fa0 RCX: 00007f461dd8eba9
RDX: 0000000000141042 RSI: 0000200000000040 RDI: ffffffffffffff9c
RBP: 00007f461de11e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f461dfd6038 R14: 00007f461dfd5fa0 R15: 00007fff274d40e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_trans_update_by_path+0x1f2b/0x1f30 fs/bcachefs/btree_update.c:410
Code: fd 90 0f 0b e8 46 86 8f fd 90 0f 0b e8 3e 86 8f fd 90 0f 0b e8 36 86 8f fd 90 0f 0b e8 2e 86 8f fd 90 0f 0b e8 26 86 8f fd 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc9000d3c66c8 EFLAGS: 00010283
RAX: ffffffff8430488a RBX: 0000000000004000 RCX: 0000000000100000
RDX: ffffc9000e162000 RSI: 00000000000554a7 RDI: 00000000000554a8
RBP: ffff888055bfa4d8 R08: ffff88800032c880 R09: 0000000000000002
R10: 0000000000000006 R11: 0000000000000002 R12: 0000000000000000
R13: 1ffff1100ab7f49b R14: dffffc0000000000 R15: ffff888055bfa4d8
FS:  00007f461eb3d6c0(0000) GS:ffff88808d00a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005576da418660 CR3: 0000000043e03000 CR4: 0000000000352ef0


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
