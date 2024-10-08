Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CF2176FA7
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728376145; cv=none; b=NTANsUW8sSRa3VGp5b2jekJnacaPdWoiZ2Kdfwx8oOx4/+BzGjp/F5Phlk4CaSb4i7KzCLRCOjqvqQOhI9AiCc/6ma100GXU08MCcu3NGVoY9ibnUK13e6CJKcMjcW5bA6hgq2wSElSYMIabas1BWGqk1KITN9J5Eq/epAKfF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728376145; c=relaxed/simple;
	bh=8WYsiUyZep98SYV76uLxLPFnnAfAHMa5pJgYh/m2LRg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=BYJpmlGL1Edy4shxdnQ+FwtSNcuqPmPSWY7UyJcyjtCNHqxM9KCyEJGpO+Ee000WMefR0a5m7Xrum/dJMNCGQqcmEoj4WL+XN/2t1i4DY1OkzyppVOw0chp2MQZHpS0nnB4dM7xIZKqCddWYIM78OicIMIVB5rKPUdRaDEjG44I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3496b480dso47272545ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Oct 2024 01:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728376143; x=1728980943;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opQU+u83JgVABznkH1cPVQ2hNYodE0DjZgqeo7zgIQg=;
        b=Li0ANy/ww4DHjQ/TYUjnrbLEOdtjEU2DwufhbfxGRdEDtsC/+ITDlbMD5QjO1XLs9j
         6WkIPBpKMbvPqDrpFLdnF3pcqL6wgJ5nPBT/0pg9ij4aecc7HImE+vQ5zTCmWZuiIxne
         FcNT/jUSiXYmGWakaLB4Nz4MfpK1x77PzokdAqCv9jIgZqesIU9VwYJyQ+6F7r61sFUq
         pH2Tsz1uM/oC8iup0Qcp0ka5YrLyxIBp4b2GX++ISoF6fZWlrAk1XKS4b3p3uh+EJD5q
         KUrDFSy6gin2Pj/g4rTnKje/VyEaYhumq3fc6yV7CoO0karydCI79JbmxP5eNCnPP5uK
         KZkA==
X-Forwarded-Encrypted: i=1; AJvYcCXCEd0/2cje0RA7xLsM0im5MeI2Z51TX0qJcit/PNBDdmE9eC3gtGpQGSvUo8JK1wS5tWhl3RGJMkjSwb21Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo95ZOrD8tlr5Xmr5FufVLtrjg8px+hvLQG9cwH5Gf1qqd03LU
	8hwPJcj59yYAdGeWOqK+srAokMREwEk9zP/L6Kj6y6vM2fp3H6MyDfmOE1cptxKtJh19CzVyOiF
	c/ADJIg88SiXc/bIqRoO+K+Rzqep65u02SYfcM2ofjCi8/EAJtQCSfBU=
X-Google-Smtp-Source: AGHT+IEP9cyVf93ub+Aj2npRF8DmXFOoD3HdJOjGkXnYLfJ/FcLsNOIkPOpaEqQ1UpLHpF3DGE8viofcWgEwvrQYG9Aa+FKwOvUl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c5:b0:3a0:be93:e8d5 with SMTP id
 e9e14a558f8ab-3a375a9e2aemr136800145ab.11.1728376142804; Tue, 08 Oct 2024
 01:29:02 -0700 (PDT)
Date: Tue, 08 Oct 2024 01:29:02 -0700
In-Reply-To: <6668bb9a-4775-4549-b24a-54b1f386374e@126.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6704ed4e.050a0220.1e4d62.0086.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_stripe_to_text
From: syzbot <syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zhaomzhao@126.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
UBSAN: shift-out-of-bounds in bch2_stripe_to_text

bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
shift exponent 108 is too large for 32-bit type 'unsigned int'
CPU: 0 UID: 0 PID: 5588 Comm: syz.0.15 Not tainted 6.11.0-syzkaller-08068-g1ec6d097897a-dirty #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 bch2_stripe_to_text+0x899/0x8c0 fs/bcachefs/ec.c:147
 __bch2_bkey_fsck_err+0x11f/0x230 fs/bcachefs/error.c:429
 bch2_stripe_validate+0x3ca/0x630 fs/bcachefs/ec.c:116
 bch2_btree_node_read_done+0x3dc6/0x5d60 fs/bcachefs/btree_io.c:1219
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x626/0x980 fs/bcachefs/btree_io.c:1773
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x24ac/0x38b0 fs/bcachefs/recovery.c:851
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1956
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f862b97f69a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f862c6a0e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f862c6a0ef0 RCX: 00007f862b97f69a
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007f862c6a0eb0
RBP: 0000000020005d80 R08: 00007f862c6a0ef0 R09: 0000000000200400
R10: 0000000000200400 R11: 0000000000000246 R12: 0000000020005dc0
R13: 00007f862c6a0eb0 R14: 0000000000005da0 R15: 0000000020000340
 </TASK>
---[ end trace ]---


Tested on:

commit:         1ec6d097 Merge tag 's390-6.12-1' of git://git.kernel.o..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=132dbb80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6265dd30e362bb47
dashboard link: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
