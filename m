Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F436EB4D
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 22:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717712551; cv=none; b=fK4CY4a+LurP/Splz4GR4dv6UFmIgbZq3FTPblPAbWKdaRIuDSCULn8vOWhIqG/YzSll2XEyOwtmjfG3Nmtbcl71a0qPB0DQT33k6v6hIllyicXVQ+91J3qdfWoPZf+NxE+ZTizmXkkoi59qOeWbXI8Bq83H38TBRMDW2cALn2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717712551; c=relaxed/simple;
	bh=+YbgPN4sGECjpFbIwFXJq2izvaMeN6JfjGGslKInETw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=T6WEtJ85yG9IKTr7ZoEh4YKHFcqgwEI9DgNQsEEDgrQ8Z9jgpwxEJtkmhCtSvX4TLNcyJXLEZ4OvWk6kWWHhEFYKguxV+uowvvubPD/aeaQzMgbCFCjI3XYdad16jNqdHIySdLsNH1mdUW1+Ux9MowJ0DOy886f7Y1aTN+ITweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7eb4c4378c0so130694139f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Jun 2024 15:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717712549; x=1718317349;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A3SfVqWCeEvzx6qk1GQPFO5BgPtJCu/+FRWlEGWXISU=;
        b=VV3Pi1QJqKcyt6r8Ny6m53FW8R43v89Gk53QESXM5GAI2gswfanjeFRiNCPQYO27fH
         6KqKTYlTyJ56Ul/E9NPo2OvVzF19INJYeTMXLCbpWKzegjgjeLLbsphHvrA0zOoGgw+5
         rnoPSr4n4qobgdz1a58l95Z4JSOBq6JpYH8niEn0abe7iyuqSzwsz41gGg462MRBZ81c
         poA4YpB0POf+N59/gRCw/TOH/tqBSrl7igEAPbm270DrO1n3g/4me+sUgoeLHml/lCw1
         VfbyDgIemyR7NUhn4OXFxjFtiYimAQD/2yAcIamCrSqChFFyReo7zA/YmpnMn3hBp/l1
         4E7w==
X-Forwarded-Encrypted: i=1; AJvYcCWZ5CeBX6xEUffRoOiamQF17+Rcqi2E/nw+r3ytBL4Cznep426uIwyFsyx9DVn7A89pqR53tq0bwAjK9jyuMIi8hGscTXWU+2IG/zk2lqE=
X-Gm-Message-State: AOJu0YyO+0pFdqHnqRfxwfIfYGXMVcKOi8fOOA1k7YI2ZZ2lXaEN+TJ2
	DsEHu+uFywShM70tEhsYpP6y8aXm2oAUC76wiyDvv+NsxmeMs4qbYP3zoidf0mA/QmL8cQ0VuGH
	RWR9KTqNyAqjnbXMmArA1CWEBYuWeDTIunHPGrK7WqG2WP58hyh/wAmE=
X-Google-Smtp-Source: AGHT+IENlrlGDBqpnFUoQSvNfGUN0bBTXotpHV/JkSAeVwV2thJtKXX2sd9MVxa9vdHECg8wd4n8HlJD0fvpxngL1Q3xTTGa2MKp
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fd5:b0:7cc:2522:f5fd with SMTP id
 ca18e2360f4ac-7eb571c83c6mr6854139f.1.1717712549134; Thu, 06 Jun 2024
 15:22:29 -0700 (PDT)
Date: Thu, 06 Jun 2024 15:22:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000515313061a401ea1@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_lru_change
From: syzbot <syzbot+df3bf3f088dcaa728857@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    83814698cf48 Merge tag 'powerpc-6.10-2' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15376aba980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=47d282ddffae809f
dashboard link: https://syzkaller.appspot.com/bug?extid=df3bf3f088dcaa728857
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e7b928e00d7b/disk-83814698.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/318e218a0bda/vmlinux-83814698.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b5b5d49c35f6/bzImage-83814698.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df3bf3f088dcaa728857@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/lru.h:22!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 7494 Comm: syz-executor.4 Not tainted 6.10.0-rc1-syzkaller-00304-g83814698cf48 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:lru_pos fs/bcachefs/lru.h:22 [inline]
RIP: 0010:__bch2_lru_set fs/bcachefs/lru.c:48 [inline]
RIP: 0010:bch2_lru_del fs/bcachefs/lru.c:54 [inline]
RIP: 0010:bch2_lru_change+0x65c/0x680 fs/bcachefs/lru.c:69
Code: 80 e1 07 38 c1 0f 8c 47 fd ff ff be 14 00 00 00 48 8b 7c 24 10 e8 74 f5 c4 fd e9 33 fd ff ff e8 9a ee 49 07 e8 85 7d 62 fd 90 <0f> 0b e8 7d 7d 62 fd 90 0f 0b e8 75 7d 62 fd 90 0f 0b e8 6d 7d 62
RSP: 0018:ffffc90004c5ec20 EFLAGS: 00010293
RAX: ffffffff8433980b RBX: 1ffff9200098bd9a RCX: ffff88801a7e1e00
RDX: 0000000000000000 RSI: 6985a28b8c752100 RDI: 0000ffffffffffff
RBP: ffffc90004c5ed50 R08: ffffffff84339353 R09: ffffffff84011614
R10: 0000000000000003 R11: ffff88801a7e1e00 R12: 0000ffffffffffff
R13: 1ffff9200098bd8c R14: 6985a28b8c752100 R15: ffffa28b8c752100
FS:  0000555590ab6480(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555590acf9b8 CR3: 000000006a46c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_trigger_alloc+0x2695/0x3b90 fs/bcachefs/alloc_background.c:797
 bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:509 [inline]
 run_btree_triggers+0xbff/0x11d0 fs/bcachefs/btree_trans_commit.c:544
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:587 [inline]
 __bch2_trans_commit+0x574/0x88e0 fs/bcachefs/btree_trans_commit.c:1022
 bch2_trans_commit fs/bcachefs/btree_update.h:170 [inline]
 bch2_inode_delete_keys+0xae8/0x1440 fs/bcachefs/inode.c:845
 bch2_inode_rm+0x165/0xd40 fs/bcachefs/inode.c:874
 bch2_evict_inode+0x21c/0x3c0 fs/bcachefs/fs.c:1579
 evict+0x2a8/0x630 fs/inode.c:667
 do_unlinkat+0x512/0x830 fs/namei.c:4414
 __do_sys_unlink fs/namei.c:4455 [inline]
 __se_sys_unlink fs/namei.c:4453 [inline]
 __x64_sys_unlink+0x49/0x60 fs/namei.c:4453
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f64ece7c697
Code: 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5f1d8f38 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f64ece7c697
RDX: 00007ffe5f1d8f60 RSI: 00007ffe5f1d8ff0 RDI: 00007ffe5f1d8ff0
RBP: 00007ffe5f1d8ff0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000206 R12: 00007ffe5f1da0e0
R13: 00007f64ecec8336 R14: 000000000003e964 R15: 0000000000000018
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lru_pos fs/bcachefs/lru.h:22 [inline]
RIP: 0010:__bch2_lru_set fs/bcachefs/lru.c:48 [inline]
RIP: 0010:bch2_lru_del fs/bcachefs/lru.c:54 [inline]
RIP: 0010:bch2_lru_change+0x65c/0x680 fs/bcachefs/lru.c:69
Code: 80 e1 07 38 c1 0f 8c 47 fd ff ff be 14 00 00 00 48 8b 7c 24 10 e8 74 f5 c4 fd e9 33 fd ff ff e8 9a ee 49 07 e8 85 7d 62 fd 90 <0f> 0b e8 7d 7d 62 fd 90 0f 0b e8 75 7d 62 fd 90 0f 0b e8 6d 7d 62
RSP: 0018:ffffc90004c5ec20 EFLAGS: 00010293
RAX: ffffffff8433980b RBX: 1ffff9200098bd9a RCX: ffff88801a7e1e00
RDX: 0000000000000000 RSI: 6985a28b8c752100 RDI: 0000ffffffffffff
RBP: ffffc90004c5ed50 R08: ffffffff84339353 R09: ffffffff84011614
R10: 0000000000000003 R11: ffff88801a7e1e00 R12: 0000ffffffffffff
R13: 1ffff9200098bd8c R14: 6985a28b8c752100 R15: ffffa28b8c752100
FS:  0000555590ab6480(0000) GS:ffff8880b


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
