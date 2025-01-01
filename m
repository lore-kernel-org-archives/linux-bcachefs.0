Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126F1EACE
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735731383; cv=none; b=tScWEWd3lnzNOTWjHtO0JsNY4QPnQbmUH7zHZ1qXD9W26+pQbxAd1MiEtbul6EMpu7dCAg5sBvok8YhC6V51Mg8y/OQcx+FBG6BwrtNe0Vn5ui9wHkqvjSlCsC400hsJlUqZnbarObROUkjchMwiM6m+J/d6i5Kh8imQy+u4Y+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735731383; c=relaxed/simple;
	bh=gcVyMPQyXgttXCgV65ufM0mp2BOJtzJPU9CJo/ZOvQk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pdAqp1DbQ9vMyFBtfJlhurGOA0SXN5Oy1Mr7R/i3dgYccorAHG+gyYGbnXeecj/St2Tw33MHEGumb7Azf9IfAdcSoxaKaRllJnC3bgYO0ZqbjJeLFoRDHKo5L20mSMU92BesXHX3Otn7BLM0smmYEK1oT2b7f+1piQlKsWdg2Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a9d57cff85so214728055ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 03:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735731381; x=1736336181;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sGH+RJsCSrc9wn7ZjqEQCTPFDr7heNnNho2v6bYekyc=;
        b=FimIkHZkvxDq/JGgDWq8FefRogOG/WBS/bbTcDwIpFe8O6HVnwzXlwhXVLGbJET5hz
         E020UF/qqiPNh+/1f7atSYHi5OUffjmjZeBmtVKo9jFtor9t2InD8nVlL9812Kg0mYwQ
         cIUDQljrmU+nauVpK53X51IaRbOBnhTIKmSDu1PtjhtSuraGFFwQ/HiFVKv5/GkdKrh4
         UeqMbIYsnmRumHf7X21biJEMmGRciYgmltCENoZslVpwmLKf8Z43jy2PXjr8uB2lKDVM
         FA++fxkHxz8fKE4WS7htf94Ubbb6NGGv43sPGi0mLt6YYSVFkFdSTaCU6cqIQhN5bCZS
         ApgA==
X-Forwarded-Encrypted: i=1; AJvYcCXvjY0juDQbLox/od2aS4ChVhSohwFzuIDyj8oFHCKVDuBSXkJQRTSnOnJr4vUu16TMvQzwlKHleO69wZEZKw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3SnIQcYf031CwQIG4kAqOFNWtnMfT7Q3moAvSK3Fz/mvQ0x5o
	2v7k8B2EbrRa2QtAwb2Ic6YFMQGzO5e5rUaQswh8yAEXvpY/bCzSMNNiveut+lnSzCSfQH7TN+e
	KYNU0Mq5bYbqBGbwc+mPagegvFb0LIVlv8Xn59G5kBXiyX9TAnYKxKrs=
X-Google-Smtp-Source: AGHT+IFj6M/e6QQ2LcHblyJmroDO1eJydl+9j4MWZLnS9NAi6wXFdP/7JbPd6n88LCxyDfX21aUKabMHyE3BIZugfmuDQlcfSZcB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:318b:b0:3a7:6e34:9219 with SMTP id
 e9e14a558f8ab-3c2d38105d2mr347269185ab.14.1735731381219; Wed, 01 Jan 2025
 03:36:21 -0800 (PST)
Date: Wed, 01 Jan 2025 03:36:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677528b5.050a0220.25abdd.09da.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in __bch2_btree_node_hash_insert
From: syzbot <syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8155b4ef3466 Add linux-next specific files for 20241220
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=113ffadf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c90bb7161a56c88
dashboard link: https://syzkaller.appspot.com/bug?extid=029d1989099aa5ae3e89
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10bcd2c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155d8af8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/98a974fc662d/disk-8155b4ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2dea9b72f624/vmlinux-8155b4ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/593a42b9eb34/bzImage-8155b4ef.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f6dde2a7f3a7/mount_0.gz

The issue was bisected to:

commit 46522a75a47ed8db6da54f37c4dcf934e12fe540
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e2caf8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e2caf8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e2caf8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+029d1989099aa5ae3e89@syzkaller.appspotmail.com
Fixes: 46522a75a47e ("bcachefs: Bad btree roots are now autofix")

bcachefs (loop0): running explicit recovery pass check_backpointers_to_extents (16), currently at recovery_pass_empty (0)
bcachefs (loop0): running explicit recovery pass scan_for_btree_nodes (1), currently at recovery_pass_empty (0)
error reading btree root btree=xattrs level=0: btree_node_read_error, fixing
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_cache.c:215:18
shift exponent 251 is too large for 64-bit type 'unsigned long long'
CPU: 0 UID: 0 PID: 5833 Comm: syz-executor472 Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 __btree_node_pinned fs/bcachefs/btree_cache.c:215 [inline]
 __bch2_btree_node_hash_insert+0x1b1d/0x1b80 fs/bcachefs/btree_cache.c:291
 bch2_btree_node_hash_insert+0x7e/0xc0 fs/bcachefs/btree_cache.c:306
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1783 [inline]
 bch2_btree_root_read+0x5c6/0x7a0 fs/bcachefs/btree_io.c:1811
 read_btree_roots+0x375/0x9e0 fs/bcachefs/recovery.c:582
 bch2_fs_recovery+0x260f/0x3de0 fs/bcachefs/recovery.c:929
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1032
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2200
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3556
 do_mount fs/namespace.c:3896 [inline]
 __do_sys_mount fs/namespace.c:4107 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4084
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15c224ca4a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd1e726af8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd1e726b10 RCX: 00007f15c224ca4a
RDX: 0000000020000180 RSI: 0000000020000540 RDI: 00007ffd1e726b10
RBP: 0000000000000004 R08: 00007ffd1e726b50 R09: 0000000000005964
R10: 0000000000800000 R11: 0000000000000282 R12: 0000000000800000
R13: 00007ffd1e726b50 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


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
