Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FA1448C0
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715694999; cv=none; b=on0UcVPJn5gAWp+d73l8JWTvnbREjfP1MU6KjDtYgnt6Jr8UTmOrug0gWbDWZyW5YtC+CLc5pKa8vcip5bNqlu18AmQfDjBMVSYaBA1qSSWAflzg8B7IRXwsssEpOFy2tOGsE84lKsER8Rm+gj5y/vm6ddShLCVp79CMfui8Gfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715694999; c=relaxed/simple;
	bh=Sn7S+V4uXZsXYyY4EJOGhFcEPtvJpEmtg/hLN2fNzGc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=scpYPMEWx4+w6vqUACuCy1xq+7X4PitARJ/kCQ4gMscAiKly0vUEe+wQ/nJ7muYSRacrPI5r+4sgoM1J8aydQprHOenVqyGJHjRlBJjiRF/RaAu4gWmZ/TQzKeLwmGOg2+aJ/dRMmAwzy/yb+8puGhHbq0d6sF7dbtd1G5O7qWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e1d6c70aeaso334491339f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 06:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715694997; x=1716299797;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WnT30DvRJogkaW0YADlT7xatAc/1sAfrQePF7EBfRAk=;
        b=gN2fbw7otfYuhD2PZkZ0LDLCNv/nzYoL1oAMPuUOsoXOXPxv6KejNLsmYoW+qZQjuF
         LiYpc2a1dky3y/XUIX0MDBnc8kZ9xWirxdTiRxd5IsVkkd0sgFRUhaDnE3qDo5jsHH41
         1RhZ4/yJaqMlcK+xUlQcTGM7I4+8gB++yBPkSXbsFZl5a2OP6Bh/qp9Mcw6wpKDKNFMS
         ia0NpF7B70apMR33+anHnNExqZrvvEZmBmCvoI1eZvwhQZ7FY3IDDmqwUHVwYuZ4UFlm
         XyU4qztRXvgL3Eg2K87yiCe4jArfeACkVq8O+XPScSEQ6T8aIqy2DDPDPok63ErFeiyp
         4Y7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVDIGf2jvZM9bW3QPy8V8CtRoEmX9VXrYv4NWd8dig955May3DkFemlT+KOUF7fNymVRan9Hyhhvly33mKhsjWYmRMC6uHaaV7qg+mTD1Y=
X-Gm-Message-State: AOJu0YzXDsbdisRrOFt7baJHlkQNbnBx5zDlq1Hsvm74mLsZ48ueVpoK
	pcWmkvjdR9t1o/EfLMtmQgdHxJPQpQ9ry05HDlwcUz4fUHnTyHRUpV4Mv7V7ZWeq/Rh3j8F2feN
	9VXkNjJnG8t+p2uUOpC/4f2SH5hIjF3y8onAbQ0d6RwIe5FMtINC2JIw=
X-Google-Smtp-Source: AGHT+IHD0Yu2uE0z3DkHFtyjctSeLnLwno4ZUf7y5iKxYVCxNGFBwz0doH8a3bgchbMrsMfhmMlDrMr/wPHiSAIbtllNvK9c8iRj
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29cd:b0:7de:e10b:859f with SMTP id
 ca18e2360f4ac-7e1b519d499mr68383539f.1.1715694996781; Tue, 14 May 2024
 06:56:36 -0700 (PDT)
Date: Tue, 14 May 2024 06:56:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d38be106186a5e45@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: bch_dev->ref underflow, last put: bch2_get_next_dev
From: syzbot <syzbot+a96175a4ea467a49c546@syzkaller.appspotmail.com>
To: bfoster@redhat.com, boqun.feng@gmail.com, frederic@kernel.org, 
	jiangshanlai@gmail.com, joel@joelfernandes.org, josh@joshtriplett.org, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	paulmck@kernel.org, qiang.zhang1211@gmail.com, quic_neeraju@quicinc.com, 
	rcu@vger.kernel.org, rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1440d068980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=a96175a4ea467a49c546
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128cd23f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15244970980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6a0d89f813ac/mount_0.gz

The issue was bisected to:

commit 552aa5486579c18b4f8e7ca03ef88fa573c517b5
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 3 22:07:40 2024 +0000

    bcachefs: Debug asserts for ca->ref

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10d08b5c980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12d08b5c980000
console output: https://syzkaller.appspot.com/x/log.txt?x=14d08b5c980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a96175a4ea467a49c546@syzkaller.appspotmail.com
Fixes: 552aa5486579 ("bcachefs: Debug asserts for ca->ref")

bucket 0:19 gen 51 different types of data in same bucket: (invalid data type), sb
while marking sb, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop0): bch2_trans_mark_dev_sb(): error EIO
Kernel panic - not syncing: bch_dev->ref underflow, last put: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
Kernel panic - not syncing: bch_dev->ref underflow, last put: rcu_read_lock include/linux/rcupdate.h:781 [inline]
Kernel panic - not syncing: bch_dev->ref underflow, last put: bch2_get_next_dev+0x26/0x500 fs/bcachefs/sb-members.h:126
CPU: 1 PID: 5098 Comm: syz-executor215 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 panic+0x349/0x860 kernel/panic.c:347
 __bch2_dev_put fs/bcachefs/sb-members.h:109 [inline]
 bch2_dev_put fs/bcachefs/sb-members.h:121 [inline]
 bch2_trans_mark_dev_sbs_flags+0xaa7/0xab0 fs/bcachefs/buckets.c:1467
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
 bch2_fs_recovery+0x2370/0x3700 fs/bcachefs/recovery.c:804
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
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
RIP: 0033:0x7f7f37cfa8ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff662e7d38 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff662e7d50 RCX: 00007f7f37cfa8ca
RDX: 0000000020011a00 RSI: 0000000020000200 RDI: 00007fff662e7d50
RBP: 0000000000000004 R08: 00007fff662e7d90 R09: 00000000000119eb
R10: 000000000120041c R11: 0000000000000282 R12: 000000000120041c
R13: 00007fff662e7d90 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


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
