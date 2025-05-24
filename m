Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD428EB
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 May 2025 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748099020; cv=none; b=PpIO6m2r5a/ZS89A2hrrEUnpuZ9zhFUE8HXl2voktY6SvqyK8oL7SZEbhwTgdmQfENRQvadKv36hTL21Q7YLBqCRvgwGRfrgi1RhC9VlfT7jZjRX55XeQbI8c2Oe2cPdwegZvgpY5FkOxaCWgf6qljfcPMXJXyX7xsrKZoZfLj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748099020; c=relaxed/simple;
	bh=Iapfhmtbl6qCZXzml+8V985in4QkkaQ2roCcFijAI+0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JBllvfpByIzmBtxc5CRF4Uh+GV9B64i/EmoA1fFG6YV2+wtbNhepfL1C+Fa5AYlu7LdW+QYeDSXKZX6vxAjQf1waC0qYWN4626sTVSk/VKueSGwWxRB2g4Xf4jPCo09LRxGqh/hhJ7BzvGBYZAnQhmgn5OC7a0+K3FFMMAGIjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-85b41b906b3so83247339f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 May 2025 08:03:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748099018; x=1748703818;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SsOdcmCfOJZVcu4aqFGwj4FFtGgKojNnma9o2NV52k=;
        b=nycktMJ/qHb7l3eK7xpjJhxAw46W44bX5rwKjNIDiedYzdunaMLRUFPm8kL8Flj7cn
         DhIey2YRw9/IKWiTrpd9UwI1OffMkZwlXaLdZus6jaD8zK5Zm0OmT4JM0rrAC3e+0Kjj
         D0J0eD0qdvlrSiQvhMsolmQVOlrTPeit8OIdOceYgZyzvi7/kY6vIeO9YuaWo6TwVcHf
         +GQVpcph/VGxEo45eDyRBshOxLGEOWRpH3KL0Hb8t1fH5t4Gxl6mNinAdsfWfaAWMsuq
         +hK43QzXskrC32wQBkdHw211466JXwzb0Q0VS/cSyu875l3AhWL7mra49HxfkUJ155ku
         51aQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5xs6hwCE3LrEINxzelUt8p89dTn8c5ilpPHppMDntrO/v9YJotUF5pZA55y+laUmhMr3ZJLTP6J3xqLH3/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdLeTXwNu3CxqmstrSkz5Va/yk4aLUsCWfuLAjw7EBRxn1IGTt
	ECt7UuhdCqFIvCMrtKprdIMtyKuJGFoilSrak2rkPr20UeXEC9UCRvTQZ4tD4yOzHWgN3iHt3E1
	xGdZGbjKMPSgDbVtshWrTiF8NPj5X2cKdpYfLHoKz3zb8AF7klOr1y4OCyL0=
X-Google-Smtp-Source: AGHT+IG2LZD2JtGo5VsdB9g6b2wGe8+9422jqP4fp+suagU1Wnv+5d/Rs3OvuzBLeJgTYIZs7zgCI48qaONx3C3KxntSRvNf2pL1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:b8b:b0:85b:476e:ede2 with SMTP id
 ca18e2360f4ac-86cbb8c2689mr292092339f.13.1748099017758; Sat, 24 May 2025
 08:03:37 -0700 (PDT)
Date: Sat, 24 May 2025 08:03:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6831dfc9.a70a0220.253bc2.0072.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_trans_commit (2)
From: syzbot <syzbot+42581416dba62b364750@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a5806cd506af Linux 6.15-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1718ff68580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9fd1c9848687d742
dashboard link: https://syzkaller.appspot.com/bug?extid=42581416dba62b364750
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a5806cd5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6757f216130e/vmlinux-a5806cd5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5f9c86c4f92f/bzImage-a5806cd5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+42581416dba62b364750@syzkaller.appspotmail.com

  u64s 8 type dirent 4096:9097378837824744618:U32_MAX len 0 ver 0: file.cold -> 536870914 type reg, fixing
bcachefs (loop0): dirent points to missing inode:
  u64s 7 type dirent 4096:9181104441347170296:U32_MAX len 0 ver 0: file0 -> 4098 type dir, fixing
bcachefs (loop0): directory 4096:4294967295 with wrong i_nlink: got 0, should be 1, fixing
bcachefs (loop0): hash table key at wrong offset: btree dirents inode 4098 offset 5675548428000973578, hashed to 6487782572445408762
  u64s 7 type dirent 4098:5675548428000973578:U32_MAX len 0 ver 0: file1 -> 4100 type lnk, fixing
bcachefs (loop0): dirent points to inode that does not point back:
  u64s 7 type dirent 4098:6487782572445408762:U32_MAX len 0 ver 0: file1 -> 4100 type lnk
  inum: 4100:4294967295 
    mode=100600
    flags=(15300000)
    journal_seq=19
    hash_seed=c09572f56f2a867d
    hash_type=siphash
    bi_size=4096
    bi_sectors=8
    bi_version=0
    bi_atime=33055089404955356
    bi_ctime=33055089404955356
    bi_mtime=33055089404955356
    bi_otime=33055089404955356
    bi_uid=0
    bi_gid=0
    bi_nlink=0
    bi_generation=0
    bi_dev=0
    bi_data_checksum=0
    bi_compression=0
    bi_project=0
    bi_background_compression=0
    bi_data_replicas=0
    bi_promote_target=0
    bi_foreground_target=0
    bi_background_target=0
    bi_erasure_code=0
    bi_fields_set=0
    bi_dir=0
    bi_dir_offset=6487782572445408762
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop0): inode 4100:4294967295 has wrong backpointer:
  got       0:6487782572445408762
  should be 4098:6487782572445408762, fixing
bcachefs (loop0): incorrect d_type: got lnk, should be reg:
  u64s 7 type dirent 4098:6487782572445408762:U32_MAX len 0 ver 0: file1 -> 4100 type lnk, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_trans_commit.c:346!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5318 Comm: syz.0.0 Not tainted 6.15.0-rc7-syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:btree_insert_entry_checks fs/bcachefs/btree_trans_commit.c:341 [inline]
RIP: 0010:bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:721 [inline]
RIP: 0010:do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:844 [inline]
RIP: 0010:__bch2_trans_commit+0x89a6/0x8ae0 fs/bcachefs/btree_trans_commit.c:1050
Code: ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 1d ff ff ff 48 89 df e8 2a ad ff fd e9 10 ff ff ff e8 90 46 34 07 e8 fb b1 9d fd 90 <0f> 0b f3 0f 1e fa 65 8b 1d 51 a0 53 0e bf 07 00 00 00 89 de e8 21
RSP: 0018:ffffc9000fe5eae0 EFLAGS: 00010246
RAX: ffffffff84223fd5 RBX: ffffffff842201ca RCX: 0000000000100000
RDX: ffffc9000ddc2000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000fe5edd0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff842201ca R12: dffffc0000000000
R13: ffff8880562fc020 R14: ffff8880562fe468 R15: 0000000000000001
FS:  00007f14e6f436c0(0000) GS:ffff88808d6c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60b65909c0 CR3: 0000000042ef5000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_trans_commit fs/bcachefs/btree_update.h:195 [inline]
 check_dirent fs/bcachefs/fsck.c:2242 [inline]
 bch2_check_dirents+0x19ae/0x2460 fs/bcachefs/fsck.c:2272
 bch2_run_recovery_pass+0xdf/0x1d0 fs/bcachefs/recovery_passes.c:227
 bch2_run_recovery_passes+0x2a0/0xdb0 fs/bcachefs/recovery_passes.c:280
 bch2_fs_recovery+0x2399/0x37b0 fs/bcachefs/recovery.c:937
 bch2_fs_start+0x70b/0xae0 fs/bcachefs/super.c:1096
 bch2_fs_get_tree+0xad7/0x13b0 fs/bcachefs/fs.c:2507
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1759
 do_new_mount+0x24a/0xa40 fs/namespace.c:3881
 do_mount fs/namespace.c:4221 [inline]
 __do_sys_mount fs/namespace.c:4432 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4409
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14e619010a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f14e6f42e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f14e6f42ef0 RCX: 00007f14e619010a
RDX: 0000200000000000 RSI: 0000200000000040 RDI: 00007f14e6f42eb0
RBP: 0000200000000000 R08: 00007f14e6f42ef0 R09: 0000000003000005
R10: 0000000003000005 R11: 0000000000000246 R12: 0000200000000040
R13: 00007f14e6f42eb0 R14: 000000000000597c R15: 0000200000000280
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btree_insert_entry_checks fs/bcachefs/btree_trans_commit.c:341 [inline]
RIP: 0010:bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:721 [inline]
RIP: 0010:do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:844 [inline]
RIP: 0010:__bch2_trans_commit+0x89a6/0x8ae0 fs/bcachefs/btree_trans_commit.c:1050
Code: ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 1d ff ff ff 48 89 df e8 2a ad ff fd e9 10 ff ff ff e8 90 46 34 07 e8 fb b1 9d fd 90 <0f> 0b f3 0f 1e fa 65 8b 1d 51 a0 53 0e bf 07 00 00 00 89 de e8 21
RSP: 0018:ffffc9000fe5eae0 EFLAGS: 00010246
RAX: ffffffff84223fd5 RBX: ffffffff842201ca RCX: 0000000000100000
RDX: ffffc9000ddc2000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffffc9000fe5edd0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff842201ca R12: dffffc0000000000
R13: ffff8880562fc020 R14: ffff8880562fe468 R15: 0000000000000001
FS:  00007f14e6f436c0(0000) GS:ffff88808d6c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60b65909c0 CR3: 0000000042ef5000 CR4: 0000000000352ef0
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
