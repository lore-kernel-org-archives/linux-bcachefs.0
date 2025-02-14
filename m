Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5074B192B95
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 19:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739559802; cv=none; b=VekrYPngKWUUPmuRS8GCoIlYrpI40m8WR3f61AFPQEqbSP0wG1BUYBf1n9bE2mDAdJOo1c4Z2if8OnEwi3sl8T4lilUTyycvnReGDwcupxxvJA4yLbDDNLGS14rLK64XLS/zyARc+RLeq7U9lBNWQl1wHwwPqecRjCmGL02auIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739559802; c=relaxed/simple;
	bh=LzPHQhDzpvp48VwnmU/0YO7/c2pZASju1ajipcpGA/E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ssz+ywodjCEibYo5oEclgWIvmEz+URl29SGz2gSuNlaRwEo8iaJ9Xo6+cTa0E2RRvvXEi6rJ/JZwpz8djgof5g5pnYNrop/6mHv8ZpyW/unOCkm8WXfEb3tamNiqox+cOqGWT7gMWHQC4yICE21A2EvMmu9q8bpPvOVvIWTIfyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d18a1a0f0eso46553205ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 11:03:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739559799; x=1740164599;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ozsTo1EMbkvLjAprOo6XEaeUGMGcNs59zEx3LNPFyeI=;
        b=jfxQmhIaCST1xnLgO3CQX1WTVKZuOOqXa3acJL3wRLbP/r4ACLHCgLidVUlEhdrp6I
         JZ4Yv2ygJM+nJAOpHjIuI8tIFxcy0CKf8+b+1EWeJ+g1ca1lnkGcyI4zVtSZRL6hXT9h
         OfzYAuEqwPVsGl7OZ1EX2eVjG5M0DHbWUsbIOoMMqug4yriUu+LwayuwVpdHf9K64liZ
         1jEBnWPSAzeCmbQRKE4rJqsVO9mYJ2Dy4lEbBPPyd+465MZPXru9zeBmrh7w/oTSMfYw
         ppIFh2+57B3fX/aqUJViKMKzvtX5aaSSZIqFfS81dN0pZQzRK/hFIRcxLFHnRRfAGbGv
         /SzA==
X-Forwarded-Encrypted: i=1; AJvYcCW71nzg1JfLa9nrk/ANsDDnNxiVVyK5fmEe0J5oGKF/dFRmGoX4mpv4cNrHSevakJhXuWM+sSTjNxe8CwsUNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw2huPRkrT3AMP+1QfEKd0hsJmXDBx97+3cl4zX+F//udHNyAx
	+OYYRTZg28GXRazL+iiPOc337ltDACbxnDtqtxrVM9qE4e3vAI0oEeSQYo77XY7A/j5TEJtBTA4
	79yPJHBp0J90W5VN1AYk6Q1cwbLV1O0yPUZsj95ISkezaVVRjz7Lz92g=
X-Google-Smtp-Source: AGHT+IEFzCBbA/CTRaoj68hjY8/AOfMM8idDhjdvbl1mZo6uamjfvugUlqnTB0xzPuuwxqJa0NuNyBXklCGOHb/J6biX4rnmlJTW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148d:b0:3d1:a75e:65f6 with SMTP id
 e9e14a558f8ab-3d280949290mr4406545ab.18.1739559799439; Fri, 14 Feb 2025
 11:03:19 -0800 (PST)
Date: Fri, 14 Feb 2025 11:03:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67af9377.050a0220.21dd3.004e.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in
 bch2_btree_cache_scan (3)
From: syzbot <syzbot+fadf17c17d4661618afc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12038f18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=fadf17c17d4661618afc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmlinux-128c8f96.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f451cf16fc9f/bzImage-128c8f96.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fadf17c17d4661618afc@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffe8fffebdf038
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 1b03f067 P4D 1b03f067 PUD 1ed1a067 PMD 1ac49067 PTE 0
Oops: Oops: 0002 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 80 Comm: kswapd1 Not tainted 6.14.0-rc2-syzkaller-00185-g128c8f96eb86 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_cache_scan+0xb57/0xec0 fs/bcachefs/btree_cache.c:563
Code: 24 38 0f 85 12 02 00 00 44 21 2a 48 81 c3 48 b6 04 00 48 89 d8 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 bc 08 e2 fd 48 8b 03 <65> 48 ff 40 38 41 80 3c 2e 00 74 08 4c 89 ff e8 a5 08 e2 fd 49 8b
RSP: 0018:ffffc9000125f2c0 EFLAGS: 00010246
RAX: 0000607fdefdf000 RBX: ffff88805804b648 RCX: ffffffff8c0998c7
RDX: ffff8880334a802c RSI: 0000000000000008 RDI: ffffc9000125f240
RBP: dffffc0000000000 R08: ffffc9000125f247 R09: 1ffff9200024be48
R10: dffffc0000000000 R11: fffff5200024be49 R12: 0000000000000003
R13: 00000000fffbffff R14: 1ffff9200024beb5 R15: ffffc9000125f5a8
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffebdf038 CR3: 000000000e938000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_shrink_slab+0x72d/0x1160 mm/shrinker.c:437
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
 shrink_one+0x43b/0x850 mm/vmscan.c:4868
 shrink_many mm/vmscan.c:4929 [inline]
 lru_gen_shrink_node mm/vmscan.c:5007 [inline]
 shrink_node+0x379b/0x3e20 mm/vmscan.c:5978
 kswapd_shrink_node mm/vmscan.c:6807 [inline]
 balance_pgdat mm/vmscan.c:6999 [inline]
 kswapd+0x20f3/0x3b10 mm/vmscan.c:7264
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
CR2: ffffe8fffebdf038
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_cache_scan+0xb57/0xec0 fs/bcachefs/btree_cache.c:563
Code: 24 38 0f 85 12 02 00 00 44 21 2a 48 81 c3 48 b6 04 00 48 89 d8 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 bc 08 e2 fd 48 8b 03 <65> 48 ff 40 38 41 80 3c 2e 00 74 08 4c 89 ff e8 a5 08 e2 fd 49 8b
RSP: 0018:ffffc9000125f2c0 EFLAGS: 00010246
RAX: 0000607fdefdf000 RBX: ffff88805804b648 RCX: ffffffff8c0998c7
RDX: ffff8880334a802c RSI: 0000000000000008 RDI: ffffc9000125f240
RBP: dffffc0000000000 R08: ffffc9000125f247 R09: 1ffff9200024be48
R10: dffffc0000000000 R11: fffff5200024be49 R12: 0000000000000003
R13: 00000000fffbffff R14: 1ffff9200024beb5 R15: ffffc9000125f5a8
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffebdf038 CR3: 000000000e938000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	24 38                	and    $0x38,%al
   2:	0f 85 12 02 00 00    	jne    0x21a
   8:	44 21 2a             	and    %r13d,(%rdx)
   b:	48 81 c3 48 b6 04 00 	add    $0x4b648,%rbx
  12:	48 89 d8             	mov    %rbx,%rax
  15:	48 c1 e8 03          	shr    $0x3,%rax
  19:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  1d:	74 08                	je     0x27
  1f:	48 89 df             	mov    %rbx,%rdi
  22:	e8 bc 08 e2 fd       	call   0xfde208e3
  27:	48 8b 03             	mov    (%rbx),%rax
* 2a:	65 48 ff 40 38       	incq   %gs:0x38(%rax) <-- trapping instruction
  2f:	41 80 3c 2e 00       	cmpb   $0x0,(%r14,%rbp,1)
  34:	74 08                	je     0x3e
  36:	4c 89 ff             	mov    %r15,%rdi
  39:	e8 a5 08 e2 fd       	call   0xfde208e3
  3e:	49                   	rex.WB
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
