Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC75526A1B0
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739892742; cv=none; b=h7UC9xKJkhZCqh4CUUaEhruTvyKovNe87Xl93WSQxjNzvhSy4a6J1Z4HmI38CLHX3R1ZtD/D+H6/nlFcOrvZsqijVKjCtZSLnrfaoDJiyyHakvTjOsxJKjtYufy8GVJYCbburF5MckIjiNWdtozpDfnQbsDFTRQIdvGLPQmSNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739892742; c=relaxed/simple;
	bh=QpL/AtEu0RLHanD5578BLOiZ1DfT9IbMpp5qQyl6uFk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WSgOhm2a1lRSaweACRyM0bQmvHwsLXqxGX89k2sRO+brBj1NFxoSboEgZ25PyfpnRHjMURX2IUytn+oLA0L+13KfwwJeIc9LXlWdpvcQMjeCi0B+gDkE8xtemtEAJi4ULJFvq6vzLX4XfatS2rBh6B/Ldva1GwsQudDQfgg9r9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d2abf82a21so14427965ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 07:32:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739892740; x=1740497540;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U38C3lDKwbTK17gc2HRI9P8P3TtJlwig/T9P9hd3NCE=;
        b=edMVOebkg5sRHOaUmxAdOWDz0Sa2XH8QXUlAAWl/Apep+4yG7+TB36euLgp11XMBwe
         2jK9sfHTZiaAoXg4iRlKryqwA4GOGO7ris/ZYrWzPvkYMo59twwdgkcVoWru4+mOWc82
         yGHSK5yNmdt6l0ScLM9unpyHmkErHRk2BwHXL9OrwQwYhRNY7Dhdi65SMguzJaWzLrG1
         CITJvgn/5Z1Lu9UxZ0sEHmT+MNoPInB1uZ87MKk1Z+c27Elpk8HHzpWLxI21hkAOCL1Q
         DRF/cq90aM1YZ8q1yXzrGxTRhk1f26dBHl4YwovKM7ifzcd00cXx6hQkyQ5iB0uKZsZo
         z2Og==
X-Forwarded-Encrypted: i=1; AJvYcCW6RjRA5+Hzojx8rxvVA/wtK1cvgreJZih2SvHjVNPt1pO2eNbkn96EwSZG/9xS/JQuDBokQU8JGI9e1oPCow==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGb7R/QGoaBHx77/LSF11sP/Y72oEchZ3nJHUJb2uXN5RNFxhp
	awqY6V+LjParj8IZZOSLOuBAl8XEnp/Pe/qjKs0zhSS1TQMQnNMWP3YZg2o0RVP7wzvIlqBEqgo
	r+mnyDyIxGMHy2q6dE+iPjN4rfa6Ig1rSYa2YMrmWatMLZEW4qsx9JxA=
X-Google-Smtp-Source: AGHT+IF6n3nUbG7dttcbsl4kRv/GKA8Le7LRdxhlOoo5EIBnOZIj5ufi/JRfI9HsLVyb5scZtoNdR+oUDTC3Rh7Q/9K1eh5LFIjv
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1384:b0:3d0:17d2:a03e with SMTP id
 e9e14a558f8ab-3d2809d97dcmr137102065ab.21.1739892739946; Tue, 18 Feb 2025
 07:32:19 -0800 (PST)
Date: Tue, 18 Feb 2025 07:32:19 -0800
In-Reply-To: <67b44ef3.050a0220.173698.004c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b4a803.050a0220.173698.0066.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] WARNING: locking bug in simple_recursive_removal
From: syzbot <syzbot+727c886b67040701c448@syzkaller.appspotmail.com>
To: dakr@kernel.org, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    2408a807bfc3 Merge tag 'vfs-6.14-rc4.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154fb7df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cc40dfe827ffb85
dashboard link: https://syzkaller.appspot.com/bug?extid=727c886b67040701c448
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17982498580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3bbfce004a48/disk-2408a807.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0151460c5539/vmlinux-2408a807.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8dfe7f8b2862/bzImage-2408a807.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2e6491f4c19e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+727c886b67040701c448@syzkaller.appspotmail.com

bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): done starting filesystem
bcachefs (loop0): missing subvolume 1
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop0): bch2_fs_get_tree(): error mounting: error getting root inode ENOENT_bkey_type_mismatch
bcachefs (loop0): shutting down
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 6056 at kernel/locking/lockdep.c:234 hlock_class kernel/locking/lockdep.c:234 [inline]
WARNING: CPU: 1 PID: 6056 at kernel/locking/lockdep.c:234 check_wait_context kernel/locking/lockdep.c:4852 [inline]
WARNING: CPU: 1 PID: 6056 at kernel/locking/lockdep.c:234 __lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5178
Modules linked in:
CPU: 1 UID: 0 PID: 6056 Comm: syz.0.18 Not tainted 6.14.0-rc3-syzkaller-00012-g2408a807bfc3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4852 [inline]
RIP: 0010:__lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5178
Code: 00 00 83 3d 81 37 9f 0e 00 75 23 90 48 c7 c7 e0 a2 2a 8c 48 c7 c6 e0 a5 2a 8c e8 07 c2 e4 ff 48 ba 00 00 00 00 00 fc ff df 90 <0f> 0b 90 90 90 31 db 48 81 c3 c4 00 00 00 48 89 d8 48 c1 e8 03 0f
RSP: 0018:ffffc90003337530 EFLAGS: 00010046
RAX: 8841e1c411249300 RBX: 0000000000001826 RCX: ffff8880278ebc00
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000041826 R08: ffffffff81817d42 R09: 1ffff110170e519a
R10: dffffc0000000000 R11: ffffed10170e519b R12: ffff8880278ec6d4
R13: 0000000000000005 R14: 1ffff11004f1d8e7 R15: ffff8880278ec738
FS:  00007efc242d26c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055efac1c6518 CR3: 000000006cff8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:877 [inline]
 simple_recursive_removal+0x9a/0x8f0 fs/libfs.c:615
 debugfs_remove+0x49/0x70 fs/debugfs/inode.c:805
 __bch2_fs_stop+0x290/0x5c0 fs/bcachefs/super.c:643
 bch2_fs_get_tree+0xd3a/0x17a0 fs/bcachefs/fs.c:2303
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efc2338e58a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efc242d1e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007efc242d1ef0 RCX: 00007efc2338e58a
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007efc242d1eb0
RBP: 00004000000058c0 R08: 00007efc242d1ef0 R09: 0000000000010000
R10: 0000000000010000 R11: 0000000000000246 R12: 0000400000005900
R13: 00007efc242d1eb0 R14: 0000000000005912 R15: 00004000000001c0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
