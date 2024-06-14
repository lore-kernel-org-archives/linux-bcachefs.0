Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428B9198851
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367443; cv=none; b=BK2QEFjrGJNdWL3XgjAquQTJwmegrs0J5BdezmudgapnnMXNxD08ROR6Rqpasj+4ooP3UC1/XuUdBm6BFrpPJCuPYpdXkff7aFlicGl/utTW3SimW7bE1j0xt74xcZGKOb108LixJy9ImxoxoahwBBAAutmjpxuOqBgju9dERZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367443; c=relaxed/simple;
	bh=Exj63OoisrZhR8WLJdEruzSEulGzSeKI22HLLV2dkS0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PozFPH7pC1pvxYhK/YIy8NgYxZhCS5suoXrhbZDzmgX/Z42VMqwXq5I7v2QVeWRb0VgzJhCM8+SbgTPNRYZqEdYYrq3AtmE6hK+LKg6RL1njR1sUohNmFJenBNfRAFWnBDw5+W1sDOG7bWerAVeDImKnbfJU4YvceGTAkD28AXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7ebeebdc580so72283139f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 05:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718367441; x=1718972241;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HnIUaiLobppew0KZWTezY3pR7gs3y0V2DGXixWAfN0g=;
        b=oFPKNl1L2C7kGPCjAe/Yrai8T+g9ksSLLlejdT9heik5WD3Bk9jDc/4Hx9ex3WE1Gw
         pViogFERj3YO27R4KdmqrkBXjae8/FmS5WgRXNcyK1y55aW8G8+bqbk86Ev08P7oyQkX
         gYq02X4326wQGoFbbX5ObvrMtDFu11Hkx4Ni/Ua10JXQpQPkVzjJxmZRxNWC2qf5mPEH
         TLdz375fM4WflRDMHQqeH2sbw7Mb6wb1DnweuYrQC0nUObK6crxFUNpZdZykNPCLhOm8
         br67OMTfMmfSIyaSbqO8oHv8UdDxchycaa9rTlwMRFZqa5MUGqasjnLrAyJX+4CoceNs
         4arQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp/L7sE9oXRM1nhpGD6OY10o/934rYnlPivC732h3Sl/gdlmjEi2q5LwUofXbxPaqOj5QN7/NuU8eVCysKQ6Sg35DrDKocYjpH8U8cleE=
X-Gm-Message-State: AOJu0YxnP5hh+QRuuCKqwSd44OIN5uDu7hNktVnBjEw1gpLzEB/hwC2x
	QH74GkY4MQvpMsFP3/gnAl6josTqBcIO2EMyPQuvGU0wAIFRGT2eXMQvjmIkelw/DL4XoFaWjF9
	jM5AO2oHM0gmUT9uIqUpuyyrnBNQWkclA/+7EqV9CkFZfSp2xhSzcDT8=
X-Google-Smtp-Source: AGHT+IHVGxjV8uG6wOLl/zEVzuS7ua50Q6Ux9yP0OAdWjrZn3+sXJGGvxTR9V95Gc//dwaC4Qb12H2sb5BQ+Euj3sefnB3pSuv3z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6424:b0:7eb:76f7:4857 with SMTP id
 ca18e2360f4ac-7ebeaef0783mr2500039f.0.1718367441321; Fri, 14 Jun 2024
 05:17:21 -0700 (PDT)
Date: Fri, 14 Jun 2024 05:17:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ef1901061ad898e7@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_readdir
From: syzbot <syzbot+b6e671a90975c257b802@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14487874980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=b6e671a90975c257b802
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6e671a90975c257b802@syzkaller.appspotmail.com

dccp_invalid_packet: P.Data Offset(144) too large
=====================================================
BUG: KMSAN: uninit-value in bch2_dirent_read_target fs/bcachefs/dirent.c:265 [inline]
BUG: KMSAN: uninit-value in bch2_readdir+0xad6/0x2110 fs/bcachefs/dirent.c:572
 bch2_dirent_read_target fs/bcachefs/dirent.c:265 [inline]
 bch2_readdir+0xad6/0x2110 fs/bcachefs/dirent.c:572
 bch2_vfs_readdir+0x394/0x840 fs/bcachefs/fs.c:1095
 iterate_dir+0x688/0x870 fs/readdir.c:110
 __do_sys_getdents64 fs/readdir.c:409 [inline]
 __se_sys_getdents64+0x169/0x530 fs/readdir.c:394
 __x64_sys_getdents64+0x96/0xe0 fs/readdir.c:394
 x64_sys_call+0x343d/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:218
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
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

CPU: 0 PID: 9936 Comm: syz-executor.2 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
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
