Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932D3570CB
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 16:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609082; cv=none; b=K6gzRoFVWwekBZ88vElufniflc0ZtSNmdnKDVVrmnrxKUL4qsRvmZWUHkOpHaOgKhuvOy1S+NzdaOOWXsMhsek0ENZZWs+rFpBgUfjYdNEqyoUqPcctLYERZgQaEN7Fp/r2sM2JSleI6oPq2z+IUfG7NSiWou474XmJ39Kk0DsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609082; c=relaxed/simple;
	bh=r7zIrmTcH7V0C2QWyQEZI8cLSyj2S0FQeUO8H0HYb/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uNmwLNh8qA4PWRfSXfV/z1KdQGEqYEo0tauGxKxW2+KrAv0ltgqVEAWYT7Yn1vQcMSrfTXOttnvhgzRxE/wgoyLeJLz+YyDL2dDch3Twxu9TNO6OkaZV6m/0+lJ7AG2d8ePKe7mDcSJNuxk/k2+rJ3upZLIjtoQNTVUcXD3ghns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VC5dQWDa; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VC5dQWDa"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b042eb09948so204902966b.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 09:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757609079; x=1758213879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7zIrmTcH7V0C2QWyQEZI8cLSyj2S0FQeUO8H0HYb/8=;
        b=VC5dQWDaIQhecohdCyIF91m6W76hZjyQUcLikkxKSMsyPZYxqpWt/sWoRXtpjM6XZg
         HHMXzIz4iGRdrS/AkoKsr0vG36/jvJvo78pbs/nRsoSqq/wXizd1zfyW8DC8XBjx1dnp
         +YFvTgz/TCUOmPdMnKnxH0+geOZ9iz9taR3xbM9DJdYJljfuz5UjEnD4IFRpdVqBH9Ar
         H9dG4jdaRd8WrTRp4Giyu9cztxlLnfO2jYNWlWNjmu/ginLKGoA++Ifp/EMmqCbcqPRR
         153E83vLAlu2aJnwt32wzsX5awCh8THa6vJvs4O8Bu6m2V8vX57YVHM3UPkeFneUxKpv
         iOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757609079; x=1758213879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7zIrmTcH7V0C2QWyQEZI8cLSyj2S0FQeUO8H0HYb/8=;
        b=oinT6H00MsLkzQ8dQqbIWTRSi0Yng+6IfBFJt9ig+sZ8q7gYjp0RK5p/XxaVTXwmHy
         p26jI1Mw1St1n+MWIIAwSgRqtEPjdolzuLZ6DpMMMtJQhe1W9h6j2I8gnDDOuW5KyF39
         QmBotYnbyCF0FyrtY4eNWka6EDO/JLptGbbt5BkaQtwXff7qcZqUmFxF/dUR3TbnxaMV
         uWmbVmD8xxkbD3Y+XM6rqhnVjNkMMvB5GwbB77xpbOlDun+nmWl/hgSio9ry2fTMY+un
         7wIuaS3GZrVcms/zFnKMbcALpqu7C/vwfG2N67vagNatzYQTK79aG7V1hWL/zHKsfREn
         XXYw==
X-Forwarded-Encrypted: i=1; AJvYcCUg15s7xz5/Mh0gfuNWQb9GtCfNAL6sdjM982+mqqPChM2OmyX1iNADY47k/QcgEAOBYO8o3HptfKDxF5YCPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnIis6pkaQG+p+Nus8TzrGKy9D07iebg8eD5ZKmctP8nLPfDaO
	VxbGvr1UjDWRrv11wmAU4/5dDQHgccaOX8eQn5ItDbd+eHgP67HPfERHbSKBQkTesiDYQg7jvW+
	rGw4YgfHv//W82TXNfqtg42Z1GhawBhY=
X-Gm-Gg: ASbGncuemtNmjZK3iWwtGodv7/qo6Yd06ditWQhoacK3YW06q9Y8UI79u4riswcvAsd
	oLuyS5Lxqzknu5L+dibdK5oOGjojU6RCKPGcoamB2DnfPvBif1MtdcLn5bQCJYq/ABbYh7CcJbE
	NYvm4Hph37RxAKv/O5qvgihwVX/Nsx7j/qEPhkMKMdnQwlPZiQdqOvPJBCXkRjfD5GV48X72TRs
	quITUWgSNfIioRYWek=
X-Google-Smtp-Source: AGHT+IFs1CV3yVVZXZDMGsTeTso3AEuFjceZvzC2pTMX9WT/SD8BBKjIvKtouj4GtucfAqE4OoYOii8QIyUDf/twVIk=
X-Received: by 2002:a17:906:4fc7:b0:b04:9acf:46c4 with SMTP id
 a640c23a62f3a-b04b17376c1mr1933063266b.51.1757609078466; Thu, 11 Sep 2025
 09:44:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFYUeKswEh54fM5bFEvOfFLfc_GunKwEgr2uND=j-pxixQ@mail.gmail.com>
 <CANypQFYGt3c1eoeytCzw3RKLw+cbtDDPJy8UM=aj8HQMC8MWmA@mail.gmail.com> <CANn89iKkQ_zmdYwFLomcg4H2=4s8f1_2E8UbHhfd9KEPv=tu_Q@mail.gmail.com>
In-Reply-To: <CANn89iKkQ_zmdYwFLomcg4H2=4s8f1_2E8UbHhfd9KEPv=tu_Q@mail.gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Fri, 12 Sep 2025 00:44:01 +0800
X-Gm-Features: AS18NWBS4uG5Gox8DFZ7HZzpk_Vt9bHfh2HzF20kEvBgTQrA8elDiKoDobubpYc
Message-ID: <CANypQFZVc-+E-xDWyza33A=BTmYRQjsK24z3Tny-X3xzoVO0jQ@mail.gmail.com>
Subject: Re: [Linux Kernel Bug] WARNING in remove_vm_area
To: Eric Dumazet <edumazet@google.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	security@kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the reminder! I'll keep it in mind.

Eric Dumazet <edumazet@google.com> =E4=BA=8E2025=E5=B9=B49=E6=9C=8812=E6=97=
=A5=E5=91=A8=E4=BA=94 00:33=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Sep 11, 2025 at 9:29=E2=80=AFAM Jiaming Zhang <r772577952@gmail.c=
om> wrote:
> >
> > Hello,
> >
> > Apologies for the oversight in my previous email. I neglected to
> > include the formatted report.
> >
> > Please find the formatted report (formatted by syz-symbolize) attached
> > to this email. This should be easier to read and analyze.
> >
> > Sorry for any inconvenience.
> >
> > Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2025=E5=B9=B49=E6=9C=8811=
=E6=97=A5=E5=91=A8=E5=9B=9B 21:59=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Dear Linux kernel developers and maintainers:
> > >
> > > We are writing to report a kernel WARNING in remove_vm_area,
> > > discovered with our modified version of syzkaller.
> > >
> > > This issue was initially found in kernel v6.17-rc5 (commit
> > > 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c). Unfortunately, we do not
> > > have a stable C or Syz program to reproduce this warning. We are
> > > actively analyzing the root cause and working to create a reliable
> > > reproducer, which we will share as soon as it is available.
> > >
> > > Attached are the kernel console output and the .config file for your
> > > analysis. Please let us know if any further information would be
> > > helpful.
> > >
> > > Best regards,
> > > Jiaming Zhang
>
> Please note that syzbot reports bcachefs bugs quite often, you do not
> have to involve security@kernel.org,
> especially if you send public reports to linux-kernel@kernel.org.
>
> Thank you.
