Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8D66CDAC
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 May 2024 18:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714933591; cv=none; b=Po+87vzvU0Eck5cvbuANEr3RNkh+qZoLYjk7EvzLZcnoj43gA38j698AkyUfgQnLaZi2psyiw/xJorsLvBohJv8y8P4V85b1sp7NOVntzFasi/t17FbBehEiQqZL8ErNBn/eCPXvGIy6dd3iU+nvaH6QjOPOWQa+9a/85ASDfGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714933591; c=relaxed/simple;
	bh=zL4ttq+dTYc2Po+Y/KgYNUEQOWFlVXDeYjMJ6ITXDn8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bBhSFnNetTIuO7OiG2/48PEKSKuxMbcbLgtJcV0nowBFEGmBWOe+7FzWlXYvLefYrcuJy6HzrA0/RhIAzZXznXt84tfNx960s5o2Sx5KNEqxvddLkLh/uZqBnmrtLO60VPANWGWSaA9++CAcQ6wXR71YyYkKUf+p5dxwvh9BWoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-36b3c9c65d7so15013725ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 May 2024 11:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714933589; x=1715538389;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SjJjtFn5h5ZtaHCuoaDSFOcZypXdldCXXXigcZgDNpk=;
        b=TczzzE9Pb+8bYgRoM6iuoNU3n9Ivkuq3JZfteFV+PA5LzAkDeClJuqWOvQQVXHkoUl
         63PzDyIvqAMPnUDWHQNAHVdYIWvDgtmuCmIPvK2CvSgQk4yxXrd9p6dD80p0yhzkgue+
         0a3eMCULkkBUbWulLhkfcpin8YiufBaioKKoLkpsk+H8fnO6qr19wbMncQGJnJfh1iBh
         4qFbNzSXQZnvFe9uie8k2Vt4abIbEdauom9zet7pj111/hbPPLTlZODsHBlZg3D4NAtT
         u37UJynXYxXO5qZZInEbu983hKHVjaaRnAGuMVZ+XGxnG7qFCGW8jJlnAkS5tNjCVRxy
         NxPw==
X-Forwarded-Encrypted: i=1; AJvYcCXJcuue9qqzcEQ2thRJBcCJuMAbIPVPjL6UzLZ/18zJ46bdKKiMNtieGHYxM5mKrGfbZZuVQGI75/e2wUMiTrIJ3IiqbZQJ4HS2rFX2y0U=
X-Gm-Message-State: AOJu0Yz6ZvMjcGt2zhpEHp4B9Bdv2Vmg8bwFOmyekuzPS6Cre97VM8GW
	2w271P4rgBWUJFLpSatbElXNkHNeIWNnmvnxnh+gqE/gaCL8DGoTOFEvfslSPR3eftxrDvTl3BA
	D0QzajnQ5zz+VYBx+0E9B2WvblezNHPF6jf4GYKtIq1oKCbWIkiP6oGU=
X-Google-Smtp-Source: AGHT+IFABT5H/si6OUrwBZ1qoO06Zf71SLikL60DsieHyjA2Qv4jr4M8juXr4SKmmQnVmFjojW3MDtJ2/MwGKVv00UL7Z9UktdPu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c23:b0:36c:5bd2:6b92 with SMTP id
 m3-20020a056e021c2300b0036c5bd26b92mr535175ilh.0.1714933589114; Sun, 05 May
 2024 11:26:29 -0700 (PDT)
Date: Sun, 05 May 2024 11:26:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000648e620617b9177a@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_inode_v3_invalid
From: syzbot <syzbot+d3803303d5b280e059d8@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7367539ad4b0 Merge tag 'cxl-fixes-6.9-rc7' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ad5e60980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbf567496022057b
dashboard link: https://syzkaller.appspot.com/bug?extid=d3803303d5b280e059d8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44fb709c4e9c/disk-7367539a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d25971073eca/vmlinux-7367539a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a327aa91b63e/bzImage-7367539a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d3803303d5b280e059d8@syzkaller.appspotmail.com

bcachefs (loop2): going read-only
bcachefs (loop2): finished waiting for writes to stop
bcachefs (loop2): flushing journal and stopping allocators, journal seq 9
=====================================================
BUG: KMSAN: uninit-value in bch2_inode_v3_invalid+0x390/0x520 fs/bcachefs/inode.c:516
 bch2_inode_v3_invalid+0x390/0x520 fs/bcachefs/inode.c:516
 bch2_bkey_val_invalid+0x24f/0x380 fs/bcachefs/bkey_methods.c:140
 bset_key_invalid fs/bcachefs/btree_io.c:831 [inline]
 validate_bset_keys+0x12d8/0x25d0 fs/bcachefs/btree_io.c:904
 validate_bset_for_write+0x1dd/0x340 fs/bcachefs/btree_io.c:1945
 __bch2_btree_node_write+0x5383/0x67c0 fs/bcachefs/btree_io.c:2155
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 journal_flush_done+0x156/0x3f0 fs/bcachefs/journal_reclaim.c:809
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:839
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x1b9/0x750 fs/bcachefs/super.c:277
 bch2_fs_read_only+0xcb4/0x1540 fs/bcachefs/super.c:357
 __bch2_fs_stop+0x112/0x6f0 fs/bcachefs/super.c:622
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:1788
 generic_shutdown_super+0x194/0x4c0 fs/super.c:641
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2012
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

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:46 [inline]
 bch2_sort_keys+0x1fdf/0x2cb0 fs/bcachefs/bkey_sort.c:194
 __bch2_btree_node_write+0x3acd/0x67c0 fs/bcachefs/btree_io.c:2100
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2288
 btree_node_write_if_need fs/bcachefs/btree_io.h:153 [inline]
 __btree_node_flush+0x4d0/0x640 fs/bcachefs/btree_trans_commit.c:229
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:238
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:553
 journal_flush_done+0x156/0x3f0 fs/bcachefs/journal_reclaim.c:809
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:839
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x1b9/0x750 fs/bcachefs/super.c:277
 bch2_fs_read_only+0xcb4/0x1540 fs/bcachefs/super.c:357
 __bch2_fs_stop+0x112/0x6f0 fs/bcachefs/super.c:622
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:1788
 generic_shutdown_super+0x194/0x4c0 fs/super.c:641
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2012
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
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3921
 __do_kmalloc_node mm/slub.c:3954 [inline]
 __kmalloc_node+0xb07/0x1060 mm/slub.c:3973
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
 bch2_fs_recovery+0x7adb/0x9310 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x135f/0x1670 fs/bcachefs/super.c:2102
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
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

CPU: 1 PID: 26381 Comm: syz-executor.2 Tainted: G        W          6.9.0-rc6-syzkaller-00234-g7367539ad4b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
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
