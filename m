Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF2F3FB31
	for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731833662; cv=none; b=KTkE8QwEtJ97fNLBzgln84uXM7gh7qZyNRxgjQywutOpErdqxVceJYTCgt+u8t7I9wO5lVsilL8aHX+1n8GvrONoD0BjLBzyMzRCzU6K5j3wZyYGCdztDpaAouNexxsDKkaoJBZbnhHLgYl3nFm1FYtQynrMJj95cCVrjB4nFtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731833662; c=relaxed/simple;
	bh=eW7ZTuGgTxVbD9YJouOvUERPiC9b5acU+NvaGEjE3D0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iPU6CwnwQQTH0VjKXFXVN/aIRNu0+my5yR9QbeCRmeDqFtpXl/YpEGtA7gRw6Ege3A+2BTtYIXL8lXdijlSLIsoBMnfGmjh0TS125WmEAvMcPLHsIxqi3vtymVCt3bNXLmrZEE6jPHUhq7dVGUAm7luF8WLTLor/P/I5qHel3Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ab434c629so95534339f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 00:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731833659; x=1732438459;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DEtI0Z1ytAIIQ+OsrJeQ49AClVM0w20ckGZyyuMEl9Y=;
        b=wVowt56PIeAcnyOzO1gXmUqQsJaT3QwgGcAcHzsdG1G1H1/tx2fZHsWass10VMRoUv
         67dHfz8wGeUfToMFcCtnk9cmZkR67RUP5YBGoGkgmglTCbh1YGoodg85IPv6OOvqT9Lx
         GBUM/ubUf8VuqzzLVCkIFmQkgNfmMsYydSSsIGGUNtSX6oezKZLX2oHOtz5FU3i2QMuA
         yNdXGfIP0ePs9MP6vnLPPTYdvlLv7AAUIlqkILOSFukTtzOuvs1LJx9M9fMXl4guOYwo
         nhKfFcN6MmXB8EDs2RRbRdK81K8pRWbqP5F15xmTGDO3SnjSvjdRBxtrrbvQR4kTqxEV
         lRPw==
X-Forwarded-Encrypted: i=1; AJvYcCXJSq9R/EDB9SgBB2shDaB4eYzqnzqQidRQagKJ9pcsX80veo4EFtess6s+4+um+W5ZKES+KCwMtj6xXWcGcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YylRJNI73YQP7+roZMRYad7siKFPuflA+6Svrob44a+WS9YW8uX
	z4SojkapdDVzsdRDR+O6vmer0n6g2PKbL6Jb+BA2XAnaPzfYoOL+iiy3ZGncVUkIcZBaJ8ELk7Z
	7Oa31aBCdhh+2enTBw7rgvUGmw4KkUEU3cESiE4pEFXouFxs59bJrap4=
X-Google-Smtp-Source: AGHT+IEBT33y/mdzg5BZxsKfEL8O2ghZhGIuAs4E2z4BmLZQieXaepLs18dEW08L7HQy+bBE3Bdt+g65W1LrU2jKoCb3W9cAHtJS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219e:b0:3a3:b45b:fb92 with SMTP id
 e9e14a558f8ab-3a7480d5657mr69307185ab.23.1731833659626; Sun, 17 Nov 2024
 00:54:19 -0800 (PST)
Date: Sun, 17 Nov 2024 00:54:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6739af3b.050a0220.87769.0007.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_alloc_v4_validate (2)
From: syzbot <syzbot+8dd95f470e7cd0ff4b66@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3022e9d00ebe Merge tag 'sched_ext-for-6.12-rc7-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175f0df7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcca673786a14715
dashboard link: https://syzkaller.appspot.com/bug?extid=8dd95f470e7cd0ff4b66
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/937339c4ba17/disk-3022e9d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/23acd73c301b/vmlinux-3022e9d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66d14471611f/bzImage-3022e9d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8dd95f470e7cd0ff4b66@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_v4_validate+0x739/0x19a0 fs/bcachefs/alloc_background.c:249
 bch2_alloc_v4_validate+0x739/0x19a0 fs/bcachefs/alloc_background.c:249
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:845 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:914
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1946
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2156
 bch2_btree_node_write+0x256/0x2e0 fs/bcachefs/btree_io.c:2300
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 bch2_alloc_v4_validate+0x27f/0x19a0 fs/bcachefs/alloc_background.c:247
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:845 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:914
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1946
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2156
 bch2_btree_node_write+0x256/0x2e0 fs/bcachefs/btree_io.c:2300
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x16af/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2099
 bch2_btree_node_write+0x256/0x2e0 fs/bcachefs/btree_io.c:2300
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4219
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4236
 __do_kmalloc_node mm/slub.c:4252 [inline]
 __kmalloc_node_noprof+0x9d6/0xf50 mm/slub.c:4270
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:658
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2252
 bch2_btree_node_prep_for_write+0x494/0x720 fs/bcachefs/btree_trans_commit.c:93
 bch2_trans_lock_write+0x7ef/0xc00 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x31c4/0xd190 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_journal_replay+0x2e3d/0x4d30 fs/bcachefs/recovery.c:317
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:185 [inline]
 bch2_run_recovery_passes+0xaf9/0xf80 fs/bcachefs/recovery_passes.c:238
 bch2_fs_recovery+0x447b/0x5b00 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x13ea/0x22d0 fs/bcachefs/fs.c:2170
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __ia32_sys_mount+0xe3/0x150 fs/namespace.c:4034
 ia32_sys_call+0x2530/0x40d0 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 12680 Comm: bch-reclaim/loo Not tainted 6.12.0-rc7-syzkaller-00012-g3022e9d00ebe #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
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
