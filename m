Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4760435947
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 02:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739415022; cv=none; b=PGIiD1585zXc6SRK4XapWZ/uFIWIo9i59lgBreZH2X0MzbCw/A64DgSPuzGMF0w5bYfK6Dqer1mf9UAQQ7ECeWGvk92VStjUNeWJftV57QFW+0vNdM40O4e2XtrBNn5zS+BXB7k2mdrV9SaKQLkZ+56IidKKV9BCOkOdAev70ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739415022; c=relaxed/simple;
	bh=IhNnv9A8xMCtA2GWFqZ6Y+uA+T74NuklveC9/S6AB6U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=INwU1AFbjqzr7r6M4dU562o9syaJq92Vvk+WwUc6zZA6/zVNb+RWmt0rmMm65Y1J6n/ggLivkfTFbyb97iuD2s3zDqIHQHZa49tSmX3AKbA+SOI8PokOJir7wFyFTRcm7EZn1acKY6UyD6CC6YsBF8q8Q3kkQlJGmXjVNpv/8zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d18700311dso2888545ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 18:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739415020; x=1740019820;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TPmOTzWtVm2N0eQJTjR3cORbIlvWtpTU5n8X/CPLxVg=;
        b=UJu4wlrqqTCfzRDDx+UCVYKnmkKh3RnVXWXRJkTYebXaB2VDNIbnwEZE7riHZRcUWO
         lBSyoOyvqX/6/u3nmjyZtu57GVGHzm+4kzeJBLq8GfpZvVLAFDl37lppn2CZJMK/zl6l
         ZTlpu4rykQmCPZdlgqYTkkESr9DVtZh/s5aTcaWYMh3Dw2gKPzR30Win92YsTUKOZeoh
         ZAFhcQF2xxDKVZFthF4HzjU8VrHJpGT2nYJ8/PgSSWpl7uiO4WKKj5lpF/ZqQYopdLBW
         bF1KDdNSZh/LmfCyrMfYDylnQnHlHRPMPsMtYCG2hJTDjKZQ3Ry0GJasxfIbpnEP65Zt
         pS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXM3xRfx5hn19E6DxskBlocwyTaUe/p3NompTU4Q3oynnx7QMCf+Y1xUb6RZpfVMwaJAw67kNlXK7flthPUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YywwY3QGIQCPCLluaRCqsY/T+PHoBvlppVrlrAkPJetzXRmalwf
	iv+LeXpd9FeVSBzSYjriQhqjAkrKxBDWw/13mqmGk6OaqAVr4AZZ+EHuWWWYJEA797fJA0S25q0
	xj5hrv9zKkJ1KKXNx1m/TRlcpO6V0EDMAMmLmuS/GZxjtAsKuCzUWRdk=
X-Google-Smtp-Source: AGHT+IEw996n3q7RYLQxRi8pOtdqwlC1zDTL7Z9O8aZVPVl5RFxdtJILbTaZcmLnF9h2smp6vl5kI1SJzsOsdboXsO235AL/JN6e
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a84:b0:3d0:4a82:3f42 with SMTP id
 e9e14a558f8ab-3d17bff951dmr40717425ab.16.1739415020367; Wed, 12 Feb 2025
 18:50:20 -0800 (PST)
Date: Wed, 12 Feb 2025 18:50:20 -0800
In-Reply-To: <66f02282.050a0220.1b7b75.0003.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ad5dec.050a0220.3d72c.01c8.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_quota_check_limit
From: syzbot <syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    4dc1d1bec898 Merge tag 'mfd-fixes-6.14' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1093bbdf980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c2347dd6174fbe2
dashboard link: https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db49b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103b49b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-4dc1d1be.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/69a70e883a61/vmlinux-4dc1d1be.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e5f11135c484/bzImage-4dc1d1be.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a337140bc590/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com

bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): reading quotas
------------[ cut here ]------------
kernel BUG at fs/bcachefs/quota.c:232!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5303 Comm: syz-executor286 Not tainted 6.14.0-rc2-syzkaller-00041-g4dc1d1bec898 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_quota_check_limit+0xd48/0xd70 fs/bcachefs/quota.c:232
Code: de e8 ac fc b1 00 e9 9b fa ff ff e8 e2 47 50 fd 48 c7 c7 10 2b f7 8e 48 89 de e8 93 fc b1 00 e9 d8 fa ff ff e8 c9 47 50 fd 90 <0f> 0b e8 c1 47 50 fd 90 0f 0b e8 b9 47 50 fd 90 0f 0b e8 b1 47 50
RSP: 0018:ffffc9000cfe6eb0 EFLAGS: 00010293
RAX: ffffffff846f07d7 RBX: 0000000000000000 RCX: ffff8880006d0000
RDX: 0000000000000000 RSI: f7c0f28a20bd2430 RDI: 0000000000000000
RBP: f7c0f28a20bd2418 R08: ffffffff846efb1f R09: f7c0f28a20bd2418
R10: dffffc0000000000 R11: fffffbfff2036c0f R12: ffff88804a968000
R13: 0000000000000000 R14: f7c0f28a20bd2430 R15: ffffc9000cfe6fe0
FS:  00005555744ef380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005624cd3f1098 CR3: 00000000431b0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_quota_acct+0x3fb/0x750 fs/bcachefs/quota.c:299
 bch2_fs_quota_read_inode fs/bcachefs/quota.c:514 [inline]
 bch2_fs_quota_read+0x13d7/0x24b0 fs/bcachefs/quota.c:536
 bch2_fs_recovery+0x307d/0x3de0 fs/bcachefs/recovery.c:988
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5b5e44cfaa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc16aae0e8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc16aae100 RCX: 00007f5b5e44cfaa
RDX: 0000400000000000 RSI: 0000400000000200 RDI: 00007ffc16aae100
RBP: 0000400000000200 R08: 00007ffc16aae140 R09: 000000000000f631
R10: 0000000002a18414 R11: 0000000000000282 R12: 0000400000000000
R13: 00007ffc16aae140 R14: 0000000000000003 R15: 0000000002a18414
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_quota_check_limit+0xd48/0xd70 fs/bcachefs/quota.c:232
Code: de e8 ac fc b1 00 e9 9b fa ff ff e8 e2 47 50 fd 48 c7 c7 10 2b f7 8e 48 89 de e8 93 fc b1 00 e9 d8 fa ff ff e8 c9 47 50 fd 90 <0f> 0b e8 c1 47 50 fd 90 0f 0b e8 b9 47 50 fd 90 0f 0b e8 b1 47 50
RSP: 0018:ffffc9000cfe6eb0 EFLAGS: 00010293
RAX: ffffffff846f07d7 RBX: 0000000000000000 RCX: ffff8880006d0000
RDX: 0000000000000000 RSI: f7c0f28a20bd2430 RDI: 0000000000000000
RBP: f7c0f28a20bd2418 R08: ffffffff846efb1f R09: f7c0f28a20bd2418
R10: dffffc0000000000 R11: fffffbfff2036c0f R12: ffff88804a968000
R13: 0000000000000000 R14: f7c0f28a20bd2430 R15: ffffc9000cfe6fe0
FS:  00005555744ef380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005624cd3f1098 CR3: 00000000431b0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
