Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70681DF991;
	Thu, 17 Oct 2024 17:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729186799; cv=none; b=CN3LfGuhFiTSOZKhq5U9C7mbaBzb9ADjEhAOOm83X2NyVZYWmaKe6JRj5AIRngBsqFqNnYRgrRX4oDnM2etT5W8UESImG4sPSxQyvm7nxbodWwVsJBbJd2+Md1GgwPvryKUctBv08+PIY+D9J7G2M7dMI7ADyVGESg8qujsznGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729186799; c=relaxed/simple;
	bh=XNhYFcnBb2qAtLDWT7ob6Tja21YLROu8fBAm57b1QQM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nrjE6iUN9gGBlQL6N7HpzWt9u+3SN3OEVWv0XvDHkpPmU5tHCUuXCaqebF6SiEol8KzdjgCgfceet2FL3Mf27gz+rSqVY4JzNyfiVlQYsR4wSYqdUk9nwExkSNYJfdzyREHAYcGDMt7/IqTmgIn2UhEoErHoINFzYDikyJ2P80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDuQEAAg; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDuQEAAg"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2da8529e1so185980a91.1;
        Thu, 17 Oct 2024 10:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729186797; x=1729791597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DVbAzyc9I6m3RIJUQ1MXWzv3RJTPsyczSm1xKWtX5dw=;
        b=MDuQEAAgfyDkC2YOc+Fi0cXVxZ3vG8Qye3uL0KFNtl5HBkE7vACZTRCpV+SmtYU3bN
         39yZH+1MNxb2dQxwQOjtCgJ/EJCvxGJnLx+mVh/f8gI8EipBWwoRiDt2aPt+0r1OfmSS
         grFJ2JVQOVBQvPhCUwKJOrU0FVaKXL0ieBQB6uPrMLMwbot2EVIWJFs6NgfBKUCp8JaH
         l8CwB6WHOdCDarVMQesT95ekneb00F39O+hT/xG1Le30PWy0u7FU7Ml1+OILpHgbl6t1
         gtoxi73hVbgTXMPpoxHNE7t7+MkKJgViNt0hAaFHqIrr9P0Vq98VUcIzqLOZbQ/FfmnA
         rV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729186797; x=1729791597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DVbAzyc9I6m3RIJUQ1MXWzv3RJTPsyczSm1xKWtX5dw=;
        b=UaaOShfeYGPdTnBx6cYeHkrzmuaRiermaVqcpnd7t1yHPu55Gyqq81Ft4fi2gP6KVd
         Z1kKrnlQluRhlVbpeNtt4A7XnTeFGECJgONUe0p/2zasvrNT33ErTcGeJn6ryjXUf0kb
         OhWI0/m60LM2d8JRt19IqEiQs7zBcuwAWu1jwPplmJ9f19VvMX/KMLYqxeA88JhqvHsA
         AzOACIE5SC0Z1qrl4XaLYVUGRs5WxpfE84gtWXu+TPYoJa7L6UmZ0CiC2fOC2nv3VDTE
         oKoeoiNTOT+sodSBk0SiJWSLwwgLfxYaqv2LcgAgDVsC217fLa/U/WsgXPNBQb8+NbaA
         wZnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaU+PYY1exmNnqjyZwxWZ+SSYdjWWZrUhWA78a6qeRe4ATopxfq1Uv/IRpA3pREov6I7+fKYQ5VCishng2rA==@vger.kernel.org, AJvYcCV6uVyTagIrexJILOo+lU73A7ZITaBMbhcfxLB1m6zwQj8xQ4xyvKTFfasvON8q6lDrEpp+6pjNQT/IVATE@vger.kernel.org, AJvYcCW0FP7sfvVXO7EqkPH+HNGfPaEERzNFHpPDfuHrjKjfs9qdCiY3aXsFyBIB4F4JuVAYWEOs8ro1MTrZN9Ym5p+I@vger.kernel.org
X-Gm-Message-State: AOJu0YwIN7AfRfZ2ANA1o8p3V28KmqHfZcTVeGsxzYabrtXFpNhdNQT5
	+R2WDBNUBJ9Rl6NK/GAQlv4/BfK6DB3A2A/U9wV7CvgKt7XEdwdopxcVyxfbIZKCTc6Zerum5F/
	Xp6oZNE8JlA7TXUh5mwGaPlk7i3s=
X-Google-Smtp-Source: AGHT+IFKzPCfniyRQAO3KPKy/OOw3FuLREb1jofve8Ca+H1mRB5ShgyM2jfaUY0+oY9BlPJVrOG307sYawNQmU4mkPo=
X-Received: by 2002:a17:90b:784:b0:2e2:da69:e3fa with SMTP id
 98e67ed59e1d1-2e3dc135040mr2166896a91.2.1729186797074; Thu, 17 Oct 2024
 10:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zv6BEO-1Y0oJ3krr@archlinux> <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux> <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux> <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux> <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X>
In-Reply-To: <20241017165522.GA370674@thelio-3990X>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 17 Oct 2024 19:39:43 +0200
Message-ID: <CANiq72=cUS4GRzuU0WAWn9owttU-L4UpV1Dip6QjUdudCoT8VA@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org, ojeda@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 6:55=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Should this include a Fixes tag to give the stable folks a hint about
> how far back this should go? Maybe
>
> Fixes: c8248faf3ca2 ("Compiler Attributes: counted_by: Adjust name and id=
entifier expansion")

Yeah, I am not sure -- it does not really fix that commit, but if it
helps the stable team...

> compiler_attributes.h is intended to be free from compiler and version
> checks, so adding a version check means that __counted_by() needs to be

Yeah, ideally we should avoid that since the goal was to have a file
with the straightforward ones.

Though if we do go for `CC_HAS_*`, I guess it would be simple enough
too, i.e. similar to `has_attribute` (but on our side), but it also
loses the simplicity of knowing those do not have arbitrarily complex
conditions which `CC_HAS_*` could hide.

> moved into compiler_types.h. This might be a good opportunity to
> introduce something like CC_HAS_COUNTED_BY in Kconfig, so that we can
> keep the checks unified (since there are already multiple places that
> want to know about __counted_by support for the sake of testing) and
> adjust versions like this easily in the future if something else comes
> up, especially since __counted_by() is not available in a released GCC
> version yet.

Sounds good to me (even if we did the unification somewhere else).
Using `CLANG_VERSION` looks better too.

> +config CC_HAS_COUNTED_BY
> +       def_bool $(success,echo 'struct flex { int count; int array[] __a=
ttribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -=
o /dev/null -Werror)

I am probably missing some context, but what is the reason for the
build test? i.e. is there a reason we cannot test the GCC version too?
If the reason it is that it is not released, should we change it
later?

Thanks! (and for the Cc).

Cheers,
Miguel
