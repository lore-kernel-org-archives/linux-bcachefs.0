Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DBB2E174B
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Jul 2025 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584966; cv=none; b=UO5iR8OXMLlvgn/wG3rDBivNSV6aH3gP55Az2tVqK26FTmzX/XsFrvB9oXaAzjB1RgOgPiqATCBzSznUn1e0fP+SRUcos9VXj6urCwjoV/LmaMXNZy5MosURbZity0WnZ4wFprB/CIBnc2AxMicGYN9K5tjn7hjRv4JYNjEdzvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584966; c=relaxed/simple;
	bh=djF+zPGKM8JtGU9a35ywnIIaA/Y7bfws5UsdU90/5YE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ivKRacpAoeeH7pg/eNdDiuAPvFjsofRreHM9fkhFWKZp5LhoO25tCPi+YaFv2kmppqZM3xMdSOsVfIQr3DlAxg+EGZDGucOYb8zUnR32w4eNkAVuUeJjRTFhm6nt+9PMbJlja6arbV+FbNxDoZRIP8MWwJ2REKUGuOBAtGu0DQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86d0aa2dc99so561541139f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Jul 2025 06:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752584964; x=1753189764;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M7lMbOmndqVY+BYfCySLtcIi0O/Fdj4Vy8dOUynDUIU=;
        b=W6PXqXLdX0r/UmCy7XdvPFGvqXqClMN8SSH1yStqN54T7ozkSB4pi1ofvO/fYWvflX
         rCGQUn9TDCn9kP9WcbbrPi1EvUe7VsgW2krIIUdqZzRuc0a2gab6jYdcSole4+RIoBCT
         MXRDiGGIUNzqYAaGQoizs3jBZdo0xBptV/BGLBUtKkRxV2Cf3IlVvyE5SKEqkg/cjMMn
         SpIAq8V0B6NGEVjZ8CChtmgHNifHns4FfGVbN2gTQLEw55P4giuJO52tEjjKlnc3Wa29
         g9r/EPPgXmMFjhEapRHvqBTH5ClVMNhPUhGTL8eukInMHDAwKsZogstjimIqcD7hrvdC
         uy+g==
X-Forwarded-Encrypted: i=1; AJvYcCUKmHsmSVSd6NT7vZNZeh4hKXacZVEv1T3x0I+jhnhQOH0iTZtCw3LjuBtIa4Nvx2MwXA6brzay6v58TJxgxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxdEQd9xP9k1435DWPZrwIVMFzRbGYw4yI2Wfm4AxTWD8wMxp/2
	UJlsPIjwMIoU3kCDnUl4sPBQBMLXjEEWV0qUpEFijOdNTw2iVcxMCnmZldvQir5SNiZNf/Xy/0j
	bQEosT5tHsIqUS9pdqhRcLVbT4ny1t3lFQ5DojqJHOzBKho+4dU7cwN+jGAM=
X-Google-Smtp-Source: AGHT+IHSqmd2FLGYLv1ftVR+Y4fO+Xrf5bszMEVgqnFkxLVVr7F2ULal8RMS/drct7yUa684W0t4mErpITqHtQAJfBNN9UCsfBjp
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:60c3:b0:879:674e:2c73 with SMTP id
 ca18e2360f4ac-87977f54b53mr2031258339f.4.1752584964207; Tue, 15 Jul 2025
 06:09:24 -0700 (PDT)
Date: Tue, 15 Jul 2025 06:09:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68765304.a00a0220.105e77.0000.GAE@google.com>
Subject: [syzbot] [bcachefs?] [squashfs?] INFO: task hung in
 truncate_inode_pages_final (2)
From: syzbot <syzbot+760777ae7038cad77437@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, phillip@squashfs.org.uk, 
	squashfs-devel@lists.sourceforge.net, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ec4801305969 Merge branches 'for-next/core' and 'for-next/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1323ba8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e99b6fcd403d050
dashboard link: https://syzkaller.appspot.com/bug?extid=760777ae7038cad77437
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d38d82580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ba0f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/64d8dc107d9d/disk-ec480130.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/31280b2dee28/vmlinux-ec480130.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b3f9fb3d09f8/Image-ec480130.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9b3f4e51e5f9/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+760777ae7038cad77437@syzkaller.appspotmail.com

INFO: task syz-executor:6656 blocked for more than 143
INFO: task syz-executor:6656 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc5-syzkaller-gec4801305969 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:0     pid:6656  tgid:6656  ppid:1      task_flags:0x400140 flags:0x00000019
Call trace:
 __switch_to+0x414/0x834 arch/arm64/kernel/process.c:742 (T)
 context_switch kernel/sched/core.c:5401 [inline]
 __schedule+0x1414/0x2a28 kernel/sched/core.c:6790
 __schedule_loop kernel/sched/core.c:6868 [inline]
 schedule+0xb4/0x230 kernel/sched/core.c:6883
 io_schedule+0x84/0xf0 kernel/sched/core.c:7728
 folio_wait_bit_common+0x56c/0x9e0 mm/filemap.c:1317
 __folio_lock mm/filemap.c:1675 [inline]
 folio_lock include/linux/pagemap.h:1114 [inline]
 __filemap_get_folio+0x1ec/0xc38 mm/filemap.c:1928
 truncate_inode_pages_range+0x38c/0xe18 mm/truncate.c:388
 truncate_inode_pages mm/truncate.c:460 [inline]
 truncate_inode_pages_final+0x8c/0xbc mm/truncate.c:495
 evict+0x420/0x928 fs/inode.c:812
 dispose_list fs/inode.c:852 [inline]
 evict_inodes+0x650/0x6e8 fs/inode.c:906
 generic_shutdown_super+0xa0/0x2b8 fs/super.c:628
 kill_block_super+0x44/0x90 fs/super.c:1755
 deactivate_locked_super+0xc4/0x12c fs/super.c:474
 deactivate_super+0xe0/0x100 fs/super.c:507
 cleanup_mnt+0x31c/0x3ac fs/namespace.c:1417
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1424
 task_work_run+0x1dc/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x174/0x1f4 arch/arm64/kernel/entry-common.c:155
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:173 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:182 [inline]
 el0_svc+0xb8/0x180 arch/arm64/kernel/entry-common.c:880
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Showing all locks held in the system:
3 locks held by kworker/u8:1/14:
1 lock held by khungtaskd/32:
 #0: ffff80008f8599c0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x48 include/linux/rcupdate.h:330
2 locks held by pr/ttyAMA0/43:
2 locks held by getty/6289:
 #0: ffff0000d314d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009ba2e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x34c/0xfa4 drivers/tty/n_tty.c:2222
1 lock held by syz-executor/6656:
 #0: ffff0000c8c7e0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000c8c7e0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000c8c7e0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6739:
 #0: ffff0000dbe180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000dbe180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000dbe180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6760:
 #0: ffff0000c90c20e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000c90c20e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000c90c20e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6787:
 #0: ffff0000d3e2a0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000d3e2a0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000d3e2a0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6808:
 #0: ffff0000d89180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000d89180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000d89180e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6839:
 #0: ffff0000f2aba0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000f2aba0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000f2aba0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6876:
 #0: ffff0000dd8f40e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000dd8f40e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000dd8f40e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6909:
 #0: ffff0000eac320e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000eac320e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000eac320e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506
1 lock held by syz-executor/6942:
 #0: ffff0000d65fa0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff0000d65fa0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff0000d65fa0e0 (&type->s_umount_key#54){+.+.}-{4:4}, at: deactivate_super+0xd8/0x100 fs/super.c:506

=============================================



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
