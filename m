Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42E19D8AC
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 11:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739617762; cv=none; b=dbhaFPi0hD5ivUL2aHCxR7BUHDpPWIh6pRxESbPBOL7Eu/1GgxMVQAYzrxmgrICcEl7ou5nXMJXJWw/GtLVYuzN1uPQ7xIn1eXQ3yV9C9PNLoKIg0NV98X27mR8ylNs89MOYvDDaNcTGpv6WffxKCtqQ7Q5S66Zfuy7t7wPErjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739617762; c=relaxed/simple;
	bh=QsTM/b/ShaDvJLchPA/QcVpGiASWAv4GsSCkVYtg+P8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ahr/PMBHwoZefv+XyiWWjdsFzJnJ2xrIWZlk7LMe1CPkOeE7yDgkDeU4NDvxY83OuLXQUSD6AL2vOux7CrXY6JotGBhs4J0w5Bpj7eg6rTLPj4ACgxiFdjMbCsMiudBqAL96AiNIil/kSdhAJJPrYhwPpcsHQ3GPgTSl5xH4KqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d18f21d202so20947255ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 03:09:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739617760; x=1740222560;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+msdTiV3dh/grEx5HhcNgwCDceZ8oekmj7XtrsfSAkc=;
        b=CfHNevh6bglTa4jTXFE4BpQ/wh0+78BNjd4pwQaVOSq523b+CLqOguBrklxghrdC1e
         xT86rdtZiG9iFJv5mIKRU2O3dx8H2u7YwDjngxH3/8Pkjwb0M5wEdLV6/FGAYrJ6xUBi
         jBMI30TY5HR7yklDykmy3fuhm/BmYohiQwPfwxBGP7FcWdHooFkSBKigDOSC+iualZh3
         y24V1F582HVUORvkbPtoqvqkM/akQsUziRBvrVCPgRl/W9WdstuNdU7dd5noKBeHcjZO
         4wnz7QGON70jqYM4emxq+Hqe3O4vdQwNMwcYOvupnbDIYZAjtVHQlUksbDe3QzrS+AcV
         clTA==
X-Forwarded-Encrypted: i=1; AJvYcCXrMKsC+Cc4ZRNHjuZ0pN4vq4te8WsZOLXn/cKGtGwezGUTMydA9ZZrrFwOGoDY+y1JBC4xS9dMjQcDkAviYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy52AWO2obzTT8LqMM+YEZtj1jLlrXjrHzi7J/K4sUSawN4Jmh9
	hW0/ukgAEHEL5iECav79I9juNIUlNUkvRf/2v6OWOCTn7OoBdqMWX3+3neVm3lOYi0MTt2OaZqA
	PFk7cad31TxPk/JxOIolLBx0L4NdOFNrxM3kQqGVS5amzuf37dXR1ONo=
X-Google-Smtp-Source: AGHT+IG0HPosK62MBkh0uJdYlIhmznYl7gKiqEuRjj1CvH4+aBPVZnnatYPvX2F/VUJ5jPcY5MTOQIqRSiPv2utSM/QMFHbD2cfo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:3d0:47cf:869c with SMTP id
 e9e14a558f8ab-3d280949c9emr16539415ab.19.1739617760343; Sat, 15 Feb 2025
 03:09:20 -0800 (PST)
Date: Sat, 15 Feb 2025 03:09:20 -0800
In-Reply-To: <67afa09f.050a0220.21dd3.0054.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b075e0.050a0220.6f0b7.0002.GAE@google.com>
Subject: Re: [syzbot] [kernfs?] [bcachefs?] UBSAN: shift-out-of-bounds in radix_tree_delete_item
From: syzbot <syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    04f41cbf03ec Merge tag 'sched_ext-for-6.14-rc2-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158239b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b399a4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17dd4bf8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-04f41cbf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/04aaec67f85e/vmlinux-04f41cbf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b8db5fac3a6/bzImage-04f41cbf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/402dc55a596d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/radix-tree.c:88:31
shift exponent 240 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 5331 Comm: syz-executor299 Not tainted 6.14.0-rc2-syzkaller-00228-g04f41cbf03ec #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 radix_tree_descend lib/radix-tree.c:88 [inline]
 __radix_tree_lookup lib/radix-tree.c:766 [inline]
 radix_tree_delete_item+0x1df/0x3f0 lib/radix-tree.c:1420
 kernfs_put+0x1ba/0x370 fs/kernfs/dir.c:575
 __kernfs_remove+0x768/0x870 fs/kernfs/dir.c:1509
 kernfs_remove+0x7a/0xa0 fs/kernfs/dir.c:1529
 __kobject_del+0xe2/0x310 lib/kobject.c:604
 kobject_del+0x45/0x60 lib/kobject.c:627
 __bch2_fs_stop+0x288/0x5c0 fs/bcachefs/super.c:641
 bch2_fs_stop+0x15/0x20 fs/bcachefs/super.c:691
 bch2_fs_get_tree+0xdee/0x17a0 fs/bcachefs/fs.c:2299
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f17e484402a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f17e3fe7fd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f17e3fe7ff0 RCX: 00007f17e484402a
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007f17e3fe7ff0
RBP: 0000400000005900 R08: 00007f17e3fe8030 R09: 0000000000005931
R10: 0000000000010000 R11: 0000000000000282 R12: 00004000000058c0
R13: 00007f17e3fe8030 R14: 0000000000000003 R15: 0000000000010000
 </TASK>
---[ end trace ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
