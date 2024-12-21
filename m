Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60959CA5A
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734776372; cv=none; b=UOTtIBM1S2c/hVfA/4ZHo0XQx/uA5rDkC69esde/XGdNNtyRQjZl6xYrcIg5BET+VjQuPcQxE55pMc9+McC43VuVh3ehnul8YOivHtTJzVLK3o2iNe1OBEI04y9570ATi7ClIVZCZLs0Hfh03bu6bBKVxWRbtKSN+dxsMVd4rlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734776372; c=relaxed/simple;
	bh=BSb6b7CPM3LzKPH2rdGWlZ9TsL81ZA2TzdiQ8KJy0uM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WYVI3l5qgo7CuG1hUu9OfKMmA42edp1XwaM1q0qwdg+GJUM2fU2g4FT176W2hHA3Vqs1gAos6ni6Hh649NJwOu9Fru4C9BysxzaPacEaEDCzsxTJ6m8XDqsbGLzqlBRj7O/OMxlCxbcVSDBGI+6BnouyqgMh1YYZ6ImIHYyOZes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a817e4aa67so24198275ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 02:19:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734776369; x=1735381169;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IgaLjB0d6S/RM80n0iWhqUmA+kYYCmRJ9epzNzV8NPU=;
        b=Q4aebCzXm7wnuPFHfDUo3o0fu4ehOEg6rxVpKwbKbyOMW1mkhxicwNMZjphAkInM+m
         tUwfFu6AI108e9P5EyJqUh3KLZZqmcmllMrVzGXN9I9vXi1RDndosf6X64d2rqaeO1jl
         7hv7YXRQof6dcqUxBp50G8iPIA37KNLt8MH0Fshd0pDWTj8qU6TNlmDv6vbDkZLBFN21
         scOGSwuCdsdGYl6Ncl4HUt+c/G5m7H25Jv5TaS7Gzc8xEDhvanPSKEpUSTnOwoUkhY3b
         A3UhE8gt/RvJfMfg9XmuTkGr/3Npal2iXHeM6vLbO3zymCZGvu/bTbBqmxf4T8iuLXxn
         rSEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNuvAPwuwNZPGB5aBoADj15Y8mLaBPJCxY913DKTOA8vgFzqBw7ZGv+LH1OWDXHpKRByATLkwWQMc4IBrxag==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqqPDqiouryHOOTiXfxp7Qw8xLj24uxNxK2C8oW04BOyuuOg0r
	o/z8I/V9HS5UB+JKCaQr9j/1BOw9olVj9g7un1BfbMoe2Hnzi6ENipWvfdej8cWzJVXtS0cLsfP
	jtCVtFzCMz0EY7XU0pVxO1QAOXZyoLnNsDpRk52c7LiUnqODeryfYbys=
X-Google-Smtp-Source: AGHT+IGRhbpj4/kf0Wg1uq7PmExJJolOmbSUZLNy9Bkht89UypD2y2tYUP8sNn5jjZVGd65iBW9W1crh2Q42c79JITS/sAO/2rlI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20ca:b0:3a7:7124:bd2c with SMTP id
 e9e14a558f8ab-3c2d51516b7mr68083195ab.19.1734776369606; Sat, 21 Dec 2024
 02:19:29 -0800 (PST)
Date: Sat, 21 Dec 2024 02:19:29 -0800
In-Reply-To: <00000000000047b2a506189dfc1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67669631.050a0220.25abdd.012c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_trans_put
From: syzbot <syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e9b8ffafd20a Merge tag 'usb-6.13-rc4' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10b47e0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10246f30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176540c4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d0a298a7e2d5/disk-e9b8ffaf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/361b2225724c/vmlinux-e9b8ffaf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/033556a82b6e/bzImage-e9b8ffaf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6fe2d0cb8e91/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com

bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=extents level=0 SPOS_MAX due to error
------------[ cut here ]------------
btree trans held srcu lock (delaying memory reclaim) for 11 seconds
WARNING: CPU: 1 PID: 5823 at fs/bcachefs/btree_iter.c:3030 check_srcu_held_too_long fs/bcachefs/btree_iter.c:3028 [inline]
WARNING: CPU: 1 PID: 5823 at fs/bcachefs/btree_iter.c:3030 bch2_trans_put+0xd45/0xf00 fs/bcachefs/btree_iter.c:3274
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz-executor422 Not tainted 6.13.0-rc3-syzkaller-00193-ge9b8ffafd20a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:check_srcu_held_too_long fs/bcachefs/btree_iter.c:3028 [inline]
RIP: 0010:bch2_trans_put+0xd45/0xf00 fs/bcachefs/btree_iter.c:3274
Code: 1c 24 48 c1 eb 02 48 b9 c3 f5 28 5c 8f c2 f5 28 48 89 d8 48 f7 e1 48 c1 ea 02 48 c7 c7 40 28 51 8c 48 89 d6 e8 5c 4e 42 fd 90 <0f> 0b 90 90 e9 af f8 ff ff e8 1d ab 81 fd 90 0f 0b 90 e9 f2 f8 ff
RSP: 0018:ffffc90003f3f300 EFLAGS: 00010246
RAX: daf39d7b7a91ab00 RBX: 0000000000000113 RCX: ffff88802414bc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff81601962 R09: 1ffff920007e7dfc
R10: dffffc0000000000 R11: fffff520007e7dfd R12: ffff888029d10070
R13: 1ffff110053a200e R14: ffff888029d10042 R15: 1ffff110053a2008
FS:  0000555580eef380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f95f5c24990 CR3: 0000000076fc2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_root_read+0x6d6/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f95f5bf2eda
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6fea95b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd6fea95c0 RCX: 00007f95f5bf2eda
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffd6fea95c0
RBP: 0000000000000004 R08: 00007ffd6fea9600 R09: 00000000000058fe
R10: 0000000000000001 R11: 0000000000000282 R12: 00007ffd6fea9600
R13: 0000000000000003 R14: 0000000001000000 R15: 00007f95f5c3a03b
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
