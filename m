Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244D14A4DD
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 22:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732917750; cv=none; b=hMl1o07sNrSxpnOJVSBTPDF1O4Pay9Swn83OvlOBZHxOPuRy5elTzs+IJKG8hYk5Dpv1yuo0aS4VB1cOkaN6ZKCp8k3A1bqzyQXt8WT5YVYK+O4BAQds3NiIN4UfpiWOQTHWgHxY5hPaLcRmHzwUarbR2HCR5amdGKQRkdl91k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732917750; c=relaxed/simple;
	bh=6JBekSvlmvRnpOx7yRy0hRBnwNrdgNlkbK81pIXdUxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XuTPHMY8tKhwtDrnM8R4jdngAeFysCl9SjmvQJd5M262TezAgorGUo/o6l2g9ywXt2SjD6X+d93zXw4PPJZN9bwW73Y44zkOCencSk0fFVLJJEw1KkBtIlHI7Zto751NH69iZcpRLcw9PwPKPAM9RTsFkCUPQbJ0W/vVeEarbA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=syJWKXP9; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="syJWKXP9"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7fbd76941ccso1678060a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 14:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732917748; x=1733522548; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8YbWM47sasrazQoqBcANA4ZQuWL479UweA5NnTKE7Q=;
        b=syJWKXP92S6XxXPyg0xCjTLE26UHT32/Y/8/+rJSbsA9i0kLEPe4TDkxsSgVtkYxYO
         neH36daX2Ec7ozuLTARwLTrlW8Rec/OOBX1dU3RcaIEzAdUNxu27ivSgIXRrvqOd0CpU
         IoMENYcmmMdtWFNm1yfJ9zfEXsSbzHojnmJ65uDwotb2MNDNBRjKbJ1m+9lZRJ4PNwnx
         AzBPZCtiQZPShVG4n+o2ZlEgPFnhU+/rx67+qMlOg9vYnOgSTkDK2PEO8mQN49rPoIm1
         Hx5CkK2VGScZ5SAOV5nAaNhlm5vCPX8z+nOXRAG1yFp2VX/EQA7Ut0cnaA+bF7EQ385M
         4Pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732917748; x=1733522548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8YbWM47sasrazQoqBcANA4ZQuWL479UweA5NnTKE7Q=;
        b=uSP60dVdMtqN2k4cgaGCNZ/oYxyVul9RCVbos1xje3htjPWtlgWh/VOLG/MW3pACoC
         jzbsBt2F7mhHFrKExjZlrU3jMpfSPw9y9wvVCk1ZS79vil5zRz/Q7Br1HVoybW3k3Pak
         7ffX+aFcR9gaMrgm7d3YG3dz3z5DYJDeTL3b7rf2hSjGkqkzYfznsWKHtmAP4lygtQGI
         9+/i3OzrnjySGiea/QwMOkijHskYP5M/WpjlRiTf7hTGQLlGXYwh/rG3S7nN7Ss1l4Er
         ydJL3vRNQ5Fgjr+EJwFTON+Ukg1WpsubsYvWIQKdH0UYHI2x4SD8B3HfKUln6d7ukqY/
         9+HA==
X-Forwarded-Encrypted: i=1; AJvYcCXYX6a/cSNkkNFdHqFS9txGJ0lJ52+T9da67wDQBEdyN9Ia0QWDU9L6IndfBWOwLbaUwn+Ka7gl2pEChQy/qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOKX4A/Cglj2tfUv2ALXXMNCDHIeqlA0eVNyf5V1VTg6fHS2H1
	k3K/TXr4kKmRvQHhE3Ue3UN2J9nO1PMxA2oTjq17zdNsgyrxapG2oJVeIgr9XVe+NeDv8JbcuGS
	e7KfzNcbzpKZ2MqMDg+4i1o2AJ3wBGnR2Q2sA
X-Gm-Gg: ASbGncuZPd6Tl6AAwYpHHAC7kxU5qTrjhID7FWMBpRahG/b70MHUBHtxzdT6aWoRGEh
	15fwV2t9VGq4Fq61Mc1GODxiMvrUkUhSBlz/I0XrfCA37XtiFUnK3nFSIQxYiX3P0
X-Google-Smtp-Source: AGHT+IEszUgV6uDxXNtQeBdG3Gf0WsYcjXafTfFs7o6pIEMD+ET48NgARGcVATt0Oliiv6hgqm04ZkfD4K92pB1NJMA=
X-Received: by 2002:a17:90b:5550:b0:2ee:74a1:fb92 with SMTP id
 98e67ed59e1d1-2ee74b13e8fmr2230988a91.6.1732917748095; Fri, 29 Nov 2024
 14:02:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6749f54c.050a0220.253251.00bc.GAE@google.com> <vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz@5hibgcwmd3go>
In-Reply-To: <vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz@5hibgcwmd3go>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 29 Nov 2024 23:02:16 +0100
Message-ID: <CANp29Y65AipY2cNPV3opLjUdPxJ8tWGesBm6mkkN4HZ2K+gcxQ@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in trans_set_locked
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kent,

For reopened bugs, syzbot appends (2), (3), etc. at the end of the
title. In this case, there are no numbers, so it has never reported
anything with such a title before.

But it can well be the case that the underlying problem here is the
same as in some other syzbot report (you could then "#syz dup" the new
to the older one). If you happen to see patterns in such duplicate
reports, please let us know and we'll try to improve the crash report
parsing logic.

--=20
Aleksandr

On Fri, Nov 29, 2024 at 9:25=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Nov 29, 2024 at 09:09:32AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/sm=
mu'..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/lin=
ux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D17d6af78580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9bc44a6de1c=
eb5d6
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D78f4eb354f5ca=
6c1e6eb
> > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for D=
ebian) 2.40
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D107bdf5f9=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13ae49e8580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/4d4a0162c7c3/d=
isk-7b1d1d4c.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/a8c47a4be472/vmli=
nux-7b1d1d4c.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/0e173b91f83e=
/Image-7b1d1d4c.gz.xz
> > mounted in repro #1: https://storage.googleapis.com/syzbot-assets/5ab7b=
24d2900/mount_0.gz
> > mounted in repro #2: https://storage.googleapis.com/syzbot-assets/fbfbb=
60588c1/mount_2.gz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: possible circular locking dependency detected
> > 6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
> > ------------------------------------------------------
> > syz-executor203/6432 is trying to acquire lock:
> > ffff0000da100128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x5=
c/0x21c fs/bcachefs/btree_locking.h:193
> >
> > but task is already holding lock:
> > ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsc=
k_err+0x344/0x2544 fs/bcachefs/error.c:282
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
> >        __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
> >        __mutex_lock kernel/locking/mutex.c:752 [inline]
> >        mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
> >        __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_ba=
ckground.c:1278
> >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background=
.c:1547
> >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:=
191
> >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_=
passes.c:212
> >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:2=
98
> >        kthread+0x288/0x310 kernel/kthread.c:389
> >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> >
> > -> #0 (bcachefs_btree){+.+.}-{0:0}:
> >        check_prev_add kernel/locking/lockdep.c:3161 [inline]
> >        check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> >        validate_chain kernel/locking/lockdep.c:3904 [inline]
> >        __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> >        lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> >        trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> >        __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> >        bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> >        __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_ba=
ckground.c:1278
> >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background=
.c:1547
> >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:=
191
> >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_=
passes.c:212
> >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:2=
98
> >        kthread+0x288/0x310 kernel/kthread.c:389
> >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> >
> > other info that might help us debug this:
> >
> >  Possible unsafe locking scenario:
> >
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock(&c->fsck_error_msgs_lock);
> >                                lock(bcachefs_btree);
> >                                lock(&c->fsck_error_msgs_lock);
> >   lock(bcachefs_btree);
> >
> >  *** DEADLOCK ***
> >
> > 3 locks held by syz-executor203/6432:
> >  #0: ffff0000dc600278 (&c->state_lock){++++}-{3:3}, at: bch2_run_online=
_recovery_passes+0x3c/0x174 fs/bcachefs/recovery_passes.c:204
> >  #1: ffff0000dc604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_l=
ock_acquire+0x18/0x54 include/linux/srcu.h:150
> >  #2: ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch=
2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> >
> > stack backtrace:
> > CPU: 1 UID: 0 PID: 6432 Comm: syz-executor203 Not tainted 6.12.0-syzkal=
ler-g7b1d1d4cfac0 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 09/13/2024
> > Call trace:
> >  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
> >  __dump_stack lib/dump_stack.c:94 [inline]
> >  dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
> >  dump_stack+0x1c/0x28 lib/dump_stack.c:129
> >  print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
> >  check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
> >  check_prev_add kernel/locking/lockdep.c:3161 [inline]
> >  check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> >  validate_chain kernel/locking/lockdep.c:3904 [inline]
> >  __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> >  lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> >  trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> >  __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> >  bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> >  __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> >  bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_backgrou=
nd.c:1278
> >  bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:154=
7
> >  bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
> >  bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes=
.c:212
> >  bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> >  thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> >  kthread+0x288/0x310 kernel/kthread.c:389
> >  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing=
.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>
> syzbot seems to now be re-opening bugs just because the patch hasn't
> been merged into the branch it's testing?
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz%405hibgcwmd3go.
