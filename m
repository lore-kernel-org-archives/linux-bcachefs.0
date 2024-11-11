Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79DD17F7
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 00:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731284907; cv=none; b=CrNVWRZchkO4kJZUpUV0dU1K9PPjcyN7WdbFLgk1mnI2GKcFjktfAYHHQ+ZKYUNxOha+qXUpjGe33zlUW+idt/YgANDC6eNOcJ+qB9HiEfKlqnu1/GrwS/FI50u3u7JPZe7vu/e+VkinCFEBKnZaoY4Tv5ItF9VBIiFmH0mc1cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731284907; c=relaxed/simple;
	bh=AtNX+PT3C/pdFDLVft8iEMdcEog8EYRw1rhTOm7Qq8o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OhM6dkbfLLtjibCA6rqWVFg7vByzLRCSRvbxe2ZFqG9Hm5CvbXgR/heMmjBT+lQ5Qlo7xMfkQ5ox+fYQdaRdRoiwAeXU51R3RxlAf/EVvU8u9BH0DyfmRkwaNztR+jamrwKJ0jyiFpLy+Nwb0yZCEixn/nDt0jwCbSqDfCF65pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a6bf539ceaso44705055ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 10 Nov 2024 16:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731284905; x=1731889705;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n+sOcLHXW7oInXtyr92cpfXx3BsIK+2FEd/aTqcx/18=;
        b=PmKyrrD4BehWveHP3ysfRgf/4AH5lviBk/LYvsRRm2fvA6OdIlw4gOZswBOkxtD5Ct
         LtK8c8RNWTmq4Y5ctXT3VUZeW6aQE4I1/nwrw4mp5BUtcQ9raNMqmnmy9t6VuXhUfbqG
         qQ3W4JO04t9gveq9mJo4g4u66WjMw2aOpAEsxHeA1SDalbG/cqy9l5BpyvLfjAq213yb
         jMQUjYsoM2o3VCwnR9eNJ42YZc090UPSa9UPcNthDApe8HwNEnDMBEVHMQqdqE8IKe6F
         9HWd45t+8a8kpF04SE5RRHKiN1jguvKUeuP4AOHeyF/KXwohpECOoNTxJ+asfZhHV05P
         J9Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWBLUp/kbSgisKcvvC2/ztVrYwRUiwl+jXz42Ei2ClQtBGptDnS66mXWDzQBVql/9JDk1MyjgjBvMmyrKPkRg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXGELWWsqXJDQwoubD+RrxYF+9w4LY0RouoPnHq7wwRJrcnSqi
	BXDHAKumeG5e74Rwv4dKxM8ItKBXtnegZnaQwlQJv3f87W/p1Eyw2HK8nC514CCkU+zJTB4Hnz8
	SMmywtZIYAVjEV0xDTLPcBt0+MdB/1CxcufdvTK+kOFd97EQ4W+0drqs=
X-Google-Smtp-Source: AGHT+IHWZauRWWUQFOfns0ik8UhM7aT+2BQMB+2Rhj1pynJ0FwdgNaPTbpR6vDAzf1nrN2P1CXixPGo7SMpms1jBUW2/8P7Gkd13
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18cc:b0:3a6:be9a:2144 with SMTP id
 e9e14a558f8ab-3a6f254c63dmr101892155ab.11.1731284904834; Sun, 10 Nov 2024
 16:28:24 -0800 (PST)
Date: Sun, 10 Nov 2024 16:28:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67314fa8.050a0220.138bd5.0057.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_btree_node_check_topology
From: syzbot <syzbot+494bcd3631a9f6759f91@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7758b206117d Merge tag 'tracefs-v6.12-rc6' of git://git.ke..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13e72e30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fdf74cce377223b
dashboard link: https://syzkaller.appspot.com/bug?extid=494bcd3631a9f6759f91
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a0df40580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15e1f6a7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cff7adedd889/disk-7758b206.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c3babec78429/vmlinux-7758b206.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9de747183951/bzImage-7758b206.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c2654a9124db/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+494bcd3631a9f6759f91@syzkaller.appspotmail.com

BUG: KMSAN: uninit-value in bch2_btree_node_check_topology+0x12cc/0x2e40 fs/bcachefs/btree_update_interior.c:96
 bch2_btree_node_check_topology+0x12cc/0x2e40 fs/bcachefs/btree_update_interior.c:96
 btree_split_insert_keys+0x4fd/0x630 fs/bcachefs/btree_update_interior.c:1573
 btree_split+0xdc4/0x98e0 fs/bcachefs/btree_update_interior.c:1664
 bch2_btree_insert_node+0xaba/0x2810 fs/bcachefs/btree_update_interior.c:1837
 bch2_btree_node_rewrite+0x10f8/0x1930 fs/bcachefs/btree_update_interior.c:2164
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2230 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2243
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4219
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4236
 __do_kmalloc_node mm/slub.c:4252 [inline]
 __kmalloc_node_noprof+0x9d6/0xf50 mm/slub.c:4270
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:658
 btree_node_data_alloc fs/bcachefs/btree_cache.c:125 [inline]
 bch2_btree_node_mem_alloc+0xa68/0x2e30 fs/bcachefs/btree_cache.c:807
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:325 [inline]
 bch2_btree_reserve_get+0x37f/0x2290 fs/bcachefs/btree_update_interior.c:554
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1252
 bch2_btree_node_rewrite+0x1da/0x1930 fs/bcachefs/btree_update_interior.c:2142
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2230 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2243
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

CPU: 0 UID: 0 PID: 3761 Comm: kworker/u8:13 Not tainted 6.12.0-rc6-syzkaller-00099-g7758b206117d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
=====================================================


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
