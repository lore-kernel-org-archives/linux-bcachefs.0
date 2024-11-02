Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41B1F931
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Nov 2024 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730508812; cv=none; b=rOhazXewiz1XO+p7Urq2wrUppSSHD7y1kcovkzgYOOWva3sRl06IiSQQyLwqOkUbiH6EXn0lZ0/aXPbUEVr2xw+V3Noc5lF/W0t0K/c+DNn87CgUDjoFgu2aoomVTsfGhUe7SRAU0ayINXQRBwA1Ms1g4fOYj6NpI5YJ1HTCeDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730508812; c=relaxed/simple;
	bh=zos+aEb96pFI/W6za7yUXzhh8hQ9Ce7LgUZmatvccQs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E74hX50VkWsFGii/TL87BfUgGEjZ7qY2x7BQakLWB54SS24v5KTNNqWXJ0WYeyK37mlNa6mnjmpX8WdET4HZtpNJKG0FL5MOhGZ6Z7xY+ZRTIzDR5ukRVtnay8rKnSvUbn0FITf/vJ1VoP7kTQCXDtckKtqPQhlIJQMz4SgEI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3c27c72d5so25717655ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 01 Nov 2024 17:53:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730508810; x=1731113610;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9CAoiH9G7loATtuL7LpfCvs892X1MnJOk56pJ7cHrck=;
        b=Tz/hjZxe13yoIEqo7O5qceNxuN57sPCM6PvCbAb6Soi2aId0hGXZj8vcowUx7W//ne
         Wd42NXKcYtnjDwAoKNPmNCG7Md4x1eSBwZnMMxq0KyXT5wptP+TBpPqQCial3thV1/Tl
         s77WwpfzKiRDGP2jxdk2Vz/3UznPzf/vOjjbNlPqovHwNQDmSLhIz0IFMKDCGyoNakbw
         YhlREl0c5iQFYY0I4cnlV+gh02ldUm4ildJ+SpPM4/v1oyz3l09eFW4tovoifKQ0DVU6
         0QSHgmJHGNvHBcLUn7aA6O8Yv510/uasx0mURd+pjFx09CWMWnKEOOdRPHrX/vEcng23
         nhiw==
X-Forwarded-Encrypted: i=1; AJvYcCVTG5nHIdUNaJ+N9nCYdENIe5XzfJlr+UakiLkVnUzfNCmxIQmBOyfFFRUd4lkZxO7beR9Q0TH+Z3UpIwsHgA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxo+PLMUJC0dTp5JNurVaMlgc7eHMPl9JK2QS/O2Gx13f7pcu6
	azpFngJMhblRNq7B9J/HMwT3qZtiC7+fOAOqb/T1D6rSL0Wk4PZ0qWcem2o6lb7DWgoQICMDdVY
	PoQz/hBq48m5PgESz3j7lqjEOUcnBXrpwHpItk6TTBTAbSGMnFYXvN7E=
X-Google-Smtp-Source: AGHT+IFMEg1nyHRMeZR7Ux78y0juCqVfOX+gW9SsVt0jCCfg8JK7wl3GbyN/6wfALuDb6V1EqpMDRukQDqOo2d0NClaNhutXgHU4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d11:b0:3a0:8c5f:90d8 with SMTP id
 e9e14a558f8ab-3a6b02b4c3bmr58126245ab.6.1730508810266; Fri, 01 Nov 2024
 17:53:30 -0700 (PDT)
Date: Fri, 01 Nov 2024 17:53:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6725780a.050a0220.35b515.0181.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_writepage_io_done (2)
From: syzbot <syzbot+9765be6fa7d03a49a95c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e42b1a9a2557 Merge tag 'spi-fix-v6.12-rc5' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a9e940580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ce635c2e1785fd6
dashboard link: https://syzkaller.appspot.com/bug?extid=9765be6fa7d03a49a95c
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b440ec26d97d/disk-e42b1a9a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/76f539c22a2e/vmlinux-e42b1a9a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b7fffe3fc1ad/bzImage-e42b1a9a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9765be6fa7d03a49a95c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 52 at fs/bcachefs/fs-io-buffered.c:419 bch2_writepage_io_done+0x857/0xd10 fs/bcachefs/fs-io-buffered.c:419
Modules linked in:
CPU: 0 UID: 0 PID: 52 Comm: kworker/u8:3 Not tainted 6.12.0-rc5-syzkaller-00005-ge42b1a9a2557 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: writeback wb_workfn (flush-bcachefs-56)
RIP: 0010:bch2_writepage_io_done+0x857/0xd10 fs/bcachefs/fs-io-buffered.c:419
Code: ff e8 cd 38 82 fd 8b 84 24 88 00 00 00 48 8b 74 24 08 48 8b 7c 24 10 8d 50 01 89 04 24 e8 11 ee ff ff eb c5 e8 aa 38 82 fd 90 <0f> 0b 90 e8 a1 38 82 fd 48 8b 44 24 18 48 8d 78 f8 48 b8 00 00 00
RSP: 0018:ffffc90000bd71b0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000008 RCX: ffffffff840b3bd9
RDX: ffff888022699e00 RSI: ffffffff840b4286 RDI: 0000000000000007
RBP: 0000000000000008 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000000 R12: ffffea00004d63c0
R13: ffff88814cd81b80 R14: 0000000000000008 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7e3b046f98 CR3: 000000005dbaa000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 bch2_write_done+0x246/0x400 fs/bcachefs/io_write.c:477
 bch2_write_data_inline fs/bcachefs/io_write.c:1561 [inline]
 bch2_write+0xb42/0x14a0 fs/bcachefs/io_write.c:1630
 bch2_writepages+0x136/0x200 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x1a6/0x7f0 mm/page-writeback.c:2683
 __writeback_single_inode+0x166/0xfa0 fs/fs-writeback.c:1658
 writeback_sb_inodes+0x603/0xfa0 fs/fs-writeback.c:1954
 __writeback_inodes_wb+0xff/0x2e0 fs/fs-writeback.c:2025
 wb_writeback+0x721/0xb50 fs/fs-writeback.c:2136
 wb_check_start_all fs/fs-writeback.c:2262 [inline]
 wb_do_writeback fs/fs-writeback.c:2288 [inline]
 wb_workfn+0x878/0xbc0 fs/fs-writeback.c:2321
 process_one_work+0x9c8/0x1ba0 kernel/workqueue.c:3229
 process_scheduled_works kernel/workqueue.c:3310 [inline]
 worker_thread+0x6c8/0xf00 kernel/workqueue.c:3391
 kthread+0x2c4/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
