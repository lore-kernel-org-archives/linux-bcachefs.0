Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A316B405FB
	for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731833662; cv=none; b=N8BAJqSmKc6qPN6/UYyOae3HEVIjE+Px9+iuIZlIm5/EeAHYyMSSKg/s8MjmlZDnfTLlatmOIFHG2FlPG4qzi3mi5QjlBOJwywXLnwp+STBXEhQ1iLykdqrDGMlCkAX+731wCh6HWMo5jjVdCRSLxO0Cv/iG52A/VCrJoq7gtxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731833662; c=relaxed/simple;
	bh=hNGFVYc72UO2mgeYU91sQC9+fOs2EG6RcJDDBMnf61U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=B9PsQodgnM1IFLxuMjx5+ZYL5Gu0crsbPLFr1lc8aPzUvwoNTM9W/0tPZn6zFJ9uJ8vOMrzzvHH6fkwcbMU4tXb/9TEdCTN9FYHQ8YCL2qbwDmdogJXXmkdyyfHcTgoEtN2B0EyFDSUnNc+RlZCDO0wKzXrIrqdsThaJ95XVI8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a743d76ed9so23894795ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 17 Nov 2024 00:54:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731833660; x=1732438460;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gpW9XoTRggzdMzhtPVMqmJUsWCL+vzGqsCdnm2YZVOw=;
        b=qs1bnAbVPrBHXvC1Xee/oC+bYu0A2SqQs03YIz+jSDxt4VU4olMyyXWYxHFEfBJ/ua
         FZWVZPFQhUrXtBk0h60uBo1KMaPqM7GXr5HNA/Ml1QjJF3sQNjmjHh8vM0dBi4Ajvd+0
         liQLZuKUs5UN53s5JKJZvjTzHCPZ17cA4shL+WtEpP2U1zcXkg+qpyn7fi4NQow+Eo0f
         6clrXShJ3L7MfAA19+OeiqO/PCxO8CNTOxCbuiEtm43Ak7Ct4RraBiHdxHmBuwzBSwOv
         qEj0N8Nz4H6uYllUSbUu7t+J7fEoKLwz7UeUK6vpNXiBEi3IlVew2BcL/EuXqsxzUZ0W
         G0Lw==
X-Forwarded-Encrypted: i=1; AJvYcCX3stRiLmuilRtTx5V6WRomsWMy4no8TbkPD6CMhbwG5oZQGJVrsgfy73SXIedwjrQfkrxHsrT4gCZrT7pm8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1cFPI8uRMyQL15VFmz0IkUuX3Ikq3fck90BbPpAN3vnhEnegK
	FSzW2yfRjCt3v1f2jM+YcHtSb9+PMI5q2EE80w6pUadennJ404ii+58k3yMWUJYCWx/zWYtp2Bi
	P/tsgOnw76jRBj+Y35hjgc+7hm/L2W2PEIUgEpkFzJlSBiqees8fRc6w=
X-Google-Smtp-Source: AGHT+IHu623/lRAwEWD8F2FQ5xQOyFBtiD7P9n4iWXZr6YNynbDCcNdLZ9sldIRp70gwoMaFQlnGfLswlX+qT5x2qw6cET/AWHq5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3f0b:b0:3a0:9c04:8047 with SMTP id
 e9e14a558f8ab-3a746f7ee2emr76584325ab.6.1731833659951; Sun, 17 Nov 2024
 00:54:19 -0800 (PST)
Date: Sun, 17 Nov 2024 00:54:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6739af3b.050a0220.87769.0008.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_iter_init (2)
From: syzbot <syzbot+62f5ae3a10a9e97accd4@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3022e9d00ebe Merge tag 'sched_ext-for-6.12-rc7-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=162341a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcca673786a14715
dashboard link: https://syzkaller.appspot.com/bug?extid=62f5ae3a10a9e97accd4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/937339c4ba17/disk-3022e9d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/23acd73c301b/vmlinux-3022e9d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66d14471611f/bzImage-3022e9d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+62f5ae3a10a9e97accd4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bkey_cmp_p_or_unp fs/bcachefs/bset.h:287 [inline]
BUG: KMSAN: uninit-value in bkey_iter_cmp_p_or_unp fs/bcachefs/bset.h:400 [inline]
BUG: KMSAN: uninit-value in bch2_bset_search_linear fs/bcachefs/bset.c:1189 [inline]
BUG: KMSAN: uninit-value in bch2_btree_node_iter_init+0x319a/0x51a0 fs/bcachefs/bset.c:1334
 bkey_cmp_p_or_unp fs/bcachefs/bset.h:287 [inline]
 bkey_iter_cmp_p_or_unp fs/bcachefs/bset.h:400 [inline]
 bch2_bset_search_linear fs/bcachefs/bset.c:1189 [inline]
 bch2_btree_node_iter_init+0x319a/0x51a0 fs/bcachefs/bset.c:1334
 __btree_path_level_init fs/bcachefs/btree_iter.c:615 [inline]
 bch2_btree_path_level_init+0x821/0xc80 fs/bcachefs/btree_iter.c:635
 btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
 bch2_btree_path_traverse_one+0x379d/0x47b0 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_traverse+0xaf9/0x1020 fs/bcachefs/btree_iter.c:1880
 bch2_btree_node_update_key_get_iter+0x15c/0x9e0 fs/bcachefs/btree_update_interior.c:2481
 btree_node_write_work+0xb37/0x15a0 fs/bcachefs/btree_io.c:1874
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
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

CPU: 0 UID: 0 PID: 43 Comm: kworker/0:1H Not tainted 6.12.0-rc7-syzkaller-00012-g3022e9d00ebe #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Workqueue: bcachefs_btree_io btree_node_write_work
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
