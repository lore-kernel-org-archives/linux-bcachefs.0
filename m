Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2B317BEC5
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732538541; cv=none; b=c8hRuoX1M8MR6eowKMl3zkG7KtBRPtiQS7lhDoox0/2qAH1ABmAQx/JKAxHGJxh/LMrDiFmcN7+HFmpkYOGI5HhRcGtQoDHdrMLTXJ/r9VhFbp4EYQRwC3b9OdxcnQEDrc5NgAC4zdoo+vBzAHy8YW+L/DTBgXHrVE9/13XExxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732538541; c=relaxed/simple;
	bh=fz/01Kr00HHPzJ/B0y5tFtjfjn4l4Z9ljQdjyGk+kEQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=blchhm22Iebv2ZdpsEiBxo0YawyyaDZ1RTYK1SAdpNzPJGbnenIk6nCuVVMnK1KLjqIukJHvGxbOgW1VRBqFCjxCF8kNoqSa9GgU0B5Np4r7ThK0kWgxpY2A2WpVjrDu/4B2WT4U6MozsNPL3d4d2zLNgAYfWdnDNOMlv0G97Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a76ba215b2so46036485ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 04:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732538539; x=1733143339;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7+z13xlx/JBPOgRHb3CjjH8lUVhFTpA9EJKc9fwjzVI=;
        b=KYh8A68YzOrT2aCme4tMAndaR8H9bK/lBt2IZ2/0BYbU4ytuytUYq58nBxFClBJBQ8
         +I66VZFBHLXbi8V52t5ywdl+l2YNgz4wp9/PJDbRKQSOVodNzc1KdwkwM4v8DXjRFVKf
         awwK3/98sm6WrxPhpCjXfOhheVpzErvI94E4QM2hYivJ7JUNkT8LX2rEn0rIkCv5AYD5
         oLWDfsYvTNLaH1ypL0Q8BOFNaqn34Gasxz22gMrIJiCyDCey5DUJR5hnDZqyagaUjm1C
         v+I7/wxYsWm/pHBnXVGO6n8V9mUb9B/SbU5L9oifPtNFE7yxeq8scIlBOt40LhrYRpO0
         g7/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYyEZGHOpRTNrgrtcjJTan2vANGesoeQk+nynVvw9AVpydCxRNdArkiUh6A2O29mJ1hZ08/aLQvbI83cXiqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YykkSPqWrbU0L4eu2qbbEbuE0MCpiLPuKGrbHpTdPXxcJmptiBm
	ebTF98LlMgrrDu5MA7U0kK4NboHTGEuxgsd+mtdv8zWi7qqDo7QbUtSQM1HJQJmHoEzRWxbCMCC
	Pub+F1hdDDEyGfc8P0pipsT7nRCdqhse95NoSKzofrNm454ygW4oKW8I=
X-Google-Smtp-Source: AGHT+IFk+rT9P9R2gxypjuSHJDWmLqmGBi+W3GykOmsr/ojXBXuyTuB1BrjV9qIDF64l5b8sIP3diOnLaNRAw2gt4h6yiULmOC6V
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1885:b0:3a7:8720:9de5 with SMTP id
 e9e14a558f8ab-3a79acfb902mr164933035ab.1.1732538539674; Mon, 25 Nov 2024
 04:42:19 -0800 (PST)
Date: Mon, 25 Nov 2024 04:42:19 -0800
In-Reply-To: <6743ea99.050a0220.1cc393.0057.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674470ab.050a0220.1cc393.007c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_journal_pin_put
From: syzbot <syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10972778580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb680913ee293bcc
dashboard link: https://syzkaller.appspot.com/bug?extid=73ed43fbe826227bd4e0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111e775f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14972778580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-9f16d5e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/15be8a79f63a/vmlinux-9f16d5e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/82d8dde32162/bzImage-9f16d5e6.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f0224b26c115/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_reclaim.h:30!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 4682 Comm: kworker/u5:1 Not tainted 6.12.0-syzkaller-09073-g9f16d5e6f220 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_journal journal_write_work
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:__bch2_journal_pin_put+0x121/0x130 fs/bcachefs/journal_reclaim.c:327
Code: 9a 52 fd 31 ff 89 de e8 0d 9a 52 fd 89 d8 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 f8 96 52 fd 90 0f 0b e8 f0 96 52 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000dcf7a10 EFLAGS: 00010293
RAX: ffffffff84434920 RBX: 0000000000000000 RCX: ffff888000582440
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffffc9000dcf7b78 R08: ffffffff84434881 R09: ffffffff8440bb88
R10: 0000000000000004 R11: ffff888000582440 R12: dffffc0000000000
R13: ffff88804474a500 R14: ffffffffffffffff R15: ffff88804474a500
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056474e330408 CR3: 000000000e738000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_buf_put_final fs/bcachefs/journal.c:217 [inline]
 __bch2_journal_buf_put fs/bcachefs/journal.h:276 [inline]
 __journal_entry_close+0x80a/0xe30 fs/bcachefs/journal.c:301
 journal_write_work+0x129/0x140 fs/bcachefs/journal.c:487
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:__bch2_journal_pin_put+0x121/0x130 fs/bcachefs/journal_reclaim.c:327
Code: 9a 52 fd 31 ff 89 de e8 0d 9a 52 fd 89 d8 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 f8 96 52 fd 90 0f 0b e8 f0 96 52 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000dcf7a10 EFLAGS: 00010293
RAX: ffffffff84434920 RBX: 0000000000000000 RCX: ffff888000582440
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffffc9000dcf7b78 R08: ffffffff84434881 R09: ffffffff8440bb88
R10: 0000000000000004 R11: ffff888000582440 R12: dffffc0000000000
R13: ffff88804474a500 R14: ffffffffffffffff R15: ffff88804474a500
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056474e330408 CR3: 000000000e738000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
