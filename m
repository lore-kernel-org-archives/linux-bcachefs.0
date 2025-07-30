Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54C2DE710
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Jul 2025 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891778; cv=none; b=NDtpIeA8b5lWe+954VTYpnNMWmbZZdsSEIvI1cB3SIupdjofA/JMXaDFtbOTxKKI6D8T3G3ZYJCVm50TpLyvRVttSXCSzjvxV+VbbmrzaRDr+A5dOd6Pzr3hdgPIjoxDL+Sg2wKZWY4fx2cwy04k5TfZnf8tDItExUvyAg7MZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891778; c=relaxed/simple;
	bh=kRMFaP3uDFy9AtnSJJbnU7XeE3l2zaYmlEcIV6keUYs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AhLVn2zIARJPyes3SvtAdPGFk9MCask2s/Q9RXqg9MQi0iUTdJAhfMWfDjTz6OiFJX7y/hSLDym3Pmk9q+5TZxaJd7paLOcXq2q/PqJuQcyUrTMg0QaPfGyBTzguJQ7HBvFhsTmUTfrDNnRlOYoGDbvFd0TfLPVsYCH9JhIwzQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3e3ed8b5d05so12368065ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 30 Jul 2025 09:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753891776; x=1754496576;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V6sU9wcsAFaB8MjEXUXjl60SDL+4Ms1KtUD6ELWGeD8=;
        b=doET3ZQCkzoJHtFNqbcfP4sJKntu5yUzApQu9wTcIbFyEaQ5WHHufdd7t6MO3qlF3r
         W072oVQfLNCxMoYHtgE73IlvzlHx+ebiYCXxl8mzRK3KcfXZKIX/+NzeeBvUPh//CbXy
         fmknYOatDKw1sNWzEYYGgghFPks5HJKTKk0B3CM0x//tzGd1OYDrRmOVUUXhv2tSAUIp
         yAK3CzAXzF7LYu/JlbA6VzOZOiaQJIitHfqdT6Wr3IOBXqYMhj8pSyBMbaKtDSiY3gg6
         YZT/51NgJYwVUb/br3zmxk0u9x8lSGkGRlayTS71r+l2RFSbl4/S+jpLkiLyPQ+71gWz
         YtAA==
X-Forwarded-Encrypted: i=1; AJvYcCX2YsHth2EGzvHHiWQllgdg3WB7TiAWdn0VBFs53z/txbPCrIvyFuq1MQWv+F1j7P23lW5C49UZOEGMgWaxpg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw22xsAzJDBSHjv+OWjOCXRd6doQcz8P/sTEacZEj8qB9G3ViGQ
	xE4vbwEbsnOJn6z8sH4R9xabyAieRd57rhj//Jd939pmt/2yeuX+S4CARnVAMNiuOaPZrD83K6l
	ysy2CkhWyQn4HS2aOq1RO69TNA6QQEejgYS+W04RNHrU7AhNw9lHc32/pVS4=
X-Google-Smtp-Source: AGHT+IHofyv55TPFRJtG29cCv7oY5anOxPw9dQhV3YeIrZXjGKHsY+hOqswB+cCAwc/JEIpgDTfwEFT42d90jwXtxxDd+ccyeDrA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2388:b0:3e3:b4ff:15e3 with SMTP id
 e9e14a558f8ab-3e3f621a48emr56479425ab.4.1753891775703; Wed, 30 Jul 2025
 09:09:35 -0700 (PDT)
Date: Wed, 30 Jul 2025 09:09:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688a43bf.050a0220.5d226.000a.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bio_compress (3)
From: syzbot <syzbot+1733f08e3b98628b164a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f33ebd2018c Merge tag 'drm-fixes-2025-07-26' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15fa4034580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8adfe52da0de2761
dashboard link: https://syzkaller.appspot.com/bug?extid=1733f08e3b98628b164a
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-5f33ebd2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a554f67105dc/vmlinux-5f33ebd2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b3d52a10bce9/bzImage-5f33ebd2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1733f08e3b98628b164a@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/compress.c:525!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5346 Comm: bch-copygc/loop Not tainted 6.16.0-rc7-syzkaller-00120-g5f33ebd2018c #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bio_compress fs/bcachefs/compress.c:525 [inline]
RIP: 0010:bch2_bio_compress+0x14b1/0x14c0 fs/bcachefs/compress.c:555
Code: fd 90 0f 0b e8 20 30 90 fd 90 0f 0b e8 18 30 90 fd 90 0f 0b e8 10 30 90 fd 90 0f 0b e8 08 30 90 fd 90 0f 0b e8 00 30 90 fd 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f51e600 EFLAGS: 00010293
RAX: ffffffff84300110 RBX: 0000000000000003 RCX: ffff88803d990000
RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000000000000000
RBP: ffffc9000f51e850 R08: 0000000000000005 R09: 0000000000000003
R10: ffffc90001a23033 R11: fffff52000344800 R12: 0000000000000800
R13: 0000000100000001 R14: 0000000000000000 R15: 0000000000002800
FS:  0000000000000000(0000) GS:ffff88808d218000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555e44a5168 CR3: 0000000011b80000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_write_extent fs/bcachefs/io_write.c:1060 [inline]
 __bch2_write+0xfb5/0x3900 fs/bcachefs/io_write.c:1554
 move_write fs/bcachefs/move.c:217 [inline]
 bch2_moving_ctxt_do_pending_writes+0x5a7/0xe60 fs/bcachefs/move.c:248
 bch2_move_ratelimit+0x8e8/0x1330 fs/bcachefs/move.c:585
 __bch2_move_data_phys+0x110f/0x1c50 fs/bcachefs/move.c:904
 bch2_evacuate_bucket+0x228/0x3a0 fs/bcachefs/move.c:1082
 bch2_copygc+0x3be3/0x4510 fs/bcachefs/movinggc.c:234
 bch2_copygc_thread+0x97a/0xe00 fs/bcachefs/movinggc.c:409
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bio_compress fs/bcachefs/compress.c:525 [inline]
RIP: 0010:bch2_bio_compress+0x14b1/0x14c0 fs/bcachefs/compress.c:555
Code: fd 90 0f 0b e8 20 30 90 fd 90 0f 0b e8 18 30 90 fd 90 0f 0b e8 10 30 90 fd 90 0f 0b e8 08 30 90 fd 90 0f 0b e8 00 30 90 fd 90 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000f51e600 EFLAGS: 00010293
RAX: ffffffff84300110 RBX: 0000000000000003 RCX: ffff88803d990000
RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000000000000000
RBP: ffffc9000f51e850 R08: 0000000000000005 R09: 0000000000000003
R10: ffffc90001a23033 R11: fffff52000344800 R12: 0000000000000800
R13: 0000000100000001 R14: 0000000000000000 R15: 0000000000002800


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
