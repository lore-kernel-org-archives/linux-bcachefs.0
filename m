Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9409024338E
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 23:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739057004; cv=none; b=nolhmXEBu2UT6wHlqRFols0f7gsp2d+0tFq6GpteUObxeDqwJ+/spBZfNkqy8/k0PYc4GjSWcCIQPDu7SAJSFXzwFSn1aQYJAKEKrMtDSK7VDSTRHIygW8zwseb9DGNGr+qkEGpoltfOiZCwhwUasCsarkhbEf8MBoUnmiHLh2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739057004; c=relaxed/simple;
	bh=+tITSfmTPnYEjO3C/jiW5sciRTbuZT79tXWfdWsfbN8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WMjuKAMKx27fFtRKhSeqcfSAFa1wMX4feLG/U3ruYlYuzlt8OrY5DziEZiFayuKuydjM2baUR7ybomEQnCpS6AfcGn4upEveRdO3EVhwBitX5eGqoCo2ygNzshkJylSqpQYjg4IeoXbq41Xao9KhQhyLcczTmjEGkHmhiCU9BO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cf6ceaccdbso23112515ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Feb 2025 15:23:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739057001; x=1739661801;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9ndoZhOwaQZLQGFiiCIM0BOswD8Ed+92zYxo6GV7ec=;
        b=E1c+uvgwDI2nX/Rby+Zf4g0qMK9u8QgIvinaP5Q5FDloDIxKylNvMNQbB5o7fp2l4U
         rCo4OAnC6hQb/ZVLdn0zPMdkgWCRO2ZiDykQ7/Cf6TvVwrt8hnnRhsYTIek03Rpmyf/l
         mztoMbC/sTgx/0fTEwZUy1W6w4QVQJ4gYakxMI074ELpOmJhbUu1249muP8vJoyju4+n
         QkwHQPUGvpC74z6ejG48sKXo/LfAHqhe/9Gi7ezx7wO7Kh4Bbd+a0u0Qb2p1GbZ6NNT/
         m6e0iDx9BeAUyhoEjxrY5hecJKMzqzcT3/ZSWY/f6O00TEdcyQR8TbhSSKREnoTZQXuE
         53jA==
X-Forwarded-Encrypted: i=1; AJvYcCWbeUuaFr26+mWXU7fUU3cR9sZafLR5xeBO/tGWxo0bQfcCgzmhvRHgMeOvy/9kiJ4Qoke18hkpASIwB0f63A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1JtpbBdjTabNvsLYdt3pl97Jrfz0iSWiwlycs2d1cDUsFekDG
	PVw6b0YGiUVtj3DyZKTgMXfHEPqVgUoUNORlaydlJAQWJtlY9guyE4fRDzlv4zuQuVzVbKlwvRD
	TiqBxkvgK4TElngCO7EVnPMyFao0WrHfzcyQaXJZI8TPafVa3bQpDcmE=
X-Google-Smtp-Source: AGHT+IGm96PGbyixrD+vPHQeLoFUIwRZ+l2RL558GJzx+MmPLc+g1tjuplQUTMpSKRVvwS+aWxv2tSR4lIP1jQRSoijeJTpx89T/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c263:0:b0:3d0:224f:32e0 with SMTP id
 e9e14a558f8ab-3d13dcfca38mr68472075ab.4.1739057001770; Sat, 08 Feb 2025
 15:23:21 -0800 (PST)
Date: Sat, 08 Feb 2025 15:23:21 -0800
In-Reply-To: <6749afb0.050a0220.253251.00b2.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a7e769.050a0220.110943.0013.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_peek_slot
From: syzbot <syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ed58d103e6da Add linux-next specific files for 20250207
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11c32b18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=244a34ec1429746
dashboard link: https://syzkaller.appspot.com/bug?extid=3ebaf90b49bd97e920ee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152811b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13443df8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ce459b7174dd/disk-ed58d103.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/60699733c0c8/vmlinux-ed58d103.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f589bce7c898/bzImage-ed58d103.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c0e95d2847cc/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:1850!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 2964 Comm: kworker/u8:8 Not tainted 6.14.0-rc1-next-20250207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: btree_update btree_interior_update_work
RIP: 0010:bch2_btree_path_peek_slot+0xfa2/0xfe0 fs/bcachefs/btree_iter.c:1850
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 f2 e5 e3 fd 48 8b 34 24 44 8b 44 24 08 e9 25 f7 ff ff e8 9f 08 7d fd 90 <0f> 0b e8 97 08 7d fd 90 0f 0b e8 bf 88 b7 07 e8 8a 08 7d fd 90 0f
RSP: 0018:ffffc9000bda5800 EFLAGS: 00010293
RAX: ffffffff84428051 RBX: 0000000000002164 RCX: ffff888030423c00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000bda5910 R08: ffffffff844271e0 R09: 0000000000000000
R10: ffffc9000bda5a80 R11: fffff520017b4b52 R12: dffffc0000000000
R13: 1ffff1100484f0c2 R14: ffff8880242785f0 R15: 1ffff1100484f0c1
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f110aa60000 CR3: 0000000077baa000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_iter_peek_slot+0xb67/0x27c0 fs/bcachefs/btree_iter.c:2799
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:573 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:587 [inline]
 bch2_check_discard_freespace_key+0x292/0xeb0 fs/bcachefs/alloc_background.c:1404
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:274 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:425 [inline]
 bch2_bucket_alloc_trans+0x1583/0x2ea0 fs/bcachefs/alloc_foreground.c:557
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:713
 __open_bucket_add_buckets+0x13a2/0x1e10 fs/bcachefs/alloc_foreground.c:956
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1000
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:322 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:532
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1230
 bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x804d/0x9680 fs/bcachefs/btree_trans_commit.c:1085
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:706 [inline]
 btree_interior_update_work+0x1449/0x2a70 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_path_peek_slot+0xfa2/0xfe0 fs/bcachefs/btree_iter.c:1850
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 f2 e5 e3 fd 48 8b 34 24 44 8b 44 24 08 e9 25 f7 ff ff e8 9f 08 7d fd 90 <0f> 0b e8 97 08 7d fd 90 0f 0b e8 bf 88 b7 07 e8 8a 08 7d fd 90 0f
RSP: 0018:ffffc9000bda5800 EFLAGS: 00010293
RAX: ffffffff84428051 RBX: 0000000000002164 RCX: ffff888030423c00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000bda5910 R08: ffffffff844271e0 R09: 0000000000000000
R10: ffffc9000bda5a80 R11: fffff520017b4b52 R12: dffffc0000000000
R13: 1ffff1100484f0c2 R14: ffff8880242785f0 R15: 1ffff1100484f0c1
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f110a231000 CR3: 000000002f9c4000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
