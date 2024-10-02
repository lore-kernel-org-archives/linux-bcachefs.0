Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB7519D07D
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 10:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727866469; cv=none; b=BuxFmJHTUZMwaZhBJNUIlio87Rep0pe0toUDyeRlHsfHrxLuQqXR3OeKVLCHGIatgLueEQ/Wm5NMbKQtxQ1KLwSD2D4ppHYjuyLyUMvLJyu2n8TaCEyCKlA3JxOuGn8PQ52ANGBXNf56wqeVxNqVje+SYY3VfRbSAvkz4KHLf4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727866469; c=relaxed/simple;
	bh=Jn2w8KbCtODWjc90Pe9cF1uEbew1QeRsgtJCVjrREZU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=s7jG7lp99MiLzs8AsHaXEsPO9iDfk+KZWCZpXz+6KW96F/CvinR1/lp9Nb49OgxAs999Wjl+EdmCV2KuQmL7bd/YIsDnc3rgcx38LfyHo7ot+TEPWRDrviMapkYU0Ph4QG4qwI9d0WyVonj8+EcQxQ56DBNvPnut78kNtAFG4r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a19534ac2fso97115595ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 03:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727866467; x=1728471267;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RoAmgCGX6l11CJrPMpadAIjDi4yqQdtg+my/4u5cLJc=;
        b=baVuD5+lmLsIx7w8xRC73Bgl1m6YY2ow7DjDkJHymW2IWHXubvMJS4Uizzbrbhn0gH
         7MMgUClBHg9yKO0hVElVagbHC/dhCkFOCadRJfnbT0SbdZpVAsp1lKrKAom/r7Hnkix2
         H8CgI5RNx3TEJBbISDIVtV8mvPbr4JxvLXtOfsb1ETuxGso163fvdq5YvKAXcCYTkB3C
         yUH7hrxEEwbbYwfM6tNUWVIe16eYIg34ZXno/ylnrnldfRCcAe2rFNvY6tAHWgNjzhE1
         k50gEoa6zQXNEqUHJdey4olE2hPEcfnp4+I/7uh1gzabw45Bfu4g7vMSOQ/h16cQzO2j
         Rtvw==
X-Forwarded-Encrypted: i=1; AJvYcCVQ9Urn3pe0cYEjG5UZkxX+Z4jVeWTqumgBNVVlhQvthw4e7i/ARa9TUhtORlP+YuwJ6GB2F7IfLMvUxDl0kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLV4YeEvl8ybVqcTg2imuJ+Zc/EtvCYZIvGPKtsi8aD2n+AJdk
	7plT58nVjeUUXafu8GQ0/dn5J3zxnE7es1z61xpPSghJdD6lmp7kvz/HMd4DN3VXmnK6GGucZ2I
	hsePUq+QePjSu56i+6rk8uBZkvzOxVC/WQHdAuWr71l5TTRLoAN94clo=
X-Google-Smtp-Source: AGHT+IFSdZLEVX0XsSeTY+JX4BnJvLpGs7RPfv1RodEHrYWIWyVQQLXTjxkqWD6LhGiDLU0sCvTv6ixUirPUevizRy6LNnoCk66+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180b:b0:39f:60d7:813b with SMTP id
 e9e14a558f8ab-3a365954717mr24003675ab.22.1727866467591; Wed, 02 Oct 2024
 03:54:27 -0700 (PDT)
Date: Wed, 02 Oct 2024 03:54:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fd2663.050a0220.f28ec.0510.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in __btree_node_pinned
From: syzbot <syzbot+9f41e4b255897d99d4e9@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ad46e8f95e93 Merge tag 'pm-6.12-rc1-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13b3d507980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62086b2fd100a029
dashboard link: https://syzkaller.appspot.com/bug?extid=9f41e4b255897d99d4e9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b69e80580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1567c6a9980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ad46e8f9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/72b7539cbeb1/vmlinux-ad46e8f9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/73c9b9cebaf4/bzImage-ad46e8f9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/54e2032c8f9d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9f41e4b255897d99d4e9@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/btree_cache.c:198:18
shift exponent 227 is too large for 64-bit type 'unsigned long long'
CPU: 0 UID: 0 PID: 5109 Comm: read_btree_node Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 __btree_node_pinned+0x80b/0x850 fs/bcachefs/btree_cache.c:198
 __bch2_btree_node_hash_insert+0xcfd/0x13e0 fs/bcachefs/btree_cache.c:270
 bch2_btree_node_hash_insert fs/bcachefs/btree_cache.c:287 [inline]
 bch2_btree_node_fill+0x94e/0x1200 fs/bcachefs/btree_cache.c:932
 bch2_btree_node_get_noiter+0x9d5/0xf70 fs/bcachefs/btree_cache.c:1238
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:190 [inline]
 read_btree_nodes_worker+0x122c/0x20b0 fs/bcachefs/btree_node_scan.c:239
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
---[ end trace ]---
Kernel panic - not syncing: UBSAN: panic_on_warn set ...
CPU: 0 UID: 0 PID: 5109 Comm: read_btree_node Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 panic+0x349/0x880 kernel/panic.c:354
 check_panic_on_warn+0x86/0xb0 kernel/panic.c:243
 ubsan_epilogue lib/ubsan.c:236 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3e7/0x420 lib/ubsan.c:468
 __btree_node_pinned+0x80b/0x850 fs/bcachefs/btree_cache.c:198
 __bch2_btree_node_hash_insert+0xcfd/0x13e0 fs/bcachefs/btree_cache.c:270
 bch2_btree_node_hash_insert fs/bcachefs/btree_cache.c:287 [inline]
 bch2_btree_node_fill+0x94e/0x1200 fs/bcachefs/btree_cache.c:932
 bch2_btree_node_get_noiter+0x9d5/0xf70 fs/bcachefs/btree_cache.c:1238
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:190 [inline]
 read_btree_nodes_worker+0x122c/0x20b0 fs/bcachefs/btree_node_scan.c:239
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Kernel Offset: disabled
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
