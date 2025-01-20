Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A00F383
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Jan 2025 23:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737414026; cv=none; b=tfhHdWERiVB7zEVyGHTu7HAxBw7orOzDNcKCior7zwNqWiCC3LpJl+CuLySsfenBPwgjHV5jDHCCqgF411hHCjwvv76lUD3JZXAgeOUl1Aq/Jv/U4Xu7jvbHjc3yNm/Y+b23fPmiAisexxYtq6EhzUUebjYbHHofSqHToBiLN8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737414026; c=relaxed/simple;
	bh=Y/SsdsLt7IQmGkRXCZvWaboR9B7D05UJ9iaVk2MEl4A=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TKNUA/r4i0aJPmC3sce0QA8EoZeGOnmWeLfdBKhFH8BlYKCDWk/ravGc3IZnU4LYgqxJYtAy6/UKabB3oRcTF4EzHYRG+T0/upy1bz6rd1pFbrwJbjEAGcKjynPObAMPFPqR6LGe/KtgJm4e70XWkKqvx4QlSRE+V5byait9djA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ce7e5d651aso40103735ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 20 Jan 2025 15:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737414024; x=1738018824;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OG0kCiXAkpHNAos4IjkyXmyqU3EhFukxrDy/vAFe+eU=;
        b=wQaduG87k3ru11Cao3vroTaA7pulTkYBExvUuu+zTyiuxjEUIoGotw2dDDD8V0CAKQ
         Av8/YvzsdhsUgZ7K+dZ/nZfEMnEriPrvteXFtJ96Rvp9pyzFIDefnmypwW0Qe3us3HOW
         vep9c3nsqFSA+wIXZ4jHdWHiNv9v9BeUe0cTdqqmArHWvCUpTYcIDNnpYE2JUZKthoOF
         bZn8DuzXuZQJHKWXdOt8WRaOqn+dU3KAF6Ke2mGWCo69Lh3FrGBxVHAi7MdXIS9Ptorr
         mUEMFF/LbPVfZXC0JB3Wv9PRxQVsf7LEKMcXyDuIa//FkQtaW4Fk8Ns5+Br+fWWR34gq
         ROBg==
X-Forwarded-Encrypted: i=1; AJvYcCWy0CAuxIdWEdnBLsZVNaYFjYi2wwwnK0p+vqpg3kl6JTI3S+N3PRJIOZ5hU0W1YeNaiFTqQYJ360bYXI4XyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yznc4FXLEyMc2vCWoaORn0T0TfNG87iLA/XXzKqFrRuRLVZDsdV
	ReLHiydGVH2m/JAPKKUfvISG50d8Vmm6hPNaszhGK9LoEDU0Zvevlf709bU1dmqZspbhXCCuOB1
	IMWEgpGHA6LI6bg7X/+ZlNYOukdOrmj56LYx/x40MDN8IkJHIcR1a8po=
X-Google-Smtp-Source: AGHT+IFQsuYL9xmFfZ6VgNIjFiqnoFpRJzjuVPf63sTpcQnzBx/H32YISCGwVh6DMqL0tD5r97ZGpl8ZnxTAgpCrIscSu25ysw3W
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c26b:0:b0:3ce:7ac0:64ce with SMTP id
 e9e14a558f8ab-3cf74495f72mr127071695ab.18.1737414024182; Mon, 20 Jan 2025
 15:00:24 -0800 (PST)
Date: Mon, 20 Jan 2025 15:00:24 -0800
In-Reply-To: <67886d60.050a0220.20d369.0020.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678ed588.050a0220.15cac.0001.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_btree_node_hash_insert (2)
From: syzbot <syzbot+3b2a86ce65e01acca028@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ffd294d346d1 Linux 6.13
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1092b9df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88da85736adb8c92
dashboard link: https://syzkaller.appspot.com/bug?extid=3b2a86ce65e01acca028
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10722618580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e9d2b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ffd294d3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ab1d8ddaa6bd/vmlinux-ffd294d3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8aadb123ffff/bzImage-ffd294d3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/12a2657ef791/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3b2a86ce65e01acca028@syzkaller.appspotmail.com

bucket 0:42 data type btree stale dirty ptr: 0 < 1
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1db8f60c84bb244c written 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen 0 stale, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.c:280!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5300 Comm: syz-executor829 Not tainted 6.13.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: ed fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 8e 76 ed fd e9 e5 f7 ff ff e8 f4 0b 87 fd 90 <0f> 0b e8 ec 0b 87 fd 90 0f 0b e8 e4 0b 87 fd 90 0f 0b e8 ec 7d b0
RSP: 0018:ffffc9000d2c5de0 EFLAGS: 00010293
RAX: ffffffff84186bcc RBX: ffff888040678228 RCX: ffff888000a50000
RDX: 0000000000000000 RSI: ffff888040678000 RDI: ffff888048c01a80
RBP: ffffc9000d2c5f10 R08: ffffffff841874b1 R09: 1ffff110080cf016
R10: dffffc0000000000 R11: ffffed10080cf017 R12: 1ffff110080cf045
R13: dffffc0000000000 R14: ffff888048c01a80 R15: ffff888040678000
FS:  000055557bdba380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005644f46e5018 CR3: 0000000042ec0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_update_key_early+0xa8d/0xbd0 fs/bcachefs/btree_cache.c:332
 bch2_check_fix_ptrs+0x5dc7/0x6530 fs/bcachefs/buckets.c:380
 bch2_trigger_extent+0x92c/0xaa0 fs/bcachefs/buckets.c:856
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_gc_mark_key+0x6b5/0x10e0 fs/bcachefs/btree_gc.c:634
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1c3e/0x7070 fs/bcachefs/btree_gc.c:1133
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
RIP: 0033:0x7f4025b9c88a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc9288bcf8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc9288bd10 RCX: 00007f4025b9c88a
RDX: 00000000200000c0 RSI: 0000000020000180 RDI: 00007ffc9288bd10
RBP: 0000000000000004 R08: 00007ffc9288bd50 R09: 00000000000059ad
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffc9288bd50 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_node_hash_insert+0x12ed/0x1310 fs/bcachefs/btree_cache.c:280
Code: ed fd e9 9d f5 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c f2 f7 ff ff 48 89 df e8 8e 76 ed fd e9 e5 f7 ff ff e8 f4 0b 87 fd 90 <0f> 0b e8 ec 0b 87 fd 90 0f 0b e8 e4 0b 87 fd 90 0f 0b e8 ec 7d b0
RSP: 0018:ffffc9000d2c5de0 EFLAGS: 00010293
RAX: ffffffff84186bcc RBX: ffff888040678228 RCX: ffff888000a50000
RDX: 0000000000000000 RSI: ffff888040678000 RDI: ffff888048c01a80
RBP: ffffc9000d2c5f10 R08: ffffffff841874b1 R09: 1ffff110080cf016
R10: dffffc0000000000 R11: ffffed10080cf017 R12: 1ffff110080cf045
R13: dffffc0000000000 R14: ffff888048c01a80 R15: ffff888040678000
FS:  000055557bdba380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005644f46e5018 CR3: 0000000042ec0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
