Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA03610E5
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739016149; cv=none; b=npHwVlkq1w1yiVYyGZ1BxY98s4gjUbZa7s6TxYNSB052VlLCK6mbrG9kB7w77gnPJ2NYOSkKUcqxfG0IwDVeikmaqJPRRJfjWruCMz+ykGkMUEDOdbQMNqFY0Vcxt5C2WeUoEVOHRgV83Ld6P+IaKRzyzmz6DIMg2tQgHHpJysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739016149; c=relaxed/simple;
	bh=Q9hqIsy9+LNpv/TZJvaY2CrlpA4cmlenA1GK4K6PMzk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hMqjrhZ1kqeX4x+P6UL4NXENoNRjzQncARg0b+EDw5Jj23zTdZjmynaxBhJYF6c3Yy8wlLLvuYxcqCHGIktqlHlSopoYzk+KtFPI9TLy8g0er29CTKTBEuVPS2zAgvERwF/mcsueAcEpge/f2Ho9KiZSLTJw95EoDWqZ5guOS8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3cf64584097so22213475ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Feb 2025 04:02:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739016147; x=1739620947;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJ93vbAnlQ57EbuUwzDdDu5NbRawDV6a4Y7oO6u3NQs=;
        b=spw8XYnCPEBj7DJawQCotVGEanHgMnRTciwo+Rz3qyxCfpOpGfFXgez4I6SSii3yKh
         C/2AnBLsDanrD54laM+7Rhl3dMrnBC/ElcFNJ/jkgv6KzCYZMFKrKSyyCeyzRGkGHZoj
         P8tQCFN/B4j/hANvAgtmVvBPFcYDewe4UzwFZm9kOccoEzDt5y/AmGKP5lNmK9w1hOOU
         Zq23rkEf+pZgvaYhPAmWA+SE0ev1Rf8Nni8/K8ymAXP1YOj6jevh495lo6TxBToVkmd0
         x7cSnfuTqPNAy4jk86JMtC1muZ8eKRKCZebD+bBtXizUmZcGnSTJeI5wa98IPCmq2/HG
         hafQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD+unStKKOEta6Y8we/Az/bFFFZp0hergk59Py0JdU8BqJelMGaRpR2dgYTKs1NV9m54/NDGwR3adj3UJtBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/2asw6nLKNWxjwpitkY80PdQoporWOPEowUljZMp+8DcUa27Z
	A1VIJb0n6x88zq7pnJcC6PtxW6YiJ1l4AA568qd/8ggq7c99B90etp8pfKNZ1M+Gp0V7pSTy3sO
	UGPpE3bufx+0F5al7W85R2M1ofCI4eDOFyoao0hdhFl/fPAsZNlDX1hw=
X-Google-Smtp-Source: AGHT+IFu0K3IzL4ky9SIUeGPgcq7Oxhquq5BWY7Kii5K++K8Vs/C/uGQ9EIs5G966ou7Le6h2mJ2/hVhx7sUbz+yRWu2ZyMbtevf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b26:b0:3ce:9149:a8b1 with SMTP id
 e9e14a558f8ab-3d13dd6747amr44751675ab.9.1739016147064; Sat, 08 Feb 2025
 04:02:27 -0800 (PST)
Date: Sat, 08 Feb 2025 04:02:27 -0800
In-Reply-To: <6749afb0.050a0220.253251.00b2.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a747d3.050a0220.110943.000c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_peek_slot
From: syzbot <syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ef5df8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=3ebaf90b49bd97e920ee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178b8bdf980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54ead761f64f/disk-7ee983c8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/95e57de2a045/vmlinux-7ee983c8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d24a612a8ac7/bzImage-7ee983c8.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/202515454152/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/d6fc55b76c5c/mount_2.gz
  fsck result: OK (log: https://syzkaller.appspot.com/x/fsck.log?x=119bf0e4580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ebaf90b49bd97e920ee@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:1850!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 2956 Comm: kworker/u8:6 Not tainted 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: btree_update btree_interior_update_work
RIP: 0010:bch2_btree_path_peek_slot+0xfa2/0xfe0 fs/bcachefs/btree_iter.c:1850
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 02 60 e4 fd 48 8b 34 24 44 8b 44 24 08 e9 25 f7 ff ff e8 ff 4c 80 fd 90 <0f> 0b e8 f7 4c 80 fd 90 0f 0b e8 8f e7 ae 07 e8 ea 4c 80 fd 90 0f
RSP: 0018:ffffc9000c555800 EFLAGS: 00010293
RAX: ffffffff843f10c1 RBX: 0000000000002164 RCX: ffff8880307cbc00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000c555910 R08: ffffffff843f0250 R09: 0000000000000000
R10: ffffc9000c555a80 R11: fffff520018aab52 R12: dffffc0000000000
R13: 1ffff1100ff3a08f R14: ffff88807f9d0458 R15: 1ffff1100ff3a08e
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f607dda0010 CR3: 000000001eb30000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_iter_peek_slot+0xb67/0x27c0 fs/bcachefs/btree_iter.c:2799
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:573 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:587 [inline]
 bch2_check_discard_freespace_key+0x292/0xeb0 fs/bcachefs/alloc_background.c:1404
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:291 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:442 [inline]
 bch2_bucket_alloc_trans+0x1583/0x2ea0 fs/bcachefs/alloc_foreground.c:574
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:730
 __open_bucket_add_buckets+0x13a2/0x1e10 fs/bcachefs/alloc_foreground.c:973
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1017
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:322 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:532
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1230
 bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x812b/0x97a0 fs/bcachefs/btree_trans_commit.c:1085
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
Code: f7 ff ff 48 89 34 24 be 08 00 00 00 44 89 44 24 08 e8 02 60 e4 fd 48 8b 34 24 44 8b 44 24 08 e9 25 f7 ff ff e8 ff 4c 80 fd 90 <0f> 0b e8 f7 4c 80 fd 90 0f 0b e8 8f e7 ae 07 e8 ea 4c 80 fd 90 0f
RSP: 0018:ffffc9000c555800 EFLAGS: 00010293
RAX: ffffffff843f10c1 RBX: 0000000000002164 RCX: ffff8880307cbc00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: ffffc9000c555910 R08: ffffffff843f0250 R09: 0000000000000000
R10: ffffc9000c555a80 R11: fffff520018aab52 R12: dffffc0000000000
R13: 1ffff1100ff3a08f R14: ffff88807f9d0458 R15: 1ffff1100ff3a08e
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f607e921000 CR3: 0000000031b80000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
