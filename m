Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082271EB48
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729516063; cv=none; b=qQgwh/1GsQDtHVrObIsz/Md5smxOmty55G7bpz73vq/ZUFJUGWW/oKnzTYfG4m8pdsPOz89n27s66F0SsAqS0ThxcSa1g3Mp6nmzEYi7XHnsWi7BamrEeKdv44ZDExvyw7egflTlZjexQ0YkM76Qla2JFQXmiqf4kACtrGEueUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729516063; c=relaxed/simple;
	bh=5Ifj4Sp13dHucqKkTQuEhcox6XUMdqjWTOIw2lr9WTQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=N25g79PqJ6tepewFbOe83Cv+kDOrBlq3RBmYWjnwO9mZBuJ6yrxD7lR/qUEqkRtmZxhEyS11QEcvJL2+5b4v+7NYwdXeZ/sDXxuH2cwC7JfOTRuFhtYRa1I4/V/mTRjKAapp1HEviij3Z1fgnQNc2TmywMVS2JNsBOpkUC3/LUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3c24f3111so41838515ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 06:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729516060; x=1730120860;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avKkSIJdplTpCHpPm7V8BJnb89UfH6875r+tEKrJznY=;
        b=Srutu2AcR/5CVVCMkAwa7pHd4zYENyXGFGtmKXy/3zyg/0fvas0kDO6dfdpu3H1heK
         2td6cZeYpqy+wCwYb10e3DskYp/ISoWc0Bfxd2kakzoyuXeoJtvOPsjs9XOjjBxbejLx
         n9woRMPmqhc8zQOKzrlaMqvxMSGl7QeYO8IPVAlTp+P3IcdqG6T149j3P7i3DtOTkxmZ
         JMW1FF/Jvz4tqZR9FGMKvVNvn0XQ+lzugCckAFw1CEr+/ig/oXU97uj3E/jNm/+3G8vC
         d5fWi7/InwjEiYZo5Ly/QO9hsXsSJI9N9YGFtGQFQA4WYZJW/lOgd3TfTuPa4ZfQaoVW
         sRDQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3Sis50a/FmJRtmvVeWhvKD7UHCbnjag52JOsl1JjgkWO8PNbcFGXVXx6i0wILQn8PjETeNsueLfXD5vcbqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8J7OdONQ+jz5MtsSju+IjmDP+KKhNLRyRtFkYZ3DZ9uLL9Q+w
	EycOmLXZ1TZMZxo2KfzSslCZnrj1OmNpz7qLh28RroB7YjNWZQo7Tb0FNR5PPQjy2VkkwWcLgsS
	cub+bUpBISDerueiYc8Bi3NhoesUcPE0UHhcTDZxmvcWX0b64o2Yr304=
X-Google-Smtp-Source: AGHT+IEfM1SxMR602Gv3uvZ9LAUePUEeFHq+e6NXJc8W9Cu2+R8RMwypX6k17FzaQ+miCdUY/DjBzbvJlbMr7mLXM+TdItwOBo8G
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a81:b0:3a3:4175:79d2 with SMTP id
 e9e14a558f8ab-3a3f4073c20mr112039805ab.14.1729516059938; Mon, 21 Oct 2024
 06:07:39 -0700 (PDT)
Date: Mon, 21 Oct 2024 06:07:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6716521b.050a0220.1e4b4d.0059.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_key_insert_take
From: syzbot <syzbot+47f334396d741f9cb1ce@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    15e7d45e786a Add linux-next specific files for 20241016
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10a5c240580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c36416f1c54640c0
dashboard link: https://syzkaller.appspot.com/bug?extid=47f334396d741f9cb1ce
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11044487980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12815830580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cf2ad43c81cc/disk-15e7d45e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c85347a66a1c/vmlinux-15e7d45e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/648cf8e59c13/bzImage-15e7d45e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6ba77e840d2c/mount_0.gz

The issue was bisected to:

commit d59f4aba096298347f0e0e5402843bb8505edc2d
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 12 02:53:09 2024 +0000

    bcachefs: -o norecovery now bails out of recovery earlier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1580c487980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1780c487980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1380c487980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47f334396d741f9cb1ce@syzkaller.appspotmail.com
Fixes: d59f4aba0962 ("bcachefs: -o norecovery now bails out of recovery earlier")

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_journal_iter.c:190!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 1169 Comm: kworker/1:2 Not tainted 6.12.0-rc3-next-20241016-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work (bcachefs-delete-dead-snapshots/)
RIP: 0010:bch2_journal_key_insert_take+0x180f/0x1830 fs/bcachefs/btree_journal_iter.c:190
Code: f1 fc ff ff e8 d2 51 78 fd 90 0f 0b e8 ca 51 78 fd 90 0f 0b e8 c2 51 78 fd 90 0f 0b e8 ba 51 78 fd 90 0f 0b e8 b2 51 78 fd 90 <0f> 0b e8 4a a1 af 07 e8 a5 51 78 fd 90 0f 0b e8 9d 51 78 fd 90 0f
RSP: 0018:ffffc9000430edc0 EFLAGS: 00010293
RAX: ffffffff841c909e RBX: 0000000000000040 RCX: ffff8880272b8000
RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
RBP: ffffc9000430ef30 R08: ffffffff841c7a8e R09: 1ffff1100de80035
R10: dffffc0000000000 R11: ffffed100de80036 R12: 0000000000000000
R13: ffff88806f400000 R14: dffffc0000000000 R15: ffff88806f44b310
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559ab32ac530 CR3: 00000000744be000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_key_insert+0xb3/0x130 fs/bcachefs/btree_journal_iter.c:260
 do_bch2_trans_commit_to_journal_replay+0x111/0x420 fs/bcachefs/btree_trans_commit.c:1003
 __bch2_trans_commit+0x15d9/0x9420 fs/bcachefs/btree_trans_commit.c:1039
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_delete_dead_snapshots+0x19b6/0x5ae0 fs/bcachefs/snapshot.c:1655
 bch2_delete_dead_snapshots_work+0x34/0x40 fs/bcachefs/snapshot.c:1730
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_journal_key_insert_take+0x180f/0x1830 fs/bcachefs/btree_journal_iter.c:190
Cod


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
