Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7055941A84;
	Mon, 30 Sep 2024 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727701707; cv=none; b=Iz+Cf094jzYDAw5SwzjcU5mFDSiA4jLgnau8l7In5FsW0h/IZdDXY14vAwbDL6Nh24pMUR6TB0sHNHKlF00L9PWFBpFUPDtBVYbSr0F3ZQOLrPkq22omTLtRWSX+b9d74f46XzOseOj4DtzYmCeYX4kRzI9GmraqTsNYL9tOI/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727701707; c=relaxed/simple;
	bh=lJMbXOLaoTQWPHteatcACbF5SHhiwAK5RcwdJdHkHIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AiF7VT9uTfzClJX8nD0kN9qN2mXaTXmY+hh9i0kFtbfUEMWArA9rE29BJzlJUtnTyT+IJUC1HtjnjKf9D6wx7R5fNGEFSgQBGN09fmN+0aLp64nVyMCixs1cvVPiSuVaKLMiJH5lRvep5BJ4MxFswZANxStzagm4r3o04iDrdO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-710dad96bf7so1007531a34.0;
        Mon, 30 Sep 2024 06:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727701704; x=1728306504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bv7MwMEuMoMwsONGPmFGg2sAv+OxcqxVlJPO/nIu4M=;
        b=iI0zaHUbiDf+gViujukwgR30o81jGg79b7nxx0tg4+cGSWNqNtLoF5nFu+vW2I6EcC
         flnBhF1tCPUncHdwsOFZ1CciQ9hJzaDpDNWKBIK3Bb8sYA1tANgetaL6CY4zl86WkQrA
         T0n5a3go2AKgHHkwN2ZJaghghUdOFskbILv1mPrysDvgpflZmx5ybb/Rtpq2qaoZ3CPz
         MxuB92koXFZuQOhngJAK1c9prjFcYaYwIu8JuUh8Dpa2aW4uR8S0Q0riVLhoUBGQai7W
         enuh7ET1Jsu7ahsTxw2plFgkLL5+KvQcjpqA6VOYyY73eytGAKCCFnaxV7kSDf2g1/O8
         9GaA==
X-Forwarded-Encrypted: i=1; AJvYcCUQtBeTQPi401ouhcNuC2PCcnqjnPbtiIXzMO7fYgUPSybezrZU+DwhI1yl71lB7QzaIEzye5iG9+xPVTsD@vger.kernel.org, AJvYcCUsAuDaqOD4cNH89zau2OpAJOaVaIXytz+yPhfoPtsBq8xzdqEMEBCZFOtjOIP/3M8Vy/YWHiAVBdaMXwIykw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlWQZZmAH66vnbskdqe0Lvkkxg4z+XZtrLW7YfqCp21xlmOQId
	6xCPRKXZY8+1exlK/+H2QSI1UF2ciOGvWvw4w5aF1OHbmyVFPvG5AA6giQZu
X-Google-Smtp-Source: AGHT+IHvebmGV9jzv7CiMPY6K3xjtcqFfIx62SkjJKQFEEInwlG8XtYI6FA5+5eMcddC6w5nkPu8xQ==
X-Received: by 2002:a05:6830:348e:b0:710:f8df:33d2 with SMTP id 46e09a7af769-714fbde5aa1mr7404713a34.0.1727701704023;
        Mon, 30 Sep 2024 06:08:24 -0700 (PDT)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com. [209.85.160.45])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5e770eabe2fsm2141423eaf.38.2024.09.30.06.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 06:08:23 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-27ce4f37afeso1741468fac.0;
        Mon, 30 Sep 2024 06:08:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWqKUfP8RKeufZc6sqF347d0KaaONnb2jp6Uj3p4Xr1HivJaqAPpSjII5ZqhH9+fJDA23EbodQXrfC4TF1U1A==@vger.kernel.org, AJvYcCXAOC5AeukT4n2Vw4qtAH2Dht888Cvclp2T6zn9zpHkFoiga8jxizvpCYLOBHGuPuDlxogmJEO9bT7nqOAP@vger.kernel.org
X-Received: by 2002:a05:6871:8713:b0:287:4e4a:a2da with SMTP id
 586e51a60fabf-2874e4aba6amr1313043fac.26.1727701703155; Mon, 30 Sep 2024
 06:08:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930003902.4127294-1-linux@roeck-us.net> <CAMuHMdWcPpBgsK0r0U=k8NyjTjUTwBTLe6Bg_ORD2zmSNoRgJA@mail.gmail.com>
 <obpogbufu5awsn2a6olh2ondrgwl7bgdowjcpv6jcpm2ey4s5h@obcml2w3csap>
 <CAMuHMdXZ_N+uvXROpNvvSO3AZ7A-7hQTE4FxEa=1aMX-NC5rbA@mail.gmail.com> <fo6bvxt5o5veelshcig3zrqyktwvpxzxpvz4bb3n6gyk2vwejk@fx7opeolkbvj>
In-Reply-To: <fo6bvxt5o5veelshcig3zrqyktwvpxzxpvz4bb3n6gyk2vwejk@fx7opeolkbvj>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Sep 2024 15:08:10 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUNoomsTKu=X5C=HBd+RAkzgcBoYyqmMy2-NsM0DqbRoQ@mail.gmail.com>
Message-ID: <CAMuHMdUNoomsTKu=X5C=HBd+RAkzgcBoYyqmMy2-NsM0DqbRoQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: rename version -> bversion for big endian builds
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kent,

On Mon, Sep 30, 2024 at 2:31=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Mon, Sep 30, 2024 at 02:08:25PM GMT, Geert Uytterhoeven wrote:
> > On Mon, Sep 30, 2024 at 12:11=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > On Mon, Sep 30, 2024 at 12:04:42PM GMT, Geert Uytterhoeven wrote:
> > > > On Mon, Sep 30, 2024 at 2:39=E2=80=AFAM Guenter Roeck <linux@roeck-=
us.net> wrote:
> > > > > Builds on big endian systems fail as follows.
> > > > >
> > > > > fs/bcachefs/bkey.h: In function 'bch2_bkey_format_add_key':
> > > > > fs/bcachefs/bkey.h:557:41: error:
> > > > >         'const struct bkey' has no member named 'bversion'
> > > > >
> > > > > The original commit only renamed the variable for little endian b=
uilds.
> > > > > Rename it for big endian builds as well to fix the problem.
> > > > >
> > > > > Fixes: cf49f8a8c277 ("bcachefs: rename version -> bversion")
> > > >
> > > > Which is (again) not found on any mailing list, and has never been =
in
> > > > linux-next before it hit upstream...
> > > >
> > > > > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > >
> > > > > --- a/fs/bcachefs/bcachefs_format.h
> > > > > +++ b/fs/bcachefs/bcachefs_format.h
> > > > > @@ -223,7 +223,7 @@ struct bkey {
> > > > >  #elif __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
> > > > >         struct bpos     p;
> > > > >         __u32           size;           /* extent size, in sector=
s */
> > > > > -       struct bversion version;
> > > > > +       struct bversion bversion;
> > > > >
> > > > >         __u8            pad[1];
> > > > >  #endif
> > > >
> > > > BTW, how does this work when accessing a non-native file system?
> > > > Didn't we stop doing bi-endian file systems in v2.1.10, when ext2 w=
as
> > > > converted from a bi-endian to a little-endian file system?
> > >
> > > we byte swab if necessary
> >
> > So you have to test 4 combinations instead of 2 (which you don't do,
> > obviously ;-)
> >
> > Ext2 was converted from a bi-endian to a little-endian file system
> > because it turned out the conditional byte-swapping was more
> > expensive than unconditional (not) byte-swapping. Given all the
> > bcache structures are already tagged with __packed anyway, I guess
> > this is even more true for bcachefs.
> >
> > The proper way established +25y ago was to settle on one endianness
> > layout for all on-disk data. That way you do not have to duplicate
> > data and code for little vs. big endian, keep both paths in sync, and
> > you can annotate everything with __[bl]eXX attributes to let sparse
> > help you catch bugs.
> >
> > Which endianness to pick is up to you. Ext2 settled on little-endian,
> > XFS on big-endian.
>
> If you peruse that code even slightly, you'll see that what we're doing
> is treating the key as a multi word integer, so word order has to match
> machine byte order in order for various things in the btree lookup code
> to work.

I have seen the multi-word integers...

> But sure, try and tell me there's something about filesystems I don't
> already know...

Okay...

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
