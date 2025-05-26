Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199C13A3ED;
	Mon, 26 May 2025 10:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748256086; cv=none; b=J0DJ6T6KWLiJSyU6Ys7VDyZhadmVHrUG8xzEZczACUQRPUbZtJNGXoLNt8/9EU3d7khsGceelfEBpNxVx5FEUrW0FmkD4HUq4q6QvxNF7PM0q9n5AL9JCbydVjxPR1TtAwU5H3Abm6uDjuMpjAQepR/N42Xm9rEOwmuK8Ct4z5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748256086; c=relaxed/simple;
	bh=uniVZXHisSJScHw1shsREVuOLfkfu2eNRJYvh35wzE4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=uvhqZ8dxI2IRjGF7lxVTLLJPrezuM6hmX3B21jpSvl3k55JapWqE++bjSyzT/Zvu1RYC4Zq1zUvGL+qOn6qTpME9IARA6MG6/RXEeio6pFwrqmCtBMgaKUlTQOotfG1bzMfGPB/OdJsseRKmFjRs02xGiQd9mWmIUP4Mlbu0Xhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BJBMmLbH; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BJBMmLbH"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2347b7d6aeeso4026575ad.2;
        Mon, 26 May 2025 03:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748256085; x=1748860885; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5UYmpqJS9ZcSi76Quh1tEJ70UWXrT46fckri5gwqHNo=;
        b=BJBMmLbHM00H5EVLEGBBjlP02PYxnwsPb2Q301dit81bEzX80w/i6xcfMWcSIWXzNS
         vf3zpveBt81N8kyAMVof5tjMYlYb4aPho7RpWgXt0uH6v8d0eg1SlA6UQyq/yy2CF+5S
         +Q1Y1sGwL/9u6I+MCmLCdG8GlkJpTyePyQvqEeULlSa62uDCGJv0Rm5erwAeCRqK9N9K
         uH/EfPe1AXUgv6fNNCmFmcTQmzPcQjJ6MZQAGC/SIC6Kg3dkTg56DYqmAuUwSzH8e0Iq
         u6IImsFBT3JVG8q4fblw8qqUXXQdwvS472cGngu8LqMxclf1FMGJ4tnWh2hnOK4LhJis
         PH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748256085; x=1748860885;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5UYmpqJS9ZcSi76Quh1tEJ70UWXrT46fckri5gwqHNo=;
        b=gHuyluT0FwJTwM4h+0FYTdmh5IisR6KBOXj2OaEP1U761qDo92kQiO4Nye9FHJHdka
         4w+DqFtz9IdF+uRisSOeXTA+TZq+YrJITEnviaWhRYjFzyW6rDIGQnqSne31xxQeDyo7
         2LpWXcIFPfMVKurl9az8AwHb1XvKOoAI0QhHiYQG5FTyInWKLK8NZ4Ke5fkwuU9J/yK/
         7hCak8/90LomGZA62mlnfuMy0/KDL2RUWmYoye3AjBaRSV2f69A9HjQRi5UMaQ4rlEQm
         DhtZUUR6ZK6KrE3CGimyJ5ScGhaDytUD3MW/lBDp+5z58IS9Ou1ypnzv6bPC7wK1GBi9
         s/3g==
X-Forwarded-Encrypted: i=1; AJvYcCUkGxlvYztlBrqR3aLZV0plqzvF+LgtXZmqOacv8PpOc9Q2aeGEgmibHkzVCkKNFaIpe95AKYnYjax7bgJy@vger.kernel.org, AJvYcCWfwVke0iDDJdYjST0EcIqoljA5DlslDvKPY5+NYlymROVkU9Qj4Y7+T/bw+UPSydv6Ya/4Q3cVlP+kCw+uAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzF0tLfWw3gKADNGO/6zHO/8VDaWxNgLy3HZc58eMx9lw5d4u7o
	GGrixcufXaYcY0JvCSzFdZS5mMECjpW4vsCn8hN55VY0iLGj+27EPfDQ
X-Gm-Gg: ASbGnctJYsDdONPoQeQbnB9q5yNM7gSUgHxoeVMZA9LVt7EPIeLreXt6/eqzOJcF7Dz
	kNWwn7wjXl6PCAKYvbTdjzl9w1Gfawx/JeGkxOC6OCeODlN/0o2f4tYhvkidAy+3dFvuZyTkKgO
	2dJGLkD5IO43dGWwYcfL2OOzxN4uPxJDAGB1HMviNQgtD1Z//R0jjEvy9s3yfP6TfY5F1FZ6zw0
	ZB2DwUWRSKfROFlt0nRWm6TrempEVJUD7VwGbwaVSwbOk14i6AV+1Tn5Y4rPqgU5tihYUFX3S2A
	u+1qbbyx9B371TnI26NTNzr7BcxhyC7iQIE=
X-Google-Smtp-Source: AGHT+IHwjO+XzLFOoHEsNDT4HAGv7G6Gb8U7JzlmEcmelv3VMjE9rrEkbcjrIN5UTlrrcwM9WFLJkg==
X-Received: by 2002:a17:903:1a67:b0:231:f97c:f2cc with SMTP id d9443c01a7336-23414fcd3d7mr146361485ad.39.1748256084582;
        Mon, 26 May 2025 03:41:24 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23448a49ac1sm21983375ad.73.2025.05.26.03.41.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 May 2025 03:41:24 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] WARNING in rhashtable_init_noprof
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <68342b55.a70a0220.253bc2.0092.GAE@google.com>
Date: Mon, 26 May 2025 18:41:09 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <05DB907D-8EF0-4E16-A133-3E32A8F8FD1C@gmail.com>
References: <68342b55.a70a0220.253bc2.0092.GAE@google.com>
To: syzbot <syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On May 26, 2025, at 16:50, syzbot =
<syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    176e917e010c Add linux-next specific files for =
20250523
> git tree:       linux-next
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D13d555f4580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3De7902c752bef748
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3Dbcc38a9556d0324c2ec2
> compiler:       Debian clang version 20.1.6 =
(++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD =
20.1.6
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D145948e8580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D13d6a170580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/5f7692c642fa/disk-176e917e.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/057a442d42d0/vmlinux-176e917e=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/8f8ebdb4dd96/bzImage-176e917e=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/d3d310848021/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com
>=20
> ODEBUG: object ffffc9000469fb90 is on stack ffffc90004698000, but NOT =
annotated.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 =
debug_object_is_on_stack lib/debugobjects.c:655 [inline]
> WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 =
lookup_object_or_alloc lib/debugobjects.c:688 [inline]
> WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 =
__debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
> Modules linked in:
> CPU: 1 UID: 0 PID: 5924 Comm: bch-copygc/loop Not tainted =
6.15.0-rc7-next-20250523-syzkaller #0 PREEMPT(full)=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 05/07/2025
> RIP: 0010:debug_object_is_on_stack lib/debugobjects.c:655 [inline]
> RIP: 0010:lookup_object_or_alloc lib/debugobjects.c:688 [inline]
> RIP: 0010:__debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
> Code: cc cc cc 41 ff c7 44 89 3d a4 18 14 15 48 c7 c1 80 9b e2 8b 48 =
c7 c7 e0 9b e2 8b 84 c0 48 0f 45 f9 48 89 de e8 48 2b 61 fc 90 <0f> 0b =
90 e9 c0 fe ff ff e8 3a 1c 00 00 8b 05 1c 9c c6 09 3b 05 1a
> RSP: 0018:ffffc9000469f6e0 EFLAGS: 00010046
> RAX: 0000000000000050 RBX: ffffc9000469fb90 RCX: 0aa01120dfd08500
> RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
> RBP: ffff88802f5c9e20 R08: ffffc9000469f3c7 R09: 1ffff920008d3e78
> R10: dffffc0000000000 R11: fffff520008d3e79 R12: 0000000000000040
> R13: ffff8880771e5d20 R14: dffffc0000000000 R15: 0000000000000001
> FS:  0000000000000000(0000) GS:ffff888125d56000(0000) =
knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1c5ee80000 CR3: 0000000077540000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> rhashtable_init_noprof+0x7c0/0xbb0 lib/rhashtable.c:1085
> bch2_copygc_thread+0x116/0xdc0 fs/bcachefs/movinggc.c:355
> kthread+0x711/0x8a0 kernel/kthread.c:464
> ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
> ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
9b38df1f0d770aef29fd6aea023b28b053e14ecf

