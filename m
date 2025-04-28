Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B251F941
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745808009; cv=none; b=JaNRIi7HlOUoH1PPsBpL3nyr+LeJ0BeYoWg0VQYDTx1ZeArKkWdVKGp83Evq8bT+AKu7IaH54hY4wIgQwfXbws19F3m7m7M1ceG7jpgSDfuWh5LrLyHVtQsGeKlBpAFB/VayzZpedSlVVHmJdUVh9xWtOnK9LeO/+rM6uvpF5vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745808009; c=relaxed/simple;
	bh=9ak1Y1LNwKVWK45Mep5TVznM9aXYVsr0q7zxmIKkhMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a7Pm8o1SrmaIOIuC7GCP7/WrhdJpAh84rPYyLdADFioF0sZQVh39OdWgCGg22fXmcaqrZfPwe3fZ0MRAVijRu4G2y/uNxssZikeQh046iWZAXqGsgMbfFrOt0/toNhx9A6lSyQi2wRtJjFH4eyr8JlEMMZrftYhlNTXx3gnn8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Trj3KLvi; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Trj3KLvi"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abec8b750ebso719574666b.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 19:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745808005; x=1746412805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7yg5nbDyJb2zlJLx/YXnma09SaHzuLtzbwsUIUnGhg=;
        b=Trj3KLvi8UGU8+oc7xMnIWelZ6vVLVyYrTTT+qbyPq4kbYVBadcUBC0q3tnEwWL58f
         iNIjvkwLsBWKHZRGsuwyYEMcbQDk+0LgINC5GBKCx8Ew+d0pXT+DGEnwpQcaiX6FmGLC
         sQGSmA6vq11h4Xon6PK36Llit/S/kGW9GoAK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745808005; x=1746412805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7yg5nbDyJb2zlJLx/YXnma09SaHzuLtzbwsUIUnGhg=;
        b=tmVvx+wxxa3aEJGWHyW3ZHMZpRNVaGzy7XRCjmWzT4IfIsUBlB2d1lx+FLBI/UJHZQ
         NGAkfb/0c7mJGFHK7CEFsuc4fIQTrRjV7aeCTYIO2pfCLJa9tfHYe11dHa70U1Z+8PYG
         tbOwVdudnDCDCxsP5AClVugQFOMVONEWN5b/G9BYczAE+RzIv38GCYvOXe3otpGKShH6
         8HDIqRhPLGLpbPfg3RoP8zIHOD3Y5TtzIj/Qcqki0FXrPKMKrOWme2DpLLxa2okur/YN
         HWxRPKkRK8ieVXTnrBMH5bRmwlySoy0RpGdJDcRJS9ki398bBO79U010zoQFfP96jGzX
         UznA==
X-Forwarded-Encrypted: i=1; AJvYcCW/akcJsZJSSQjHjTY8TLToBTHyKUS9o0vE8b6EmggoK4iQ3l49HljiriLdMnJdzUa6uuiOGLtWoPUTe0obTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzXs891k7XJK5aNs7eI9gf064l/hrRuA5SvIs1/Vwnv+l5FxOf/
	WeHQr3oe4ikfuk201uHASZbtVzRytqBCpguk+KaGeapT7gJr3RPpRd4AgRRMZwFzMbxVkhwdk7x
	Sy6g=
X-Gm-Gg: ASbGncsuN5hcb4crcZ6mmMQUTA9aDDhpBUs3h4ByAjlGtxne4+YxGpGJSEBBlrIOBvo
	4qAanJc+eG6Rais3wDBo67fAQlZesfvuQxT44UAdYnGXqWpCqOEiFPRvIzn8MC+fyLMiDITNOuO
	5cseFMH3LPaMNAmsTtMOxG2O/T8z70caqg6znOYhMLtJeJbo7OePPCnGLtGCFGsQKeCl1eBkN4u
	OqMnEXB4/+6ebbO3AxFF9+VI0X+fyV8J4Nh7qScZbkPL3AFg7JBVp/ftXFQkfFljZMKTtxfa6FM
	H7claWuMX16aGSSeNM4IkSi0/G9p10EYjJbacsOWQA+fsz1DI3GicwISeyVwx48iCpnBA42pNVl
	+jQPuV4orh9wx5I0=
X-Google-Smtp-Source: AGHT+IGe6mAi9XRN0Zi0DZ9hPpNDoqXR5JmUlSRnLG0FObW5Iv0kbbeRMKm/fsO829JY05YeYQs+wg==
X-Received: by 2002:a17:907:9816:b0:aca:cac6:3ca9 with SMTP id a640c23a62f3a-ace71107381mr929792666b.27.1745808005501;
        Sun, 27 Apr 2025 19:40:05 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41cf71sm533552766b.30.2025.04.27.19.40.04
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Apr 2025 19:40:04 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acbb85ce788so814075166b.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 19:40:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+TL4o5U/Ht313DiEZM073ikSmsmoWFeYcPqueZu7uYWrWEUGoXk40vyRnZCWJtOjoaY51vWQE4YxkINtkjw==@vger.kernel.org
X-Received: by 2002:a17:907:7fa5:b0:ac7:ec90:2ae5 with SMTP id
 a640c23a62f3a-ace7110bbc5mr916176466b.25.1745808004097; Sun, 27 Apr 2025
 19:40:04 -0700 (PDT)
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
 <aAvlM1G1k94kvCs9@casper.infradead.org> <ahdxc464lydwmyqugl472r3orhrj5dasevw5f6edsdhj3dm6zc@lolmht6hpi6t>
 <20250428013059.GA6134@sol.localdomain> <ytjddsxe5uy4swchkn2hh56lwqegv6hinmlmipq3xxinqzkjnd@cpdw4thi3fqq>
 <5ea8aeb1-3760-4d00-baac-a81a4c4c3986@froggi.es> <20250428022240.GC6134@sol.localdomain>
In-Reply-To: <20250428022240.GC6134@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Apr 2025 19:39:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGC=QF0PoqUBTo9+qW_hEGLcgb2ZHyt9V8xo5pvtj3Ew@mail.gmail.com>
X-Gm-Features: ATxdqUGvyKI4n-dRAwL1ViEnwkLC2od4DD7XTcjrN1q3OFkYBi4GABqBN_mXblI
Message-ID: <CAHk-=wjGC=QF0PoqUBTo9+qW_hEGLcgb2ZHyt9V8xo5pvtj3Ew@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Eric Biggers <ebiggers@kernel.org>
Cc: Autumn Ashton <misyl@froggi.es>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Apr 2025 at 19:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> I suspect that all that was really needed was case-insensitivity of ASCII=
 a-z.

Yes. That's my argument. I think anything else ends up being a
mistake. MAYBE extend it to the first 256 characters in Unicode (aka
"Latin1").

Case folding on a-z is the only thing you could really effectively
rely on in user space even in the DOS times, because different
codepages would make for different rules for the upper 128 characters
anyway, and you could be in a situation where you literally couldn't
copy files from one floppy to another, because two files that had
distinct names on one floppy would have the *same* name on another
one.

Of course, that was mostly a weird corner case that almost nobody ever
actually saw in practice, because very few people even used anything
else than the default codepage.

And the same is afaik still true on NT, although practically speaking
I suspect it went from "unusual" to "really doesn't happen EVER in
practice".

Extending those mistakes to full unicode and mixing in things like
nonprinting codes and other things have only made things worse.

And dealing with things like =C3=9F and ss and trying to make those compare
as equal is a *horrible* mistake. People who really need to do that
(usually for some legalistic local reason) tend to have very specific
rules for sorting anyway, and they are rules specific to particular
situations, not something that the filesystem should even try to work
with.

          Linus
