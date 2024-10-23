Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E94BDDAB
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693654; cv=none; b=LySMJLt4WdUdsQVl9M5QA63z5bYN8IqnB2X3KsseOVkgMtmHDY0bx7U6c2TUhKCtZ9wMVoitQTk4ggq4zBdIj7GG/4pc5C8Vt4AMzZJY9QHvmO6zm8zQS5WVDjNAOOCVHyq3Oaif0PvoiQIT0YaIOTa7Uzq1ebtwe/Ek+n12t3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693654; c=relaxed/simple;
	bh=wtP/NxJgdxIz8oV9uHmBzipVXqr9N46aFLNrTpRMShY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r/0ojdvJTvWd6FMQUn8JXFUlAwyzJRZ5oadxF0q1Ee9BepXHglNjSFnfe1kmWx4Lblo++vf7WA2a6kNvrHI0DoZD70jq9dewsNY2ColrVjtvCuJCN9uKuh7u+jJLqK0UZljuyp+/L+67ieanIuxNV+vQ5BXlVlrOtbXXGs8PqDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3a5f6cb13so58677695ab.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 07:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729693652; x=1730298452;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+v1VeT6FcS4wrKJrKwXE8lgby5WygTxXqrIqNjOgiZQ=;
        b=bhqPjtc1MPrVeFvvtFe3ZbCn8ntCBxttmBqZqpyNj8yi5lOa7DRuCk0Vk4nWt7ybX9
         LvXcQSrWNK5tcAnwTGOQCekhOkl1oNR+xy1WDyTZTpTnGphh7FR9l7v2MmImK0MrzMNN
         w3m/ISFMNJhZZ+vYV5MlM5lshFQrtoixLkW2PIDYynJD+GDaap1Eor3gX9mz1bp/iUZP
         PhtylUhcmx5rYjXo29kanQNgm7IOYT5NSS9Ms8D1W/XAq7BVU5oYsSyTHLMOTvpEsSKa
         0MA5MGx3fk4dvx96XeaLgPYh6XYZ8guh9WMZaAQGpF0ojGSxMfOeE6FmAgqAzCGqUvZ6
         yeIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlZ8SBKovfu7eWoY3H9cKJUsMtUXAiKTlxVqBitz0uJhMImN0dO8OqgJwrGenYXelJw+cMH9l957IhxedhKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyscwBVP33gKLk0MCN67x4yipymZsvN+5W9P4jVjjsLO+Zj/oXR
	wYTc+7B+sCtwId7mx7DN2nyMQ1MSJcUkz3yAaGv1oHd2MjplXqW/+mWL1Xg1OUWV+y9iqkcXFiQ
	Fbd6yksj/mIFFK09HeJ4dueEg4WPLYqNoV9C3nn/4F1WF5YRtcUGs0t8=
X-Google-Smtp-Source: AGHT+IF9D45qKuktmPAVRe+qc1d+dxucRjP88Tw+D6hNKjf4B4W1wFDhfjPH9NRiWP6YCdb6u43FWZzXWE2HgQ7/y3lFkeri9dlI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:3649:0:b0:3a4:d9d0:55a6 with SMTP id
 e9e14a558f8ab-3a4d9d0572dmr10741355ab.19.1729693652397; Wed, 23 Oct 2024
 07:27:32 -0700 (PDT)
Date: Wed, 23 Oct 2024 07:27:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671907d4.050a0220.1e4b4d.008e.GAE@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in validate_sb_layout
From: syzbot <syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16acc287980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=089fad5a3a5e77825426
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109dd640580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f288a7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d116f71ad0eb/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdd6f545b105/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0d26b05e3d7c/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b13b1120386a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+089fad5a3a5e77825426@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/super-io.c:290:18
shift exponent 255 is too large for 32-bit type 'int'
CPU: 0 UID: 0 PID: 5220 Comm: syz-executor166 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 validate_sb_layout+0xafa/0xb10 fs/bcachefs/super-io.c:290
 bch2_sb_validate+0x8e4/0xf70 fs/bcachefs/super-io.c:442
 __bch2_read_super+0xc24/0x1380 fs/bcachefs/super-io.c:832
 bch2_fs_open+0x270/0x2f80 fs/bcachefs/super.c:2032
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2161
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f55733ccb7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff5b40e1e8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff5b40e1f0 RCX: 00007f55733ccb7a
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007fff5b40e1f0
RBP: 0000000000000004 R08: 00007fff5b40e230 R09: 000000000000594e
R10: 0000000000014001 R11: 0000000000000282 R12: 00007fff5b40e230
R13: 0000000000000003 R14: 0000000001000000 R15: 0000000000000001
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
