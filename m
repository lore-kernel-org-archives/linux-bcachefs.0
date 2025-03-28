Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2903E4409
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Mar 2025 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743172647; cv=none; b=Y02fQz1t+XiR8m0GTvXBNKlAtyEuV8ep3+0VfFhJOOVLmxO3scLL8PGHaCTuQtoEgfkVAkfZpi0ZwUsMyYluDST0xMZp43JxOpFmUzEEHtIsPjiA98cS1J8juicwPftOOSAxKaO85k9M4qg+VAnA9gk+kH1Ahu2zGy9iCCizE1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743172647; c=relaxed/simple;
	bh=gCm7JU5FihwgDHgFXSHn2+IowMIRtz0nUIsMACFCu0M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dZ/9g2toSMt0l8hBerOgLRLaeWvHnuK1o11qWh+ldes9Cal/eThAOxD3lmr+nbGdekhyssyhFjFsvwaPZKjp1HchLv36mYNxBYGtdDRNLuZ0aylGoAc7mANTnz2ok2CCrhs1LLN9XctWunZXRVB5zWwLwTYklh4/syefVTg0lQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3cf64584097so25939725ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Mar 2025 07:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743172645; x=1743777445;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xYMC/H3UEk7iKnzZymadts0uBa0TYTmFnPMsVu/ZvzA=;
        b=nj4Rtv3GC1Y78G7UtaYPv6hWc8+Wxk33GrQwL6dN+oIJp5/QjjrgkK8RJNeqxSBhxS
         k4cVLI0+92DNECZvdzQOX7bQSZkOEX9yLr0rPFPY2dDhRoaW2vZBFfzp3qXhjz2qbii5
         cUpCm6Wj71L2lkLEyJBtSnMv/OUoG4Ga9YOgRbGXDtB6QNSYTs0v5FymnwqRORzus8Yk
         WaX38LP4XmLiG4KsOSwWb0vVGGvFFvvYfq75QNSIRis7Vx2UR2GXMsiZG6hNebVrTuxe
         48j0GmvVfALaeIoC547mwOfYGLvt8oVhqmXveF4n1ZS7fofixLjVl2RADDLuK+PFO6RE
         Axmw==
X-Forwarded-Encrypted: i=1; AJvYcCX0Rw5oTi/kU82aJ/9N7+vjOQitMiAEnQ9VTM9mnvmmpoGdEBUBEy8FER3X2gCwJy52eqLzvpnGsChz63HMow==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPPwI20FcW5yCR8N9OAhRIT4S0sh3K77rNxMMpQtLwDAgeWMlj
	ydfwhQc6TxoeO62bB12vX0/AqaWDB/UN3cuE5v4HBeTLssw+V7YhJ5UU2rCfelkJ46pm/tjHMqC
	9sEqzNPlz2njeJtejRlc4G0QZOcEyrsdxCoYGebUu4/HHgQe94Pxvjg4=
X-Google-Smtp-Source: AGHT+IHxMTrSZ2zop9EggjKA2rrUz+eBoP9Seih/0taYeV8GMv1bnmx5yg5MKHQ3TS0u6z7rYgGrsj9fWa9iAOYzdkKITHzTxzxd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c6:b0:3d1:966c:fc8d with SMTP id
 e9e14a558f8ab-3d5cce29c7amr73783595ab.22.1743172645081; Fri, 28 Mar 2025
 07:37:25 -0700 (PDT)
Date: Fri, 28 Mar 2025 07:37:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e6b425.050a0220.2f068f.007a.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_bkey_pick_read_device
From: syzbot <syzbot+336a6e6a2dbb7d4dba9a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    acb4f33713b9 Merge tag 'm68knommu-for-v6.15' of git://git...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=120aebb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=982413b40f90fdf8
dashboard link: https://syzkaller.appspot.com/bug?extid=336a6e6a2dbb7d4dba9a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e7b43f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160aebb0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/29801dcd72c7/disk-acb4f337.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/606dd80a4b3e/vmlinux-acb4f337.xz
kernel image: https://storage.googleapis.com/syzbot-assets/acf6a9bb497d/bzImage-acb4f337.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/28a34463091e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+336a6e6a2dbb7d4dba9a@syzkaller.appspotmail.com

  btree=alloc level=0 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1818ce08861e3527 written 40 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0
------------[ cut here ]------------
unhandled error case in bch2_bkey_pick_read_device
WARNING: CPU: 0 PID: 5822 at fs/bcachefs/extents.c:230 bch2_bkey_pick_read_device+0x17a5/0x1a00 fs/bcachefs/extents.c:230
Modules linked in:
CPU: 0 UID: 0 PID: 5822 Comm: syz-executor359 Not tainted 6.14.0-syzkaller-07422-gacb4f33713b9 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:bch2_bkey_pick_read_device+0x17a5/0x1a00 fs/bcachefs/extents.c:230
Code: d1 cc 59 fd e9 d0 fd ff ff e8 c7 cc 59 fd c6 05 51 06 dd 0b 01 90 48 c7 c7 e0 9c 93 8c 48 c7 c6 9e d7 57 8e e8 0c e0 18 fd 90 <0f> 0b 90 90 e9 bc fe ff ff e8 9d cc 59 fd e9 6e ff ff ff 89 d9 80
RSP: 0018:ffffc9000412ede0 EFLAGS: 00010246
RAX: d930a4d251d78e00 RBX: 0000000000000000 RCX: ffff88807d1a8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000412f010 R08: ffffffff81829c92 R09: 1ffff92000825d58
R10: dffffc0000000000 R11: fffff52000825d59 R12: dffffc0000000000
R13: 1ffff92000825de4 R14: 0000000000000000 R15: 0000000000000000
FS:  0000555580f6f380(0000) GS:ffff888125027000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005564d1c2e1f0 CR3: 000000007a9ee000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_read+0x7ac/0x29e0 fs/bcachefs/btree_io.c:1705
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1795 [inline]
 bch2_btree_root_read+0x656/0x7e0 fs/bcachefs/btree_io.c:1817
 read_btree_roots+0x3d7/0xa80 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x28e4/0x3e20 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x37c/0x620 fs/bcachefs/super.c:1057
 bch2_fs_get_tree+0x1270/0x18d0 fs/bcachefs/fs.c:2253
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3878
 do_mount fs/namespace.c:4218 [inline]
 __do_sys_mount fs/namespace.c:4429 [inline]
 __se_sys_mount+0x38c/0x400 fs/namespace.c:4406
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f50721bda3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb2febc18 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdb2febc30 RCX: 00007f50721bda3a
RDX: 000020000000f640 RSI: 00002000000000c0 RDI: 00007ffdb2febc30
RBP: 00002000000000c0 R08: 00007ffdb2febc70 R09: 000000000000f62e
R10: 0000000002200002 R11: 0000000000000282 R12: 000020000000f640
R13: 00007ffdb2febc70 R14: 0000000000000003 R15: 0000000002200002
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
