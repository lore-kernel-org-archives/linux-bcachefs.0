Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364AB2AF19
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 10:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739357249; cv=none; b=pfJKDHIzwUt/4g/uGxYml0ufJqDerXp+XW3oLBfl/2JgqflP3F483E+9YccwfhrCszPrv1Sjd0yAgGxecNhwp5ngFSEhoFU4CuC6uaUWj0OjJFhP3WKUHH7y6V0Q3Nbv0dRDNX3mUQUkm6FEq8Kbf9sbWWzR9Ny9WkLL0MHbxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739357249; c=relaxed/simple;
	bh=lktNSrHADcrlJcpv1LVG3T/72KlRRffskbQB21l2VR4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kn9EGpdZy9pluryGW2xk2/fzFaG2CLITHxOIgbiilYfukW4xGltESvSs8cbdufBLaeTfjSUwbObbTaj+8tEyFj8YJpizQdkEpWXIGFua5yHNNforD8oKyQ9tjq55tkQfKkS4RbsmGMauRnTNglQrIjgkk8nU7oXNCFynKZzmU1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d14c647935so84997635ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 02:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739357246; x=1739962046;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1v6IWlc3XiSaFeDTotE3yjGY2oJ++LVh7lE4zelYMc=;
        b=sZmmlUT1xn5LC9DivOjk/ofQ7xXf5oYXYQBgQm5X7t0fNPaLvG5VzVC3DBXl/aoLS1
         Mu1NaQVulndIOc3TxrdlvJwnRkOe+KTHD1PXe9/5DhHvBK0IdFyw7wvr2XxUX6ESIi1k
         FdXttx87v4IO54JjthRvMs+zqJzQ9eCAMOZWtU83eW7UHGBQaqOUqpjVpfALrr05tOlM
         FKQtTIzggI75NgNZMj7iD5JNwx3kjmqSv3ieUHK9UhK2f3g+ECfEy1bD13yF9kFTDDyH
         B/WNm0Sqf4snFipvM7u8ud4uUA2lpwR5rHvn6tSZnxeN2CnsNfqriSjRseRE0la9bzIS
         AK7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHl58jePctnP9h/hRBOWZuA+I1QwU7pPbWQRQowfsM28FQisg/sGeltosw1rzOGtuCEqNkjJKGQkOwUSedeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYq4oE00V3k9szDUjSudxxEsV36j5cwDJZHqVxpVF2DTh4IWFw
	DQ3NWsh4hyaSINjneXn5pPeGrxLgyVjMw0AmjSxjwuhfXC4iKpaYlcLUK3WHT4HTeKPohiY2tz9
	pdX4RwzAAYDOPm/T4XuKjtLeZ5TRHZXwfQoGLQmujFXRW+HawFazQpzs=
X-Google-Smtp-Source: AGHT+IHPlKtgX0CpACwGTYhnGnVAoCBHYrvZkoxo2Fhep0cNORjv2MZjQxTQCDoedwMSRClJ35xAvxQUFzwLndI55qqDtAGG386q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1445:b0:3a7:88f2:cfa9 with SMTP id
 e9e14a558f8ab-3d17d0aaff3mr16688825ab.11.1739357246368; Wed, 12 Feb 2025
 02:47:26 -0800 (PST)
Date: Wed, 12 Feb 2025 02:47:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ac7c3e.050a0220.110943.004b.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_btree_node_mem_alloc
From: syzbot <syzbot+64fe1897190293e35923@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1081cb18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=64fe1897190293e35923
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7ee983c8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2f78699fc41/vmlinux-7ee983c8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca55e6e8dd01/bzImage-7ee983c8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+64fe1897190293e35923@syzkaller.appspotmail.com

error reading btree root btree=extents level=0: btree_node_read_error, fixing
invalid bkey in btree_node btree=inodes level=0: u64s 16 type inode_v3 0:4096:4294967281 len 0 ver 0: (unpack error)
  invalid variable length fields: delete?, fixing
invalid bkey in btree_node btree=inodes level=0: u64s 18 type inode_v3 0:4098:U32_MAX len 0 ver 0: (unpack error)
  invalid variable length fields: delete?, fixing
bcachefs (loop0): error validating btree node on loop0 at btree subvolumes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 5b940 written 0 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0  
  node offset 0/0: got wrong btree node: got
  btree=subvolumes level=0 seq c0bef60d07ceb940 1
  min: POS_MIN
  max: SPOS_MAX
bcachefs (loop0): flagging btree subvolumes lost data
error reading btree root btree=subvolumes level=0: btree_node_read_error, fixing
bcachefs (loop0): scan_for_btree_nodes...
bcachefs (loop0): btree node scan found 2 nodes after overwrites
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root extents unreadable, must recover from scan
no nodes found for btree extents, continuing
bcachefs (loop0): btree root subvolumes unreadable, must recover from scan
no nodes found for btree subvolumes, continuing
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:10 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:10 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:27 gen 0 has wrong data_type: got btree, should be need_discard, fixing
bucket 0:27 gen 0 data type need_discard has wrong dirty_sectors: got 256, should be 0, fixing
bucket 0:34 gen 0 has wrong data_type: got user, should be need_discard, fixing
bucket 0:34 gen 0 data type need_discard has wrong dirty_sectors: got 16, should be 0, fixing
bucket 0:35 gen 0 has wrong data_type: got btree, should be need_discard, fixing
bucket 0:35 gen 0 data type need_discard has wrong dirty_sectors: got 256, should be 0, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
btree cache cannibalize failed
WARNING: CPU: 0 PID: 5320 at fs/bcachefs/btree_cache.c:770 btree_node_cannibalize fs/bcachefs/btree_cache.c:770 [inline]
WARNING: CPU: 0 PID: 5320 at fs/bcachefs/btree_cache.c:770 bch2_btree_node_mem_alloc+0xf66/0x16f0 fs/bcachefs/btree_cache.c:870
Modules linked in:
CPU: 0 UID: 0 PID: 5320 Comm: syz.0.0 Not tainted 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:btree_node_cannibalize fs/bcachefs/btree_cache.c:770 [inline]
RIP: 0010:bch2_btree_node_mem_alloc+0xf66/0x16f0 fs/bcachefs/btree_cache.c:870
Code: d2 e8 2e 47 53 fd 2e 2e 2e 31 c0 e9 a3 fe ff ff e8 0f 67 83 fd c6 05 e4 7c c9 0b 01 90 48 c7 c7 00 bc 51 8c e8 6b 12 44 fd 90 <0f> 0b 90 90 eb c3 e8 ef 66 83 fd eb 05 e8 e8 66 83 fd 48 8b 5c 24
RSP: 0018:ffffc9000d425c48 EFLAGS: 00010246
RAX: c8f2efa4a74c8f00 RBX: ffff888058901cd8 RCX: 0000000000100000
RDX: ffffc9000edbb000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffff888058901cf8 R08: ffffffff81800c22 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff88801f040000
R13: ffff88805369e800 R14: ffff888058901cd0 R15: dffffc0000000000
FS:  00007f80cf7176c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f80ce84cf70 CR3: 00000000437ba000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 [inline]
 bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:532
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1230
 bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x812b/0x97a0 fs/bcachefs/btree_trans_commit.c:1085
 wb_flush_one fs/bcachefs/btree_write_buffer.c:181 [inline]
 bch2_btree_write_buffer_flush_locked+0x2c8c/0x5b10 fs/bcachefs/btree_write_buffer.c:379
 btree_write_buffer_flush_seq+0x1c49/0x1e10 fs/bcachefs/btree_write_buffer.c:551
 bch2_btree_write_buffer_journal_flush+0xc7/0x150 fs/bcachefs/btree_write_buffer.c:567
 journal_flush_pins+0x649/0xbb0 fs/bcachefs/journal_reclaim.c:585
 journal_flush_pins_or_still_flushing+0x2f/0x390 fs/bcachefs/journal_reclaim.c:857
 journal_flush_done+0x8b/0x400 fs/bcachefs/journal_reclaim.c:872
 bch2_journal_flush_pins+0x225/0x3a0 fs/bcachefs/journal_reclaim.c:912
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x2744/0x2a70 fs/bcachefs/recovery.c:442
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f80ce98e58a
Code: Unable to access opcode bytes at 0x7f80ce98e560.
RSP: 002b:00007f80cf716e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f80cf716ef0 RCX: 00007f80ce98e58a
RDX: 0000400000000200 RSI: 0000400000005900 RDI: 00007f80cf716eb0
RBP: 0000400000000200 R08: 00007f80cf716ef0 R09: 0000000001000081
R10: 0000000001000081 R11: 0000000000000246 R12: 0000400000005900
R13: 00007f80cf716eb0 R14: 0000000000005992 R15: 0000400000000000
 </TASK>


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
