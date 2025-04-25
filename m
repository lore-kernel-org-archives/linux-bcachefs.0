Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA7186E20
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 20:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745613360; cv=none; b=tTIqAB+iAO1ztN/ezrOLZ2YpT+3qWz3Ox5sYI34tqID1lUfWmhtoTWWVG0qeP+Zr5RlExx/Ei+hzL5LXPvytygitIzA+1eMs/egMcFBe/30IxQ3/FSi+Cy+zDO+BJf6jmG/rZITKiXKhxF5VyPaHkhhAkcbNVs1jOqrycI0pMrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745613360; c=relaxed/simple;
	bh=SQExu4w4hPgGkdy5kCAct+RvK8+FjV4snNR+nLyJBNA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FyDRYm3Oh3bL34Prgnv5LaWzvP+bdVc9/Ev/ChzwKAzAy1Ztk8idgMPukV1DHkH4IizQuW0Dcq0UdyF24/vIZuizT5IgY7ZGhlAnL9tUDro3sdqrCiEemHcFeVuS8Lc2i4zLftIhctQSE/ktCGFot+iajCk+0LpKV1nu/h9lxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AcqdYf7s; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AcqdYf7s"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ace333d5f7bso439420766b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 13:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745613355; x=1746218155; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qHF1zPVwXD8IdJu/yf1YIr/T0XDnrM1CQwq7Bj5CPDw=;
        b=AcqdYf7sEb5O+p7PVg+SZBBLgQsUwDcGRQTQc2JJgrlVDWdBnJNhSSZvwB9Y/uq95v
         SFZOHoWJVu8NVIHqXNYAkdH/DMLXOVm+keHTgYF5b4Ka8r3hg0WEDUVNB49RjBh7Z12x
         Jj5oHdUODbq4ly6ayEpYN6M10Qjlnt3VJEsL8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745613355; x=1746218155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qHF1zPVwXD8IdJu/yf1YIr/T0XDnrM1CQwq7Bj5CPDw=;
        b=FcUAryaV+m98xLscAodcXIHbGvscH8xriP017UsCUIlXTW6cKL+AGGR/CyYm1P7e7W
         CsCzIR6hOapPGW8mrS9qeSSjsf0OG62kRSeUQcgNvw1i77RpD6qOVat7xxNOnaBcWs5M
         souJ1Rui7RoRqv6mjJGM156m3sYJbmFkLZ2KyJ5TtaQvABr0W2qsi3uJxHS5IzFxRCR7
         s73sdQSaVtgiV/0KxyZ7ZmfeDt8Qwi82/iquCxvhDIzcpzE2/aLo0fnmbGac1TQDAWIA
         j0tJZgjttr3omkA01EWcxy8Xs+kPnPHhx0CuZyDvfv0HCo658itJykw/dfTV9g652VJn
         vRhw==
X-Forwarded-Encrypted: i=1; AJvYcCVITOgw2EJPZTGK4eYR7FaGBw1wT+XvAxJ+kytVbta+sDP5py3MMu7yUfPkCbqSs+GARFeepEFt1280g4x3Rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbbAdwdCbhWzjbp+9gXprbeeosLM7lwID3y1uXSlXGiuT2ODk+
	aaPUu3iwhhNWmVZyHPigvbRsihzjXpp/nFXlF2ag2d5HTKLguC1o8SLrBDBDGVTJbWgLYWcy+hz
	SWSs=
X-Gm-Gg: ASbGncslVzWn1JuzNCM9FHp4u+BJvqZ/d2qcagNrbPBX2Kb8ymB/f5S7WTzZARp6saU
	a3zsMeIay2NOG3ubkSQP741KkJJovoi5kibsLpOQZJqRbxBfqKXKfeBmen0+pbKH3u8GEy+9faW
	Xseu38OHQa9mbGACyu0jDjhIKgbOoV9TyoMGEiWbMoncmjJXdqdCc8anlHwZIOlq3vnwtqBUlqX
	TBCqvUHSie4zDMYVOPMNB7XeKJ4N6oZ6pIAhzRYqyW3X15ZwKESJLgV0pTCqaEJnJuFMkGq3lst
	4FwuvDQ1+DeW6fEdnKYQR2R4xxE8AuWmJmlUhe6tvYKlpflXniHQmUo2Ex0USGGLIHGbyNiOs9t
	eT48/gXSNIsB2wMk=
X-Google-Smtp-Source: AGHT+IHYAsUq1SoxiGi7E6gsYxCXXb7S/paEkIUIvWTLr0Jx7ckTGACDgdWF8rPxP5UWPuRY4R3BOA==
X-Received: by 2002:a17:907:7e95:b0:ac3:8895:2776 with SMTP id a640c23a62f3a-ace848c0439mr61941666b.5.1745613354855;
        Fri, 25 Apr 2025 13:35:54 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41ac78sm185805666b.2.2025.04.25.13.35.53
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 13:35:54 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac2c663a3daso511001066b.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 13:35:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVD3Uk9q+TCqmlylq1SlX+4CcpEQpr0PGTv8mKEBoZT5tyLV/tIxk6wY+YaUTyz8KsowEPggMgRwRudNJaPuQ==@vger.kernel.org
X-Received: by 2002:a17:907:7f24:b0:acb:107e:95af with SMTP id
 a640c23a62f3a-ace84ad7774mr62978366b.39.1745613353476; Fri, 25 Apr 2025
 13:35:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com> <aAvlM1G1k94kvCs9@casper.infradead.org>
In-Reply-To: <aAvlM1G1k94kvCs9@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 13:35:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiX-CVhm0S2Ba4+pLO2U=3dY0x56jcunMyOz2TEHAgnYg@mail.gmail.com>
X-Gm-Features: ATxdqUGwKlTpu4bheZKrvcER-qlO-D6uY_4AgFPDdEUKnYAjfRZ_s0Tk9V5ZhUc
Message-ID: <CAHk-=wiX-CVhm0S2Ba4+pLO2U=3dY0x56jcunMyOz2TEHAgnYg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Matthew Wilcox <willy@infradead.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 12:40, Matthew Wilcox <willy@infradead.org> wrote:
>
> I think this is something that NTFS actually got right.  Each filesystem
> carries with it a 128KiB table that maps each codepoint to its
> case-insensitive equivalent.

I agree that that is indeed a technically correct way to deal with
case sensitivity at least from a filesystem standpoint.

It does have some usability issues - exactly because of that "fixed at
filesystem creation time" - but since in *practice* nobody actually
cares about the odd cases, that isn't really much of a real issue.

And the fixed translation table means that it at least gets versioning
right, and you hopefully filled the table up sanely and don't end up
with the crazy cases (ie the nonprinting characters etc) so hopefully
it contains only the completely unambiguous stuff.

That said, I really suspect that in practice, folding even just the
7-bit ASCII subset would have been ok and would have obviated even
that table. And I say that as somebody who grew up in an environment
that used a bigger character set than that.

Of course, the NTFS stuff came about because FAT had code pages for
just the 8-bit cases - and people used them, and that then caused odd
issues when moving data around.

Again - 8-bit tables were entirely sufficient in practice but actually
caused more problems than not doing it at all would have. And then
people go "we switched to 16-bit wide characters, so we need to expand
on the code table too".

Which is obviously exactly how you end up with that 128kB table.

But you have to ask yourself: do you think that the people who made
the incredibly bad choice to use a fixed 16-bit wide character set -
which caused literally decades of trouble in Windows, and still shows
up today - then made the perfect choice when dealing with case
folding? Yeah, no.

Still, I very much agree it was a better choice than "let's call
random unicode routines we don't really appreciate the complexity of".

            Linus
