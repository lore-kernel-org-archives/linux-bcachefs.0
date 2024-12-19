Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1675221D87
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602005; cv=none; b=MWSPUfZkg8x3Tb89u+0CcQiVyZatjQkQj3lgqYSCl211BZQ5ZQNmDm01HJE/QFYuR4fb8dFeYDUBatuCsHZEPjN/GgQa1H/wprUbE/kgGzITBsk06ovmGXhfq81kSfun3fVu7uGDkGAiT7ja/wIKaLSTjW8n5cefpf7JBduydI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602005; c=relaxed/simple;
	bh=5ZiZgXMBiNzsncE/p/WC3F+rL3uwyYm0mwD3Xp67Gsk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=gWF/96DoRMl2jmgSojqHz/FbQrgDdKJAOa3vEiSQb3sk3yiMrF0lxtP7tYjcKXrkdtpTVheLfPZdydqmABD4NJ1bEY21dxQEgFIG+dAVW5xmmwolrTM2CKe4H0lWyWoOw0sFDBW481U5F3Nc+Tfdt3PekYQYQxLac4yrsGjLCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a817e4aa67so4880665ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 01:53:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734602003; x=1735206803;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kcZwEdsZiieinVS8tQb3zhVuCaVYZX0yTDsXLOOTRko=;
        b=dbSiOKq/HnRFMN6rnm09qZqoX43JfgNar0YN+IwGPqEoM7brpxZrb6Clvb9UniSWj0
         AqO6IOLglCNpHIqcqvCC2v61dFT3dbmgfyK6jSgLI3PUtFy62vu9WQ4zg+wUGpSl8eZm
         T/gtUUdCvdhkyj8hMKlczeIDMrVK7HVJLo5P3ZqkJ5c/LAJaDao1Mx5mUX+auQwVmcQx
         e9zKY4dJX9dFB9Jb3mZnn3c+/rhdD3k8NxWoS6r/2Jt9Gcv1rHsM1NyhTv5Oft8STXwZ
         hwLtz0kBymiIkLaQXSofW5i1fl8/XBQa7OkyHpJNxNYlO0o3fwvvjcPyQzUbHnzmFwoR
         h0BA==
X-Forwarded-Encrypted: i=1; AJvYcCW2wP6IFmdnL+Hb+tZFQvn6DINX4U0xeP0CbXMxnjASSVQknsOaX/Tg1kDKy1pEp/XevyVxKZ/FzSMmCuXUyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxY/zWYmXWZj8cFCveFK/l0B2Y+2/O0sJgv27MKX8BO4GljrOVE
	NE2LsIVDrKNOGD4pFQ/Tc9PYoW8cEreHQ5xd3PKqd//et0FECwMrst8asFgwWj6NMA5pmY9H8Ez
	rwbgjLKNPkAjNKjQ+ic4U/Ny+j8dSlsadGX7oxgrcKCZBwfm6ViP/LPQ=
X-Google-Smtp-Source: AGHT+IHDUXzlrh88BcYJ6S0wAt4s1ey/GNNSpQhCKLz5NQ+Il8XQ4QcY5JzgAiTmwEfeBqPxj8syuskMmOjmbotlsDjWTkpyXoBQ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f03:b0:3a7:e732:4713 with SMTP id
 e9e14a558f8ab-3bdc428219emr60389395ab.15.1734602002872; Thu, 19 Dec 2024
 01:53:22 -0800 (PST)
Date: Thu, 19 Dec 2024 01:53:22 -0800
In-Reply-To: <6744873b.050a0220.1286eb.0000.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6763ed12.050a0220.3157ee.0014.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_exit
From: syzbot <syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170e77e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=e733ab672a1b6724c27f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12834cf8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a4dff87674a/disk-eabcdba3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/266bc2b7ced3/vmlinux-eabcdba3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee4bcd9be832/bzImage-eabcdba3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7bfbea1d3e96/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com

------------[ cut here ]------------
==================================================================
BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:646 [inline]
BUG: KASAN: global-out-of-bounds in string+0x218/0x2b0 lib/vsprintf.c:728
Read of size 1 at addr ffffffff8c53984a by task syz.0.174/7554

CPU: 1 UID: 0 PID: 7554 Comm: syz.0.174 Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 string_nocheck lib/vsprintf.c:646 [inline]
 string+0x218/0x2b0 lib/vsprintf.c:728
 vsnprintf+0x1101/0x1da0 lib/vsprintf.c:2848
 vprintk_store+0x485/0x1240 kernel/printk/printk.c:2279
 vprintk_emit+0x271/0xa10 kernel/printk/printk.c:2408
 __warn_printk+0x263/0x360 kernel/panic.c:797
 look_up_lock_class+0xdb/0x170 kernel/locking/lockdep.c:936
 register_lock_class+0x102/0x980 kernel/locking/lockdep.c:1290
 __lock_acquire+0xf3/0x2100 kernel/locking/lockdep.c:5101
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xd3/0x120 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_has_pending_or_armed fs/bcachefs/rcu_pending.c:576 [inline]
 rcu_pending_exit+0x13f/0x7a0 fs/bcachefs/rcu_pending.c:594
 bch2_fs_btree_key_cache_exit+0x97f/0xab0 fs/bcachefs/btree_key_cache.c:741
 __bch2_fs_free fs/bcachefs/super.c:556 [inline]
 bch2_fs_release+0x206/0x7d0 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_alloc fs/bcachefs/super.c:960 [inline]
 bch2_fs_open+0x1ebe/0x2f80 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2157
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb98f7874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb99051be68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fb99051bef0 RCX: 00007fb98f7874ca
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 00007fb99051beb0
RBP: 00000000200000c0 R08: 00007fb99051bef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000000020000000
R13: 00007fb99051beb0 R14: 0000000000005938 R15: 0000000020005b00
 </TASK>

The buggy address belongs to the variable:
 .str+0xa/0x20

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xc539
flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000002000 ffffea0000314e48 ffffea0000314e48 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffffffff8c539700: 02 f9 f9 f9 00 00 06 f9 f9 f9 f9 f9 00 00 03 f9
 ffffffff8c539780: f9 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 00
>ffffffff8c539800: 00 00 00 00 00 00 00 00 00 01 f9 f9 00 00 00 04
                                              ^
 ffffffff8c539880: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff8c539900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
