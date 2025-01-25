Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CC22063C3
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 Jan 2025 03:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737775768; cv=none; b=C1oWwW2V0yPfDEqmzkqPypKI9cLXH3cwhbIE0COs8qSoSP42RL6EEJpP+eEpErRqqxOlZIw1ev8kFq9I8nBit1+cuB4EO3ITjIsA8hpJa5UOaZO5xtb6Zx0HNHta/+F0Vz1EG7uhWdzqfJ1cxJZ8xAkc9vSS29AHBd8yx01qPwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737775768; c=relaxed/simple;
	bh=mJAjsc/iYl3QH/BxVrmYNfUVQE4U8QAEAquTCO7DUq0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Sln8JxLdlA5mrSvE9Mv/D9z269y9upPGYuyIZKRftTenrFcZwERiChEdCkliP6yxZk9nhzM0t/fDQI6FGYSHm4vuZtZ9Jnjqs3jEHqYr7EjR/n74ei7UKLmePhfZfXh5tGeoMZwOZrg/juDKt24jST5mPl5HaBJNqxWAgc8sKq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so18249385ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 Jan 2025 19:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737775766; x=1738380566;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+IfOume9Y64Al63SLr5Fj6P7ZxyT4FhTBO2YwEtZrZQ=;
        b=XnOGITLfc1hslzwOUF+c7e08XwCFJSVjl8dEcssOxUMMIpCEDYAWQOVcw61WVzXer4
         nrdav4YAryoVKd9Lsr7h7BnlIvf0sF+0h8qeBLUJ2AAciJCPHHDuw9WeBPhDtpfBJtP/
         ObOcMxZdrUXkj2XaQUf/2TQaa9ZpgHAoC+sFkBhnozawToqRePXoRAmJiE93Hw0dFVEV
         BX0UZ86jfOrp0DBIZLXaP0AHpLMuRb235bfJD+H8hPtDSRZ8pdIc0zfqlWky2FfGhU/l
         qwlEvP49/djlJ5nSIYJAHrnTC20LmkbB7QTbUsrmaftyJyYj/2se7A4Yj/DDw2Uyz+R7
         BvQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUl9E69d1yclnwa+RAxF8ojXk7jS9cG7Vn3ILOs8bBxZKQf26NKZeC2YgYFs+CbWVfCMzPLEt9FUfwTjU6EgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwZPtSOKyPX81YauZhEaydF0ijdLpBBSPw4kndjbZ0CYntVzXB
	GnYstMzF9CutlWa+W+1BVFuMuNc2y56Av0+82wEIuyajjiDw6ndQuqwt86J4ZWQjvq8OX5DdaoL
	icGK6U0KPwkgbIxTHnNpyisrwd+A13h9AzInvsvXML15olSv6Jg4THeU=
X-Google-Smtp-Source: AGHT+IFFnRch23GQqlRRlPe4ytoBqwv5BqTNiVqHptydkPLZWkzUpeg4eSTNr6j0wCpIi3OJcyvr1NEw45FsFdc6mSBBjnVMtgaQ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c263:0:b0:3cf:c8bf:3b6e with SMTP id
 e9e14a558f8ab-3cfc8bf3c72mr50091415ab.3.1737775765744; Fri, 24 Jan 2025
 19:29:25 -0800 (PST)
Date: Fri, 24 Jan 2025 19:29:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67945a95.050a0220.2eae65.0023.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_subvolume_delete
From: syzbot <syzbot+2875f6362e0214a32381@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c4b9570cfb63 Merge tag 'audit-pr-20250121' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120c1824580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d46425e33fe266e
dashboard link: https://syzkaller.appspot.com/bug?extid=2875f6362e0214a32381
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125c3618580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11de5964580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c4b9570c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/731d6adef14e/vmlinux-c4b9570c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fba145e47ede/bzImage-c4b9570c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/875e2f608701/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2875f6362e0214a32381@syzkaller.appspotmail.com

bcachefs (loop0): scanning for missing backpointers in 4/128 buckets
 done
bcachefs (loop0): reconstruct_snapshots... done
bcachefs (loop0): check_subvols...
subvolume 1 points to missing subvolume root 4096:4294967295, fixing
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5303 Comm: syz-executor216 Not tainted 6.13.0-syzkaller-02526-gc4b9570cfb63 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_subvolume_delete fs/bcachefs/subvolume.c:444 [inline]
RIP: 0010:bch2_subvolume_delete+0x24bc/0x3bb0 fs/bcachefs/subvolume.c:468
Code: 89 ef 48 8d b4 24 40 04 00 00 e8 bf 41 cc ff 4d 85 ff 75 9d e8 15 d9 49 fd 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 63 12 00 00 45 8b 34 24 44 89 f7 8b 5c 24
RSP: 0018:ffffc9000d0be760 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffff799 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000d0bebae
RBP: ffffc9000d0bee30 R08: ffffc9000d0bebad R09: 0000000000000000
R10: ffffc9000d0beba0 R11: fffff52001a17d76 R12: 0000000000000000
R13: ffff88804351c000 R14: 0000000000000000 R15: fffffffffffff799
FS:  000055557ca05380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000565245a9fa40 CR3: 000000003407e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 check_subvol fs/bcachefs/subvolume.c:115 [inline]
 bch2_check_subvols+0x1cac/0x3d80 fs/bcachefs/subvolume.c:163
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:937
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1030
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f95e107326a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde9323ca8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffde9323cc0 RCX: 00007f95e107326a
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffde9323cc0
RBP: 0000000000000004 R08: 00007ffde9323d00 R09: 00000000000058fc
R10: 0000000001000000 R11: 0000000000000282 R12: 0000000001000000
R13: 00007ffde9323d00 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_subvolume_delete fs/bcachefs/subvolume.c:444 [inline]
RIP: 0010:bch2_subvolume_delete+0x24bc/0x3bb0 fs/bcachefs/subvolume.c:468
Code: 89 ef 48 8d b4 24 40 04 00 00 e8 bf 41 cc ff 4d 85 ff 75 9d e8 15 d9 49 fd 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 63 12 00 00 45 8b 34 24 44 89 f7 8b 5c 24
RSP: 0018:ffffc9000d0be760 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffff799 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9000d0bebae
RBP: ffffc9000d0bee30 R08: ffffc9000d0bebad R09: 0000000000000000
R10: ffffc9000d0beba0 R11: fffff52001a17d76 R12: 0000000000000000
R13: ffff88804351c000 R14: 0000000000000000 R15: fffffffffffff799
FS:  000055557ca05380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005621c7fab0f8 CR3: 000000003407e000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 ef                	mov    %ebp,%edi
   2:	48 8d b4 24 40 04 00 	lea    0x440(%rsp),%rsi
   9:	00
   a:	e8 bf 41 cc ff       	call   0xffcc41ce
   f:	4d 85 ff             	test   %r15,%r15
  12:	75 9d                	jne    0xffffffb1
  14:	e8 15 d9 49 fd       	call   0xfd49d92e
  19:	4c 89 e0             	mov    %r12,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 63 12 00 00    	jne    0x1299
  36:	45 8b 34 24          	mov    (%r12),%r14d
  3a:	44 89 f7             	mov    %r14d,%edi
  3d:	8b                   	.byte 0x8b
  3e:	5c                   	pop    %rsp
  3f:	24                   	.byte 0x24


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
