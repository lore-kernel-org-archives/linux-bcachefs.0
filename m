Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999C944E;
	Fri,  4 Apr 2025 06:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743749594; cv=none; b=kZIwb5rDo2lwmqmQmWmQtXI12vW7Mg0OFJ9LcPB8VYMr/7Ogy7NleV1VhK2POYScxfAgYt/omduDG8e/9lyTk1cEPt7sm9BzLVmAC6uWUqT44+fEDwb+b7wu6tpcluCUPvUbsd7n7c5url3hbDOAii8KLYz4/zRx7DwDzSGSo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743749594; c=relaxed/simple;
	bh=wagEcAUCHG05vNZLORykGW7a7L+MU7y4dAnfJ7Prwbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UgH48o9VPUjqRal3FfKaW8EJpK+f2k90+ZFg0O+cj1LNK7hK6LKNBkVKmA243HAAz+XqJsSWzGuI56kBnK3+7ZneT8xt53x5QdQyZwJy+zdawJ+0QCfyvGsannzwn4LJbzye2sVDNDI1e2XkvewUoYLgigz8A9oDpKIGFqWNg5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DVFM/b/w; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVFM/b/w"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ff6e91cff5so1644283a91.2;
        Thu, 03 Apr 2025 23:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743749592; x=1744354392; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wagEcAUCHG05vNZLORykGW7a7L+MU7y4dAnfJ7Prwbk=;
        b=DVFM/b/w4Gow44KtWF7tUn1wsliiLxGWckarTDNCC9tsJur4uC1pY4O4peChFl/78G
         UZzM74MBuhB3YJURovnWAy2xZu8Xg+Ep5G5KutC/NcNhf3C1vQA6G7QSDs+G5hOPghyv
         c8b3ZNmquVC4XTp+au9wSIOQzF3ARXdPPMmpcPhvBiZT5PKxmfghlO4erf7C4DOIFMOO
         hWMCAihfCPbYeivMcLDbW5rVdhG4BDzx2SiWY6u5aDjpQBe6waxy/YJaAOcIVyPXFOIw
         6bxKhl922mvEI55rRnFNGov9q4AuN/0Zcd8J2sG62ewreywwPqYLhKWHjRbjyhqxY/6c
         56Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743749592; x=1744354392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wagEcAUCHG05vNZLORykGW7a7L+MU7y4dAnfJ7Prwbk=;
        b=ZQrnkj28D6uAGSirouBJXItWl9IIEaxP05q7iyJ+DGp4wA+MKNVqjiK4+7haEpIf90
         E3rhLcRjoXzruXXQ3fR2bAfiV4lMaVPsRyj2eKgIsmBh31XexZXV0SdPSkGUqWkgChmA
         iZlwg8gp1bg8RB9J3LdKdDmQcquatv4mwH12iu3gV4hF0qeD5yNNIxypkSW0Bk4gBeOq
         ydl3y0o6E8JTB99pPvBuRwCJOBuKTrRcvHfQyyq91Efg/QdCOIGNlJGFtJVZnYhubmL+
         QlU19a0OZtzyftRfk6FB8e0txGxlZXpjO+5WzGwI40vzAL3mwMnt0LDoXS7NSp17OhaD
         Ax+w==
X-Forwarded-Encrypted: i=1; AJvYcCWsjQnodGZI4XBqNHaEciahXX1as3Q0keIxqXvMVaCRFFEoNAclMs6O0pLhHxHxr4c9m64YwXeXtyeZJOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDhFw8Vpe6zt21OJ3eQp9y43L7+KIaKT/s/2/udalCafKXN0uu
	tRUl+IBrSEUT+R3Ykorcu6FfDOhJBM6r6o+8qIZDazPTXOcut9ZwVQ2lKzx+9VDmjBwdrT1wOnz
	9IT4qpqfgbwBn8XlIPYy5UqnmGxo=
X-Gm-Gg: ASbGncuid5wvqpgESMlMxZ3KoG1H4pVgcUkm3Yr0zXe5bB1xlBzLnaTSLadWBind/xn
	cgYxkiayJCDCel+svLGSdYrzvIufy+4OgInuLIw5AcgMdB2N8FGTA29kyMp34zS3tC+vHKcg6Hv
	LgqgW/89dNZiNGGGN+QicZGo+c+EFeVlJIuP8B
X-Google-Smtp-Source: AGHT+IEL7jgtpRh1nW1SS7zZ3z7a94wwMUS7u52cjNfkU3cMCpt/OhXhPeGtWWkv5f5GksecYqHZpamDGK2sAf61OpU=
X-Received: by 2002:a17:90a:e18f:b0:2f1:2fa5:1924 with SMTP id
 98e67ed59e1d1-306a62138a0mr1822038a91.26.1743749591696; Thu, 03 Apr 2025
 23:53:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
 <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
 <CAPZ5DTEGi8RXBMui823bwnt96PcqZSavH8AQ+LPhRs=sJ-Br1Q@mail.gmail.com> <ciw5ocj6io5q5p2tsv3sqpga2ff73eqwhlrrug4el63ggolcho@iviprrqsaemj>
In-Reply-To: <ciw5ocj6io5q5p2tsv3sqpga2ff73eqwhlrrug4el63ggolcho@iviprrqsaemj>
From: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Date: Fri, 4 Apr 2025 12:22:45 +0530
X-Gm-Features: AQ5f1JqhQjzHwVi0_Dvyw6YFPjyd625XIAiKSOF-1GZqntHD3yyuAojBkP7y-AU
Message-ID: <CAPZ5DTGWC2Xemgby9E8EL61Vio0NYQrKBd5FNpvERwwBoEP8tg@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: don't call sleeping funcs when handling
 inconsistency errors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 10:08=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, Apr 02, 2025 at 10:03:10PM +0530, Bharadwaj Raju wrote:
> > On Wed, Apr 2, 2025 at 9:47=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
>
> If you're feeling particularly adventurous - print_string_as_lines() is
> a hack, I think we should be able to do something more robust by
> skipping printk (that's where the 1k limit comes from) and calling
> something lower level - that will require digging into the printk
> codepath and finding lower level we can call.

I tried looking into the printk codepath, namely vprintk_emit -> vprintk_st=
ore.
It doesn't seem like there's a convenient single lower-level
entrypoint we could
call which just avoids the 1k limit, rather there's a lot of internal
code mixed with
the truncation that we'd have to just copy if we want printk behavior.
I don't think that's a reasonable option for us.

> I also just noticed that print_string_as_lines() needs to check for
> being passed a NULL pointer - in case the printbuf memory allocation
> fails. Want to get that one too?

From what I'm seeing __bch2_print_string_as_lines already checks
for the lines pointer being NULL. The only unchecked pointer is prefix,
which I don't think needs to be checked since it will be something constant
from kern_levels.h, not something which could be NULL.
