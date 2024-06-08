Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C652E208A7
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Jun 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717884927; cv=none; b=Eg/6V0InAkp29RCEffzMDpcVECqs07vllMsnMXx4DeDOQZEuuuPSRdE9RTYg5DTgTCFC6YxUWL6goexW2AIcG6/S5T4a64Tir0u2ZcnPxl4eJMM0F1Xnl+y6d9WVgKj+dv7GRi+pXTeVAwf2xO73LiCqwugj4KhztJD6WUMjn80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717884927; c=relaxed/simple;
	bh=L+XFKR9UCJTz9ouj9QF2ybokOAy4hoOFeB353+qGyEo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TcQL1HiaXPm/xnEc7wai0sIv92hg70E39unurau+a4USsOLkU+U2/Ed5S7Js7pekGOlSagsN2iwhR3u50h54+XqfDRXI8nMvl31VmYugV8dUbAjaZNE9oiHsAkRJDHOABpCTLKB/LU05EpDRKY5DHxUkkdxjgrsKy143nXrailg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e8e2ea7b4bso411973039f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Jun 2024 15:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717884925; x=1718489725;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nh+Qcv/a65RsARp7hlRUgmHh9ym5Laqv0AiY1NOYVvM=;
        b=nT42QhvDwyYL2ZqckQ8SzD4OaSB9Mt7rzXZX5aouOKGdx/paqPTMAfyZmhhzq8uwWN
         7JJuMp5MyY+KMKSNfetyfUhAmNdgV1Ije0D4I/IFF+ipsGeHaIU+aBwntFK2HYvBM/Oy
         4V57FB1PKXQwWLOojUNVeXZe37LcIaVik8qq1wJ3WMvywIN1GB8ICsZSWcR+QbgMfWn9
         23UzaYgbGYnegtTq3EvhDZVrxMu3k+J9bvVNiUMacw7T3vnfGGXc1paa7RvKu/h0JgX4
         2v3gujyV8vgayw3DCyKFQLaL7W+GH3aqR13eqPUKEux9k4lIWnDJbRlAD/T6TYdxPDXz
         cMEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcagyPv67qMhqGJX1NQprIm4UUnYdCoe5+lZPYDMXrngvsxQ2Z050iwOSj3idTavubxKRyeLsVRahO3wg5Ry9qOkk+KkCwnRsbZGTFV0A=
X-Gm-Message-State: AOJu0YxpNQ5VQkEvy1KCZpAbG82VOaawEIRxeUzHv8h1X1ZDb+dHg00F
	C4XLk53IbKiK/ZZOCvR4XLqceVugO3oElumnW3RNGtmOT8zlsrjtAr8apw3OS6qfOgFI7M/85zN
	ixJwmiEzetCqo5QZNBS638tAze91YeBfA36AxIFcmWOg8tr9GshuwlJM=
X-Google-Smtp-Source: AGHT+IEotM2Q4rFWH4L5M3Z4txG7kMKQjeQvqr2VQhPF4X4O9feQxEHFB84e4JwK3q+2elZTfFQx/RsjAmK4eVB5p6WVipOInlmP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8527:b0:4b9:fb0:fd43 with SMTP id
 8926c6da1cb9f-4b90fb1070emr437173.3.1717884924932; Sat, 08 Jun 2024 15:15:24
 -0700 (PDT)
Date: Sat, 08 Jun 2024 15:15:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b74056061a6840af@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_bkey_swab_key
From: syzbot <syzbot+51837cbb6ca165f5344e@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d30d0e49da71 Merge tag 'net-6.10-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17cac096980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a6ac4277fffe3ea
dashboard link: https://syzkaller.appspot.com/bug?extid=51837cbb6ca165f5344e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6d0ced9b3d02/disk-d30d0e49.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd5917307028/vmlinux-d30d0e49.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cda11b4554fe/bzImage-d30d0e49.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51837cbb6ca165f5344e@syzkaller.appspotmail.com

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey.c:1067:27
index 5 is out of range for type '__u64[0]' (aka 'unsigned long long[0]')
CPU: 0 PID: 5185 Comm: syz-executor.0 Not tainted 6.10.0-rc2-syzkaller-00222-gd30d0e49da71 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_out_of_bounds+0x121/0x150 lib/ubsan.c:429
 bch2_bkey_swab_key+0x224/0x240 fs/bcachefs/bkey.c:1067
 __bch2_bkey_compat+0x2b3/0x1030 fs/bcachefs/bkey_methods.c:402
 bch2_bkey_compat fs/bcachefs/bkey_methods.h:133 [inline]
 validate_bset_keys+0x608/0x1a60 fs/bcachefs/btree_io.c:915
 bch2_btree_node_read_done+0x250a/0x6750 fs/bcachefs/btree_io.c:1148
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1345
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1793
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:475
 bch2_fs_recovery+0x2346/0x3720 fs/bcachefs/recovery.c:803
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
 bch2_mount+0x6c0/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe09a07e66a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe09adffef8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fe09adfff80 RCX: 00007fe09a07e66a
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007fe09adfff40
RBP: 0000000020005d80 R08: 00007fe09adfff80 R09: 0000000000000018
R10: 0000000000000018 R11: 0000000000000202 R12: 0000000020005dc0
R13: 00007fe09adfff40 R14: 0000000000005dab R15: 0000000020005e00
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
