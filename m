Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E277A1DF258
	for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732301066; cv=none; b=Q4A/NkYNyc+C7nGO6qtJdSNlfr0rLXsZpB9mOkKvOnTWEm3kVR4DLcd0BFxyZqrQhhMxiMTRjolZH4cqukkoAOar+UrslgwaD3RwTBBacrQwer+led41p13+HDqe2ssnZKs9q8sOnl7I7RznDdbmcCtnlA3SC6pyPLGRfSeTDi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732301066; c=relaxed/simple;
	bh=EwkBTr/N3yhq9SFwac0I+lxk1xz3tctWv0sLN6oCTP8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dDYy+znxJeXXA9aemvfOpoFglWcMSv5jD0NEvtHeBECfhxkW/tEHYtXRwvyIpQGiAdPcGRr5zBFSXLN1othLVhQj1fdDbeefp6vKuYq5CvXDXCzW8IwzreXDOLo71meXz1QDGM1JcEKP4qgPsZmB8Q1TLbfBPJWai5K6V3/hiXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a78b04470cso27580815ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 10:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732301064; x=1732905864;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MdimGuhinLllTQuj7Lr0mfJgpwO+4DOFH9jFfw9xekk=;
        b=XejC83a6F/b3TWuCfjCDcqcbCrT+51QvxRc8GveDGMc+WgUKP6dM03qTCF1yUj9ejD
         e3o26O+stpeafTEm/0sCEUizg5j8WW9gy/yMsTjLk0f5Euin20J3uq0AAQQ5sCvuHXKh
         tP29tvVlLU2cSgAJaCXTOvNZMQYsxm0BXEE8CeeMcJeaC41zZJN79kDKv7ethgFJFq4R
         /dljwFTB5Epo39YLcsLEwnoNqC0reBHC5Y6cR2AEFsHhKPxXvaHPHfMn3BqZthADUELk
         7lKWOxj/1O0yGvwD/1ac71f2txqfJW4si6A3UIL/++kwExXbSqsOI8QPxs+a6aQSn6Be
         4n2A==
X-Forwarded-Encrypted: i=1; AJvYcCUie8zmU1NNe6dcqrjYcGjaYvx6eU0SGpNr5ImLe0gVoFudIxTqijge7ur462vPDMz54e/FRRnF7UcyIpjewg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUSJADx5rCIfmBoCkgaVa87u5sMb7NRXTCtxk1UGQcfu/xcMEz
	qXBDIVYuYpXM0z8HnI3ReeOXAYSGPqqmyyP4pSakqKn2h5L0+Xp5vdirfD2JfWn1lyoI4CC1d4v
	G6HLClUWvpapryiBL/7NJNpEZPYvzBveczFyccxWDiFVoLfPw1B+hrNQ=
X-Google-Smtp-Source: AGHT+IGXhplYSr+IciGa5CrDFj7QPgZXsW7/ePHDf1LJCJ6vNpZkqL+sj0TVvZiY9xYcvmYqMlT/AJ66c2uP0FLdfvvxCCb900hH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18c9:b0:3a7:8040:5962 with SMTP id
 e9e14a558f8ab-3a79ab8148bmr54183145ab.0.1732301064231; Fri, 22 Nov 2024
 10:44:24 -0800 (PST)
Date: Fri, 22 Nov 2024 10:44:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6740d108.050a0220.3c9d61.0196.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_pos_to_text (2)
From: syzbot <syzbot+1f202d4da221ec6ebf8e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    158f238aa69d Merge tag 'for-linus-6.13-rc1-tag' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13798b78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e547da255e4eefa
dashboard link: https://syzkaller.appspot.com/bug?extid=1f202d4da221ec6ebf8e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e386c0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1105875f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-158f238a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0a823971fc99/vmlinux-158f238a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e215e05844b2/bzImage-158f238a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b0994925a8f6/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f202d4da221ec6ebf8e@syzkaller.appspotmail.com

invalid bkey u64s 5 type set 18446462598867058688:34:0 len 3072 ver 0
  size != 0: delete?, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.h:131!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5321 Comm: read_btree_node Not tainted 6.12.0-syzkaller-00971-g158f238aa69d #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:131 [inline]
RIP: 0010:bch2_btree_pos_to_text+0x1ee/0x1f0 fs/bcachefs/btree_cache.c:1403
Code: 00 00 fc ff df e9 70 ff ff ff 89 d9 80 e1 07 38 c1 0f 8c 7a ff ff ff 48 89 df e8 fd 89 e9 fd e9 6d ff ff ff e8 c3 a1 7f fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d14f448 EFLAGS: 00010293
RAX: ffffffff8415501d RBX: 000000000000001e RCX: ffff888000c04880
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84154f0a R09: 0000000000000000
R10: ffffc9000d14f5e0 R11: fffff52001a29ec1 R12: ffff888040420800
R13: ffff888044700000 R14: ffff888044700000 R15: ffffc9000d14f5e0
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562b097d2fd0 CR3: 0000000011e62000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_node_read_work+0x486/0x1260 fs/bcachefs/btree_io.c:1308
 bch2_btree_node_read+0x2433/0x2a10
 bch2_btree_node_fill+0xc75/0x12f0 fs/bcachefs/btree_cache.c:991
 bch2_btree_node_get_noiter+0x9d5/0xf70 fs/bcachefs/btree_cache.c:1260
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:193 [inline]
 read_btree_nodes_worker+0x13c5/0x2220 fs/bcachefs/btree_node_scan.c:242
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:131 [inline]
RIP: 0010:bch2_btree_pos_to_text+0x1ee/0x1f0 fs/bcachefs/btree_cache.c:1403
Code: 00 00 fc ff df e9 70 ff ff ff 89 d9 80 e1 07 38 c1 0f 8c 7a ff ff ff 48 89 df e8 fd 89 e9 fd e9 6d ff ff ff e8 c3 a1 7f fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d14f448 EFLAGS: 00010293
RAX: ffffffff8415501d RBX: 000000000000001e RCX: ffff888000c04880
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84154f0a R09: 0000000000000000
R10: ffffc9000d14f5e0 R11: fffff52001a29ec1 R12: ffff888040420800
R13: ffff888044700000 R14: ffff888044700000 R15: ffffc9000d14f5e0
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b6646f3018 CR3: 0000000011e62000 CR4: 0000000000352ef0
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
