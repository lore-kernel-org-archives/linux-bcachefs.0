Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B668201011
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730901511; cv=none; b=Y2sFMV47nN4EjeFux3D5CpziJta0cAaMHweo00UGFzF1Me+Y1JTQmfkzIt5JaULc4+nErjmU11Sm8OdmGSb8v2q0gCvzi4Htvx8x27OPo15WyU3/TnzO3X6c7a/f5rN/Gcij/RbCamyZ2jmRVZkkIS9BHAWf9QktLnCnIQjVT0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730901511; c=relaxed/simple;
	bh=bVea+gjFvg96Mm4WrdlYM7pndP58QE60uzMc42R73tA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HNDwLAbxisMjPeWhlEgnueZ5PW9VsZwVmFCrXkIb5QcNZf0VIGg8NbUve3u44j789K2yrqrp7Yd1iRS+VcrwskmrT7GbXtc4cTlCGwIs026nnfGNMt4IPEex2mZoVpaqdctWHHGtWdf5NMkelo0f6O5xPgn0QWLfKo6SV2RM+4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83abb2b6d42so643651639f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Nov 2024 05:58:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730901508; x=1731506308;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YvXX4Uvm4Sv5rG3ET+3b+aopQP+lQPtXC+0jGPc3apA=;
        b=rIFu/g/3hC1cpkov9Fh3mwiXQebrtJw19dB/MuKFMNDuwKju3o9EXd0AzXFSJIGIVE
         wpa5qaYjZsN2lWzaO22vz0R8U48k3C56SDMvokffBw1M4sLAn0iRm3XI13sprO0f2H0U
         uLYwRxa+Tu9SQMiy3Fp5FnorQZn0TF9sRtKLIwmsLeBH6oT7UpAGvrSwV4NJ6jeB8uY2
         l8eWpkwNoL15vDyk2INHejfM3EZtD2HB7WsqHOLVeXHD83e7a52irwvVUxaTuMqTEugu
         OK0NSk7s5OIp3e83rJEiK0lIR0ccsttOEAUra+XfWv4mee/3ASwJ3xYAa8qYuVlScN44
         dkZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFI2ZIaVN72hNVHwMu0EMiMGwvWeatBfvfp5HEu6WljSl2VtCMkrMgq9bOPNTPqPEOiDr8twyWT9EOS5k+Nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyodJ99izy6GhF6JwzFjmrRY0UFea/Ef8n5w3pGLc4YKBF5hv4m
	sKqp9ZdoR0TOYuW3Zk1XLO7x4anlvLmD1XxC8Sf+SJoYSA/UQOoq4TRVlTMEKH4eopTNX5AS0G+
	ZGihKwHGdTqbjMsOMnc1DW5c5LN7b74o6+IsJFf91+Zrhp5Myt8E9lc0=
X-Google-Smtp-Source: AGHT+IFey/Zx2IVbBLTw97R/YIfcXvyIYX8izd78Ia5TIEnHV/L2aBbmDrqy+WZPMZGqjKM4jfAk/27jPtKFesnBcb0qfWsiOhDB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24e:0:b0:3a6:af20:944c with SMTP id
 e9e14a558f8ab-3a6af2095bemr175869765ab.9.1730901508525; Wed, 06 Nov 2024
 05:58:28 -0800 (PST)
Date: Wed, 06 Nov 2024 05:58:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672b7604.050a0220.350062.0255.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bucket_alloc_early
From: syzbot <syzbot+07d7911319bd613ba885@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    11066801dd4b Merge tag 'linux_kselftest-fixes-6.12-rc6' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1586755f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1edd801cefd6ca3e
dashboard link: https://syzkaller.appspot.com/bug?extid=07d7911319bd613ba885
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cc31a4a3feaf/disk-11066801.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/864b7b8a0366/vmlinux-11066801.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1d3aafe2185a/bzImage-11066801.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+07d7911319bd613ba885@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
BUG: KMSAN: uninit-value in bch2_bucket_alloc_early+0x11c0/0x2520 fs/bcachefs/alloc_foreground.c:439
 bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
 bch2_bucket_alloc_early+0x11c0/0x2520 fs/bcachefs/alloc_foreground.c:439
 bch2_bucket_alloc_trans+0x8e6/0x3fb0 fs/bcachefs/alloc_foreground.c:649
 bch2_bucket_alloc_set_trans+0x959/0x1650 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x1dec/0x3070 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x328/0x530 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0x1833/0x32b0
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:343 [inline]
 bch2_btree_reserve_get+0x9d6/0x2290 fs/bcachefs/btree_update_interior.c:554
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1252
 bch2_btree_split_leaf+0x120/0xc00 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x1c0/0x1d60 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x210f/0xd190 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:728 [inline]
 btree_interior_update_work+0x2080/0x4870 fs/bcachefs/btree_update_interior.c:866
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
 btree_node_data_alloc fs/bcachefs/btree_cache.c:125 [inline]
 __bch2_btree_node_mem_alloc+0x2c8/0x9d0 fs/bcachefs/btree_cache.c:170
 bch2_fs_btree_cache_init+0x4e4/0xb50 fs/bcachefs/btree_cache.c:633
 bch2_fs_alloc fs/bcachefs/super.c:916 [inline]
 bch2_fs_open+0x4d35/0x5b30 fs/bcachefs/super.c:2064
 bch2_fs_get_tree+0x983/0x22d0 fs/bcachefs/fs.c:2157
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

CPU: 1 UID: 0 PID: 1882 Comm: kworker/u8:7 Not tainted 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
