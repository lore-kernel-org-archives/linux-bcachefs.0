Received: from mail-vs1-f77.google.com (mail-vs1-f77.google.com [209.85.217.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0586318CC1C
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 19:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734117669; cv=none; b=dST2j6UIjfZ2RRDySkMbClEFh73zOM8JBmc4nQPoqK3svgJTITuyqjvpishEaf3bFDNdwB9jRtj1g3Cchjnl/8mpAcOMA18TGCRXQAch4HIU7dUFP0qZEgbFgxLBC4mO08HsfUhdqQIaFI1q9sgLC8XJ1AsMLJFih8OxEkSbywo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734117669; c=relaxed/simple;
	bh=4SGi0enRJVcai15qH3LwCosFtYap/LUehjcwvR2f/NQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LEhOsr94dRaUIfrJx7EBCQilbhBKu+n/yn4aUXyCd0E4wlcLMl8P18cih+B3ZdLs4GLzFYXtm4/n2C88ika1VvAmFiN+pIeOhpuD0NbC7VpAvV8DM7Djk2cpswC/I2nNAxrr/AFYTRWK+pJQv7cyvok0Fh1WXKPTV+n4wYQGHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.217.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-vs1-f77.google.com with SMTP id ada2fe7eead31-4afe261fc2cso1283933137.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 11:21:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734117666; x=1734722466;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SBh0cDcxYAsSADOuDl2Ad3HHmdzKD2QJGvTJjL9pGiA=;
        b=fIotDUjr3gUsVX1WUYASkVu8ugLkE7Jrk18cjEbEFME0GmLHPu0h1sCu7kiw0FcYhL
         7m7on5LclqeWo4sfuy+/bCNR4CGRvvGMfV7EV0qYshMye2nU89BRo7IE4GD08+RUZj4r
         lG7WlEG38bCZYLepY4y/3e/1kB9Io6iI25EyrT29KNa2D7qaBMRObDpHj48Ny//5sYAT
         BS18i3R79YXFy5ymmCsPZPEID6R9+DTQApbnV7/mRlkF6+W+KC1bHQQwAcdN+PIY/iIK
         6jXaqs8xtPK05WKGJ6DWiesDf0kWj/OKSiyAROpy174A6rHkQ+QnQrXbR2aQ77/3t4tu
         CH8A==
X-Forwarded-Encrypted: i=1; AJvYcCWrm6r6N4T+nbv3D5v2xYEFyE8huZgFiG4HnB6J7nf+MGNzsaYgrpJFkHU0zuGUG6PAIDhe3604hn5ReJbn8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqY0b6DeyNFb3XwzPBvqHY+vX/Axafa34OjvW22Q/gIfbCl39S
	b44BLW6dXDXvilPqBThdDKB8kN6+MdmqcfSQj/otUVCKhTJPd/Ki/NWH/z4CI/c1Oe+kWh31h2R
	bTmzoBwjro7QmqeIZkra3DZbOCUBntCUAX/zDXCGMlHkPUX0mIW3270E=
X-Google-Smtp-Source: AGHT+IFVV968yAdGGHzAHY/GBff1XxkHL2BzAPSYHr5jONe7t1eGHi3dYhTYPa0Q22assxwcPfBcyKAYqNkRzXxOwnIQyUk5cPP2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:3a7:7ee3:108d with SMTP id
 e9e14a558f8ab-3aff9821369mr56239645ab.23.1734117209296; Fri, 13 Dec 2024
 11:13:29 -0800 (PST)
Date: Fri, 13 Dec 2024 11:13:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675c8759.050a0220.2875e5.004a.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in __build_ro_aux_tree
From: syzbot <syzbot+ac254bd3bcde20072a0a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fac04efc5c79 Linux 6.13-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15eeab30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95d0bb0535bcaca0
dashboard link: https://syzkaller.appspot.com/bug?extid=ac254bd3bcde20072a0a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d6e1c34e8de/disk-fac04efc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e1de71b47f9/vmlinux-fac04efc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/915cb3b3a8e7/bzImage-fac04efc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac254bd3bcde20072a0a@syzkaller.appspotmail.com

bcachefs (loop3): journal_replay...
=====================================================
BUG: KMSAN: uninit-value in __build_ro_aux_tree+0x61f/0x21a0 fs/bcachefs/bset.c:715
 __build_ro_aux_tree+0x61f/0x21a0 fs/bcachefs/bset.c:715
 bch2_bset_build_aux_tree+0x6e6/0x850 fs/bcachefs/bset.c:779
 bch2_btree_build_aux_trees fs/bcachefs/btree_io.c:448 [inline]
 bch2_btree_init_next+0xdda/0x11e0 fs/bcachefs/btree_io.c:508
 bch2_btree_node_prep_for_write+0x6c8/0x720 fs/bcachefs/btree_trans_commit.c:101
 bch2_trans_lock_write+0x7ef/0xc00 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x31c4/0xd190 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_key_cache_flush_pos fs/bcachefs/btree_key_cache.c:432 [inline]
 bch2_btree_key_cache_journal_flush+0x1076/0x1900 fs/bcachefs/btree_key_cache.c:512
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0xe1/0x3f0 fs/bcachefs/journal_reclaim.c:819
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x4937/0x4d30 fs/bcachefs/recovery.c:383
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

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_node_data_alloc fs/bcachefs/btree_cache.c:153 [inline]
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x4e4/0xb50 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:917 [inline]
 bch2_fs_open+0x4d3a/0x5b40 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x983/0x22d0 fs/bcachefs/fs.c:2157
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

CPU: 1 UID: 0 PID: 6069 Comm: syz.3.35 Not tainted 6.13.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
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
