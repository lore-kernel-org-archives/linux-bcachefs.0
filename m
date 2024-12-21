Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA5D19DF61
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 08:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734768443; cv=none; b=S91od4mooGuYM2E/K8n1pogXsD3DFQhJQgLboydvcU6s17F4yhwGiWFYAn7Y6qY888FS73p1J2ScthFn2cq+M9jIJysZdNkG4OjSUczQdKrjPe0YMqHasY3riv7X7V2uSIjAyDszpEnJ6sIoCMRMMOIc5+YWxZ4ZyK8Bbo9u3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734768443; c=relaxed/simple;
	bh=xlwN07Pw7HtepPsvjKjTDtdMsamSNrlDzdfHU0R4TwQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DrnrWNxANEo4hMkelbNemTesVJSKiXehrN1H2akwuYFTivJe9RGV5n+pgZQ8rxxTPNLNI3odTLKVR41KE3IzXXvcL0nHDYCfZsDAWwfPc37LX4hWS++5HXfq2m9xMkub9Weh7J6CyQNP2Vfc28eqELxCjPdUCq5RRHAtxwGxJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7e39b48a2so51626565ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 00:07:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734768441; x=1735373241;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZfJ7YhPynGx+OJ9WKpyZwKymghT+hwgfer2nulqdfY=;
        b=g7rFF6OzDh1pUMZFnY4l8M6TXviL95RVuylk5+sD9+PjzcDDDSht5gHsO5h71dw14F
         VBGXJ+6eryydAdNrn572SVeRZwtY45m5hIV3aYXv1pcphhNm4S67yRtpX6z9w31b/jhZ
         jS0nVxpF6vW7aJkHz6xuF6wXonlCOq+9RNmOnO31IyxBRBMxfgUAx3I5UvwTb5vzMKGg
         nkMfnLvd6hJs+o/pnu8SgEv7cE1PGvpQC7crXml3tar2D4nELFOyj9exf+qPIVjwUDzi
         1GcPRJmMC+4KZJfccstC+37GYqyoCDbNm7nIcPwiQZRY+Bw8WmIIGZQAx01q9bcG3r7I
         VPow==
X-Forwarded-Encrypted: i=1; AJvYcCUKBTGcNP3ByQltySRvMCsuRS6tI3u1YwuOrlGePpkm3lvRpJnBU7XTJ7GGXmyORp2dJ+1RrBVt+glF3ODCMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi6Hm3Tyv65WrZZ/Crhr1WTW+u3N1ApbwhYPDCnX/vsj8UcNhh
	exgxV9k8niz/Wzwut9jz2Xo2l15hIYkfhLnv/1WLuZTn1XsKF0ipvqDyMMC9Ixk8csnksntfsRn
	o5cf+gCqsu220HXzMFHPfAeZWK1hNXON6er7lNlA+dMyS02+KrpDSZVE=
X-Google-Smtp-Source: AGHT+IHR+o5PLlh6UaXn3bxshVtu1eLhgAc9k9zbdwe+gy+C5ffizEI7+QAWS6g+FZD9va4f/T+jdPCpTV+XORWV18yRXHMPDtaX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a44:b0:3a7:e86a:e803 with SMTP id
 e9e14a558f8ab-3c2d25673f5mr53721985ab.8.1734768441483; Sat, 21 Dec 2024
 00:07:21 -0800 (PST)
Date: Sat, 21 Dec 2024 00:07:21 -0800
In-Reply-To: <67633cd6.050a0220.3157ee.0006.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67667739.050a0220.226966.000a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init_from_start
From: syzbot <syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e9b8ffafd20a Merge tag 'usb-6.13-rc4' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11d7af30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=381eead9693b057ae73f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17f640c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176fbe0f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d0a298a7e2d5/disk-e9b8ffaf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/361b2225724c/vmlinux-e9b8ffaf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/033556a82b6e/bzImage-e9b8ffaf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/49b59694867f/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+381eead9693b057ae73f@syzkaller.appspotmail.com

btree node with incorrect min_key  at btree snapshots level 1:
  parent: u64s 5 type btree_ptr SPOS_MAX len 0 ver 0
  next: u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d771a06d670df06c written 536 min_key 674309865472:0:0 durability: 1 ptr: 0:32:0 gen 0, fixing
bcachefs (loop0): set_node_min(): u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d771a06d670df06c written 536 min_key 674309865472:0:0 durability: 1 ptr: 0:32:0 gen 0 -> 9710702841361986335:2465851572921718109:1388148219
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bset.c:1354!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 5823 Comm: syz-executor860 Not tainted 6.13.0-rc3-syzkaller-00193-ge9b8ffafd20a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:bch2_btree_node_iter_init_from_start+0x446/0x460 fs/bcachefs/bset.c:1354
Code: c4 80 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 40 ae ff ff e8 0b 2f 8a fd 90 0f 0b e8 03 2f 8a fd 90 0f 0b e8 fb 2e 8a fd 90 <0f> 0b e8 f3 2e 8a fd 90 0f 0b e8 eb 2e 8a fd 90 0f 0b e8 e3 2e 8a
RSP: 0018:ffffc90003eee828 EFLAGS: 00010293
RAX: ffffffff841544a5 RBX: ffff8880734c009e RCX: ffff888033451e00
RDX: 0000000000000000 RSI: ffff8880734c00a0 RDI: ffff8880734c0008
RBP: 0000000000000013 R08: ffffffff84154119 R09: 0000000000000000
R10: ffffc90003eee920 R11: fffff520007ddd25 R12: ffff8880277888f8
R13: ffff888027788908 R14: dffffc0000000000 R15: ffffc90003eee920
FS:  00007f32a0c696c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a384727ff8 CR3: 0000000032b60000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_and_journal_iter_init_node_iter+0x98/0x200 fs/bcachefs/btree_journal_iter.c:478
 bch2_btree_repair_topology_recurse+0x45c8/0x6750 fs/bcachefs/btree_gc.c:447
 bch2_check_topology+0x692/0xb20 fs/bcachefs/btree_gc.c:550
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
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
RIP: 0033:0x7f32a0cb471a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f32a0c68fd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f32a0c68ff0 RCX: 00007f32a0cb471a
RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007f32a0c68ff0
RBP: 0000000000000004 R08: 00007f32a0c69030 R09: 000000000000f625
R10: 0000000000000084 R11: 0000000000000282 R12: 00007f32a0c69030
R13: 0000000000000084 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_node_iter_init_from_start+0x446/0x460 fs/bcachefs/bset.c:1354
Code: c4 80 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 40 ae ff ff e8 0b 2f 8a fd 90 0f 0b e8 03 2f 8a fd 90 0f 0b e8 fb 2e 8a fd 90 <0f> 0b e8 f3 2e 8a fd 90 0f 0b e8 eb 2e 8a fd 90 0f 0b e8 e3 2e 8a
RSP: 0018:ffffc90003eee828 EFLAGS: 00010293
RAX: ffffffff841544a5 RBX: ffff8880734c009e RCX: ffff888033451e00
RDX: 0000000000000000 RSI: ffff8880734c00a0 RDI: ffff8880734c0008
RBP: 0000000000000013 R08: ffffffff84154119 R09: 0000000000000000
R10: ffffc90003eee920 R11: fffff520007ddd25 R12: ffff8880277888f8
R13: ffff888027788908 R14: dffffc0000000000 R15: ffffc90003eee920
FS:  00007f32a0c696c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a384727ff8 CR3: 0000000032b60000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
