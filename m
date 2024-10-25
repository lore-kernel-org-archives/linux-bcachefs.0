Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADAF1C173D;
	Fri, 25 Oct 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729843853; cv=none; b=MFm0q+HyZ+s1y9iOKAZvwq7NjalQArFJ6KjU4rkPR8mJXygDRzFSjnmDlcKMqxeZHNuGggTVl+te4c7oP9yw1vMqHw2ZhZ5lsT5ViKjxcNa1MHQ+AvjXBnKmMZmymXymS3aoqnGSxjszum6uAY6XP5GRrpTqOsCEx9pHG+1xu30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729843853; c=relaxed/simple;
	bh=QxIPJtYLaqp7GcRN9wXG0w03pUAqJ2kV07BZzgdMuRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b71J9Au9shHQa8o03W0E84LY9cpKzGkyW4o2G1AvxHpDhUbqjzkp0n7mXKjW2TN+tZ2d8YYDqZnacNW8yCzRnRw+z5OiIzVRUPUeG5uOys3KxnqO4Z1WU0Lt5DqRad04WsOkGo1drDSDUSf9StZQ4WDC76snCQm2fOyEYxVM8DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VowyQzhF; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VowyQzhF"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e2af4dca5cso338277a91.3;
        Fri, 25 Oct 2024 01:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729843851; x=1730448651; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxIPJtYLaqp7GcRN9wXG0w03pUAqJ2kV07BZzgdMuRs=;
        b=VowyQzhF2j+56z0tr7JL9VYluXpqw3CbnPxN8AN0R/evMVNqqGPyazSn4VbQjRdNzD
         4TW5J0uX2cryJPXsk1QMGzk5I5Humwj7a5AVrYUPzqPLOpH0tz8MpnIcmrSU3UdeIwg4
         gPovTx4moBzGHIZjBEGdGXDOO2dmkW4ocX0eDnjk4kgGYCGVbWm1Yf0xs86yMoFg6VoP
         0L1ayIVhhlqqhj/N3e5uYDVPypl86xckYALNrkwnvqNOrAvSGQbrwppKXyIuSRAqMPy+
         Y/FQ7zr56mpTj7ROFJazLrlpU8HE1YTmdOxmYpq4UQqNGxcoGCubkFP7AOhIzho75IWF
         y7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729843851; x=1730448651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxIPJtYLaqp7GcRN9wXG0w03pUAqJ2kV07BZzgdMuRs=;
        b=gR0SwTuzn+GN9KZrTJfKtXYn46OvcNH3jt/E+kLmmbOQc8CPLHQq91kbPBoVkax7k2
         bzjUZ8PqC4EBS1svx3Q3fWPXx9vLNkNtKMG3bqpZjSsJMdqDlkOCo9j11dZVZw+C0nj3
         wcrCCpLRi4YACE6VX7D5RRS5Zo4j9IXtAMjG7uVxXSzP/j11ACfLlNJjyuF5hBE5IV2Q
         k7TZMwMx2BJ/yxaXzPPl43XZnz9Wi6I4FcRpbnFEldDljXnpTPXr9LrgO2sVyl/T7zwb
         nAcbttBsfAe0EksOCPGR9oPYKBMUQsd/tfyMzj/FC2/nhTT/Q57g1HvgdgLlHiVN/hVa
         ftRw==
X-Forwarded-Encrypted: i=1; AJvYcCUqM/5BnSOpF/mh42rlA93Zqc91lO0GTkKUXCCpdrktk/BjwS9Xg7kjUw2IAHOGZxshQwMdJ+6x+ao9+pD+rQ==@vger.kernel.org, AJvYcCVMFzl/pybyRSQfez3a16CGpgUzU3qIo2b+zUI0HrvUqaAs7MzL46QTwrc6/cJ+2xGM5XPdQQXesbkLKKpI@vger.kernel.org, AJvYcCW0dDbX5NRZnAfwi6VDAfNVjJ64R1qadQSdoMKItGcsWX1vl+eSdydPIlpsApBPWV4vLbVRDvANikZ+9JsThPrJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyZiwoF76gYROFyXIhddfTfrMqPSYvWPdrHGvrtWrzCNJyb/rsS
	3TgRzRNhJYN0Y+wRp4vMSZ/frueAvDlY5eiVoXsjMnmUHAt5cVlYsRrVwbuqm/GIZBhSmpVCKTq
	6sM8GkZAmgMSoEIV0eB7ViXXrQ5M=
X-Google-Smtp-Source: AGHT+IGPvqhUDFBkOrQZPHHnvPcIrx/rb8ZygTWHg/zDEP3AqX5dEQ8DbwE6syU+VnzrC/rKZmINXToaxuTbKVRq2qs=
X-Received: by 2002:a17:90b:4f47:b0:2e2:de92:2d52 with SMTP id
 98e67ed59e1d1-2e8e8239caamr324426a91.9.1729843851009; Fri, 25 Oct 2024
 01:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zv8RIs-htdc-PtXB@archlinux> <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux> <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux> <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux> <20241025011527.GA740745@thelio-3990X>
In-Reply-To: <20241025011527.GA740745@thelio-3990X>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 25 Oct 2024 10:10:38 +0200
Message-ID: <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org, ojeda@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2024 at 3:15=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> on the official submission.

Same -- please feel free to add:

Reviewed-by: Miguel Ojeda <ojeda@kernel.org>

One nit below that is fine either way:

> > +# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> > +# https://github.com/llvm/llvm-project/pull/110497
> > +# https://github.com/llvm/llvm-project/pull/112636
> > +# TODO: when gcc 15 is released remove the build test and add gcc vers=
ion check

I would perhaps move these closer to the respective lines they are
comment on (i.e. `depends on` and `def_bool`).

Thanks!

Cheers,
Miguel
