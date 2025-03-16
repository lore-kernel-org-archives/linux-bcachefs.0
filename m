Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF4119D890
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 18:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742149713; cv=none; b=o+5MRBErWrNa+1vVbHUa5nBVv5OTJ4e/ItD2HB4NvIKCIRYJCTftqkOZaQAZ0NuyzgQ91lq2Kc3IRO60anxSdh827v1zi2R7oc5TC/FaRkrrhdSUxYrS09qcSqAGGCzU1Iww8VGxi2Ez3p5IwY1OhOlS4R1CtGFA1CvnM3YT9zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742149713; c=relaxed/simple;
	bh=O/23en28hvKXlUKcWLqYD+Nu61JsgdEb/ggpvtZng3g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SUj7cADumuueN7thFC6hHl5mojRH5aSKZMvnPUE7aPYL1JvP5f+aAIypYOUWBhMSp6s9DZd2am8xehNdIY/L0/rsCDi+bK0kz0x9sg4nbJv0X2k0tG0+RQJ7MdPhhnelpKNPoe/WnU588bG0tK7iL6dOh8IoIkw3O91Nf7iE+X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-85dad56a6cbso760829339f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 11:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742149711; x=1742754511;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6wEwCURg/DLt1sNXbiJP0/Zcr1jp6rZUzj+yDk8Diy4=;
        b=oSbGJwCMCTO146t3NL4ytrSnMoU8EeXzpNKnjeAJJi5pP0NsR/974YPuX7DQ7g+kmH
         eDWEMSV+SfGR/5FDb8tePdrjdw14ggb7Ho1Lg5sgbHkL8cHMU6FjZxm66jE12+7svDqT
         DorMN3d8T0fZOnpJEISnVn7YdhsFLfqfGzbadf8EdZfvvvNP6Hu9Tr7RPt4Ua3+fT5V6
         81aMJhq0OpKThOW7h1+fJP32hUEnvBMVeQ6PEgcwhvYnl8244WSLP0cFejGcNMmLAULZ
         F2id2K9W3cb0VxBDIUkg/K5ySzncSCsTiSHvJDy6HdLFxpJY7BAh/PQhIRM1QRJX7GbW
         d1vg==
X-Forwarded-Encrypted: i=1; AJvYcCWKTugRzzpjatSy29bgSbQG9HgZT3OB09IiV7tRQG366kfJl9zlelEFNeJDtUCxDGYjayv+ZFM9aLZefdXQVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDqRMCfL8ddhCFnFPb0j2R9exQzVp16P7bMxH4brJlptaruZHx
	afQLz+D/F09L1JpVE4WRHdeZLx+gh3kXDvYT53IxLjaKksy2fKdRAMJTAgVkEpwu9MTKwr+J9SB
	irVa5Cx5N+4EUvXshw4OFv5iHiMWR/fUb36UHDQOX826qZaFYYVDUj4I=
X-Google-Smtp-Source: AGHT+IGas2Rs8es65QFc8H7gSDaUEjj/Olz0ShtJR3d4EWmB+7RtH18uygx6/uMQZQ3R3CZPeex9QttHtaVeV87WbjyufhVgmsvu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240f:b0:3d4:6dcf:d8f5 with SMTP id
 e9e14a558f8ab-3d4839f46a7mr134579165ab.1.1742149711035; Sun, 16 Mar 2025
 11:28:31 -0700 (PDT)
Date: Sun, 16 Mar 2025 11:28:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d7184f.050a0220.3657bb.0002.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in shmem_undo_range
From: syzbot <syzbot+3ed98178a28b3ce6680c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0fed89a961ea Merge tag 'hyperv-fixes-signed-20250311' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13f24c78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31c94a07ddad0b00
dashboard link: https://syzkaller.appspot.com/bug?extid=3ed98178a28b3ce6680c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a61874580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0fed89a9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9e4d0fd4258e/vmlinux-0fed89a9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea186f3b1240/bzImage-0fed89a9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0ad36b250ea5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3ed98178a28b3ce6680c@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/xarray.c:196:22
shift exponent 240 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 5449 Comm: syz-executor Not tainted 6.14.0-rc6-syzkaller-00016-g0fed89a961ea #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 xas_start+0x772/0x7b0 lib/xarray.c:196
 xas_load+0x2c/0x5c0 lib/xarray.c:239
 xas_find+0x13f/0x960 lib/xarray.c:1273
 find_get_entry mm/filemap.c:2015 [inline]
 find_lock_entries+0x269/0xbb0 mm/filemap.c:2119
 shmem_undo_range+0x2d4/0x1820 mm/shmem.c:1094
 shmem_truncate_range mm/shmem.c:1224 [inline]
 shmem_evict_inode+0x29b/0xa80 mm/shmem.c:1352
 evict+0x4e8/0x9a0 fs/inode.c:796
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 dput+0x19f/0x2b0 fs/dcache.c:885
 __fput+0x60b/0x9f0 fs/file_table.c:472
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fad4c78bdca
Code: 48 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c 24 0c e8 43 91 02 00 8b 7c 24 0c 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 36 89 d7 89 44 24 0c e8 a3 91 02 00 8b 44 24
RSP: 002b:00007fff96e49350 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 00007fad4c78bdca
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fff96e493ac R08: 0000000000000000 R09: 00007fff96e490b7
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000001
R13: 0000555594fa6590 R14: 0000000000022d85 R15: 00007fff96e49400
 </TASK>
---[ end trace ]---


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
