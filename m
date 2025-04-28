Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609DB1494DB
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 02:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745808829; cv=none; b=vFvbEFJJVgRCbo8+DPD1sPjWSJ2ZZVxmAE6oKAqQQdX4BOsuYbtvpfHu02q9SUpiaXPKd0ORUmZ4hfLtuyIoNQHV12QgsgMmP/wJnRDVKnOer6V3lDrvwXdh0LOjF2lnyD3qADFnQVlNQF3bvn357kGFQNmoHaK59jDY6otqIlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745808829; c=relaxed/simple;
	bh=UYBN6HdnwtEXdHHUY5kI3syKqrU1cYLpXW7HNGKUdm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UTtM+phEkJ6WfIzGEVulaQYGg3wE3tBvZwGjldDmKANBgow0WTMEXb0VISk+UqQAX2HdJy6MjgOMPG4aWxQzi86eeT6yAsrfCTzdjL5TR7sDZoUVszjvCvaGVxjLWbYl8aqnfEoA2QF6Pr2yf+tchudHMFzqa2E554/8qJMjBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D6tuUz6Y; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D6tuUz6Y"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e8be1c6ff8so6982247a12.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745808825; x=1746413625; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6iPnRBaGFfe17FMavfrpmiKhUoHcfBaVv2/5epCw8RU=;
        b=D6tuUz6YrL3itVF+w9wB7Sw04BVctio9s3DGYhlbk0+Bj9Vw8+mTcyYQjOKYP/LGx0
         +RyjNqXTiLSpg6YMXQgOwU47K2GzlTmbKjJUvlq03yFa3oQ4jVl3qQEQri1HEWyd8JAD
         PP5OMsCz02saXfkDSAm5Uul2wxY++Gkhedjfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745808825; x=1746413625;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6iPnRBaGFfe17FMavfrpmiKhUoHcfBaVv2/5epCw8RU=;
        b=EdIDFzOtr6Mw6v6er3WPBVMtXca+hxIwRwGLkL/iwZHOHma4oXD65N4rsYOoLqv4jZ
         Asv2YMmQsg8Pi1/TpSDHz7rMrzqmzqbRqXj0CYFTPb4jI7HTjx0QRMNy2JZF1+T39awP
         o6/5OGO4k065pqWROQ4FpuXfBEHcZE1kd7AY65ShDMyid1fLmk2zWx+n2vx/pKQcE4Ie
         4kAfMh7cOas2BTT5ZrGjpQshdfRjPebrjfRLQdW/mdYf7f5ir3vJLKKGNt4YD1O+K6Ff
         H2OyTZCmzsVgNSWpRc9wXfKJhCigPZjOZq/7Sf1HI5OFkm40m8vwwqejhPo4e5Ww8FGg
         QRtg==
X-Forwarded-Encrypted: i=1; AJvYcCVlvfQXiSVv51NV3izXvKxV70i52Bn2YF2jSJG82z8/wrZtVdjZ+BQEbB1Q2DSn1+3ZJVNXbREbLHpkcnPSrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw05/luIDPLXXLJS78ihv2LkB81SQd0Oh29AOaBTMqqG8Cx4JfG
	tBALmDT0BbTaQzp4BXUXDX3o4jDQyN/6PxMkIaVr2jfk+9vNPFQQ3UCxb30Fxan+Tnjom8bs7N/
	kiRo=
X-Gm-Gg: ASbGnctTUWWAD3/IR50p1rfs70Y+q9CA3xNPQhPHvUq7DGADq1hMpLS4Fi0ACtQ8NNs
	QlDWQiE4AKIzsw4hNF+uO/XSSpJ7w4tq+LhlNcYVGzeuj9+37OOinJW4Wl4t1bqBErVEIFM6AXt
	OlQHjaxig8UvLPRcAAnut8GD4eVEKBUEM8Iw7xtn28vzw4y/9sEv81NdaBTARyA/8gwpS2LX0e7
	xADWvbSjBjgEAeoo73/F3JnxpLGlkNAR3+MYSZ5XZVbZQNdHyUHqstg9tR3XZ0SahLDEJvhLOlB
	shGGzHCDFPd7Z/SYmOP/Csup9dpaP1aKpzXntWG9OKRYWzPOXwZ8BUFGxLnGVMESAGAMmYYEmvA
	+qV06mjqjs8HMSGc=
X-Google-Smtp-Source: AGHT+IH35al+ULt4kOYYyOuJvRLMmX17kEad+//Z4GQmVN75r+MWUX8lYVGi6Xz8NW7p/xQ/SMMaiA==
X-Received: by 2002:a05:6402:27cb:b0:5f4:95e0:e5 with SMTP id 4fb4d7f45d1cf-5f72343657fmr9298535a12.25.1745808825493;
        Sun, 27 Apr 2025 19:53:45 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f703833d98sm5027952a12.73.2025.04.27.19.53.43
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Apr 2025 19:53:44 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e5c7d6b96fso8184057a12.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 27 Apr 2025 19:53:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUESbIGu9DyylFB6+EK4G4macAcQ/Vb3PnF46/2FL5wF4zG11i/IIRxrcWyVUi61YNFz+zl0HoP1gqpcbuRPw==@vger.kernel.org
X-Received: by 2002:a17:907:1c89:b0:ac1:db49:99a3 with SMTP id
 a640c23a62f3a-ace7133c2d4mr947487766b.40.1745808823097; Sun, 27 Apr 2025
 19:53:43 -0700 (PDT)
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
 <dorhk5yr66eemxszl6hrujiqxnpera5kpvkkd4ebumh6xc3q2c@gtvl3cjfqfln>
In-Reply-To: <dorhk5yr66eemxszl6hrujiqxnpera5kpvkkd4ebumh6xc3q2c@gtvl3cjfqfln>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Apr 2025 19:53:26 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgtibpSH3+th-YjbQUSZVMbGNxG87oBDeqx+UkbHWejGw@mail.gmail.com>
X-Gm-Features: ATxdqUGcdKhwN_XGkfQCtIIDjIKiRGyOs20GwmO8dm7_o5J-qX3JKlU0UN9-k6M
Message-ID: <CAHk-=wgtibpSH3+th-YjbQUSZVMbGNxG87oBDeqx+UkbHWejGw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Autumn Ashton <misyl@froggi.es>, 
	Matthew Wilcox <willy@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 27 Apr 2025 at 19:34, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Do you mean to say that we invented yet another incompatible unicode
> casefolding scheme?
>
> Dear god, why?

Oh, Unicode itself comes with multiple "you can do this" schemes.

It's designed by committee, and meant for different situations and
different uses.  Because the rules for things like sorting names are
wildly different even for the same language, just for different
contexts.

Think of Unicode as "several decades of many different people coming
together, all having very different use cases".

So you find four different normalization forms, all with different use-cases.

And guess what? The only actual *valid* scheme for a filesystem is
none of the four. Literally. It's to say "we don't normalize".

Because the normalization forms are not meant to be some kind of "you
should do this".

They are meant as a kind of "if you are going to do X, then you can
normalize into form Y, which makes doing X easier". And often the
normalized form should only ever be an intermediate _temporary_ form
for doing comparisons, not the actual form you save things in.

Sadly, people so often get it wrong.

For example, one very typical "you got it wrong, because you didn't
understand the problem" case is to do comparisons by normalizing both
sides (in one of the normalization forms) and then doing the
comparison in that form.

And guess what? 99.9% of the time, you just wasted enormous amounts of
time, because you could have done the comparison first *without* any
normalization at all, because equality is equality even when neither
side is normalized.

And the *common* case is that you are comparing things that are in the
same form. For example, in filesystem operations, 99.999% of the time
when you do a 'stat()' the *source* of the 'stat()' is typically a
'readdir()' operation. So you are going to be using the same exact
form that the filesystem ALREADY HAD, and it's going to be an exact
match, and there will NEVER EVER be any case folding issues in those
situations.

But the "simplistic" way to do it is to always normalize - which
involves allocating temporary storage for the new form, doing a fairly
expensive transformation including case folding, and then comparing
those things.

Christ.

The pure and incompetence in case-insensitivity *hurts*.

And what is so sad is that all of this is self-inflicted damage by
filesystem people who SHOULD NOT HAVE DONE THE COMPLEXITY IN THE FIRST
PLACE!

It's a classic case of

  "Doctor, doctor, it hurts when I hit myself in the balls with this hammer"

and then people wonder why I still claim the answer still remains -
and always will remain - "Don't do that then".

               Linus
