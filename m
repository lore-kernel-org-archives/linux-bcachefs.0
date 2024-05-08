Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9713FBAE
	for <linux-bcachefs@vger.kernel.org>; Wed,  8 May 2024 08:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715155889; cv=none; b=OcLMa/KLKjeoSQi05Uris9/Zq44cTCwFyYaOrHE/bTU5W6xsxo+gtO2NgonHti8vM/OOkPPkMbxIR31F7wVLxvveL94Xpex/QeHoLZ9vJbyNzEuI+L8kPDntxu7P8pvmh9OWix/DlsCxWVg74VIQuKmlYLobCUitN6FJYIJndCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715155889; c=relaxed/simple;
	bh=saxFz38dozy1mF1iTqtAanoNI9EUBodlVOT3bIkWB5A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Bg2bx4BWYHDqxJVdALLHSQgm24qXGGGKkjJvuLm1BBzTVZsUja9pgP2KqXKJJIlKVYoURkeZS94aQ0lPylHT+HbDTgBI4zx9eJuDguMfn7k6seBRCqRVyHqsP5+idt15Jl9CpwiS1NpIh6zQn5TVud/NPjkHlpu2ndjfz2sWIq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7dab89699a8so462964139f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 08 May 2024 01:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715155887; x=1715760687;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1TC4P/faER2lAvVgIfDbtDWGEj4zknODtVb17Ze9sQc=;
        b=kRY8eZMivHH6xglr1dRVufLlA4nZC/oSts12vaxYTz6B1MLs4BDJ+0b3jX4NlSzW/Q
         oR+LJ/s9CZOybkGU7V97WucFoDpyMUEQ+JIGv509uxuUxlLkLP7fLpLWTgHTovACxmeF
         BGKBk8wk8VoyVxCq61ctFfYzJ4uUxp+Q5WZPOn5OcpoNi0tTt8kuTRC5Piu6avSlrj8/
         QkUy2YGBiLM3MBLgqEpajSmlaS2dJU2v6zMXKPa5+1QJN7OYlHcwNaCoSLNCreccrIh6
         ibdacyXav5XhU7RwL1OSEda03qzD+ogVySOCOQcEZaTOioaHvU8MCTxLQb6SGjW2h7Fl
         C63Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5wflBWwrjOX6r1SttQcgR6DPbU7tKC2kgDy/2PPUc//VfQhHb+6IPPkNV9DjGKXWrMHGdpsRzqBpyMRaQ80uoMgSFaontd9YrdUCAejQ=
X-Gm-Message-State: AOJu0Yy0DYLmeQ+rb5S8AlmojPRzDe8gZgE2F9PnZFxcEbqfEsRCL/rR
	HPafylVNfjuCMRawcmKrdVUOTnXXMi0FOX2J/pkGUQmDmSgv0opluT2ZCiP+0MMYhBgBbqRP4f8
	MggGmZqDON/rRXw2ry0Q6OwSNVGvwzV63QHM+F4cNkghIxcPfpX5GK/k=
X-Google-Smtp-Source: AGHT+IFgdbj6+sIkAGoToRnJPBmkbWHMq5sVU4eRFthIoz0S0PkhOpDpwMsH0rgxzOLiMI3IvKdgBCzhZ+dNiex9WuLAD5SUsQqj
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2389:b0:488:59cc:eb4c with SMTP id
 8926c6da1cb9f-488fdd5553amr128283173.3.1715155887604; Wed, 08 May 2024
 01:11:27 -0700 (PDT)
Date: Wed, 08 May 2024 01:11:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a59f00617ecd989@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_bkey_format_invalid
From: syzbot <syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9221b2819b8a Add linux-next specific files for 20240503
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=153b20e4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ab537f51a6a0d98
dashboard link: https://syzkaller.appspot.com/bug?extid=9833a1d29d4a44361e2c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114b7a50980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b7ae87180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3e67dbdc3c37/disk-9221b281.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ade618fa19f8/vmlinux-9221b281.xz
kernel image: https://storage.googleapis.com/syzbot-assets/df12e5073c97/bzImage-9221b281.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d64ba6155455/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9833a1d29d4a44361e2c@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/bkey.c:663:22
shift exponent 254 is too large for 64-bit type 'unsigned long long'
CPU: 1 PID: 5092 Comm: syz-executor406 Not tainted 6.9.0-rc6-next-20240503-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 bch2_bkey_format_invalid+0x46c/0x5c0 fs/bcachefs/bkey.c:663
 validate_bset+0x168d/0x25a0 fs/bcachefs/btree_io.c:824
 bch2_btree_node_read_done+0x20d2/0x5ed0 fs/bcachefs/btree_io.c:1142
 btree_node_read_work+0x665/0x1300 fs/bcachefs/btree_io.c:1345
 bch2_btree_node_read+0x2637/0x2c80 fs/bcachefs/btree_io.c:1730
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
 bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1793
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:472
 bch2_fs_recovery+0x2334/0x36e0 fs/bcachefs/recovery.c:800
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1030
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa35434c8fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff2b30e848 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff2b30e860 RCX: 00007fa35434c8fa
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007fff2b30e860
RBP: 0000000000000010 R08: 00007fff2b30e8a0 R09: 0000000000005d8f
R10: 0000000000000010 R11: 0000000000000282 R12: 0000000000000004
R13: 00007fff2b30e8a0 R14: 0000000000000003 R15: 0000000001000000
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
