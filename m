Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348E05BAF0
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Jun 2025 06:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748757990; cv=none; b=mDnAkdgp+7z1jX7fYehAf6dY7ABRp+idktoAolCoL39kZm8MpalSabpFvrZ41IWBnPya4kpt/D/BgfDNWyl2zi7fQvWPt1oW3zXFaKuJl7zLl5nd/eVIAybtLjK9RaUEJYIanBLvDgvXm17SgZyBDet13iO4HaJ4lHiWZtD3xz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748757990; c=relaxed/simple;
	bh=p4EpFZAyDWxU/aeNsGjxVz0cZ/jPMNVBlfnChRuUv1s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=I0RoOE5GOSZzxnvMeA5UM+i4k113/H8dUAld76/i9gn/P6vIAjC1h3MWDgbZWUXABmr8esn+N3AWIfeOCDK1h9tsqJoheL/8pJnfITyH+gCZ286gb1aCMGICMrA72LFQBX1xRYVSScbyPiKrSECYvI0kObZ0XollpC9r4nPoH8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3dc83674dbbso70263465ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 23:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748757988; x=1749362788;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kabmbo8phJB46YgVpQXJIaqZwVULOZk2uHf/LD/syXQ=;
        b=WKwWK6DbFixbyhEeqw66Gcwu9499ImtCs9OKrmqbnOpie/vK8P80Jov3lsiTApm9EB
         wFlAL05wFArehZrpdBXt/GRZjOS0J0dyU7ngEpGMq+3kwfXHfFWXdfmaHzstW0pYi9aa
         aVU+x+h67bV5ARgUKwoa2susYm2P8Isub0ENsmniR4/co0XFQKqrOKIej3ULXUqh13C9
         4nOdkHtxAnt7YnCLYyN8Sw2NaMUYz8kHp6vae5KRCDYJURfencbzfA/hsjDUUSYMKmBH
         kR1auaFEFlecMEyjkcoy43GG1pIp10yXID+HBQ34CoU99wLjJ/hHDceYtKfSa3SQje5A
         +sIg==
X-Forwarded-Encrypted: i=1; AJvYcCWOonaQlMgfPd5QXP3wcaZ1dx3fxNug7gYRAC/agq6t42R1QJxJfioWq7uoAnnnteyEbRjhNKxlgCT8CHFyWg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/MKo0m2Fa1IYA0VUYR4meBKQpQEDF++xsIpV8xiXAA4BGi/Oa
	E/pjml7r6Bc0k6vrk1bQer+D6whnEEv9n5KOZ9wtIXKxB/3ancKv40ekoFU0cWKYFdtdGgy07x3
	HKiWyzBJKzPiDFSa0WPKNlxEe9Fd085i0A+rfod+6nNU96RK+S+Da9TlziXg=
X-Google-Smtp-Source: AGHT+IGG+J265gMQ/sp7rKTTgnO1EgW1mLGrm4DQ1bu7tp2Ku0gcRG5YqbK9+zbiJoZ0AihVfdo6RFeTIQr1LUdOxXHOXsHeBv56
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a01:b0:3dc:7bc9:5058 with SMTP id
 e9e14a558f8ab-3dd9c9936bemr84598425ab.7.1748757988285; Sat, 31 May 2025
 23:06:28 -0700 (PDT)
Date: Sat, 31 May 2025 23:06:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683bede4.a00a0220.d8eae.002a.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in mempool_alloc_noprof (2)
From: syzbot <syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4cb6c8af8591 selftests/filesystems: Fix build of anon_inod..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a8a00c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=43b7075a5c42ffca
dashboard link: https://syzkaller.appspot.com/bug?extid=56edda805363e0a093b8
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c67ed4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147a300c580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4cb6c8af.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/91b28032d866/vmlinux-4cb6c8af.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7cf2a9f8c096/bzImage-4cb6c8af.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9c0eef7ba9b5/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/0c5386ea7a4e/mount_4.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=12a8a00c580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: Oops: 0010 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5317 Comm: syz-executor257 Not tainted 6.15.0-syzkaller-10402-g4cb6c8af8591 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000d3fedb8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888044583ee8
RDX: 1ffff110088b07dd RSI: 0000000000000000 RDI: 0000000000092800
RBP: ffffc9000d3fef10 R08: ffffc9000d3fee87 R09: 0000000000000000
R10: ffffc9000d3fee60 R11: 0000000000000000 R12: 1ffff92001a7fdc8
R13: ffff888044583ee8 R14: 0000000000092c40 R15: 0000000000092800
FS:  0000000000000000(0000) GS:ffff88808d265000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000042a6b000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mempool_alloc_noprof+0x1a7/0x510 mm/mempool.c:402
 bch2_btree_update_start+0x549/0x1480 fs/bcachefs/btree_update_interior.c:1194
 bch2_btree_node_rewrite+0x17e/0x1120 fs/bcachefs/btree_update_interior.c:2208
 bch2_move_btree+0x6f0/0xc70 fs/bcachefs/move.c:1093
 bch2_scan_old_btree_nodes+0x95/0x240 fs/bcachefs/move.c:1215
 bch2_data_job+0x646/0x910 fs/bcachefs/move.c:1354
 bch2_data_thread+0x8f/0x1d0 fs/bcachefs/chardev.c:315
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000d3fedb8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff888044583ee8
RDX: 1ffff110088b07dd RSI: 0000000000000000 RDI: 0000000000092800
RBP: ffffc9000d3fef10 R08: ffffc9000d3fee87 R09: 0000000000000000
R10: ffffc9000d3fee60 R11: 0000000000000000 R12: 1ffff92001a7fdc8
R13: ffff888044583ee8 R14: 0000000000092c40 R15: 0000000000092800
FS:  0000000000000000(0000) GS:ffff88808d265000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000042a6b000 CR4: 0000000000352ef0
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
