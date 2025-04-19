Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272401FB3
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Apr 2025 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745051782; cv=none; b=bVsfhijntmuVvYlfa+l8SeelJ76iR8mU5IctBZFIuplO4CZQnswBzr4oB4jupyFvkj5+xYoEQC0v8r4MAr8+fsH5XzW0UzIfcgsgcXfJzYjkNj9hAri1zqrPbWpVUzMCU1DBVdrrsdc15O2r46wZYPVkeQniSai3zPPQdO9Miyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745051782; c=relaxed/simple;
	bh=2muuX7Ih62Wo7gja35Okue8CWnhgSewdoNusaP2V7P0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eICr1LZ8qZRdApH+eTu6/Bsrj0exf5ZpY4N0+pwsf5pAhO1NVTMMYtBFT8A0eNeXZJvD7arE9JKgwQfAfP7S+iJ54W1V5VAwrGx7b/3sDgFkcxLwhE/qCM5KxRFrqcsS7TvNHOZ3cp17d9UAia9RvsPQ3IvyvmOSXXMUWZg6Rf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d458e61faaso24710365ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 19 Apr 2025 01:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745051780; x=1745656580;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=viXqPNMRsD79f0RGNVXeE0kyOUVbU86j7clKbfA/SQM=;
        b=XHsVtHsXJikjkk1pCFccFV3X00a5m96DCWf433UI1iXfUIb8izJYsgkCr10ubYTkhC
         Fy4M1YYNo4JItTI/3EPHRurpX51Dg4Giy8lpiFw3GOumtF7LKuaK7WTLWYP2IaDLESp0
         +6XUCg7Tg729t/+pWy9hsgvRPfkNRu51PmKyA9dS05T65jcE1qN8HzHz0wyjLCC8k/2+
         u53KIj6ARWAEyiindwKKkPkqZ134/6evvEhOSl5niyBSzrAiiOjHtYb/snlWU4Y5/JG2
         LWDG/SD/OS4MU/XQ8dbyUIuY+4sOSwvw8EmKF6TIrPpnD+3/9uT/A7jyYTCEQ757gyeP
         ZUIg==
X-Forwarded-Encrypted: i=1; AJvYcCUY+5RyrRep9H5vG9LUGs2ylejXmybYHE6mKtZ82LloLK6NmB+FFNd6J/vYb94fpKMJNN48TmBxlg2aIOXyAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPF2G/A0RavT7XudR3mnhGZW9SV9tg6aNeGPyPFyfnPUFY7Zyy
	+bGyBSHQdm6N6AK41EiNv/H1ycLz6ePKDV7o7usg7gHO9MCkEE0dvHjb4AhM7xgd9yL9bP2X7RU
	+D2Wz/6+qjRE45YiZ58h6hZ2AFW27YMoT4YPV93nkcKBP/DYRmKCp7cM=
X-Google-Smtp-Source: AGHT+IHkH/wwUf5d8lEEpuJxnz3SCVRu5KO/+QNvaticspBogfzuSTTlnBcBEi4bqi+Aeol4UGA5h8ZFt1vmaZ6fdEINgQ1UFwDV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b41:b0:3d5:890b:d9e1 with SMTP id
 e9e14a558f8ab-3d8b694907emr40125955ab.1.1745051780294; Sat, 19 Apr 2025
 01:36:20 -0700 (PDT)
Date: Sat, 19 Apr 2025 01:36:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68036084.050a0220.297747.0018.GAE@google.com>
Subject: [syzbot] [block?] [bcachefs?] kernel panic: KASAN: panic_on_warn set ...
From: syzbot <syzbot+4eb503ec2b8156835f24@syzkaller.appspotmail.com>
To: brauner@kernel.org, jack@suse.cz, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3088d26962e8 Merge tag 'x86-urgent-2025-04-18' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17aed470580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a31f7155996562
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb503ec2b8156835f24
compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3088d269.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5ec84510bfc9/vmlinux-3088d269.xz
kernel image: https://storage.googleapis.com/syzbot-assets/af58d0bee0a4/bzImage-3088d269.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4eb503ec2b8156835f24@syzkaller.appspotmail.com

Kernel panic - not syncing: KASAN: panic_on_warn set ...
CPU: 0 UID: 0 PID: 47 Comm: kworker/u4:3 Not tainted 6.15.0-rc2-syzkaller-00400-g3088d26962e8 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: loop0 loop_workfn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 panic+0x349/0x880 kernel/panic.c:354
 check_panic_on_warn+0x86/0xb0 kernel/panic.c:243
 end_report+0x77/0x160 mm/kasan/report.c:227
 kasan_report+0x154/0x180 mm/kasan/report.c:636
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x28f/0x2a0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_dec include/linux/atomic/atomic-instrumented.h:592 [inline]
 put_bh include/linux/buffer_head.h:301 [inline]
 end_buffer_read_sync+0xc1/0xd0 fs/buffer.c:161
 end_bio_bh_io_sync+0xbf/0x120 fs/buffer.c:2748
 blk_update_request+0x5e5/0x1160 block/blk-mq.c:983
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1145
 lo_rw_aio_do_completion drivers/block/loop.c:317 [inline]
 lo_rw_aio_complete drivers/block/loop.c:325 [inline]
 lo_rw_aio+0xdfd/0xf80 drivers/block/loop.c:398
 do_req_filebacked drivers/block/loop.c:-1 [inline]
 loop_handle_cmd drivers/block/loop.c:1866 [inline]
 loop_process_work+0x8e3/0x11f0 drivers/block/loop.c:1901
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xac3/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd50 kernel/workqueue.c:3400
 kthread+0x7b7/0x940 kernel/kthread.c:464


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
