Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D684EF9D6;
	Fri,  8 Aug 2025 05:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754632124; cv=none; b=u2CCHusfpGdTFzP2r/x7sQc8t08vbLRskvcwmVjkgkbTWe1NMQo2PpB/AMeGZZjxPgEAGDg9ti0bXH+cXxEgP8RycSXQWywIUqacoIjK5gKQJK+YI36++al/HWmRs34ES6MLhIAYdQoapnsf2Uxy6Cuvd3RLeFLtHETHyxneOoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754632124; c=relaxed/simple;
	bh=64y2OLmJjdjiOFIbQx6H/LHiAxwplk2LZmhhZcCz6v8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EZwiderFIX8O6NPb5Ro6w/ZXkjQe5z3aihUyaCs0KfK4b1IzX4EUK1GXNAQrTMz0i5Q2/RQk7fXBVVa6Il6BKGE57A4T1W7TKx/0Hol8iTlAaDjtPWX2+6Kw17ALKar/Nt/7LrbNdaGhyRkbwE4g0ZduuDa2nHYN7JuK9vYWX88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIrnwE/w; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIrnwE/w"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-31f3b54da19so1298510a91.1;
        Thu, 07 Aug 2025 22:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754632122; x=1755236922; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Di83UKe+p2WYB6K8Bhu617LpYCqcFl/0LRwLRoC3QGk=;
        b=XIrnwE/wt8TZSNwPkjt7KxM54tzobWI1ouF9ubAHvznh8IGbnR2/tcfRrpzIUCMwpU
         uKEnKZ2jFXzBKawtA50SiWbfoD0+6pws5vdsC8KtDkyDq+fvFKIs41OsJk/7dWt3Z6Gf
         AVsHNoalbrSnyxaB/WmMqyrAvQORwTOpeOLUZr66td7KwS13DiuxtU8IwbiMbiZ58MSm
         YFSu9jAgAOx5sUncjy9e6OF7DWnbeJTdKeDak6QvMOPikuCBKK4NCayaeiYRfF6HbZ0F
         MHEVaLtRtCV5WthqEWCy86FOKqwUH0YuV5rMcHjzj4lphGNSo/fFoTsZKyUmutfcmwAL
         CkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754632122; x=1755236922;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Di83UKe+p2WYB6K8Bhu617LpYCqcFl/0LRwLRoC3QGk=;
        b=fM9jCQwAe9urHox0TKikRYS7Q+X9XpcgO2BKF8T/MnfhxEb62gxTdiBsRifReKmbRn
         ZePs1hkxQkTj9KKGY1EkbEdcsOtbFRUbDBPXTPRcmatuKZUYAkuIrHf6udsTBuY4522B
         aPtL90r1ZgyUC/5RESouxzh+9+ZfgJZeIlt3euYMw7TR/7F+kHGR8HoudF0UyRQWktLv
         oHtLxnXwUVU7Nn7zsvZomXV/5ZRzNJ0AcEhtC+nS/e87mAfNlY34HMnDCQcM80TjRzVS
         REGKflKe6PtA6qNG7HhlyDfGRvkh7UJNVwmkejE9dix61mCr5Y1LsW5ufVI3oGOk4nGV
         ajaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNS7+gwaVa41Mu/dvafPRab26AtxIOaGPgUObCar+UiXBproyolPAHYclDjPh7a0sV0qQ3yEqsjC5mhs2W@vger.kernel.org, AJvYcCVWJUAUWSv8F+fRyDxLp+DGbEALa4Bnm4bWs/Kd1L+7BwOuoQWIHusLF7FwgydtNU/V/yPXeBHnzP+fqdfVPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YznURlA9VeyqSy0LBt9oRksN5aEM0+o02ZfaThqFHOQMvubMvj7
	tX5ltaI9cgiSa6IMtpUOh9otnhmOR4pbCM8rTz+YkSEM6iXA+Rp7qiPF0i6Yyg==
X-Gm-Gg: ASbGncvtVm9E4fyIaLuRQAd/Gn0OUyUM7ZSgUb1HPirRXkYgKbSH9ZbXOvuBVD8cdk4
	0Ptau5nD7I8ALakpcEELktDIDQ+DckQC7WvgNhVyRhYlNOXR2MIn0BINM/mPaBqOtG6bmN40pZh
	yRp/ZpCaf562OyVctB5BV20H8kuD/eoHL83LSmIFh+jyICWw5oLsG0YA3C2Qu5K1tZ6zgud0L+p
	LtuOwZcDnf+D9w2cVBiZASgvt3yfTlp/5WMGpaZ4jIRu9e97QRhfzCLEVeA46ccVMt8zmkdsBxh
	6fe0Xad8LUp2NxbNR9ZQMcqt5YCfhba2cMDLL3hQ1U9dxaXk6wgLphrvYsEV4JYWRJ+2ox8B01G
	KysU7nQ==
X-Google-Smtp-Source: AGHT+IGg+3+ZL60XYJPsSJRomyR+ggvwba0ih7eFvK/+JsJ9obnCWfYe1uG87m3FdKyyKpdB42yx2Q==
X-Received: by 2002:a17:90b:4c8a:b0:2f8:34df:5652 with SMTP id 98e67ed59e1d1-32183b4382cmr2647211a91.21.1754632122159;
        Thu, 07 Aug 2025 22:48:42 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-321612815c4sm6925191a91.23.2025.08.07.22.48.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Aug 2025 22:48:41 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] kernel panic: bcachefs (loop3): panic after
 error
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <670bd8cc.050a0220.4cbc0.0031.GAE@google.com>
Date: Fri, 8 Aug 2025 13:48:26 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <67AE3CA9-C03C-4292-8456-745BA07F69B0@gmail.com>
References: <670bd8cc.050a0220.4cbc0.0031.GAE@google.com>
To: syzbot <syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Oct 13, 2024, at 22:27, syzbot =
<syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    75b607fab38d Merge tag 'sched_ext-for-6.12-rc2-fixes' =
of g..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D10d35780580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D7a3fccdd0bb995
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3De6ea15c610261d2106ba
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D14560f07980000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/283eaf72a57c/disk-75b607fa.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/a721235f5b80/vmlinux-75b607fa=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/f5219ace4d70/bzImage-75b607fa=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/c65430058ea3/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+e6ea15c610261d2106ba@syzkaller.appspotmail.com
>=20
> bcachefs (loop3): starting version 1.7: mi_btree_bitmap =
opts=3Derrors=3Dpanic,metadata_checksum=3Dcrc64,data_checksum=3Dnone,compr=
ession=3Dlz4,background_compression=3Dgzip,no_splitbrain_check,nocow
> superblock marked clean but clean section not present, shutting down
> Kernel panic - not syncing: bcachefs (loop3): panic after error
> CPU: 1 UID: 0 PID: 5433 Comm: syz.3.18 Not tainted =
6.12.0-rc2-syzkaller-00058-g75b607fab38d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 09/13/2024
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> panic+0x349/0x880 kernel/panic.c:354
> bch2_inconsistent_error+0x146/0x150 fs/bcachefs/error.c:26
> __bch2_fsck_err+0x1167/0x15f0 fs/bcachefs/error.c:422
> bch2_read_superblock_clean+0x3b4/0x520 fs/bcachefs/sb-clean.c:152
> bch2_fs_recovery+0x1f4/0x39c0 fs/bcachefs/recovery.c:639
> bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
> bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2080
> vfs_get_tree+0x90/0x2b0 fs/super.c:1800
> do_new_mount+0x2be/0xb40 fs/namespace.c:3507
> do_mount fs/namespace.c:3847 [inline]
> __do_sys_mount fs/namespace.c:4055 [inline]
> __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb67417f79a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb674f20e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fb674f20ef0 RCX: 00007fb67417f79a
> RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007fb674f20eb0
> RBP: 00000000200058c0 R08: 00007fb674f20ef0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020000100
> R13: 00007fb674f20eb0 R14: 0000000000005957 R15: 0000000020000080
> </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
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

#syz invalid

