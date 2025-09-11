Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1D0356919
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 16:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608438; cv=none; b=I1Um2DFWEDSjDl+DnwIqhH8IXINORe8JmeEqd4yBibdt7IDQ7SA+ryN6dtZeW5C2WSInnJRP85EudmN6s8v4h4bc1Nf7hMp7z9+rDVgzdDJu+gSCIRxlwdwbTLpfAgMLH8GYA3M/OKZ0+G5c4iayAWNuyOIkuk6gkveo8N3sGDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608438; c=relaxed/simple;
	bh=XRpc+knh/XAGoMqBcH6aN+Qn2be+thMVYIuV1pFbNDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbym0a8hMzGb7jSDl+4h9eMHSxNnfqJwkcld0dP3v+h9r/e5jRh9NN13Fod9z5Z8sq7knTjcoTHiVNGBAz/t9b9HZm5pFHmXgc+T5nRlkptLkneBJ+0tTli7FhhfV9MoiG1yTFXWWSLHlRYF3dLhT/BQNBpyXmwLcJY6D0i4YRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxhAQsYE; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxhAQsYE"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-80bdff6d1e4so93762485a.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 09:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757608436; x=1758213236; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRpc+knh/XAGoMqBcH6aN+Qn2be+thMVYIuV1pFbNDg=;
        b=bxhAQsYEAkDWSwLT0pB9/BQLJ0RyCYomKP7sHMcs8ePjcFxCNLnv+604hKj7rMzv9i
         Z/lnZtdq1Dq3nsIi9lMlMCX45dOU4tK0I4JNKgF4ahOtK3g9YM83car4yOsHLccLo3XZ
         vTtkEwnxLTa+BaiAs2MFIL6C2vxd3+7FY4rqPGJQPGaummjGhCD98CV0SbYJ5a3uc49S
         InHpZOjUj2XjTY99PzhWy6kbRbCpPg9ryx5N7BSO7VGnRFmIrs+9zxo8hG2LmDagZgCs
         PYr3Yc1zJehERBv4ja5EXsgZKxAoshiMVlmBvFnwNbT6C5RWM6fEdNFXKhxlyvwAuu8d
         ZQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608436; x=1758213236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRpc+knh/XAGoMqBcH6aN+Qn2be+thMVYIuV1pFbNDg=;
        b=MAmZI/iBRZpNCq8W1pSJMmaahjnGoSf24FGDuUJzfZmaBZqyt6vH2cGqUtamOGrzmh
         3nCX8fnasYfaA0Kh+j+tEvHsRB26dWSfpiXUFW2gfW0kQIm5rYqusNPBrEAJWP4C8z4h
         Pqz2N/0HqgfZNS0gg/m3v4043xVx4W9tSfUD8R2SBrMmL+pRcMcPP5+lZ3UNvY7dqDbo
         mv3NE++877Yeug/BaH8IIfksB/3aowCWREA+JhQcnZkLcr9J6WFjZq1DW7O+E5e7A4s6
         3EQrrucoV3mJwv7krnFmOyaErWw7aLSPK7aUC2zPNoZ08kkgoU2s31r9xXF9iDOhB9uz
         vTMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU52LKm0ao8m43PBAHJLbsZ02T6RyGw6ytxezNXIvSKUiTh768loZngiNXFu4CeFRa/M9D74pqDNhlNjYqgog==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvceLJ2dmTWeE+M7lB7JDQvmriN4KBXW9iucB0YypFxPwpJJBY
	HK0nz6MSYMoBgpPesAEnRhR7PyCGInBzKcBBC+ySONP/ksU/mDz+DcpGxVGQ9ZV0rDEarvwWxeV
	kob7KU9tUB2g/bbVcdfkYRcNCae8Qrp5uA798Ogti
X-Gm-Gg: ASbGncuRuRN+/CoM06SlZfB9j3UJ7Xvwbzul8+n1XbUj5zwuRXpVhaHo0qd61pwBWyE
	M6AEx18Siv9PbV+OuIi8VS2UF5E7EkGwb5ubbPjGElZIw3RqCFa5MAvE5C/IA7t+xowPwVQHTL6
	2trAnZ2vwn/dJXaNEBpPAtqgz9QM57mgcRwIwneyqwjPwRgh4XQrBVwa7nGFj8YMvVif7cVosTy
	jcydIVwJqbUEpFw/s6F+XPxmw==
X-Google-Smtp-Source: AGHT+IEaFA8tsNcJeHfx5qLmIH0MNFjzi/To//8aF+L9OoKjWM1WmelbHtAWtohQ9HZ+iZUhBysXGLmTj5pKgg/s0xg=
X-Received: by 2002:a05:620a:46ab:b0:80c:e95f:8a54 with SMTP id
 af79cd13be357-813c0d0e13emr2025336585a.29.1757608435516; Thu, 11 Sep 2025
 09:33:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFYUeKswEh54fM5bFEvOfFLfc_GunKwEgr2uND=j-pxixQ@mail.gmail.com>
 <CANypQFYGt3c1eoeytCzw3RKLw+cbtDDPJy8UM=aj8HQMC8MWmA@mail.gmail.com>
In-Reply-To: <CANypQFYGt3c1eoeytCzw3RKLw+cbtDDPJy8UM=aj8HQMC8MWmA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 Sep 2025 09:33:43 -0700
X-Gm-Features: Ac12FXww1fFqS3jtWKre_Swiw10hdYzTQtOJ2Z6Tvjkjgn8O4Kb4C1yBFhEel6s
Message-ID: <CANn89iKkQ_zmdYwFLomcg4H2=4s8f1_2E8UbHhfd9KEPv=tu_Q@mail.gmail.com>
Subject: Re: [Linux Kernel Bug] WARNING in remove_vm_area
To: Jiaming Zhang <r772577952@gmail.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	security@kernel.org, linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 9:29=E2=80=AFAM Jiaming Zhang <r772577952@gmail.com=
> wrote:
>
> Hello,
>
> Apologies for the oversight in my previous email. I neglected to
> include the formatted report.
>
> Please find the formatted report (formatted by syz-symbolize) attached
> to this email. This should be easier to read and analyze.
>
> Sorry for any inconvenience.
>
> Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2025=E5=B9=B49=E6=9C=8811=
=E6=97=A5=E5=91=A8=E5=9B=9B 21:59=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Dear Linux kernel developers and maintainers:
> >
> > We are writing to report a kernel WARNING in remove_vm_area,
> > discovered with our modified version of syzkaller.
> >
> > This issue was initially found in kernel v6.17-rc5 (commit
> > 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c). Unfortunately, we do not
> > have a stable C or Syz program to reproduce this warning. We are
> > actively analyzing the root cause and working to create a reliable
> > reproducer, which we will share as soon as it is available.
> >
> > Attached are the kernel console output and the .config file for your
> > analysis. Please let us know if any further information would be
> > helpful.
> >
> > Best regards,
> > Jiaming Zhang

Please note that syzbot reports bcachefs bugs quite often, you do not
have to involve security@kernel.org,
especially if you send public reports to linux-kernel@kernel.org.

Thank you.
