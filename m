Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2389148FF9;
	Mon, 21 Oct 2024 06:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490659; cv=none; b=oAfEPmY/rr9M1tJaGQMzOBJySe5pHJkiR+Q3Sa/tQXcZIozYC/+hhgL9O1KfncQEnHYyH523ipBfscSar0YuMBscwdyEzKjQmEjLA4Gr96SSJvkLuUD9ct7nhmcJuGJuVXmAtZ7zIxoW3jcnrUl0Jua2nTNe/CLqC/74cYeSOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490659; c=relaxed/simple;
	bh=2fsWYvEi0IK73sUTq74gKefon2ZTtdpF9s5+XTn6UtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ub4LaHjd5udBayINQ4EexrnXUkt8pDSPJT8qELDxVENkrUcPKj+lXvP0ddLDYkCSfhtYXmAyRqXmwDJiCf3g1Yt6tXuuaOg03sPW+ybea6hmleY4riYSYqr17meR8Uscphcb9yYNKgQhf3OcfbEv//iTpdhbgfQ8x7Nm81cagkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bw3CfYMO; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bw3CfYMO"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e2b720a0bbso840068a91.1;
        Sun, 20 Oct 2024 23:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729490657; x=1730095457; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pg0JsnBu9cMvcgcmJc1G+uprIvIAEsIzBiz3R+FFLKw=;
        b=bw3CfYMOnrcFF5cjS4i+Qh2P2w3wlxGCoaTu9xHYeHx2GiqGgxg8i7Nh9kJk/JdjLB
         LHBHWbm70xL4nnx4crrVUPBCJvmH1pWT9j08BN46hfmpC+9hyU/ChwaVTBEbQzqWdDnK
         fleNQ4nmfinUSYHs6PW7jJMvxVC3HFWNqFwld2wMQVMEjKWM6/W0/US2kW7UUifW7HGK
         6FJsXinIr3f6J01uusQUSz2wed6D9pU+zeCLtHnH4HWDKCK/rzm6EWBZneqBlv8YOdd1
         ZeyBwe3wJltRcSmLUyDSrKA8By+9VJozK9aRsHWOAill6zLuKLSCkdJinb8HTpYQMnXR
         /Aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729490657; x=1730095457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pg0JsnBu9cMvcgcmJc1G+uprIvIAEsIzBiz3R+FFLKw=;
        b=g5WyX2sNWAaRs0VZBJSH9kpJq4y4BEgWtuQ8nMF0mH//pMdKhYgYx445eJ9svRG3KP
         NVveTfjEF5weLHR2geLWw+LJ9b9Q5uhrsgOv0un5dJeHERHTC/yAd/Yl8EY+HJFXVusz
         ms2dFZPq9tUXcZgHn4SY6oTNF/DxnpfdkpvdnNwMQpRaHMav7r8s1QTxKheEgwnoP3Lc
         D0X7Hn8rZv8CQdQ4hzWV7jIrklVAKgN12m0W91qZF3cbiBNf/xAKW4TkMcA6xfW6mo+f
         NHwjfnzZ/dHZlG3bFePbDeQ1nWi0vc74y1hDUDE5ab4u7kMRpISwGDKsXfsLsF4snZdP
         nExw==
X-Forwarded-Encrypted: i=1; AJvYcCUXnVaR+beYOKHZw/YCMN2qVqhA0T4Lkcc7fTF5plf3Twl0bLXMu/mwVeOeP23oO5wnooVH4Kv+yLJW0slB3A==@vger.kernel.org, AJvYcCV6uAKwXLef0qT3MfH5isB04aVzEc7OovDveHuo0UCxpbrYvFhsiwKmhTdTTRoOjlmBOFJlBGbNZZd4QVj5@vger.kernel.org, AJvYcCWaPVqNhXJMZinNEQdabn7iVA/83/N062Vysy9mNlo2Yp1SMAjGtqponDu0n6wQssQ6cPPKkdmtyQ5CV7eCcROG@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr47xcTFH/TIhxJJ8Q7/muYtUOQbAB1v5blAPDzD+qOd0IF8tI
	v6YbhD/JQSfvv0XS9hEJOX/WcUYqGMRm6abr3vHG9Qe7Pk6BpNczvBegfTtsp3Ui8akSCNI4kyW
	YYKo4EnJPyZMQPfFr3CK4eHoSmyQ=
X-Google-Smtp-Source: AGHT+IFTn6AyaH521mGGVsrVLQ1r+PtN4Lem3tmtd4HDqCECIc/0C2xjgjebgZGML6ZwL4dc7ldcwVwVP3BNKEybmnw=
X-Received: by 2002:a17:902:d4c9:b0:20c:959e:f706 with SMTP id
 d9443c01a7336-20e5a76117dmr62142145ad.1.1729490656749; Sun, 20 Oct 2024
 23:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux> <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux> <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux> <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X> <ZxWvcAPHPaRxp9UE@archlinux>
In-Reply-To: <ZxWvcAPHPaRxp9UE@archlinux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 21 Oct 2024 08:04:03 +0200
Message-ID: <CANiq72=yYDcG=ef9TxCCECwjSgW-5zFoTJqcjrWGOALCvaW0SA@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Nathan Chancellor <nathan@kernel.org>, Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org, ojeda@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 3:33=E2=80=AFAM Jan Hendrik Farr <kernel@jfarr.cc> =
wrote:
>
> I think I prefer
>
>         depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)
>
> to make it more clear that the purpose is to disable this for clang
> versions below 19.1.3, but keep it enabled for every other compiler
> including pre-release gcc versions that pass the compile test.

Do we want other tooling to see the attribute? i.e. if the build check
gets removed, then that `depends on` would mean other tooling would
see it, right?

> Also after gcc 15 is released I don't think a version check for gcc
> should be necessary. I only see an explicit version check as required
> when we know a certain version is broken. Otherwise I would prefer using
> the build test.

Yeah, build tests are nice, although they require spawning a process
and so on, which (as far as I understand) we try to minimize. Version
checks also have the advantage that it is easy to remember/check when
we can remove the checks themselves when we upgrade the minimum
versions.

> I guess an alternative would be to just create a
> CC_COUNTED_BY_BROKEN that is enabled for clang versions below 19.1.3
> and continue to use __has_attribute together with that option. That
> would make the build test unnecesarry. The downside is that it
> will require checking both __has_attribute and
> CONFIG_CC_COUNTED_BY_BROKEN for __counted_by support. So I think
> CC_HAS_COUNTED_BY is better.

Yeah, if we are going to need a new Kconfig symbol anyway, then let's
make that the only thing to check. Otherwise we are in the "worst of
both worlds", I would say.

> I'll submit it once Bill's fix is in the release/19.x branch. Which
> maintainer should I address this too? You (Nathan), Miguel, Kees, or
> someone else?

Sounds good -- if you want, you can send it to all of us and we can
figure that out later.

Thanks!

Cheers,
Miguel
