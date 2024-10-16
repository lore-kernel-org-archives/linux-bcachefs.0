Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE28660B8A
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729041791; cv=none; b=WFo0svWsMW2heRzD9vWNZrTPeT6U0wsg5mB2Oejg9BeTVvLozV/1ojgsnT1p+M4OPxWlIAnL3JHnl8TrPTY/Jcu9qVrvXKXnVx7dBxhGhiXie8w3jpvs0orITfymduWMu1c2q0unPjtubRKHDIgDfAqhCBNzhFdbO3eB0uIhRkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729041791; c=relaxed/simple;
	bh=aKMOa2lsMcZ+PzeFhDC9/s5MDDTvDylmgOWrFIZX/mc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cG1mBCEsjLD0P/YDp5zyhebXmZcCLXqpSUAcXR7tYT2VoS2TMBHIhL2XQse9TmE80GK9wito37/USKsaQp/f9+kfbbIJ56JCP4jFhLoiJLZb6NLM9ipiedOMReR7Beflss5KNJPn/NmsopglyfYOlSlNZWFkBk/GvkuQ/uD6QOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MSFTIpZb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSFTIpZb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a99ffeea60bso468046066b.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Oct 2024 18:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729041788; x=1729646588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKMOa2lsMcZ+PzeFhDC9/s5MDDTvDylmgOWrFIZX/mc=;
        b=MSFTIpZb2HNKhOW7IY+Mal7DtWGSFphZFEbUqc8O1ALbn6XUbKAmQrLfKAoJJJZXcR
         HHjkfXpHK1dW75rtDd8OPNZO6kWdq8pDpzk0Yu3GXFly7jt/9XofjP6p5amIgYacnGsr
         OYN/egF9ZoFKOXijHxyDIOw29I637Bmi14/UjGb1YpKNhbrjiP24/NGkU54xqSZ9w+ai
         hS050iPK5X3ecAhWmeJJBjMRo5AG4McD/4et3ITfOFlwYsfajoNf9Z5A0cOBdI/JzM0x
         bgG7Yfn37NkMEv4OTyZCuPOuLjyxh23sUJKFfqOpAo8yxkmCMP5nQ+bEOJyM0h4FvzT1
         X7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729041788; x=1729646588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKMOa2lsMcZ+PzeFhDC9/s5MDDTvDylmgOWrFIZX/mc=;
        b=X8RM0aIA1325SlZasqRb+zgdOainw+9NmrMoB/2h9lH82oxI5V+BqxRHsJJu9JCClt
         y+hbXPZPn0HhZF2cVg3HZIn0GJ+1w1yMCKJKgEiEzSw90M53Ca7NLq+1z5yLL5SdidoX
         WMm15kpelpKUSrA4phkATcnSRsUm+Sit3VpeMgjZXC6SsdXQPFN+Q0bdSonrsNlTgW1q
         kVzqJY8eym+D1t7D/7w/ujfO4C/WQLx72V9DuTr3o8C3BXEBUac7NoRnPz9CnGv1ogUS
         VxsM3zW6jztnDAi+pwKFfT6EIsqpD3JKgaToKV0LzY7/jHk844Gd0hXxHX/bg+x9+mVS
         HW/A==
X-Forwarded-Encrypted: i=1; AJvYcCXcehrVEwMa3PYlPDkmxJvaA8XRZXb8MzJMak2jugXHi4Swn7aUKeYxK0IP9S8ufdQgeiqh93hBWwmRz9bR1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqqPZZc4Olw4RRsA6xdGmQvCXE9fi8H0vbo6SRysqFMKF1/JU6
	5PhXTc1SjX89Z7f69smMgkPrnGMkgOmgM6oqPt894aOI+MQkxGdFNMoxRF9NsqvfiZtGZus6FpA
	zscAznXnY/NrXlGT0xtAeXE2I+lTOizRHBk4=
X-Google-Smtp-Source: AGHT+IHdkfklJ4F1OwuM1/1DqBmbkhdk3WE3vsIugWlT33b5VzThcJq7LfO9xnbbLXiMKZS361OAmCHXw1jqbZb5Hjo=
X-Received: by 2002:a17:907:9709:b0:a9a:4d1:460 with SMTP id
 a640c23a62f3a-a9a04d10662mr910288566b.63.1729041788043; Tue, 15 Oct 2024
 18:23:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZvV6X5FPBBW7CO1f@archlinux> <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com> <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook> <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
In-Reply-To: <Zv6BEO-1Y0oJ3krr@archlinux>
From: Bill Wendling <morbo@google.com>
Date: Tue, 15 Oct 2024 18:22:50 -0700
Message-ID: <CAGG=3QVecaZfoRrjToToq8=Azh8M0vQ5Q=V8dfhdBnDR8GWy5A@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 3, 2024 at 4:33=E2=80=AFAM Jan Hendrik Farr <kernel@jfarr.cc> w=
rote:
> On 02 11:18:57, Thorsten Blum wrote:
> > On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > > [...]
> > >
> > > Sorry, I've been out of commission with covid. Globally disabling thi=
s
> > > macro for clang is not the right solution (way too big a hammer).
> > >
> > > Until Bill has a fix, we can revert commit
> > > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited t=
o
> > > certain situations where 'counted_by' is in use.
> >
> > I already encountered two other related __counted_by() issues [1][2]
> > that are now being reverted. Would it be an option to disable it
> > globally, but only for Clang < v19 (where it looks like it'll be fixed)=
?
> >
> > Otherwise adding __counted_by() might be a slippery slope for a long
> > time and the edge cases don't seem to be that rare anymore.
> >
> > Thanks,
> > Thorsten
> >
> > [1] https://lore.kernel.org/all/20240909162725.1805-2-thorsten.blum@tob=
lux.com/
> > [2] https://lore.kernel.org/all/20240923213809.235128-2-thorsten.blum@l=
inux.dev/
>
> This issue is now fixed on the llvm main branch:
> https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf7=
69fc9a93e8a
>
> So presumably this will go into 19.1.2, not sure what this means for
> distros that ship clang 18. Will they have to be notified to backport
> this?
>
FYI, Clang 19.1.2 shipped with your fix in it.

-bw
