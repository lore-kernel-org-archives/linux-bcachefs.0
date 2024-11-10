Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22F522615;
	Sun, 10 Nov 2024 05:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731217677; cv=none; b=PH6v9DGOOegzA3X2lUmrmAmyyqeoa/N2jGPL4FGYm5nWNDCWwB+25EJ2t+s5ZTXbZlFSqw3k/enaN8nj6LwaxqhNWxLph7hHkujWeweSP54yxMtjIuCVkUQQ3NISUxRiN1AqVwItp028pSLEnsZ6DD7zxI9BOyHbDsZnTFCRTK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731217677; c=relaxed/simple;
	bh=l2GxpMAGbqrCljVN5nGCPr/OuM4bKMHZcr3qjuT6rjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FGVWpzo/H3Dg0Nc2CFKENpfGLMnjTFDI7OCyZlcY3oElsaB3lwv15aY/xtmxat47j/9DdsGKnBSpjqcPqXXM4O8lM0QACwhng+ZVcH1ZacU7gTdgetcb7e+ViU6+NL4Q3YN4mnSmtG0hXYyBkENbs0U/3kNAxkdsKhhuC8HM2zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+Djzkzp; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+Djzkzp"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c941623a5aso7961107a12.0;
        Sat, 09 Nov 2024 21:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731217674; x=1731822474; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CGqVpD6/HQG0EbyFkg5+ODBVI5P4owYfjsDw2k6Fkxg=;
        b=W+Djzkzp8LrRNxRmsuD3ZUY+t0GYdT3u9xpl3oyO/xtN3pKfyuFfkbYN9Ud8dT1NxV
         xXKo9qs+5MtdnZYu4dbIh6ktz1O7foOL1iomH0V4ExlqjaYaDOqcP6/YRDWHooz0h9ab
         /5OO5m2z/NxaLYL5nLUwrEnxTDd6ao7N7rh35HbgmND4dTS6MH55V7uAjA1t/RCXyRSz
         pg1aWa/G8pZc6m8Ee7QfOWlVaOZz5YzhHuDKD7/yq3mQhgdm0rAHcbJdmwa1ajzSXRXL
         spT8cnua/odoBh0C3fHi5a+3JphvadjxFO5ooEVtXVvHDgCFqu9851Jlewhz1cYQX+dO
         MvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731217674; x=1731822474;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CGqVpD6/HQG0EbyFkg5+ODBVI5P4owYfjsDw2k6Fkxg=;
        b=njDLM9Ueo3Sjip2xp/+gv3mSVu7FBaojEOpDaQvbIl1Yyo3VKlEhx/DLZDZrZs1lU8
         kiUdW9dMMPxMsQIi7aDpB9PPpk/FTO5fVq1yyq6BpIHFEnuBx/ROQ2mpkhP1OV6IuDvX
         oT0PMcxLT08tdufhsRyO+erJ0gW+l2aqWjXpn+H1NAOOHMeOOeDri4pU/ivtd8Bdb6pz
         fbVtHCgmm7oFRI/0nHR3cbshGTEmucfeuYUqotXjwcx1fDJC+LZvq1v4Lje6HIUsXvZj
         0D6+vko8KGORpXRZvbgaRxjO2Zb+3kS3b6twUysEiwo5JGDrecUXUzzGobvKuuki0xz+
         ZfbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVftiHRr4Byas+h9libXv9sXSLSZFpWInSows3L45FBLV/qzYjV279xhe3+CoO6o4BHA00OcbBkQBUJFjzV6Q==@vger.kernel.org, AJvYcCXEmyxQzwwAn8TB+ngjulLkzYa3i6fApO9NIctVEEQJZmKMOy/8/yL0dwTEIVUgAcPd7GZ52x6bNANwWcx8@vger.kernel.org
X-Gm-Message-State: AOJu0YznqB8+1r82pMoCkhwoN//Hk4FKmi2DPSetMr3QhUzN0CMLh+Fa
	L5/HnWbnqBwav/uLVcmweTA2qoOhnxCoSgHURw4AjC+4sX3n6OpxHy9/XLv/S86clkcjmN5TEAl
	RaRWSgg+TGBsH/HTNnazvFph0cSc=
X-Google-Smtp-Source: AGHT+IEqLOmXNLCHhyZH4mxBxj2PA76oNHfWOz0GVBdI81Bbn/kPGq/2fRkT83T2ce0Z50hVlz/IQH9f5qnL0TpFVNo=
X-Received: by 2002:a17:906:730d:b0:a99:6265:ed35 with SMTP id
 a640c23a62f3a-a9eefeb2ffemr762670366b.10.1731217673689; Sat, 09 Nov 2024
 21:47:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <672ecc13.050a0220.138bd5.0038.GAE@google.com>
In-Reply-To: <672ecc13.050a0220.138bd5.0038.GAE@google.com>
From: Suraj Sonawane <surajsonawane0215@gmail.com>
Date: Sun, 10 Nov 2024 11:17:16 +0530
Message-ID: <CAHiZj8gWz_yvnv_euDoeBYOx7uPvG=F2S6F24oSSo3urFw8dKw@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_copygc
To: syzbot <syzbot+8689d10f1894eedf774d@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: multipart/mixed; boundary="0000000000007834b206268886bc"

--0000000000007834b206268886bc
Content-Type: multipart/alternative; boundary="0000000000007834b006268886ba"

--0000000000007834b006268886ba
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

--0000000000007834b006268886ba
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

--0000000000007834b006268886ba--
--0000000000007834b206268886bc
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-v4KMSAN-fix-uninit-value-in-bch2_copygc.patch"
Content-Disposition: attachment; 
	filename="0001-v4KMSAN-fix-uninit-value-in-bch2_copygc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3b6a3590>
X-Attachment-Id: f_m3b6a3590

RnJvbSA3MzcwMjU3YWE5ZjFjYTIxY2MwMjE5ZTEwY2Q2ODg0Zjg0NzUzNTdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdXJhaiBTb25hd2FuZSA8c3VyYWpzb25hd2FuZTAyMTVAZ21h
aWwuY29tPgpEYXRlOiBTdW4sIDEwIE5vdiAyMDI0IDExOjE1OjE0ICswNTMwClN1YmplY3Q6IFtQ
QVRDSCB2NF0gS01TQU46IGZpeCB1bmluaXQtdmFsdWUgaW4gYmNoMl9jb3B5Z2MKCnN5eiB0ZXN0
CgpTaWduZWQtb2ZmLWJ5OiBTdXJhaiBTb25hd2FuZSA8c3VyYWpzb25hd2FuZTAyMTVAZ21haWwu
Y29tPgotLS0KIGluY2x1ZGUvbGludXgvcmhhc2h0YWJsZS5oIHwgOCArKysrKysrLQogMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbGludXgvcmhhc2h0YWJsZS5oIGIvaW5jbHVkZS9saW51eC9yaGFzaHRhYmxlLmgKaW5k
ZXggODQ2M2ExMjhlLi4wNDE0YTg1NmYgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcmhhc2h0
YWJsZS5oCisrKyBiL2luY2x1ZGUvbGludXgvcmhhc2h0YWJsZS5oCkBAIC0zNzMsNyArMzczLDEz
IEBAIHN0YXRpYyBpbmxpbmUgc3RydWN0IHJoYXNoX2hlYWQgKl9fcmh0X3B0cigKIHN0YXRpYyBp
bmxpbmUgc3RydWN0IHJoYXNoX2hlYWQgKnJodF9wdHJfcmN1KAogCXN0cnVjdCByaGFzaF9sb2Nr
X2hlYWQgX19yY3UgKmNvbnN0ICpia3QpCiB7Ci0JcmV0dXJuIF9fcmh0X3B0cihyY3VfZGVyZWZl
cmVuY2UoKmJrdCksIGJrdCk7CisJc3RydWN0IHJoYXNoX2xvY2tfaGVhZCAqcHRyID0gcmN1X2Rl
cmVmZXJlbmNlKCpia3QpOworCisJaWYgKCFwdHIpIHsKKwkJcHRyID0gMDsKKwl9CisKKwlyZXR1
cm4gX19yaHRfcHRyKHB0ciwgYmt0KTsKIH0KIAogc3RhdGljIGlubGluZSBzdHJ1Y3Qgcmhhc2hf
aGVhZCAqcmh0X3B0cigKLS0gCjIuMzQuMQoK
--0000000000007834b206268886bc--
