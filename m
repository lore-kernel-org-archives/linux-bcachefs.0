Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ABF15B988
	for <linux-bcachefs@vger.kernel.org>; Thu,  2 May 2024 20:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714681737; cv=none; b=Xz3r/5+1J7tacYFQConRuFb+Dp7niOvoZ/64AFhJ93keIOeta3ty+SojiwW9oYZK7MWGzGgF/z1zJnhLVHcN0g+X/t/ClW1hXZkAoT7fbXFygOCj64FjiprsowJSSxWkoOxum/kL7qHklE4RjqnOXmnoQdN2Nnz0TZGI/JYnxAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714681737; c=relaxed/simple;
	bh=zLLDTk7xl0de3A0RLseluPNPKN7nj7092t1YKGx/xRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B9HMAG6Bt88DEBOPzzGj5zcAnSP0x7ePwMl2Omv+cE9dQA04mLADVFhwPACMBvVV1LLtuSGxg9X3Y4s2TUhyBZk+RzlAuM/X5rovj69bQ0+KDb1k3uoxIMNX5MRuWll+EQ4zMqLgqbcBEDPDZFRXvke4XzPaKdiydiuRjTgZXZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nws4kW0X; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nws4kW0X"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1ec182ab287so10265ad.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 May 2024 13:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714681736; x=1715286536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLLDTk7xl0de3A0RLseluPNPKN7nj7092t1YKGx/xRU=;
        b=nws4kW0X1iYRWs5JCYkLhk6hirPdvxtHw9peTN+iWsKCZ/bgFucMUVn0TVwMEObMJU
         nUlT1lr+LQ+rqj2Bg7x6Po0+C8GRSwyywsfOgLzSFftjDDm8Di+qAdFonMscAU+lBndQ
         uhSRSQqxxt8CLwc0YiZ0OFqFGVjP374ezu8TbEbpYmglDRckK6sgbWaOwiqYjAzAm3iL
         Z9rZJQWLcy4TVJjHBJHyREcOcFulA/9dy7BFXsclJ8aQtsxXg6wDpDJzlhUm+gq0gTO2
         4WyIymri4Q+4sQfIma980cTeq9UW2WUx6/vE4ugDpGVelqo1E8/mKMr7RUkmvvT2TTKT
         JnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714681736; x=1715286536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zLLDTk7xl0de3A0RLseluPNPKN7nj7092t1YKGx/xRU=;
        b=opk0WTj5kOCIWaYAIfDuhZVIsQQU1aOMmpdPADpfRteII9utrXGr8it9TEeqRilhPk
         7R2kFoKE2zWV4fpadhv0oOERXO6TOTvJdTbH24k+02vTo0m9RZarB8cii1DeIHCfRm8i
         u9XwPdtl/6xrtxYzI/5rbAi2kI6UikRR3pqNYarZZGOs2oADOBkMrfwtaLKgl3gfZa64
         sc66BfjM/FZ9CgZs68BdY/H5hD4+AoNgkhjClzvNbYuNMccyFJkUmTBN6o32/46KwTHO
         ufkBNNGGLUyL6VwiRCcmHKrxXfsi4xMSQ24XgcgsikvWioIeVsLJXf5Skn2lsLfFYpMm
         nZ4g==
X-Forwarded-Encrypted: i=1; AJvYcCVuYTxIolNb/9WUsrNH++ojhHEScVWA0PfpX8GxMreYhnUeyEiWq8D8aeY3JpNG+TRZb+9tzUJEl1GsPgNhvN3A4/VffIKc6ubHqRqGYiY=
X-Gm-Message-State: AOJu0YwgDMxT7/eUYFWHm3UkwUDi2YNtk3i/auIsLkHQ2DwKGXvA2ZSt
	pTDNu3hzlpg02A7VTi+y6CsfScaZyWRwrOuQ/XTluoFkwhJSESpehzwuw/98IdWFBRQTT8vtcjQ
	fxIldhtPJicaA7i6MhHHl59Aolon5dRLcRmO+
X-Google-Smtp-Source: AGHT+IGI8LrduAFZb2j97H+0+ezWttyJAQ1jFlOuv4IymRX7JAjmTfhvZqrX6wihOGo5Kx1HZSncvm3L3ma1hDG4yG0=
X-Received: by 2002:a17:902:e5d1:b0:1e3:d23a:2d5e with SMTP id
 d9443c01a7336-1ed36dce7bbmr29255ad.21.1714681735575; Thu, 02 May 2024
 13:28:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
 <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
 <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com> <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
In-Reply-To: <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 2 May 2024 22:28:42 +0200
Message-ID: <CANp29Y6wQSb2Zn9Jujhzw4Mij77Nvfo4+2fkpY=ppJ6OCDE6Qw@mail.gmail.com>
Subject: Re: syzbot for bcachefs?
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 7:19=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Apr 19, 2024 at 10:35:27AM +0200, Dmitry Vyukov wrote:
> >
> > We've enabled the configs, but we don't have good image seeds yet.
> > Aleksandr tried to generate them, he is currently OOO, but maybe you
> > can help meanwhile.
> > He said that running:
> >
> > $ mkfs.bcachefs test.img
> >
> > gives this error (on a quite big image, I don't know how large exactly =
it was):
> >
> > insufficient space for superblocks: start 8 end 4104 > 4096 size 2048
> >
> > Why could it give such an error and how to avoid it?
>
> What was the precise size? I'll see if I'm able to reproduce

I think the problem was that I was trying to save the generated files
to a 9p filesystem (so that I could easily take them out of my VM).
But now I've set up a proper userspace image with the latest 6.9 RC
kernel and it worked fine.

>
> > Also what would be a good sets of options to generate seed images?
> > We try to "sample" space of different images to create seeds. To give
> > you an idea here is what we do for other file systems:
> > https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03c824=
d6642f6c0b/tools/syz-imagegen/imagegen.go#L60-L516
>
> --encrypted --no_passphrase
> --compression=3Dlz4
> --no-checksum

The mkfs.bcachefs tool that I installed does not know the
--no-checksum flag, so I used --data_checksum=3Dnone
--metadata_checksum=3Dnone instead. Does it mean the same thing?

I've pushed my changes to https://github.com/google/syzkaller/pull/4752

--=20
Aleksandr

>
> That shousd get us reasonable coverage to start with.
