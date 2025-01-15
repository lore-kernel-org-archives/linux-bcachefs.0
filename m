Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7181E7C22
	for <linux-bcachefs@vger.kernel.org>; Wed, 15 Jan 2025 10:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736935582; cv=none; b=HC5okEpQxpsQ9+H7sjwsgcz9N4VbnWRDrfM0GXQOofeRaDXspmBIU9L964Ue0HmmvYaVjsVfkeoII1FtBwo+XDF3qS6eWOF4NiV82an3bD2N+lYFtY9JPFkkPr/35yP106tqys7dp72WpXsUTKEBe7MZb/okrRVw8Fyxz0K57og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736935582; c=relaxed/simple;
	bh=NrU2S3EcKpmEbnVMr2/kljaHJO/552ysN9eH/kHfkWE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=i2wAnTnv36bL/beh4bi77o7ovHzJO0wzuO53oWFB9wRv6UTnena6b3vcqtnG8gp+RuTrOLTs9G8/Ghju4M+NppK3ozumpHnWs4LbrqYUHoP3RUN36m2gHOB2cOMf02VEFLgoDZtenzE+a5Jep2xL/xzwjwrAw1arWT9+boDBIDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-844cffcb685so488619739f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 15 Jan 2025 02:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736935580; x=1737540380;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJtFmGRXJxzFA0o56+bUXI9TFlTaUh21BBY8FEEe1UY=;
        b=iSa0YrKkTE/k2G+gjeV5qnrrCwAgCFnZU0VwYSp6K4vCKM/BlZYGuDgKsHwEGJyhHW
         pql0iN1X+j7KbsZyMSyX1mB8Mj5sk1ZrK42CZSqrX42C+TXd0Lz97IQ2D/U/581lONoC
         t4XDKLSCmsxJRce78v23s/TiLhUF+vcVLU3HiWwyRY3yAOkS/1Swl3iY172qUIBCL2En
         4RJ4iYsQN3g3wTp0w6pTrJJE5Z6hIWZw+z1J8DIX3/MEDhCpXQnnNxFEL6Ilr33dkod/
         aiqzvoREGt5xdvoPtZQRVTK9bnc1qCntIIyOCFuv7V7cshHkW1EXyDMhDJI9WYXB0s0R
         WL6A==
X-Forwarded-Encrypted: i=1; AJvYcCU9VS9Si/Y8d59JNdJaTpYA75iQs7vmBLkEexU9LlB3FOcI6ihNJ2XKiP3ZzBXmPZT320HiNwrFQqAT6pTWbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXU5bSgbsrDhPETRa+1lif9grbazp2VqWwctsdw1ndVMy6QUh6
	Y2Xwn2NIu4peCoZnud7GRbH550ruLtLxk0MRcKsmtLxzMmSN2xnXXMZkiYYB/tpaCdorNc7X9q6
	ET3js51k/uynnBOQ1EDAJ7tcJt03I79b7aGlOrKXYkmtOupiJRYfqqto=
X-Google-Smtp-Source: AGHT+IHRys8t15pGEyx2Uj8xTk+9xKDkZHRUejMuDjLlj8Pk5ZxBKK0o8h87wsBLGKhZtw1D6prB4f+2fqmeZjAuytjWSqmir42C
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198a:b0:3ce:8cd1:f671 with SMTP id
 e9e14a558f8ab-3ce8cd1f9b5mr1803225ab.21.1736935580317; Wed, 15 Jan 2025
 02:06:20 -0800 (PST)
Date: Wed, 15 Jan 2025 02:06:20 -0800
In-Reply-To: <671b8cd6.050a0220.2e773.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6787889c.050a0220.20d369.000e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING: locking bug in rcu_pending_pcpu_dequeue
From: syzbot <syzbot+e103923b16da1cda0ae0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    619f0b6fad52 Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fc87c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c676c8e1379fdfaa
dashboard link: https://syzkaller.appspot.com/bug?extid=e103923b16da1cda0ae0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f36a18580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a9c9c3056af4/disk-619f0b6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/558f94c52108/vmlinux-619f0b6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/595b7ae81ee0/bzImage-619f0b6f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/57adb1b0a2e2/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e103923b16da1cda0ae0@syzkaller.appspotmail.com

bcachefs (loop2): stripes_read... done
bcachefs (loop2): snapshots_read... done
bcachefs (loop2): check_allocations...
------------[ cut here ]------------
Looking for class "" with key rcu_pending_init.__key, but found a different class "&p->lock" with the same key
WARNING: CPU: 0 PID: 7205 at kernel/locking/lockdep.c:939 look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 0 UID: 0 PID: 7205 Comm: syz.2.134 Not tainted 6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Code: 01 0f 85 8a 00 00 00 c6 05 c4 7d 41 04 01 90 49 8b 16 49 8b 76 18 48 8b 8b b8 00 00 00 48 c7 c7 60 ba 0a 8c e8 15 07 9f f5 90 <0f> 0b 90 90 eb 61 90 e8 68 de f5 f8 e8 63 69 be f5 48 c7 c7 a0 b9
RSP: 0018:ffffc90003bcd870 EFLAGS: 00010046
RAX: 5e4db7495586dc00 RBX: ffffffff93c599c8 RCX: ffff888031bd1e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003bcd980 R08: ffffffff816019e2 R09: 1ffff110170c519a
R10: dffffc0000000000 R11: ffffed10170c519b R12: ffffe8ffffc3f830
R13: ffffe8ffffc3f830 R14: ffffe8ffffc3f830 R15: ffffffff9a51dcc0
FS:  00007ff8886426c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f05ef09a000 CR3: 0000000033d02000 CR4: 00000000003526f0
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
 rcu_pending_pcpu_dequeue+0x29/0x2b0 fs/bcachefs/rcu_pending.c:522
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:143 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:220 [inline]
 btree_key_cache_fill+0x43a/0x2920 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x84e/0xbe0 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x45d/0x2940 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_trans_update_get_key_cache+0x6c0/0x1220 fs/bcachefs/btree_update.c:494
 bch2_trans_update+0x9b1/0x2550 fs/bcachefs/btree_update.c:539
 bch2_alloc_write_key fs/bcachefs/btree_gc.c:887 [inline]
 bch2_gc_alloc_done fs/bcachefs/btree_gc.c:897 [inline]
 bch2_check_allocations+0x4344/0x7070 fs/bcachefs/btree_gc.c:1139
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3511
 do_mount fs/namespace.c:3851 [inline]
 __do_sys_mount fs/namespace.c:4061 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4038
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff8877874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff888641e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ff888641ef0 RCX: 00007ff8877874ca
RDX: 0000000020000380 RSI: 0000000020000340 RDI: 00007ff888641eb0
RBP: 0000000020000380 R08: 00007ff888641ef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000000020000340
R13: 00007ff888641eb0 R14: 0000000000005919 R15: 00000000200001c0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
