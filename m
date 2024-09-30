Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8F18CC0F;
	Mon, 30 Sep 2024 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727699050; cv=none; b=Tj0J9qGaWqouk1XONlImJiYzQTovEMUDbNzIob+CmvTJQk9dU1qu0fKrEqcugfVLgorO2mxq/rAUr5uDHoYA8L44i/C2UK/sRMyw6YNrbwiRIlZwl3Trh9dp9d46A3Ko7xi22eTD4AasUGipszv5NfmEhf7KY/6rsjbL4PyweIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727699050; c=relaxed/simple;
	bh=BvU70KRa57b9h2yEy4cMq4fjUU2H6/D0YN0W/tbSSoE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9GgOWnXO7qjN29WMbsgyfXJTuU5k1/s5psfH1eoDmewxXGjrblgalkv/fJhL3Fu//Lv7mRtohUklN7zHB1FYR8/S0RsgYcChtonk1LcSEObKI+oXxUxbGlyTcoMepm/0tMKCqAtc6UOyXPNfK7S57FRMbnNMpsZKWfgn8avFQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6dfff346a83so33653297b3.2;
        Mon, 30 Sep 2024 05:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727699047; x=1728303847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XVVEAdqwkf2SKZtGMgXXahxTvOnFGWg6xEOd3sY1anw=;
        b=CkmMbVhIa33DxVMxV9H2c4JkhiRv4rBPKfU5v5QTBpXkuHWJnvh8YTZhKH06f/kFyz
         0EBQH3opS24jGCeDETaoY6Hme9imhRQeKgKitsNY2l3pj7kB9I5UK88GBcfgAlk2EC4c
         +EQyID9xqiFki47V5FBN0CYw2IZPuHDpjReU6bP53NrawbOH64xztJ9zqtBj9hb92pQG
         OsnQUXghzDytfkXVJWGKGB20K+xKtXkKz8M2FxWFB9wHrrd4G2yG00h36lSefBXD/Twe
         tBWr5l13KlNtMR3CTSQHD8E5887ic7qI5MoVbfLgXCbt9n6PBWy141s2HNbtqxPOtFes
         ftqw==
X-Forwarded-Encrypted: i=1; AJvYcCVzg4RF3c73g4YvCrEaRe8BV+9Y6F+1rkOzXCvpsFMwE7CpKkW5Qh5jsyF3AHzAchcfP1tAznSwiGeKH0NTMw==@vger.kernel.org, AJvYcCXdNpjFntT+CtsL6/sn7WG49ntC+4BOIfPV76H160Zt8X2LuAOMMbENczwIk0ZHz8l69n3XKuf6kpQLwmqC@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4dB2vu0pcncy3ci8+Mq8yz9xA1GEKSQQuWKAbs/9lQghE+lFj
	wgu4Lb26jzPAqEUwiYLeT1NbCpAP0+pnwfLjaCXUDVGjq6HiCr/mp0oaEi2G
X-Google-Smtp-Source: AGHT+IHgKFzNCNm2Yj7USS1fkOyyZx61sgK8EE3LNkobej/itHB2WRssiJvVbs4OFOovorBGXC4Nfg==
X-Received: by 2002:a05:690c:2d8a:b0:6d3:cfaa:edca with SMTP id 00721157ae682-6e247551286mr60127787b3.15.1727699047433;
        Mon, 30 Sep 2024 05:24:07 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e245369535sm13419967b3.79.2024.09.30.05.24.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 05:24:07 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e02c4983bfaso3868683276.2;
        Mon, 30 Sep 2024 05:24:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVt2KpgBvT2LNLOHVzA77ihcyJAzi1Wc42qgC9aAISNm6PLYksrrA/LZAFEHLTc2F6SQOOhZVpxD0CnTLKb@vger.kernel.org, AJvYcCXwgfWvKbxwnOTjn5nwGLqCksWEH+ZuQolQoOPRDr6LuvsZ1eEn/amde15K9+uoZ5JfbYXloSwzl11Txd5/gA==@vger.kernel.org
X-Received: by 2002:a05:690c:7008:b0:6dd:b9a5:5a75 with SMTP id
 00721157ae682-6e2476108bfmr85800337b3.38.1727699046934; Mon, 30 Sep 2024
 05:24:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240930003902.4127294-1-linux@roeck-us.net>
In-Reply-To: <20240930003902.4127294-1-linux@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 30 Sep 2024 14:23:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXmjeHWM48U6X=oOo6eKg5i62GAP7FoFSMUwXgkPDk9iw@mail.gmail.com>
Message-ID: <CAMuHMdXmjeHWM48U6X=oOo6eKg5i62GAP7FoFSMUwXgkPDk9iw@mail.gmail.com>
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
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

As this fixes the build for me:
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

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
