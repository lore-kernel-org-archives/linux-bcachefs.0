Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C51E23B1
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720971265; cv=none; b=fVThoKU6KmyyxnVe/0JKqbKAEN4liThSGwr1JXjDcokvvOFCva28SPnbJq6X+UKCWpkPtksWRKNG+0iYpcSIAZSSn9k0I25Cytv4DEb5EJYOsZS5zjk/vcqt7N+KKC4g0BhbF+ZB0OxI32dXA45KYFK2AaAgVZophrq7cVWkciA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720971265; c=relaxed/simple;
	bh=VxH4UksOpkaMl6EV/9swL9EnoM9ryOGtmKZl0FXTSJM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TPg+iMWjSVejQh/sUgsvayivHQCHC3BXJG8Q1A3Uwpm7994BWyf+Lh9pzg34u/L+y3gPzOXG0Ple4Mztnz5bHvZRDPM90c4Nzg5Fsk1D8i4V89WVkimm4zWLYFLHixqPN63XBZMkiKG32JUOIH0KZUezhzjbexwWoHcUJS9pKRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-80502b81995so398129539f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 08:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720971263; x=1721576063;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqBCk+MGR7k+XeGXBmb2zUl3eXxlEyHzV+d8dZCTaFo=;
        b=v0jONeER13zccQYbQaLM8i7RzIgvTrTlvS59D2fPiX1Xz4wW/ityJGEDu6QR2ShQeJ
         7Y5BTa9rNYjK7h/JANd1jc+IerXzIRzvClBgjfVyxm82RBHRr9yw/5aQh7bn4uu+9MXS
         9VdMg01JJ4JcCERBozVVDZwhzB0I8ebTUbh5htDCfP1Eb6alfJW9yuZ8VbFkQ3mgbKYh
         v9G7f/4jehVbOVG+o9fAjMf0yAEdb64vuJuXJ4jVj/rlriGtR1tr4BCbazazRQzbkyvV
         9sjE9lfO2qAooP39TW0UN6u81kpHOMy3Alw0hGCaikmvX8+3p0/YSaiNjC8gE+zVcz34
         d7kA==
X-Forwarded-Encrypted: i=1; AJvYcCW3NNAmP4QSQH7INyK42zI5qKqqkESw8RPrQn2mb2R49QFw2qYAgnWTZylWKiuxrEMP3B4xypPNiQnHX3em58XUoLxSm0FLGekhPr0YsjU=
X-Gm-Message-State: AOJu0Yy2mPRyryEQME0wPKtjyENM/ym7HK5QFQvAlvwHcslkvhD6uNAg
	7pRmL7zpXchcPiU53MbK/9m0OayFBM6QViUJHCKv681d7w8OoxbSwY5Ou7iXZA/aHw8HmX48tHY
	hldJnv3rGFBU1GZWehot/DKVlRsEY7fWsA7XILuL9zNtLHrmZLWuEXM4=
X-Google-Smtp-Source: AGHT+IF1YXaI2DLY2PZSZMvLQ0FZlApMjvRbGPeG8ZsDwDr9/EMcZ9+nkOePgUSUYejKzHblECrVYhzQHCBRtRcOgtU6muM1Mngg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3f8d:b0:80f:81f5:b484 with SMTP id
 ca18e2360f4ac-80f81f5b905mr21236239f.2.1720971263501; Sun, 14 Jul 2024
 08:34:23 -0700 (PDT)
Date: Sun, 14 Jul 2024 08:34:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4795d061d36d825@google.com>
Subject: [syzbot] [btrfs?] BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low! (5)
From: syzbot <syzbot+d79987254280f6484dd2@syzkaller.appspotmail.com>
To: bfoster@redhat.com, clm@fb.com, dsterba@suse.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a10a61980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8786f381e62940f
dashboard link: https://syzkaller.appspot.com/bug?extid=d79987254280f6484dd2
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fb0f02980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d3d851980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c40c1cd990d2/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a2a94050804e/bzImage-2ccbdf43.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/56eac6c758d4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d79987254280f6484dd2@syzkaller.appspotmail.com

BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
turning off the locking correctness validator.
CPU: 1 PID: 5233 Comm: kworker/1:1 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 add_chain_cache kernel/locking/lockdep.c:3735 [inline]
 lookup_chain_cache_add kernel/locking/lockdep.c:3816 [inline]
 validate_chain kernel/locking/lockdep.c:3837 [inline]
 __lock_acquire+0x2ea6/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 _raw_spin_lock_nested+0x31/0x40 kernel/locking/spinlock.c:378
 raw_spin_rq_lock_nested+0x29/0x130 kernel/sched/core.c:559
 raw_spin_rq_lock kernel/sched/sched.h:1406 [inline]
 rq_lock kernel/sched/sched.h:1702 [inline]
 ttwu_queue kernel/sched/core.c:4055 [inline]
 try_to_wake_up+0x514/0x13e0 kernel/sched/core.c:4378
 kick_pool+0x2a0/0x7a0 kernel/workqueue.c:1279
 __queue_work+0x94d/0x1020 kernel/workqueue.c:2360
 queue_work_on+0x11a/0x140 kernel/workqueue.c:2410
 queue_work include/linux/workqueue.h:621 [inline]
 __bch2_btree_node_write+0x1fc1/0x2d60 fs/bcachefs/btree_io.c:2232
 bch2_btree_node_write+0x127/0x2f0 fs/bcachefs/btree_io.c:2307
 btree_split+0x1087/0x3010 fs/bcachefs/btree_update_interior.c:1706
 bch2_btree_split_leaf+0x108/0x770 fs/bcachefs/btree_update_interior.c:1857
 bch2_trans_commit_error+0x327/0xd00 fs/bcachefs/btree_trans_commit.c:918
 __bch2_trans_commit+0x4eb1/0x7ad0 fs/bcachefs/btree_trans_commit.c:1138
 bch2_trans_commit fs/bcachefs/btree_update.h:170 [inline]
 bch2_delete_dead_snapshots+0x1b07/0x4e50 fs/bcachefs/snapshot.c:1617
 bch2_delete_dead_snapshots_work+0x20/0x160 fs/bcachefs/snapshot.c:1690
 process_one_work+0x9fb/0x1b60 kernel/workqueue.c:3231
 process_scheduled_works kernel/workqueue.c:3312 [inline]
 worker_thread+0x6c8/0xf70 kernel/workqueue.c:3393
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting keys from dying snapshots erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting keys from dying snapshots erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting keys from dying snapshots erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting keys from dying snapshots erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error erofs_trans_commit
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error deleting snapshot 4294967295 ENOENT_bkey_type_mismatch
bcachefs (loop0): bch2_delete_dead_snapshots(): error ENOENT_bkey_type_mismatch


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
