Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A44716F8EF
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 03:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718075675; cv=none; b=jd1IYXt550WRPhw0KaXf2uwzeq0keVDja9lBtnkwKbf2S8xcT137jkQjvtiy1YWEN2Vv02KL97jY1yeKklUaND6M9DM/np+p2+KPP1b+ls2DTuZ6zbOM1D0YyHMJDxizczxJJ7Rx/qNdgK9pJAiKgGPoZvDmKIbohwY46V8ps/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718075675; c=relaxed/simple;
	bh=VGRnZZqPDyW2EDepRD1odJM+RoQ+7Jsw78lL3gHC/zo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tC1LpiWwZIdM/4gkKJdD5h615qm0PaHqVlly74ov+CWE+wLGPWNnhNQNCnyzhZfqKFx16Ond1SeweYDJkiKDi50hWfw1o69c/bpcvnl1CGGEWtiv6sEW2zNj+oteRC+2jnWk2CibDta8wc48r7WNjRDJ5AID/0+zxZzUO2mJYq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-37596e877e9so33376075ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 20:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718075673; x=1718680473;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RYjYM0JZ0ej8f0kLyK0sQ6PA3/U/McvM0TTZxMmiXk4=;
        b=iF+PNPz5aF902VLFOjkUwBklSkooIDZnR4GVH+B6CmVdaKiB5kltrTXyl4i7VWS+4b
         FrBizLleleiB21L8bfqQawmT30jM3TS6/rvym3WiRgHS0w0LoTOnnhRhKclKghdnI3DY
         TEIN3UDNy0EJ3lkepoHd9YIUCl1dnWHzCKO3gnNsvgWebXSbbESuoljVwqT9dXqnndsq
         CsfVEADehihUyhIrHEz4I0aNvQ8m7aWc7oNQ3whVO++bJY/w/p1R61PU6NKvBgI3TeCo
         484Nb9s6fUCCKg1lu/j+RnsU2vPIHUfP7KFVRsPHAMK46iyRZ70ZBZLUPQdeQaChBdT9
         wY2A==
X-Forwarded-Encrypted: i=1; AJvYcCWYXETsBPQhtrK98QrY7F9/bqmyzDVYTo9tk1GUHgRg5dSMHjSuOfuDBZ3AyBr9EeE4XALesMQ6nv+5dZdnYl9TrpXRxpdqQOpZH8QAC78=
X-Gm-Message-State: AOJu0YwZNMNSLxUmT6tig5ClyV441bG+mlQOSpgbmxilKYVhKnX7gIk9
	EtbbAJUDPgNWFBnHBlPvD2F1Ij0wqwymYDbLiybpJUmebppsE8j4YHK5Q96bz8r7Vtged3X68Qd
	DmswAHSjEQqf6YzK+HidIbb6MGpp+wxxPdbp96QGaE2gnUIPDVXgxpoI=
X-Google-Smtp-Source: AGHT+IEonuQUowvVkuEO3w3h8q+NQle6+AkFlAwEjvvZw6VWdy7uSziqlEpHDap3A3atlKtlb17+Vwb47WW/jlmZEHciCR40kQEl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa8:b0:375:9cb9:9d04 with SMTP id
 e9e14a558f8ab-3759cb9a138mr4678895ab.3.1718075672693; Mon, 10 Jun 2024
 20:14:32 -0700 (PDT)
Date: Mon, 10 Jun 2024 20:14:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b1e82061a94aaef@google.com>
Subject: [syzbot] [bcachefs?] WARNING: locking bug in srcu_gp_start_if_needed
From: syzbot <syzbot+3cca837c2183f8f6fcaf@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d30d0e49da71 Merge tag 'net-6.10-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f5d896980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96fd46a1ee1615e0
dashboard link: https://syzkaller.appspot.com/bug?extid=3cca837c2183f8f6fcaf
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-d30d0e49.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/970e3906a552/vmlinux-d30d0e49.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d80af4a76ff6/bzImage-d30d0e49.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3cca837c2183f8f6fcaf@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 111 at kernel/locking/lockdep.c:232 hlock_class kernel/locking/lockdep.c:232 [inline]
WARNING: CPU: 1 PID: 111 at kernel/locking/lockdep.c:232 hlock_class+0xfa/0x130 kernel/locking/lockdep.c:221
Modules linked in:
CPU: 1 PID: 111 Comm: kswapd0 Not tainted 6.10.0-rc2-syzkaller-00222-gd30d0e49da71 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:hlock_class kernel/locking/lockdep.c:232 [inline]
RIP: 0010:hlock_class+0xfa/0x130 kernel/locking/lockdep.c:221
Code: b6 14 11 38 d0 7c 04 84 d2 75 43 8b 05 b3 2e 77 0e 85 c0 75 19 90 48 c7 c6 80 be 2c 8b 48 c7 c7 20 b9 2c 8b e8 97 47 e5 ff 90 <0f> 0b 90 90 90 31 c0 eb 9e e8 98 f6 7f 00 e9 1c ff ff ff 48 c7 c7
RSP: 0018:ffffc90000e9f338 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 00000000000018c4 RCX: ffffffff81511229
RDX: ffff888019f8a440 RSI: ffffffff81511236 RDI: 0000000000000001
RBP: 0000000000008000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 000000002d2d2d2d R12: 0000000000000000
R13: 0000000000000000 R14: ffff888019f8afe8 R15: 00000000000018c4
FS:  0000000000000000(0000) GS:ffff88802c100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000eeb14000 CR3: 0000000046f74000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 check_wait_context kernel/locking/lockdep.c:4773 [inline]
 __lock_acquire+0x3f2/0x3b30 kernel/locking/lockdep.c:5087
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __raw_spin_trylock include/linux/spinlock_api_smp.h:90 [inline]
 _raw_spin_trylock+0x63/0x80 kernel/locking/spinlock.c:138
 spin_lock_irqsave_sdp_contention kernel/rcu/srcutree.c:373 [inline]
 srcu_gp_start_if_needed+0x75e/0xf00 kernel/rcu/srcutree.c:1233
 bkey_cached_free fs/bcachefs/btree_key_cache.c:90 [inline]
 bch2_btree_key_cache_scan+0xb90/0x1820 fs/bcachefs/btree_key_cache.c:886
 do_shrink_slab+0x44f/0x11c0 mm/shrinker.c:435
 shrink_slab+0x18a/0x1310 mm/shrinker.c:662
 shrink_one+0x493/0x7c0 mm/vmscan.c:4790
 shrink_many mm/vmscan.c:4851 [inline]
 lru_gen_shrink_node+0x89f/0x1750 mm/vmscan.c:4951
 shrink_node mm/vmscan.c:5910 [inline]
 kswapd_shrink_node mm/vmscan.c:6720 [inline]
 balance_pgdat+0x1105/0x1970 mm/vmscan.c:6911
 kswapd+0x5ea/0xbf0 mm/vmscan.c:7180
 kthread+0x2c1/0x3a0 kernel/kthread.c:389
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
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
