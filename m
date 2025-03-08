Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7FBA55
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Mar 2025 00:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741392026; cv=none; b=dng2+dfadA5EpyAOhJlQobEGTGlmWIfi3PnuNa4oiR4xZYuBB7E8Wy3RdaA3PgoHLpGSHILLaTyYdfs0uMKWWXdh/krwutAIJrcC2Eu5+2isxO5uj09y5vk3nnu33EJth/fnBnPHMCAE08LS3KDDh2macBoZ5yuWq1EKv7CHA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741392026; c=relaxed/simple;
	bh=PqeRCfCOt3IqwQkNHrSSUNElfR90VfB1ojffiwTjlZQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=DOZUBWHxOi5EaxhDOtzn46tQaHITF3sISaSI+QAYijerAzscRmnexh9GSl30pmnJuHZsNdqV+7rnUMN3MVutmwhAJEfml5A4ckl2NS84mqKgJGwNAg3XEy5RkRLZ6j+nYRehNhm4Gbfd/QbSbQQKk8evpiQTZMGACy6to2L44Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-85aec8c95efso205158639f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Mar 2025 16:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741392024; x=1741996824;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EmyCjvl4yLKn40ekfPHqv7O9qpyCsq4OqgixO6uvnA=;
        b=BR4HjClohlQrKcinctmbEOewWcLBll0KT4cMqNZnWMYXUxSUZtmGwetE4PP3YXCg5s
         HJlaNNoMPnTC5T3FKYlC+/zKhVC3aXIwyNZir+blxWZqXyJ2zhCXTDGE9vHMgi8l8hGN
         q24aOZHy3XNe7u3JKjYahygqofDyUbXzFbQ4OyNL4NxS7wU/wpBKLlVpLQBKh9Iu8J9+
         Lh7/EUwRzAOBHRJ42o+1SMYk7E08HUScqwOt2YXDq3yBTaDJ3dxrbN09VTBbEj+2CGJO
         TzDc5C+QPOMbx/dcRaPd03eX8J1U9tf8yBqmV9/2Tcgu7WSJGoVKw3ahXl5XYomSsaox
         emFg==
X-Forwarded-Encrypted: i=1; AJvYcCWFgejwbV2GERnYmmhFxsFA+F+LxlRue+GsawWZ3RVnzyQx4ZCIg2q+r7qHgZ9JrWDW3trOPCp9MsjPw6JD+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXzftbcjW5M37o9UfAAgLfEny9g70bAxOMq08Q/ynfGXMDjjRV
	FWgd0QOLYT21TvoAoJgcbgVD5xsTYGzVB61ScwTmGldEnQrkGpyUL0EPE7/waK53LSHLy5kMKbs
	o7OasqvW8hKZifvQ4FRGh+PiJaP/2omceRmZaRgOFX0ytz3s4zTF0NnY=
X-Google-Smtp-Source: AGHT+IEQzEb9Gl2x2dSjFHuit5MUQIoDN9+CNQbCbMkZqz6ntuZPDFR8N0OBNVtbTnTUkw3ZmU0ddHdsJBSRZukoinANO9bIrd95
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b26:b0:3d4:3a45:d889 with SMTP id
 e9e14a558f8ab-3d441a06f59mr51284945ab.14.1741392024217; Fri, 07 Mar 2025
 16:00:24 -0800 (PST)
Date: Fri, 07 Mar 2025 16:00:24 -0800
In-Reply-To: <675e8eec.050a0220.37aaf.00f4.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb8898.050a0220.d8275.0229.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_checksum_update (2)
From: syzbot <syzbot+60ea31958b52b09e04af@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    00a7d39898c8 fs/pipe: add simpler helpers for common cases
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1334c878580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
dashboard link: https://syzkaller.appspot.com/bug?extid=60ea31958b52b09e04af
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c56a54580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1158e4b7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e8b5895e19ac/disk-00a7d398.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4ba923545cbc/vmlinux-00a7d398.xz
kernel image: https://storage.googleapis.com/syzbot-assets/820c28b7d351/bzImage-00a7d398.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f69b61b5c375/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60ea31958b52b09e04af@syzkaller.appspotmail.com

bcachefs (loop0): dropping and reconstructing all alloc info
==================================================================
BUG: KASAN: use-after-free in crc64_be+0x131/0x1f0 lib/crc64.c:58
Read of size 1 at addr ffff888072e00000 by task syz-executor238/5820

CPU: 1 UID: 0 PID: 5820 Comm: syz-executor238 Not tainted 6.14.0-rc5-syzkaller-00137-g00a7d39898c8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 crc64_be+0x131/0x1f0 lib/crc64.c:58
 bch2_checksum_update+0x10f/0x160 fs/bcachefs/checksum.c:89
 bch2_checksum+0x37e/0x780 fs/bcachefs/checksum.c:226
 bch2_btree_node_read_done+0x155c/0x6180 fs/bcachefs/btree_io.c:1100
 btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
 bch2_btree_node_read+0x2433/0x29f0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1789 [inline]
 bch2_btree_root_read+0x626/0x7b0 fs/bcachefs/btree_io.c:1811
 read_btree_roots+0x3d3/0xa70 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x260f/0x3de0 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8317bc351a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffec09d9368 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffec09d9380 RCX: 00007f8317bc351a
RDX: 00004000000000c0 RSI: 0000400000000000 RDI: 00007ffec09d9380
RBP: 0000400000000000 R08: 00007ffec09d93c0 R09: 0000000000005950
R10: 000000000100000a R11: 0000000000000282 R12: 00004000000000c0
R13: 00007ffec09d93c0 R14: 0000000000000003 R15: 000000000100000a
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x72e00
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0001cb8108 ffffea0001dfa708 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xcc0(GFP_KERNEL), pid 1, tgid 1 (swapper/0), ts 15177598220, free_ts 16347346247
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
 split_free_pages+0xe1/0x2d0 mm/page_alloc.c:6355
 alloc_contig_range_noprof+0x10eb/0x1770 mm/page_alloc.c:6532
 __alloc_contig_pages mm/page_alloc.c:6562 [inline]
 alloc_contig_pages_noprof+0x4b3/0x5c0 mm/page_alloc.c:6644
 debug_vm_pgtable_alloc_huge_page+0xaf/0x100 mm/debug_vm_pgtable.c:1084
 init_args+0x83b/0xb20 mm/debug_vm_pgtable.c:1266
 debug_vm_pgtable+0xe4/0x590 mm/debug_vm_pgtable.c:1304
 do_one_initcall+0x248/0x930 init/main.c:1257
 do_initcall_level+0x157/0x210 init/main.c:1319
 do_initcalls+0x71/0xd0 init/main.c:1335
 kernel_init_freeable+0x435/0x5d0 init/main.c:1568
 kernel_init+0x1d/0x2b0 init/main.c:1457
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_frozen_pages+0xe04/0x10e0 mm/page_alloc.c:2660
 free_contig_range+0x14c/0x430 mm/page_alloc.c:6678
 destroy_args+0x94/0x4b0 mm/debug_vm_pgtable.c:1017
 debug_vm_pgtable+0x551/0x590 mm/debug_vm_pgtable.c:1397
 do_one_initcall+0x248/0x930 init/main.c:1257
 do_initcall_level+0x157/0x210 init/main.c:1319
 do_initcalls+0x71/0xd0 init/main.c:1335
 kernel_init_freeable+0x435/0x5d0 init/main.c:1568
 kernel_init+0x1d/0x2b0 init/main.c:1457
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff888072dfff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888072dfff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888072e00000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888072e00080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888072e00100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
