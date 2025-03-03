Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC641E9B3D;
	Mon,  3 Mar 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740991006; cv=none; b=IvQyLHrZCPJhH0BR6vxHbECtJVGRV8vDykd4ZAzGnkGLCu//O/Td9kaNj0usE654XYsJfmJBEiz2JMzUMx/2z94i9SAowmYIKH45G76pxE9dh6/cHWi4bGgQ5kSTwCZm1f4t0kCZMti9zK6IzjUzbq7wuU6TaI1PYsOGygUf2l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740991006; c=relaxed/simple;
	bh=FhmhAZyEcpgTM+6P0ZltvrlSmw5z7rq6LGrVAQTgLUc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qBSG+2J94mnpl/11s0vrCIHuxXXeF99dZ10jpRwK3uCeL890wEQJQzLT9wZERW98XSQklPfIHyHDL9Bnfhw0jGLKeyFCm9Xi9ljbBN30u2ESQlbteC+rkfKoFmc56PWzTvUASd4SPLxBvKiZITqOLS2D0OdO3sS2PE/O+KtKdDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TnxJR2Pl; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TnxJR2Pl"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2bcc0c6c149so3752391fac.1;
        Mon, 03 Mar 2025 00:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740991004; x=1741595804; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e+xmtTeQ6le8DHUZ2pKRu6fVSKJXYIHfU/7nENHpMVY=;
        b=TnxJR2PljP3E1teHMQ7Q75ViCaaS1eNkU8sIG0L+DGJJlPt1NpvDamJhIdjCf1N4fO
         P61gYam5QbzWZ1949NoaX7wWHWFAeuQT9TgTGRoWDwQXAz/yXB147Vrj6+XMyWKXXF+f
         kuC6W4ofpzbN4Uhmk0oEcB0e2e6wGXOm8lP1Grin7sTpf226k9TPr9rVZ0zbVqgrFM36
         q2t4xPPRFTBO818jqaI9b5//weKu/0NJKuul4vz6awRJ7cuMRVerRp2Irc1SwnWtUtKK
         Jw8gqi1kZp9aG1Ums84ptXECj3LFyduRT+JXDGQfXcXuHuj9dbiyBERZ/8mSOkjCD6j8
         mgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740991004; x=1741595804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e+xmtTeQ6le8DHUZ2pKRu6fVSKJXYIHfU/7nENHpMVY=;
        b=G/5YlEzd0zrmH2cbRL73zrLDyInYUShDvU8PyhzOhz/06hNw3JffQoF1CIFR4CY1AG
         TiiShAHzBAABrhjGA2CZ5KvgrSITlbrbvA/R/lWGHXuZsmNuyEzLGLnbIzBHceWpBhxZ
         /LCDVieNQym6Cy1gSmXyHFBGdUsmWahILzssa/b+GFiBhUiFF89rc5drG4d3h+/cq4iv
         nSQ5EaQQHx/KJ6k2Ad4gpSoud8QA1PVPuQoe9Jpj7bktWWZg6XKfs5N6ww6SvspA0/Rb
         TAStKhTt0Pg1plS5vHrPlGiwiwmIoLYkXyK092B0GmXMHr7NiKD/iSELUedMITanD6VQ
         kpiA==
X-Forwarded-Encrypted: i=1; AJvYcCUvJPRQ1B3tg0GgUHMYabx7mRt8iq2Q+Ls2Knpyi5y4i62ShFghddRNzma7LIIuR9gcRbkL2+CP5iVDaxKJgg==@vger.kernel.org, AJvYcCXi4YYlmc051s2qjLB73L89tZVYhyxAnCAzVqfjs4BiQkSDQaQNzRsXo9nm15ceKZjdymsKYsGbN7EGFzIA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3kWqJz2AOWLFNNcJOljmtwYxcCmUZl3AwcgyDmJKpsofeWxoI
	uGAcf/jzznq4DOX4L8tvSZcBseKrbOhJRse5LANvTJ1EuRl8lCf9HohW80F/WNxVJySFERQtdnt
	nvI43QbgOlw2NAGuzBl0oPuO46fA=
X-Gm-Gg: ASbGnctsSyQtvnsuk+QWoYjsxk2sVfxX6TEwdtoy5JS8yao79+3jhvYX2CRta5U3mhI
	6+0GIzQITiDOQyWyHZt6h/DOJlNymQslg0Omo0JldMNWI9fCrtNr6fZ5hMyuXJ6ZjV14hEExJI3
	796JzkXL7Mb473PZFdvGKTYPWGaw==
X-Google-Smtp-Source: AGHT+IGLrgCF9bhojFbMj5hTYar1qpiA2lXfLvkY2WGahh5FA3P1m/fbqcXDx2ohWgJUoA3Ec8V+Xtqnvo6z7Fxs5hg=
X-Received: by 2002:a05:6870:bb0c:b0:2c1:6948:d57c with SMTP id
 586e51a60fabf-2c178647718mr7620263fac.28.1740991004091; Mon, 03 Mar 2025
 00:36:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Strforexc yn <strforexc@gmail.com>
Date: Mon, 3 Mar 2025 16:36:33 +0800
X-Gm-Features: AQ5f1Jr83p_Oe7kHMbWs6y-C_nqTfDNRamOd2tKyQb6DOdSeUA0HLsBeoo3tq5c
Message-ID: <CA+HokZrg9rP1Wf=SbfRTCxU07M9yD48TV0dyPQDcUM7eL9Br0g@mail.gmail.com>
Subject: [BUG] KASAN: Use-After-Free in crc32c_le_base via bch2_checksum_update
 (Bcachefs) on 6.14.0-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux Kernel Developers,
I=E2=80=99ve identified a KASAN-reported use-after-free in the Bcachefs
filesystem on Linux 6.14.0-rc4 during recovery, potentially affecting
filesystem integrity. Here are the details:

Kernel commit: v6.14-rc4 (Commits on Feb 24, 2025)
Kernel Config : https://github.com/Strforexc/LinuxKernelbug/blob/main/.conf=
ig
Kernel Log=EF=BC=9A https://github.com/Strforexc/LinuxKernelbug/blob/main/u=
af_r_bch2_checksum_update/log0
Reproduce.c: https://github.com/Strforexc/LinuxKernelbug/blob/main/uaf_r_bc=
h2_checksum_update/repro.cprog

Bug Description=EF=BC=9A
KASAN detects a use-after-free read of size 1 at address
ffff88804d060000 in crc32c_le_base (lib/crc32.c:51), called via
bch2_checksum_update (fs/bcachefs/checksum.c:85), during B-tree node
reading in Bcachefs recovery.

The fault occurs in crc32c_le_base, accessing a buffer (data) freed
earlier by btree_bounce_free in bch2_btree_node_read_done.
Cause: bch2_btree_node_read_done frees a bounce buffer (kvfree) before
its checksum is computed via bch2_checksum_update, leaving a stale
pointer. The buffer is used after freeing, causing the use-after-free.
Context: Syzkaller=E2=80=99s mount operation triggers Bcachefs recovery,
likely with a crafted filesystem exposing this buffer lifetime issue.

Could Bcachefs maintainers investigate? Possible issues:
1. Premature freeing of the bounce buffer in bch2_btree_node_read_done
before checksum completion.
2. Lack of pointer invalidation after kvfree.
Suggested fixes:
1. Defer btree_bounce_free until after all buffer operations (e.g.,
move it after checksum and validation).
2. Nullify pointers post-free to catch misuse.

Our knowledge of the kernel is somewhat limited, and we'd appreciate
it if you could determine if there is such an issue. If this issue
doesn't have an impact, please ignore it =E2=98=BA.

If you fix this issue, please add the following tag to the commit:
Reported-by: Zhizhuo Tang strforexctzzchange@foxmail.com, Jianzhou
Zhao xnxc22xnxc22@qq.com, Haoran Liu <cherest_san@163.com>


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in crc32c_le_base+0xdb/0xf0 lib/crc32.c:51
Read of size 1 at addr ffff88804d060000 by task syz.4.204/13836

CPU: 0 UID: 0 PID: 13836 Comm: syz.4.204 Not tainted 6.14.0-rc4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
 print_address_description.constprop.0+0x2c/0x420 mm/kasan/report.c:408
 print_report+0xaa/0x270 mm/kasan/report.c:521
 kasan_report+0xbd/0x100 mm/kasan/report.c:634
 crc32c_le_base+0xdb/0xf0 lib/crc32.c:51
 crc32c_le_arch+0x183/0x1d0 arch/x86/lib/crc32-glue.c:69
 __crc32c_le include/linux/crc32.h:36 [inline]
 crc32c include/linux/crc32c.h:9 [inline]
 bch2_checksum_update+0x136/0x1a0 fs/bcachefs/checksum.c:85
 bch2_checksum+0x104/0x2c0 fs/bcachefs/checksum.c:226
 bch2_btree_node_read_done+0x28e7/0x4b90 fs/bcachefs/btree_io.c:1130
 btree_node_read_work+0x670/0x1060 fs/bcachefs/btree_io.c:1358
 bch2_btree_node_read+0x855/0xc50 fs/bcachefs/btree_io.c:1748
 __bch2_btree_root_read+0x288/0x410 fs/bcachefs/btree_io.c:1789
 bch2_btree_root_read+0x54/0xa0 fs/bcachefs/btree_io.c:1811
 read_btree_roots+0x2ba/0x760 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x1822/0x2fa0 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x33d/0x690 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x105a/0x1470 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x93/0x350 fs/super.c:1814
 do_new_mount+0x368/0x730 fs/namespace.c:3560
 path_mount+0x4a6/0x17f0 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount fs/namespace.c:4088 [inline]
 __x64_sys_mount+0x288/0x310 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcb/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4c581ba41e
Code: 48 c7 c0 ff ff ff ff eb aa e8 5e 20 00 00 66 2e 0f 1f 84 00 00
00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4c59158da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000005d94 RCX: 00007f4c581ba41e
RDX: 0000400000000040 RSI: 0000400000005dc0 RDI: 00007f4c59158e00
RBP: 00007f4c59158e40 R08: 00007f4c59158e40 R09: 0000000000014002
R10: 0000000000014002 R11: 0000000000000246 R12: 0000400000000040
R13: 0000400000005dc0 R14: 00007f4c59158e00 R15: 0000400000000080
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000
index:0xffff88804d062840 pfn:0x4d060
flags: 0x4fff00000000000(node=3D1|zone=3D1|lastcpupid=3D0x7ff)
page_type: f0(buddy)
raw: 04fff00000000000 ffffea0001301008 ffff88807ffda7a8 0000000000000000
raw: ffff88804d062840 0000000000000005 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Reclaimable, gfp_mask
0x452cd0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_REC=
LAIMABLE),
pid 13836, tgid 13835 (syz.4.204), ts 115647482830, free_ts
115856278729
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1a3/0x1d0 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0x8a5/0xfa0 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x1d8/0x3b0 mm/page_alloc.c:4739
 __alloc_pages_noprof+0xc/0x1c0 mm/page_alloc.c:4773
 __alloc_pages_node_noprof include/linux/gfp.h:265 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:292 [inline]
 ___kmalloc_large_node+0x8b/0x1b0 mm/slub.c:4239
 __kmalloc_large_node_noprof+0x1a/0x80 mm/slub.c:4266
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_noprof+0x39e/0x570 mm/slub.c:4300
 __kvmalloc_node_noprof+0x7e/0x1c0 mm/util.c:662
 btree_node_data_alloc.constprop.0+0xe9/0x2a0 fs/bcachefs/btree_cache.c:156
 __bch2_btree_node_mem_alloc+0x37/0xa0 fs/bcachefs/btree_cache.c:201
 bch2_fs_btree_cache_init+0x110/0x560 fs/bcachefs/btree_cache.c:655
 bch2_fs_alloc+0x16fc/0x1e30 fs/bcachefs/super.c:919
 bch2_fs_open+0x91b/0xb90 fs/bcachefs/super.c:2064
 bch2_fs_get_tree+0xf83/0x1470 fs/bcachefs/fs.c:2190
 vfs_get_tree+0x93/0x350 fs/super.c:1814
 do_new_mount+0x368/0x730 fs/namespace.c:3560
page last free pid 13836 tgid 13835 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0x61f/0xe70 mm/page_alloc.c:1271
 __folio_put+0x304/0x3d0 mm/swap.c:112
 kvfree+0x46/0x50 mm/util.c:705
 btree_bounce_free fs/bcachefs/btree_io.c:111 [inline]
 bch2_btree_node_read_done+0x3acc/0x4b90 fs/bcachefs/btree_io.c:1243
 btree_node_read_work+0x670/0x1060 fs/bcachefs/btree_io.c:1358
 bch2_btree_node_read+0x855/0xc50 fs/bcachefs/btree_io.c:1748
 __bch2_btree_root_read+0x288/0x410 fs/bcachefs/btree_io.c:1789
 bch2_btree_root_read+0x54/0xa0 fs/bcachefs/btree_io.c:1811
 read_btree_roots+0x2ba/0x760 fs/bcachefs/recovery.c:581
 bch2_fs_recovery+0x1822/0x2fa0 fs/bcachefs/recovery.c:928
 bch2_fs_start+0x33d/0x690 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0x105a/0x1470 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x93/0x350 fs/super.c:1814
 do_new_mount+0x368/0x730 fs/namespace.c:3560
 path_mount+0x4a6/0x17f0 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount fs/namespace.c:4088 [inline]
 __x64_sys_mount+0x288/0x310 fs/namespace.c:4088

Memory state around the buggy address:
 ffff88804d05ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804d05ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88804d060000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88804d060080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88804d060100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Regards,
Strforexc
