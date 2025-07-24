Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C9E2AF03
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Jul 2025 01:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753319555; cv=none; b=J55X+SDcjXIWi/mO0cWVN+zYiXykKmqjQADEd3mkR9G2P8yZCkJobrFfvFANL0nhRN4YIwBftzT7KcDUGLIaQv/36f8sBCsD0kR8uxchuh8kKY5zWFksM1ZKVUWfLeOlBVX95yc8KgEFIz9TcDaAUGAxOHDqhXe5JYdb0SpsbN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753319555; c=relaxed/simple;
	bh=lqOlnOVnMCBJcnU10ptd3smm0+bxv6ZzWJ6vVJuAWXo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lR2l19Z1qd25z3ZruhHZsXcgkZb4+k61NdiowtMBmMsoJA3vm2a5oB8hEuk+x3DIkJVap3AEkGOO4nbmiP0BXyfxuehuQSBpgL8ERHhYjGKrBdnTqghAo9GibE8TsA8Xw2Dl0fcv8MV6a9CjLsMiD0pQnx0Bv0WRfIYT6PbKj5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-86a5def8869so112954539f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Jul 2025 18:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753319553; x=1753924353;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOYCWpFQDKIXlKlj8G4XdmS8Zk1cKrnwk/l3ieNu818=;
        b=saEhb8myzSrFLsqebnqPDikxI7w0c8XktcDP0iEEwcG8y4diy90Z/McdUN6lWqZWve
         DeSWj1J2Iy+yPEkcULv+G63XEzliPNk3iQAzelYSSNJVccwSi2NUf8aIOYgDunuqRWtg
         CFlvPs/8VB4DBIPBkKE+cFoweh2Ii4sZ3SWhonyj/aJ1Nf823jhy7+2mppnnUttwwWyi
         RN5LWXGPzJj1NZHtdDVcgnNw8YpHD8H/2+4x1BPAJTZLxjKlSD2LCc8elFrkWKetsAlc
         CMr7kLR3j9T6HW4QEejkGfVnMSmL6w130T65xB6eO1Sx9GneDWKN603wu0cpNI2FXKsb
         qysA==
X-Forwarded-Encrypted: i=1; AJvYcCVthIyi+l85imCufQ/X+bsMIB2I1r5ldsf4Srkz7ZJKPZ9VSGuXYBg0gVY0YZzbT5b0FCE8WkwcGBxCdtaG8w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzip/PPGNegtxYEtj3z2hSeA3zylj00I69p97v8UqpFf+TarbQK
	6nz/RQsvU8DAEhQJDEkdPRI+xrzVhmwJKkkpyYxJF2QvziMepFRtuHOKYM4+xOPh+v10ENXv16z
	L39UJU7fkCWXffga2dUxsh5lNYqE5KfQpkm+7jbGY+brt7+R7yV6DmSsfrbY=
X-Google-Smtp-Source: AGHT+IFPlX5kiopZKNruFJ6w1xYRY4KXSxoUJThUn02QxOBgTd/FDJ5jd1y+kXQbgX6OTn4TYIv8gppRxCVy+HViAUS6sE9mz1Ys
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6b10:b0:87c:541c:44e with SMTP id
 ca18e2360f4ac-87c6505143emr1072599939f.11.1753319552766; Wed, 23 Jul 2025
 18:12:32 -0700 (PDT)
Date: Wed, 23 Jul 2025 18:12:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68818880.a00a0220.2f88df.0007.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __build_ro_aux_tree (2)
From: syzbot <syzbot+7e787e7154eb952a259b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bf61759db409 Merge tag 'sched_ext-for-6.16-rc6-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ffc38c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f62a2ef17395702a
dashboard link: https://syzkaller.appspot.com/bug?extid=7e787e7154eb952a259b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-bf61759d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa0ef5d6c0be/vmlinux-bf61759d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc3c9e6a8165/bzImage-bf61759d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7e787e7154eb952a259b@syzkaller.appspotmail.com

 done
bcachefs (loop0): check_alloc_to_lru_refs...
bcachefs (loop0): missing fragmentation lru entry
  u64s 13 type alloc_v4 0:34:0 len 0 ver 0: 
    gen 0 oldest_gen 0 data_type user
    journal_seq_nonempty 0
    journal_seq_empty    0
    need_discard         0
    need_inc_gen         0
    dirty_sectors        16
    stripe_sectors       0
    cached_sectors       0
    stripe               0
    stripe_redundancy    0
    io_time[READ]        0
    io_time[WRITE]       0
    fragmentation     134217728
    bp_start          8
  , fixing
 done
bcachefs (loop0): check_snapshot_trees... done
bcachefs (loop0): check_snapshots... done
bcachefs (loop0): check_subvols...
bcachefs (loop0): running recovery pass reconstruct_snapshots (21), currently at check_subvols (24) - rewinding
bcachefs (loop0): bch2_check_subvols(): error restart_recovery
bcachefs (loop0): reconstruct_snapshots...
bcachefs (loop0): snapshot node 4294967295 from tree 4294967295 missing, recreating
 done
bcachefs (loop0): check_snapshot_trees... done
bcachefs (loop0): check_snapshots... done
bcachefs (loop0): check_subvols...
bcachefs (loop0): subvolume 1 is not set as snapshot but is not master subvolume, fixing
 done
bcachefs (loop0): check_subvol_children... done
bcachefs (loop0): delete_dead_snapshots... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): check_extents... done
bcachefs (loop0): check_indirect_extents... done
bcachefs (loop0): check_dirents... done
bcachefs (loop0): check_xattrs... done
bcachefs (loop0): check_root... done
bcachefs (loop0): check_unreachable_inodes... done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure... done
bcachefs (loop0): check_nlinks... done
bcachefs (loop0): check_rebalance_work... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bset.c:652!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5336 Comm: syz.0.0 Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:make_bfloat fs/bcachefs/bset.c:652 [inline]
RIP: 0010:__build_ro_aux_tree+0x17e1/0x1800 fs/bcachefs/bset.c:750
Code: 21 a4 fd be 01 00 00 00 48 c7 c7 20 25 76 8e 48 89 da e8 d2 43 db 00 e9 18 f4 ff ff e8 28 21 a4 fd 90 0f 0b e8 20 21 a4 fd 90 <0f> 0b e8 18 21 a4 fd 90 0f 0b e8 10 21 a4 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc9000d356c60 EFLAGS: 00010246
RAX: ffffffff841c10b0 RBX: dffffc0000000000 RCX: 0000000000100000
RDX: ffffc9000e322000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d356e30 R08: ffff88800019c880 R09: 0000000000000002
R10: 000000000000ffff R11: 0000000000000002 R12: ffff888056620191
R13: 0000000000000130 R14: 0000000000000001 R15: 0000000000000090
FS:  00007f809202d6c0(0000) GS:ffff88808d218000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bd826af168 CR3: 0000000044198000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_bset_build_aux_tree+0x3f5/0x570 fs/bcachefs/bset.c:787
 bch2_btree_build_aux_trees fs/bcachefs/btree_io.c:451 [inline]
 bch2_btree_post_write_cleanup+0x630/0xad0 fs/bcachefs/btree_io.c:2628
 bch2_btree_node_write_trans+0x17b/0x760 fs/bcachefs/btree_io.c:2676
 btree_node_write_if_need fs/bcachefs/btree_io.h:167 [inline]
 __btree_node_flush+0x323/0x430 fs/bcachefs/btree_trans_commit.c:255
 bch2_btree_node_flush0+0x27/0x40 fs/bcachefs/btree_trans_commit.c:264
 journal_flush_pins+0x8e3/0xe90 fs/bcachefs/journal_reclaim.c:604
 journal_flush_pins_or_still_flushing fs/bcachefs/journal_reclaim.c:871 [inline]
 journal_flush_done+0x112/0x810 fs/bcachefs/journal_reclaim.c:889
 bch2_journal_flush_pins+0x155/0x250 fs/bcachefs/journal_reclaim.c:921
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_fs_recovery+0x2775/0x3a50 fs/bcachefs/recovery.c:1036
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f809119014a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f809202ce68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f809202cef0 RCX: 00007f809119014a
RDX: 000020000000f640 RSI: 000020000000f680 RDI: 00007f809202ceb0
RBP: 000020000000f640 R08: 00007f809202cef0 R09: 0000000000000180
R10: 0000000000000180 R11: 0000000000000246 R12: 000020000000f680
R13: 00007f809202ceb0 R14: 000000000000f63a R15: 0000200000000580
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:make_bfloat fs/bcachefs/bset.c:652 [inline]
RIP: 0010:__build_ro_aux_tree+0x17e1/0x1800 fs/bcachefs/bset.c:750
Code: 21 a4 fd be 01 00 00 00 48 c7 c7 20 25 76 8e 48 89 da e8 d2 43 db 00 e9 18 f4 ff ff e8 28 21 a4 fd 90 0f 0b e8 20 21 a4 fd 90 <0f> 0b e8 18 21 a4 fd 90 0f 0b e8 10 21 a4 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc9000d356c60 EFLAGS: 00010246
RAX: ffffffff841c10b0 RBX: dffffc0000000000 RCX: 0000000000100000
RDX: ffffc9000e322000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000d356e30 R08: ffff88800019c880 R09: 0000000000000002
R10: 000000000000ffff R11: 0000000000000002 R12: ffff888056620191
R13: 0000000000000130 R14: 0000000000000001 R15: 0000000000000090
FS:  00007f809202d6c0(0000) GS:ffff88808d218000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bd826af168 CR3: 0000000044198000 CR4: 0000000000352ef0


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
