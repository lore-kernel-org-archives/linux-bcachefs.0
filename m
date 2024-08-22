Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6773D18452C
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 08:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724315607; cv=none; b=HQdB5ekpd8gfVi38vAA+ge0Oz8l+OhADhsD4HSX7GCOFc+pkyk63L5E20do3/7FQRtiyUDJO7W0Z7/jfxHOvwNN6uZKRDa2atrrvcFVhGIZaAP8udih7a+apKYNTvVGP9hDKXs+WDWJqkkWff76I1bTlOc+4TEhhb6wwKEgrFGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724315607; c=relaxed/simple;
	bh=S9LqJbUue2NmI27P20+JtZLnz5o0LiiCjLon4DQXcRU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n6GgE4gy96cq4xMb50Qb2rDQj1WquY4LwRMXuXOcgWeVLP8xkvhSIpu5G+ezmhoOSadNIiX+tLStHFpVAsyxt/IqRIY4cSqHzYbhVzzlKsI56VTlH00XAK7VwDRiAD2gtJypQz0PCCJqru2GRtp1qx5+u+MxL98W588UFOSZSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39d2dee9722so6567235ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 01:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724315604; x=1724920404;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6AXC5XHZThFajyn2Wh0sKPHHef6MxuiBJh0u0wO5Ttk=;
        b=t8KNek0iPbRgxw8BoDXRxEkEkPJhI+yWabYWF6Zvw5BJDrrcqCQhVwc57Rtjyg+xiC
         Xx483RuoSC4IoAOGNbgdhDr4ygsy0k3F6JgU+qCaOCMR5FxzNVWhnKWhNBWW111PbTzf
         XnGbEXV8/+Ef48I67F8iUpTFE5YHEXnNyIyJwGLCGory/IV43SsqFJPJIXwPHVkY6Bui
         +3ZMJ0jUICJgv/cGSo4hAsa0MgyPX8unHkwwKyM3/kNrvkNwXfigjuXkWkJ0udx71zFz
         0GQqAuXEU5MAxaiP4WF3zTwvR6aq5urtxj1tscga79wiLeBnOx+IFcAeyOIvNPe4z6JU
         IPAA==
X-Forwarded-Encrypted: i=1; AJvYcCX0AiGDQGwGqA0pquX/B/2SeakfHPpIvk38+RqEJsoU6UrYyeB8kXCldHW8KFy8ww7BX52+m4i7WL7XwYVBmA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjb02yvlOP5jpI5ogpPqaGBYSfcq3LhDQdi+vGQ8WMrofjHWA8
	sURjA5dkI4RO0tDpnBMEz6WWvE+q6SpCqjCDHYN8rRRa93hIkVqvyV2aM84wpr6RdENKwo3iR7b
	uTiV1/ijITDEPQ6mAZ89mQ8sMbfk0M8BWsxHeidIpGUM1UCQsWTrDd5U=
X-Google-Smtp-Source: AGHT+IE5ybtdLEnlV4DeQ6iz0cvn1pcpAcGxp4GMBZOpdSaSFD0DtGHNiO1cgcsWrQMk3fOS7aeX/vFq/w/scTtOk+yDPuci33j+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d16:b0:381:c14:70cf with SMTP id
 e9e14a558f8ab-39d6c34c312mr4356805ab.1.1724315604539; Thu, 22 Aug 2024
 01:33:24 -0700 (PDT)
Date: Thu, 22 Aug 2024 01:33:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000016f0070620418323@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_alloc_v4_validate
From: syzbot <syzbot+5c0423c85f295891c7f7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6e4436539ae1 Merge tag 'hid-for-linus-2024081901' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17cc9387980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62f882de896675a6
dashboard link: https://syzkaller.appspot.com/bug?extid=5c0423c85f295891c7f7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1338058d980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d0f7f3980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/75208f1b057a/disk-6e443653.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eeb34e49cb7e/vmlinux-6e443653.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bd6b9e2947c8/bzImage-6e443653.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/80d0f45895f2/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c0423c85f295891c7f7@syzkaller.appspotmail.com

bcachefs (loop0): recovering from clean shutdown, journal seq 8
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.11: disk_accounting_inum
  running recovery passes: check_allocations
=====================================================
BUG: KMSAN: uninit-value in alloc_data_type fs/bcachefs/alloc_background.h:135 [inline]
BUG: KMSAN: uninit-value in bch2_alloc_v4_validate+0x80a/0x1c10 fs/bcachefs/alloc_background.c:256
 alloc_data_type fs/bcachefs/alloc_background.h:135 [inline]
 bch2_alloc_v4_validate+0x80a/0x1c10 fs/bcachefs/alloc_background.c:256
 bch2_bkey_val_validate+0x2ac/0x470 fs/bcachefs/bkey_methods.c:143
 bch2_btree_node_read_done+0x5be1/0x7790 fs/bcachefs/btree_io.c:1219
 btree_node_read_work+0x973/0x1960 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2e6b/0x36e0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0xa81/0x13f0 fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x51c/0x1250 fs/bcachefs/recovery.c:516
 bch2_fs_recovery+0x422c/0x5c60 fs/bcachefs/recovery.c:844
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x13e8/0x22d0 fs/bcachefs/fs.c:1946
 vfs_get_tree+0xa7/0x570 fs/super.c:1800
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3472
 path_mount+0x742/0x1f10 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:3997
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3997
 x64_sys_call+0x255a/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4113
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4130
 __do_kmalloc_node mm/slub.c:4146 [inline]
 __kmalloc_node_noprof+0x9d6/0xf50 mm/slub.c:4164
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 bch2_btree_node_read_done+0x52a9/0x7790 fs/bcachefs/btree_io.c:1192
 btree_node_read_work+0x973/0x1960 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2e6b/0x36e0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0xa81/0x13f0 fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x51c/0x1250 fs/bcachefs/recovery.c:516
 bch2_fs_recovery+0x422c/0x5c60 fs/bcachefs/recovery.c:844
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0x13e8/0x22d0 fs/bcachefs/fs.c:1946
 vfs_get_tree+0xa7/0x570 fs/super.c:1800
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3472
 path_mount+0x742/0x1f10 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:3997
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3997
 x64_sys_call+0x255a/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5177 Comm: syz-executor142 Not tainted 6.11.0-rc4-syzkaller-00008-g6e4436539ae1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
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
