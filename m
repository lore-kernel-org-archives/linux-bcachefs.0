Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957E15101A
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715596538; cv=none; b=I877M4Yk4ZPkuboO+r0YfCaHjTB6OvTllAWUCGdvZ2UZ2LSaHwgreflCKV4uKCT8IP75ofRXG3C8v2b4VGO/OGe5t+8IxzVxos+6ptOEAlFlAmgkA6GH0zVpa4yFQnGJD3ZGfwjEL05KdnFufX5wWdvtoDdoCNcxwsokahpxl6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715596538; c=relaxed/simple;
	bh=RPrGrVB9fT+7Zb18GcXigzdPgH3BQ8elfRGvlzUbfkI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=k7YToQCQcN6859bmGIp4eCL1FqGNnol/wsHAP2hb9q887rTfPivkHe5j3ievEbpuUuPHQYZJ+QSYgEDf9N2G32BMbvDkhbx+090fmCQHPF9j3O5yc6hJrIH5jYeQ0Mc2szk/mx2U4P9yHPhVxJMz/m8fLafYae4Mgso0klKWOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1ed1af8aaso18632339f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 03:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715596536; x=1716201336;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wCH0thGYj8BffVTGeojaBItzNMGN/I5jPGJgTe9QIUM=;
        b=K416xnHC/7jJgL5tAMHFoLyCOhQiFY61GD7DKoTXmlXhpUTOLrWJkCLX5RlhqA0Rey
         SvOpJab0QRhcsb1SufvEVnnSQBZe2ONGg61X68RUKYrgiwspaADmxz4Hdzw4mJI5FcWv
         rvsnth0VLIiKL7499sRToiFbkigQEggUSP5LiTNLtdxCH23Y+/7W1Q/kuv+MITlqX1A9
         sZpNknbSJvlxVUDOjz+nPomIm04zV+x70sGu1WLU7tseXhx5ADx1Q5kPz6dEtDkuVZfI
         Ylt6p6aEQ3jsWsSBm6lXUSxFHgqMNDAuco+C5Mh33SbMIxM78fHmqCseBBmXetZEGBi/
         R1Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVB7gBudDWvW96YcXZDmyz0DA218sNzDyr/mrS8uC5qUcKWvNLyuxqWPcI73ECyvkw+0unMQPvLBbgKrWRzxhy4AZ3g9wMdnaM4mrMuLnc=
X-Gm-Message-State: AOJu0YyyVWwvnq6JLoK0j6xD5YK34R2SiBGIgb6cCnEoKEDnBWqGDKVq
	p+JAc2LzW5mtkN7Z3EtBQrfNnojSe+Bc2Ft6x9nSVyjaCrYy3TjAqV4KCL1r84DF42ODPowcFpl
	5jsKCoPRlTTcnBMu2c/p1h6gVc9IRnOxRF/o052BWW28OBDmLgXEuOgc=
X-Google-Smtp-Source: AGHT+IF8QLfmdruQJFExZq+TMqclpsM7Xo61vygnBgJwrrUKSPgFUwZAKwbC1YNubiEoRM5uXDvAw/ACBkuyj+OU0g9bNO1WVzjy
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d3d0:0:b0:36c:7f2c:805a with SMTP id
 e9e14a558f8ab-36cb7730557mr2629525ab.2.1715596535823; Mon, 13 May 2024
 03:35:35 -0700 (PDT)
Date: Mon, 13 May 2024 03:35:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000188f2d06185372ae@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: bch_dev->ref underflow, last put: bch2_trigger_alloc
From: syzbot <syzbot+5c7f715a7107a608a544@syzkaller.appspotmail.com>
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
console+strace: https://syzkaller.appspot.com/x/log.txt?x=169304e0980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=5c7f715a7107a608a544
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144834d0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c06d24980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c5a442f16c7f/mount_0.gz

The issue was bisected to:

commit 552aa5486579c18b4f8e7ca03ef88fa573c517b5
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 3 22:07:40 2024 +0000

    bcachefs: Debug asserts for ca->ref

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a9007c980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a9007c980000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a9007c980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5c7f715a7107a608a544@syzkaller.appspotmail.com
Fixes: 552aa5486579 ("bcachefs: Debug asserts for ca->ref")

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 8
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bucket 0:4 gen 0 different types of data in same bucket: btree, sb
while marking sb, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 8
bcachefs (loop0): bch2_trans_mark_dev_sb(): error EIO
Kernel panic - not syncing: bch_dev->ref underflow, last put: __bch2_dev_put fs/bcachefs/sb-members.h:110 [inline]
Kernel panic - not syncing: bch_dev->ref underflow, last put: bch2_dev_put fs/bcachefs/sb-members.h:121 [inline]
Kernel panic - not syncing: bch_dev->ref underflow, last put: bch2_trigger_alloc+0x2934/0x3b90 fs/bcachefs/alloc_background.c:913
CPU: 1 PID: 5093 Comm: syz-executor498 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
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
RIP: 0033:0x7facf885c8fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe54cb8d38 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe54cb8d50 RCX: 00007facf885c8fa
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffe54cb8d50
RBP: 0000000000000004 R08: 00007ffe54cb8d90 R09: 0000000000005b4c
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffe54cb8d90 R14: 0000000000000003 R15: 0000000001000000
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
