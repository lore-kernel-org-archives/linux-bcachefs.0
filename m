Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74EF4ED
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 02:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724466323; cv=none; b=lMBW1tcOv73jLFJfwM2nHrcoQ5YwksNilPoB6h2OIs/SDYEYBdpfK7DP2n1RV9Y31KjPyNRRDC6HLES/qywdcLImi4LX+ueTRwfH9HIY5HWnKK5oSqPdgdhG/hhn2HGtw4syCzHJ/oS1iBuIrEqjCF6idpiHV34fyx8Y151Uml8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724466323; c=relaxed/simple;
	bh=Qqf15j6v2yiLLe8CF3OCSjA/vKpAkg09Fp7KgnUeagw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LnoWU0Mdh/ryKCnMIpCBC6vOF8KMC3BWSKzRe4XBpvoF86vW1Dfhjqkyt3pCtLb9he6DZt+NswwERmPxU+C+aqUicRWYFd/pLhrEA1qNO6XByayAlIlMvMkLbp+UbVLr2iApUbeSeJ11y+jM8zjC571D8TszEhLTiZgl1mB8cUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwL2qKBU; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwL2qKBU"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a86acbaddb4so123892466b.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724466320; x=1725071120; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2xKPzNyZISPiEHK/cpzIhG4H3Lo5I0AHNFIjgfYtaa8=;
        b=YwL2qKBUS/r0SNnrw7mB1sx0+KXpvOHNmsKeM/YQpjspukQlK5OPy6fey2wtH75G7o
         HVgb2GTQ4UbICMTLrgAugiDZp3P7KtLTMrg+k8tGbzpFghJ9o0I7E88pV/JwMSDNkLm7
         okK21cPYeqmfUptWTPIJ1/O8YWU3k6GXW/POU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724466320; x=1725071120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2xKPzNyZISPiEHK/cpzIhG4H3Lo5I0AHNFIjgfYtaa8=;
        b=DKwsDbuSy6RllwvKoi5+v0HojXOSAUR2R59ZU0JZin1mXwVQGIo89mOCBQYUTlJNLo
         4pwW5T/o0csUyY9SUvu0WZ1eo2aGSxgm2DL6nwAfDhRl3/ZhT08j21DulG+Fr0gcT1FF
         6l8dhVgUgPHLnOcfh0BV/9MwyyxBrQaTXa/N0hmt8q/wWyJmCRgP6gbtnze7v8DUPz/h
         W7dXxyD/fmvwqRrEGP8GMCsRuYcYpwzWw+aOA843v9JWQzNNwHiAETnbsotSt3ue7VO4
         q8woTWqQT3/R0nkeS0P+FeCxnVyEMN8CieI91w2TGPuHYkc60FPXpSBembp5R/Wec5yb
         kncQ==
X-Gm-Message-State: AOJu0YxeKbjWCYCl4dd2Wm5bpCyJGGiMgn3fukQOlC55VXtVtLwAL8To
	t8nS4PEZQe3UQ3pouYljr0nrT3ZB0EjKBV+SFIr4PrEMfpdcIzT5OzjeE7js6m6tbZdgiJdvF20
	xl9GnAQ==
X-Google-Smtp-Source: AGHT+IEa/wRLw3txBMH6YS+ssc1473SdmqdvYEwIJzt+V2UudwACHECvuJc+MjUXBifHatBfqCx8/Q==
X-Received: by 2002:a17:907:d89:b0:a80:7ce0:8b2a with SMTP id a640c23a62f3a-a86a52b6a3amr209640366b.19.1724466319441;
        Fri, 23 Aug 2024 19:25:19 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f4ebdc6sm337759666b.188.2024.08.23.19.25.18
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 19:25:18 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bed83487aeso2874268a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 19:25:18 -0700 (PDT)
X-Received: by 2002:a05:6402:43cc:b0:5bf:8f3:7869 with SMTP id
 4fb4d7f45d1cf-5c0891791e4mr2666131a12.21.1724466318472; Fri, 23 Aug 2024
 19:25:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
 <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com> <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
In-Reply-To: <kj5vcqbx5ztolv5y3g4csc6te4qmi7y7kmqfora2sxbobnrbrm@rcuffqncku74>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Aug 2024 10:25:02 +0800
X-Gmail-Original-Message-ID: <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com>
Message-ID: <CAHk-=wjuLtz5F12hgCb1Yp1OVr4Bbo481m-k3YhheHWJQLpA0g@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Aug 2024 at 10:14, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Sat, Aug 24, 2024 at 09:23:00AM GMT, Linus Torvalds wrote:
> > On Sat, 24 Aug 2024 at 02:54, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > Hi Linus, big one this time...
> >
> > Yeah, no, enough is enough. The last pull was already big.
> >
> > This is too big, it touches non-bcachefs stuff, and it's not even
> > remotely some kind of regression.
> >
> > At some point "fix something" just turns into development, and this is
> > that point.
> >
> > Nobody sane uses bcachefs and expects it to be stable, so every single
> > user is an experimental site.
>
> Eh?
>
> Universal consensus has been that bcachefs is _definitely_ more
> trustworthy than brtfs,

I'll believe that when there are major distros that use it and you
have lots of varied use.

But it doesn't even change the issue: you aren't fixing a regression,
you are doing new development to fix some old probl;em, and now you
are literally editing non-bcachefs files too.

Enough is enough.

                   Linus
