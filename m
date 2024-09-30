Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FF91F95A;
	Mon, 30 Sep 2024 10:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727690701; cv=none; b=n5mxSMjAGdHjJPt1clvoQ8GBfjwPpXDQnpBozEt40pj/MX6MF0g+A1ni+JXp9Fr5mlYL4KddDVIEBwISiY4zf0+OG8Qhe2Fo7IjqjrkuC5dgqceCpOUu1a6a4tQVGg8LerxYQpUJAL3o5QOOJt6grkKolYCQ15UKkkqDQiZ5eJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727690701; c=relaxed/simple;
	bh=ka5HXDF6ap/w3nzyZz2ai7ZzSVirj0C57Rf7qLccddg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rc9+H8YkqHC+5wMKGwq7HOLn4xwEBelf3tT4Jp1y9o7mkRm90qlIEzkwIgfx1fb1iMNGC+SNFHDMK68kCvtR53Dlyt8dqsS6RTti/Qn8pbREUmQz5aet6BKhCGbgsB6gu5/od9a7S+hJ5MPl++qjTgaWza3bST4TXyOXQaia3fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dff1ccdc17bso4083868276.0;
        Mon, 30 Sep 2024 03:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727690697; x=1728295497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bwL7nI0rxd6T20AR3+geyPsofbKfCMhK1gUqxYpKa84=;
        b=jZj2IBCH1lrXYV4wCNTBGYMyLZ9jXcpfrUBk8llbcAF+TBA9nBHxEt7LhGadk2/tJO
         +OKGYSTOndMXFrKGjDohJLG/U+WKPVyVQUHYK/hETjZ1HyQ5O1XTiaWUTBhvlgHEpDhc
         ee0WEToBhyGoEwL8Cf0jnuVURQqYBql3mT0yn+M8sNaYLICxJcTBiTWnYkkq3J0HrkNb
         TbvIXpadjrDoxv3tpN9srySgRtwO5iPaG9Lg4qHwRQe4J2MPgh1uJ94KxqFzo0dKEJcu
         ItVzUHCApCWgnOZHIsqCkvDSDLgYsnEz2IrnNYgz+urW1edxv96ogYwDNVdVQ7owlXjj
         sDvA==
X-Forwarded-Encrypted: i=1; AJvYcCVFN15hesH3jtQHW13TmOSDlGmOYd35GfpNGvGhRyuOCN+AUocdO3em5OXwSyyfHD6+n4EWQg6mAFwbHI2E@vger.kernel.org, AJvYcCVtqBLXXxbD/68dUZT0DgVLb7gc6MG+XFXuYgdJCQs46OcTTgyCW7g+eqJcRPkyFRmhjxsG3ASLZ2WwqldrcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqgGtjSuOUHKxv9DZeGsjQFNMXRNPuby9HNzkPwgMs+4+CvxjG
	5LAITSffLY8uHxGGc+a1jQHZocs564Ilystib3JoL3rArn1ST+ISO5SxhXhW
X-Google-Smtp-Source: AGHT+IFQbSOVMCBQwuspGK0NiCQzUnED3hg9e4o5HKA5SG9bnn+mxlC/4/TaaDIUMDYak4beu+wYyQ==
X-Received: by 2002:a05:690c:6612:b0:65f:dfd9:b672 with SMTP id 00721157ae682-6e24754aecemr86084037b3.11.1727690697135;
        Mon, 30 Sep 2024 03:04:57 -0700 (PDT)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e245308923sm13145267b3.34.2024.09.30.03.04.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 03:04:56 -0700 (PDT)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6db836c6bd7so38928507b3.3;
        Mon, 30 Sep 2024 03:04:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW31Bu8wEJt2KmMUCj5FEduwZMahZwKdFnPq18NqiMNG//QNQ4z3tygEq2hQA6Lm2Cb2gMT0uoh6rXpFDGPMA==@vger.kernel.org, AJvYcCXg9xyzOt+4J8UPtT2Bc1VCK0cBYXLxha1JHg/M1pGVRwEqlqjMh6zTni4nfprAu7fZYifx90i454qKRwrI@vger.kernel.org
X-Received: by 2002:a05:690c:6612:b0:65f:dfd9:b672 with SMTP id
 00721157ae682-6e24754aecemr86083517b3.11.1727690695768; Mon, 30 Sep 2024
 03:04:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930003902.4127294-1-linux@roeck-us.net>
In-Reply-To: <20240930003902.4127294-1-linux@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Sep 2024 12:04:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWcPpBgsK0r0U=k8NyjTjUTwBTLe6Bg_ORD2zmSNoRgJA@mail.gmail.com>
Message-ID: <CAMuHMdWcPpBgsK0r0U=k8NyjTjUTwBTLe6Bg_ORD2zmSNoRgJA@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: rename version -> bversion for big endian builds
To: Guenter Roeck <linux@roeck-us.net>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2024 at 2:39=E2=80=AFAM Guenter Roeck <linux@roeck-us.net> =
wrote:
> Builds on big endian systems fail as follows.
>
> fs/bcachefs/bkey.h: In function 'bch2_bkey_format_add_key':
> fs/bcachefs/bkey.h:557:41: error:
>         'const struct bkey' has no member named 'bversion'
>
> The original commit only renamed the variable for little endian builds.
> Rename it for big endian builds as well to fix the problem.
>
> Fixes: cf49f8a8c277 ("bcachefs: rename version -> bversion")

Which is (again) not found on any mailing list, and has never been in
linux-next before it hit upstream...

> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -223,7 +223,7 @@ struct bkey {
>  #elif __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
>         struct bpos     p;
>         __u32           size;           /* extent size, in sectors */
> -       struct bversion version;
> +       struct bversion bversion;
>
>         __u8            pad[1];
>  #endif

BTW, how does this work when accessing a non-native file system?
Didn't we stop doing bi-endian file systems in v2.1.10, when ext2 was
converted from a bi-endian to a little-endian file system?

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
