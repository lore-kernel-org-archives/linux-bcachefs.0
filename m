Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AA628EF
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 May 2024 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714816733; cv=none; b=k6reK8tddwEg1pLM8XOvaeCyb2glAGE1WVBlNyqQhc48JPT+NHhkiPSM9sLdOV3kWaS9rSE5ClZTy5xAS66hrOcJYB8GNMbSYkju8rCRy9GYuuGK7AOUgL+lweB4zSPIu+fkPuRdLYmBEM5srRPUCQVLulwbr1gboIZ27+xn4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714816733; c=relaxed/simple;
	bh=fvPpFW37UBc/PJC6LovGC975s0+4zyVQQ35RIbcQ1ok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJuazamq+d11ajkd/K7x5Ur35NvP50cv+Od0JK4JVIqqUCF0ZRG01n20EoxGEjGZkB4ubq1uFcsTAJvT7kS2/fRrFzfvPkzp7VmoBBtPfcCcT4a+TvFdeEn5afoTcwdv0gF2NHnF+SOYWZKQUcolmqHZkoh/Pa3O7RfKHdkdyD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYjqO036; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYjqO036"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1eb1cb1a8f1so93345ad.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 May 2024 02:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714816730; x=1715421530; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5abD5W/bjg3DDQ3YvY8Tq/oOKlk0GLkKJZ22jPXL7w0=;
        b=cYjqO036rHobnj3+2fmKEPNXdBh+yI08gkSONnrfyrQ81kT/Koov0zYodosJF6F/dX
         +GnvhvC8JYN4b1yyA4G1QuFZRbmZIM3D+WVQm+eOMNnek/D0OzRy9Zf73qE46hpXHaYW
         Xg/mGnrDylE0+N7yTtN8sVVrTwEXtWubCivSvhN6xjA+pauXn3yTr6CmKmhIAKTYn/9C
         uZW6LrnNas+QH/9ONH8IekwI4pSdbmX2I0Dw65Tv178iOPdnTa7zdj0U5+PDgiv+FAkG
         gF2XOjL7aLxGJa8TDX9IsFil4PaNO+3QmMFD/dMxghHYURKui/iW5yKhtTxvDfkjw0kE
         uH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714816730; x=1715421530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5abD5W/bjg3DDQ3YvY8Tq/oOKlk0GLkKJZ22jPXL7w0=;
        b=DpQWG9VwUgMCo60xIAUq9RppSwDObOUEoVCJI0Zs93APgJNMdaI4+WPz7lFdU9xCUH
         WceVcJcpU+Yz1xbWU6++pX+FU4VvvhmW371h8svNg9FxXmKz7J7fLWAY7JwxmQ/hThpy
         c1bE/5nQ8A9poA2BABg9tftfF4f6HVfADofIEaBz2HBjr0JlHoXRP4ciLoLeYhtiMFu0
         yoyg+/E0RX+H4o7ECFj9K/i6yumHfDYrw/dafrqWqIYgNnzf2OlZ3TmxuxgDFhIKNnBN
         IzuUdRmanWevXfbTwc9arPPbgoGYnIBzCvqmGwY1sxF+u4He9SB/ijPjgIyXqhBJPqF8
         X58g==
X-Forwarded-Encrypted: i=1; AJvYcCU0C2YRseCgtZFdiCkH7PayHtl5rP65eYDttZCavSYcIGSjwDJ9JaH3tQJD2kXK9mdLAvdBVmUXjEL6aanwnSCww5IcXQLna4rdVlF5qXo=
X-Gm-Message-State: AOJu0Yy0SyLLJk6RbqRZD/7tKdza1WquCwujDTMutmFWT3SFlxYFKe73
	L/V3TaHwSRr0/0QgoOx94xKQIogVTN+4Jj98N+5WvMLfEWkLkLHxGMReE8UFenm/ID7L48ioOVV
	43EenOuazWX4/gLDbUK55vjOauMi2NRqlHcpC
X-Google-Smtp-Source: AGHT+IGRT8BoYj2x6E1+7zjRjBKYl7K8uC0ZVBbuDoO00jO/1LFsEb/hFhcjJhq62MtKY2SkX+7EYx3kR8Ko4O0eaTk=
X-Received: by 2002:a17:902:f60a:b0:1ec:a14f:37d0 with SMTP id
 d9443c01a7336-1ed85119282mr887815ad.1.1714816729031; Sat, 04 May 2024
 02:58:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000003392c606179ddd1a@google.com>
In-Reply-To: <0000000000003392c606179ddd1a@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 4 May 2024 11:58:37 +0200
Message-ID: <CANp29Y5_ho16ktzYM1jtXxwu2z5AFi4pt0ccGc2XPoz2aH+NMA@mail.gmail.com>
Subject: Re: [syzbot] [crypto?] KASAN: use-after-free Read in scatterwalk_copychunks
To: syzbot <syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz set subsystems: bcachefs

On Sat, May 4, 2024 at 11:57=E2=80=AFAM syzbot
<syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    9221b2819b8a Add linux-next specific files for 20240503
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D130f062f18000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8ab537f51a6a0=
d98
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D8c4acf719c3fc41=
e8439
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D111abc97180=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1005900498000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/3e67dbdc3c37/dis=
k-9221b281.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ade618fa19f8/vmlinu=
x-9221b281.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/df12e5073c97/b=
zImage-9221b281.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/9035c2c411=
38/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com
>
> bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=3Dmetadata_c=
hecksum=3Dnone,data_checksum=3Dnone,compression=3Dlz4,nojournal_transaction=
_names
> bcachefs (loop0): recovering from clean shutdown, journal seq 13
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: use-after-free in memcpy_dir crypto/scatterwalk.c:23 [inline]
> BUG: KASAN: use-after-free in scatterwalk_copychunks+0x1cc/0x460 crypto/s=
catterwalk.c:38
> Read of size 32 at addr ffff888049380000 by task syz-executor169/5094
>
> CPU: 0 PID: 5094 Comm: syz-executor169 Not tainted 6.9.0-rc6-next-2024050=
3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 03/27/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
>  print_address_description mm/kasan/report.c:377 [inline]
>  print_report+0x169/0x550 mm/kasan/report.c:488
>  kasan_report+0x143/0x180 mm/kasan/report.c:601
>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
>  __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
>  memcpy_dir crypto/scatterwalk.c:23 [inline]
>  scatterwalk_copychunks+0x1cc/0x460 crypto/scatterwalk.c:38
>  skcipher_next_slow+0x39d/0x480 crypto/skcipher.c:276
>  skcipher_walk_next+0x634/0xba0 crypto/skcipher.c:361
>  chacha_simd_stream_xor+0x67f/0xd10 arch/x86/crypto/chacha_glue.c:192
>  do_encrypt_sg fs/bcachefs/checksum.c:107 [inline]
>  do_encrypt+0x4de/0x7b0 fs/bcachefs/checksum.c:127
>  bset_encrypt fs/bcachefs/btree_io.h:120 [inline]
>  bch2_btree_node_read_done+0x1dca/0x5ed0 fs/bcachefs/btree_io.c:1090
>  btree_node_read_work+0x665/0x1300 fs/bcachefs/btree_io.c:1345
>  bch2_btree_node_read+0x2637/0x2c80 fs/bcachefs/btree_io.c:1730
>  __bch2_btree_root_read fs/bcachefs/btree_io.c:1769 [inline]
>  bch2_btree_root_read+0x61e/0x970 fs/bcachefs/btree_io.c:1793
>  read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:472
>  bch2_fs_recovery+0x2334/0x36e0 fs/bcachefs/recovery.c:800
>  bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1030
>  bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
>  bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1917
>  legacy_get_tree+0xee/0x190 fs/fs_context.c:662
>  vfs_get_tree+0x90/0x2a0 fs/super.c:1780
>  do_new_mount+0x2be/0xb40 fs/namespace.c:3352
>  do_mount fs/namespace.c:3692 [inline]
>  __do_sys_mount fs/namespace.c:3898 [inline]
>  __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa185da797a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcd1a149e8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffcd1a14a00 RCX: 00007fa185da797a
> RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007ffcd1a14a00
> RBP: 0000000000000004 R08: 00007ffcd1a14a40 R09: 000000000000f62b
> R10: 0000000000010400 R11: 0000000000000282 R12: 0000000000010400
> R13: 00007ffcd1a14a40 R14: 0000000000000003 R15: 0000000001000000
>  </TASK>
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4938=
0
> flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: 0xffffff7f(buddy)
> raw: 00fff00000000000 ffffea0001249008 ffffea0001223008 0000000000000000
> raw: 0000000000000000 0000000000000006 00000000ffffff7f 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as freed
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x500cc2=
(GFP_HIGHUSER|__GFP_ACCOUNT), pid 4945, tgid 4945 (sshd), ts 47548197350, f=
ree_ts 47548625509
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1468
>  prep_new_page mm/page_alloc.c:1476 [inline]
>  get_page_from_freelist+0x2ce2/0x2d90 mm/page_alloc.c:3438
>  __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4696
>  alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
>  pipe_write+0x657/0x1a40 fs/pipe.c:513
>  new_sync_write fs/read_write.c:497 [inline]
>  vfs_write+0xa72/0xc90 fs/read_write.c:590
>  ksys_write+0x1a0/0x2c0 fs/read_write.c:643
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 4947 tgid 4947 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1088 [inline]
>  free_unref_page+0xd22/0xea0 mm/page_alloc.c:2601
>  __folio_put+0x3b9/0x620 mm/swap.c:129
>  pipe_buf_release include/linux/pipe_fs_i.h:219 [inline]
>  pipe_update_tail fs/pipe.c:224 [inline]
>  pipe_read+0x6f2/0x13e0 fs/pipe.c:344
>  new_sync_read fs/read_write.c:395 [inline]
>  vfs_read+0x9c4/0xbd0 fs/read_write.c:476
>  ksys_read+0x1a0/0x2c0 fs/read_write.c:619
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88804937ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88804937ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff888049380000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                    ^
>  ffff888049380080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>  ffff888049380100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/0000000000003392c606179ddd1a%40google.com.
