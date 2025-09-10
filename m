Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7549825BEF1
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Sep 2025 03:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757476652; cv=none; b=Vac5SPaxaJYeGVVXMPn1TdraxPbvG7CsCjtNp9Q729W2L0NNUxFX94rD2suA3HtfycY4H6M9D5NpbUXV9chIl5HGaf2hj/ZALbngf6KMsBvhFF/ZRfyW3snqfkJwI+X8r17dJII5NFh+IOKQ26WZt6Oi/7JNfuL0ud8FyjOIHvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757476652; c=relaxed/simple;
	bh=rf3DjgxUrBKrYUFE9I9OjwuryvDuk0AAkRuNuc12/4w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MmmlS3BdYcdOPH10WSXKHPsUMUoCnVPZSpLEMaMFstqdN/22PL2D5wgiZvpQzExbvcJ4rw7cERrs30EuiATAks2ItbyVQIUZ/4K2uN/Tk6coJvSENGh8tUkbZno9zpJ0vswHjx8iE1WnYZ4O1vP2kmgMmmA8wziZ71NDM6z62ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3f65be4978cso65676695ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 09 Sep 2025 20:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757476649; x=1758081449;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gEF5WB3tiM+Wse74JfZu0iIEH0MznCJx0P6dgVuoz3U=;
        b=a25HlXxStVZjfJgWQpQjQhnjOxHeHQHxqVb1bZ/LnyFsQf+zL1WXGs0OATte0yGw6u
         9vMg/vEtKb94Qd85dheRI0I9sCDMS6Q6o1CR/rOClderDNTvb+fKv0C97P2tD/OcK53m
         OAdiKpREMUbiiOcCc46Vp0kyRHP/AAEewanv8fYZrqSan2qbak0faf8NaPFs358He5fD
         vihD4LihRQipcCAEowTF3UAJg7M+EEA0Pl2E9CbVHEyyR2UM8aUevlJwVkLu+XZ6Abll
         +AJFZSdVrBim/4mTicHJ9vSsUC+lf1KKHEB5C7uvI6Ctpyf+Fz91Cfrri3+WofUPP+7h
         HQuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/+soDzQBS4YMxvA8VuGqxjxaz414VqEzE2GWXiFQH17iEmHwyVTYs8+X//ecVLZF3mAwCiq5pbcOlEiBxCg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+h0vCXPg/jKZQVz0C9gxNBXJclAJkrDVP85zixuDGWMWji+7M
	UkypIuDYMsTOnRt6X+DpvfddEWpYiPU1WglvowpgfuECID++S7AOAADOwcVeS7anZgZ3wtB7WI9
	fnVqgi/i9bJH8xT+5E5YLWxiuYtK7NFay5LclSkotv7wMguNoeFOeTJehg9g=
X-Google-Smtp-Source: AGHT+IHb6q/0xQ1krG12e4qKwfHtPEbOIunhr4ONSLixN7NuUj8kNPJwUniM37lugXhcBs0CTI+JPQvg40AC+JpqOshrgPzEgOJj
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0f:0:b0:3f2:3083:8ab2 with SMTP id
 e9e14a558f8ab-3fd94a14fb2mr218431345ab.18.1757476649665; Tue, 09 Sep 2025
 20:57:29 -0700 (PDT)
Date: Tue, 09 Sep 2025 20:57:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c0f729.050a0220.3c6139.0018.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_journal_stop (2)
From: syzbot <syzbot+09fb21cd037d564c2519@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    76eeb9b8de98 Linux 6.17-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1033f962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7f605fd273c8220
dashboard link: https://syzkaller.appspot.com/bug?extid=09fb21cd037d564c2519
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-76eeb9b8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/658515dceee8/vmlinux-76eeb9b8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee40b9e4370a/bzImage-76eeb9b8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09fb21cd037d564c2519@syzkaller.appspotmail.com

    hash_seed=fc917866faeb7b5b
    hash_type=siphash
    bi_size=1050
    bi_sectors=8
    bi_version=0
    bi_atime=2770562249
    bi_ctime=2770562249
    bi_mtime=2770562249
    bi_otime=2770562249
    bi_uid=0
    bi_gid=0
    bi_nlink=0
    bi_generation=0
    bi_dev=0
    bi_data_checksum=0
    bi_compression=0
    bi_project=0
    bi_background_compression=0
    bi_data_replicas=0
    bi_promote_target=0
    bi_foreground_target=0
    bi_background_target=0
    bi_erasure_code=0
    bi_fields_set=0
    bi_dir=4098
    bi_dir_offset=8977922886548783724
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0
    bi_casefold=0, fixing
 done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): resume_logged_ops... done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): delete_dead_inodes... done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): check_extents_to_backpointers...
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): scanning for missing backpointers in 1/128 buckets
 done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): check_inodes... done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): resume_logged_ops... done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): delete_dead_inodes... done
bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): done starting filesystem
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 24
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 24
------------[ cut here ]------------
journal shutdown error: cur seq 24 but last empty seq 23
WARNING: CPU: 0 PID: 5361 at fs/bcachefs/journal.c:1472 bch2_fs_journal_stop+0x42b/0x440 fs/bcachefs/journal.c:1468
Modules linked in:
CPU: 0 UID: 0 PID: 5361 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_fs_journal_stop+0x42b/0x440 fs/bcachefs/journal.c:1468
Code: 44 24 30 42 80 3c 28 00 48 8b 5c 24 20 74 08 48 89 df e8 e8 65 d9 fd 48 8b 13 48 c7 c7 60 91 d5 8b 4c 89 e6 e8 86 01 38 fd 90 <0f> 0b 90 90 e9 e4 fe ff ff e8 07 be 30 07 0f 1f 80 00 00 00 00 90
RSP: 0018:ffffc9000d3a7540 EFLAGS: 00010246
RAX: 94147eeeb8664e00 RBX: ffff88805364aa28 RCX: ffff888031efa440
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000d3a7660 R08: ffff88801fc24253 R09: 1ffff11003f8484a
R10: dffffc0000000000 R11: ffffed1003f8484b R12: 0000000000000018
R13: dffffc0000000000 R14: ffff888053649800 R15: 1ffff1100a6c9300
FS:  0000000000000000(0000) GS:ffff88808d20c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f778139e000 CR3: 0000000051ee9000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __bch2_fs_read_only+0x343/0x5b0 fs/bcachefs/super.c:306
 bch2_fs_read_only+0x42a/0xb00 fs/bcachefs/super.c:366
 __bch2_fs_stop+0x100/0x900 fs/bcachefs/super.c:677
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2618
 deactivate_locked_super+0xb9/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1375
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6b5/0x2300 kernel/exit.c:961
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1102
 get_signal+0x1286/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0x9a/0x750 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x75/0x110 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5dff78ebe9
Code: Unable to access opcode bytes at 0x7f5dff78ebbf.
RSP: 002b:00007f5e005230e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f5dff9c5fa8 RCX: 00007f5dff78ebe9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f5dff9c5fa8
RBP: 00007f5dff9c5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5dff9c6038 R14: 00007ffcd55dc420 R15: 00007ffcd55dc508
 </TASK>


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
