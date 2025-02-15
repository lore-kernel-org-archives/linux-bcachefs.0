Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E881CC8E0
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 11:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739620761; cv=none; b=AII3K0lW55u/WuQ9L0Pr1qoyqJ+uuHVETR98Z5a8WJetvnXNqwd6XeDT9RAfTj19wKpXDorA3Zq1ru0vFz5EwKe4nLsdJHE84R8NqNNkKmIRg/NVW4CFoz3kVFQZNxVpx7pHAL/co4oUg1KIXK15O706u0Rjr+WMI2m8PLFx7A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739620761; c=relaxed/simple;
	bh=GzwbOxnNTIIa+CJaq6Q0T9xHD5AX+uo+2QoS70Pa9Wo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=aeWsL+VpCBh+64aFC43e7xbAtbqlwdW/h3tVAHMYi3Tt0qxrEWvlCTje9QP8nTUaEZ/57pdRvdb+G48MAb1Ax3HGXZ85wcadHCBClE8lgsXZPPl/WcCeVeq9t+7X+ZWAI//UK7M2ZtDz64K4JJ1XS0GojxcSA4Y8enIqQTPxv80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d2858ce843so2166205ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Feb 2025 03:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739620759; x=1740225559;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEqF9Rnv35V7b/ZktEidU0uHrbWzqMGbHv1UsAi/LY4=;
        b=AgMhJJCarguWxmAFJfbIKt2jsh/26/k2rNQWaefgQ4hAzw37ReAovIUbhABRe6QURo
         xO5aFkuyohQdUQsCM1UGFFn/IKH8G+4d8WS52S7Vjke8BJASZdXtdWlwvgYTol+8YjuK
         UDInawyY8DfDt+xic6NM698Hiu/pAF//+Vm806MZuz7a0kSmWBe0RfRyvrWMtw7TJTl5
         NgPbqJj/KZAI5gJ/CfCZ28jXlgeKPsAQVBrawcDDo750SMuNJf3DCCTsJu6L3qMfvfF1
         1lU8WxNjv12+41XGiJK4RvY+79TAgq51mUkrDaf3qluCITWPhH6yw+nxTvurYL9xe59k
         fj+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV8NRZS9FUxBd3f+BAXONXCSpkb5fS4StQdlsJ/+qMaqnudxx/98Vj26KJOqFt1Ss45Md2YduF2QhzcSfYYUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMUVG0RiJkEaScPiYl8OasZJ4bMdf48eqmlX5hEURU1m2JE2uW
	YrNU0Pg9rzhO/JpP6ZkX2fFsqX05N9R9v6VQ2CUPFN146LkqGPZcAx+4l5jpgbS5dtLaeflj97K
	mrf9fWYQW8CKH2zhX/3QDaA38Wnwh7RUB/oykK8l18EANiHltA99fFyI=
X-Google-Smtp-Source: AGHT+IFZheIveKLyGgDKIJIEP68U47rNgLUeluZuVvNUXC6l6zWEC3koLzK3Wy1ZEgpxGuDHni5VQ+UPmFWedFUlFSYOaYRnVEIG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2610:b0:3d1:78f1:8a86 with SMTP id
 e9e14a558f8ab-3d2809471f1mr22898045ab.15.1739620759104; Sat, 15 Feb 2025
 03:59:19 -0800 (PST)
Date: Sat, 15 Feb 2025 03:59:19 -0800
In-Reply-To: <67a4eae3.050a0220.65602.0002.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b08197.050a0220.6f0b7.0003.GAE@google.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in xas_reload
From: syzbot <syzbot+8ae0902c29b15a27a4ee@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    04f41cbf03ec Merge tag 'sched_ext-for-6.14-rc2-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c799a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=8ae0902c29b15a27a4ee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b8e098580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ece7df980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-04f41cbf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/04aaec67f85e/vmlinux-04f41cbf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b8db5fac3a6/bzImage-04f41cbf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/84576e830d0a/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8ae0902c29b15a27a4ee@syzkaller.appspotmail.com

UBSAN: shift-out-of-bounds in ./include/linux/xarray.h:1604:27
shift exponent 128 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 5383 Comm: syz-executor156 Not tainted 6.14.0-rc2-syzkaller-00228-g04f41cbf03ec #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 xas_reload+0x434/0x470 include/linux/xarray.h:1604
 find_get_entry mm/filemap.c:2032 [inline]
 find_lock_entries+0x2d4/0xbb0 mm/filemap.c:2119
 shmem_undo_range+0x2d4/0x1820 mm/shmem.c:1094
 shmem_truncate_range mm/shmem.c:1224 [inline]
 shmem_evict_inode+0x29b/0xa80 mm/shmem.c:1352
 evict+0x4e8/0x9a0 fs/inode.c:796
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 dput+0x19f/0x2b0 fs/dcache.c:885
 __fput+0x60b/0x9f0 fs/file_table.c:472
 __do_sys_close fs/open.c:1580 [inline]
 __se_sys_close fs/open.c:1565 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1565
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f519f1cefca
Code: 48 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c 24 0c e8 83 83 02 00 8b 7c 24 0c 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 36 89 d7 89 44 24 0c e8 e3 83 02 00 8b 44 24
RSP: 002b:00007f519e977fc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00007f519e977ff0 RCX: 00007f519f1cefca
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f519f25c480 R08: 0000000000000000 R09: 0000000000005931
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f519f25c48c
R13: 00007f519e978030 R14: 0000000000000003 R15: 00007ffe2518a5c8
 </TASK>
---[ end trace ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
