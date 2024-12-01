Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CACC7641E
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Dec 2024 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733046030; cv=none; b=JG/1C940Ayyh+E08dMNDJOT35QelkSSPgESBk/wGTaEczGdGJV9vmLk6fYPgl5ZK+bubANBaq8mt+u9pAO8JwcoFRPM5cvMw+uikatRjP/4I/AJorvm3xlf8tWZhbuWg3KbOa25Buw4Uvzg+vboN3w0HcavMtNn6+CHGwSBpgt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733046030; c=relaxed/simple;
	bh=qKjMqBAwBGQ5vd/R1CCxn/JZSm+JPzWecVHphKP7h4w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FC8TO4Ho2niquaWOaaf010HChqYFdN4gXwfbZzY5CcQCJUw2rSC4z62hMcQNzMoleZ+vk0ffucJBxwBBc8VrGOxDB1O03CT1r437/H8dYhpiPtjyPD4VwMfBczFMP80PKnLQe/Cm0AuIh30xx/YNVyRyC1P6Rm0Iu9jJvyZxppw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7d87dfd9bso24571035ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Dec 2024 01:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733046028; x=1733650828;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+64qH9DDZzuxbucfu1Sho8Z4RI5Z31rvkXDXs5UDVl4=;
        b=mGYRtnGsjtYoLYA9pla+AKJtyszj8/ca7EWdI9rdz9sj+OqO83w69diq07Kd9R8t6S
         aMXsQWAjcCH3+mPzy/ZjQ9dy7J77+P/GFo/BEtz47kqTLqDo5jgoE1bZ6SPlMG2l7LP5
         8piD9LuCMdFGsa0L+Wiqd8LlbCsKp/WynYK/bUWRFFnNqZ2XkYg5HOkUNjJ9khv5hkue
         AY+Bwqe2M0p8rQ/mQGlUWbM0SOzgHQP5MSNLg0nNgQx7ij+/kXgENzGTyke5lwVa0Znl
         gM6+s//O4IIN8i1ZGpSYfFwyJz+aOjz62NMYykEx3U43c7wUHgFiZqAyBdYTTKJbSvtH
         g8bg==
X-Forwarded-Encrypted: i=1; AJvYcCUNN8MV0w+iWY1wxHWp5tax+zVt85F+rJp8BjlhhjUjSHWWPiVGOd8rB6v1EUElNgudzr3LnsqGqo4lOZtnNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIyr3FytS1caA8CqhKlbWjFdceF/Akl5ZWtLuUesbGJw20j+33
	/BBF79iZHGyOJC1JaoHJjey6+LUNwkX+TCXzudeoTY34aV50tyeJqCyqsBYg4E9ibal89kMwJWu
	nVIGtVUtOT/+oWkfgr2lKzc35wM/EpRrR/RtycCZEvA9xduOfVRlczFU=
X-Google-Smtp-Source: AGHT+IGDiNuUUIalgJyuZHIVSQ2zuj8QXA5Kx819ZDCVFfz+xg/47lmSa0bz5pirnJa6Bf2E2iag8fkFRfNdn/fgcF9HC6Z3jU34
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ca:b0:3a7:81c6:be7e with SMTP id
 e9e14a558f8ab-3a7c5580433mr146839775ab.13.1733046028528; Sun, 01 Dec 2024
 01:40:28 -0800 (PST)
Date: Sun, 01 Dec 2024 01:40:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674c2f0c.050a0220.ad585.0034.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_get
From: syzbot <syzbot+2b2046c73fcb7e6a0e4e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    445d9f05fa14 Merge tag 'nfsd-6.13' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112afff7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5486b9d7cc64830
dashboard link: https://syzkaller.appspot.com/bug?extid=2b2046c73fcb7e6a0e4e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7024ceac9339/disk-445d9f05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ebf50afbcd15/vmlinux-445d9f05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e60e080ed9e/bzImage-445d9f05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b2046c73fcb7e6a0e4e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_btree_node_get+0x605/0x18b0 fs/bcachefs/btree_cache.c:1180
 bch2_btree_node_get+0x605/0x18b0 fs/bcachefs/btree_cache.c:1180
 btree_path_down fs/bcachefs/btree_iter.c:956 [inline]
 bch2_btree_path_traverse_one+0x2c34/0x47b0 fs/bcachefs/btree_iter.c:1182
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_node+0x2c5/0x15d0 fs/bcachefs/btree_iter.c:1901
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2218 [inline]
 async_btree_node_rewrite_work+0x29d/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:513 [inline]
 bch2_bkey_buf_reassemble fs/bcachefs/bkey_buf.h:28 [inline]
 btree_node_iter_and_journal_peek+0x866/0x2520 fs/bcachefs/btree_iter.c:898
 btree_path_down fs/bcachefs/btree_iter.c:927 [inline]
 bch2_btree_path_traverse_one+0x254c/0x47b0 fs/bcachefs/btree_iter.c:1182
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_node+0x2c5/0x15d0 fs/bcachefs/btree_iter.c:1901
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2218 [inline]
 async_btree_node_rewrite_work+0x29d/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_node_data_alloc fs/bcachefs/btree_cache.c:153 [inline]
 bch2_btree_node_mem_alloc+0xa72/0x2ee0 fs/bcachefs/btree_cache.c:832
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:321 [inline]
 bch2_btree_reserve_get+0x37f/0x2290 fs/bcachefs/btree_update_interior.c:549
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1247
 bch2_btree_split_leaf+0x120/0xc00 fs/bcachefs/btree_update_interior.c:1856
 bch2_trans_commit_error+0x1c0/0x1d60 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x210f/0xd190 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_journal_replay+0x2e3d/0x4d30 fs/bcachefs/recovery.c:317
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:191 [inline]
 bch2_run_recovery_passes+0xaf9/0xf80 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x447b/0x5b00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x13ea/0x22d0 fs/bcachefs/fs.c:2170
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __ia32_sys_mount+0xe3/0x150 fs/namespace.c:4034
 ia32_sys_call+0x260e/0x4180 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 7199 Comm: kworker/u8:2 Tainted: G        W          6.12.0-syzkaller-09734-g445d9f05fa14 #0
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
=====================================================


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
