Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF68EEB3;
	Tue,  5 Aug 2025 03:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754365952; cv=none; b=sQot0HMSQmWSj12ZEGl/9IO4KRawM2bZIAzzODvl6Kkp4fOwQR+KgtZ4WL5A3BAkYiVLxfdy8enseHC0WJank9HPOU1YsoS+dul/+tMltRmBD/ANxXi368v6lI9EP/UZSPzL4GSRakj+9ayk1xI6yzxNDee9QMOttzM78JzaqEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754365952; c=relaxed/simple;
	bh=856mOxZUywhgtLeoTqbI9AkMdh3/bKMu1nbMyn9XHyg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=gDIo4r3/QojXY3+R9PZVT3EK7ThxogCGqsuuET86j+LD+K7CtTuZqz9KIqFS++1uYq8FK4joAGRnp3en3afBm3QDVgRW1WCvv1NIpA5riQtDYWQ7EP0REr90fepTTy+dmrwfeKUsXN5ugSPoatcKaHqRhv9eJ5Js3vu09wnOGuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=md3K2QXb; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="md3K2QXb"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24041a39005so26031195ad.2;
        Mon, 04 Aug 2025 20:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754365950; x=1754970750; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+AKpZHXLZaiUhjHKQwlX6WDjf6oFtNnifsnvf7RAJRc=;
        b=md3K2QXb+ckhD4w1n6m9JIgu4MVCxAXg4999fW4wiehYHPiYaBnIt8SNE95JI1i16j
         LCMzDwGLWcWj142C2x0xOaB0Zt3tO9eYQl7rrzZhCss19BS9vfsc/MLNLNMK0OISLyqi
         LgW+uGPAGfk3XxiQB6xGo4kPbWm9p3SoOHHnSLQodyNNCOgLqOD6zgwbd/NjnluoDKAK
         z0uhuDbnDO5A0wvX0MOPdSHcwrTmvRGwZe4uW5D6O8Cv21XLsYM4mmRPZ4tboDjUIHjG
         Twp0WIuMBrqakIz9uTY1tdW7WntIGWVl7VJfEcc2oGmd0c+/oOcX2KRWpU5ZcXxD9NtN
         /cbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754365950; x=1754970750;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AKpZHXLZaiUhjHKQwlX6WDjf6oFtNnifsnvf7RAJRc=;
        b=PwyUuxqg4JnXhfU1ypwUJzNq+wKxzPAEnNeh5O0oQQuLHHKK7nhBm/1XgO/qd1ikwy
         SRgx629+SOeEFkFVWyy5RRKXORNTrZNvHaytak1Q1m59VeN6+hVrLgS5kijetscBIAKJ
         pZfyJ+UuAp9HzMajj+/MSjyFYrrKNOCoSXUGbJ/VAKO1bLEh6m/J0KzCm+swL3vEOIo+
         eCv7tX0NlUqtlF1AgUQZojTgm4/LuiAj1l27Gz9XSGBFCu4Zs+nTqMPw1nObZmTf5pbr
         qJR0xE6P3F5srKTuBgQjz83hB94Wvn2APcQyYkNBHo1RRP+OgEQYLSkErPQDQuEbbmiu
         QT1w==
X-Forwarded-Encrypted: i=1; AJvYcCVqQzac+w2REenXWP4wkXWowbzshCTXcK+g7Sq+zTGyAUEJZyl95RjtSnaFSs4l5MNN8gMFzzofNE1kD9RSDw==@vger.kernel.org, AJvYcCWfEC7Oc8kFxT6Rvnt3ocs3EkvEtBymkkPtUmbnkGPAYs39otsZxxlqu+dNDUkCX5Ptge+FbxQrvX/TrnZM@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+3wt3yKsOT4Xjq6UnmA+sGGiIUZOIRBDibSfbIGcjBgRvIUrr
	48gWA6Pt4uAxEcOhDhUEzwPbcZmxM/YZFm+cZVLIdtdUjvnEpm0pRkzB
X-Gm-Gg: ASbGnctQdRvIteGN2p9/5+P9L4JMdQwTAKOqbr9h1APDOZEWAPNn8dnyBBGSM/YfVag
	vhQhbxh3MY2QZOmWmnfA0xJiTPJf19GSz56c9giVAe5nQVj10w8TWZw/zSAUK4en22QO4dfUKtx
	mZdWvrL9UHoSQiMq/sXBTJz/+/nv2uHE/2CtogNxv9sEqNXTrmwZCw31PeRBsdCYwGKOGl+YL8w
	ELDLaGbqD7TvpLMYP1MA2Ejmk3I4rqR15hHTakYAc2tz6aBHOxUhL6Yz+bI79Q4am3VOQ8mfqnT
	+qL2AZu9duMlOEg5OQtFPpSvKOimtsMFrOuua6XrvXXfdIMMgABBQLktMZOXgYwwOoAGMbAFWx0
	ko1RtpTQpAZEZue0o
X-Google-Smtp-Source: AGHT+IHbUBzFWyDoFqCHhC0WdzbyGMWESbmBtmQAduXWEWWnQvCyD3r6KG7MgaHNcO1dMWbSLb5pPg==
X-Received: by 2002:a17:903:19ed:b0:240:1f19:d35c with SMTP id d9443c01a7336-24247030cc6mr152867425ad.39.1754365949701;
        Mon, 04 Aug 2025 20:52:29 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0e757sm121617965ad.55.2025.08.04.20.52.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 20:52:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_trans_update_by_path
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <6853f202.a00a0220.137b3.0005.GAE@google.com>
Date: Tue, 5 Aug 2025 11:52:14 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2EF5EFCC-2F5A-4B86-9D12-92A7C6712DF3@gmail.com>
References: <6853f202.a00a0220.137b3.0005.GAE@google.com>
To: syzbot <syzbot+210dfbddd64294066983@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jun 19, 2025, at 19:18, syzbot =
<syzbot+210dfbddd64294066983@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    fb4d33ab452e Merge tag '6.16-rc2-ksmbd-server-fixes' =
of gi..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D12eb6d0c580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dd11f52d3049c3790
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D210dfbddd64294066983
> compiler:       Debian clang version 20.1.6 =
(++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD =
20.1.6
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_dis=
k-fb4d33ab.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/123054ec64c2/vmlinux-fb4d33ab=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/5e5e20b8a324/bzImage-fb4d33ab=
.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+210dfbddd64294066983@syzkaller.appspotmail.com
>=20
> bcachefs (loop0): no nodes found for btree extents, continuing
> bcachefs (loop0): btree root inodes unreadable, must recover from scan
> bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=3Dinodes =
level=3D0 POS_MIN - SPOS_MAX
> bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type =
btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 =
min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
> bcachefs (loop0): empty interior btree node at btree=3Dinodes level=3D1
>  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
> bcachefs (loop0): bch2_btree_repair_topology_recurse(): error ECHILD
> bcachefs (loop0): empty btree root inodes
> bcachefs (loop0): btree root subvolumes unreadable, must recover from =
scan
> bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=3Dsubvolumes =
level=3D0 POS_MIN - SPOS_MAX
> bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type =
btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 =
min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0
> done
> bcachefs (loop0): accounting_read... done
> bcachefs (loop0): alloc_read... done
> bcachefs (loop0): snapshots_read... done
> bcachefs (loop0): check_allocations...
> bcachefs (loop0): bucket 0:26 data type btree ptr gen 0 missing in =
alloc btree
>  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq =
ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 =
gen 0, fixing
> bcachefs (loop0): bucket 0:41 data type btree ptr gen 0 missing in =
alloc btree
>  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq =
9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 =
gen 0, fixing
> bcachefs (loop0): bucket 0:35 data type btree ptr gen 0 missing in =
alloc btree
>  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq =
c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 =
gen 0, fixing
> bcachefs (loop0): bucket 0:1 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:1 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:2 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:2 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:3 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:3 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:4 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:4 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:5 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:5 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:6 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:6 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:7 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:7 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:8 gen 0 has wrong data_type: got free, =
should be sb, fixing
> bcachefs (loop0): bucket 0:8 gen 0 data type sb has wrong =
dirty_sectors: got 0, should be 8, fixing
> bcachefs (loop0): bucket 0:9 gen 0 has wrong data_type: got free, =
should be journal, fixing
> bcachefs (loop0): bucket 0:9 gen 0 data type journal has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:10 gen 0 has wrong data_type: got free, =
should be journal, fixing
> bcachefs (loop0): bucket 0:10 gen 0 data type journal has wrong =
dirty_sectors: got 0, should be 256, fixing
> bcachefs (loop0): bucket 0:11 gen 0 has wrong data_type: got free, =
should be journal, fixing
>  Ratelimiting new instances of previous error
> bcachefs (loop0): bucket 0:11 gen 0 data type journal has wrong =
dirty_sectors: got 0, should be 256, fixing
>  Ratelimiting new instances of previous error
> done
> bcachefs (loop0): going read-write
> bcachefs (loop0): journal_replay...
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/btree_update.c:375!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted =
6.16.0-rc2-syzkaller-00082-gfb4d33ab452e #0 PREEMPT(full)=20
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:bch2_trans_update_by_path+0x1efb/0x1f30 =
fs/bcachefs/btree_update.c:375
> Code: 80 e1 07 fe c1 38 c1 0f 8c 40 f7 ff ff 48 8b 7c 24 28 e8 88 5e =
fa fd e9 31 f7 ff ff e8 ce df 96 fd 90 0f 0b e8 c6 df 96 fd 90 <0f> 0b =
e8 be df 96 fd 90 0f 0b e8 b6 df 96 fd 90 0f 0b e8 ae df 96
> RSP: 0018:ffffc9000d6be9c8 EFLAGS: 00010283
> RAX: ffffffff84297c8a RBX: 0000000000008541 RCX: 0000000000100000
> RDX: ffffc9000e002000 RSI: 00000000000b63ac RDI: 00000000000b63ad
> RBP: 1ffff1100a622002 R08: ffffffff844d525f R09: 0000000000000002
> R10: 0000000000000003 R11: 0000000000000002 R12: 1ffff1100a62205e
> R13: ffff888053110010 R14: 0000000000000088 R15: ffff8880531102f0
> FS:  00007f529748d6c0(0000) GS:ffff88808d251000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffb9f0fabc CR3: 0000000043ca6000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> bch2_trans_update_ip+0x9a6/0x1db0 fs/bcachefs/btree_update.c:531
> bch2_trans_update fs/bcachefs/btree_update.h:123 [inline]
> bch2_journal_replay_key+0x46a/0xb10 fs/bcachefs/recovery.c:311
> bch2_journal_replay+0x1727/0x2620 fs/bcachefs/recovery.c:396
> bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:485 [inline]
> __bch2_run_recovery_passes+0x395/0x1010 =
fs/bcachefs/recovery_passes.c:540
> bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:611
> bch2_fs_recovery+0x25fd/0x3950 fs/bcachefs/recovery.c:989
> bch2_fs_start+0xa99/0xd90 fs/bcachefs/super.c:1203
> bch2_fs_get_tree+0xb02/0x14f0 fs/bcachefs/fs.c:2489
> vfs_get_tree+0x8f/0x2b0 fs/super.c:1804
> do_new_mount+0x24a/0xa40 fs/namespace.c:3885
> do_mount fs/namespace.c:4222 [inline]
> __do_sys_mount fs/namespace.c:4433 [inline]
> __se_sys_mount+0x317/0x410 fs/namespace.c:4410
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f52965900ca
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f529748ce68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f529748cef0 RCX: 00007f52965900ca
> RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007f529748ceb0
> RBP: 00002000000000c0 R08: 00007f529748cef0 R09: 0000000000818001
> R10: 0000000000818001 R11: 0000000000000246 R12: 0000200000000080
> R13: 00007f529748ceb0 R14: 00000000000059a7 R15: 0000200000000200
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bch2_trans_update_by_path+0x1efb/0x1f30 =
fs/bcachefs/btree_update.c:375
> Code: 80 e1 07 fe c1 38 c1 0f 8c 40 f7 ff ff 48 8b 7c 24 28 e8 88 5e =
fa fd e9 31 f7 ff ff e8 ce df 96 fd 90 0f 0b e8 c6 df 96 fd 90 <0f> 0b =
e8 be df 96 fd 90 0f 0b e8 b6 df 96 fd 90 0f 0b e8 ae df 96
> RSP: 0018:ffffc9000d6be9c8 EFLAGS: 00010283
> RAX: ffffffff84297c8a RBX: 0000000000008541 RCX: 0000000000100000
> RDX: ffffc9000e002000 RSI: 00000000000b63ac RDI: 00000000000b63ad
> RBP: 1ffff1100a622002 R08: ffffffff844d525f R09: 0000000000000002
> R10: 0000000000000003 R11: 0000000000000002 R12: 1ffff1100a62205e
> R13: ffff888053110010 R14: 0000000000000088 R15: ffff8880531102f0
> FS:  00007f529748d6c0(0000) GS:ffff88808d251000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffb9f0fabc CR3: 0000000043ca6000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20


#syz fix: bcachefs: Fix btree for nonexistent tree depth

