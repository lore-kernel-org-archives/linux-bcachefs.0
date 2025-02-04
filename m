Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96001215074
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Feb 2025 15:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683269; cv=none; b=aLgX2oFbHVYcmrLip/s7zBq5pJ1T/9VIfTwkDNmYSnZLMtKf4G5fmgRwkDnXA6gTT0p5aRhfm1oQC0wcRnWu3a56NkB+PshR/IJfHGdArRaRiFa182hMIXGyxrVALOQs3PDS13txI1XTvxIz0bmo9GMSEYAVNvIgXFVdz3YqFWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683269; c=relaxed/simple;
	bh=vFVKqLM12bLppHqtfvlxG0He9/Hds1mXRHtYYyuSE/o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ljLQ90krv86tRGF60eGmBdo+kkQO5DNHwxlQfJXW9wwooUiSWxHMZU3oSfXGjgA4HqauKWm3C/C7aGe/appsYkxRaM6lf4IHRXtwDfNiws9+laE9MxDlu055YlLuP527pS5gML3BGIPfOWJ8xDRWGgz5ensx/yFMEaDd+H0DOXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d00fe9f7b3so92916495ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 07:34:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738683266; x=1739288066;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sTyxJH1n+oqeEDYjwt7rZFUHPv1cNoPQYcBLTwj9yNM=;
        b=trppgice48lNj4RSMB3li8i1bb9zOubdVct6SLA26LkVJqpitnsZQkhHagNDZIY0Wh
         kRNpbRUSUSPi8Bv5Z2E+JRy5OF3diU1hS5UoYgvfEnoD2ivWo17O6D8R+1vZj3UigVJK
         /uI3SwFmEISqfzx7ANymiMxddebtDIJFJDo6jT1iV/4HIYK9dF96W7SMhIN1R1MsY8Xl
         Z7KPpmMZnV6Sip9QGb+3LdWzkztPtZ+Htd/oZXT9C8/zcrmefajqRyVFYgc0jAjPG15x
         iholrtCnEiJ92c8Rrc4DfnZ5RXn8Ko6oCSrfYdNPI/yP88GSkdXlQNo4yTr2QSa7Rsme
         vomA==
X-Forwarded-Encrypted: i=1; AJvYcCUsHAslX7I1RBsOvwCooXugLP2d0nXPbfb25RnGxZ9iqa5m4181eJdnQGecCF8oZy2ZL5iRjqiaLWiQsWEMIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjstWkGUhoLHUlNhKuQfSW1LAJDsSvUkEI3UriaXQWXNvx+QmF
	Prauc5kad8Kxv7Ptbqm3FuROHys9/FW06p+zANTGkFVct/Ygp9XXIcyGoPtiruqQrN/M0rtjJI4
	HDzFY7X7EkkaCVzRWAINNZXu1H5Mc90Za7UNGE6svKQpd7zn4If5lpCA=
X-Google-Smtp-Source: AGHT+IE+sxeh4zcmbP0uDKdN/YL35hQL+fHqquCuQWuMS3tm3/AqKWi3uK4P7CEyn51KfuiHrBU//kw8uqzwVHfEtVpnatdlRWgw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240b:b0:3d0:443d:a5a4 with SMTP id
 e9e14a558f8ab-3d0443da8bbmr19294865ab.2.1738683266494; Tue, 04 Feb 2025
 07:34:26 -0800 (PST)
Date: Tue, 04 Feb 2025 07:34:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a23382.050a0220.d7c5a.00bd.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in shmem_add_to_page_cache
From: syzbot <syzbot+07392c132f11b1758ac3@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=145b6d18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=07392c132f11b1758ac3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160983df980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-69e858e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a53b888c1f3f/vmlinux-69e858e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6b5e17edafc0/bzImage-69e858e0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/dfc78a0e5edb/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+07392c132f11b1758ac3@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/xarray.c:196:22
shift exponent 66 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 5744 Comm: syz.3.50 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 xas_start+0x772/0x7b0 lib/xarray.c:196
 xas_find_conflict+0x14b/0xd20 lib/xarray.c:1430
 shmem_add_to_page_cache+0x81e/0xcc0 mm/shmem.c:889
 shmem_alloc_and_add_folio+0x968/0x1090 mm/shmem.c:1928
 shmem_get_folio_gfp+0x621/0x1840 mm/shmem.c:2522
 shmem_get_folio mm/shmem.c:2628 [inline]
 shmem_write_begin+0x165/0x350 mm/shmem.c:3278
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f17fe98b85f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 92 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 4c 93 02 00 48
RSP: 002b:00007f17ff803df0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000001000000 RCX: 00007f17fe98b85f
RDX: 0000000001000000 RSI: 00007f17f5600000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000005939
R10: 0000000020005b42 R11: 0000000000000293 R12: 0000000000000003
R13: 00007f17ff803ef0 R14: 00007f17ff803eb0 R15: 00007f17f5600000
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
