Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75568146A7A
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Nov 2024 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485831; cv=none; b=W9zojTFQKNl6/lfWgtBe2Gjjj/gXyZyyBUrl9Y7bpxr0O1NKH2nP1+dKVNyMSiKyVKCW7WF0Qj9eqKsINBIbw4BhDglYMRyI7Jn3T6qZfSxMPrK50hXw1H2KE1ed4tzzd9rgSf4phKxMg7PlWtOhIdbvksbeJpyAYg8eM04EIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485831; c=relaxed/simple;
	bh=hMhLtfgNMQj1PEI+PV4Ney/g/RSDl8WEkYVehr2HcjE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=afulTFuaOzgJ+jD2G3zFt/wT7hh8lajTgsZbs3iVL15qlsVtsz1JlfJmxveNGD03RIwxfCCuCyrJ8xNq1J2Fny1gREadr/SXhCRvIaL52geCIRdakDEUcBDt73xTpC9u4maRXWrcs28TI5U7Tzfd2YPFGspk55ti7Ab3+7L2xsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83ae0af926dso207971139f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 01 Nov 2024 11:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730485828; x=1731090628;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mXZkMAHnpIXfyycrTbEtoEDDVDS3caYnPnMLznmCHUI=;
        b=PFFtdoLnyCJqNClu7m57f4TxOzQ9xc92q7TrXPdXVcIlz1Cr8iuCwxKampdpbj4aef
         TdHW7uaHphJR5pGgMZ3fE5eL/OcCkD0Hh96LuY+WunM8mLw3cRyvcstPgifer+1oLhw8
         zqyK0OH0dCBQ97IZ7YgSchHrNtt34YQXIGLQbj46LADNXcvDugcYMxfxRCEvguaY757K
         P/me9RsUpl6X45JikC0cciE1iWPeXiAozWLCTDWUmVDQ+9zkUEfmtXYibHg7FbHU4OZW
         1XpbnEzhmCUWkwdyRDDhwtTMUzYYdyNHNkx+ZiiDzT84JJ2wrJ0ACkrKd7VPyOOBrlIv
         13Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVCz9Y6NlCL+JJG+1qvsTNeGA1QVfWn7IfdBjn1mDQNWgZCJOGca6Xf09WJchKkZCMX85iDFfKIHjDfRsT0yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT4MLVTPVH6qfddjNFMPX4BeHZnZ7ET0u6KaQLoyR/K+AeWE5h
	ZzbWucpnNDPf9Ei2chElK5r/0GaFn0VDuo7Qb+CLQro4AQ8uQAATp/UBnrZ8sh7lsEHRBm2/SM1
	nTYwD8zfjAc97k3yx3+xCgpAcVJ07eGLKebgXrjRhnsOq+ByQQAPOeuk=
X-Google-Smtp-Source: AGHT+IGlAZCR29LvVl/Bw4EdczNIXrtznxNgJldWArN9m9083uz8e9DPAVy/TbSX9BDQoFAhwVP5AV9gNp/WtI+BnoO6vHuaSE8F
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20e6:b0:3a3:67b1:3080 with SMTP id
 e9e14a558f8ab-3a6b0251396mr50786425ab.7.1730485828656; Fri, 01 Nov 2024
 11:30:28 -0700 (PDT)
Date: Fri, 01 Nov 2024 11:30:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67251e44.050a0220.35b515.0174.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING: suspicious RCU usage in bucket_gen
From: syzbot <syzbot+39b80f215d9825867301@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c1e939a21eb1 Merge tag 'cgroup-for-6.12-rc5-fixes' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10054630580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aec7739e14231a7
dashboard link: https://syzkaller.appspot.com/bug?extid=39b80f215d9825867301
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c1e939a2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79a07b922222/vmlinux-c1e939a2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0a5d98e2bb0d/bzImage-c1e939a2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+39b80f215d9825867301@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.12.0-rc5-syzkaller-00044-gc1e939a21eb1 #0 Not tainted
-----------------------------
fs/bcachefs/buckets.h:94 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
4 locks held by kworker/u4:11/3443:
 #0: ffff88801ac79148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac79148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc9000e0ffd00 ((work_completion)(&rbio->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000e0ffd00 ((work_completion)(&rbio->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffff88804fa84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #2: ffff88804fa84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #2: ffff88804fa84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3215
 #3: ffff88804f35c128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 #3: ffff88804f35c128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9b0/0x1c00 fs/bcachefs/btree_iter.c:3112

stack backtrace:
CPU: 0 UID: 0 PID: 3443 Comm: kworker/u4:11 Not tainted 6.12.0-rc5-syzkaller-00044-gc1e939a21eb1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: events_unbound bch2_rbio_retry
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x226/0x340 kernel/locking/lockdep.c:6821
 bucket_gens fs/bcachefs/buckets.h:90 [inline]
 bucket_gen+0x200/0x220 fs/bcachefs/buckets.h:99
 read_from_stale_dirty_pointer+0x513/0xca0 fs/bcachefs/io_read.c:805
 __bch2_read_extent+0x994/0x4880 fs/bcachefs/io_read.c:896
 __bch2_read+0x1094/0x1f70 fs/bcachefs/io_read.c:1212
 bch2_rbio_retry+0x3bd/0x1340 fs/bcachefs/io_read.c:478
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
bcachefs (loop0): Attempting to read from stale dirty pointer:
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
  memory gen: 1
  u64s 13 type alloc_v4 0:34:0 len 0 ver 0: 
    gen 1 oldest_gen 0 data_type free
    journal_seq       0
    need_discard      0
    need_inc_gen      0
    dirty_sectors     0
    stripe_sectors    0
    cached_sectors    0
    stripe            0
    stripe_redundancy 0
    io_time[READ]     1
    io_time[WRITE]    1280
    fragmentation     0
    bp_start          8
  
bcachefs (loop0 inum 4099 offset 0): no device to read from: no_device_to_read_from
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
bcachefs (loop0 inum 4099 offset 0): read error 3 from btree lookup
bcachefs (loop0): Attempting to read from stale dirty pointer:
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
  memory gen: 1
  u64s 13 type alloc_v4 0:34:0 len 0 ver 0: 
    gen 1 oldest_gen 0 data_type free
    journal_seq       0
    need_discard      0
    need_inc_gen      0
    dirty_sectors     0
    stripe_sectors    0
    cached_sectors    0
    stripe            0
    stripe_redundancy 0
    io_time[READ]     1
    io_time[WRITE]    1280
    fragmentation     0
    bp_start          8
  
bcachefs (loop0 inum 4099 offset 0): no device to read from: no_device_to_read_from
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
bcachefs (loop0 inum 4099 offset 0): read error 3 from btree lookup
bcachefs (loop0): Attempting to read from stale dirty pointer:
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
  memory gen: 1
  u64s 13 type alloc_v4 0:34:0 len 0 ver 0: 
    gen 1 oldest_gen 0 data_type free
    journal_seq       0
    need_discard      0
    need_inc_gen      0
    dirty_sectors     0
    stripe_sectors    0
    cached_sectors    0
    stripe            0
    stripe_redundancy 0
    io_time[READ]     1
    io_time[WRITE]    1280
    fragmentation     0
    bp_start          8
  
bcachefs (loop0 inum 4099 offset 0): no device to read from: no_device_to_read_from
  u64s 7 type extent 4099:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum none 0:0  compress incompressible ptr: 0:34:0 gen 0 stale
bcachefs (loop0 inum 4099 offset 0): read error 3 from btree lookup


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
