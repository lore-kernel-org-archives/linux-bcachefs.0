Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07B7D3F4;
	Sat, 12 Apr 2025 06:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744441115; cv=none; b=ZYUlCwdz9GMataKBKAQp9KnoQdqgtkxGPYRmhWwoP4GCQp4F016HGCGbfU1SVUoPts1SaOqR9JnHytbXXcJ5rmD68396E0RzbfMyBR5cmtCbOTDdcYsJWuZoKJhk/wC+x6ht78HFaVDsyTaiwHMPEnu5wCjMD6ponXO7jmnp6jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744441115; c=relaxed/simple;
	bh=n1I6gMy9qnfNPqw1nUpIFFyRBhVHfFkz12sbdYs7zoE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=St2UyUNkikT4Jz0BkfUR1bmZFhFOfHVO0v789bvF0rEUfSscJmARpcBw74f0QMHpKtIHZkZkjIC/EG+ieMVGEv9CGVLDhYB5uUzE/9egMtrsmG/aFth9i0LYHPX32oOoLfGS/RJcL3ULv9rFKHurIs6tUOaNkStmJI7NrPmKhgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fqPzUUui; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fqPzUUui"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b0322b6f974so1973748a12.1;
        Fri, 11 Apr 2025 23:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744441113; x=1745045913; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=We8KuR87wAViSbzUzi0sZv5arDqecPVUBZGP3B8z5MQ=;
        b=fqPzUUuiA9can4omKdXPXmFi+qgZNgt3GM62t4xmUJ6Vfoi/NQJUXtbK46g8HxGMOa
         0dYN52U0snPJ78ERdX1mjZAzqMu9Uz3O9J4zw3UCH7JaXR1MfYKgl4Mu5UFrfyXRARN8
         pPPg0atOvkKZKNwJeQVAnysOeGkCjW7/U0tYq+J9F6WVxrrzoAoNZTwiZWVDrYvmmP/f
         L8nBGs+TgNnNQeQBxFCAOYrTPCXwpriTav8qadBXhXPN+Yus+pHJ3NlMmoQyE3ukKKRq
         y6xQdnRxlbxs11q3tF3gQdQbzL4TmyZR8nwaDXEzGGOyD/GXADKGyRsgIuQ4awbgdUE9
         EUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744441113; x=1745045913;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=We8KuR87wAViSbzUzi0sZv5arDqecPVUBZGP3B8z5MQ=;
        b=Qp6vNPGBRRZXDyPZ3anmNWGlPQiXa0D8MDeGPgKbsclVKa9FuqxlZ5RL01V7HacJmI
         iIhj9yx37q7XkLOohFt+gxS4Uceyk+PVPMVIkSsY6G9vzcNoppsfrS1Gc5dsIg7S1bcw
         0JSSq5Dexd8j9bkjlUO90DLc4+xPH8vbbZnYf/wk6o06OFHCiCI+5aFnbkNoEW17gIxL
         mOZyK8qp8nAbA5z2Tg3cALAFWH4bxcZ72t57XRSrTiKu81cTE+sW7cJLdPW8l7x7BEDw
         z9RX5kQa2Mj6ZOMPb1sXKF09z4iVNA6Imv7FmMBmKqu9Nm5V5afFJbs8aVlqBV2Q8gtE
         qWhg==
X-Forwarded-Encrypted: i=1; AJvYcCVNLbWgAsKVVHVQfvsFjACNQpiTpjNsFntfjZIs41Umv0eY5z+57OtEel/3PHgZqApL0SDVtJNotOc0tn0b5A==@vger.kernel.org, AJvYcCXcMdvgKQp5aKO36yeUcgGcsegIgPZIuEGEzC+xL/jG4aeoyaK7anKDwSn5tTCYPJ4O7WQKBtiyqwBBojQ9@vger.kernel.org
X-Gm-Message-State: AOJu0YyvuqBSdsiCPyi5bDVW6duuVyaXBNKLCLl3nG7l3XGUpm4P3lOQ
	OobnT2ELMrr7Xkw7A2dHecmi3clk6qLHvZ6iXbljLFgdekv+dwQfR/QjrhwB
X-Gm-Gg: ASbGncv/6jVSrjA+d7qsmyXx8JU1nsFdfpZtPvGoYG0TrsGaSe9bOBqpO4D1jHGWLc8
	XgWl7DiPrQtOLz2cSgn6AuPFBjg16OUyxiBGGrJNHvKTwt4cJL5orpz0n97e4FCF37GY1fhuhbo
	8PeINnsGOeFW3FY6yR5nCIOllNykKtuikXYoJOfNnMFo42cm8IgZAuFnDU1dxWFBqo4PvzzMmfB
	vLm5+2tnsV0lNc9OyJZGvXOnKgaqn8tRuXC0baa8xf4MMuHqjXLe49CqmaeN7MAddx3z8RcYEiD
	rxJz3PtJ6yZCCDr/CsEkJyDf
X-Google-Smtp-Source: AGHT+IHd8Pj4UxAB/FGBTTAuvXJoK9vy2dEPJkjoMhLpl6bJQNWWnBV44hk3+pCtTAGiV58Hw+FSLA==
X-Received: by 2002:a05:6a20:9d90:b0:1fd:f48b:f397 with SMTP id adf61e73a8af0-201797b96d5mr7141945637.23.1744441112428;
        Fri, 11 Apr 2025 23:58:32 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd2198e9csm2784164b3a.28.2025.04.11.23.58.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Apr 2025 23:58:31 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_initialize
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67fa0c0c.050a0220.379d84.0007.GAE@google.com>
Date: Sat, 12 Apr 2025 14:58:16 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9F695AD-3447-4F18-AAB9-85E118ED2BE3@gmail.com>
References: <67fa0c0c.050a0220.379d84.0007.GAE@google.com>
To: syzbot <syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Apr 12, 2025, at 14:45, syzbot =
<syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    29e7bf01ed80 Add linux-next specific files for =
20250410
> git tree:       linux-next
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D1515f74c580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Da554d15459e77547
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dd10151bf01574a09a915
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D14634398580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/bb76302efd6b/disk-29e7bf01.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/7da3c6b9e532/vmlinux-29e7bf01=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/4909c61270ed/bzImage-29e7bf01=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/d99f7622732d/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
>=20
> 0 pages HighMem/MovableOnly
> 428629 pages reserved
> 0 pages cma reserved
> bcachefs (loop0): error reallocating journal fifo (32768 open entries)
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/journal.h:442!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 6987 Comm: syz.0.185 Not tainted =
6.15.0-rc1-next-20250410-syzkaller #0 PREEMPT(full)=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 02/12/2025
> RIP: 0010:bch2_journal_set_replay_done fs/bcachefs/journal.h:442 =
[inline]
> RIP: 0010:bch2_fs_initialize+0x15f9/0x1620 fs/bcachefs/recovery.c:1130
> Code: ff e8 eb a8 a8 07 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 04 fe =
ff ff 4c 89 f7 e8 32 7d a3 fd e9 f7 fd ff ff e8 08 51 39 fd 90 <0f> 0b =
e8 00 51 39 fd e8 7b 6f a3 fd 4c 89 ff 8b 74 24 38 e8 bf 3f
> RSP: 0018:ffffc90003c67420 EFLAGS: 00010293
> RAX: ffffffff848a29d8 RBX: 0000000000000000 RCX: ffff88802c799e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003c67920 R08: ffffffff848a1dfe R09: 1ffff11009c792c0
> R10: dffffc0000000000 R11: ffffed1009c792c1 R12: ffff88804e380000
> R13: ffff88804e380820 R14: ffff88804e3c9600 R15: ffff88804e3c95c0
> FS:  00007fa3bfd836c0(0000) GS:ffff888125080000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00009bfc0 CR3: 000000003475c000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> bch2_fs_start+0x301/0x620 fs/bcachefs/super.c:1100
> bch2_fs_get_tree+0x1138/0x18e0 fs/bcachefs/fs.c:2253
> vfs_get_tree+0x90/0x2b0 fs/super.c:1809
> do_new_mount+0x2cf/0xb70 fs/namespace.c:3879
> do_mount fs/namespace.c:4219 [inline]
> __do_sys_mount fs/namespace.c:4430 [inline]
> __se_sys_mount+0x38c/0x400 fs/namespace.c:4407
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa3bef8e90a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa3bfd82e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fa3bfd82ef0 RCX: 00007fa3bef8e90a
> RDX: 00002000000000c0 RSI: 0000200000000180 RDI: 00007fa3bfd82eb0
> RBP: 00002000000000c0 R08: 00007fa3bfd82ef0 R09: 0000000000000080
> R10: 0000000000000080 R11: 0000000000000246 R12: 0000200000000180
> R13: 00007fa3bfd82eb0 R14: 0000000000005a18 R15: 0000200000000440
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bch2_journal_set_replay_done fs/bcachefs/journal.h:442 =
[inline]
> RIP: 0010:bch2_fs_initialize+0x15f9/0x1620 fs/bcachefs/recovery.c:1130
> Code: ff e8 eb a8 a8 07 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 04 fe =
ff ff 4c 89 f7 e8 32 7d a3 fd e9 f7 fd ff ff e8 08 51 39 fd 90 <0f> 0b =
e8 00 51 39 fd e8 7b 6f a3 fd 4c 89 ff 8b 74 24 38 e8 bf 3f
> RSP: 0018:ffffc90003c67420 EFLAGS: 00010293
> RAX: ffffffff848a29d8 RBX: 0000000000000000 RCX: ffff88802c799e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003c67920 R08: ffffffff848a1dfe R09: 1ffff11009c792c0
> R10: dffffc0000000000 R11: ffffed1009c792c1 R12: ffff88804e380000
> R13: ffff88804e380820 R14: ffff88804e3c9600 R15: ffff88804e3c95c0
> FS:  00007fa3bfd836c0(0000) GS:ffff888125080000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00009bfc0 CR3: 000000003475c000 CR4: 00000000003526f0
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

#syz test

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index d2b07f602da9..606d684e6f23 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1125,7 +1125,10 @@ int bch2_fs_initialize(struct bch_fs *c)
         * journal_res_get() will crash if called before this has
         * set up the journal.pin FIFO and journal.cur pointer:
         */
-       bch2_fs_journal_start(&c->journal, 1);
+       ret =3D bch2_fs_journal_start(&c->journal, 1);
+       if (ret)
+               goto err;
+
        set_bit(BCH_FS_accounting_replay_done, &c->flags);
        bch2_journal_set_replay_done(&c->journal);
=20



