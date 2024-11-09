Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85C145A1C;
	Sat,  9 Nov 2024 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731162706; cv=none; b=WSGdAHxgQ74fbMe11JJ8S0tjZMv/ZkQWzFYG6D/8HyBJM+l4/tInRlEwNPDvt8Of+fVyhUvz7v7awsIQ0SHjWnBVDMA8/rDnN59TrpM+aFguZHNGsdHlH0eGYlbzPNU3bnKiLlwW5k0CS+vwUwRtwibllNvLGPuYdQKl/kMxpTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731162706; c=relaxed/simple;
	bh=EMCXZ8i+2EfDuxQtvErCOOJnNyWM0ieOoO9Utf5s8YY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HJI9/1CZb/T1BcSKeo9rF5PTo9ZyXB2LF6ca5u9aiGCUTHrqQMF/GAU1BMUO1wyjLEemFPvkaaAKFJtnmOBtoH2QfxJT4F048A4ZXyb/Qt1kn5b9OuYJjT71URrrDddgQNhxP2dqF7jN+z/sfjjbyBswbhkyox2al2mAJ/+y6BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MY5OfJmJ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MY5OfJmJ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9ed49ec0f1so535859866b.1;
        Sat, 09 Nov 2024 06:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731162703; x=1731767503; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VHJRqhjtU56C6YPkpK8Pezq1Mg8Cx4M2Uf/MJfP/48U=;
        b=MY5OfJmJ7s8s1muivRW5MfJgsD91f6BA0yZZ+dsGEOgJsyT55MUv8B8FOjojOnzurs
         Mwu8EHFqua58J6XKkeV3HRiuTIcDdjy4dIUisIN6tCvcoPunyENqTHKzQNKCOKO80bfV
         nx0vHAF3+3e0oXqWx54SxwU7xDRm/chdnjYfKh9wDSzbAAwHMKjjPV9URhSMcTum9Vap
         fSXCe1qXSQXIPl4L34YANRhDQw0TUX60yMGkszog9ZCn95bBnD5DgbE/l5tFB9AZtESn
         XPjV4GPxPSJXCsriWrL13gTGa4mFaTTalzZ9Zf/O89k/DGuClKMVMvT2s/sM2t4hdYCs
         2aGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731162703; x=1731767503;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHJRqhjtU56C6YPkpK8Pezq1Mg8Cx4M2Uf/MJfP/48U=;
        b=VKFNHHzmTIh0G5yky8JdvFdADB/FG7Cso6aMIZ8ayFX6wwUOrTLhl6u53Ly39bKOB5
         Uy/hQhhODInNYvhHPGCdZ0wlVdAGH0onPLXNwiS5VzFaI6xI7RTc/YsWx223eJYpr68h
         fNJl52NXtCgzZRfT2AgEDVnWsxpgMK5WuSgJUrAf3nD7+2AUYQ0lm3Wk/0MDTqU+POfm
         wePFnXl5yQT9s3/cWaWIsAJ1IJ6bWpypUNEtgubTZ9WrbllEiEXtL4hfReKF5wky2Aaa
         dHqAFQoRSzMROQ2meglJNq4JcFbyYlSBZ1kSpJo3p3D9p7KpnJftVr8Jo5iKvy8A2S72
         WugQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0NfW74CnKVX2+BIYP9u0+dVlEo0f9SBo7Ri56aI1Zio6evQfT9rrlxjP8BgznLujxmab/PyFlznLR0jUs@vger.kernel.org, AJvYcCXcP70G4EU2GHBvVeBZQys8C+yUGVqgN2AYlaYrD+4AfA4zRHCkoLamSISHIFjoEBNlBkVN9BEoNcoe9dVYzA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOBjKntAtWTqLlM6adqoSKA4Nx+bGi+qAGV5puYF/9GMlgR5uP
	F9/GLn+GvWbfFVEAAZgd28mz8UmBGpFLxXxwcrjPsuveYij30NriMQq9gSfp1o0s8q81+Ltorpa
	MBVnyn1gchCyez9pr1XIWGcnAbn8=
X-Google-Smtp-Source: AGHT+IHGAaeDKry6Lt3qCb+EXyMlkmwLODHTQowCGLkJezxTjjnyrHzIlUldtuVzaj7L99COQJ/dOffetAe2ivyJxMI=
X-Received: by 2002:a17:907:3f97:b0:a9d:e1d1:bf95 with SMTP id
 a640c23a62f3a-a9eeff3f3b0mr638974566b.25.1731162702034; Sat, 09 Nov 2024
 06:31:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <672ecc13.050a0220.138bd5.0038.GAE@google.com>
In-Reply-To: <672ecc13.050a0220.138bd5.0038.GAE@google.com>
From: Suraj Sonawane <surajsonawane0215@gmail.com>
Date: Sat, 9 Nov 2024 20:01:05 +0530
Message-ID: <CAHiZj8hLZ3es4arB89eVfspki+Un9PXBedjo_vMix81F7OdMiw@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_copygc
To: syzbot <syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="000000000000e7867206267bb909"

--000000000000e7867206267bb909
Content-Type: multipart/alternative; boundary="000000000000e7867106267bb907"

--000000000000e7867106267bb907
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz test

On Sat, Nov 9, 2024 at 8:12=E2=80=AFAM syzbot <
syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com> wrote:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of
> git://git.ker..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D11361d5f98000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6fdf74cce3772=
23b
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=3D8689d10f1894eedf774d
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for
> Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12348f40580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11e7b58798000=
0
>
> Downloadable assets:
> disk image:
> https://storage.googleapis.com/syzbot-assets/08456e37db58/disk-2e1b3cc9.r=
aw.xz
> vmlinux:
> https://storage.googleapis.com/syzbot-assets/cc957f7ba80b/vmlinux-2e1b3cc=
9.xz
> kernel image:
> https://storage.googleapis.com/syzbot-assets/7579fe72ed89/bzImage-2e1b3cc=
9.xz
> mounted in repro:
> https://storage.googleapis.com/syzbot-assets/5903d7d7fe58/mount_4.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit:
> Reported-by: syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in rht_ptr_rcu include/linux/rhashtable.h:376
> [inline]
> BUG: KMSAN: uninit-value in __rhashtable_lookup
> include/linux/rhashtable.h:607 [inline]
> BUG: KMSAN: uninit-value in rhashtable_lookup
> include/linux/rhashtable.h:646 [inline]
> BUG: KMSAN: uninit-value in rhashtable_lookup_fast
> include/linux/rhashtable.h:672 [inline]
> BUG: KMSAN: uninit-value in bucket_in_flight fs/bcachefs/movinggc.c:144
> [inline]
> BUG: KMSAN: uninit-value in bch2_copygc_get_buckets
> fs/bcachefs/movinggc.c:170 [inline]
> BUG: KMSAN: uninit-value in bch2_copygc+0x1d3f/0x58f0
> fs/bcachefs/movinggc.c:221
>  rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
>  __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
>  rhashtable_lookup include/linux/rhashtable.h:646 [inline]
>  rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
>  bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]
>  bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
>  bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221
>  bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381
>  kthread+0x3e2/0x540 kernel/kthread.c:389
>  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>
> Local variable b205.i created at:
>  bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
>  bch2_copygc+0x15b3/0x58f0 fs/bcachefs/movinggc.c:221
>  bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381
>
> CPU: 0 UID: 0 PID: 5796 Comm: bch-copygc/loop Not tainted
> 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 09/13/2024
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Kernel panic - not syncing: kmsan.panic set ...
> CPU: 0 UID: 0 PID: 5796 Comm: bch-copygc/loop Tainted: G    B
> 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
> Tainted: [B]=3DBAD_PAGE
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 09/13/2024
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x216/0x2d0 lib/dump_stack.c:120
>  dump_stack+0x1e/0x30 lib/dump_stack.c:129
>  panic+0x4e2/0xcf0 kernel/panic.c:354
>  kmsan_report+0x2c7/0x2d0 mm/kmsan/report.c:218
>  __msan_warning+0x95/0x120 mm/kmsan/instrumentation.c:318
>  rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
>  __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
>  rhashtable_lookup include/linux/rhashtable.h:646 [inline]
>  rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
>  bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]
>  bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]
>  bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221
>  bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381
>  kthread+0x3e2/0x540 kernel/kthread.c:389
>  ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit
> https://groups.google.com/d/msgid/syzkaller-bugs/672ecc13.050a0220.138bd5=
.0038.GAE%40google.com
> .
>

--000000000000e7867106267bb907
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">#syz test<br></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Sat, Nov 9, 2024 at 8:12=E2=80=AFAM syzbot=
 &lt;<a href=3D"mailto:syzbot%2B8689d10f1894eedf774d@syzkaller.appspotmail.=
com">syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com</a>&gt; wrote:<b=
r></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex=
;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello,<br>
<br>
syzbot found the following issue on:<br>
<br>
HEAD commit:=C2=A0 =C2=A0 2e1b3cc9d7f7 Merge tag &#39;arm-fixes-6.12-2&#39;=
 of git://git.ker..<br>
git tree:=C2=A0 =C2=A0 =C2=A0 =C2=A0upstream<br>
console+strace: <a href=3D"https://syzkaller.appspot.com/x/log.txt?x=3D1136=
1d5f980000" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.appspot.=
com/x/log.txt?x=3D11361d5f980000</a><br>
kernel config:=C2=A0 <a href=3D"https://syzkaller.appspot.com/x/.config?x=
=3D6fdf74cce377223b" rel=3D"noreferrer" target=3D"_blank">https://syzkaller=
.appspot.com/x/.config?x=3D6fdf74cce377223b</a><br>
dashboard link: <a href=3D"https://syzkaller.appspot.com/bug?extid=3D8689d1=
0f1894eedf774d" rel=3D"noreferrer" target=3D"_blank">https://syzkaller.apps=
pot.com/bug?extid=3D8689d10f1894eedf774d</a><br>
compiler:=C2=A0 =C2=A0 =C2=A0 =C2=A0Debian clang version 15.0.6, GNU ld (GN=
U Binutils for Debian) 2.40<br>
syz repro:=C2=A0 =C2=A0 =C2=A0 <a href=3D"https://syzkaller.appspot.com/x/r=
epro.syz?x=3D12348f40580000" rel=3D"noreferrer" target=3D"_blank">https://s=
yzkaller.appspot.com/x/repro.syz?x=3D12348f40580000</a><br>
C reproducer:=C2=A0 =C2=A0<a href=3D"https://syzkaller.appspot.com/x/repro.=
c?x=3D11e7b587980000" rel=3D"noreferrer" target=3D"_blank">https://syzkalle=
r.appspot.com/x/repro.c?x=3D11e7b587980000</a><br>
<br>
Downloadable assets:<br>
disk image: <a href=3D"https://storage.googleapis.com/syzbot-assets/08456e3=
7db58/disk-2e1b3cc9.raw.xz" rel=3D"noreferrer" target=3D"_blank">https://st=
orage.googleapis.com/syzbot-assets/08456e37db58/disk-2e1b3cc9.raw.xz</a><br=
>
vmlinux: <a href=3D"https://storage.googleapis.com/syzbot-assets/cc957f7ba8=
0b/vmlinux-2e1b3cc9.xz" rel=3D"noreferrer" target=3D"_blank">https://storag=
e.googleapis.com/syzbot-assets/cc957f7ba80b/vmlinux-2e1b3cc9.xz</a><br>
kernel image: <a href=3D"https://storage.googleapis.com/syzbot-assets/7579f=
e72ed89/bzImage-2e1b3cc9.xz" rel=3D"noreferrer" target=3D"_blank">https://s=
torage.googleapis.com/syzbot-assets/7579fe72ed89/bzImage-2e1b3cc9.xz</a><br=
>
mounted in repro: <a href=3D"https://storage.googleapis.com/syzbot-assets/5=
903d7d7fe58/mount_4.gz" rel=3D"noreferrer" target=3D"_blank">https://storag=
e.googleapis.com/syzbot-assets/5903d7d7fe58/mount_4.gz</a><br>
<br>
IMPORTANT: if you fix the issue, please add the following tag to the commit=
:<br>
Reported-by: <a href=3D"mailto:syzbot%2B8689d10f1894eedf774d@syzkaller.apps=
potmail.com" target=3D"_blank">syzbot+8689d10f1894eedf774d@syzkaller.appspo=
tmail.com</a><br>
<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D<br>
BUG: KMSAN: uninit-value in rht_ptr_rcu include/linux/rhashtable.h:376 [inl=
ine]<br>
BUG: KMSAN: uninit-value in __rhashtable_lookup include/linux/rhashtable.h:=
607 [inline]<br>
BUG: KMSAN: uninit-value in rhashtable_lookup include/linux/rhashtable.h:64=
6 [inline]<br>
BUG: KMSAN: uninit-value in rhashtable_lookup_fast include/linux/rhashtable=
.h:672 [inline]<br>
BUG: KMSAN: uninit-value in bucket_in_flight fs/bcachefs/movinggc.c:144 [in=
line]<br>
BUG: KMSAN: uninit-value in bch2_copygc_get_buckets fs/bcachefs/movinggc.c:=
170 [inline]<br>
BUG: KMSAN: uninit-value in bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.=
c:221<br>
=C2=A0rht_ptr_rcu include/linux/rhashtable.h:376 [inline]<br>
=C2=A0__rhashtable_lookup include/linux/rhashtable.h:607 [inline]<br>
=C2=A0rhashtable_lookup include/linux/rhashtable.h:646 [inline]<br>
=C2=A0rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]<br>
=C2=A0bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]<br>
=C2=A0bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]<br>
=C2=A0bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221<br>
=C2=A0bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381<br>
=C2=A0kthread+0x3e2/0x540 kernel/kthread.c:389<br>
=C2=A0ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244<br>
<br>
Local variable b205.i created at:<br>
=C2=A0bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]<br>
=C2=A0bch2_copygc+0x15b3/0x58f0 fs/bcachefs/movinggc.c:221<br>
=C2=A0bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381<br>
<br>
CPU: 0 UID: 0 PID: 5796 Comm: bch-copygc/loop Not tainted 6.12.0-rc6-syzkal=
ler-00077-g2e1b3cc9d7f7 #0<br>
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 09/13/2024<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D<br>
Kernel panic - not syncing: kmsan.panic set ...<br>
CPU: 0 UID: 0 PID: 5796 Comm: bch-copygc/loop Tainted: G=C2=A0 =C2=A0 B=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6.12.0-rc6-syzkaller-00077-g2=
e1b3cc9d7f7 #0<br>
Tainted: [B]=3DBAD_PAGE<br>
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 09/13/2024<br>
Call Trace:<br>
=C2=A0&lt;TASK&gt;<br>
=C2=A0__dump_stack lib/dump_stack.c:94 [inline]<br>
=C2=A0dump_stack_lvl+0x216/0x2d0 lib/dump_stack.c:120<br>
=C2=A0dump_stack+0x1e/0x30 lib/dump_stack.c:129<br>
=C2=A0panic+0x4e2/0xcf0 kernel/panic.c:354<br>
=C2=A0kmsan_report+0x2c7/0x2d0 mm/kmsan/report.c:218<br>
=C2=A0__msan_warning+0x95/0x120 mm/kmsan/instrumentation.c:318<br>
=C2=A0rht_ptr_rcu include/linux/rhashtable.h:376 [inline]<br>
=C2=A0__rhashtable_lookup include/linux/rhashtable.h:607 [inline]<br>
=C2=A0rhashtable_lookup include/linux/rhashtable.h:646 [inline]<br>
=C2=A0rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]<br>
=C2=A0bucket_in_flight fs/bcachefs/movinggc.c:144 [inline]<br>
=C2=A0bch2_copygc_get_buckets fs/bcachefs/movinggc.c:170 [inline]<br>
=C2=A0bch2_copygc+0x1d3f/0x58f0 fs/bcachefs/movinggc.c:221<br>
=C2=A0bch2_copygc_thread+0x7f7/0xfa0 fs/bcachefs/movinggc.c:381<br>
=C2=A0kthread+0x3e2/0x540 kernel/kthread.c:389<br>
=C2=A0ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147<br>
=C2=A0ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244<br>
=C2=A0&lt;/TASK&gt;<br>
Kernel Offset: disabled<br>
Rebooting in 86400 seconds..<br>
<br>
<br>
---<br>
This report is generated by a bot. It may contain errors.<br>
See <a href=3D"https://goo.gl/tpsmEJ" rel=3D"noreferrer" target=3D"_blank">=
https://goo.gl/tpsmEJ</a> for more information about syzbot.<br>
syzbot engineers can be reached at <a href=3D"mailto:syzkaller@googlegroups=
.com" target=3D"_blank">syzkaller@googlegroups.com</a>.<br>
<br>
syzbot will keep track of this issue. See:<br>
<a href=3D"https://goo.gl/tpsmEJ#status" rel=3D"noreferrer" target=3D"_blan=
k">https://goo.gl/tpsmEJ#status</a> for how to communicate with syzbot.<br>
<br>
If the report is already addressed, let syzbot know by replying with:<br>
#syz fix: exact-commit-title<br>
<br>
If you want syzbot to run the reproducer, reply with:<br>
#syz test: git://repo/address.git branch-or-commit-hash<br>
If you attach or paste a git patch, syzbot will apply it before testing.<br=
>
<br>
If you want to overwrite report&#39;s subsystems, reply with:<br>
#syz set subsystems: new-subsystem<br>
(See the list of subsystem names on the web dashboard)<br>
<br>
If the report is a duplicate of another one, reply with:<br>
#syz dup: exact-subject-of-another-report<br>
<br>
If you want to undo deduplication, reply with:<br>
#syz undup<br>
<br>
-- <br>
You received this message because you are subscribed to the Google Groups &=
quot;syzkaller-bugs&quot; group.<br>
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:syzkaller-bugs%2Bunsubscribe@googlegroups.com" ta=
rget=3D"_blank">syzkaller-bugs+unsubscribe@googlegroups.com</a>.<br>
To view this discussion visit <a href=3D"https://groups.google.com/d/msgid/=
syzkaller-bugs/672ecc13.050a0220.138bd5.0038.GAE%40google.com" rel=3D"noref=
errer" target=3D"_blank">https://groups.google.com/d/msgid/syzkaller-bugs/6=
72ecc13.050a0220.138bd5.0038.GAE%40google.com</a>.<br>
</blockquote></div>

--000000000000e7867106267bb907--
--000000000000e7867206267bb909
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-v3KMSAN-fix-uninit-value-in-bch2_copygc.patch"
Content-Disposition: attachment; 
	filename="0001-v3KMSAN-fix-uninit-value-in-bch2_copygc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3a9jrzc0>
X-Attachment-Id: f_m3a9jrzc0

RnJvbSA4YzhiZTdlODBkYmE4ZGRiZTY5ZTllZWE2YzE5ZTliZTg1YjMyYTA2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdXJhaiBTb25hd2FuZSA8c3VyYWpzb25hd2FuZTAyMTVAZ21h
aWwuY29tPgpEYXRlOiBTYXQsIDkgTm92IDIwMjQgMTk6NTg6MjggKzA1MzAKU3ViamVjdDogW1BB
VENIIHYyXSBLTVNBTjogZml4IHVuaW5pdC12YWx1ZSBpbiBiY2gyX2NvcHlnYwoKc3l6IHRlc3QK
ClNpZ25lZC1vZmYtYnk6IFN1cmFqIFNvbmF3YW5lIDxzdXJhanNvbmF3YW5lMDIxNUBnbWFpbC5j
b20+Ci0tLQogaW5jbHVkZS9saW51eC9yaGFzaHRhYmxlLmggfCA2ICsrKysrLQogMSBmaWxlIGNo
YW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvcmhhc2h0YWJsZS5oIGIvaW5jbHVkZS9saW51eC9yaGFzaHRhYmxlLmgKaW5kZXgg
OWNjMThkMzA0Li5jYjg1ZmZlN2IgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcmhhc2h0YWJs
ZS5oCisrKyBiL2luY2x1ZGUvbGludXgvcmhhc2h0YWJsZS5oCkBAIC0zNzMsNyArMzczLDExIEBA
IHN0YXRpYyBpbmxpbmUgc3RydWN0IHJoYXNoX2hlYWQgKl9fcmh0X3B0cigKIHN0YXRpYyBpbmxp
bmUgc3RydWN0IHJoYXNoX2hlYWQgKnJodF9wdHJfcmN1KAogCXN0cnVjdCByaGFzaF9sb2NrX2hl
YWQgX19yY3UgKmNvbnN0ICpia3QpCiB7Ci0JcmV0dXJuIF9fcmh0X3B0cihyY3VfZGVyZWZlcmVu
Y2UoKmJrdCksIGJrdCk7CisJc3RydWN0IHJoYXNoX2xvY2tfaGVhZCAqcHRyID0gcmN1X2RlcmVm
ZXJlbmNlKCpia3QpOworCWlmICghcHRyKSB7CisJCXJldHVybiBOVUxMOworCX0KKwlyZXR1cm4g
X19yaHRfcHRyKHB0ciwgYmt0KTsKIH0KIAogc3RhdGljIGlubGluZSBzdHJ1Y3Qgcmhhc2hfaGVh
ZCAqcmh0X3B0cigKLS0gCjIuMzQuMQoK
--000000000000e7867206267bb909--
