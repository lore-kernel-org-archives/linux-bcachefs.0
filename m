Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8386D21105;
	Mon, 30 Sep 2024 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727698122; cv=none; b=gi0hcxoFIEtMRwXK1S72WkmChR6o7mraH+/r7taZj+ugxwGI4Yat1CXefL40GImqWHqdIettxeibLe7/TUNGfS2EN9prQ0WxspCQF/QFtiWXT+Jv3sABEajixXBl95K3LFtox7r3Q3q1iK5TfCw8iHU4Nm00hBEtP1i7ItWG+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727698122; c=relaxed/simple;
	bh=6j0o9FIGMN+GsY1VVNW1bDqJznpxzbVADT6Kw4LqRLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e9eQWPa3vPmeBZXJVodwjrAbRDzcfUDZBTNnW23g7TXrScO9tWoEBjsNurl6jMIsvM/ym4DBF8zCTbIATiMdnLP/WAaBVeNhWCvtZG+g6o3cqLlI4mQsokzCzWzi+n9hvZ6XpYrahzoalE5wZW3GoVmRM3NEHNSWOqkp6HaA5Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6e2598a0070so14354217b3.1;
        Mon, 30 Sep 2024 05:08:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727698118; x=1728302918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBVZmNDqRGfEDYngJl/uKE8h3d1LhGCm3KqQOd6+fHE=;
        b=XWtvFAQKzt7Jp+lLQOOuR2hlRZBzIGI5uhGEylmzwIxz0uUqvaaQVhJJWXeXXjQHsS
         GBYwsk75Dl8pvU8HYZXe8AxdVl4r3Frlo80WYph2h397y9dSHQ2+YDm+f+cn0TiCQ1Sr
         Q+nIk3CTQd0R+a/4qtoPWW3wYFuqSkxIrs6fokN9aNQbvgm5F0EDPpYI0lrZJPMfbdok
         c/CDAMfXI0Pq1fvbXbf5Iq2ocBOuVH7SPL2uytyuntx7jmsWbBRe9VsjTgGyJuaCuuu1
         d7F0WShsCQ1awhHoldhB6OLvpF+XKVGFGgYnTzq2LXc9Omo39UqBWhwlDku+eBrXd5DO
         PROw==
X-Forwarded-Encrypted: i=1; AJvYcCUGjr+JCq8lt1xYcLjDJ3Aymw0TWd5Q4KWePCbOQlVYvNNl58+EV6RubB4lcLEjfEVnFwHT5wL1iluz6pnr@vger.kernel.org, AJvYcCWPSPtTWaEMYN+yQYVQ2eAXqa3YCG1odd6olZZ8mG4Q4cOeujkQVPON7EOfqToBKMbdwT3iS4dAwu1Na7sicQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Aekohod872EEpOaVQxoghxTG/0NbiwKsB+uBiK5F5gvLozmp
	YwbYpHeZVpG49TSZ/VaKz9f8mmQQsbaPU2/G45o6P2xUcD2IDxhyFkXGalvj
X-Google-Smtp-Source: AGHT+IFjHAIchdqhmFYq8aMxXsQHGSewrO/E96IsgkRRMb9M+mIe82iBzm+frMVH8k7ARtGKkynN4g==
X-Received: by 2002:a05:690c:d96:b0:686:1240:621a with SMTP id 00721157ae682-6e2475dff92mr90410207b3.31.1727698117994;
        Mon, 30 Sep 2024 05:08:37 -0700 (PDT)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e2452f7865sm13420557b3.7.2024.09.30.05.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 05:08:37 -0700 (PDT)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6dbbe7e51bbso32859067b3.3;
        Mon, 30 Sep 2024 05:08:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXoA65BLDfFSmcZQfmkiZvPxu11S1o/Lg7aMPgbtz0+iio0Ks6j1d+Zx2hMKbHgo/uq5MxK3KNBedksWMATzw==@vger.kernel.org, AJvYcCXwF2klSdgO3xstyvQk8OKEEM43hTzsUYMGaAesEklMPRTRoLmsmVmq1KkcIS1VTXXEFkCVWsHoYhFkJ3WA@vger.kernel.org
X-Received: by 2002:a05:690c:2905:b0:6e2:1062:9b90 with SMTP id
 00721157ae682-6e247619bd8mr62582227b3.44.1727698117280; Mon, 30 Sep 2024
 05:08:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930003902.4127294-1-linux@roeck-us.net> <CAMuHMdWcPpBgsK0r0U=k8NyjTjUTwBTLe6Bg_ORD2zmSNoRgJA@mail.gmail.com>
 <obpogbufu5awsn2a6olh2ondrgwl7bgdowjcpv6jcpm2ey4s5h@obcml2w3csap>
In-Reply-To: <obpogbufu5awsn2a6olh2ondrgwl7bgdowjcpv6jcpm2ey4s5h@obcml2w3csap>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Sep 2024 14:08:25 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXZ_N+uvXROpNvvSO3AZ7A-7hQTE4FxEa=1aMX-NC5rbA@mail.gmail.com>
Message-ID: <CAMuHMdXZ_N+uvXROpNvvSO3AZ7A-7hQTE4FxEa=1aMX-NC5rbA@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: rename version -> bversion for big endian builds
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kent,

On Mon, Sep 30, 2024 at 12:11=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Mon, Sep 30, 2024 at 12:04:42PM GMT, Geert Uytterhoeven wrote:
> > On Mon, Sep 30, 2024 at 2:39=E2=80=AFAM Guenter Roeck <linux@roeck-us.n=
et> wrote:
> > > Builds on big endian systems fail as follows.
> > >
> > > fs/bcachefs/bkey.h: In function 'bch2_bkey_format_add_key':
> > > fs/bcachefs/bkey.h:557:41: error:
> > >         'const struct bkey' has no member named 'bversion'
> > >
> > > The original commit only renamed the variable for little endian build=
s.
> > > Rename it for big endian builds as well to fix the problem.
> > >
> > > Fixes: cf49f8a8c277 ("bcachefs: rename version -> bversion")
> >
> > Which is (again) not found on any mailing list, and has never been in
> > linux-next before it hit upstream...
> >
> > > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >
> > > --- a/fs/bcachefs/bcachefs_format.h
> > > +++ b/fs/bcachefs/bcachefs_format.h
> > > @@ -223,7 +223,7 @@ struct bkey {
> > >  #elif __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
> > >         struct bpos     p;
> > >         __u32           size;           /* extent size, in sectors */
> > > -       struct bversion version;
> > > +       struct bversion bversion;
> > >
> > >         __u8            pad[1];
> > >  #endif
> >
> > BTW, how does this work when accessing a non-native file system?
> > Didn't we stop doing bi-endian file systems in v2.1.10, when ext2 was
> > converted from a bi-endian to a little-endian file system?
>
> we byte swab if necessary

So you have to test 4 combinations instead of 2 (which you don't do,
obviously ;-)

Ext2 was converted from a bi-endian to a little-endian file system
because it turned out the conditional byte-swapping was more
expensive than unconditional (not) byte-swapping. Given all the
bcache structures are already tagged with __packed anyway, I guess
this is even more true for bcachefs.

The proper way established +25y ago was to settle on one endianness
layout for all on-disk data. That way you do not have to duplicate
data and code for little vs. big endian, keep both paths in sync, and
you can annotate everything with __[bl]eXX attributes to let sparse
help you catch bugs.

Which endianness to pick is up to you. Ext2 settled on little-endian,
XFS on big-endian.

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
