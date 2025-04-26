Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFEE199E84
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 04:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745640700; cv=none; b=qs6BNgt3sygLwlcLRZzAzQid5Vnmr9Peys/2U0kbQS+ivmywcVExaGNRl4mLAeSrk7ZJ0diRvgna4cjJiv2hFzN4ZO1emPrHnkImlRQkudGGTS6sqPLV268CkHIoRvPqFEHOAva9CExqZ50WuC1u1OwqyWc5A6iTFVzsdSW1mq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745640700; c=relaxed/simple;
	bh=LZaA39QZ/1ssboLrqcr0tnGr9TONpBKqHUvnz68tQ8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXIntzM/ZH3qST6M47osfX4FRZ+rcuAQTh1JegW6czLeTQOzpq9vg2G4je3irycioONykyCCiKugSC4NNU+RXoJee6KKpvKWVanFZmlq2riGysg8caWLCSZby7wMXqEjteCXr/tYWpwtJczWFMb0WC+rpgCm1OL2p/3I9Zo3tAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bmcq/u1R; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bmcq/u1R"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-acb415dd8faso418046366b.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 21:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745640696; x=1746245496; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eyFr35xmw7E/ixwUNF7HuIhiUoN7WKp+7IA8FTndH+M=;
        b=Bmcq/u1RB1lM5/VGjc8i38+Dx04UFrmd7ooQOIRdasLO83MLOVWYrL1PMb4yxWidDV
         8LOH0iQgGVQw1ALUHnPUjdJ2Zzz/GHmbSD7FHnKYjRdmoLAX5eMBTwdmDxg/TKEWPBSX
         H33boTApfw6+ZLt9zoPv+SXZxOCddHgcnNp9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745640696; x=1746245496;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eyFr35xmw7E/ixwUNF7HuIhiUoN7WKp+7IA8FTndH+M=;
        b=BUyADUIRl8sccINo7sbrbCevoKs1c5Seq0DmVm+KLPx7AK8JbgiOTou6GQOKr5EZUK
         +d4setD+r/awNyxtni6/64RMhW6CYK4WJbCFk1PpEvblqNKAoir7b1RBf6dJHfAJE3JY
         WKKUOr481QYS/TjW3VkiYDc265EcdfB2kwhXtPqz1Grmg+nVm9Yc67mp5nzVQQtDiNYa
         R9naIl4bVOpUiVYZJ+otlx6qzg+xkNqud/PWgNPciBC40htuczealHYiwanDHr+iP/b6
         bqukJH0HCUaF769Zcm7izTCSApPXasYn4ETiu8Lcx07lVGcoe+N+TEFLfPfio3TPMHef
         IGxw==
X-Gm-Message-State: AOJu0YwcPp8Ev3nZ3vuCgIN5zECyc3Oe4S5DC7wvEt8DfRmO6QWCfpzP
	/vy0H2rTMjVVdkN4NgxP5IOaUatcH3oAO0nJjQKFGVLLnEQ/tswF673kX6C42jmezgGY79kIn3K
	S4iE=
X-Gm-Gg: ASbGncug5Jd9hs8utPXlA0T5RDGDlOJGVKBXO1VEfssdCWwRSbVLjEwp35QVrvWUX2U
	q9I/r6qES0+Zd1LwrEg2notL5i9gpXQFSC9U0/x+W4G2HF7i6xEVTp/cimdvP+8m5ybcvtaMMn/
	vUC5oogTXQTF3XfOAFzqB9ATU3X0K9o5W3LWpxU2TcXarJgx1FB93Ixo2UmBt/LF0A2DCPW0fRo
	QEUj0XG9A4rslOC/EPIOnuG022BujwG6gR9cscUbTy7T/LCy97S+DpRC74hHe37m+jSiQg8xCDt
	3+uC6R04lbhwp4Doh887GZMCL8WhOudEgKkZB8MiA/TpZtOuhPE3VvZkZ8etbhFjH2wGTjoy2Yi
	yI5QCHGisd0AAxgQ=
X-Google-Smtp-Source: AGHT+IFHdpCeNb1mP0RnOh33UsXZKh4nAIDnHa4787drgyzCMFKGOsmFfXdr9sMxuR16Zvno7K+3AQ==
X-Received: by 2002:a17:907:9725:b0:ac3:bd68:24eb with SMTP id a640c23a62f3a-ace71038097mr382114266b.1.1745640695804;
        Fri, 25 Apr 2025 21:11:35 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e41b2fcsm232466066b.26.2025.04.25.21.11.35
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 21:11:35 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so359082966b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 21:11:35 -0700 (PDT)
X-Received: by 2002:a17:907:7f8d:b0:ac2:912d:5a80 with SMTP id
 a640c23a62f3a-ace7103925bmr389163066b.5.1745640694818; Fri, 25 Apr 2025
 21:11:34 -0700 (PDT)
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
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
 <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
 <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com> <opsx7zniuyrf5uef3x4vbmbusu34ymdt5myyq47ajiefigrg4n@ky74wpog4gr4>
In-Reply-To: <opsx7zniuyrf5uef3x4vbmbusu34ymdt5myyq47ajiefigrg4n@ky74wpog4gr4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 21:11:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGiu1BA_hOBYdaYWE0yMyJvMqw66_0wGe_M9FBznm9JQ@mail.gmail.com>
X-Gm-Features: ATxdqUEOndetjy9WXSDQF_xoaos9kB0PLMfvWcYcUeLMoKS_bINLgYq1z0VMTUs
Message-ID: <CAHk-=wjGiu1BA_hOBYdaYWE0yMyJvMqw66_0wGe_M9FBznm9JQ@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 25 Apr 2025 at 20:59, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Yeah, Al just pointed me at generic_set_sb_d_ops().
>
> Which is a perverse way to hide an ops struct. Bloody hell...

Kent, it's that perverse thing EXACTLY FOR THE REASONS I TOLD YOU.

The common case will never even *look* at the dentry ops, because
that's way too damn expensive, and the common case wants nothing at
all to do with case insensitivity.

So guess why that odd specialized function exists?

Exactly because the dcache makes damn sure that the irrelevant CI case
is never in the hot path. So when you set those special dentry
operations to say that you want the CI slow-paths, the VFS layer then
sets magic bits in the dentry itself that makes it go to there.

That way the dentry code doesn't do the extra check for "do I have
special dentry operations for hashing on bad filesystems?" IOW, in
order to avoid two pointer dereferences, we set one bit in the dentry
flags instead, and now we have that information right there.

So yes, people who want to use case-insensitive lookups need to go to
some extra effort, exactly because we do NOT want that garbage to
affect the well-behaved paths.

And no, I'm not surprised that you didn't get it all right. The VFS
layer is complicated, and the dentry cache is some of the more complex
parts of it.

And a lot of that complexity comes from all the performance tuning -
and a small part of it has very much been about getting this CI crap
out of the way.

A much bigger part has admittedly been all the locking complexity, the
RCU lookup, and the whole extra 'struct path' layer that allows us to
share the same dentry across multiple mounts.

The credit for almost all of *that* complexity goes to Al. Because
some of that code scares even me, and I'm supposed to know that part
of the kernel better than most.

             Linus
