Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154E1FBEB6
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Dec 2024 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734556889; cv=none; b=cOnvS+ctzfZSE1xtVVyePUxj2wRRU+3Q/7SE81a5zrb21g5iHWbU/EalWOocNM8TQ24oARYckE+NBNlMSktIpz5ohOsUR9cgooIeRxcOxfPqgPfZe38BXZiMSQ/cPN3SKd5HJmkl74ifKKUITV5xQTwlft3acUTWc+gfIILV8HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734556889; c=relaxed/simple;
	bh=KzhXlGgpK7N8DFtJWH+I8EfzMZMFXjdI5zdQ7wDeZek=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UMg7AAOyXblOWUTKjl8Sq0WiqyAwunsofWGychjQZ1KiE2CgR52SkIawzaqQl4fNqRmDKLR9IoHgbA0HZi2MOpGI0+wmssbR6q3ulZGI8CKHOv++NT3WBzZaU/54P3JYs8mT6UbnZhVrMTgUjOpqHXnlDmsF+nRvXXJxuPubSoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9d195e6e5so839555ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Dec 2024 13:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734556886; x=1735161686;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=32psuXPm47mJdT20msf4O6si8v1yZqyuAfnU5aS8Y5U=;
        b=XnyaugQP9H8BXtFronyS76rOfD67vSPhdQaYaNOq3xMbjsAgCUfbDr8/JBGsGOhqAf
         HJM6o67ZZMh5Qca6Ggsyju3RmKNy1Zx8Tw/uo+Ar9MsgYo9f9J3Um1SWeLp4RCN0/jAv
         UdGE8VApPMzXiZ1OhQzWQvlTdUaOQ4yaZ6WDNTlExyUIw0aGTcjw386XR2SHoVvUfIUA
         2Ku61x03lLlvRyoysnG52atB9TKSOFGm8ne7+l69ORN4BxgtKyF+U2iOb2usoobRFHF0
         HicBvMLcEUqVwh+72o6xzwIv9lsSgfIueHvucFeip8K08MAtuTvWvXVNGYbETMdj9tQJ
         TWIg==
X-Forwarded-Encrypted: i=1; AJvYcCUbqtAT/VAuZTH4prkeKqzm/z+iYay/XikoDcmnhh8veZcq/xFUSfW3YCicmk23ggIhALcb0K1mMxzhe2Mp8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUNWyDA8v3YzOE7pAx884BZoNYhPzUQRgQ6/goOSTChmfU6X2n
	6+BOGkgC8r/3ZQ/onv3MPn6bdaij19xP8e1Tr6H9zGOFVKtoX3DpEHT29yqWDnWfMz7MfmMTg9H
	GgXhgAj452fjeYi1q+hlUNA8zJlvFOFeLIXHsEDvpf36EfJUt8xZhc8Y=
X-Google-Smtp-Source: AGHT+IHpS/CACoJMgSpxgieDIepXLRemlJNg1qioIhtSPkITRro+ZNK65BEOpXMs8IBJ4u6JJWIioAcN1BMpW5WYvYJKPSE347z6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b0e:b0:3a7:7558:a6ea with SMTP id
 e9e14a558f8ab-3c011b45ccamr9806785ab.10.1734556886586; Wed, 18 Dec 2024
 13:21:26 -0800 (PST)
Date: Wed, 18 Dec 2024 13:21:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67633cd6.050a0220.3157ee.0006.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init_from_start
From: syzbot <syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a446e965a188 Merge tag '6.13-rc2-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15617be8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fee25f93665c89ac
dashboard link: https://syzkaller.appspot.com/bug?extid=381eead9693b057ae73f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a446e965.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8dffce4e4b7/vmlinux-a446e965.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d69c9580adbc/bzImage-a446e965.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com

  node offset 0/24: got wrong btree node: got
  btree=(unknown) l=1 seq 2774163494416111927x
  min: 15876595779377021056:14598282726174629052:3622545195
  max: 443999667996278687:11692075508790369864:2516906035
bcachefs (loop0): flagging btree dirents lost data
error reading btree root dirents l=0: btree_node_read_error, fixing
bcachefs (loop0): will run btree node scan
bcachefs (loop0): error validating btree node on loop0 at btree alloc level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1818ce08861e3527 written 40 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0  
  node offset 8/40 bset u64s 375: checksum error, type chacha20_poly1305_128: got 2d1b41d865616c1f5319137ce21d6071 should be 61ec379a8789477e76ff1a5280fd6dbd, fixing
bcachefs (loop0): error validating btree node at btree alloc level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1818ce08861e3527 written 40 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0  
  node offset 8/40 bset u64s 375 bset byte offset 1048: keys out of order: u64s 11 type alloc_v4 29273397577908224:13:0 len 0 ver 0 > u64s 11 type alloc_v4 0:14:0 len 0 ver 0, fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=alloc level=0 SPOS_MAX due to error
bcachefs (loop0): error validating btree node on loop0 at btree subvolumes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d682cebdf2a7eb26 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0  
  node offset 8/16 bset u64s 9: checksum error, type chacha20_poly1305_128: got 7632cdaf3353c3de8e3d2914ef82ff81 should be fbb8db7d0b4b1105d74f8b153c3602e1, fixing
bcachefs (loop0): error validating btree node at btree subvolumes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d682cebdf2a7eb26 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0  
  node offset 8/16 bset u64s 9 bset byte offset 40: key extends past end of bset, fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=subvolumes level=0 SPOS_MAX due to error
bcachefs (loop0): error validating btree node on loop0 at btree snapshots level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d771a06d670df06c written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0  
  node offset 0/16 bset u64s 0: checksum error, type chacha20_poly1305_128: got 62e2995e867337a1803b70574e89b407 should be 3f4bb4678363c29f1ca269ce5970cac0, fixing
bcachefs (loop0): error validating btree node on loop0 at btree snapshots level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d771a06d670df06c written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0  
  node offset 0/16: incorrect min_key: got 674309865472:0:0 should be POS_MIN
bcachefs (loop0): flagging btree snapshots lost data
error reading btree root snapshots l=0: btree_node_read_error, fixing
bcachefs (loop0): error validating btree node on loop0 at btree lru level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 93dda84068e88b3f written 16 min_key POS_MIN durability: 1 ptr: 0:28:0 gen 0  
  node offset 8/16 bset u64s 3: checksum error, type chacha20_poly1305_128: got f3429b02592db3bb33a5353e5cab12c2 should be 9ac25d08c1c53f9311173a7dfa1d3bf7, fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=lru level=0 SPOS_MAX due to error
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  extents l=0 seq=1 journal_seq=5 cookie=4e0410879b0c2f04 POS_MIN-SPOS_MAX ptr: 0:27:0 gen 0
  inodes l=0 seq=1 journal_seq=5 cookie=2a20405ac3f40602 POS_MIN-SPOS_MAX ptr: 0:38:0 gen 0
  xattrs l=0 seq=1 journal_seq=4 cookie=1b881868e2a6abe1 POS_MIN-SPOS_MAX ptr: 0:31:0 gen 0
  subvolumes l=0 seq=1 journal_seq=1 cookie=d682cebdf2a7eb26 POS_MIN-SPOS_MAX ptr: 0:35:0 gen 0
  snapshots l=0 seq=1 journal_seq=1 cookie=d771a06d670df06c 674309865472:0:0-SPOS_MAX ptr: 0:32:0 gen 0
  lru l=0 seq=1 journal_seq=5 cookie=93dda84068e88b3f POS_MIN-SPOS_MAX ptr: 0:28:0 gen 0
  deleted_inodes l=0 seq=1 journal_seq=0 cookie=82036bda63714c10 POS_MIN-SPOS_MAX ptr: 0:40:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root dirents unreadable, must recover from scan
no nodes found for btree dirents, continuing
bcachefs (loop0): btree root snapshots unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovering snapshots l=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d771a06d670df06c written 536 min_key 674309865472:0:0 durability: 1 ptr: 0:32:0 gen 0
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bset.c:1354!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5318 Comm: syz.0.0 Not tainted 6.13.0-rc2-syzkaller-00292-ga446e965a188 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_node_iter_init_from_start+0x446/0x460 fs/bcachefs/bset.c:1354
Code: c4 80 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 40 ae ff ff e8 5b ad 87 fd 90 0f 0b e8 53 ad 87 fd 90 0f 0b e8 4b ad 87 fd 90 <0f> 0b e8 43 ad 87 fd 90 0f 0b e8 3b ad 87 fd 90 0f 0b e8 33 ad 87
RSP: 0018:ffffc9000d4be828 EFLAGS: 00010293
RAX: ffffffff8417b0f5 RBX: ffff88804518009e RCX: ffff88801ee90000
RDX: 0000000000000000 RSI: ffff8880451800a0 RDI: ffff888045180008
RBP: 0000000000000013 R08: ffffffff8417ad69 R09: 0000000000000000
R10: ffffc9000d4be920 R11: fffff52001a97d25 R12: ffff8880525470f8
R13: ffff888052547108 R14: dffffc0000000000 R15: ffffc9000d4be920
FS:  00007fecd68fc6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558790d4e088 CR3: 0000000043330000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_and_journal_iter_init_node_iter+0x98/0x200 fs/bcachefs/btree_journal_iter.c:478
 bch2_btree_repair_topology_recurse+0x45c8/0x6750 fs/bcachefs/btree_gc.c:447
 bch2_check_topology+0x692/0xb20 fs/bcachefs/btree_gc.c:550
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fecd5b874ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fecd68fbe68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fecd68fbef0 RCX: 00007fecd5b874ba
RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007fecd68fbeb0
RBP: 000000002000f640 R08: 00007fecd68fbef0 R09: 0000000000000084
R10: 0000000000000084 R11: 0000000000000246 R12: 000000002000f680
R13: 00007fecd68fbeb0 R14: 000000000000f62b R15: 0000000020000240
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_node_iter_init_from_start+0x446/0x460 fs/bcachefs/bset.c:1354
Code: c4 80 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 40 ae ff ff e8 5b ad 87 fd 90 0f 0b e8 53 ad 87 fd 90 0f 0b e8 4b ad 87 fd 90 <0f> 0b e8 43 ad 87 fd 90 0f 0b e8 3b ad 87 fd 90 0f 0b e8 33 ad 87
RSP: 0018:ffffc9000d4be828 EFLAGS: 00010293
RAX: ffffffff8417b0f5 RBX: ffff88804518009e RCX: ffff88801ee90000
RDX: 0000000000000000 RSI: ffff8880451800a0 RDI: ffff888045180008
RBP: 0000000000000013 R08: ffffffff8417ad69 R09: 0000000000000000
R10: ffffc9000d4be920 R11: fffff52001a97d25 R12: ffff8880525470f8
R13: ffff888052547108 R14: dffffc0000000000 R15: ffffc9000d4be920
FS:  00007fecd68fc6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558790d4f068 CR3: 0000000043330000 CR4: 0000000000352ef0
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
