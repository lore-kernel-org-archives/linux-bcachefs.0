Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192AB192D76
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 07:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778866; cv=none; b=C7+MzLsr3s8ctEvWbGbyb755sfD7TL+69061F4luqKQiTbNEDymH/IP9+LQZQ59hCHUhb5iW5oHifqlwaexVfQG/jYhU2yJrUPaJqQQktMbC07jI5z18gztLPx0ZEF3UmSGD17XO0vjG8sVMdj4XNyJA9OOc3bb8b22Vzbdrd18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778866; c=relaxed/simple;
	bh=H5i6IEVX+AjIQ8LY27vwrnHOw4dfiLJ6SLYK5CERd0w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UT195O4hcjQmmbLdf7Pd1vICLOUwNMd5sU+knG74ebNlwAANbmitGz87gMshHW/Jwk4RzMpu0XTQPlaCaa81om9kOOsHhtfyZgibJaSMrCq9qRq4YlZaEw8+WeEkT82jmjTOcueDYLuYOnkBnuxHLa9ghUIOtLoAW/Gc+MRkgm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d187cab068so67456685ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 23:54:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739778864; x=1740383664;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rOlsuRFtx0/zGFL1Oincjqd19yiWnsfzR0lZUprZ9E=;
        b=mpS0pbGzcFXFtFa7lRISloUl3lj0eSGvNmtKja9ZEW3XLV/gArizJo+ykeFAkcsaBD
         O6Pid/W5cAoMtxIeLUHtwZQo6KbWvM69eTZglGH6PuM3DCqWhM9dx0x8NmYFLXQrn7o4
         TRaWeh0LMVV9bY7yFjcLqDi1ZcadcChjTJFLTGF3DnCTnPZ5UYXAtqk0Lzs2btCncUO7
         M/cpJd5WFoPDr3w2Lq2N/A8rwR0PEzAg7Qhvxdn61Qxwgo9a+s2kHbV0Fvf4a7zTQpXd
         oVPnhSLWHskG9DmiOGLwx8ORIPBo/uQle4qi+h8z/3v4TMfgM84cV98nriyAKiUIC99u
         wpIw==
X-Forwarded-Encrypted: i=1; AJvYcCXsA1Kf9I/Gzugt6KXpTfsg+FNnlkLfgGOZ9F3yNSh5VnnXQk1FRLJlu6G9CtcL5hESkz1e5vtCvG0FZcrzgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ+xHqKDtwUas+TaucUe5yKuKjLmBHAnMpE7siQ/rMEKTeyexY
	M2BH90kM3lmCAUaG5FwTSCqc2GbQEIQHxtKiCVOk8sCvYwtdNKB6xtOKeDlWI3l/rtSGgslthTM
	lKiP2EpsocG9uo3fzZB5LUNksbiEetHrC34m8MbU2lXN22F+aVjuoD+4=
X-Google-Smtp-Source: AGHT+IGGBj7LAuxNKF5rf+N1GnpRu6O3eIsCt4HfXTqoEImfaIX3kgRyhpoZkGLhnoEb5TnxlSKUFDTqgpmAYwCG5RJ5MPRGNmYk
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240b:b0:3d0:e52:7d33 with SMTP id
 e9e14a558f8ab-3d2809d114bmr84745465ab.22.1739778864312; Sun, 16 Feb 2025
 23:54:24 -0800 (PST)
Date: Sun, 16 Feb 2025 23:54:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2eb30.050a0220.173698.0021.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] WARNING in workingset_update_node
From: syzbot <syzbot+345b4f219a355c967850@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ad1b832bf1cf Merge tag 'devicetree-fixes-for-6.14-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17fd0898580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=345b4f219a355c967850
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a717df980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ad1b832b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/64103cb6fc45/vmlinux-ad1b832b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9bc34ac014d0/bzImage-ad1b832b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d24d8142c574/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+345b4f219a355c967850@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5609 at mm/workingset.c:627 workingset_update_node+0x1ca/0x230 mm/workingset.c:627
Modules linked in:
CPU: 0 UID: 0 PID: 5609 Comm: syz.3.19 Not tainted 6.14.0-rc2-syzkaller-00303-gad1b832bf1cf #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:workingset_update_node+0x1ca/0x230 mm/workingset.c:627
Code: 48 c7 c7 c0 1a 6a 9a 4c 89 fe e8 71 7c ff ff 4c 89 f7 be 09 00 00 00 5b 41 5c 41 5e 41 5f 5d e9 5c d9 fa ff e8 47 6a b5 ff 90 <0f> 0b 90 e9 d0 fe ff ff 48 c7 c1 10 10 3d 90 80 e1 07 80 c1 03 38
RSP: 0000:ffffc90002d2f2e0 EFLAGS: 00010093
RAX: ffffffff820c4df9 RBX: 0000000000000000 RCX: ffff888036a94880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002d2f480 R08: ffffffff820c4cbe R09: fffff520005a5e54
R10: dffffc0000000000 R11: ffffffff820c4c30 R12: dffffc0000000000
R13: dffffc0000000000 R14: 000000000103582c R15: ffff888040d60b00
FS:  0000555581bbe500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30320000 CR3: 00000000595e4000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xas_update lib/xarray.c:356 [inline]
 update_node lib/xarray.c:764 [inline]
 xas_store+0xb89/0x1870 lib/xarray.c:851
 __filemap_add_folio+0xab1/0x1320 mm/filemap.c:925
 filemap_add_folio+0x155/0x380 mm/filemap.c:981
 page_cache_ra_unbounded+0x40c/0x820 mm/readahead.c:276
 do_sync_mmap_readahead+0x4a6/0x990
 filemap_fault+0x89e/0x16c0 mm/filemap.c:3447
 __do_fault+0x135/0x390 mm/memory.c:4977
 do_shared_fault mm/memory.c:5456 [inline]
 do_fault mm/memory.c:5530 [inline]
 do_pte_missing mm/memory.c:4047 [inline]
 handle_pte_fault mm/memory.c:5889 [inline]
 __handle_mm_fault+0x220a/0x70f0 mm/memory.c:6032
 handle_mm_fault+0x3e5/0x8d0 mm/memory.c:6201
 do_user_addr_fault arch/x86/mm/fault.c:1337 [inline]
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x459/0x8b0 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7fd5b7c63c6b
Code: 00 00 00 48 8d b8 c8 fe ff ff e8 e0 50 0c 00 85 c0 0f 85 14 fb ff ff 48 8b 44 24 68 8b b4 24 98 00 00 00 89 30 e9 01 fb ff ff <89> 32 e9 d0 ef ff ff 48 8d 05 37 2b 23 00 48 8d 3d a0 1a e7 00 c6
RSP: 002b:00007ffd4aede840 EFLAGS: 00010246
RAX: 000000000003fde8 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000001b30320000 RSI: 0000000000040000 RDI: 00007fd5b7e967b0
RBP: 0000000000000000 R08: 0000000000000008 R09: 00007ffd4aede586
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 00007fd5b7f76260 R14: 0000000000000003 R15: 00007ffd4aedeaf0
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
