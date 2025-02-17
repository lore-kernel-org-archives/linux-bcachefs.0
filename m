Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21D7192D70
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 07:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778810; cv=none; b=Q1umKvbE7C5YytlHET6Y3jyX0tdJtRloZUtsbk7JkIVE9oHXEa1cKavVymIWSaOz/lMtnloZw4bpGWbYflwATD2eGcplRsgM9CxZ1kh6ZWbCD+G/CPn0srGq4eKSyK3AoF8cW98ioO+xSw2Ksvn3/JKZBysbC3AKqewq7e9mD/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778810; c=relaxed/simple;
	bh=UWNlBGhn8gTQXtaqcjBINb2qBYAx79VzujnWrdSJMn8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=co3RKSUbF50dBc47R7F1RihGC++1yIKh4fnRXkSdq2+dFTt/MVRQqMsPMnU1wqPH77lBT4F9GLQHrZULSDq3kJeM2cD6JYzrEOXVcR3wdgDCj48s3tOYu+xbpkSYbeQMn9rej4QLramtl/KzFaODoWVW+LdOwNSNWWX2/iPipLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d054d79dacso79547725ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 23:53:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739778808; x=1740383608;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xa6eOaAMR3+Qxml1oXlPvkHdgNoOKtRK2JU98N4ptAU=;
        b=N5eFa0qKONzP3/TakRYAaXEwY9OedgEAYl0czMrk9Gb5b/eB1ETWjMFzxG04q8ip6A
         FtW/izmoJUJjsDn8Mi2xUOW9mNfSplnUurEptAfOYXqkVMiUy0EuWOYHUYn37YGuR5UA
         bhRI5duBl4Zo46AtpML2Z3LScwfKVIjWAfgLJIo6/GfzRUYESc+wBYBG5DFQqaW5a2ti
         dKRG2J0vzR+oDeB20FjISERpuA/XSO2vHPg5lMsjrLd0hHgL+MaAMOX8AZCsEQ/j5KWk
         8cUp6rMwvRnRtVVnlrOpk4jJS/69YWCqruychfwbpagNr59vIAHzKJbkCvv2uJEnPkWU
         wEYw==
X-Forwarded-Encrypted: i=1; AJvYcCWACMSqOJ2mSHcAmI7ozFxzNxuyNHfsZ9FOQ4ou2ZWfkUpLn9WywQ9iXUIbBR0rLDq8xbf2qpaq+g6wj80RIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxF6gTQacuvyoD1Bh/4qWyQUit8tjJehzST6elkhhJZlSvd7IFZ
	VdDALZ+u4jr45La/GDYV09L+xiI6NKM7JUhGnXm+8cNtz7lvJ7C9kux8PBR3lUwotm2WGe6Du5/
	09aPRti0lL3CgPAeVKYJgERpy6JIihJnU8sLiQn3ZZSyy92R1LpUY71s=
X-Google-Smtp-Source: AGHT+IFqV+nU2Qz57UdH0pXY1vNYRVAam7Zie7skMf8m4Bc3k0pqLhD+EAGmuDvZkjK3Q07MmDfQ7ZWdi+3ssKl5WOM1ekSOBsqE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4b:b0:3cf:c773:6992 with SMTP id
 e9e14a558f8ab-3d280906241mr91745345ab.12.1739778807973; Sun, 16 Feb 2025
 23:53:27 -0800 (PST)
Date: Sun, 16 Feb 2025 23:53:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2eaf7.050a0220.173698.001f.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_reconstruct_snapshots
From: syzbot <syzbot+b4cb4a6988aced0cec4b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13c44bf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=b4cb4a6988aced0cec4b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d5d9b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112099a4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/419cba1a156b/disk-128c8f96.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0fa327c9a058/vmlinux-128c8f96.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ad066f8a08b/bzImage-128c8f96.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/77719351875e/mount_0.gz

The issue was bisected to:

commit c986dd7ecba185ad2a36b0815940f34deb2a8170
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Oct 10 01:28:11 2024 +0000

    bcachefs: Improve check_snapshot_exists()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1568e098580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1768e098580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1368e098580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b4cb4a6988aced0cec4b@syzkaller.appspotmail.com
Fixes: c986dd7ecba1 ("bcachefs: Improve check_snapshot_exists()")

bcachefs (loop0): scanning for missing backpointers in 6/128 buckets
 done
bcachefs (loop0): reconstruct_snapshots...
snapshot node 4294905343 from tree 4294905343 missing, recreating
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey_types.h:210!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5822 Comm: syz-executor354 Not tainted 6.14.0-rc2-syzkaller-00185-g128c8f96eb86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:bkey_s_c_to_subvolume fs/bcachefs/bkey_types.h:210 [inline]
RIP: 0010:check_snapshot_exists fs/bcachefs/snapshot.c:884 [inline]
RIP: 0010:bch2_reconstruct_snapshots+0x35a5/0x35b0 fs/bcachefs/snapshot.c:1001
Code: 08 a9 fd e9 e3 cb ff ff e8 88 51 44 fd e8 f3 fa a8 fd 4c 89 ef 89 de e8 29 68 cc ff e8 74 51 44 fd 90 0f 0b e8 6c 51 44 fd 90 <0f> 0b e8 84 e7 82 07 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003dfee20 EFLAGS: 00010293
RAX: ffffffff847d6594 RBX: 0000000000000009 RCX: ffff88807c9d5a00
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 0000000000000015
RBP: ffffc90003dff428 R08: ffffffff847d56ba R09: 0000000000000000
R10: ffffc90003dfe820 R11: fffff520007bfd11 R12: ffff8880250865c0
R13: 0000000000000000 R14: ffff888029330230 R15: 1ffff11004a10cb8
FS:  000055558bf6c380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055da28eea000 CR3: 000000005d824000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe1e5e912ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff4e8847f8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff4e884810 RCX: 00007fe1e5e912ea
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007fff4e884810
RBP: 0000400000005900 R08: 00007fff4e884850 R09: 000000000000592e
R10: 0000000001000000 R11: 0000000000000282 R12: 00004000000058c0
R13: 00007fff4e884850 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bkey_s_c_to_subvolume fs/bcachefs/bkey_types.h:210 [inline]
RIP: 0010:check_snapshot_exists fs/bcachefs/snapshot.c:884 [inline]
RIP: 0010:bch2_reconstruct_snapshots+0x35a5/0x35b0 fs/bcachefs/snapshot.c:1001
Code: 08 a9 fd e9 e3 cb ff ff e8 88 51 44 fd e8 f3 fa a8 fd 4c 89 ef 89 de e8 29 68 cc ff e8 74 51 44 fd 90 0f 0b e8 6c 51 44 fd 90 <0f> 0b e8 84 e7 82 07 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90003dfee20 EFLAGS: 00010293
RAX: ffffffff847d6594 RBX: 0000000000000009 RCX: ffff88807c9d5a00
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 0000000000000015
RBP: ffffc90003dff428 R08: ffffffff847d56ba R09: 0000000000000000
R10: ffffc90003dfe820 R11: fffff520007bfd11 R12: ffff8880250865c0
R13: 0000000000000000 R14: ffff888029330230 R15: 1ffff11004a10cb8
FS:  000055558bf6c380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ff36f26038 CR3: 000000005d824000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
