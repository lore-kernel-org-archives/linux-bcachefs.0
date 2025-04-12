Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F00515575C
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 05:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744435711; cv=none; b=YfUib5L2hjw51FL+sfXzHCcY6qEqiZjMdSz6oD0OuQgJpafzpfHizAhJLaeUSCMXghPp6TKYGAeQIh/0UcZUHZvWLu/Y1NfyvLwANmeylPDM9MIg/h/c1dY5GX25LGCIJ6nGK88Dk3jTgpY5y8+dqCjf16F7TEC7IzAMx4JpuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744435711; c=relaxed/simple;
	bh=vsgLSBOTSiRtvtmw2Vo1/bXr0FCm0q0B8MGzMVsCmjY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Y2RpsWYmN4MHxDsHFhocszkQY5qDNYrpslkydKBaFzpyKvSvPhYm963ACF4c+sEj2fla7j0fQ8ZhR39BRBcxIJSWvaa6LAqvXikRF7cOZnp1uTXsa50Q1JhJ4VNh7MgfZ/I5HoeJ6THvuPfDzZ1clfMglZo12fHdBuFkZ27AzDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d438be189bso25174235ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 22:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744435708; x=1745040508;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fshlYPmQ7QdF9X67GnUsOZ/655gHBJtZ94SgllsrcCk=;
        b=Tbz6XGcQ2Qhhg78lriUOCfXKT5wjf1/ZXd9bB6qq+jf4bEG5bopEvzySOeG/JZo2vF
         PaITaQfp/LrT1MfiLbunR0yQiE4CtWu8c3fJZ+87dW96ln5vsOF2J1vfuw9jx43NY9wg
         Dxie+ohrrJ/EM+s22B/vjeGpL5kcrVTU4IDoLML3AvA6CJmVA3NpZYi2Uyceskw5nByW
         3pppF4GOTDInGobuTjZP8X0+vdCPEPJItxP+uumd/gUURKKQ1O19d/Wfl8vj3LFWSuSD
         0VvUIBYqlWKFJKILDYyRC+RfsRLXd9mLjGTtT+PIgjOX/OseBAcorVjrlfEJbDzaHcUQ
         qkIA==
X-Forwarded-Encrypted: i=1; AJvYcCX/WcHLHQeEaXyNJXdRyaurT1J63onCRNZSNNH0XZiH+7zRl7ZVs0Eyd0dfKTG3LTKi0dlQIDIlV7M0Il25Iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFlfZFq7aAPo4nQMfM/zBQJw32Bc01zJpytxjUKlQusirnrE+8
	BCSLjpT4AMBh5B0qKLnmYUJQD4BYQUseK/lufujukHNbS4OCOiNdR2dmS9kPXs5e0ABkVzMCLUI
	j3i9sEqXtwEsXYk4a6kKFSgDUowFWduH5q/p+pt1verC1WYs9mtiMKbw=
X-Google-Smtp-Source: AGHT+IF3p11549MuftLL6BjRV8V0Bletxi5uWDq/cU/7ytMrkj3IzsvM/kEJn2oYBWzmFzQdR/9/OZpHI+NVoVw9nt8I7daxHQm2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2f:b0:3d5:d743:8089 with SMTP id
 e9e14a558f8ab-3d7ec1fd1fdmr57598695ab.7.1744435708585; Fri, 11 Apr 2025
 22:28:28 -0700 (PDT)
Date: Fri, 11 Apr 2025 22:28:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f9f9fc.050a0220.379d84.0006.GAE@google.com>
Subject: [syzbot] [block?] WARNING in bio_alloc_bioset
From: syzbot <syzbot+a7d6ceaba099cc21dee4@syzkaller.appspotmail.com>
To: axboe@kernel.dk, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7702d0130dc0 Add linux-next specific files for 20250408
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17d07a74580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91edf513888f57d7
dashboard link: https://syzkaller.appspot.com/bug?extid=a7d6ceaba099cc21dee4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103f9070580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1489cc04580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0603dd3556b9/disk-7702d013.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d384baaee881/vmlinux-7702d013.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1ac172735b6c/bzImage-7702d013.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/27765a0fbde9/mount_0.gz

The issue was bisected to:

commit f4e35e5f940c0e1ca83ff6274883f7b7eaba04df
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Apr 5 21:36:04 2025 +0000

    bcachefs: RO mounts now use less memory

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a3ed78580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a3ed78580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a3ed78580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7d6ceaba099cc21dee4@syzkaller.appspotmail.com
Fixes: f4e35e5f940c ("bcachefs: RO mounts now use less memory")

bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5831 at block/bio.c:512 bio_alloc_bioset+0xd61/0x1130 block/bio.c:512
Modules linked in:
CPU: 1 UID: 0 PID: 5831 Comm: syz-executor169 Not tainted 6.15.0-rc1-next-20250408-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:bio_alloc_bioset+0xd61/0x1130 block/bio.c:512
Code: db f6 ff 81 ce 00 20 09 00 e8 db dd 3f fd 48 85 c0 0f 84 a1 00 00 00 48 89 c5 e8 0a 55 e1 fc e9 7a f8 ff ff e8 00 55 e1 fc 90 <0f> 0b 90 e9 7b fb ff ff e8 f2 54 e1 fc 90 0f 0b 90 44 8b 7c 24 20
RSP: 0018:ffffc90003f5f050 EFLAGS: 00010293
RAX: ffffffff84e1f000 RBX: 0000000000000000 RCX: ffff888021b29e00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff84e1e304 R09: 1ffffd4000143e38
R10: dffffc0000000000 R11: fffff94000143e39 R12: 0000000000000100
R13: 0000000000000cc0 R14: 0000000000000001 R15: 0000000000000100
FS:  0000555556118380(0000) GS:ffff888125089000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdad858000 CR3: 000000007ed30000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_writepage_io_alloc fs/bcachefs/fs-io-buffered.c:510 [inline]
 __bch2_writepage+0x1624/0x2780 fs/bcachefs/fs-io-buffered.c:644
 write_cache_pages+0xd2/0x240 mm/page-writeback.c:2613
 bch2_writepages+0x158/0x390 fs/bcachefs/fs-io-buffered.c:675
 do_writepages+0x38c/0x640 mm/page-writeback.c:2635
 filemap_fdatawrite_wbc mm/filemap.c:386 [inline]
 __filemap_fdatawrite_range mm/filemap.c:419 [inline]
 filemap_write_and_wait_range+0x2ac/0x3d0 mm/filemap.c:691
 bchfs_truncate+0x77c/0xc60 fs/bcachefs/fs-io.c:-1
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate+0x222/0x310 fs/open.c:65
 vfs_truncate+0x4a6/0x540 fs/open.c:115
 do_sys_truncate+0xd8/0x190 fs/open.c:138
 __do_sys_truncate fs/open.c:150 [inline]
 __se_sys_truncate fs/open.c:148 [inline]
 __x64_sys_truncate+0x5b/0x70 fs/open.c:148
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f504c2996b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdad857aa8 EFLAGS: 00000246 ORIG_RAX: 000000000000004c
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f504c2996b9
RDX: 00007f504c2989b0 RSI: 0000000000000002 RDI: 0000200000000800
RBP: 0000200000000000 R08: 00000000000058fd R09: 0000000000000000
R10: 00007ffdad857970 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffdad857c88 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


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
