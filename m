Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E047E293B53;
	Thu,  3 Jul 2025 07:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751527193; cv=none; b=Jkw96MxsyyY7fVjXuyh0hQ0B67hS3Cc4Ln3PK32uO2mQVLwbElvoLEhnwsWuHsKQvbZvKd6/fqJTcEcv6vW5ItBF5Rk8GovST2fKM1JfjlZP5eHeyEHeIRVRp2FtRnOcwLHz4RFFM70yhOhEXTuA0dArw36PFU2QPMDNbxvebFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751527193; c=relaxed/simple;
	bh=kiX0JFjP5NR+W9JpkBrRkkixeVI5ZwDMdiYzvWIemz8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=O+j7BYDrAiBCD7LfP9m1u0zub5YoWMz3v379cbZ5sAOyfrsxt5Y1dQxf84jtmJ7s2zaSt/aHdVMwnt5nrGUejn87Oy1xxoH1DcgR1PT4Y5NoHCHWQ4DCFIPuTNwRWdV+NYjEbYZQ+5VX4Msa3twXpIADH1XVZ/HIC4fmCsRFw5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UC2FNxeR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UC2FNxeR"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-234bfe37cccso93331245ad.0;
        Thu, 03 Jul 2025 00:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751527191; x=1752131991; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SCjNGmqDoY0Yur1BoE0juKB2ttl80ROWlsxDI9cYNk=;
        b=UC2FNxeRg1aWlDsiRnTevRTeHRVsRMliuhtlrshsQA34fzInlDNcE/A5llQX1nF5E1
         Vuw0tumc392hH4lX2p/Z2ARoNsSvuIDdoTTbLr9oy2K0HkV3nMFkWos1omxJDwktZMnE
         n6CBzLiDwjTcxyh7mEtI+a8CFAt8lIXBJUeq2kjKOp8UZv5DOAizsadLPcnsW2wellpn
         gY7vtU5apJtxq/1uWrYrVHfVSfveMzMhog7lW8n4+JAsGCeUteZCl/GeKQuSxC6CnWoK
         Fl8hKEuBzD9DkDA8vXMA1hdr96hAcK/8sTfJVOgw2Q4ArvOycvzSUSD3LCVNpoosq3je
         oXEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751527191; x=1752131991;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2SCjNGmqDoY0Yur1BoE0juKB2ttl80ROWlsxDI9cYNk=;
        b=HOoFXuattUypG97BxXTClY2gUAupIBuFsRaBYI/diMqikur8QVKJkaB2APpmyIUW3F
         4MCLsK7JRlF8KqXPGDFbMleCl/BFH46vBIZQ58WuGHu71zq8NdJjDmqmvXW2LbVJQxXS
         Ngl6KwgsCeCA0vpM+QDMOqUQRWLvgx0yZG4FLogPJhFxQdoh4g270fhO1B8IWz1DvLv9
         iuB3yWA/Rj4BLkMRdx29lZi8yokDfE+yDCIjLfS93dDtylARXYXJfcclIrF0H7iNe8ue
         CdLwrto3ctAGTJQS/FKerI1kic8ErCCP12ZvHO6IzAZonqIcJBas4Ap1eKixLly0jBV2
         2JzA==
X-Forwarded-Encrypted: i=1; AJvYcCVWU5JYtJ+PBq5dSmw8gPTz/FMVL/TACtmla8I2l0au1bTMMv5IdFF20HJjorRH1nvtv9Npo/3mH3nCf1zR/A==@vger.kernel.org, AJvYcCXqliLHRD9QrD9eclx6Qmbez/ojYHKjVxknQgG9cnuSETIAq1EjE01NV/5MZaiuSOkkbN6+7t4vE74WfYhn@vger.kernel.org
X-Gm-Message-State: AOJu0YxH3xKSr5i9evO3H1SGEtpmDoIeUcvu8l1C1bThLm0UW+JDzk2H
	yOoJywaOCwrAMYTUzMp5WKce3n+TkU08R2TXPogqp5A6Uv5ZoFdVUb7L
X-Gm-Gg: ASbGncuwD51YZHh6Kdz5/KYt1E3Y+2lVE+N224dtcWQcQYmsnKEbSD+quX+qTo7jyYB
	LgXYshSVCUgQ9QzUS35bDP69Eu4GfrcJC0bDB1TRmiz7dephHbjC1UIgaoq/HfQKcZGT5SOjqGW
	ClxjqH8b3QqPdBU84abNCUZz2q4i1bIUsIaRImO9Rwewrxk9h8kJPxmN31wL09iyieMX26gfSaV
	+UMpymoveHvOz4VCj6M5ezH6C9gO7dWV8XTJKhEq+eqx9xI8QbM3YBeNuELMImZZzJxd0P6/ZKS
	vhEvUT0GL3BfK2baw3r7FkYgGMtwP1IgDhDrv2rjLspGwA==
X-Google-Smtp-Source: AGHT+IHQb50iWONDdZm3enefvc5V5CVLRdQt0jDWh1Lf8vZEnVr6n1UY3HGzTa0jM/DPgWOV0g5MWQ==
X-Received: by 2002:a17:903:19e6:b0:234:d292:be84 with SMTP id d9443c01a7336-23c796a1922mr33902955ad.10.1751527191074;
        Thu, 03 Jul 2025 00:19:51 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e300c8c9sm13042924a12.5.2025.07.03.00.19.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jul 2025 00:19:50 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] kernel BUG in __btree_trans_update_by_path
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <686611ef.a70a0220.5d25f.0833.GAE@google.com>
Date: Thu, 3 Jul 2025 15:19:35 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <4B44CAF4-89D2-415B-8D29-13FB7767A1D3@gmail.com>
References: <686611ef.a70a0220.5d25f.0833.GAE@google.com>
To: syzbot <syzbot+8deb6ff4415db67a9f18@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jul 3, 2025, at 13:15, syzbot =
<syzbot+8deb6ff4415db67a9f18@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    50c8770a42fa Add linux-next specific files for =
20250702
> git tree:       linux-next
> console+strace: =
https://syzkaller.appspot.com/x/log.txt?x=3D1191aebc580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dd831c9dfe03f77ec
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D8deb6ff4415db67a9f18
> compiler:       Debian clang version 20.1.6 =
(++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD =
20.1.6
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D1311d3d4580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D1770f982580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/eb40fda2e0ca/disk-50c8770a.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/cba4d214940c/vmlinux-50c8770a=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/4b23ed647866/bzImage-50c8770a=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/cd313604f9e1/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+8deb6ff4415db67a9f18@syzkaller.appspotmail.com
>=20
>  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq =
1db8f60c84bb244c written 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen =
0, fixing
> done
> bcachefs (loop0): going read-write
> bcachefs (loop0): journal_replay...
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/btree_update.c:339!

Caused by commit b47a82ff4772ea9d7091b85ef5f34dc78c866a02 (=E2=80=9Cbcache=
fs: Only run 'increase_depth' for keys from btree node csan=E2=80=9D)

The commit add an additional condition: !k->allocated


> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5842 Comm: syz-executor286 Not tainted =
6.16.0-rc4-next-20250702-syzkaller #0 PREEMPT(full)=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 05/07/2025
> RIP: 0010:__btree_trans_update_by_path+0x1fd3/0x2010 =
fs/bcachefs/btree_update.c:339
> Code: f6 ff ff 48 8b 7c 24 28 e8 ca dd f5 fd 48 ba 00 00 00 00 00 fc =
ff df e9 3d f6 ff ff e8 a6 c9 91 fd 90 0f 0b e8 9e c9 91 fd 90 <0f> 0b =
e8 96 c9 91 fd 90 0f 0b e8 8e c9 91 fd 90 0f 0b e8 86 c9 91
> RSP: 0018:ffffc9000413ea18 EFLAGS: 00010293
> RAX: ffffffff842e0b42 RBX: 0000000000008542 RCX: ffff88802ea71e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888031194010 R08: ffffffff84518baa R09: 0000000000000002
> R10: 0000000000000003 R11: 0000000000000000 R12: ffff888074e00000
> R13: ffff888031194000 R14: 0000000000000088 R15: 1ffff11006232802
> FS:  000055555e045380(0000) GS:ffff888125c1d000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055e03c677168 CR3: 0000000078920000 CR4: 00000000003526f0
> Call Trace:
> <TASK>
> bch2_trans_update_by_path fs/bcachefs/btree_update.c:454 [inline]
> bch2_trans_update_ip+0x8f6/0x1f00 fs/bcachefs/btree_update.c:546
> bch2_trans_update fs/bcachefs/btree_update.h:123 [inline]
> bch2_journal_replay_key+0x4c1/0xb50 fs/bcachefs/recovery.c:311
> bch2_journal_replay+0x171d/0x2630 fs/bcachefs/recovery.c:396
> bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:484 [inline]
> __bch2_run_recovery_passes+0x392/0x1010 =
fs/bcachefs/recovery_passes.c:539
> bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:610
> bch2_fs_recovery+0x2690/0x3a50 fs/bcachefs/recovery.c:1005
> bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1212
> bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2488
> vfs_get_tree+0x92/0x2b0 fs/super.c:1804
> do_new_mount+0x24a/0xa40 fs/namespace.c:3902
> do_mount fs/namespace.c:4239 [inline]
> __do_sys_mount fs/namespace.c:4450 [inline]
> __se_sys_mount+0x317/0x410 fs/namespace.c:4427
> do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f878cb709ba
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc9f662588 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffc9f6625a0 RCX: 00007f878cb709ba
> RDX: 00002000000000c0 RSI: 0000200000000080 RDI: 00007ffc9f6625a0
> RBP: 0000200000000080 R08: 00007ffc9f6625e0 R09: 00000000000059b9
> R10: 0000000000818001 R11: 0000000000000282 R12: 00002000000000c0
> R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffc9f6625e0
> </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__btree_trans_update_by_path+0x1fd3/0x2010 =
fs/bcachefs/btree_update.c:339
> Code: f6 ff ff 48 8b 7c 24 28 e8 ca dd f5 fd 48 ba 00 00 00 00 00 fc =
ff df e9 3d f6 ff ff e8 a6 c9 91 fd 90 0f 0b e8 9e c9 91 fd 90 <0f> 0b =
e8 96 c9 91 fd 90 0f 0b e8 8e c9 91 fd 90 0f 0b e8 86 c9 91
> RSP: 0018:ffffc9000413ea18 EFLAGS: 00010293
> RAX: ffffffff842e0b42 RBX: 0000000000008542 RCX: ffff88802ea71e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888031194010 R08: ffffffff84518baa R09: 0000000000000002
> R10: 0000000000000003 R11: 0000000000000000 R12: ffff888074e00000
> R13: ffff888031194000 R14: 0000000000000088 R15: 1ffff11006232802
> FS:  000055555e045380(0000) GS:ffff888125d1d000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8f8b3a1796 CR3: 0000000078920000 CR4: 00000000003526f0
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

