Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB82486342
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 05:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745643704; cv=none; b=I5zZ/+moFh7He13Oe6TGFO9+fEn6+7TQ93qk62IFRZKXQjqlvRoIL18GUhAS3e3wrYSueV/rSnEHMe2oH6QK/4Xj/Z7J3JzcY9nvjWX5VCNAQngz6XEvJTN11jYBHhks+F73LPYmsXMYeg5RWR5GMhdkF2P8yOqm3VFjyEKjl3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745643704; c=relaxed/simple;
	bh=cXDJuE/yHxwV04PJPoKVlfNQF+rhGqfW81Ns96b8E2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gw2OfPULc6zFQCHTMQAurd87SXO+B89Vy+m2Fmr6mIm7RKecg/4nniZ2EfBcgyMS9uyHouzNrkaxxJNCzQxnjCHbm3/B030LCcsmk/mAxh8ZzUJPuzZjx/eSceWtl+rBF2bTdOtf9PvHjOs7Ooi7Y+WkbqVyTct0A92wMU8Q+vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=befHzSvp; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="befHzSvp"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5f6c3f7b0b0so5460170a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 22:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745643699; x=1746248499; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1Zg0s0tJJS2TEem3MFSImn2y5n2w5Xsq8PYaeuyKw6E=;
        b=befHzSvpC6nEm049fo2PSKtmwjM2uEQmg5QBRwJajygSMbCXpt5xtyA9HC+GvPcjeh
         xrfEV47/qGquenENAwLniSXAwYXJ/YW/GslzxAatGfRb5FOxtCWREe/0u0xenyBQj7JA
         OKZaMabyvs8QCcSUZD113i4bdZublzgxyIumg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745643699; x=1746248499;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Zg0s0tJJS2TEem3MFSImn2y5n2w5Xsq8PYaeuyKw6E=;
        b=JmEyV7oI90KdfvGrGrHQE6aN4mkkBSED66pjF3pGK2CJqpLMxofWtlO9sGcgDPv5A8
         e1hxK7/gdstPe0jXS3YH7LIqCZyMpAbAuu5SltXyh+EpFNCMsL9jR/uTwnGBQfuhGrtN
         WqmHG2oF+6JQuIFvXl7y+u4uujWPjmfob+lIxdYOs3FYsnx7DdOfknm4YWAx8nVZmcIS
         s/dAgmfzVIsl0kiAS28d/KYUxEk7UHYDRbrAHo8fpLFs5m6VGXTO18b+uTO/4iQD6ZBz
         JUbsItsOyOLFGpN0UL/ahW4Jcuf2CGBJFlRFJu86DRXbaGiqkMkF6jpER2v5rSBpHOH+
         Z/hw==
X-Gm-Message-State: AOJu0YwKqfq6lLmREWcdwxLU7EGG4VC5PGQDydcNEgpLWeTqAfjtfrH8
	LZ5kCSk+rP1C8rtz0/tyK9fkH+gcA8FUjqn6mZGhsY7eIyLgI7sDrtfFQLPlNgmhH9Ahsnip5z3
	SVy4=
X-Gm-Gg: ASbGnctE6y+Ew/6qmEqN5dyiV/vAXbK8fBTottBF3XpUfPHNAxA9+6ilYZ66tm7bWkx
	vMqd3+Nd2F+2eIgU9sH6zdAnoyvkPfhzDlP1aMx9EllTG1rTzQexDizUijFbnz6znfrTVVZNA4G
	ggYNMvZHfCq+cdeGnJTYjQgcJF9A8inTdCCreumdddNM98LjUK+IMm9bqnk2R7xbt31DU9WF7Si
	90xXouxAPpyoc5VT6O9oglahOAzA3NuR6dyD7gdYESw86p/o0XoiHgU/zw9AMjC7ukYvQ5NlCV0
	UZZK79LAW5YeRDPezxyglRE6eWYT/OPu3sB6Le5g1Splftd2AXyDOKjW6ckRE/rrZFgZunPcC+a
	uAfHlWv6WkLaMoqE=
X-Google-Smtp-Source: AGHT+IG8mPGl6HL9jOzuJRK8/syp76pRaiNkxEPYKpvGQ/ErhssjPOlQniImDidEph+SZ+yqmoaEMA==
X-Received: by 2002:a17:906:7314:b0:aca:d831:8fb1 with SMTP id a640c23a62f3a-ace73b45d04mr393646366b.51.1745643698701;
        Fri, 25 Apr 2025 22:01:38 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f703831dc3sm2152160a12.67.2025.04.25.22.01.37
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 22:01:37 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso512164466b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 22:01:37 -0700 (PDT)
X-Received: by 2002:a17:907:7214:b0:ac7:ec31:deb0 with SMTP id
 a640c23a62f3a-ace739dce1cmr296946666b.9.1745643697218; Fri, 25 Apr 2025
 22:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
 <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
 <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
 <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
 <opsx7zniuyrf5uef3x4vbmbusu34ymdt5myyq47ajiefigrg4n@ky74wpog4gr4>
 <CAHk-=wjGiu1BA_hOBYdaYWE0yMyJvMqw66_0wGe_M9FBznm9JQ@mail.gmail.com> <rn2bojnk2h3z6xavoap6phjbib55poltxclv64xaijtikg4f5v@npknltjjnzan>
In-Reply-To: <rn2bojnk2h3z6xavoap6phjbib55poltxclv64xaijtikg4f5v@npknltjjnzan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 22:01:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiLE9BkSiq8F-mFW5NOtPzYrtrXsXiLrn+qXTx4-Sy6MA@mail.gmail.com>
X-Gm-Features: ATxdqUHWqxV-OrhDY-rKh16ASGQeohXR7OrfwoZY40F3L9gFfuaxZ44BLo28GKU
Message-ID: <CAHk-=wiLE9BkSiq8F-mFW5NOtPzYrtrXsXiLrn+qXTx4-Sy6MA@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 21:49, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> And you never noticed that the complaints I had about the dcache bits
> didn't make sense and how I said it should work was how it actually does
> work? Heh.

That's a funny way of saying

  "Oh, Linus, you were right in the first place when you called me out
on my bullshit"

Here's a clue, Kent. I told you you were wrong and full of shit. Let
me quote that for you again:

  "I think you're confused, and don't know what you are talking about.
   You'd better go learn how the dcache actually works"

You doubled down and tried to tell me otherwise.

You were wrong. Again.

I'm really tired of your constant attitude where you think you
absolutely know best, and then EVEN WHEN YOU ARE WRONG you try to make
it be about somebody else.

Now you are trying to make it about *me* somehow not noticing YOUR
ABSOLUTE BULLSHIT.

Just walk away, Kent. Because I'm very close to being done with this
constant aggravation.

                Linus
