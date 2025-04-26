Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B1B18DB0D
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 03:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745636670; cv=none; b=qSxzO0eIZcUdvibjodRPAcsO2cIAsUc1q+7v2DTRSxf5uIhrkjMh2yk12tFa7egm3ymZznx5tjCDBXT/dUvcli+su8lehSwT0xiA+mBmo5UP316tyDIUOWkhLkCiNx/wQWkzzNLdk1BWEFWMzLl6GmQ+wsbgw9j25WIGK0B6FII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745636670; c=relaxed/simple;
	bh=GTJ//8V8E4lhqHArq3UxGsIGl6/VT0BfXlXZWxH9QFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z7MLxky1QRwg+U+4iiGEizBc5L9vXEqcTKMUur9JGnD5Yy0fUo0i2WFwMpC6S+fT14ybi+OhNWFf9ceGsc9KdFvblWqkIJKrFTFMK980TPFrJ9Oa4dmnnIRnRhWb3B/m8jYZS9RaLwx0QELQma+MXFYB1qRzuJ6j7SHmbkEkFC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dJ5h8GMH; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dJ5h8GMH"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5f6fb95f431so2902043a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 20:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745636665; x=1746241465; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oPhqmcKvY9AvewH7vCAuPy8QpwgWU5A4tiUVrwJrrSM=;
        b=dJ5h8GMHAf1hMYywLtKDKK1f6BvHVV6RVV3iIPqwcKWus2ZWU20T3L97zh2JvM4su+
         fyt5FvIMl7xiojgwfM0vYGBUzFZCgV1490IV/JHF3PjEAfTv0BfN65ZY+Mzg46gf/uD/
         P7dfcZSdI5GjZBMXIK2uEG0ZrKb5ISz8etYS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745636665; x=1746241465;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oPhqmcKvY9AvewH7vCAuPy8QpwgWU5A4tiUVrwJrrSM=;
        b=dcbxRSt7epeNO0mzw0YDnQ3pAzdK7x31gGCnJylb0NDGH5FwCbYpJkdmLGYfCJ7U3N
         lDAwYIVECJQkhlOxW2mgtJADkbSjvEODCDzD7UVYQk5/pRU1snA2YCsbRpVaOxij1qlf
         1yThzjO5Ae43HGAkHpSrIw4Kx2Y0KFno5NTceJ0XcL/DFoOlytSVF6Nki2DxvVz9Fcx+
         kxxWtvDc/BVaHz0QulPnCX82hpBcLVYcJRfWt4LviSN+XjY5t+fVtZAvDf+3bY5nKHrA
         w8WBCsiIjMiEvjIQpy6R9PW4ICAacp3CGgOcUkcO0j7FVyh1sVNeXPo7kt89sIgoJNmA
         WO0A==
X-Gm-Message-State: AOJu0YzDI0vgyGR5IWct4/0wTFLSmNZULfgR22zY+Pme7CDmWtq68S45
	lKzSNEjUmpKVvf2l9PE+vxrE0w1J4JeUliP/+iJHJldY9YjavD8UGlkOWYb2CMfN69VWYF/7415
	jFB4=
X-Gm-Gg: ASbGncsiqZbm8wQGx3v49HesIGa57JafpybMClO2WkRuXO2KNqDr4tsgCJlQj1GvNiS
	IoNX7KYjUYrjQ2Bq+vP5Yv8VmkWKrUrvLdOxAhSe8rL4yMnXu82PIISMUAlFsQngERr5u47/5Fz
	ZLyDPT2kyEDDZputYpw059OglYLQNtYOfT06hhHR8m4jzOH+/niUGuSO99CEZDAPmZB/+Va4nY5
	3aL0019YgU3BuDTUHp9iluRhd1GM9tJ88cf6CHPBDxBCTWKkYkmfDub7Gy3InDi+0ijb3VYbVmI
	sx7J6PYaal43bRNRJk+Yt5LYRkiYPuUFSPrF6VSfvYYqXBliy6K0K9X6z5r1Yr2P4H6rbl7h9Qp
	VrylGqw1nk7nxf9c=
X-Google-Smtp-Source: AGHT+IEegej8joLHRWosvPVYGTzcEu4bHcrx/vLtt8/O4b3Bx02ZxB8HJ9gFIdRZu5nU/BGD1eDCOA==
X-Received: by 2002:a17:906:9f87:b0:ac7:b213:b7e5 with SMTP id a640c23a62f3a-ace5a2a92ebmr825832266b.18.1745636665584;
        Fri, 25 Apr 2025 20:04:25 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41db02sm231638666b.15.2025.04.25.20.04.24
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 20:04:25 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f6fb95f431so2902029a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 20:04:24 -0700 (PDT)
X-Received: by 2002:a17:907:7da3:b0:aca:95eb:12e with SMTP id
 a640c23a62f3a-ace73540c92mr337021266b.24.1745636664671; Fri, 25 Apr 2025
 20:04:24 -0700 (PDT)
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
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com> <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
In-Reply-To: <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 20:04:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
X-Gm-Features: ATxdqUHS8znrEYMOPUF1a-wv9B602cVOVCl5sRHxinjIxR42DruVX1W-GKZj2oA
Message-ID: <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 20:00, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> No, what I wrote is exactly how CI lookups work with the dcache. Go have
> a look.

Kent, I literally wrote most of that code, and you are claiming that
the CI case is trying to be the fast case.

Not so. Get a clue. The CI case is the "nobody cares" case. It goes
off and does nasty stuff. It's very much designed to *not* affect the
sane case.

The things you complain about may be exactly those things. You just
don't understand the design.

             Linus
