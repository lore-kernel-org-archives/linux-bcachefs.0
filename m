Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2897E184E
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 04:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716785487; cv=none; b=BcM2zp4k+UNzk8ni6QlSwRqt4NfqjS8Cb4dFlEhLGZOurYDLf3IEB93Cfys5ah4Uolx8Swzn6CFxu+EdXGvAKNiM/qNu4ifJd+Wa45ihWPGA3g4dXqmuf6LZ6DOukyFg0dMQf4Hexqyd6AM1Chbc4oYLsXtQII0Vxd+eCMe86rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716785487; c=relaxed/simple;
	bh=ZoE7narg4J1YWIp8aSQpsODB7MpHvESq9E6xWfbz4rQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NNQiWoMN1vtdbm05E7bfSdyukVbvS+Hjky1RcahHpfrSQqO5KwvqnBA3E671iwb6v/OmM4EY1a1yMkGDwcyCHBe7TW2Iay/Y4VOOIecl31HpdbRnIy/uOTQ7lE1JliD2e6oHGbHTkTfuuBYmq/MH8+5fnYmwn069m+3b7PzHdLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7eaa9ddad99so149407039f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 26 May 2024 21:51:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716785485; x=1717390285;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpUjp5fS64Ntq/6J/v5RR7cXt7c7XY9Z7Qnv9gif+00=;
        b=JxtG1FS+FZ2i9ZsH72EPhl1a4CmuZfg7N2UBwfaJNqcLiqX+rnbwCY4HRA0mMhKNM0
         elPNa4p6T0Y9vkpC6sMyi8Z5P9AOR04vFvz9QH596X8p6SgDTZYQh7PZR4wJta+WK+Y4
         oJhfhXiHLPtqyOA+OIIe89EpmiEHIZN1cjkrqc3odqsUX9UVzIUfeH7hlm1f52TmgviI
         7wF5Cj5U85kr1LVcXTh0NB1SHLBMB8VWhp5SAVr/xFXc/ZQ3x9F+YlFQ1d0HEjIQEMEl
         QKQywwuPL2J7Qh+K4j/c7YPqz+WQrsc6fBIMfv29Hvg5MZemH/ZJi2nuJPDZbisyzxTs
         jxRw==
X-Forwarded-Encrypted: i=1; AJvYcCV2eMqKpm2HHsIraZs61BIHBh7sYjV5FXu9NSncfhy1Hij1Aw4PbImGKeOLvWyYBzKlHe3qCkXto0cAxPWCtmPdyp52XDrtUGZ8pzG8FBM=
X-Gm-Message-State: AOJu0Yzcnr5kZbMdSD8tZJW1n0r0UBtemr2y4zMXgWw+b9gYv+0poFkk
	5elVY5v08QKsuGykdbmcOMfAyQW5ozVRf2mMvEsGcSsStjLq+iFftVeHLuKh4JPRQfh/uEzw1Yh
	Y+owVwIM4WQ+AE9IDBKtdOKZHF4G6omux25Mb6MjVqKMuTqq3edhrlKY=
X-Google-Smtp-Source: AGHT+IEuP1KOxwcqbolWlRhggi+ELse9IUArdHOJ8hEoOY5wvt8WC+LQRVMhSLC8vnhX7RwRotUSXU7S1P/R4NswySEoXjY3PUND
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1563:b0:36d:cef6:7c8c with SMTP id
 e9e14a558f8ab-3737b423053mr6386955ab.5.1716785485308; Sun, 26 May 2024
 21:51:25 -0700 (PDT)
Date: Sun, 26 May 2024 21:51:25 -0700
In-Reply-To: <000000000000fd5e7006191f78dc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000001f1c3061968450e@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_iter_init
From: syzbot <syzbot+f321ecc68453b9ac9bff@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11daa71a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=f321ecc68453b9ac9bff
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16de2ee8980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d696dc980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/73fc1c49d3bd/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f321ecc68453b9ac9bff@syzkaller.appspotmail.com

bcachefs (loop0): shutting down
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
 ptrace_notify+0x304/0x320 kernel/signal.c:2404
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0x14e/0x3e0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x135/0x160 kernel/entry/common.c:218
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

CPU: 0 PID: 5043 Comm: syz-executor855 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
