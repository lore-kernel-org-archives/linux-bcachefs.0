Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A06C1917E3
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754291919; cv=none; b=sg/m/G/wFp0rxe38IhGjLrmg7riurK+XNTw3XNFIrRtnfUOH8+HRK65w/RpmndWpYMUgI4xC2jIw5os7r2821QFC8/cVgAZDkdvW6jmD/I3+uRVQuwDw+DYsH0p39L0trfDphXJTE5wcc2Ln6j/89OTw9xGhkEQqqpuFeAjhVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754291919; c=relaxed/simple;
	bh=ZjCuUiyTzpd3UeODtecLVlTigMekhPys+29NLLlNW3w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XlTZcJUBAS93k7+4s3emCMRbXOMZ9xImOexIs/Q2uwxweF66BQ9MW0MQUEHiTgt3BfhjcbdfQvlYyLhtl1aFnmJMtZ8K6hscz0LFUNYxkPVvgD/gs4Ysey993/BEnmMFFHpmYP7C9uXcFMTOUAdfppwywpAYI3ntNR1BJpfmK2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-881855cd566so44316639f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 00:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754291916; x=1754896716;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z17DyzNxPkiI2YUZz4soZreG//rdEQjseJD0Rw+gpoo=;
        b=ccjM/7pJdZtiETbgXIBatK35uZNyQIpg10kEmWuAd3aSiuH5+XNitiKSvjkQZSNsEw
         GKTnbKQ3JGaCqzM1IVwmvOZn9UAO3J6zgP/iaT5ESIFYHDjqgOy2HLVoS+o3pn36uG5F
         kvB+AL6+U01OQ1tc3aBfj2DwpzIn+2PzvOa6Nx8R7WoCxhsDEP/GGuRLlWXj7LElYKXC
         xjwsX7xwnaX7Iqs0Z9ny7skUEAr561aO77kwJR8AgMC8r7ym8TYRS8XU9hLcf8/9eEvP
         PGAUfrA7tcd4gCtXJmDXgsnXRKRSemNqJNisf1uVawukq6K6KESGX30xsoQaBvOpRSn1
         yRZA==
X-Forwarded-Encrypted: i=1; AJvYcCXZN2QBbW12rzHp1eI9LIVGqoXjkL7bZBPGjLWJNOlK7fx/Nqg/gonyn/PHKBzgBGIQXlM01Te624tbs8LRuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYEeyjhRebHJ0F/SWhVrpD504ekevnyaPo2Oy81vbEmCFeTAU6
	G0KVI/U5aQ31cmNrC5JtDWYqUIrX68JkjVRabS4DS81eFv6S0vJ2FpPgUmWAx+MfVBzMnZf8Id5
	zcZQVM91JvwcsbBcjb1cF0NKOM+lyqzyUoD22Ao8TzBzzY3+YTrQqz7jsAj0=
X-Google-Smtp-Source: AGHT+IEffIXFbn4TwPlopWwvoBrIZ29XcugjOATO11IpLsQQFff5K61XQzFKra4Phudkhr07PcON7beNsc0PSRrKvS03LLzTh041
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2cd2:b0:87c:1237:cef7 with SMTP id
 ca18e2360f4ac-881683cfb64mr1506476739f.13.1754291916404; Mon, 04 Aug 2025
 00:18:36 -0700 (PDT)
Date: Mon, 04 Aug 2025 00:18:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68905ecc.050a0220.7f033.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_accounting_validate
From: syzbot <syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    352af6a011d5 Merge tag 'rust-6.17' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=135d7aa2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cae1291240e8962a
dashboard link: https://syzkaller.appspot.com/bug?extid=cd063f869beedf5b9cd7
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dcc6a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133e02f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a762497d1fce/disk-352af6a0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3055e1e47995/vmlinux-352af6a0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aa300ee98202/bzImage-352af6a0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/de2a4b00a48a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com

bcachefs (loop0): error reading btree root btree=subvolumes level=0: btree_node_read_error, fixing
bcachefs (loop0): invalid bkey in btree_node btree=snapshot_trees level=0: u64s 6 type snapshot_tree POS_MIN len 0 ver 0: subvol 1 root snapshot 4294967295
  bad pos, deleting
bcachefs (loop0): error reading btree root btree=snapshot_trees level=0: btree_node_read_error, fixing
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/bcachefs/disk_accounting.c:238:2
index 175 is out of range for type 'const unsigned int[9]'
CPU: 0 UID: 0 PID: 5849 Comm: syz-executor427 Tainted: G        W           6.16.0-syzkaller-11322-g352af6a011d5 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x40 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe9/0xf0 lib/ubsan.c:455
 bch2_accounting_validate+0x112f/0x1400 fs/bcachefs/disk_accounting.c:238
 bch2_bkey_val_validate+0x202/0x3e0 fs/bcachefs/bkey_methods.c:143
 btree_node_bkey_val_validate fs/bcachefs/btree_io.c:880 [inline]
 bch2_btree_node_read_done+0x4051/0x5550 fs/bcachefs/btree_io.c:1303
 btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
 bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
 bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
 read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
 bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5016bf5eaa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd552f5c58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd552f5c70 RCX: 00007f5016bf5eaa
RDX: 0000200000001000 RSI: 0000200000000000 RDI: 00007ffd552f5c70
RBP: 0000200000000000 R08: 00007ffd552f5cb0 R09: 000000000000492c
R10: 0000000000000000 R11: 0000000000000282 R12: 0000200000001000
R13: 00007ffd552f5cb0 R14: 0000000000000003 R15: 0000000000000000
 </TASK>
---[ end trace ]---


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
