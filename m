Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D984B1A3035
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 12:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731673766; cv=none; b=OJvLtmsOr7WFBqKGUTfbwkrGTgXLfOfe6cfcqjNij2dYgtAYP9ntwpS7X9aE0AFkgnVC6lTfjeoLVv+/Mgn+TVr8eLPEsjHdfpiDwoQLpERA5S/qnXNPeY5bVIsJ5eus0lnSooXyV32HnUHScDr6Mcd+8UvOjZ8grhgq40Rn9uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731673766; c=relaxed/simple;
	bh=NHWC6Ve82wlWY9YJNTS4xN8tJlqZPM855tSImF2HueU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Li/NyeCl0pORW5B6O2UsZHE/2HMTJld8qXrY/NhvLdS4zMFeiyllZrtNTgUkPdo1foJYngnGwuzwLCtTSs7TF4qoTPTkGymFDC4b06MiOCMPkGu/vWQqGYI+q1Q3uegTQ6Exow97hkKzRp+skCA2efhLYTpyxA7NxecsJHoVl5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so21359585ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 04:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731673764; x=1732278564;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A0dpNKRxwoLls+j4kum3KUu9yYY5rELajDHXG4WCsHU=;
        b=I9kJ9dq6qvwwPIHAWRRVIeEDtAVGvsX1XJNSLhpslCdDhw10v3NbY12QR0JDU/u09a
         rcWexRNtmxWquRPS+S2+Z4BZJrbShoI1EbdDjt2HbOB4DcMaXvmlO3mv5YDLtOLYG4xB
         VcQLyA2dB4lX11iLCDMBsktzQWWfJWoK7WA42fTzbCRBqpswRfVF175R8LC+cor+tmrj
         zmDUWLt/hCaajgB1n5AzEe+LaoyF0U9LeSCDtO8Q3qnuduR4n8ikrJ1W0ZeiRn5OgkOy
         nC4nB3zr5CK5dXQL8rsW5JOY520EUC6DqkgfavSIub/okY2w4GDT6tZgHgag6RdB/qz8
         sgZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX40J7CgkuMsq15kU1AiUcJZPZ7TF8lRBZ6rvVeNoqucVpXBcMXZHD+wr0KAfXeSlv2JlhUEEMAq+4BfY92sw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxnaudjCiWWHCwQN/WMINGAbAW06qisGkP7isFg+Bhv+ytzfojg
	/xjXLl/hAwkn51KYbcqHbxy0qQ8ziHUZhXA1bhoehny01oVYr5GgXRp1TKQVLuU3LhSlW0jf8NY
	hHT8CuhXC2ZoFuMCGY0SJ/w8VDeHbTDIXROm+Pes763Kbt0/tG/3e3dE=
X-Google-Smtp-Source: AGHT+IHMYT/WmM5CU8Z8NS4U0VLiygFqh7sbivZJ+S/zXXjQ9IQFYOpBnexIPeXK9nbJECM360/fusOGt0GO/YFWk6MUL+Iml/+f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1c:b0:3a7:2b12:78dd with SMTP id
 e9e14a558f8ab-3a7480234f3mr22222805ab.11.1731673763964; Fri, 15 Nov 2024
 04:29:23 -0800 (PST)
Date: Fri, 15 Nov 2024 04:29:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67373ea3.050a0220.1324f8.00ad.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING: locking bug in rcu_pending_enqueue
From: syzbot <syzbot+b63566ef71c0f462e815@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    563047e691f2 Merge remote-tracking branch 'tip/irq/core' i..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10513ea7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d1ed5ebe7f28fe9
dashboard link: https://syzkaller.appspot.com/bug?extid=b63566ef71c0f462e815
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/09130b543284/disk-563047e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/76ce58c74487/vmlinux-563047e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e39916627eee/Image-563047e6.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b63566ef71c0f462e815@syzkaller.appspotmail.com

------------[ cut here ]------------
Looking for class "p->lock" with key rcu_pending_init.__key, but found a different class "&p->lock" with the same key
WARNING: CPU: 0 PID: 44 at kernel/locking/lockdep.c:939 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 0 UID: 0 PID: 44 Comm: kworker/u8:3 Not tainted 6.12.0-rc6-syzkaller-g563047e691f2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_update btree_interior_update_work
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
lr : look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
sp : ffff800097fe6fa0
x29: ffff800097fe6fa0 x28: dfff800000000000 x27: 0000000000000000
x26: ffff8000973358c0 x25: ffff800097335000 x24: 0000000000000001
x23: 0000000000000000 x22: 1ffff00011f020ba x21: ffff8000974dc7a0
x20: fffffdffbf6f0340 x19: ffff800092e82b80 x18: 0000000000000008
x17: 747562202c79656b x16: ffff8000830cb670 x15: 0000000000000001
x14: 1fffe000366c6ce2 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000003 x10: 0000000000ff0100 x9 : 2e0fef016daf9f00
x8 : 2e0fef016daf9f00 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff800097fe66d8 x4 : ffff80008f8fd0c0 x3 : ffff80008062728c
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 0000000000000000
Call trace:
 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936 (P)
 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936 (L)
 register_lock_class+0x8c/0x6b4 kernel/locking/lockdep.c:1290
 __lock_acquire+0x18c/0x77c8 kernel/locking/lockdep.c:5077
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x48/0x60 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:418 [inline]
 rcu_pending_enqueue+0x164/0x898 fs/bcachefs/rcu_pending.c:515
 bkey_cached_free+0xb8/0x214 fs/bcachefs/btree_key_cache.c:115
 bch2_btree_key_cache_drop+0x104/0x210 fs/bcachefs/btree_key_cache.c:586
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:824 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:900 [inline]
 __bch2_trans_commit+0x4d64/0x6604 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:728 [inline]
 btree_interior_update_work+0xd40/0x1e00 fs/bcachefs/btree_update_interior.c:866
 process_one_work+0x7bc/0x1600 kernel/workqueue.c:3229
 process_scheduled_works kernel/workqueue.c:3310 [inline]
 worker_thread+0x97c/0xeec kernel/workqueue.c:3391
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
irq event stamp: 938478
hardirqs last  enabled at (938477): [<ffff800080ac7d3c>] kasan_quarantine_put+0x1a0/0x1c8 mm/kasan/quarantine.c:234
hardirqs last disabled at (938478): [<ffff800082a539e8>] __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:416 [inline]
hardirqs last disabled at (938478): [<ffff800082a539e8>] rcu_pending_enqueue+0xe4/0x898 fs/bcachefs/rcu_pending.c:515
softirqs last  enabled at (938018): [<ffff8000866510a8>] spin_unlock_bh include/linux/spinlock.h:396 [inline]
softirqs last  enabled at (938018): [<ffff8000866510a8>] nsim_dev_trap_report drivers/net/netdevsim/dev.c:820 [inline]
softirqs last  enabled at (938018): [<ffff8000866510a8>] nsim_dev_trap_report_work+0x620/0x938 drivers/net/netdevsim/dev.c:851
softirqs last disabled at (938016): [<ffff800086651024>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (938016): [<ffff800086651024>] nsim_dev_trap_report drivers/net/netdevsim/dev.c:816 [inline]
softirqs last disabled at (938016): [<ffff800086651024>] nsim_dev_trap_report_work+0x59c/0x938 drivers/net/netdevsim/dev.c:851
---[ end trace 0000000000000000 ]---


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
