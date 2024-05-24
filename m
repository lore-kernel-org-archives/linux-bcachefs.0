Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FBD4AEF8
	for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 18:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716575551; cv=none; b=PL/TfefqztJSwL23QF+srAHOzH5tc26CfGzZIlkB4J9iZfB/ZCNaCV0MY5bCDjd3amb68GvRRJF8DzhOXjV6yS9GiJslAve/C5Rn8A3HFHDPwpJWyiz6+krzqMSsIc3cS2Cw+kjOHF4d43PBmoHrpKz7Kg0zj1ZZ2gTqZXVOQxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716575551; c=relaxed/simple;
	bh=5msJXS/dtKh3iOFppa8Cw0vW4deFvLyYforwtcAeIEc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=i+mZ164KlyMGciea9VP1wnNSc1eh7AE3wzSfCbqfFEyBk60SVUInsT0kC0F9zLKKzwQWroPOegZTZ19zVVCsUDPbjEC8JDhUNfvIq8a/K2QHrmZ4EsHCkGth/3vyuW2UQvLfS2Ro/0EEK+cKsDQfSBNkX7MgKlBCiAeK1Vh81b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e8dbc4a698so93426039f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 11:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716575549; x=1717180349;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2R68mPgV+niEy7m8e9z+aOUhhRPmas2QR3yP8VqiXbg=;
        b=MN5Zo+yb3i2v+t39XeQPH7gvwDBFO5Jx1B48bJH5SYyUnA1SugtoY7ukyCiPfMhIAc
         grnvgHjDeKEWXxiAihCa0PQR/oHb5S9YfrluRU2xSWRF156jklF+/E09VEy50L1hX6cj
         O5Cz1eNMaO7OPa9IOSMaATmZiUSx0LCaeJ7QjCBRHioqlZgMlRy7mKNPHbcRJDzl9aWK
         RBqLdDjKqoJRDJQ7+SF3T5GO6q0j7WtjYDautzMFjZPbRAEKaZsTkOZu2L78202i0syU
         aYsPBeoYBup2HwkMTU//VxOmIdYbRCKM/IECAkXYJFbJpI715M9ccJiX9x8g718sKFcp
         dwUg==
X-Forwarded-Encrypted: i=1; AJvYcCVCyuE8S+XUzBV0eso1GdivFMb/1Ig2ZxzBJ0S+7V1ls8iCK8El73REfEhX44mWlnEnQO7L6zF8nj27A+QdeVnd0+abrdRs1m42qnPUMYM=
X-Gm-Message-State: AOJu0YzOjqe8OEbNuGNhxx3s0BL3fmQmR8hC8Ven5/1ufKrIZCIBM/HB
	2rSVVKdc492VlQzAH7hk7Fm2/uP3VGhNppEi85eN/19WjSRfwLFBgHGwrZfvMO/XY85V8fTSJUn
	po1bCps5o478MXvOKz3nFTDjSDevsaevzvEWcVYGVN8O+YOW4dhM9A0k=
X-Google-Smtp-Source: AGHT+IHfvW1MnyNVZokVzVh9uIYkP+1usWLG6aoc/PW1ZBB8HxPNzXUyNoI894fDJfHvPC5p6BqUt+R9gcRAGZDKaALBC55CYRln
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:a58e:0:b0:49d:f18c:de57 with SMTP id
 8926c6da1cb9f-4b03a21155amr98719173.0.1716575549613; Fri, 24 May 2024
 11:32:29 -0700 (PDT)
Date: Fri, 24 May 2024 11:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd79ba0619376337@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: not locked: inodes NUM:NUM:NUM cached
From: syzbot <syzbot+b01867e789ff58727a77@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fda5695d692c Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=145455cc980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95dc1de8407c7270
dashboard link: https://syzkaller.appspot.com/bug?extid=b01867e789ff58727a77
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15bba634980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d2a5cc980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/07f3214ff0d9/disk-fda5695d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70e2e2c864e8/vmlinux-fda5695d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b259942a16dc/Image-fda5695d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a396b8da95e5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b01867e789ff58727a77@syzkaller.appspotmail.com

path: idx  2 ref 1:0 P S btree=dirents l=0 pos 4096:6783475523080972787:U32_MAX locks 0 bch2_trans_iter_init fs/bcachefs/btree_iter.h:489 [inline]
path: idx  2 ref 1:0 P S btree=dirents l=0 pos 4096:6783475523080972787:U32_MAX locks 0 bch2_hash_lookup_in_snapshot+0x150/0x564 fs/bcachefs/str_hash.h:173
path: idx  1 ref 0:0 P S btree=subvolumes l=0 pos 0:1:0 locks 0 bch2_trans_iter_init fs/bcachefs/btree_iter.h:489 [inline]
path: idx  1 ref 0:0 P S btree=subvolumes l=0 pos 0:1:0 locks 0 __bch2_bkey_get_iter+0xe4/0x248 fs/bcachefs/btree_iter.h:548
transaction updates for bch2_lookup journal seq 0
Kernel panic - not syncing: not locked: inodes 0:4101:0 cached
CPU: 1 PID: 6245 Comm: syz-executor964 Not tainted 6.9.0-rc7-syzkaller-gfda5695d692c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:114
 dump_stack+0x1c/0x28 lib/dump_stack.c:123
 panic+0x30c/0x894 kernel/panic.c:348
 bch2_assert_pos_locked+0x890/0x8dc fs/bcachefs/btree_iter.c:367
 bch2_inode_update_after_write+0x184/0x88c fs/bcachefs/fs.c:59
 bch2_vfs_inode_init+0xac/0x640 fs/bcachefs/fs.c:1448
 bch2_lookup_trans fs/bcachefs/fs.c:419 [inline]
 bch2_lookup+0x918/0xbcc fs/bcachefs/fs.c:437
 lookup_open fs/namei.c:3475 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0xc90/0x2830 fs/namei.c:3796
 do_filp_open+0x1bc/0x3cc fs/namei.c:3826
 do_sys_openat2+0x124/0x1b8 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __arm64_sys_openat+0x1f0/0x240 fs/open.c:1432
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x00,00000103,80100128,42017203
Memory Limit: none
Rebooting in 86400 seconds..


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
