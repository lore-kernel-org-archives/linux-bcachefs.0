Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71AF5FDA7
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Jan 2025 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736994147; cv=none; b=NYVNj0EfutbWCscxOUxTI17Rwvul4bk61OoevU1zsMObZMvkVAKeTIatZP0c/M6wOFlySqUS2F7J2oLCjomfU+261hNwuWOWn17nVXNTvuSlXIjFsSTsApf95eA26j4J0NPe2bnGPHmcXb1b2SZl4dYWSI/OaiL93MUeu8EckdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736994147; c=relaxed/simple;
	bh=U4bNVHoo63QiNg3U1HFRfzJLv6eiJVcZcmqnrq58TLM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AtANNi1BgN2n85Kc269rfYdu/8fm7Zh5L2WKQH/b00dmAaBp6E8xP2WikK1c1RCCyZWQ03Ulh0g3LaCkcjcZmMrbLmXZ5Xe87b2fLAmIKGG6YBViekc4iQy4ZEP4QUVVYP6rM5aEi6XxHqSs1uUsJDe6r574weAHoHqhiX4OAHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ac98b49e4dso2919105ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 15 Jan 2025 18:22:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736994145; x=1737598945;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SKIC+dQJdC4Rajq1T8I0BDTu3o6w4py9UUL2L3gSU6U=;
        b=WwbwRK3CK2YQ5ZlToULatn2hP/PiOw3zqbyAZMCKOpK2qtZeXWXLRHvFdAWYFaRbKJ
         SqpQzpfcrS4s9FX6hxswbyowmBlDu3YWT2RP2lBYVEP+UGx8nIqMt20ILuN/RS5qaz/g
         mVlpfzlVcgCu3nKCoYwyvJ55R1Da3kFSORb26QE+EUN9wpXzKBK7uePWKoz1q2tZvjnE
         QY7Do27rM+3j7xtIvzn3UXAaKP0M2hJUaexdJHAt82Niy9ta298utmrCUnU153k+9EUJ
         mKWON3eRcvIPTNwnJX4sAbBlYpEpPBcAOmk6r1++z00bpn3pTmyTNQaUWPA/c+Wkqhid
         DVlA==
X-Forwarded-Encrypted: i=1; AJvYcCXg0V5zI6tjgLTPcLdI68tyzr7tNMZExod3J/Myvz4iVkuwE/9qUDP5AZBP3HZoG1LlaZwilyl0ZczZD98xGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxB4M5w4I0KieNethbi+91D0DO6YXF/nhWsxlgKlXVEj5sJES
	PYnziYJcCi1xTnPOawryQepswgLxKVhfTfQgYZsFd4vOw7WLN5Kf3jFtO5QOz4R1z7zCRdkz7jo
	bsexp2Wt3r3q5x+Y7SSQeyUWgr77Z+qw0IAay60BWMNtHUJfj6cGxsgs=
X-Google-Smtp-Source: AGHT+IHozIVyR9nkyXIdZGLpoQ9DGUNUj/c3cB+h5V1bVV2E1igpJszV3mKk2/AfANHgE93NB1obeRZPEyVVy9z2/8yRlsnVzEOO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190e:b0:3ce:5af3:79d5 with SMTP id
 e9e14a558f8ab-3ce5af44b62mr186896185ab.6.1736994145004; Wed, 15 Jan 2025
 18:22:25 -0800 (PST)
Date: Wed, 15 Jan 2025 18:22:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67886d60.050a0220.20d369.0020.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_btree_node_hash_insert (2)
From: syzbot <syzbot+3b2a86ce65e01acca028@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b62cef9a5c67 Merge tag 'hwmon-for-v6.13-rc7' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c5acb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ef22c4fce5135b4
dashboard link: https://syzkaller.appspot.com/bug?extid=3b2a86ce65e01acca028
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b62cef9a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b41aebe26f97/vmlinux-b62cef9a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ffdc0f63e63/bzImage-b62cef9a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3b2a86ce65e01acca028@syzkaller.appspotmail.com

bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=freespace level=0 SPOS_MAX due to error
invalid btree root deleted_inodes, fixing
bcachefs (loop0): flagging btree deleted_inodes lost data
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  xattrs l=0 seq=1 journal_seq=4 cookie=2285c34bed0abe32 POS_MIN-SPOS_MAX ptr: 0:31:0 gen 0
  lru l=0 seq=1 journal_seq=5 cookie=28f61e078e70b95c POS_MIN-SPOS_MAX ptr: 0:28:0 gen 0
  deleted_inodes l=0 seq=1 journal_seq=0 cookie=1db8f60c84bb244c POS_MIN-SPOS_MAX ptr: 0:42:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root extents unreadable, must recover from scan
no nodes found for btree extents, continuing
bcachefs (loop0): btree root deleted_inodes unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovering deleted_inodes l=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1db8f60c84bb244c written 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen 0
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
bcachefs (loop0): pointer to nonexistent bucket 0:4398046511107
bcachefs (loop0): bch2_gc_mark_key(): error EIO
bcachefs (loop0): bch2_gc_btree(): error EIO
btree node read error for alloc, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
bucket 0:38 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bucket 0:41 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bucket 0:35 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
bucket 0:32 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
bucket 0:28 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 28f61e078e70b95c written 16 min_key POS_MIN durability: 1 ptr: 0:28:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 21 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:29 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 21 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:42 data type btree stale dirty ptr: 0 < 7
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1db8f60c84bb244c written 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen 0, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.c:280!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5316 Comm: syz.0.0 Not tainted 6.13.0-rc6-syzkaller-00262-gb62cef9a5c67 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: ed fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 2e 61 ed fd e9 e5 f7 ff ff e8 a4 fd 86 fd 90 <0f> 0b e8 9c fd 86 fd 90 0f 0b e8 94 fd 86 fd 90 0f 0b e8 3c 65 b0
RSP: 0018:ffffc9000d41dde0 EFLAGS: 00010287
RAX: ffffffff8418848c RBX: ffff888040273228 RCX: 0000000000100000
RDX: ffffc9000e982000 RSI: 000000000008c2b0 RDI: 000000000008c2b1
RBP: ffffc9000d41df10 R08: ffffffff84188d71 R09: 1ffff1100804e616
R10: dffffc0000000000 R11: ffffed100804e617 R12: 1ffff1100804e645
R13: dffffc0000000000 R14: ffff888053081a80 R15: ffff888040273000
FS:  00007f9d548776c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559ae8673088 CR3: 000000003ff32000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_update_key_early+0xa8d/0xbd0 fs/bcachefs/btree_cache.c:332
 bch2_check_fix_ptrs+0x5dc7/0x6530 fs/bcachefs/buckets.c:380
 bch2_trigger_extent+0x92c/0xaa0 fs/bcachefs/buckets.c:856
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_gc_mark_key+0x6b5/0x10e0 fs/bcachefs/btree_gc.c:634
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1c3e/0x7070 fs/bcachefs/btree_gc.c:1133
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3511
 do_mount fs/namespace.c:3851 [inline]
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9d539874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9d54876e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f9d54876ef0 RCX: 00007f9d539874ca
RDX: 0000000020000000 RSI: 0000000020005900 RDI: 00007f9d54876eb0
RBP: 0000000020000000 R08: 00007f9d54876ef0 R09: 0000000001000044
R10: 0000000001000044 R11: 0000000000000246 R12: 0000000020005900
R13: 00007f9d54876eb0 R14: 00000000000059bc R15: 0000000020000180
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: ed fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 2e 61 ed fd e9 e5 f7 ff ff e8 a4 fd 86 fd 90 <0f> 0b e8 9c fd 86 fd 90 0f 0b e8 94 fd 86 fd 90 0f 0b e8 3c 65 b0
RSP: 0018:ffffc9000d41dde0 EFLAGS: 00010287
RAX: ffffffff8418848c RBX: ffff888040273228 RCX: 0000000000100000
RDX: ffffc9000e982000 RSI: 000000000008c2b0 RDI: 000000000008c2b1
RBP: ffffc9000d41df10 R08: ffffffff84188d71 R09: 1ffff1100804e616
R10: dffffc0000000000 R11: ffffed100804e617 R12: 1ffff1100804e645
R13: dffffc0000000000 R14: ffff888053081a80 R15: ffff888040273000
FS:  00007f9d548776c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559ae8673088 CR3: 000000003ff32000 CR4: 0000000000352ef0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
