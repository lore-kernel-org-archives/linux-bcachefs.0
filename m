Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048978468
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 21:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733003245; cv=none; b=cpd8GYZVF4WWlMXfhvUu0gp2Bnov7RTZwWC7TBwNKL127hvKdYfJGx1aiN36YLDDcEgDv32JLZSd3iUo2v+KrjJYnW2yyyDgT8izBP3MXmjVX1Q2TmIPZocgBgCnwFdmn1+Z69y1YOnMq0z2BkJyYrhEwYl2JM1E3y1DyyQRbqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733003245; c=relaxed/simple;
	bh=hKc9b04hPVo+87rE0xVTlOD7wiWplnvqLwmjF9I98Yc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=m2qGtUvMwi7nAkhdbUdqXC15SGZaPnIosDsQkl/mtRZ9mepzE56jli8jMiqZUDWD0uyfGSumLcVJLcI+qWHT6iw04z+hcMxZBxq0CAEq+t87zEXwKnM8tKcY+3lqRVRFXBsRcWXG0WoUjd0EvZ1zVhxEkZ1QaEwIzdimM45gea0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a76690f813so35307015ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 13:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733003243; x=1733608043;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F71PIKJd6PKs9DqFJZNi98eoObNp6K05Y2iv1os98h0=;
        b=oOaRhg9oO25OhiETmy+H7aPZHIu9pQy0b1lRaFh6bw49W3n5ACOEA8ZC0fQQ8+FH79
         nUkRc6m/uj43tzRY8k83L34ojn4et4gbE7tdkQ1c+cAITHQS91L1i9LQ1j0WiUqyzBpw
         2IAy8Gy8Y8tejBQdJRUnPJ/UI9DJp8tny8QXw/9TqhoN1F532WXO6w6+UlcQ8qpTh2JD
         XcIuDPinvEysqk8rpjXdA/LZfzKPs7BwDCdj4zu/niqv5rMSlfqJhQ5ojXOjQLvBdlSA
         giyBZuvLOyyo7uchIvYwbaT/Iof9mspqNR8APBqlhdKW5U1751E3bsQxA2R8IWA6pz25
         sxug==
X-Forwarded-Encrypted: i=1; AJvYcCVxhB+MISUNnPaHFqBSnOKUHPT+CqXPDwrwdh7411zbqIF7Pzp9FLsJrs/CppXFO67AinzuKK5V2mzwpFRlnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxxUaedvrI9RvuHAbRrVsO8jzzyT2inTmHcYrQ52r5RXFzXc1KI
	uV4fLAsxNElq+ZysHdRrMP9E2xBhVEzpcjSZH+yF/EDGu4gEi3LFkppqpA6RGucdXyqOjLlta99
	cwehnwxp1orW+1CJ861VInajgp6m4jA4pN+exKnL2SCo9XeZVNzn6Y3E=
X-Google-Smtp-Source: AGHT+IHr53xmZY2KkhEC/VV/nATgaH8sxpjbsLIj6R2RpPSa7UCI/Ad5XtS5m9YjG42Ul+fTp1udQ/kQl/HEKlAOCrWMVllxOTrs
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc3:b0:3a7:e8e1:cbc9 with SMTP id
 e9e14a558f8ab-3a7e8e1cc70mr14941645ab.22.1733003243263; Sat, 30 Nov 2024
 13:47:23 -0800 (PST)
Date: Sat, 30 Nov 2024 13:47:23 -0800
In-Reply-To: <6716e2ac.050a0220.1e4b4d.0064.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674b87eb.050a0220.253251.00e8.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING: locking bug in rcu_pending_exit
From: syzbot <syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2ba9f676d0a2 Merge tag 'drm-next-2024-11-29' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153a5f78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a857d0dac7fee57c
dashboard link: https://syzkaller.appspot.com/bug?extid=8d7226784b8fcb4c9d04
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1037f9e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155d1d30580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bdc15c061096/disk-2ba9f676.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d53677f61bd7/vmlinux-2ba9f676.xz
kernel image: https://storage.googleapis.com/syzbot-assets/792a9fd72bea/bzImage-2ba9f676.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/43642e934dbd/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d7226784b8fcb4c9d04@syzkaller.appspotmail.com

bcachefs (da441363-bb6a-4ab9-999b-c1f40db4fee2): shutdown complete
------------[ cut here ]------------
Looking for class "->lock" with key rcu_pending_init.__key, but found a different class "&p->lock" with the same key
WARNING: CPU: 0 PID: 6892 at kernel/locking/lockdep.c:939 look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 0 UID: 0 PID: 6892 Comm: syz-executor223 Not tainted 6.12.0-syzkaller-11677-g2ba9f676d0a2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Code: 01 0f 85 8a 00 00 00 c6 05 93 f3 45 04 01 90 49 8b 16 49 8b 76 18 48 8b 8b b8 00 00 00 48 c7 c7 e0 fa 0a 8c e8 e5 d5 95 f5 90 <0f> 0b 90 90 eb 61 90 e8 58 d9 f3 f8 e8 23 32 b5 f5 48 c7 c7 20 fa
RSP: 0018:ffffc900036e6e10 EFLAGS: 00010046
RAX: d8228172b281a900 RBX: ffffffff93c9d788 RCX: ffff88801ef19e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900036e6f20 R08: ffffffff81568b22 R09: 1ffff920006dcd5c
R10: dffffc0000000000 R11: fffff520006dcd5d R12: ffffe8ffffc3e020
R13: ffffe8ffffc3e020 R14: ffffe8ffffc3e020 R15: ffffffff9a5739a0
FS:  00007f1d4027b6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1d4027c000 CR3: 0000000024eaa000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
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
RIP: 0033:0x7f1d40ad40aa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1d4027b088 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f1d4027b0a0 RCX: 00007f1d40ad40aa
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007f1d4027b0a0
RBP: 0000000000000004 R08: 00007f1d4027b0e0 R09: 00000000000058ae
R10: 0000000000010000 R11: 0000000000000282 R12: 00007f1d4027b0e0
R13: 0000000000010000 R14: 0000000000000003 R15: 0000000001000000
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
