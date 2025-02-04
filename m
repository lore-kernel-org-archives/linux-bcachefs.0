Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA050214206
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Feb 2025 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683204; cv=none; b=XpTO/nDfAUIs2+87t6nDEDDvHJy5ecW5RYD6RxUj5Pb9JLkCYx9EWIckVxWF5N9aMBrujAAL7GKmK7H6xj0MVZ06gW1AeL4YHc6qeXN0Yr5X6K1o4LZXuKh2yP6kQjcy4FDxFZrF9TJ/emN1p2/iRc7eaxczHWFU113uyg7lTpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683204; c=relaxed/simple;
	bh=rK/35i00Dq/m+kQSvH56ORmPEA6pq7QYHlH9wLTW2os=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=siHmK5Vvob9Beqv8ooFEfiOTQSUnskhNqzwOcAQCVrAfe8yeBpLkBKyyR9ZxRPcVodyImeQexQEmL2IENJhif+SKod0SCa3LddPDWgzlr/UYVbjhqyfWVe7/EsUp4ExyIkGoAqhrVrDjdMTtWpRUO5oHtkuJ/SJYcO7LLeAWyBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce81a40f5cso100545375ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 07:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738683202; x=1739288002;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aU3W+YMhVZxK2H5kCMELnyCFjHYhQjJGH0o0IKU8nGc=;
        b=S0AEQ9J+Fq9gHI8WfVNivermAq+V70IdGfY1RPdX0wFNMd5V/nqsX4xm7HXIA0LjS6
         uRmTSTSw7k5lW+nFnWTv6iGMx/dMmd9q8BeAM0HjV5p8jUKXlx3+J02XYOhI3Hqd94ik
         H7vEH1nLBS0ZqOO+YcVgHIcPju/QLt6Xpb30MGm+ekH4X6vYsSf8xQIdWivOONMAcHXX
         NuKUfkbzQADKin4VZ1LGtMwTmgIMltqn5B5sR2xXGxL3MBcc4653kMP2kcWpRrohI3ab
         MARTuWLeqRTXqG/Ma72BqpPAfSx9JFejiauqdZWd1+j1qjgVo5n0m8DA+zBZeMiqO8FZ
         OVxA==
X-Forwarded-Encrypted: i=1; AJvYcCWGsZK4BWRCBEoTqDRvYrTsp217ylmxpc8ZXIWYsXz4nY44rAfBFDqcjEs2tSNDCYsLwLFzoP+HayeQiDOMcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRCuLzy86yo3fJ1AvKrAtCKg9LRKFFElg3LkAf2yvxl/yFNXwl
	x7QyocEcQxeonZ0/cQTz9mAQ/yLj20XIIDbE7JNNmABjqNaNo3wP2Ku5JcIPSe7abaIQZ0cDmyA
	xlsSBz4Qq+lN76kSksy/IVEEF0XjE1a2ITvWYWw+G1aVdTFFlAQEmXto=
X-Google-Smtp-Source: AGHT+IEPPA9YUrVpGGpAGy3CCAhXjbINWy8FOxEoFHv0KTSCRV5HUwj4vJDj+06OrNfgctRzM2XQd2uOVw2RwC0u10tU9T8jR9eK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1707:b0:3cf:b39c:58ea with SMTP id
 e9e14a558f8ab-3cffe3bd76bmr232736765ab.10.1738683201873; Tue, 04 Feb 2025
 07:33:21 -0800 (PST)
Date: Tue, 04 Feb 2025 07:33:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a23341.050a0220.163cdc.006a.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in xas_create
From: syzbot <syzbot+fe375f77ba1a6ab944b6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=132078a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=fe375f77ba1a6ab944b6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17eca3df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10974f64580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e651a39ab132/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fe375f77ba1a6ab944b6@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/xarray.c:147:16
shift exponent 252 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 11 Comm: kworker/u4:0 Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: loop0 loop_rootcg_workfn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 get_offset lib/xarray.c:147 [inline]
 xas_descend lib/xarray.c:207 [inline]
 xas_create+0x1832/0x1ae0 lib/xarray.c:695
 xas_store+0x96/0x1870 lib/xarray.c:794
 shmem_add_to_page_cache+0x89d/0xcc0 mm/shmem.c:897
 shmem_alloc_and_add_folio+0x968/0x1090 mm/shmem.c:1928
 shmem_get_folio_gfp+0x621/0x1840 mm/shmem.c:2522
 shmem_get_folio mm/shmem.c:2628 [inline]
 shmem_write_begin+0x165/0x350 mm/shmem.c:3278
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
 do_iter_readv_writev+0x71a/0x9d0
 vfs_iter_write+0x23e/0x600 fs/read_write.c:974
 lo_write_bvec drivers/block/loop.c:245 [inline]
 lo_write_simple drivers/block/loop.c:266 [inline]
 do_req_filebacked drivers/block/loop.c:520 [inline]
 loop_handle_cmd drivers/block/loop.c:1929 [inline]
 loop_process_work+0x1429/0x21c0 drivers/block/loop.c:1964
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
