Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC01FBCB6
	for <linux-bcachefs@vger.kernel.org>; Sun,  2 Feb 2025 17:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738518859; cv=none; b=LCvXvwhbYjRVQd5uhl6JBhWDOz1+3xm40mJVwq8WcVXjANkDQ0Tqqp9WPzUowe3i7lQ+GquVzaL4Ptt4GKs2kkFowBkCaHDSpXDzCj+eFQX7DVFUjvEbrDA0iXDZK/tYtYqQrnS+vBg31pjhdt5H1lC6dSCn/UQU4qHJCMlIjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738518859; c=relaxed/simple;
	bh=C06X4MtjwiRfraZHD3TU0nQoXIyrYQNWMoemyoQbVeI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CxaAEyN1MFdyd4gJ9JHwBkdGduAzwtF1l8eYEPuAFhZFEJ/QgTqcvKD+jJZW5R0oMYxQC+JkdxXLOtPPeblEGF0IENaMA0tPZiqi0YFfHUe59eDnCp/WnLLPPsOkhiv86NuQXbgsuKABn3cXdRCxyPpK5krDziAgvNZtjuYa5+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-851c4ef08b9so771563239f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 02 Feb 2025 09:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738518857; x=1739123657;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ih/1gPJKKAmiKdzYU1qzRkBTW9CJ2EZJX0hepwOVEb0=;
        b=stj119qrKMAc1Hn0sCL3URy+dp/OLAzc2s9wYGNmfp2xXNwncYxGs93OcX0QoM96hT
         lroT8HcglKXhk/xq4j615+tohlVNQ3yF2kjIAo1IeVjFQklhilW5eV8SpLfpHAOBoyzZ
         aCFDTj3r9DVdqCOTBijhX8SQwwVTy4ENfiIz35ZP8pTh8SjGQ9TyFFIDbxWzfT98tchy
         TBWmxNU8mPC1pOvbVjsrWmUaPnxRj7lFdJd5YsI7Agg59/W4gDj2Xn4/2hWRj7SHDLR6
         u/ttQ6Vg96yBJ11lVWPXgESDd5vJLy3IvYl3QReBLpCpkSxdQFWdJXdAu/zUd9tQcMYy
         Y5qg==
X-Forwarded-Encrypted: i=1; AJvYcCVQgSd1F0yV0WFpxp3/KcvixlrumQcpXgQwLgyhrh9VkRYKwyJs8Ct3HCYM8djr/ttbs2w1EIpLLI1EGV7ILw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2hMnDxcXM5NCBoE34hws79C9uvrOWvEqVzkptzqwJAgxTarIb
	zrumc58Lt8RHtDZwdvb6/1mKvhSDdVkYUru1ENZWXL5BW+lpvA7g/sFxWKcRK40hKygYOWAJcTG
	iHrK/kCvH+sDqTEyMNV2uvqEANxl7xIMUWNsuvQXJiFNwEL6MkADG4fQ=
X-Google-Smtp-Source: AGHT+IFcF/cldw+QIoy7SuV67XgA86mgrRXel//l1ed8VXiRsBm9rSTA6F+OUCB5jfHrY08qa6kLQ3HmaHYVJtuWU93jMqLiCUnm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:370e:b0:3d0:101e:45e7 with SMTP id
 e9e14a558f8ab-3d0101e47acmr121088825ab.19.1738518856816; Sun, 02 Feb 2025
 09:54:16 -0800 (PST)
Date: Sun, 02 Feb 2025 09:54:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <679fb148.050a0220.d7c5a.0074.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in filemap_get_entry
From: syzbot <syzbot+a0ae55e3dde11d2d790c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17814b24580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=a0ae55e3dde11d2d790c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13877b64580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16063ddf980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-69e858e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a53b888c1f3f/vmlinux-69e858e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6b5e17edafc0/bzImage-69e858e0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/680b2fde83a8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a0ae55e3dde11d2d790c@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/xarray.c:147:16
shift exponent 192 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 2666 Comm: kworker/u4:9 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: loop0 loop_rootcg_workfn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 get_offset lib/xarray.c:147 [inline]
 xas_descend lib/xarray.c:207 [inline]
 xas_load+0x583/0x5c0 lib/xarray.c:246
 filemap_get_entry+0x1f0/0x3b0 mm/filemap.c:1860
 shmem_get_folio_gfp+0x285/0x1840 mm/shmem.c:2446
 shmem_get_folio mm/shmem.c:2628 [inline]
 shmem_write_begin+0x165/0x350 mm/shmem.c:3278
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
 do_iter_readv_writev+0x71a/0x9d0
 vfs_iter_write+0x23e/0x600 fs/read_write.c:974
 lo_write_bvec drivers/block/loop.c:245 [inline]
 lo_write_simple drivers/block/loop.c:266 [inline]
 do_req_filebacked drivers/block/loop.c:520 [inline]
 loop_handle_cmd drivers/block/loop.c:1926 [inline]
 loop_process_work+0x1429/0x21c0 drivers/block/loop.c:1961
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
