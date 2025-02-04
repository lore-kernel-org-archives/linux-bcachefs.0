Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85684214207
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Feb 2025 15:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683205; cv=none; b=l1KvIeysPdcLD5ByEIUBS/897HwwTmjA4fC+0Ab4tBP4Kmym8RJnJihZU3NfxMEXmLzbv9vzxX5dgPurUIwohC1vQa84LC3dzVN6+dqcjVI9O51dysW2Lvf41urabDRtTg3A9elghiI+bYapj/Yv5phrDV9scczT2OP3GJ+6RwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683205; c=relaxed/simple;
	bh=WRA/WKB/1cX5TzaHrN/TTlXTa6s9rZhFqhteluIY7+E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ArjfN5rKgQ3NOgwyJYBDCn7hAUv2fInctuppV2bFx1ek6gtBXxLE+0ycHEfQLPlIYv4OYHsKT/xglHgJLC1GvdYXDr6QA4FPlipcCD8+SVpOsCxfUiTJ/+oAsSUqDmolfwTKKVCkZflrzYhhQE97C5/CbYvxebrNwzD5LketWmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d04b390e9cso1877285ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 07:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738683202; x=1739288002;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M9hgVt0Dd3cwy31/EVS6hXGly9CDwHG3tCjvJcgmtDk=;
        b=XxCA3iHhSHI8QRm0rQV5IehWXcas6NVGxzC+y4oWr2wLcLUlTibjdx8u2lYHWW/tp0
         xkUXYxUPnUFUBy3Adlvw2eWNmNrEEqKcCr4yaWc1ufJYD/nV0gYS/NWLzlYHeI80RQKb
         3rjsGk3V5L97NgR09bv51pjUrp1vqNQbG8COXm8qn+oZZkvbEAcgJkEck3irOo6My8KW
         vvkqFnRJPhEKNTNxRYjlKYH7rX7z6d0COUjPHSJI7Du+uAWCSV9s2Km1d58YrP7isUxz
         /ZbBXZJIK+lmRENIKgspiVHe+SZtos47kiQZeYWzg1WnQhV93vKvB3Md9dojXsd4Eezb
         /P2g==
X-Forwarded-Encrypted: i=1; AJvYcCV6x2H30yrwP/YiPJviMKuNRQY8YoVTmRYMeKfEK/6LhDqr4eOC+fT8yzmsHm5mgT9Do28CL7PT3JKJ0cUWjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFCDmG5wHLJvhKLWIAKyyBbhAEsKjsjf0Rz8GF1zU4jVx+wOlm
	4DnBQkdRZ67e2Q6rt/fzZDwjMBiXcm9WCRGSjjyHfSdfUwLcD1eg72IysipfTzjuxY6C/WMtFCS
	UDPj4us1rMHjMR1zkd24V7hFw9bBb1uUNyp+/RU5dLwOAl9UWmruPJxg=
X-Google-Smtp-Source: AGHT+IFo0UwLrMpFRAOVkM7R/lQuwAlbFXvVQVfQo3o/ge/i6wfW/Vyy97mNiF1LYm7jpjCZkbgQcw9/TVVKRoHpvUAd+LibQOUX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2195:b0:3d0:23f6:2eed with SMTP id
 e9e14a558f8ab-3d023f63111mr93122455ab.11.1738683202135; Tue, 04 Feb 2025
 07:33:22 -0800 (PST)
Date: Tue, 04 Feb 2025 07:33:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a23342.050a0220.163cdc.006b.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_ptr_v2_validate
From: syzbot <syzbot+655143dc5f99972b52e6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=110078a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f20bce78db15972a
dashboard link: https://syzkaller.appspot.com/bug?extid=655143dc5f99972b52e6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c74f64580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c74f64580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b06dbcd0bfdc/disk-0de63bb7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bc7060cef2b6/vmlinux-0de63bb7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3578d0574f33/bzImage-0de63bb7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/eec1bd50a821/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+655143dc5f99972b52e6@syzkaller.appspotmail.com

bucket incorrectly unset in freespace btree
  u64s 5 type deleted 0:29:0 len 0 ver 0, , continuing
=====================================================
BUG: KMSAN: uninit-value in bpos_le fs/bcachefs/bkey.h:113 [inline]
BUG: KMSAN: uninit-value in bpos_ge fs/bcachefs/bkey.h:125 [inline]
BUG: KMSAN: uninit-value in bch2_btree_ptr_v2_validate+0x51c/0xb20 fs/bcachefs/extents.c:211
 bpos_le fs/bcachefs/bkey.h:113 [inline]
 bpos_ge fs/bcachefs/bkey.h:125 [inline]
 bch2_btree_ptr_v2_validate+0x51c/0xb20 fs/bcachefs/extents.c:211
 bch2_bkey_val_validate+0x357/0x530 fs/bcachefs/bkey_methods.c:143
 btree_node_bkey_val_validate fs/bcachefs/btree_io.c:838 [inline]
 bset_key_validate fs/bcachefs/btree_io.c:859 [inline]
 validate_bset_keys+0x20e3/0x2350 fs/bcachefs/btree_io.c:942
 validate_bset_for_write+0x2b3/0x410 fs/bcachefs/btree_io.c:1987
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2197
 bch2_btree_node_write_trans+0xd7/0x890 fs/bcachefs/btree_io.c:2357
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:816 [inline]
 btree_interior_update_work+0x3e3f/0x4820 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3317
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3398
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:416 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:40 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x17d1/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2140
 bch2_btree_node_write_trans+0xd7/0x890 fs/bcachefs/btree_io.c:2357
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:816 [inline]
 btree_interior_update_work+0x3e3f/0x4820 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3317
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3398
 kthread+0x6b9/0xef0 kernel/kthread.c:464
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4249
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4266
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4300
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:662
 btree_node_data_alloc fs/bcachefs/btree_cache.c:156 [inline]
 bch2_btree_node_mem_alloc+0xa72/0x2ee0 fs/bcachefs/btree_cache.c:834
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:304 [inline]
 bch2_btree_reserve_get+0x37f/0x2290 fs/bcachefs/btree_update_interior.c:532
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1230
 bch2_btree_split_leaf+0x120/0xc90 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x1c0/0x1d60 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x1d60/0xd310 fs/bcachefs/btree_trans_commit.c:1085
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 bch2_journal_replay+0x3082/0x4d30 fs/bcachefs/recovery.c:373
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:226 [inline]
 bch2_run_recovery_passes+0x5a2/0x1160 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x489c/0x6230 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x7ca/0xc20 fs/bcachefs/super.c:1030
 bch2_fs_get_tree+0x143a/0x2330 fs/bcachefs/fs.c:2203
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3560
 path_mount+0x742/0x1f10 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x71f/0x800 fs/namespace.c:4088
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:4088
 x64_sys_call+0x39bf/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 1092 Comm: kworker/u8:7 Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: btree_update btree_interior_update_work
=====================================================


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
