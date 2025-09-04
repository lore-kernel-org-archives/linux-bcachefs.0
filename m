Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03ED2FCC17
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Sep 2025 11:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756985070; cv=none; b=kXM+GepsPDiHxDU0ZQiLFvlOxK7MA6sf05wG9oO48Eefy3n4yJofyDV7DdsfuPyXO4qI1BOGU+JfMG3R9C1nrDQ9WpGrSWMpE0Ir4LhjMcloGAynKzSV115CYc/lUQfvS76jkWtsa35t5O6cAc46sp+pvoChxAlSsS1jFddlC6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756985070; c=relaxed/simple;
	bh=XIxJWp5jwgkd/x7EAs6Yb9l1Rxb0JLWprLhzApVoMW8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rAGXhN0rStDPShWbb2akjIpEESYNcTAZLLJxsATXIHBOMHZZCXOFjAhqbenygtGcfHt8ayOYEdOVyI4v1l+bZz8//FpOknShUunAtQxZDXHS2wSS9WXuEFcaerLSvEP8iTP7CtFwOPqqbD1HwEfjVrS7gG5otkYWOtnF8FPcRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3eefbb2da62so22462985ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 04 Sep 2025 04:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756985065; x=1757589865;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jVRXauSRvqty3E4JUfh3G8bM2Mvnct/XdFmYtu4QSq0=;
        b=tBLe6Y4SC9R0TUxnadBGXWY/9dh3EnAKmDC7HdA5CrLEEkcTLHVI280qD+LFpkQGco
         tPuFGuXNxRK1WY9Epp0JNnhaOtmt53QRn+EoxHd9BlHQ1T4jOgVU8ytigaBJzPeY3xeB
         HfetU+iPlyfyIJv35edFOSQSpuQ2Qwg2Ph/uxj4fwurJHr68IIvbLKsAGAPH5br1oHJY
         iziCW5PekfDuz4r4CrVqsb95+k7x6qMDdvteVZ+uzSRnMwl5hBxUerKQ8ujnJCElk22k
         suR04q9z3IuNzpcYLRzCt0Lz3MWUv9WdaABRsejCjXLluWPPN6jMagaaYrdT7gcW32pK
         L/sA==
X-Forwarded-Encrypted: i=1; AJvYcCX9mLs/Lgu/hLf1dMRIsFHOZsbgIv9r6UyraKpMQz6nB3dVRDQTZdOjOcok6ScTeGAO7ixnqEgQVFuuN3ob/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4M6nkjnpGdkV4IkHkqWpOle9j6b7buasURj/1bj6wToi3F9Wf
	OMgWmnbvAsD2739cNc9XhHkFQStAWpJamCTJi+MoQcbEHYAkCGXc+kugkXdG9CsC8+UvcEmYRmj
	vk4T6nNKG5c5+EWmnPsQzv3KC6uEKKJY3JlJlfPXAPwtOk01M6BShAukpKjk=
X-Google-Smtp-Source: AGHT+IGt6o9ZLvAXT3Dmw29yW7aii9EEHtCOfepySmQ4fXe/lAEnyriCWeXfF4yitxfZnvv4BV6Yr3oRLqMrvVskKgdpkK9YiwtO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ce:b0:3e5:4e4f:65df with SMTP id
 e9e14a558f8ab-3f400475c29mr309315895ab.9.1756985064883; Thu, 04 Sep 2025
 04:24:24 -0700 (PDT)
Date: Thu, 04 Sep 2025 04:24:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b976e8.050a0220.192772.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_recovery_pass_want_ratelimit
From: syzbot <syzbot+3bf8b0169d7fcc0ebcd5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c8bc81a52d5a Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a9ce34580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=385d836f07b5a70d
dashboard link: https://syzkaller.appspot.com/bug?extid=3bf8b0169d7fcc0ebcd5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c8bc81a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c0190a39aee/vmlinux-c8bc81a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc2b728f9900/bzImage-c8bc81a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bf8b0169d7fcc0ebcd5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5373 at fs/bcachefs/recovery_passes.c:174 bch2_recovery_pass_want_ratelimit+0x1d8/0x290 fs/bcachefs/recovery_passes.c:174
Modules linked in:
CPU: 0 UID: 0 PID: 5373 Comm: bch-copygc/loop Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_recovery_pass_want_ratelimit+0x1d8/0x290 fs/bcachefs/recovery_passes.c:174
Code: fd 40 20 eb eb 0e e8 17 04 6b fd eb 05 e8 10 04 6b fd 31 db 89 d8 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 f9 03 6b fd 90 <0f> 0b 90 e9 d1 fe ff ff e8 eb 03 6b fd 48 c7 c7 80 c1 79 8e 48 89
RSP: 0018:ffffc9000d326cb0 EFLAGS: 00010293
RAX: ffffffff8454b747 RBX: 000000000000000e RCX: ffff888033b9a440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888055f8eb5c R09: 0000000000000003
R10: ffff888055f8eb5b R11: ffffed100abf1d6c R12: dffffc0000000000
R13: dffffc0000000000 R14: ffff888052e00000 R15: 1ffff92001a64da5
FS:  0000000000000000(0000) GS:ffff88808d20d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002140 CR3: 00000000334f3000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 recovery_pass_needs_set+0x9a/0x510 fs/bcachefs/recovery_passes.c:302
 bch2_run_explicit_recovery_pass+0x3f/0xd0 fs/bcachefs/recovery_passes.c:416
 bch2_check_bucket_backpointer_mismatch+0x634/0x690 fs/bcachefs/backpointers.c:1220
 __bch2_move_data_phys+0x17a7/0x1c50 fs/bcachefs/move.c:922
 bch2_evacuate_bucket+0x228/0x3a0 fs/bcachefs/move.c:1082
 bch2_copygc+0x3be3/0x4510 fs/bcachefs/movinggc.c:234
 bch2_copygc_thread+0x97a/0xe00 fs/bcachefs/movinggc.c:409
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
