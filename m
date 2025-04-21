Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1B645
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 23:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745279066; cv=none; b=OsqaPnB1DlLWPYmDEAKGqSHgWebuaKRZYVah24vEO6Js8REp6ytLThth+h9n3BpzxqcIsMwTlbIaP9JSm6AbC0FCuwUF2eQ0GtjG+YL50CnTulhK1dTfeuyJVLsF8wMrGa8/nBI2m6AQdZZO6fNfzPR9LcUc3to/IhBFrMQb6LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745279066; c=relaxed/simple;
	bh=P2wvXGX9RyxQutEvJeFwCF40d4EG5/gN3MFMUyo9dB4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bHxg4/ICPmjZ6tJLhtPslV88rpT8gvpYgX/rQJgCwOCEJdXFiKTbf8iLYuHb1mlcUvYFNIuwvXsk8Cc+9vNeppvBhJqRRK2gfDEXd+mSg00uPOD5He9J8/zHx+eqWOCF1a7Bbo+Kg7SW1+hMnEwOSNXNoi5QmbL6jc458CYyqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d8dd0c9143so64410425ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 16:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745279063; x=1745883863;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMntUzmFGHwHoKwsYH6vbLJWkFQPvQdgV4H9UXVOs6I=;
        b=ORb67Q+PnjFRN+5uo33kHrfaaHr+uVslW9hl/zNlGm+KqK8sBCGAWpaSYWcDV62gcr
         zDqMgvhAXbvdis0LiCEe7nOnfezU6937WA0HN9g9vU+K8qVDJ/qK7n/INtR2mzqsr/Bd
         W8GqWnMAcXi3W/d5WApeRql3cZNQpHx+rlpUMKzfWLhrt4+BnLPXeXmnJ5SOvKe2kZZ1
         w9a6RXw8hz5fVu0uNIseZlVVhGjVcd3oj2oVb6ZjMgN5BKQoMPT3/AR7xyfWpxolDrzF
         U87jJC8ktcgtu92kM5qcbJEJobO96OlYOc/up6acW02+We62Ztr8/L9oQW51SPzUp3mf
         ls/w==
X-Forwarded-Encrypted: i=1; AJvYcCWwzAbGrxwTN0Xac5AlPLLjdXbtnl3Dv+DWRoWkzH5kzmOfuIDFow5XMQ89fSnxcazC6oYrdPuNu1mItzqFQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhuqkTw/vmiJCCjUi9roqvftkLbJVOWAJGXQb/dFhNmfGAQvt8
	pzew5u7//X4s+3aKjp8E8Pbf+Qq29qOoQ/xy/fCDnv3WmHQhGMFt1c4jkZsAy+FcEFbCKMzD41L
	v9hWLIBNAB4zd1+IqtCdETgGAbqNEMGZhL1khAG76ApBl9SpRxKxf54M=
X-Google-Smtp-Source: AGHT+IH8cQG1EQ7OUlzuetCNZbpyTuGsGoCr+c/nny9NxYKIPrZNTZfMFNMyXuEGl4GQGJsE0y7pvMrV7UjjKiyGgkScu+4J0z/I
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b25:b0:3d4:6ff4:2608 with SMTP id
 e9e14a558f8ab-3d88eda852bmr132763075ab.12.1745279063755; Mon, 21 Apr 2025
 16:44:23 -0700 (PDT)
Date: Mon, 21 Apr 2025 16:44:23 -0700
In-Reply-To: <67f76c11.050a0220.258fea.0029.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6806d857.050a0220.f25bb.07a8.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __bch2_str_hash_check_key
From: syzbot <syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot has found a reproducer for the following issue on:

HEAD commit:    9d7a0577c9db gcc-15: disable '-Wunterminated-string-initia.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D15456c70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D45c3bf6fd4cb6a1=
0
dashboard link: https://syzkaller.appspot.com/bug?extid=3D843981bb836d699c0=
7d1
compiler:       Debian clang version 15.0.6, Debian LLD 15.0.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D100ca63f98000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D138f0ccc580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-9d7a0577.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2451ac2169e6/vmlinux-=
9d7a0577.xz
kernel image: https://storage.googleapis.com/syzbot-assets/14cc88d90db9/bzI=
mage-9d7a0577.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/403f0024ed04=
/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+843981bb836d699c07d1@syzkaller.appspotmail.com

bcachefs (loop0): hash table key at wrong offset: btree dirents inode 4096 =
offset 6229884513039707068, hashed to 2263426191451115502
  u64s 7 type dirent 4096:6229884513039707068:U32_MAX len 0 ver 0: =EF=BF=
=BD=EF=BF=BDle2 -> 2165878814 -> 1056964609 type subvol, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/fsck.c:979!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5314 Comm: syz-executor312 Not tainted 6.15.0-rc3-syzkal=
ler-00001-g9d7a0577c9db #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_fsck_update_backpointers+0x4ed/0x4f0 fs/bcachefs/fsck.c:979
Code: e9 2b fc ff ff 89 d9 80 e1 07 38 c1 0f 8c 62 fc ff ff 48 89 df e8 63 =
c6 b7 fd e9 55 fc ff ff e8 29 70 ba 07 e8 04 8d 4d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d426460 EFLAGS: 00010293
RAX: ffffffff8475301c RBX: 0000000000000010 RCX: ffff88800081a440
RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000010
RBP: ffffc9000d426600 R08: ffffffff84752c79 R09: 0000000000000000
R10: ffffc9000d426530 R11: fffff52001a84caf R12: ffffc9000d427290
R13: dffffc0000000000 R14: ffff888040e75f00 R15: ffff88803fdb0000
FS:  000055557bb26380(0000) GS:ffff88808c59a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a385eda068 CR3: 0000000043706000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_str_hash_check_key+0x202c/0x3b50 fs/bcachefs/str_hash.c:257
 bch2_str_hash_check_key fs/bcachefs/str_hash.h:415 [inline]
 check_dirent fs/bcachefs/fsck.c:2177 [inline]
 bch2_check_dirents+0x2d45/0x3b90 fs/bcachefs/fsck.c:2272
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:285
 bch2_fs_recovery+0x292a/0x3e20 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x310/0x620 fs/bcachefs/super.c:1065
 bch2_fs_get_tree+0x113e/0x18f0 fs/bcachefs/fs.c:2253
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3881
 do_mount fs/namespace.c:4221 [inline]
 __do_sys_mount fs/namespace.c:4432 [inline]
 __se_sys_mount+0x38c/0x400 fs/namespace.c:4409
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f05363dcf6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe48350348 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe48350360 RCX: 00007f05363dcf6a
RDX: 000020000000f640 RSI: 0000200000000200 RDI: 00007ffe48350360
RBP: 0000200000000200 R08: 00007ffe483503a0 R09: 000000000000f64b
R10: 0000000002a18414 R11: 0000000000000282 R12: 000020000000f640
R13: 00007ffe483503a0 R14: 0000000000000003 R15: 0000000002a18414
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fsck_update_backpointers+0x4ed/0x4f0 fs/bcachefs/fsck.c:979
Code: e9 2b fc ff ff 89 d9 80 e1 07 38 c1 0f 8c 62 fc ff ff 48 89 df e8 63 =
c6 b7 fd e9 55 fc ff ff e8 29 70 ba 07 e8 04 8d 4d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e
RSP: 0018:ffffc9000d426460 EFLAGS: 00010293
RAX: ffffffff8475301c RBX: 0000000000000010 RCX: ffff88800081a440
RDX: 0000000000000000 RSI: 0000000000000010 RDI: 0000000000000010
RBP: ffffc9000d426600 R08: ffffffff84752c79 R09: 0000000000000000
R10: ffffc9000d426530 R11: fffff52001a84caf R12: ffffc9000d427290
R13: dffffc0000000000 R14: ffff888040e75f00 R15: ffff88803fdb0000
FS:  000055557bb26380(0000) GS:ffff88808c59a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a385eda068 CR3: 0000000043706000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
