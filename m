Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8453F1AB6EC
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727347771; cv=none; b=guoJFzckLeBd7Qx/KaGgPjudzrxghOCeOa1+O+1CU2AjvAX/YDx1wLV8jswD+zFWIal3o1JJ8Gte6wpdEH697n7mtPolvvorJAniIv1GfQUr21kH16ed3DzvzDmxOEOFMqRxFUc8Eav00linqAMIz92geQ5bdYzPHKQUNfMSaYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727347771; c=relaxed/simple;
	bh=KEawcTrJFiGdBZY0yAY/PMd6jxyoUx+5CAO7Zh1V9R4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OsW8P+dT1lBjDjDds9r1E5AnlSA64dhH+tt4lE6m71bpcNAdw6Ieh6o3Gp8umfipv1Kzvw3lafnZhiIURx7byCVKroCMvMd6R6zCCHZgS/FfP3MIxCpZLsPNp5MLypExx2JLWkirUlXT2yW1gFLwjKT/+EXhWr9pmrCPbxwp734=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0cadb1536so9162585ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 03:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727347768; x=1727952568;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xr3Jdh4lzyM+gHqoLJWzrwPHI0SDfvfxvRci18QnFi0=;
        b=rHGaOcCw9E7H7K/18NM774uBrck6Fh65JDm/8i4VWnwuSa/Xc8a6Qq+ml+4wMYYt8I
         SCUXUtJgNFHUPv7lZz5TjdZKSoozFLpJbsXaBZMHvorheK1OiT/IbUBTCQzZQ31uUFYB
         dRPW41k2fBYhf9SoPU7dao+IL4onNuphlIX+QX2UNt1Y9+95Rs0tCA4YUjIbym1H5eUE
         85P6mvu0aeCJDPaXfqtCK8KUVttgFU/ORntR5MPjuKYngaDchp8YHAqogFK4ExeVbmBb
         F7KEwZH2kjzKRSbY9Fah0cnNXWNaZ8IUVVmCt8bQlFb+smUHwxheJ7SeIVftgSsq4KSc
         ZHuA==
X-Forwarded-Encrypted: i=1; AJvYcCWzDwU2X77fOVJeniH31Vch+9vv9/eNPBunt2GH5Ze2pRu46JxxaaAiePZBkjmQg4gBDFh0LP61bshpsNvoIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUhoKxB3+3tvozSFNcTgnf3KLbwkzH1lP7qdp4tFeYKldplqtv
	fhu8vVz+36BAmY0yn4a0Sw9IZMmLD/aulxMZSBX1KfSsBNtZwmOHRwr1IIcBXIOtdokAYpzGGXe
	/slmkE8SeYMRXt3bvcGJnG6DugR6vyTFmO1XN4P/laA/eLeU2S+bOA4s=
X-Google-Smtp-Source: AGHT+IGoZaOeI4L7kAj69IlfSEUZcwlaeAkURhARdEfyyIisH0G/Zhhb8FuuvGdClg9hZLZjVI1NN75B4Kj4Fk9ZL8vcNXzeCkmJ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca2:b0:3a3:41cf:f594 with SMTP id
 e9e14a558f8ab-3a341cff716mr6694975ab.12.1727347768582; Thu, 26 Sep 2024
 03:49:28 -0700 (PDT)
Date: Thu, 26 Sep 2024 03:49:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f53c38.050a0220.211276.0069.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_alloc_read
From: syzbot <syzbot+a1b59c8e1a3f022fd301@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88264981f208 Merge tag 'sched_ext-for-6.12' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a3de9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e851828834875d6f
dashboard link: https://syzkaller.appspot.com/bug?extid=a1b59c8e1a3f022fd301
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167ddca9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a3de9f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-88264981.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/df2a0a047a7a/vmlinux-88264981.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bbdb25081712/bzImage-88264981.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2bfe5d0e1da4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a1b59c8e1a3f022fd301@syzkaller.appspotmail.com

bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read...
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5100 Comm: syz-executor420 Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_alloc_read+0x17d9/0x24f0 fs/bcachefs/alloc_background.c:625
Code: 0f b6 04 10 84 c0 4c 8d a4 24 b0 02 00 00 49 89 d7 0f 85 78 04 00 00 48 8b 33 48 8b 3c 24 e8 5e 14 00 00 48 89 c3 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 74 04 00 00 0f b6 44 24 30 88 03 48 8b
RSP: 0018:ffffc90002d8f0e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff89011e18963c
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000008100000014
RBP: ffffc90002d8f4c8 R08: ffffffff8409ef0e R09: 0000000000000000
R10: ffffc90002d8f450 R11: fffff520005b1e8c R12: ffffc90002d8f390
R13: 000000000000001c R14: ffffc90002d8f200 R15: dffffc0000000000
FS:  00005555882c4380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558280275240 CR3: 000000001205e000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:230
 bch2_fs_recovery+0x24f9/0x38b0 fs/bcachefs/recovery.c:859
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1956
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c704b9dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd5754dfb8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd5754dfd0 RCX: 00007f0c704b9dea
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffd5754dfd0
RBP: 0000000000000004 R08: 00007ffd5754e010 R09: 002c61746f757172
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffd5754e010 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_alloc_read+0x17d9/0x24f0 fs/bcachefs/alloc_background.c:625
Code: 0f b6 04 10 84 c0 4c 8d a4 24 b0 02 00 00 49 89 d7 0f 85 78 04 00 00 48 8b 33 48 8b 3c 24 e8 5e 14 00 00 48 89 c3 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 74 04 00 00 0f b6 44 24 30 88 03 48 8b
RSP: 0018:ffffc90002d8f0e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff89011e18963c
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000008100000014
RBP: ffffc90002d8f4c8 R08: ffffffff8409ef0e R09: 0000000000000000
R10: ffffc90002d8f450 R11: fffff520005b1e8c R12: ffffc90002d8f390
R13: 000000000000001c R14: ffffc90002d8f200 R15: dffffc0000000000
FS:  00005555882c4380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4c02468cda CR3: 000000001205e000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
   4:	84 c0                	test   %al,%al
   6:	4c 8d a4 24 b0 02 00 	lea    0x2b0(%rsp),%r12
   d:	00
   e:	49 89 d7             	mov    %rdx,%r15
  11:	0f 85 78 04 00 00    	jne    0x48f
  17:	48 8b 33             	mov    (%rbx),%rsi
  1a:	48 8b 3c 24          	mov    (%rsp),%rdi
  1e:	e8 5e 14 00 00       	call   0x1481
  23:	48 89 c3             	mov    %rax,%rbx
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 74 04 00 00    	jne    0x4ab
  37:	0f b6 44 24 30       	movzbl 0x30(%rsp),%eax
  3c:	88 03                	mov    %al,(%rbx)
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


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
