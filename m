Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913E3F9D6;
	Fri,  8 Aug 2025 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754632006; cv=none; b=q24P8vuKDVLDMfzgLCzxv+qeX1xP+L0sAMKpcRL71iuTzFL0dmDc4dANuvnR4FJNmcwVDJeEuiyztUtN6G8z77+HfbqVQk52RMPI+2B46xtxgRo2ujXrmeSuXppPLDLQpQSYZupbYBJcpSvqdewiglYe8TonKfm2jIOmSo102yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754632006; c=relaxed/simple;
	bh=SaJ+0IPa6kquZ4dEIDNmhajzUcqO5AHFUFvRu0KQ1YE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tZQhMSNU2q2alD/1k+eGH4ZWtcATtx5xE9zqePNBw/N2D7EVtS+CMN8vxGmJFzVX96hB/5V4MpWwGRw7ByLBKnwfug0A+lRx5X8nmFy56F0Kl9o91Sm4cXyn4NuC4hgvLDs9eLsvTax1K/dfAfnRxxAYj762rXSYPHKbKHZle3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNi7Oc7p; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNi7Oc7p"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76bd6e84eddso2297119b3a.0;
        Thu, 07 Aug 2025 22:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754632004; x=1755236804; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzJNeJceayQzxiqleA4V9oOf0cRVS9OsNem3Aj5gx3s=;
        b=nNi7Oc7p7XKQkCg7GE4cNzgwYfJQkmVGI3S/scOOw8QrkvqukcgKROsmDOO2Et2C+h
         wjpStzE31D+Y4oMBqRtjEiZ4OKDDHlBvnfKkz41scANhIR2/YYrVLPiNannDCPcVYyL5
         1dm7/COpYrjegk37JOge7h36YbGT9pT2h5U4bO5mq2nN+v9e7TmqibbcVXqR5Z1d3B5S
         D4lnH/Kc7LfhWp4MLudCOk8xn2fK9Lm0C+laszzAqol/Rv/gWSSJi6gI+8U6f9yjYE1k
         V1f6QTA6jvd9kEV3FquHi+1epyPQxYsdzBXhOoSgQ0RXppcT7B2ms/C3tcCzTuCBRW9c
         3Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754632004; x=1755236804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HzJNeJceayQzxiqleA4V9oOf0cRVS9OsNem3Aj5gx3s=;
        b=TFmBSLCT5xC6WjZjA0ddCGz7Xuc3IoCzSMbVuK//QHE4NQ88aRcQ9UKtYQGw5oL7Dp
         GfE49lvjqWX/gAg17aAjXBxgJKIpGywrVHvaXPKqBJN1HWl9OgkjKlmTvnP6rg7b1k8h
         PuObysja/Vg1rrgbUj5NUbGkVmHDmjGeVR3iYzIaUTlRkUBpHgyqJSfThKRsTwLV5tHP
         4pnhd+fI9SwbpLhnWoMwAYoublrApooxHxkBk/M9UU5r7lyy65ifljzTuLN8ihRMJjzF
         PFUzBHh6pkvMtUFvBB6pX3LttujU7YzPlwvN77zj6NypcN9RsunXx9XE9bW7vBMaxnRf
         0mFQ==
X-Forwarded-Encrypted: i=1; AJvYcCU841WWBwWbCTiA1YX05ulRvujpewTjPLeEl2IRKc9sBJz29IwkDTzmqGju/+3d8Q3cquQqi/ZwQLaO+xXwxg==@vger.kernel.org, AJvYcCUycDyysFSsScDWcCivPAn93DlqJRDGUUDRwTZ7hMG1CiD09Kk+QYborQNGVvuYAYqFF5uMC9GwwAe/Nil0@vger.kernel.org
X-Gm-Message-State: AOJu0YzUQ7TMHmK9WfGSUZVKIuWuMSc6b6dWlwtpqWQpFiM6NFb0gcWs
	boIKUjyattFwB7qmx/+JvvKsSN9A8Z80htz0+TuJ+nTh1n5yXsCiAkjG
X-Gm-Gg: ASbGnctG/DXlamhGy7/t0+5M+Meuj3K/WFmGLr4LSW1cY5on39cJuHa0Mli7miE3bgf
	Ceho20iiuOyxwDVOC8um1WQ6x+dZzobO6Cj3MgncVXC8ImsjkW/itHK387jLJztpQkEj2QERe3E
	tEFnWu0hxFh/YuldTunRC0lvkadFDTHLQsBDWEY8CtIJ950qM4BFXzzqYIPg1uHOlIYW7faBiBI
	Idgn/ELtqRveNC+Ayw2YZKWQm+rgi+Na7WHHGsbWbZ2vi4LMzvUl9MVm2EOrHu1LgoK5vTjyd/P
	XKViA85U/JxFvTyeHE75XEHbm+u+IYHRWLcz7qgU6z9WHjkwG2ZyDCm4aN8fPe5Y2wRJHHxuxyt
	kS5Y9Qw==
X-Google-Smtp-Source: AGHT+IHOvQUcJMmiCNry3ZIzGU8f4YL8DV+0B3GFNTPuyMA8WvnFMZpTvmgcnDSBg8fezKfzMfRX9w==
X-Received: by 2002:a05:6a00:4614:b0:76b:dedb:3048 with SMTP id d2e1a72fcca58-76c4617fd1amr2769508b3a.14.1754632003862;
        Thu, 07 Aug 2025 22:46:43 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfd4893sm19402040b3a.107.2025.08.07.22.46.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Aug 2025 22:46:43 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] kernel panic: bcachefs (loop0): panic after
 error
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67282553.050a0220.35b515.01aa.GAE@google.com>
Date: Fri, 8 Aug 2025 13:46:27 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C36685A-875B-48D8-82AE-8A9D30233022@gmail.com>
References: <67282553.050a0220.35b515.01aa.GAE@google.com>
To: syzbot <syzbot+4c6e722ab29ba1d06b19@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Nov 4, 2024, at 09:37, syzbot =
<syzbot+4c6e722ab29ba1d06b19@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    4236f913808c Merge tag 'scsi-fixes' of =
git://git.kernel.or..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D116da55f980000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D4aec7739e14231a7
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D4c6e722ab29ba1d06b19
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D1792c630580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D156da55f980000
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-4236f913.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/ca5604c008a4/vmlinux-4236f913=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/34ea5692a94f/bzImage-4236f913=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/8ac365f356c8/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+4c6e722ab29ba1d06b19@syzkaller.appspotmail.com
>=20
> bcachefs (loop0): starting version 1.7: mi_btree_bitmap =
opts=3Derrors=3Dpanic,metadata_checksum=3Dcrc64,data_checksum=3Dnone,compr=
ession=3Dlz4,background_compression=3Dgzip,no_splitbrain_check,nocow
> superblock marked clean but clean section not present, shutting down
> Kernel panic - not syncing: bcachefs (loop0): panic after error
> CPU: 0 UID: 0 PID: 5308 Comm: syz-executor415 Not tainted =
6.12.0-rc5-syzkaller-00047-g4236f913808c #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> panic+0x349/0x880 kernel/panic.c:354
> bch2_inconsistent_error+0x146/0x150 fs/bcachefs/error.c:26
> __bch2_fsck_err+0x10ee/0x1570 fs/bcachefs/error.c:425
> bch2_read_superblock_clean+0x3b4/0x520 fs/bcachefs/sb-clean.c:152
> bch2_fs_recovery+0x1f4/0x39c0 fs/bcachefs/recovery.c:640
> bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
> bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
> vfs_get_tree+0x90/0x2b0 fs/super.c:1800
> do_new_mount+0x2be/0xb40 fs/namespace.c:3507
> do_mount fs/namespace.c:3847 [inline]
> __do_sys_mount fs/namespace.c:4057 [inline]
> __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7d3c001eba
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffe9e18a88 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fffe9e18aa0 RCX: 00007f7d3c001eba
> RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007fffe9e18aa0
> RBP: 0000000000000004 R08: 00007fffe9e18ae0 R09: 0000000000005951
> R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
> R13: 00007fffe9e18ae0 R14: 0000000000000003 R15: 0000000001000000
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

