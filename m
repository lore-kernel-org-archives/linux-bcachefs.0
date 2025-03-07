Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6023F27A;
	Fri,  7 Mar 2025 17:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741367180; cv=none; b=t8AQJCSWTKKzNiYqC0eMQVMOOoH1MEtRn3m1qh6+4VuDxGZzgtg8q/gmumYtXaaGLhHt5Pa6LQ5La6lh5OO/9/wr357+tHJ8sB+LO5MnGJqz0xZgjZXUxLgr9JyG8psTJNZu4HrvflHWWfVvltCKy3sS3k/MmWsXTHZj+e6cAoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741367180; c=relaxed/simple;
	bh=lUni9ATZBCXsxkhR4R4RQw/z2NPis/NDqTz0VPhxcbs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=P0UpJdRnIk84qBa6DhCjiws2VDphBIzS8NVW9GWmhGfgaLa+zKQrp7PF7iqc0vQuBkauPkkGZGtQYHJTJB4bk5qMvilN2/nX82qvF+TxvxtzlSl0LonzXJisPK9u6TTBeMNroINA47fEskcnuy2Rqt7W24SR6rjjcP+rENNo3Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqPlhOrT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqPlhOrT"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22334203781so62678245ad.0;
        Fri, 07 Mar 2025 09:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741367178; x=1741971978; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kAAXyXTItzF2WU7cmxe1b1WSqxvCINsOGqpMs4jawGc=;
        b=gqPlhOrTyaDKnjxroDsL7qCgFSGK8DUctDsH159j2ClyeZ4PTxt7cgy0PL6DB4fMDG
         HVFa5Ew4s2whQoDcolzpHee0ZvuuataHS/poy+k75jyApsza2wHvb/+kc9vTridWNN17
         KhX+yb1qCNMx3WKTYul68yv/fEGq1wQSIJbkJpB+0vT7JPeSacW5s4Ql51dnMDkEnRjp
         iHJ92ftLjZE0VpFlgZDLSkP+Vnkg+CsXhlOv5BbFt5MyJS9gc3KbSXHccotVbPxvEW2f
         exHFURGB2n+tnfECoUURyfDAEM/dH7HNOirOu7T+tJFe+q3yL+PIRRPGtf2dAAQMza9g
         JUiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741367178; x=1741971978;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kAAXyXTItzF2WU7cmxe1b1WSqxvCINsOGqpMs4jawGc=;
        b=NfzWjlEOpFBzeDpkT/6d7hlSrLMdKz2MyNIeLaJj9SxCpbvxysxBgqCJXlr13QgLgZ
         GK2dYsWLOBENqRxK5Gtw0rIT3TIzyuP/z+fdeelUP3E4Ltz/GYH3/kgQ7PD0KIh5Uyxg
         c5MiS80BJLYwx+X/MZAKS4i+a5lQfQL+00gjxYNGeSK//450h7FA76Oqf5Q6Rt1pURxm
         yf+QBDgmaeuIO+R78FJc7ayTFWn24Sxf2hofK6AqSx7urviPMVCknVdSryOCGAGGY9w4
         s0zYn4NqSabxTNcyDO0XLrdx8Ua8uLjKg/QdF8q5UU73/QERDsRzqx7cB6E4LsE7LFGh
         mFJg==
X-Forwarded-Encrypted: i=1; AJvYcCUgCSKx63cb31yMhNSZj6C3PT9Hy9K8WaSi/Qnp5Pc0k159pvbX+WtYB1ot7lYlluBI+DtsmlwGv5XJUVD8@vger.kernel.org, AJvYcCXWnRrrpRSlzOaBf6YKKenxOZhM0ZnV9eMQ703wbJQmeDUH/DXhOKxjZyAEp8C1YEDNJBR6Ng4ibybOYAdUqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZbrkheUHW8RzaBKst75+q+aQDkB8M3nRTvgFl9Ids2Y+iMbeG
	+C7kXYwlmigkwjsGB9JkyOBeKhkdMu+A/zo/Ie+Guoodf99m+EZW
X-Gm-Gg: ASbGncv9hefiEJsNma8YYe9wI/vQg/24I6Nx4ZInOrHUGTaaEa05g/emwlne6/qjuFJ
	b6sbO18uzO9WrW4Y0V4h7eXXuYXG1413KBnlPdO9SX5Ii4xKne7beBCJo00d03C+SIT/9T2FMSl
	srORm67paz1ByLt12obTVHd4ZydAc2jcycni0RbkVj63J0R4z7eIAz/Wi8k3xiosVSwG6wFx6WR
	4sOEhhub34JjNJ2QG8QZRRhQkRRrqcNP+1Uk1PO4Tm+kgGKK4CrHYgv9B7xd4LClrRW0akSl8ov
	TvciC9Q4fweWffYj6TF3jsrDRgYB
X-Google-Smtp-Source: AGHT+IGyY2KyjgH96JMvRfAw4Wk47r1awXhS9XJcEQcm/uTcRH18NaCiOzu8PbrHQrqb7Wz87PQefA==
X-Received: by 2002:a05:6a00:3188:b0:736:b400:b58f with SMTP id d2e1a72fcca58-736bbe1307amr430566b3a.0.1741367177913;
        Fri, 07 Mar 2025 09:06:17 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736bb5fcd68sm210682b3a.135.2025.03.07.09.06.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Mar 2025 09:06:17 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in
 __bch2_bkey_unpack_key
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67c9e207.050a0220.15b4b9.004c.GAE@google.com>
Date: Sat, 8 Mar 2025 01:06:02 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <67972800-CD21-4A3E-B4E5-0FDFD7B83D44@gmail.com>
References: <67c9e207.050a0220.15b4b9.004c.GAE@google.com>
To: syzbot <syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Mar 7, 2025, at 01:57, syzbot =
<syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of =
git://git.ke..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D11f08078580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D2040405600e83619
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Db9d9de2aa46b1bbe575a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D13b69464580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D15f08078580000
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-99fa936e.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/ef04f83d96f6/vmlinux-99fa936e=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/583a7eea5c8e/bzImage-99fa936e=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/4d401321a7e1/mount_6.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com
>=20
>  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0 =
=20
>  node offset 8/48 bset u64s 2088 bset byte offset 360: bad k->u64s 0 =
(min 3 max 253), fixing
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in unpack_state_init =
fs/bcachefs/bkey.c:151 [inline]
> BUG: KASAN: slab-out-of-bounds in __bch2_bkey_unpack_key+0x66/0xdd0 =
fs/bcachefs/bkey.c:269
> Read of size 8 at addr ffff888053574140 by task kworker/0:1H/36
>=20
> CPU: 0 UID: 0 PID: 36 Comm: kworker/0:1H Not tainted =
6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: bcachefs_btree_read_complete btree_node_read_work
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> print_address_description mm/kasan/report.c:408 [inline]
> print_report+0x16e/0x5b0 mm/kasan/report.c:521
> kasan_report+0x143/0x180 mm/kasan/report.c:634
> unpack_state_init fs/bcachefs/bkey.c:151 [inline]
> __bch2_bkey_unpack_key+0x66/0xdd0 fs/bcachefs/bkey.c:269
> __bkey_unpack_key_format_checked fs/bcachefs/bkey.h:407 [inline]
> __bkey_unpack_key fs/bcachefs/bkey.h:426 [inline]
> __bkey_disassemble fs/bcachefs/bkey.h:477 [inline]
> bkey_packed_valid+0x21e/0x6c0 fs/bcachefs/btree_io.c:875
> validate_bset_keys+0xeb5/0x1af0 fs/bcachefs/btree_io.c:987
> bch2_btree_node_read_done+0x2298/0x6180 fs/bcachefs/btree_io.c:1164
> btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
> process_one_work kernel/workqueue.c:3238 [inline]
> process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
> worker_thread+0x870/0xd30 kernel/workqueue.c:3400
> kthread+0x7a9/0x920 kernel/kthread.c:464
> ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> </TASK>
>=20
> Last potentially related work creation:
> ------------[ cut here ]------------
> pool index 16319 out of bounds (797) for stack id 9a6c3fc0
> WARNING: CPU: 0 PID: 36 at lib/stackdepot.c:452 =
depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
> Modules linked in:
> CPU: 0 UID: 0 PID: 36 Comm: kworker/0:1H Not tainted =
6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Workqueue: bcachefs_btree_read_complete btree_node_read_work
> RIP: 0010:depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
> Code: 83 7c 18 1c 00 74 38 48 01 d8 eb 24 90 0f 0b 90 44 39 f5 72 ca =
90 48 c7 c7 63 fc 3a 8e 89 ee 44 89 f2 89 d9 e8 ab e2 53 fc 90 <0f> 0b =
90 90 31 c0 5b 41 5e 5d c3 cc cc cc cc 90 0f 0b 90 eb ef 90
> RSP: 0000:ffffc90000576d08 EFLAGS: 00010046
> RAX: a98b856e26fe2600 RBX: 000000009a6c3fc0 RCX: ffff88801e00c880
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000003fbf R08: ffffffff81817e32 R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff888053574140
> R13: ffffea00014d5d00 R14: 000000000000031d R15: ffffc90000576de0
> FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fabca6ea000 CR3: 0000000012240000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> stack_depot_fetch lib/stackdepot.c:714 [inline]
> stack_depot_print+0x16/0x50 lib/stackdepot.c:752
> kasan_print_aux_stacks+0x38/0x70 mm/kasan/report_generic.c:199
> describe_object_stacks mm/kasan/report.c:347 [inline]
> describe_object mm/kasan/report.c:353 [inline]
> print_address_description mm/kasan/report.c:412 [inline]
> print_report+0x22b/0x5b0 mm/kasan/report.c:521
> kasan_report+0x143/0x180 mm/kasan/report.c:634
> unpack_state_init fs/bcachefs/bkey.c:151 [inline]
> __bch2_bkey_unpack_key+0x66/0xdd0 fs/bcachefs/bkey.c:269
> __bkey_unpack_key_format_checked fs/bcachefs/bkey.h:407 [inline]
> __bkey_unpack_key fs/bcachefs/bkey.h:426 [inline]
> __bkey_disassemble fs/bcachefs/bkey.h:477 [inline]
> bkey_packed_valid+0x21e/0x6c0 fs/bcachefs/btree_io.c:875
> validate_bset_keys+0xeb5/0x1af0 fs/bcachefs/btree_io.c:987
> bch2_btree_node_read_done+0x2298/0x6180 fs/bcachefs/btree_io.c:1164
> btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
> process_one_work kernel/workqueue.c:3238 [inline]
> process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
> worker_thread+0x870/0xd30 kernel/workqueue.c:3400
> kthread+0x7a9/0x920 kernel/kthread.c:464
> ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> </TASK>
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
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
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

#syz test: https://github.com/alanskind/bcachefs =
47e4e14a59ecffbec0025733f1980d23b1a7c7ef


