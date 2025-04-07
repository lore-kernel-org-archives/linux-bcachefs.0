Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DCD2550CF
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Apr 2025 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052786; cv=none; b=o2GLSmT5wIrHDn8PhoxfrPagbudms6Ip486kpDz9A4eVgnGHzjJDIuXGDAzJQ2qEU72aNgez/rAqfVQtxW1KPhauAS8jHuhokwydeWPdHXeEuCHUQ7tolGPGDz8h372hrLCzyq8lXnOiV6ohT/0TjrvvReSYU8gqmSis5OUsNxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052786; c=relaxed/simple;
	bh=0AMCrLurcJfZb7kJ53tZu/iAVXNzYknQ/AnFDcVs6i8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ip8dWd2DIT3xVnMSc65Jt2Nl54Ti/HOaHpxeUxYonVvfjTKb4jJreQ09Wu2iJDfzmNSvSPFaNJkqW+c4TVAYSDFCXgVW1Fuk4VW6JxhPlX8YyfGxOOo6SRke9rdCrQ1jxoWwiRP3+sqF3eNSO+7nrLTU9pXesDNG1GUesXKerEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d43541a706so47678495ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Apr 2025 12:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744052784; x=1744657584;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+xVZLm6kqc2an4MKk8zio1UQWD5T1+HUmq4djDHDhvI=;
        b=NC2IAuPAB5I1wNszAw4ipmwynDn2cu9HTrFLZXrP5YQXUEiGvezYymUMYYt12gIRwE
         DdhYj2UeHcy+pSTmujEt3R8H5V6WytkeYdpWx/SW6IjXrLYDYNmbZtmG2MMMHA+HFhgb
         44PR5s2tLP78URSrKqFk0gwz40O3bjhnWLRt/kGf622mA32x9ON0YAFYVQYA3tcLcDtX
         fVbpKC5fUBfKQK4GmsboOXJLOijJNtkigtUd4+OXAlrPsfGurEkSn+73gzStBUG5/Feq
         5LUkb84Mrc238B1QB+SQWKBxBGvUGfSJg/5ZvvgFZM8rbBeX6Mho6Ard5NDERsansopR
         1umA==
X-Forwarded-Encrypted: i=1; AJvYcCVKAU3i/eSDWP8UZ3sbgRPT331p34ad/Okwbjt4vTiaYU7lAJxyzo9fKFORyvxQFymw/gIs18nU0z5LtB7xYg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yze4qO05d31BfPL95lKC6oqM/3bhqKXmmZlNFG2G9OcxZWtPRAd
	PYzHx44Onec6yaPDnvwKBbvs4EDuN/Qq/aijoaUcAVX2NNhIRPSGvxiRBfXpmmgZC3riHQ2aIkM
	nybDzDDVrEq+q+9cMHMmDK8NhuwhvOEgH5ZP3yr8Rs3rYXJd75ynm97o=
X-Google-Smtp-Source: AGHT+IHPbTLpASg7R6uZalh6iNPCdDRAruLRQxDMs2Na9CqjWqglBRYeBtAG9F5rnxwzQLPUgb1SJwsnAXR2audcNkGslBuCQH/Z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3783:b0:3d6:d0e1:73eb with SMTP id
 e9e14a558f8ab-3d6e531e535mr133514345ab.7.1744052784008; Mon, 07 Apr 2025
 12:06:24 -0700 (PDT)
Date: Mon, 07 Apr 2025 12:06:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f4222f.050a0220.396535.0552.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_rename2 (2)
From: syzbot <syzbot+fa540e3a6e6f0bc4edc8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0af2f6be1b42 Linux 6.15-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f03b4c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66996a2350ef05e0
dashboard link: https://syzkaller.appspot.com/bug?extid=fa540e3a6e6f0bc4edc8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0af2f6be.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fcfb8eefe4d/vmlinux-0af2f6be.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e06a39be2bd8/bzImage-0af2f6be.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa540e3a6e6f0bc4edc8@syzkaller.appspotmail.com

bcachefs (loop0): running explicit recovery pass reconstruct_snapshots (21), currently at snapshots_read (7)
 done
bcachefs (loop0): check_allocations...
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
bcachefs (loop0): bucket 0:26 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bcachefs (loop0): bucket 0:15 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:15 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:26 gen 0 has wrong data_type: got free, should be btree, fixing
bcachefs (loop0): bucket 0:26 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:32 gen 0 has wrong data_type: got btree, should be need_discard, fixing
bcachefs (loop0): bucket 0:32 gen 0 data type need_discard has wrong dirty_sectors: got 256, should be 0, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
bcachefs (loop0): scanning for missing backpointers in 4/128 buckets
 done
bcachefs (loop0): reconstruct_snapshots...
bcachefs (loop0): snapshot node 4294967295 from tree 4294967295 missing, recreating
 done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
bcachefs (loop0): scanning for missing backpointers in 1/128 buckets
 done
bcachefs (loop0): reconstruct_snapshots... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
bcachefs (loop0): dirent to missing inode:
  u64s 7 type dirent 4096:189491840996961599:U32_MAX len 0 ver 0: file0 -> 4098 type dir
  
------------[ cut here ]------------
kernel BUG at fs/bcachefs/fs.c:990!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5325 Comm: syz.0.0 Not tainted 6.15.0-rc1-syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_rename2+0x20c6/0x20d0 fs/bcachefs/fs.c:990
Code: ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 44 f2 ff ff 4c 89 ff e8 3a 3b bb fd e9 37 f2 ff ff e8 20 3e be 07 e8 3b 12 51 fd 90 <0f> 0b e8 33 12 51 fd 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d317520 EFLAGS: 00010283
RAX: ffffffff847242e5 RBX: 0000000000001002 RCX: 0000000000100000
RDX: ffffc9000e102000 RSI: 00000000000059ca RDI: 00000000000059cb
RBP: ffffc9000d317ab0 R08: ffffffff84723605 R09: 1ffff1100ac9903a
R10: dffffc0000000000 R11: ffffed100ac9903b R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000001005 R15: ffff8880550b9e60
FS:  00007f9ddb8926c0(0000) GS:ffff88808c596000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe65a81b18 CR3: 00000000441b8000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vfs_rename+0xbce/0xf10 fs/namei.c:5086
 do_renameat2+0xc8d/0x1290 fs/namei.c:5235
 __do_sys_renameat2 fs/namei.c:5269 [inline]
 __se_sys_renameat2 fs/namei.c:5266 [inline]
 __x64_sys_renameat2+0xce/0xe0 fs/namei.c:5266
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9dda98d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9ddb892038 EFLAGS: 00000246 ORIG_RAX: 000000000000013c
RAX: ffffffffffffffda RBX: 00007f9ddaba5fa0 RCX: 00007f9dda98d169
RDX: 0000000000000006 RSI: 00002000000001c0 RDI: 0000000000000006
RBP: 00007f9ddaa0e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000200 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f9ddaba5fa0 R15: 00007ffcbe6f4818
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_rename2+0x20c6/0x20d0 fs/bcachefs/fs.c:990
Code: ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 44 f2 ff ff 4c 89 ff e8 3a 3b bb fd e9 37 f2 ff ff e8 20 3e be 07 e8 3b 12 51 fd 90 <0f> 0b e8 33 12 51 fd 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d317520 EFLAGS: 00010283
RAX: ffffffff847242e5 RBX: 0000000000001002 RCX: 0000000000100000
RDX: ffffc9000e102000 RSI: 00000000000059ca RDI: 00000000000059cb
RBP: ffffc9000d317ab0 R08: ffffffff84723605 R09: 1ffff1100ac9903a
R10: dffffc0000000000 R11: ffffed100ac9903b R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000001005 R15: ffff8880550b9e60
FS:  00007f9ddb8926c0(0000) GS:ffff88808c596000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9ddb870fd8 CR3: 00000000441b8000 CR4: 0000000000352ef0
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
