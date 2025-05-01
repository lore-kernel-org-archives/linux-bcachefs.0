Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249481EEA28
	for <linux-bcachefs@vger.kernel.org>; Thu,  1 May 2025 03:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746069163; cv=none; b=lBNj5UyrORrUYJiv9Q/2VahisYxOrZn7//+sHAG2KA4gC8DBpWGbac2bQjs8fpk074ysPNHu0T5mkqGcoJDAkBj456d1tM1WIUz0ttn/jXlI3YGfvtDKe2M/S92Ua/BRE+AFbJDEKdTld5xWKrKOl12rJaXJ3xmkgKSCqq+BdhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746069163; c=relaxed/simple;
	bh=3Qs+LMUQu4ZZ9m3bGStlH/F2gPjLzRKPh3ITFdqZ4EU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqftmgZjF/gLP+Mf0XmijRwWw9B1ij1sFnIgy8TiQri8qzJms9nmaHd/lpCXbYmVAHiIVGjrVERnLsIF6WkIM/2RIZm9UGIqb9cj7mWWFmX/qt093hLWidFGPT5+CsxJF3nuOSOUeRiggVjxV9FWotcoC8j3x49XIRp7PGIAvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JB+kOAwP; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JB+kOAwP"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5f6214f189bso1020172a12.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 20:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1746069159; x=1746673959; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OC1oQVKn70KzlSasLkTsE0MQR+OTmhnwfBz3Xe1R3C4=;
        b=JB+kOAwPDAKGzyPwVTQShbQfE8XqYM7PYy7O/m66J6KzjjK2/hXtupvmny5oyjqHHT
         uxm3vhmVpfZXZduvvAhOLv0FXEiIxNetwvRikaxB+lCHUTg5qWnX2BF6KuULw77567dP
         qGrlidxQRMo9PBy+fhljulSyqXlF1+2sdnKbQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746069159; x=1746673959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OC1oQVKn70KzlSasLkTsE0MQR+OTmhnwfBz3Xe1R3C4=;
        b=nZOEvzhosjSa11l6Y929QrnO3goMgPJgEhoivotGW0/JS6IAq8OG3E+BC2YBppVVi7
         OOeZyYkz8FhxQ0RAg6YvO9LCJDPttDKjmbDPYD5Y5FeGirlho9qWTQJA3KbVvcCmB71r
         88Wc+unmN6wjkEahy1+p2U0JctyRE97WGkjnDX6lK1SKlWjsNSeKEFXqAKYuRtXl0QMd
         pkVHRqC9enamlzfyanCYqX9Z8LqYN8v0CnE7YAlXd6MUiex7EO9OCZUwDFELf7kO/IkE
         IViewEl9Vbbrihwqbey9YQTvj3F4trRIE9xoJ1ZBgt2wIf035NgpzqhCsA39iZG+RYc1
         q+Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUMa5OhfWVJ3YF2kInoysNTbCf75XF101t6/wQjEnuBSX9hadfZZwc5NVomL9r3B5moE//WfuMVXSZd5REovQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjZ4W/jABic2ExzuHcZZcOiT/WLr8zCno1Sh0en8x3z7O8w/BM
	oxJ/lhM/wenwHQ43jFaedDRxvfg7mw2Hf+7qrqbSx7RNap1PPx0Bx2Ip7d9MPaVtVpJyACGXoLc
	Hhww=
X-Gm-Gg: ASbGncuIcUdBxUwBjaDYerYS/NSqr7PoXuNPOvO+6TqXfLFhqDVBLBcgDL3/nipR4ID
	GQiTsvShvUduUsYXyg4LNUPuSOiL/+rmqlUERFOfl4q0kmp0uz4VjaAu5NDHnpX6OIu8Uuv+vPJ
	wpeBS4T/ZMPIPTajjlxS+9vEherqFNKYj++yjGDKL6vgR3k6d6wzE4bYeZsr4/QpGzGVu1375Q/
	pPVyrT3EqmXIHz70/qVjeuCoC3WKqU4gqtHhhTmSA7girxwOmBHxj9vixQCfawq5HwL87Kxbwrt
	w3KI9U0XL1++cjxTqcplGS7d4PJi+PVKmSFB8xar8xo0IyOenzI4asZ8BSA5HPazNOWUx/aBSGS
	FgIZoHOICLDT7h7E=
X-Google-Smtp-Source: AGHT+IFijBhNFCoSNyTfDl4Jg+LyRdCMNU2k4jt79epmaLP7XtaDQeYnfepaDRCIgktzVwmcRQz9xw==
X-Received: by 2002:a17:907:6093:b0:ac2:2ba5:5471 with SMTP id a640c23a62f3a-aceff41b0ebmr69275066b.24.1746069159069;
        Wed, 30 Apr 2025 20:12:39 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f5db6sm9665871a12.44.2025.04.30.20.12.37
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:12:37 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so96582066b.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 20:12:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUEaEs9zOg1/CdE5v1L6jKmOkYUN2XsNzBudbB0XlBucyTyRoUQ4EOjqHWwfaCh4hPjA52tI9vweQCc5uk1nQ==@vger.kernel.org
X-Received: by 2002:a17:907:968a:b0:ace:d650:853e with SMTP id
 a640c23a62f3a-aceff41a4d7mr74472666b.15.1746069156852; Wed, 30 Apr 2025
 20:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <20250425195910.GA1018738@mit.edu> <d87f7b76-8a53-4023-81e2-5d257c90acc2@zytor.com>
In-Reply-To: <d87f7b76-8a53-4023-81e2-5d257c90acc2@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Apr 2025 20:12:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgwuu5Yp0Y-t_U6MoeKmDbJ-Y+0e+MoQi7pkGw2Eu9BzQ@mail.gmail.com>
X-Gm-Features: ATxdqUHanefpUI8GyxvaKB734S5zjy2OepCny55RpmWEo-qYF6q5WHIuuXBquxk
Message-ID: <CAHk-=wgwuu5Yp0Y-t_U6MoeKmDbJ-Y+0e+MoQi7pkGw2Eu9BzQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Apr 2025 at 19:48, H. Peter Anvin <hpa@zytor.com> wrote:
>
> It is worth noting that Microsoft has basically declared their
> "recommended" case folding (upcase) table to be permanently frozen (for
> new filesystem instances in the case where they use an on-disk
> translation table created at format time.)  As far as I know they have
> never supported anything other than 1:1 conversion of BMP code points,
> nor normalization.

So no crazy '=C3=9F' matches 'ss' kind of thing? (And yes, afaik that's
technically wrong even in German, but afaik at least sorts the same in
some locales).

Because yes, if MS basically does a 1:1 unicode translation with a
fixed table, that is not only "simpler", I think it's what we should
strive for.

Because I think the *only* valid reason for case insensitive
filesystems is "backwards compatibility", and given that, it's
_particularly_ stupid to then do anything more complicated and broken
than the thing you're trying to be compatible with.

I hope to everything holy that nobody ever wants to be compatible with
the absolute garbage that is the OSX HFS model.

Because the whole "let's actively corrupt names into something that is
almost, but not exactly, NFD" stuff is just some next-level evil
stuff.

            Linus
