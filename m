Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD51F8AE8
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Dec 2024 14:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733148119; cv=none; b=nj4NYhoUpEwGanTb8C8QEyamZtcZrjfqd5x6rNfAd2pGBQeynxe5rYUgzjF0xYZ/ShjxR8I9+KtNj1x0uYqniE6EHGYrKdhMLczt8rRaEqQYIdCNV+E4SAoDA7CCvy9conxDiY/BNNV/Nj9/D/ysGGSv/GOhNgi/r03Fay9FaiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733148119; c=relaxed/simple;
	bh=13mSg9tOGrPIB2+LxxC03JHB2cnD6fwmVHPeURULjrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b5tnrXdbhnKzoUvMOf67zbceCIpFiNpDsqGUxggPuJL0fsIa9NKFKzlPftUWIyJ3Z07BrNQx3CtPxuWqNBpoXOTTtcL8QDZSIsCHSkaBwaLLjAIqpBAs0tXmL6UR7vlR1O4BdvsE2fRjCMIZU1mndThrazzvPyEQJ+4aXcCbTLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=um1UhMsK; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="um1UhMsK"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7ee11ff7210so3022547a12.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Dec 2024 06:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733148116; x=1733752916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw66bujCKtT9mP3fH0eE4DZbrDe++mnHZ5hUnmQ/IMI=;
        b=um1UhMsKf92boUrOKJB3yknlseEaeqqRZXKtWI6bdpjHswz/z/a6hurY7JYLmOfpgt
         R3bVoXYrZFhJ2QYN41NyKQiSdBo5qQJy2A8WCXRHKJir/+eZDAFi03gtsBaWt8eGtwLy
         fJSbb/wpb0s9wl90RKhOSW5P3A8bHvdLjPJccpgPcNQ1t0GRplLyAj0n3AHKONhn/d/D
         exGuEpf8nyXV0HyHAq0fR5ehCTj20TLYIG4GpSCJGH8bKcXcZazifDiQtBvd+tsFU33Y
         dcTeHuDgIagBmP4Ky1Kq0djwHuv6OU6O0dXZ2ng7yeiA2M12WHIu40AeeLivg8hQQ6A9
         wpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733148116; x=1733752916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dw66bujCKtT9mP3fH0eE4DZbrDe++mnHZ5hUnmQ/IMI=;
        b=q8nMVIWBrBC+0wy50omOPWT4+VGfscEx01RWF0qPJhcoNOav0dBvV7ysYZUW0UxKvU
         B8T4STq91C69VQWEGSBhoQ6nBYF43bbId1NaZjtZz529K4/PGKKvusS0jbQBzns/MsOm
         tLCNYYbfa9htBAMmaZ120dh9KTFXFdT7YHv/MhehtJi2lNoY/fBsGjnITczoyUJbcNmE
         moB49vKdICVpk81FC3AHyOZ0ea5fucZSKZhJTu4/FsqvZqumCjHtVIoj3iBcz9JlFj8B
         /JU7tP+HcM0Mqm8GpAPAboHZlomANxbjqEP4Y8Nfl4zJV5RnkjxHTxr5iUA94oUKPtqH
         uwCg==
X-Forwarded-Encrypted: i=1; AJvYcCXzBXlKlws+F5mwu4qL2IAfajUNlSWjQqDX/5W8KXqc+wx26rXjbAVjV+CiZYCU+Noh6GlgkJZnf3eCDsr3DA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhTsg1G3PbQMt0hO07tGizIagccEJzzc1W2JiVqvQ+grSsiAL2
	EEtgeqsRHvidkpnSuMWZdtw/z1LlKpfsAIjfHv+S6FMiPA9ZwqSAGywGOdTQzVjRwK1FC2/qSsQ
	ot1dFelai9/rjoRu+Vcc/G5qpwK6DuHa+XFjW
X-Gm-Gg: ASbGncuuMaNISZZootiOv9Tt3VeqpEvGJ08oxt3Ig4F8DnZLsv6AMCad0I6G9JADb+5
	/sUGvY/NRNkWkYM0gVx4XDxarA8YnZdAGjI508X1WeaOa/+u29V7Jg5AFHQOJNQ==
X-Google-Smtp-Source: AGHT+IEyQ2IiXM5aKSsRFSR8emoZ8XEH5BjdTyRqhWbZzj83GfPllLjqCgWgjQKss5LD+8MERsnDVFi6RHZiA1QCfbA=
X-Received: by 2002:a05:6a20:4393:b0:1e0:de01:4407 with SMTP id
 adf61e73a8af0-1e0e0b7d90emr37551625637.37.1733148114419; Mon, 02 Dec 2024
 06:01:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6749f54c.050a0220.253251.00bc.GAE@google.com> <vkwc4py3f5crc5byn4h24u3bcbsyke2hzeuzd752ncra7iptdz@5hibgcwmd3go>
 <CANp29Y65AipY2cNPV3opLjUdPxJ8tWGesBm6mkkN4HZ2K+gcxQ@mail.gmail.com> <rykdmzcn6v34ss36cpff6i7cssityfmvipu7evxoklhsagb4py@7lwtulreg5o5>
In-Reply-To: <rykdmzcn6v34ss36cpff6i7cssityfmvipu7evxoklhsagb4py@7lwtulreg5o5>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 2 Dec 2024 15:01:42 +0100
Message-ID: <CANp29Y4aEEHP79xwq0TXmtdXU-pYMRJ0ikOamxjSg0rv_EkZ-g@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in trans_set_locked
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2024 at 11:57=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Nov 29, 2024 at 11:02:16PM +0100, Aleksandr Nogikh wrote:
> > Hi Kent,
> >
> > For reopened bugs, syzbot appends (2), (3), etc. at the end of the
> > title. In this case, there are no numbers, so it has never reported
> > anything with such a title before.
> >
> > But it can well be the case that the underlying problem here is the
> > same as in some other syzbot report (you could then "#syz dup" the new
> > to the older one). If you happen to see patterns in such duplicate
> > reports, please let us know and we'll try to improve the crash report
> > parsing logic.
>
> It looks identical to this one which I closed last night
>
> https://syzkaller.appspot.com/bug?extid=3De088be3c2d5c05aaac35
>
> Is that a parsing issue? The lockdep splats don't just look similar to
> me, they look identical.

Yes, that's exactly a report parsing issue. In this case it's even one
that's a bit more involved than usually, so I've filed an issue to
discuss it in more detail:
https://github.com/google/syzkaller/issues/5558

>
> I've got another one that I closed last night that it seems might be
> confusing for syzbot:
> https://syzkaller.appspot.com/bug?extid=3D64e6509c7f777aec3a24
>
> I fixed the patch that introduced the bug (it was only in -next), but I
> don't seem to have a way to tell syzbot not to reopen it unless it sees
> the updated patch.

That's actually the default behavior of syzbot: if you set the fix
commit title via `#syz fix` or via a `Reported-by` tag, syzbot will
first wait until the fix commit has reached all the trees that are
fuzzed and will reopen the issue with a " (2)" suffix only if the
failure occurred on some patched tree.

However, syzbot parsed these two bug reports differently. It identified the=
m as:
* possible deadlock in __bch2_trans_relock
* possible deadlock in trans_set_locked

So, from its viewpoint, these are totally "different".

If you know the exact duplicate issue, please send a #syz dup
command(s) to remove them from the web dashboard (and Cc
syzkaller@googlegroups.com so that we know that there was a parsing
problem).

--=20
Aleksandr

>
> Probably not a real issue with this particular bug - this exact situation
> is pretty rare, but I do have bugs accumulating in my dashboard that
> seem to have been fixed but I don't have a good way to close since I
> don't know the patch that fixed them (not going to bisect 20+ fixes...)

>
> >
> > --
> > Aleksandr
> >
> > On Fri, Nov 29, 2024 at 9:25=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, Nov 29, 2024 at 09:09:32AM -0800, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/ar=
m/smmu'..
> > > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64=
/linux.git for-kernelci
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D17d6af7=
8580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9bc44a6=
de1ceb5d6
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D78f4eb354=
f5ca6c1e6eb
> > > > compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils f=
or Debian) 2.40
> > > > userspace arch: arm64
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D107bd=
f5f980000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D13ae49e=
8580000
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/4d4a0162c7=
c3/disk-7b1d1d4c.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/a8c47a4be472/=
vmlinux-7b1d1d4c.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/0e173b91=
f83e/Image-7b1d1d4c.gz.xz
> > > > mounted in repro #1: https://storage.googleapis.com/syzbot-assets/5=
ab7b24d2900/mount_0.gz
> > > > mounted in repro #2: https://storage.googleapis.com/syzbot-assets/f=
bfbb60588c1/mount_2.gz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to th=
e commit:
> > > > Reported-by: syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > > > WARNING: possible circular locking dependency detected
> > > > 6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
> > > > ------------------------------------------------------
> > > > syz-executor203/6432 is trying to acquire lock:
> > > > ffff0000da100128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked=
+0x5c/0x21c fs/bcachefs/btree_locking.h:193
> > > >
> > > > but task is already holding lock:
> > > > ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2=
_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > > >
> > > > which lock already depends on the new lock.
> > > >
> > > >
> > > > the existing dependency chain (in reverse order) is:
> > > >
> > > > -> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
> > > >        __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
> > > >        __mutex_lock kernel/locking/mutex.c:752 [inline]
> > > >        mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
> > > >        __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > > >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/allo=
c_background.c:1278
> > > >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_backgr=
ound.c:1547
> > > >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passe=
s.c:191
> > > >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recov=
ery_passes.c:212
> > > >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c=
:799
> > > >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file=
.c:298
> > > >        kthread+0x288/0x310 kernel/kthread.c:389
> > > >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > > >
> > > > -> #0 (bcachefs_btree){+.+.}-{0:0}:
> > > >        check_prev_add kernel/locking/lockdep.c:3161 [inline]
> > > >        check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> > > >        validate_chain kernel/locking/lockdep.c:3904 [inline]
> > > >        __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> > > >        lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> > > >        trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> > > >        __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:=
785
> > > >        bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> > > >        __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> > > >        bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/allo=
c_background.c:1278
> > > >        bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_backgr=
ound.c:1547
> > > >        bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passe=
s.c:191
> > > >        bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recov=
ery_passes.c:212
> > > >        bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c=
:799
> > > >        thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file=
.c:298
> > > >        kthread+0x288/0x310 kernel/kthread.c:389
> > > >        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > > >
> > > > other info that might help us debug this:
> > > >
> > > >  Possible unsafe locking scenario:
> > > >
> > > >        CPU0                    CPU1
> > > >        ----                    ----
> > > >   lock(&c->fsck_error_msgs_lock);
> > > >                                lock(bcachefs_btree);
> > > >                                lock(&c->fsck_error_msgs_lock);
> > > >   lock(bcachefs_btree);
> > > >
> > > >  *** DEADLOCK ***
> > > >
> > > > 3 locks held by syz-executor203/6432:
> > > >  #0: ffff0000dc600278 (&c->state_lock){++++}-{3:3}, at: bch2_run_on=
line_recovery_passes+0x3c/0x174 fs/bcachefs/recovery_passes.c:204
> > > >  #1: ffff0000dc604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: sr=
cu_lock_acquire+0x18/0x54 include/linux/srcu.h:150
> > > >  #2: ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: _=
_bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
> > > >
> > > > stack backtrace:
> > > > CPU: 1 UID: 0 PID: 6432 Comm: syz-executor203 Not tainted 6.12.0-sy=
zkaller-g7b1d1d4cfac0 #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 09/13/2024
> > > > Call trace:
> > > >  show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
> > > >  __dump_stack lib/dump_stack.c:94 [inline]
> > > >  dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
> > > >  dump_stack+0x1c/0x28 lib/dump_stack.c:129
> > > >  print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
> > > >  check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
> > > >  check_prev_add kernel/locking/lockdep.c:3161 [inline]
> > > >  check_prevs_add kernel/locking/lockdep.c:3280 [inline]
> > > >  validate_chain kernel/locking/lockdep.c:3904 [inline]
> > > >  __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
> > > >  lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
> > > >  trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
> > > >  __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
> > > >  bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
> > > >  __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
> > > >  bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_back=
ground.c:1278
> > > >  bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c=
:1547
> > > >  bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:19=
1
> > > >  bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_pa=
sses.c:212
> > > >  bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
> > > >  thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
> > > >  kthread+0x288/0x310 kernel/kthread.c:389
> > > >  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
> > > >
> > > >
> > > > ---
> > > > This report is generated by a bot. It may contain errors.
> > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > >
> > > > syzbot will keep track of this issue. See:
> > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > >
> > > > If the report is already addressed, let syzbot know by replying wit=
h:
> > > > #syz fix: exact-commit-title
> > > >
> > > > If you want syzbot to run the reproducer, reply with:
> > > > #syz test: git://repo/address.git branch-or-commit-hash
> > > > If you attach or paste a git patch, syzbot will apply it before tes=
ting.
> > > >
> > > > If you want to overwrite report's subsystems, reply with:
> > > > #syz set subsystems: new-subsystem
> > > > (See the list of subsystem names on the web dashboard)
> > > >
> > > > If the report is a duplicate of another one, reply with:
> > > > #syz dup: exact-subject-of-another-report
> > > >
> > > > If you want to undo deduplication, reply with:
> > > > #syz undup
> > >
> > > syzbot seems to now be re-opening bugs just because the patch hasn't
> > > been merged into the branch it's testing?
> > >
