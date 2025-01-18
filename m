Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6340F158870
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Jan 2025 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737180148; cv=none; b=U97ghk7aGtbe7Dk6c/I4jdRC221P9u0VtKiHBXqlYA+AFz3dcZskIaLBsdG4SQZ2GnyB49+3Uq8vn6xX6h785a57tocev3kxAvDfcwhHE1HvmfWUZwmj3J2yOAfymPit1ateOsL3NXkvab7iK+VUJT1bDr29iUQtK6wFDuFn3gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737180148; c=relaxed/simple;
	bh=hAIMo/7rQAP1sB2VOQzMM0vy6BO5LpmfB/+qJrKud3A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Tb29mhr8lDacc7mXZaKbxf7HbRT+ZkF0qiLrR94ygJJ6Kb4+NF/JC9n3oG/7MAX4Kxtw1xJhFZk12/K1r54btV9yoo4RY/DNZB9lY4DofKI4BpxcNcR5Mou9YQ2XVAA1i0/dVklpWa3qlr8ubNwiqonZIu5GKhrNYklEY9oE5js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ce8cdf1898so16038165ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 17 Jan 2025 22:02:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737180145; x=1737784945;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8DGj8t7zZaBZAyMgTvK2ezQbPr1//3Z5VyPLbRW0VAg=;
        b=j4FVytmU/9Wd1Flr4QXOUtkUpDu5bq831EgbPBK53O261CHQvX2kggI65te0KiCG71
         EKU9GKfaHQEIDy196zh4W5swLgIjgZLPWiPjER4dPPgETmEo66x1P2Kwf8SrSbkhu/Wn
         lUEFBTAGqE9W8eOlrqvpTzYIhB32S1DK8+HAM20yLWrEE+Q2ISv+sAUc5Qt4jOBJQ6/j
         ddB5sBQLZqHdHoP31CZo1RyxKejjqWaW9h3uhAq++ia9byOEijwaUobuMn/atlOQWb4X
         ipE1fN5H+/PPFDb38B0tvMPuNSNP5MvBLmwaPWoaMHhDaCUg128FEeZXq0Kui9S/V9cC
         CYMQ==
X-Forwarded-Encrypted: i=1; AJvYcCWByxLQeSJ5SSwxl9ZaKZ+rGdL5mzxO4us9RT+zLHRw3JCQr9bkOknE2W6sUgzukS94RF9r7J7Y+3YtN3ZR/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuyNapbv68ncBbLMOC5Kc+ZfK8veAqZgOpB0y5FVZGpW+HheUw
	fgab/UttC09DmBYAX0Z3fMxvuZ01G7ObzQuJmTEk8Oz5z9t/AzL0daBntsEwlKrwzMUD9F0JfSc
	CZaS444uMENyZefL1UxDfidyBUNOiWygZHkb3Edk6+2WSoYhiCQe02Hc=
X-Google-Smtp-Source: AGHT+IErnCEVZ1leX9sQ76mWabhPmClBMsc0l6v/w4iNr3ct4OGYq8/0LuZ5NPdfh/x4sQIfI+qwGED28U+qCKCheOK8Vb+vl2BX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219e:b0:3cf:6463:41fc with SMTP id
 e9e14a558f8ab-3cf74487c3bmr43063965ab.17.1737180145424; Fri, 17 Jan 2025
 22:02:25 -0800 (PST)
Date: Fri, 17 Jan 2025 22:02:25 -0800
In-Reply-To: <67823638.050a0220.d0267.0040.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678b43f1.050a0220.303755.001d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_journal_replay (2)
From: syzbot <syzbot+a3885f6d294f83923567@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ad26fc09dabf Merge tag 'mm-hotfixes-stable-2025-01-16-21-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104fe1f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aadf89e2f6db86cc
dashboard link: https://syzkaller.appspot.com/bug?extid=a3885f6d294f83923567
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ceba18580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137ee9df980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ad26fc09.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e8c59e9a573f/vmlinux-ad26fc09.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8bfa2df81410/bzImage-ad26fc09.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/8485647a2ac3/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3885f6d294f83923567@syzkaller.appspotmail.com

    new u64s 5 type deleted 14293651161087:U64_MAX:U32_MAX len 0 ver 0
bcachefs (loop0): bch2_btree_update_start(): error EIO
bcachefs (loop0): bch2_btree_update_start(): error EIO
------------[ cut here ]------------
kernel BUG at fs/bcachefs/recovery.c:130!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5306 Comm: syz-executor276 Not tainted 6.13.0-rc7-syzkaller-00160-gad26fc09dabf #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:130 [inline]
RIP: 0010:bch2_journal_replay+0x2a09/0x2a40 fs/bcachefs/recovery.c:346
Code: cd 35 7e 07 e8 68 9e 54 fd 90 0f 0b e8 60 9e 54 fd 90 0f 0b e8 58 9e 54 fd 90 0f 0b e8 50 9e 54 fd 90 0f 0b e8 48 9e 54 fd 90 <0f> 0b e8 40 9e 54 fd 90 0f 0b e8 38 9e 54 fd 90 0f 0b e8 30 9e 54
RSP: 0018:ffffc9000d297180 EFLAGS: 00010293
RAX: ffffffff844ae428 RBX: ff0000000000000b RCX: ffff88801f6b0000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ff0000000000000b
RBP: ffffc9000d297478 R08: ffffffff844ad999 R09: ffffffff84beba5f
R10: 0000000000000004 R11: ffff88801f6b0000 R12: ffff888044a4abb8
R13: dffffc0000000000 R14: 00000000ffffffff R15: ffff888044a4abc0
FS:  000055555a053380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fd59292098 CR3: 0000000043c6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3511
 do_mount fs/namespace.c:3851 [inline]
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1e71c47dfa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde82bfb88 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffde82bfba0 RCX: 00007f1e71c47dfa
RDX: 00000000200058c0 RSI: 0000000020000140 RDI: 00007ffde82bfba0
RBP: 0000000000004800 R08: 00007ffde82bfbe0 R09: 0000000000005a2b
R10: 0000000000004800 R11: 0000000000000282 R12: 0000000000000005
R13: 00007ffde82bfbe0 R14: 0000000000000004 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:130 [inline]
RIP: 0010:bch2_journal_replay+0x2a09/0x2a40 fs/bcachefs/recovery.c:346
Code: cd 35 7e 07 e8 68 9e 54 fd 90 0f 0b e8 60 9e 54 fd 90 0f 0b e8 58 9e 54 fd 90 0f 0b e8 50 9e 54 fd 90 0f 0b e8 48 9e 54 fd 90 <0f> 0b e8 40 9e 54 fd 90 0f 0b e8 38 9e 54 fd 90 0f 0b e8 30 9e 54
RSP: 0018:ffffc9000d297180 EFLAGS: 00010293
RAX: ffffffff844ae428 RBX: ff0000000000000b RCX: ffff88801f6b0000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ff0000000000000b
RBP: ffffc9000d297478 R08: ffffffff844ad999 R09: ffffffff84beba5f
R10: 0000000000000004 R11: ffff88801f6b0000 R12: ffff888044a4abb8
R13: dffffc0000000000 R14: 00000000ffffffff R15: ffff888044a4abc0
FS:  000055555a053380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fd59292098 CR3: 0000000043c6e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
