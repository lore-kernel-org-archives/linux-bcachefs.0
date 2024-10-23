Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD21459F6
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 13:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729688433; cv=none; b=Lfrsse1u5/HO7dT8vnI1GWrqcYuwpuj7J7PDgffznPm7hmEZ2utwbjlHXFEYCisFiOCFFraBuer+WD9tizbcDID1zAVMJ/VINZxpnVohBHvYs0qKbdlAjIJYyE2tby39NY2l2X6+hhYqMDYb3xj/Df38ok73pp6LblUqg46HM54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729688433; c=relaxed/simple;
	bh=2e5eFoRMwBWRdDE2ylQJjZRlA3BKT2yeIoZzrzYDrYo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HKfwhLdC/DJgp32GdukZ6GBj0tAL8lutZMc3IlImVbaGeUMSZw5KvUeVlhrBW1TGxGOIyjbf3KW+QAKjHe8kXglgYWw8kdYfjG4qG20t6u9ovByzyIxlRM+/irM0RerM7EB2AwvsGZLjCT9aPUHjOAW6/OJIAlNImwzJnbn5Jj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3f7b8b116so6792465ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 06:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729688431; x=1730293231;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lv8HGdtW8ka1/S6gFIq1Rq2zKYfib8sklnV6AOqlWUA=;
        b=TfboJMokn5DsDt7CvjN91k7TVh75Fz4sqxsS/guNJURD02cLxHYMnN+j/dU1VtZ7F/
         SPQrG5UAThb9F26HvmN2s0EfsWuAfdY0lEHB2+IaFNCjOfr5ZMQKVmN4uI3/UXhlW57G
         txGKHAAjRrlFVUOsjdsb5M+vBefNSRYfUMjPeEpfMui9KTPlL3K02t84niUlVBcySa2h
         McpFwHhiFXIStOH0nK9pcr02btdbIR9NRcac0tUyKvlPpj4kaIMmQrX77Tkbba124gWa
         KBIGQeS7mrI3xoGn1pWMwBZFToe3YiZHvJN5oqlTJBnb04wE+hQMfCzLYW6pmL7+flHY
         lQnw==
X-Forwarded-Encrypted: i=1; AJvYcCWs0y2sNlrIH7BBPhMElqiY7ZvWp3kicP0kW/yniZTe14zDZvZBUBtzKCkYSASfpi8bC9Vu6Smdq8Qa1hOyrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzygYj26rVIQ0AuyLMkDPfGqSOwuIPJRHYuCjQ0bv4UBP6e39aQ
	5WPSUpYFUWACXZ6G9U8om7f2e4jZu0wRdk7n0spxOXlsjuFYKhlFHbYFLojMVgxtJLbMDyiagEt
	pNA1zEvMDtLF/72kCp6JDzrWNK+TCdFs7eAP3Cbgmy8s2u9F1jL1Om0U=
X-Google-Smtp-Source: AGHT+IGUCn/VEk9BT4YmIIc0WXyiH9uYsf9Nsnn7RlfQguqLfOryF/RmHdqmwo+50K1VVyVG3KivTIXtyOqsUK3O+k0z6rKVO4dV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1385:b0:3a0:9903:42c3 with SMTP id
 e9e14a558f8ab-3a4d59952b4mr13803855ab.10.1729688430551; Wed, 23 Oct 2024
 06:00:30 -0700 (PDT)
Date: Wed, 23 Oct 2024 06:00:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6718f36e.050a0220.1e4b4d.008a.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in wb_flush_one
From: syzbot <syzbot+bbf8e41759ee46cc56cc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d2b1b3bccef6 KVM: arm64: Shave a few bytes from the EL2 id..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1299d240580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c154e2d4db830898
dashboard link: https://syzkaller.appspot.com/bug?extid=bbf8e41759ee46cc56cc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12244430580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16244430580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ab5b5f1bb836/disk-d2b1b3bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e47b288f7c97/vmlinux-d2b1b3bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1e3e5f0bea26/Image-d2b1b3bc.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/42f1c4ccbf47/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bbf8e41759ee46cc56cc@syzkaller.appspotmail.com

bucket 0:127 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_write_buffer.c:147!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6422 Comm: syz-executor340 Not tainted 6.12.0-rc3-syzkaller-gd2b1b3bccef6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : wb_flush_one+0x15bc/0x1638 fs/bcachefs/btree_write_buffer.c:147
lr : wb_flush_one+0x15bc/0x1638 fs/bcachefs/btree_write_buffer.c:147
sp : ffff8000a44162a0
x29: ffff8000a44163c0 x28: ffff8000a49fa230 x27: ffff8000a4416640
x26: ffff0000d9858000 x25: ffff8000a44166d0 x24: ffff8000a4416720
x23: 0000000000000009 x22: ffff700014882c64 x21: 4200000000000009
x20: dfff800000000000 x19: ffff8000a4416320 x18: ffff8000a4415ac0
x17: 000000000000e6f9 x16: ffff80008b3c8ac8 x15: ffff700014882be1
x14: 1ffff00014882be0 x13: 0000000000000004 x12: ffffffffffffffff
x11: ffff800082899880 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000d9803c80 x7 : 0000000000000000 x6 : 0000000000000003
x5 : ffff8000a44166d0 x4 : ffff8000a4416720 x3 : ffff8000a44166f0
x2 : ffff8000a49fa230 x1 : 0000000000000009 x0 : 4200000000000009
Call trace:
 wb_flush_one+0x15bc/0x1638 fs/bcachefs/btree_write_buffer.c:147
 bch2_btree_write_buffer_flush_locked+0x1370/0x2c98 fs/bcachefs/btree_write_buffer.c:375
 btree_write_buffer_flush_seq+0xff8/0x1130 fs/bcachefs/btree_write_buffer.c:510
 bch2_btree_write_buffer_journal_flush+0x58/0x94 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x524/0xa10 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x98/0x248 fs/bcachefs/journal_reclaim.c:819
 bch2_journal_flush_pins+0x1f4/0x338 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x1bc8/0x1f0c fs/bcachefs/recovery.c:383
 bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x430/0x71c fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x32d8/0x55a0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:2078
 vfs_get_tree+0x90/0x28c fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3507
 path_mount+0x590/0xe04 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount fs/namespace.c:4032 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:4032
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: d4210000 9773b504 d4210000 9773b502 (d4210000) 
---[ end trace 0000000000000000 ]---


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
