Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF601FDA7B
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740075684; cv=none; b=Z1o6vC4bjN3njhifeYvw6Q1gl21LGRljAyCxV6GjEyOIX18ULTx+2eHSmTFYz6cDmd81abGmPTwecigDgkDN/68OOZwZ4X1DfKEju0HLpxJWRfadKSk2w5ZXvvDX4CRVV5L8aW634ygDMwBmEWKwTg6mglZHYSIcbI2xXQAMt3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740075684; c=relaxed/simple;
	bh=45y/imlWG8q2VcYF2DLQUplcU04j+EE270Hfxi8gPmQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=vCvkRYPSdvrLB0vnHysvbUjPtNZK6nUSXBBVjuKfKiouGYn7/FkA89hluKJyBHkR/2Mlb2YjavCLmD9rEH71Tr7y7Z9BYBor59h/Yeg6H0WhiyUsBauQoqoq42JinwEqnapJwivqB3MPw90ENHUNRVga2SDgPPLXL58f0SUIrMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d289bf6c39so17746115ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Feb 2025 10:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740075681; x=1740680481;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+vS9a0JAby6AAWXnoFQKgnxA4tCQW6gHUk2YdFJ7pM=;
        b=VLi7a3KXdDV6maQe4YR6aFWP7nb21oM+v+/qeaDtpHm5aZ+aZ8x32o3lwgkj8iBiBJ
         jcenAhhfs4+SdtnOtC1uUJKr7qdhBYJ+0q5/n5KRTrPDIlze/5CdkIALWoJX02NoqSAq
         W0nZ4e8HLFgclBrcGdSkTLe88xiAj9HYsZVjoTHfviOiSwNrkxkfNq4p7KOLO1sLl90S
         ICdxp91G7dQ8VIcPSH34PV1kZZBeyXKzyc4qMLlX6RvQFcywnmpadHV0/PyEUX3euynk
         Da4Hq2vOYQgI1MstyvIoONQItpSiNOkmUMwADXiFY2Adh6vcr7JznaGbpPQHmFI2e4Re
         6eCA==
X-Forwarded-Encrypted: i=1; AJvYcCUXtq9XD4CddZWCEIsCARtf3ptINEPnW8/Ve+UTcc9XDN2gd+VO5grmpBITD5RNkQzBXuVOd8vXZIjvmYnGPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxkqnr8BFcPTJNL7NxbI0tmTVBBqYXeVKnpjvCT81o+jhyawWMl
	ysyXGQaEvWgDbK2Ed6X31rriue9ppZz7K/71O4vlABkOeK2YIsUTj5D9C8GvrXniG7/KghiW7gL
	vXVr3oTxPEDAm6KAuQ3g+SrbnaTS4Iv0HY+QP9oNnGXyNsfrhLleo1q8=
X-Google-Smtp-Source: AGHT+IE0AcxIwkwv79ImBfEVfZxcJL/5DX1ileuUoT8df+BEJZXct1UrKwMkCtsWztGNecDDJWnfOP1zg4WCCHSVzVeQo9dA6MKu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3286:b0:3d1:5f67:f0e6 with SMTP id
 e9e14a558f8ab-3d2cac94fb3mr2029115ab.1.1740075681745; Thu, 20 Feb 2025
 10:21:21 -0800 (PST)
Date: Thu, 20 Feb 2025 10:21:21 -0800
In-Reply-To: <6744873b.050a0220.1286eb.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b772a1.050a0220.14d86d.02f3.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_exit
From: syzbot <syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    87a132e73910 Merge tag 'mm-hotfixes-stable-2025-02-19-17-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175775b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7bde34acd8f53b1
dashboard link: https://syzkaller.appspot.com/bug?extid=e733ab672a1b6724c27f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d8aba4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e1dae4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4a88f50cb21d/disk-87a132e7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d970e0210e8a/vmlinux-87a132e7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9b6329058ef7/bzImage-87a132e7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f06af6381842/mount_0.gz

The issue was bisected to:

commit d97de0d017cde0d442c3d144b4f969f43064cc0f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Aug 13 01:31:25 2024 +0000

    bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13432ef8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10c32ef8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=17432ef8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")

------------[ cut here ]------------
==================================================================
BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:632 [inline]
BUG: KASAN: global-out-of-bounds in string+0x229/0x2b0 lib/vsprintf.c:714
Read of size 1 at addr ffffffff8c74c10a by task syz-executor504/5826

CPU: 1 UID: 0 PID: 5826 Comm: syz-executor504 Not tainted 6.14.0-rc3-syzkaller-00079-g87a132e73910 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 string_nocheck lib/vsprintf.c:632 [inline]
 string+0x229/0x2b0 lib/vsprintf.c:714
 vsnprintf+0x8b4/0x1220 lib/vsprintf.c:2843
 vprintk_store+0x482/0x1240 kernel/printk/printk.c:2279
 vprintk_emit+0x271/0xa10 kernel/printk/printk.c:2408
 __warn_printk+0x263/0x360 kernel/panic.c:797
 look_up_lock_class+0xdb/0x170 kernel/locking/lockdep.c:938
 register_lock_class+0x102/0x980 kernel/locking/lockdep.c:1292
 __lock_acquire+0xf3/0x2100 kernel/locking/lockdep.c:5103
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xd3/0x120 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_has_pending_or_armed fs/bcachefs/rcu_pending.c:592 [inline]
 rcu_pending_exit+0x13f/0x7a0 fs/bcachefs/rcu_pending.c:610
 bch2_fs_btree_key_cache_exit+0x8d1/0x9f0 fs/bcachefs/btree_key_cache.c:778
 __bch2_fs_free fs/bcachefs/super.c:569 [inline]
 bch2_fs_release+0x206/0x7b0 fs/bcachefs/super.c:624
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x231/0x480 lib/kobject.c:737
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
 task_work_run+0x251/0x310 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7e807c2577
Code: 07 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffeee02cd28 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f7e807c2577
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffeee02cde0
RBP: 00007ffeee02cde0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000206 R12: 00007ffeee02de50
R13: 000055557adeb6c0 R14: 431bde82d7b634db R15: 00007ffeee02de70
 </TASK>

The buggy address belongs to the variable:
 .str+0xa/0x20

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xc74c
flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000002000 ffffea000031d308 ffffea000031d308 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffffffff8c74c000: 00 05 f9 f9 02 f9 f9 f9 06 f9 f9 f9 00 00 00 00
 ffffffff8c74c080: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
>ffffffff8c74c100: 00 01 f9 f9 00 00 00 04 f9 f9 f9 f9 00 00 00 00
                      ^
 ffffffff8c74c180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff8c74c200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
