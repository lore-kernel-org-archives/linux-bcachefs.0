Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDDF1C231C
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717011328; cv=none; b=QXAWthCR2h6KOmzLtux0j9w+I2N2kBELwbUhg0HpJLrmSjI3iM70mIZDoswL2Lvwrd1T25WQvCZnAWT0JcyPSYsKWoc6FZjhIwRHL+sWWXx/P0Dp2uTAem6cFo5eV78+o0W7kn+SHvogNXnnmtFd85IAdHWJsYlzD/1iZ1kOfWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717011328; c=relaxed/simple;
	bh=L5LYcj983w/G7cmoPjlZ9HazA9HPlFn0B8m+apoXi00=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ktE3RHBkl8oLFZszgq0AE6jT50zx+ijpFhrPQbkey9NmXwxaLghItS5vsNrTLWxNLe1SdWzJ86zyiMLIyBO9gRD8vbtI2O8Vi/WWiDypMGByG8lFEg09nxcbTsyRkujEz7kzKwazm/wV4RL6zTtk6EDQssrYAP0+ep4Co+9kLnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e69c0762b8so5176139f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 12:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717011326; x=1717616126;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5bUpBAQIlroT+U2Q77MLXTFapZdCAd6xc7X9aNiD0gw=;
        b=WwFouFxiDZkTJ9MrZYlx/bf5LY4bMx1bPE9KCvD2ua+VYGwkI/+LNwl0CztYGpWW+T
         jg4e3rJGXqL+MmeV7qiFD/NGHL1dzyAKmf3LHVqaOKXFoyqMfqcjLV/yZe9jkid376IF
         YrO8a4iMkDyGCnRDXuKXeR+C35l4/D3N5oD6mBd+tbQzCGC/pAKIZuKBePOTk9/GQL6J
         Z4jR5tyH18rco64lb06a6e281vfkd4qHKO1dpcuu20o7httOEAmP3spE4g+qY+l41X5O
         8HmIY3KtfGifhWvTdll11oeHSW5RRNQ6INmtwVueUX93vJx/xb1MgvTgNQLTyyn6CAFm
         43yg==
X-Forwarded-Encrypted: i=1; AJvYcCVBWjCIeAHaSsWZzjQK/BpizenSRa8NtyTpw1QFAeg/NkD2V64h40XU2PxIst9qbYSEAklOlD2n7PlefPvRv/MNELI+EpyiFjr9hv+ssk0=
X-Gm-Message-State: AOJu0YwG+dZzgjIYW2gljSn86TeTN9RHkddZlRkMqORMsrLGjSdRGYx5
	0TI9QAjg5vJAllOmQAIGrgvnhNlVrkXxmzURjDWwAu6JRww/k1azMUUQ0vXPj2YRcnN/F0g2/ci
	7FrSlGU/dsgl6HixzhQWn+6RoQ98xRWlbRBMAAPD41LgwftaU+S41M5c=
X-Google-Smtp-Source: AGHT+IHPgBzCc6sDZsZRbK3JXRWbsYidyX+tlba/egulDrs1fIdP5OlO6Owkqoqpzb68bbUtFNNMziLhmBhKUMZNJ4Hcc42B8waT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:168a:b0:7de:e20f:4c65 with SMTP id
 ca18e2360f4ac-7e8c3bbbed7mr53400339f.1.1717011325737; Wed, 29 May 2024
 12:35:25 -0700 (PDT)
Date: Wed, 29 May 2024 12:35:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000256ed406199cda69@google.com>
Subject: [syzbot] [bcachefs?] WARNING: kmalloc bug in __snapshot_t_mut
From: syzbot <syzbot+770e99b65e26fa023ab1@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c13320499ba0 Merge tag '6.10-rc-smb3-fixes-part2' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14fb3ec8980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee7b962709a5f5a5
dashboard link: https://syzkaller.appspot.com/bug?extid=770e99b65e26fa023ab1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157e822c980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ed3a3c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/22adcef01567/disk-c1332049.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/03f224c81035/vmlinux-c1332049.xz
kernel image: https://storage.googleapis.com/syzbot-assets/711f192697c1/bzImage-c1332049.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f94c66f22d99/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1799b972980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1459b972980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1059b972980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+770e99b65e26fa023ab1@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=crc64,data_checksum=xxhash,compression=gzip,str_hash=crc64,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read...
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5078 at mm/util.c:649 kvmalloc_node_noprof+0x17a/0x190 mm/util.c:649
Modules linked in:
CPU: 1 PID: 5078 Comm: syz-executor347 Not tainted 6.9.0-syzkaller-12398-gc13320499ba0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:kvmalloc_node_noprof+0x17a/0x190 mm/util.c:649
Code: cc 44 89 fe 81 e6 00 20 00 00 31 ff e8 6f 48 be ff 41 81 e7 00 20 00 00 74 0a e8 21 44 be ff e9 3b ff ff ff e8 17 44 be ff 90 <0f> 0b 90 e9 2d ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
RSP: 0018:ffffc90004116c68 EFLAGS: 00010293
RAX: ffffffff81d7d179 RBX: 00000037ffc7c850 RCX: ffff88802d0d9e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff81d7d161 R09: 00000000ffffffff
R10: ffffc90004116b00 R11: fffff52000822d65 R12: ffffc90004116fef
R13: 00000000000100ff R14: 00000000ffffffff R15: 0000000000000000
FS:  000055557a8d2380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005582515a4208 CR3: 0000000011274000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __snapshot_t_mut+0x3c/0x220 fs/bcachefs/snapshot.c:171
 __bch2_mark_snapshot+0x130/0xac0 fs/bcachefs/snapshot.c:310
 bch2_snapshots_read+0x596/0x1680 fs/bcachefs/snapshot.c:1845
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
 bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
 bch2_mount+0x71d/0x1310 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9cfdd8adea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd812fab8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdd812fad0 RCX: 00007f9cfdd8adea
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007ffdd812fad0
RBP: 0000000000000004 R08: 00007ffdd812fb10 R09: 0000000000005d64
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffdd812fb10 R14: 0000000000000003 R15: 0000000001000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
