Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858DF170A37
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745638871; cv=none; b=Z9fn2m0HiA1o7yTOhrv+Wtua9C45Ayl3IoCzTAoWwfdC6+F5H2tyYNWGAPRNBG1eEZBIJKAzSThz/W6nAcU9NePOCRMdXxrWRefD1YNN4gltj68MyyG/8Ge6ueLeSVrccjaylWephskzDW7liFoTQgvN2qdfZ5XhCyybjSwOzFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745638871; c=relaxed/simple;
	bh=0eHXO77AAyGUMGMq7VTE6t2K6BioW4E11zC+/xXCKsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5STYPlKwriQbJEgiRBWp5r0zxdTaEhqK/NjJc/gqlVTgghbb5cm+TU5E9fMM1Hm8YHft9Kwo3htZ/61VbHIMmyLwoQUKqnRRPqTW8BQujh2wZ53d6lTJt2vKJYA+RN4M2i2OwKotskC2nms/x4yijdXGkybNWyEvkOrclZHeUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UTiPNFfx; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UTiPNFfx"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso3858494a12.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 20:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745638866; x=1746243666; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Jnw7cB8PnBwNO4vq3emLlRW++0sbsZCdtmwKmtUbY6A=;
        b=UTiPNFfxSceVJD8M1up63SzdIgXxJjkc9VCFcjxV2aDPkh/is4PTlXAmJY52xeOJhL
         vylFPxx8lHmfRSITw0NGEX3UN5Q1iMdlxIs23sioNl9Nf5UkDD2fq0cD6/TRNf0e/b1B
         sAC5B+5g8BxAmqKAUCSiYfc1jgfPAWV8U7qcE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745638866; x=1746243666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jnw7cB8PnBwNO4vq3emLlRW++0sbsZCdtmwKmtUbY6A=;
        b=dpgD+oIX6IhIUNCEqoV0cLroB6ewsL6pcbzIkUL25pvkSHNbEW49bau702oCiF5M4j
         0/n+4+I9bssMVySZbrBu4DgKr8XKrQcOa1mMcaZCIOFfIleGSnqAEioHrK9vbKmz3e8g
         geUF5NFHnJ04E8DGJz1Tpl7FyHZx/r4XF8F5OokfhN0/MuC1gECEcrpxxTbXFAudG6O3
         284IjEvmnjHaFagVTDWdZn+0lOvycgOpTFGOpoX2M6bond386a9yxbtZSuTKK11Sj3sN
         0/bi0EYjO82P47XvMz7g4zqwFumbSvbOqjdfnjnjnfA8ebONmQRzkpd95t6OH8QgNUst
         uzAQ==
X-Gm-Message-State: AOJu0YwAYKEmGlIyVw3QpCzlmYdZcgMw3S6Q+w28bfDPg76kHKBILdh3
	uZCPdLJhiXKuEh28ywb/RzmixdhzCcRT4bS7XSvC11ojUtyK6D09ekNebFyetP1zw21HCm8A3MD
	lQfU=
X-Gm-Gg: ASbGncu2CmbyflFKpd/VoKAzHuM+3rSJvvIYXHXaqp71cTTf3igKw/OhBPmnS+WfF+0
	vFWR635p8YZLO0zIPPcVopION5zuPz0YGo8szDXDmsMLVbhyXSN6Qr/CVexYBzt2AXauiN2Pzoa
	2uigZ4qqI1WGWhlOsdA4DB/k++jUUKhSd7zApFyHqmzYYBNYpiJiBvb9N3N4G2AyG+gqsjf6YEh
	HJcMMyAR52uhA3KCqebZqOKf3o6Ejqmt/qING8VG+SfPSC+Lyen0Zz7AsOcf4k7WcWxX9di+6F/
	eSkZJiqnhspxwKzkdZBBNJLeqSWCRr4Uc0LGc5glBCaon5GTBLwsEANA1K0OuhEWcGwjXDoDqau
	NoQjYVsGVOCXqLbxL/jeERTJBhQ==
X-Google-Smtp-Source: AGHT+IGD8oQOJ6nIm4EaiDdGHUnV7DV+YEukInnJdxOqu7j+JZOb4LsH/j/BIV5vUOfeOwrxlwnomg==
X-Received: by 2002:a05:6402:4416:b0:5f7:2893:a690 with SMTP id 4fb4d7f45d1cf-5f73983dfbamr1218681a12.34.1745638866436;
        Fri, 25 Apr 2025 20:41:06 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7035464f1sm2082912a12.62.2025.04.25.20.41.05
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 20:41:05 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac3b12e8518so510999966b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 20:41:05 -0700 (PDT)
X-Received: by 2002:a17:907:3dac:b0:ac7:391b:e68a with SMTP id
 a640c23a62f3a-ace84be069bmr123676766b.60.1745638864888; Fri, 25 Apr 2025
 20:41:04 -0700 (PDT)
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
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
 <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com> <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
In-Reply-To: <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 20:40:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
X-Gm-Features: ATxdqUGH7mQMKhNc_ZyOpUoBrH1zpBO2k8Qe7v9LI4_RH5cpFyznGVafbugfOHw
Message-ID: <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 20:09, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> The subject is CI lookups, and I'll eat my shoe if you wrote that.

Start chomping. That nasty code with d_compare and d_hash goes way back.

From a quick look, it's from '97, and got merged in in 2.1.50. It was
added (obviously) for FAT. Back then, that was the only case that
wanted it.

I don't have any archives from that time, and I'm sure others were
involved, but that whole init_name_hash / partial_name_hash /
end_name_hash pattern in 2.1.50 looks like code I remember. So I was
at least part of it.

The design, if you haven't figured it out yet, is that filesystems
that have case-independent name comparisons can do their own hash
functions and their own name comparison functions, exactly so that one
dentry can match multiple different strings (and different strings can
hash to the same bucket).

If you get dentry aliases, you may be doing something wrong.

Also, originally this was all in the same core dcache lookup path. So
the whole "we have to check if the filesystem has its own hash
function" ended up slowing down the normal case. It's obviously been
massively modified since 1997 ("No, really?"), and now the code is
very much set up so that the straight-line normal case is all the
non-CI cases, and then case idnependence ends up out-of-line with its
own dcache hash lookup loops so that it doesn't affect the normal good
case.

            Linus
