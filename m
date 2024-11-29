Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3019C569
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 12:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732882354; cv=none; b=nAzmjVHtdydFT0o+m/xLPG9m2p76JR5wzhq5uHIgtTYdKkpt/SHDeCUtW9Q3uCO4vDLIb627pezKNTd/5yre9vc3Xyh26BUxYOEgJ+hWjcrq9VW/2JN5j85QjugaEfvYb+hIB02LyVm96MEGQ7EST7tuIfMaDLegRCY3SRIKX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732882354; c=relaxed/simple;
	bh=vhSELNGRU9ia8cJZ8yaFgbszUbmVsqqiL+P8mHh6C80=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GqLCL0B8QoqS6merOA58j548V4NKpaaLBxPBkvtNnKAgJ5opJLI9Sxh3tXThv2aCxxdfBwYH4BmKdXuuGURQr8yKdiKfnjDhJZfy0MEzYjd+4AhOLajRpZf0+UyNsk4iidqJ1IErbl6N6n3X6z/oNgz0GMB3PJBAxOI4h73m870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a7de3ab182so3723255ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 04:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732882352; x=1733487152;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pGi6Sc9OlCd1Ksj/0M3YBMNOfSQNw9vcgM6HwKYNkWw=;
        b=LXQ/F25EGowDx1ysPBHA2UbfT9r18IDgzPHb49hM1hBAIGmQ3RomtbzLByu1AyGu9u
         SC0hlwl2qYRz/1fpfPScPS5eW4u9fD0hSmbbBWs1vhOS7XZMrjonQ6XrDS2XFRYx7y09
         HY9Wojb9oK7ykX8/1odyNHJfjASXX+9Cc+BWHhK67ua70lHkCIv+LP4CE5CczLl6e6vM
         6P0ZxGnWYqOr5VMsN4GQBcpLp3gSm3Vhpf3R4lpsXGSU0T6vNlKACCE4um0XXV/BpS8M
         R1mcgnnr/MX5vncAGw2z6DGkubPl1UHJHiwBm+5cLIzihPMlYQUYheIHpqEcaL9ihp8E
         mBBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVO0o/a4UQL9jFOMxpJip19uip0IqyFHq1zxZyt1TxrWqqKKiopxH7mfJTk+g9Bi1RAs88iho/EL1u3Av1MIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2AOI+BnXEe9RAsIoD10xM8JgDJ750SxV+g6gdY5VSP4YL70Sb
	U5gQ/YrHPectfiQtrQx2qI/ZmfqtU9npIojLbTK4D3Kqk3MPFBjKGdqq4mFEuYjcrasK4vvkIGf
	g/25d2i2HNAnZ9x5TUJeqF0jSgB0UXjx3VXMHCwQbgZ0jZIc61cIRhL8=
X-Google-Smtp-Source: AGHT+IF5nTY4XothRKp/qaKlLcmow73kJjPm6ScMewoifHqB1/GZgbF1HBv3uD/zGcDFmAsBHMUlSNw0aECEAvEeQuwLQcun5kaO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156f:b0:3a6:ad61:7ff8 with SMTP id
 e9e14a558f8ab-3a7c556a18fmr109546125ab.12.1732882352198; Fri, 29 Nov 2024
 04:12:32 -0800 (PST)
Date: Fri, 29 Nov 2024 04:12:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6749afb0.050a0220.253251.00b2.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_peek_slot
From: syzbot <syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    65ae975e97d5 Merge tag 'net-6.13-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14794d30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3891b550f14aea0f
dashboard link: https://syzkaller.appspot.com/bug?extid=3ebaf90b49bd97e920ee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-65ae975e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/53fd215a7a86/vmlinux-65ae975e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/589c729ff0b2/bzImage-65ae975e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:1816!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 4683 Comm: kworker/u5:1 Not tainted 6.12.0-syzkaller-10681-g65ae975e97d5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs bch2_write_point_do_index_updates
RIP: 0010:bch2_btree_path_peek_slot+0xf50/0xf90 fs/bcachefs/btree_iter.c:1816
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 c4 fa e3 fd 48 8b 34 24 44 8b 44 24 08 e9 50 f7 ff ff e8 51 12 79 fd 90 <0f> 0b e8 49 12 79 fd 90 0f 0b e8 21 4a b6 07 e8 3c 12 79 fd 90 0f
RSP: 0018:ffffc9000de4c0a0 EFLAGS: 00010293
RAX: ffffffff841cd22f RBX: 0000000000002164 RCX: ffff88801f290000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000de4c1b0 R08: ffffffff841cc410 R09: 0000000000000000
R10: ffffc9000de4c300 R11: fffff52001bc9862 R12: dffffc0000000000
R13: 1ffff1100adc228d R14: ffff888056e11448 R15: 1ffff1100adc228c
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe0e030d38 CR3: 000000004f5d2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_iter_peek_slot+0xa2f/0x2550 fs/bcachefs/btree_iter.c:2658
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:575 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:589 [inline]
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:305 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:525 [inline]
 bch2_bucket_alloc_trans+0x1997/0x3a50 fs/bcachefs/alloc_foreground.c:648
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x13d0/0x1ec0 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:339 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:549
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1247
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1856
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_key_cache_flush_pos fs/bcachefs/btree_key_cache.c:432 [inline]
 bch2_btree_key_cache_journal_flush+0x97d/0xe70 fs/bcachefs/btree_key_cache.c:512
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x789/0xdc0 fs/bcachefs/journal_reclaim.c:698
 __journal_res_get+0x1de3/0x2670 fs/bcachefs/journal.c:581
 bch2_journal_res_get_slowpath+0xe6/0x710 fs/bcachefs/journal.c:606
 bch2_journal_res_get fs/bcachefs/journal.h:382 [inline]
 bch2_trans_journal_res_get fs/bcachefs/btree_trans_commit.c:350 [inline]
 bch2_trans_commit_error+0xd91/0x1390 fs/bcachefs/btree_trans_commit.c:962
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 __bch2_data_update_index_update+0x56bb/0x77f0 fs/bcachefs/data_update.c:368
 bch2_data_update_index_update+0x63/0x90 fs/bcachefs/data_update.c:414
 __bch2_write_index+0x16d1/0x2140 fs/bcachefs/io_write.c:527
 bch2_write_point_do_index_updates+0x32e/0x690 fs/bcachefs/io_write.c:635
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_path_peek_slot+0xf50/0xf90 fs/bcachefs/btree_iter.c:1816
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 c4 fa e3 fd 48 8b 34 24 44 8b 44 24 08 e9 50 f7 ff ff e8 51 12 79 fd 90 <0f> 0b e8 49 12 79 fd 90 0f 0b e8 21 4a b6 07 e8 3c 12 79 fd 90 0f
RSP: 0018:ffffc9000de4c0a0 EFLAGS: 00010293
RAX: ffffffff841cd22f RBX: 0000000000002164 RCX: ffff88801f290000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000de4c1b0 R08: ffffffff841cc410 R09: 0000000000000000
R10: ffffc9000de4c300 R11: fffff52001bc9862 R12: dffffc0000000000
R13: 1ffff1100adc228d R14: ffff888056e11448 R15: 1ffff1100adc228c
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe0e030d38 CR3: 000000004f5d2000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
