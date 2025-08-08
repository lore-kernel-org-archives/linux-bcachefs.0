Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B76C2253EB;
	Fri,  8 Aug 2025 07:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754637872; cv=none; b=pxfCcBPMikAKRYXeXAFHsdfuR3dIqxRQIWt1KQvni4WxSVAxP0cvDInYolIzJWu7VptexoinGLXaZeZpUkGXv3TqZWvVLM8rsHw8dAINEL/OvwxP4NiZBTLO8va6Hyl/fCHqVWuLjQ3iBZhA/NYEQNCnfXOylcfBAgWKO6WOX2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754637872; c=relaxed/simple;
	bh=CoyAj5ykzX0RsUkQzxfR9fWF0JGaTLnIfiCV/+2rXAI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ODhJeTlfsLzOvmMeskS6wBCgSdosjY4l+Svdvzz2WNsgqUNW6VCixbQM9cLiPcEye/wJ00+kMl/7Q/OQTmThUZcNFJXTJo3XpUG5xtsSqRySgCJ6dGfqEfC4l582tl+r6C/djCFLC/+abHlVXcVZX+Fm0sZ+vXDSLT0cZj3uFN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VvtFYjcH; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VvtFYjcH"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31ece02ad92so1524447a91.2;
        Fri, 08 Aug 2025 00:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754637870; x=1755242670; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kq6jfnH6Ny9gPRgiG3cjYrW5tpA/eQz2qFEMu+Bkk8=;
        b=VvtFYjcH7q5tky4rWqWBmWe0RmTACIuSC7e1+wWJOiz5agrdK/d7SuBofpeEfzsQy7
         xmUY+RTPUKBlFtMybjDlNc49rkR8sfPVW3ds59gsNNbw4syYrVMiw1dy4IhUwKhlNEOn
         sylGfMrrOJGMpqkcbcQxBz55qibnqS11s/zaFHmtuaKY2FayVvLGET6lCxGHiXo457Z3
         EimbotL3tInC7ZhmkkG0X+PlFYzgrqArFgE3o5SL5+FJv7MVNgF+u9IFMdKd/xO38KE8
         QPEishWGCORMvsntMt3F5BvcxeF6ZWvpU7+YBREXFKXeUMG8ZGPPYVmh8ygSpXdOOQYh
         vUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754637870; x=1755242670;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8kq6jfnH6Ny9gPRgiG3cjYrW5tpA/eQz2qFEMu+Bkk8=;
        b=GvPKOtWmuBU+17NyDuXEtVNTCGVIoQ2Iagq0rLH5sKItGKbqpbeBz5uBDNYAXyHqW9
         aVfRIh0BJOBU0/9Od4/VrYGydofj92+Ea2Oi71sT/wbLtmv/gxC5MaK15eKUEsstSlD3
         QoBhoj9zdhHxyas7RW/zcBjK551WMBmIvxhM6QgmsMqWoUwflnu0w+4lrH+M94R56F/9
         AJ2URoCVTuX4xVT//ScieCGI3GcdSmHvPVG7l0WdBwKEDQaf92qfxvIX2M5MU4bUokRL
         5TaXx56B40y9NgcJNJgaCPGkMfeClBEEQdCMXHhhQMRogh5AZxRTCLkUl42lBX04nhMi
         uTOw==
X-Forwarded-Encrypted: i=1; AJvYcCV4yjJE65ba0mKO/PuiUzV/iRnkvu17G+MNcZ/e95A4+CNYkqnm1zrAMnjbWvWpaClXCZgzuJBmp022U0a5@vger.kernel.org, AJvYcCX3vGlDTzHTCruhp5q3nDQe62Xbzei+wdkx8+yLpTXN8QqwaTYuh0IDKsC4Q41gXi87XuqGt5cVvuyETuJmrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVZtNjOwXxcEwI4dwvWizIKRLjjnioYE4LH2uY8Qq2v7lsa9we
	kYUpiPwnSoU5DXihvw6xg/2wqLhVQR/8uzJdVF9NEJjVGrvvsrkVhgwM
X-Gm-Gg: ASbGncuyBOq4JSFiD5WWGYc9xlWnarLX+EKSzZymAqMEf43/HHhaGQpLjNEs2uUdned
	V+e6cfH6H493qgiQY3cFfTj741dhWevwl1g5SIP8WYsZyrTBKylTUuN+K6PzmdIeWADYZOlcGu0
	8utWuo3mVFT2AxR433nYmBSFPNIzO8vPsJR4lD7jRyN0OhOx8fIVKRL/5bbF031FkXW/Ji/JUZc
	l326GBqkAlN74o/VT5ys5gWtxeAf/XUch8yvwwNw6fC1rFymSpUATLRwJdmb2RSsWbvOPE1a+7y
	CT4mRW+pWtJ8h+7UTQ/1EuJa0E30K+OBV6G0+6fcs9qyKVG13hzv0ga1YPPeIdppddiMHWnQutU
	ySMIHZnTdPW4jz9eT
X-Google-Smtp-Source: AGHT+IGJsxvBasl+HRN4thk+yxnR9s6JRomaZlNIoO0K+w92vAXmpA79Cm8QdXqYOdzpt7F6+Lv8sw==
X-Received: by 2002:a17:90b:2685:b0:2fa:157e:c790 with SMTP id 98e67ed59e1d1-321839d6666mr3234299a91.5.1754637869597;
        Fri, 08 Aug 2025 00:24:29 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63dc4ef0sm24164488a91.14.2025.08.08.00.24.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Aug 2025 00:24:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] possible deadlock in trans_set_locked
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <6749f54c.050a0220.253251.00bc.GAE@google.com>
Date: Fri, 8 Aug 2025 15:24:13 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <80513B36-FAE6-4CB6-855B-029E2CAE235B@gmail.com>
References: <6749f54c.050a0220.253251.00bc.GAE@google.com>
To: syzbot <syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Nov 30, 2024, at 01:09, syzbot =
<syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch =
'iommu/arm/smmu'..
> git tree:       =
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git =
for-kernelci
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D17d6af78580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D9bc44a6de1ceb5d6
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D78f4eb354f5ca6c1e6eb
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> userspace arch: arm64
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D107bdf5f980000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D13ae49e8580000
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/4d4a0162c7c3/disk-7b1d1d4c.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/a8c47a4be472/vmlinux-7b1d1d4c=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/0e173b91f83e/Image-7b1d1d4c.g=
z.xz
> mounted in repro #1: =
https://storage.googleapis.com/syzbot-assets/5ab7b24d2900/mount_0.gz
> mounted in repro #2: =
https://storage.googleapis.com/syzbot-assets/fbfbb60588c1/mount_2.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
> ------------------------------------------------------
> syz-executor203/6432 is trying to acquire lock:
> ffff0000da100128 (bcachefs_btree){+.+.}-{0:0}, at: =
trans_set_locked+0x5c/0x21c fs/bcachefs/btree_locking.h:193
>=20
> but task is already holding lock:
> ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: =
__bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
>       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
>       __mutex_lock kernel/locking/mutex.c:752 [inline]
>       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
>       __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
>       bch2_check_alloc_hole_freespace+0x5fc/0xd74 =
fs/bcachefs/alloc_background.c:1278
>       bch2_check_alloc_info+0x1174/0x26f8 =
fs/bcachefs/alloc_background.c:1547
>       bch2_run_recovery_pass+0xe4/0x1d4 =
fs/bcachefs/recovery_passes.c:191
>       bch2_run_online_recovery_passes+0xa4/0x174 =
fs/bcachefs/recovery_passes.c:212
>       bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
>       thread_with_stdio_fn+0x64/0x134 =
fs/bcachefs/thread_with_file.c:298
>       kthread+0x288/0x310 kernel/kthread.c:389
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
>=20
> -> #0 (bcachefs_btree){+.+.}-{0:0}:
>       check_prev_add kernel/locking/lockdep.c:3161 [inline]
>       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
>       validate_chain kernel/locking/lockdep.c:3904 [inline]
>       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
>       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
>       trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
>       __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
>       bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
>       __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
>       bch2_check_alloc_hole_freespace+0x5fc/0xd74 =
fs/bcachefs/alloc_background.c:1278
>       bch2_check_alloc_info+0x1174/0x26f8 =
fs/bcachefs/alloc_background.c:1547
>       bch2_run_recovery_pass+0xe4/0x1d4 =
fs/bcachefs/recovery_passes.c:191
>       bch2_run_online_recovery_passes+0xa4/0x174 =
fs/bcachefs/recovery_passes.c:212
>       bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
>       thread_with_stdio_fn+0x64/0x134 =
fs/bcachefs/thread_with_file.c:298
>       kthread+0x288/0x310 kernel/kthread.c:389
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
>=20
> other info that might help us debug this:
>=20
> Possible unsafe locking scenario:
>=20
>       CPU0                    CPU1
>       ----                    ----
>  lock(&c->fsck_error_msgs_lock);
>                               lock(bcachefs_btree);
>                               lock(&c->fsck_error_msgs_lock);
>  lock(bcachefs_btree);
>=20
> *** DEADLOCK ***
>=20
> 3 locks held by syz-executor203/6432:
> #0: ffff0000dc600278 (&c->state_lock){++++}-{3:3}, at: =
bch2_run_online_recovery_passes+0x3c/0x174 =
fs/bcachefs/recovery_passes.c:204
> #1: ffff0000dc604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: =
srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:150
> #2: ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: =
__bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
>=20
> stack backtrace:
> CPU: 1 UID: 0 PID: 6432 Comm: syz-executor203 Not tainted =
6.12.0-syzkaller-g7b1d1d4cfac0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 09/13/2024
> Call trace:
> show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
> dump_stack+0x1c/0x28 lib/dump_stack.c:129
> print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
> check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
> check_prev_add kernel/locking/lockdep.c:3161 [inline]
> check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> validate_chain kernel/locking/lockdep.c:3904 [inline]
> __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> bch2_check_alloc_hole_freespace+0x5fc/0xd74 =
fs/bcachefs/alloc_background.c:1278
> bch2_check_alloc_info+0x1174/0x26f8 =
fs/bcachefs/alloc_background.c:1547
> bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
> bch2_run_online_recovery_passes+0xa4/0x174 =
fs/bcachefs/recovery_passes.c:212
> bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> kthread+0x288/0x310 kernel/kthread.c:389
> ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
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

#syz fix: bcachefs: bch2_trans_relock() is trylock for lockdep

