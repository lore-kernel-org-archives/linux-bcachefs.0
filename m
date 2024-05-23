Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57181E892
	for <linux-bcachefs@vger.kernel.org>; Thu, 23 May 2024 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716472828; cv=none; b=b0Jw9BceJWKJZNZ3s8FHlcgdGrQ5JfFFKoDlYTn6c5ztqoLaUyOkYxNQjOi3ZtRNEEdcPODokeVUl7KWyw1B6CrQsoRJNvSh6SAugYM988RhJ8l1pV266eMyrdpkauNfae38Mcc8mVTBFfViwslMAFeqeuFY7lwwsIwGvOsUB+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716472828; c=relaxed/simple;
	bh=+Sa4jCx3HrYSmQS58xyuCJKHDHKorezGCcy0lXHcE1A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=msC4syBkCu4nVpQdx+UI79+4HLZ68z+FDA1qOkNou4e8ob/ljjJaACUVPyeXqY0BfDK20EIYPdqnRQ33jjIcZ4VQVyqVRcpx6jgLBLNKjVmfLFzhOlYNswNXVKotGz5cufmwA/87LWE3ZuK24MbEzp2DK0Vex8gacIxOTj03g1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e1d3e81a00so174037639f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 23 May 2024 07:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716472826; x=1717077626;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzgIGrD05RdoTuhWxY3GayxZfeAK6Q+wyCgJXMUbQWA=;
        b=PLb7g29WzrJyXQADpYAq1/ea/fBRP/+YHrjMy0Nxa0zC2LMVEFRGtkZ28aCT+pFRcL
         SjJ6RlO21SXEoP+Eey1G8bxJtKe995PRg32HFXPc8BLX0hc3tKihX3MA4851n0TejL5W
         J+AkIjrBs1VepOEY9gSdIDGgRZdNqbvmC4cyzBqGvznlF33J6nzB11Dtz2Dy1aQziIQz
         J9hK49rPFJPm9DvppHT6mkKItSy9v0sTb646zLw9ETFYugXPHXu04fV63/Cmn4DouCtU
         OV65oEIaKE+sDgYiTqDaMwW7n6BU9/Tj/3MWEtVMsnlzUSIVKy0fogGnfj967yLkbb1h
         oA/A==
X-Forwarded-Encrypted: i=1; AJvYcCVA68C+AJ2qLqfX9AU6U/Jc3KdUAZ6tG9h5zT0t4qjCFnqo1wQetra/sn8oHKgJOOpVD5+jU5bXf/rDCYzD90/+AU/9OOepr/ieY17hsCc=
X-Gm-Message-State: AOJu0YwWOyZ1pE942+T0vyHex7L3tfa/yYCn3VAT7+tqqlPtdBRNlZ9n
	yLscf4dbl6tR11v3GEzNGqQAtv3hYouQyv0TDDGPiAQJ2Sh8pMpYHowfjIOgeV14gAUyBCWTntt
	fTOFAh4sQMYKnIr5I+J+0H5mFgkc4zrYdDZAyQjM9popLju6wO2FyP/s=
X-Google-Smtp-Source: AGHT+IFDXZ2H09q2l1hj9W4Eezn14AzgsiwirmklrzVlugz4/ZOjgAwpzVNf/2C+ZB1bwjOjXuwtzZdXkK8yhhcJMIz6aQRi6wAT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:ad09:0:b0:488:ac5a:7fe9 with SMTP id
 8926c6da1cb9f-4afe3c6bb4fmr81463173.4.1716472824809; Thu, 23 May 2024
 07:00:24 -0700 (PDT)
Date: Thu, 23 May 2024 07:00:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd5e7006191f78dc@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_iter_init
From: syzbot <syzbot+f321ecc68453b9ac9bff@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1180fbb2980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=f321ecc68453b9ac9bff
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f321ecc68453b9ac9bff@syzkaller.appspotmail.com

bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 12
=====================================================
BUG: KMSAN: uninit-value in bkey_cmp_p_or_unp fs/bcachefs/bset.h:284 [inline]
BUG: KMSAN: uninit-value in bkey_iter_cmp_p_or_unp fs/bcachefs/bset.h:398 [inline]
BUG: KMSAN: uninit-value in bch2_bset_search_linear fs/bcachefs/bset.c:1217 [inline]
BUG: KMSAN: uninit-value in bch2_btree_node_iter_init+0x3237/0x5280 fs/bcachefs/bset.c:1362
 bkey_cmp_p_or_unp fs/bcachefs/bset.h:284 [inline]
 bkey_iter_cmp_p_or_unp fs/bcachefs/bset.h:398 [inline]
 bch2_bset_search_linear fs/bcachefs/bset.c:1217 [inline]
 bch2_btree_node_iter_init+0x3237/0x5280 fs/bcachefs/bset.c:1362
 __btree_path_level_init fs/bcachefs/btree_iter.c:627 [inline]
 bch2_btree_path_level_init+0x821/0xc80 fs/bcachefs/btree_iter.c:647
 btree_path_lock_root fs/bcachefs/btree_iter.c:781 [inline]
 bch2_btree_path_traverse_one+0x46e8/0x5290 fs/bcachefs/btree_iter.c:1178
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:225 [inline]
 bch2_btree_iter_traverse+0x99f/0xe90 fs/bcachefs/btree_iter.c:1741
 btree_key_cache_flush_pos fs/bcachefs/btree_key_cache.c:667 [inline]
 bch2_btree_key_cache_journal_flush+0xf8d/0x1990 fs/bcachefs/btree_key_cache.c:748
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 journal_flush_done+0xe1/0x3f0 fs/bcachefs/journal_reclaim.c:806
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:839
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x1b9/0x750 fs/bcachefs/super.c:277
 bch2_fs_read_only+0xcb4/0x1540 fs/bcachefs/super.c:357
 __bch2_fs_stop+0x112/0x6f0 fs/bcachefs/super.c:622
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:1791
 generic_shutdown_super+0x194/0x4c0 fs/super.c:641
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2015
 deactivate_locked_super+0xe0/0x3f0 fs/super.c:472
 deactivate_super+0x14f/0x160 fs/super.c:505
 cleanup_mnt+0x6c6/0x730 fs/namespace.c:1267
 __cleanup_mnt+0x22/0x30 fs/namespace.c:1274
 task_work_run+0x268/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x160 kernel/entry/common.c:218
 do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3994
 __do_kmalloc_node mm/slub.c:4027 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:4046
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
 bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7b6a/0x93e0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x152a/0x15f0 fs/bcachefs/super.c:2105
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1906
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 PID: 5074 Comm: syz-executor.0 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
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
