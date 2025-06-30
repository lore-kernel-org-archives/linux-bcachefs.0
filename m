Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F65C254AE0
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751278293; cv=none; b=MgbelHrC3qjFFl+AtfcYr+Z7ds1rE1fycS1USCcKnctizvDPEVBPGJqfeiqGege60zAYcvxt5eql8uMpkn5hcWDClA7PIkgZ8QcRkMv276AZkILtVKk9lrh8iFPjW9M3FA6B5NT0USTY4hsVb4T+xmLLurb/LalkY5AW68fOBFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751278293; c=relaxed/simple;
	bh=DXIsdFz0khiePemQabaCvf5rwUnePHro0xb3kO6m5I0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MCKNNY6Y59zzkWGdAY1qo8YSJmF9N27A2+Zc2vc922vmr8IewftzXkVp0yebk7rIw2na7e88TG6NqG66uUO+NUAgS+AkXXZEa3YytfLhnqh76aPI34ymJ5k6J9kv2b3kqHCYGfu4C1z1Fxd591JKjc6yJKth9AYfm3ZkoaVc35s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3df4d2a8b5eso20526135ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Jun 2025 03:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751278291; x=1751883091;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fir1Mx3oc/hw50qWcisj52CkcOoqSXSUW6bCpRc9mjo=;
        b=dVBOnOZx8WXY5lg5FSYG+DSzl4fmwNvyRYiERauBadsLOIKdGOWISlcDHkH63s6DH+
         VGuQvMmhz6TXMirg3W1gdOMzD+dszg100jCALMr7tl+N1pyXWnxAsrsUTzcQzHM5D0Ta
         OT4rCeWORRR5S6xdwICeSvejE1aaw0pN8lbhO4y8EZJo6QLlP0jUCncwt0vT23VsM66h
         pDzGwj9xioYCP/5sUhGE7JA7yusutghNs2bt8xbdwXW6cUKpmpxKOu2Su2Jkdm7jefDE
         nxyoRI9S0H5DKk9D4JaRoZmrsvf3D5/Mna8IO3Y2he3k3k2MmDGb+hlh/TmthZnQc7UM
         //Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVeoUtZFqSIDBE4AJw5aZ4pXjgyLnR4Qj8OzUZeTWo3mgYmRJDJ8UboL3PEIQyEKxZf6PiHb5MLDUHpQ+xrag==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9BWj9evslc6geTL5gfOAuIIbXZTuRSNKBqc11i3+GzA+naBnG
	AolMTRvcVgx5kzCpmiIX5X7dH+TKW/ZeOQ0aRsiVt9YAL93Kmt5K7lAstSQlU878tLrGpzUpLcQ
	zv52ZXD489JncMo8hEiEpIOxwyxvj1/w+9UsMC8tbHPdFWOi/bYYDDDlYVk8=
X-Google-Smtp-Source: AGHT+IEnD2oKWqQpO4u3jON1MVhQdfPievbLzAnNT45I7RyDzc4nUzweQuFblO4kKNtuVEYZhlp8WXvirtivf6s2crxC1JaB8bfS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c08:b0:3df:3598:7688 with SMTP id
 e9e14a558f8ab-3df4acf494emr161155415ab.21.1751278291394; Mon, 30 Jun 2025
 03:11:31 -0700 (PDT)
Date: Mon, 30 Jun 2025 03:11:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686262d3.a70a0220.d08a1.0002.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: in transaction restart:
 transaction_restart_mem_realloced, last restarted by
From: syzbot <syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f02769e7f272 Merge tag 'devicetree-fixes-for-6.16-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133b83d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79da270cec5ffd65
dashboard link: https://syzkaller.appspot.com/bug?extid=cc7567f096079cb4146f
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f02769e7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a454895505b7/vmlinux-f02769e7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b5db986999e9/bzImage-f02769e7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc7567f096079cb4146f@syzkaller.appspotmail.com

bcachefs (loop0): root directory missing, fixing
 done
bcachefs (loop0): check_unreachable_inodes...
bcachefs (loop0): unreachable inode:
  inum: 4100:4294967295 
    mode=40755
    flags=(4300000)
    journal_seq=23
    hash_seed=f497c5e8402f7aa5
    hash_type=siphash
    bi_size=0
    bi_sectors=0
    bi_version=0
    bi_atime=36304197331961109
    bi_ctime=36304197331961109
    bi_mtime=36304197331961109
    bi_otime=36304197331961109
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
    bi_dir_offset=0
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
bcachefs (loop0): creating (disconnected)/lost+found in subvol 1 snapshot 4294967295
bcachefs (loop0): creating (disconnected)/lost+found in subvol 1 snapshot 4294967295
bcachefs (loop0): creating (disconnected)/lost+found in subvol 1 snapshot 4294967295
bcachefs (loop0): creating (disconnected)/lost+found in subvol 1 snapshot 4294967295
bcachefs (loop0): creating (disconnected)/lost+found in subvol 1 snapshot 4294967295
 done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure...
bcachefs (loop0): directory structure loop:
  4100:4294967295 4096:4294967295 4096:4294967295, fixing
Kernel panic - not syncing: in transaction restart: transaction_restart_mem_realloced, last restarted by
[<0>] btree_trans_restart_ip fs/bcachefs/btree_iter.h:364 [inline]
[<0>] __bch2_trans_kmalloc+0x5d7/0xc80 fs/bcachefs/btree_iter.c:3216
[<0>] bch2_trans_kmalloc_ip fs/bcachefs/btree_iter.h:604 [inline]
[<0>] bch2_trans_kmalloc fs/bcachefs/btree_iter.h:616 [inline]
[<0>] bch2_hash_delete_at fs/bcachefs/str_hash.h:364 [inline]
[<0>] bch2_fsck_remove_dirent+0x1032/0x12a0 fs/bcachefs/dirent.c:756
[<0>] remove_backpointer+0x1fe/0x280 fs/bcachefs/fsck.c:502
[<0>] check_path_loop fs/bcachefs/fsck.c:2700 [inline]
[<0>] bch2_check_directory_structure+0x1a7f/0x1f00 fs/bcachefs/fsck.c:2733
[<0>] bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:485 [inline]
[<0>] __bch2_run_recovery_passes+0x392/0x1010 fs/bcachefs/recovery_passes.c:540
[<0>] bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:611
[<0>] bch2_fs_recovery+0x25fd/0x3950 fs/bcachefs/recovery.c:989
[<0>] bch2_fs_start+0xa99/0xd90 fs/bcachefs/super.c:1203
[<0>] bch2_fs_get_tree+0xb02/0x14f0 fs/bcachefs/fs.c:2489
[<0>] vfs_get_tree+0x92/0x2b0 fs/super.c:1804
[<0>] do_new_mount+0x24a/0xa40 fs/namespace.c:3902
[<0>] do_mount fs/namespace.c:4239 [inline]
[<0>] __do_sys_mount fs/namespace.c:4450 [inline]
[<0>] __se_sys_mount+0x317/0x410 fs/namespace.c:4427
[<0>] do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
[<0>] do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
[<0>] entry_SYSCALL_64_after_hwframe+0x77/0x7f
CPU: 0 UID: 0 PID: 5318 Comm: syz.0.0 Not tainted 6.16.0-rc3-syzkaller-00121-gf02769e7f272 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x99/0x250 lib/dump_stack.c:120
 panic+0x2db/0x790 kernel/panic.c:382
 bch2_trans_in_restart_error+0xdb/0x110 fs/bcachefs/btree_iter.c:1455
 bch2_trans_unlocked_or_in_restart_error+0xc2/0x110 fs/bcachefs/btree_iter.c:1468
 bch2_trans_verify_not_unlocked_or_in_restart fs/bcachefs/btree_iter.h:344 [inline]
 bch2_path_get+0x108c/0x1540 fs/bcachefs/btree_iter.c:1747
 bch2_trans_iter_init_common fs/bcachefs/btree_iter.h:529 [inline]
 bch2_trans_iter_init fs/bcachefs/btree_iter.h:543 [inline]
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:631 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:646 [inline]
 bch2_bi_depth_renumber_one fs/bcachefs/fsck.c:2573 [inline]
 bch2_bi_depth_renumber fs/bcachefs/fsck.c:2599 [inline]
 check_path_loop fs/bcachefs/fsck.c:2717 [inline]
 bch2_check_directory_structure+0x1376/0x1f00 fs/bcachefs/fsck.c:2733
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:485 [inline]
 __bch2_run_recovery_passes+0x392/0x1010 fs/bcachefs/recovery_passes.c:540
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:611
 bch2_fs_recovery+0x25fd/0x3950 fs/bcachefs/recovery.c:989
 bch2_fs_start+0xa99/0xd90 fs/bcachefs/super.c:1203
 bch2_fs_get_tree+0xb02/0x14f0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f338f9900ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f339072ee68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f339072eef0 RCX: 00007f338f9900ca
RDX: 0000200000000040 RSI: 0000200000000000 RDI: 00007f339072eeb0
RBP: 0000200000000040 R08: 00007f339072eef0 R09: 0000000000204000
R10: 0000000000204000 R11: 0000000000000246 R12: 0000200000000000
R13: 00007f339072eeb0 R14: 000000000000598c R15: 0000200000000100
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


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
