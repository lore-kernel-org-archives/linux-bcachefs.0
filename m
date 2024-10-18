Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABADD6FB6;
	Fri, 18 Oct 2024 11:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729252343; cv=none; b=rrgkUquVLmHxQ724QF1erh2aTOeg8vpoAfF7qisqQo6h4e9NNOyqaXCmEFFXTG6wUSyp8pN4/ZvZqIvvbDDDj3iUdf+/XsWY0xZASPn4FrImG91frcB1nNhwR2KFI5thaezL+8COFwafSQ7bwzy4bo0yO6uusPZG4FZ9fYGEhi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729252343; c=relaxed/simple;
	bh=iNV1Toc7MSk4oGsveAP0All7CMv4VkQA5da0clNa6u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmpOhEcR3ETehZcj/uy8bg6ALiQadnfL84Whpfh8HNfcBBK+bLAtIXS3Oe5B1Te+qCS2RPqbDW3jPD8X5lmzmeZ++rfKuHyaDz5ecoxDyqRmwSjt9dy6ZXvtSUxLCMDV+CFVNcfVUeoH7SK+3iKCd3HFUtrXQdzpKuTefvrZpcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRrnpQ+O; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRrnpQ+O"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e2af4dca5cso358628a91.3;
        Fri, 18 Oct 2024 04:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729252341; x=1729857141; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iNV1Toc7MSk4oGsveAP0All7CMv4VkQA5da0clNa6u4=;
        b=eRrnpQ+OwmQYWkHl0tiYF37Qo5NAtCPUY4nDg1j4OGhHe7xOSXc3wxGxMfYog/r4rL
         0Q8I1nI+q4l/SugtQJ6o6dApdOjOklBgFCpfYhATBINGMnPrEIJoXn9h8ZRpbXHpxsbY
         BMm7hYX6EbGwUpoxDcxA2DFhdDH1wxKnDlsK7s23KCvUV37Q8JhUkhUbpobDM9YvuF3N
         h5Kh62JBPI+SP+Wp1oDU5A0EchUXD2mnHmlI/N2Dg7QRtJP/Aarsq1MVXrMPaVVNu5xV
         McuvAkppcdSblBrcYNY7H3WOwx91KmaGhHhmWezcU2RVENWKg/z+/2tZON89G8UAMwE2
         yzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729252341; x=1729857141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iNV1Toc7MSk4oGsveAP0All7CMv4VkQA5da0clNa6u4=;
        b=qQ5U3rzLYvbEwcOA+MDi8pRPaAmQVGmX3W0xjBbOTM+MOgs02ZZqq8TNJFGQ1t17sy
         Hb7bXV3aVHeGTw7cZRt/R+/XCOZ1YepAifZ/c0m59A3LsvbpXtdHYB52W1O186BLhFFm
         PospV32lX6rXT2DIOumUQ80I8UqDwFPULXbGrK6d2i2sDciSHyZo6RTsVxDpQZPMLVia
         SfIAC2tsC10vhK7phbNhFWxy9JxcGq/ukCgS/pePdysZ9qV9Pc2DD5y/k6yc574z5kBP
         hN2l1Tdc2kP4/NyxK03pgeSEVsabk1/mQ7q0xHaSwOIcyRcfYSPm1p2uZiGPkDjG2sFx
         GGJA==
X-Forwarded-Encrypted: i=1; AJvYcCVu5Tv74+JOEshqGbed2/DjaNEEFOaPFa1QRu6lxICUYMAlOWlPnR3kYDZil9aSy++p1npOfF5XR94MkyHx@vger.kernel.org, AJvYcCW71uvnAQslKDkvQEGKUI1z3awh03EXVzxvZb02zZLNf60kPZNMXUMHTSZ/OaI93swcm6DgkmncMQ3V8tu9aHUL@vger.kernel.org, AJvYcCWfY552i5xM22eiHXFxJA7caqSNepbkb5Evnel3vtcXU+/yVjnEWhlv9MLKiQaK1E/Te31sylMm8aIFnVx9Cg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9QNXnxxTZwofhSkHRp33bByGTCJ3NTZCDzBfue+a8gB27o9sV
	526OZTeIw6VQaaqtpbYl+dNvMQTacQCvFoKbAv+olGBcrrNNMXVHha1G7szYHq3JTZr2Bs0tXis
	Q/sWOIVOKKORqPpNNbKkglRKO7sw=
X-Google-Smtp-Source: AGHT+IG0ZQWmOdahzal0xzYd7knbSdaQBL5DsAJHxmsUxXKZ2XhcWs8MdyWy6ihQNAZJrQ6QOwlll+4hdS5YoIiCx88=
X-Received: by 2002:a17:90b:1254:b0:2e2:d881:5936 with SMTP id
 98e67ed59e1d1-2e561a10f40mr1104905a91.7.1729252341015; Fri, 18 Oct 2024
 04:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Zv61dCaxScXuOjZg@archlinux> <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux> <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux> <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux> <20241017165522.GA370674@thelio-3990X>
 <CANiq72=cUS4GRzuU0WAWn9owttU-L4UpV1Dip6QjUdudCoT8VA@mail.gmail.com> <20241017185552.GA2263054@thelio-3990X>
In-Reply-To: <20241017185552.GA2263054@thelio-3990X>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 18 Oct 2024 13:52:08 +0200
Message-ID: <CANiq72=BRFHrNK54f3ydj7EPPnDGprzaBUhoB+bY_xO3tOPyOA@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>, Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>, 
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org, ojeda@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 8:55=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> The most "correct" Fixes tag would appear to be the one that first
> introduced __counted_by itself (dd06e72e68bc) but __counted_by can never
> be used at that original change because the test used __element_count__
> as the attribute name, which never shipped in any compiler. So I would
> argue that this change really does fix c8248faf3ca2 because that is the
> point in time that needs this fix.

That is fair, you are right.

> This is a good point, as technically to allow use of __counted_by with
> GCC with a version check, it would need to be 150000, which would
> potentially break GCC versions between the 15 version bump and landing
> __counted_by support without the feature check. We could also just do
> 150100 to be simple about it but I am not sure that is worth doing,
> since I believe it is important that we support using __counted_by with
> prerelease GCC. We want to make sure that this attribute gets decent
> testing coverage while in development.
>
> We could ship this with a comment to simplify the check when GCC 15.1.0
> is released, since this is a feature very unlikely to be backported to
> earlier GCC releases?

Thanks for the clear explanation! Yeah, if older not-yet-released GCC
15s are important for some people, then I think it is fair to have the
build test for the time being.

Cheers,
Miguel
