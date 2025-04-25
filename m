Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503041A23AD
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745598949; cv=none; b=AXMCPMXPLSHIQJZ+7wt1ZZhUk1UBQJVkZlRB6nFMkyPgHCwP4pYicuidbvziP/PiIeyPeUdWjeNn6mP78XauZ6hcrWRcHUVzaOe1WpYIbuNeRd57jhC0eVbRcbN1ooJhFj/dYxDFiTnKJW3Wn2p04K52ZfhOgEzlO7vnBmQm9DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745598949; c=relaxed/simple;
	bh=mdIQCxdUYhtXLzXUmLDFNwoEcEWuoi78Lo+56Eh8rac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N69VOQueA/Gy4pRZZqf2YMdiMqHGwCEn3MRQGWE+5xDwDf+s6/kzRYa+WedS9ejkJ1oOCbk6H4yE83ri+3rVqCOy8OpAksPSBYQRaRDYIzp3RX8+WYstAKjdzlViThGOf6iEOIXPhytSIXKQfsjMgyBBZ9dU1u/lXuAKjLmMjuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AUT8y7Q2; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AUT8y7Q2"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5f6c3f7b0b0so4565915a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 09:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1745598945; x=1746203745; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EIUARXjixZE2LMjIM7t5GFiqmmk274q2ndIpCfZ4HnU=;
        b=AUT8y7Q2pVqVvCMV42YSG5GNC1Xxj7a/ixWBwJTDz61OsXbgaV8BFJf8L2b+lPrUcv
         UiLtSm6Kd9x5Zo3voC7BNfPH6Ip5suH7AyhY/qWGkntDaUB7G8eSd65OzvDNqf+YRF7r
         17919hC3EDALbyKgFmv6kZjcwkhFgIXT0TzmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745598945; x=1746203745;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EIUARXjixZE2LMjIM7t5GFiqmmk274q2ndIpCfZ4HnU=;
        b=UvoFRsrRuRf9+O5NUNMft0kDnx0ZzUz3ekdHwpfBWtogajwSsYxG4aC72i2Sh8k4c/
         v1S1/n/Qula6Ehd2+R6atU1v9LWzyva25YXIqYjMdU6eKIW6wJ9Q+OJY4LZe2QMEGOZy
         F9vzYUOOdij3hbPHVC+CmpGmuzCWhUSlM5ZST5C9QQa5hEdgi7CMx7u6pplPc8/049Gg
         GuImv6vnyxthl+H1uOTdloZV8VdXWA2QpZFBtKlpizHAVhLFWb0WBjvS3G5wczGRhmXe
         ewBwl8PplC0QIX0YRsKe0uwc5lDclSuBmmQjRLsqA+sMdf6Pkc0dp9uR5ca4+guF2nAh
         ycaA==
X-Gm-Message-State: AOJu0Yzf0ARW7BAGtN0VPGOXHrzWgLC0nQTO1Gr4+McTqCjkf5d/+ELm
	qyC4O34ipjk1KVfajQokrPBhhA+Pq2egoe7FkNjB8mlUYAC1wwZdB2M3fBk2hmIlkfLpztxw//l
	ueoc=
X-Gm-Gg: ASbGncsN4FJCzd8P+/XdJTGfol8V526kpWA/B5ERDJXkFrutHYkVooINTLQTg9MA7az
	/y4/vh/xPnrhtd9q8JP/EFVrMlCTLlZ9/q82TwqJRMj7m7L7VqpUM7IRMzDthNd5rlompsuiPX6
	rAhKEv9JWeQvZ/RbXxhTIRp0DD9v+9vFLmORw0fb3FGJjAu2Os6UN/ED2wBH7UCCdN/vk7F2iCz
	vbTfU8mfwN7jVwKV03SBvW+M5A2hRme0Cor4IyqHkfKvMFbh8nHDVM5QLoROlKyq40CpcC04HSw
	Y3yT+K8qQQ/JyHCKD/IH+IJKDhOw0Zv7BL4mgaOz779B9rZzwLRfgXkmqFdmNC8XG9ggfrUt1EE
	2uGmsXF3iy9PhSpw=
X-Google-Smtp-Source: AGHT+IE7I/rM7VzR92lu+ieYc1kB/HCvt80d+zGceZlCuWJl9pQVCIK9hYlHUelcFs7AZ46XaamErQ==
X-Received: by 2002:a05:6402:2709:b0:5e5:ba3e:ab04 with SMTP id 4fb4d7f45d1cf-5f72363cfd6mr2452239a12.26.1745598945182;
        Fri, 25 Apr 2025 09:35:45 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7035464f1sm1463493a12.62.2025.04.25.09.35.44
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 09:35:44 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-acb39c45b4eso382220866b.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 09:35:44 -0700 (PDT)
X-Received: by 2002:a17:907:26ce:b0:aca:c38d:fef0 with SMTP id
 a640c23a62f3a-ace736f5aa5mr267986666b.0.1745598943873; Fri, 25 Apr 2025
 09:35:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com> <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
In-Reply-To: <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Apr 2025 09:35:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
X-Gm-Features: ATxdqUHMp1icRsSCmBF8bQUPP7IOF6HLUDbKcNsbk2Yj391oWT65wJGBfC1ihnQ
Message-ID: <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Apr 2025 at 21:52, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> And the attitude of "I hate this, so I'm going to partition this off as
> much as I can and spend as little time as I can on this" has all made
> this even worse - the dcache stuff is all half baked.

No. The dcache side is *correct*.

The thing is, you absolutely cannot make the case-insensitive lookup
be the fast case.

So it's partitioned off not because people don't want to deal with it
(which also admittedly _is_ true), but because partitioning off is a
firewall against the code generation garbage case that simply *cannot*
be done well and allows the proper cases to be properly optimized.

Now, if filesystem people were to see the light, and have a proper and
well-designed case insensitivity, that might change. But I've never
seen even a *whiff* of that. I have only seen bad code that
understands neither how UTF-8 works, nor how unicode works (or rather:
how unicode does *not* work - code that uses the unicode comparison
functions without a deeper understanding of what the implications
are).

Your comments blaming unicode is only another sign of that.

Because no, the problem with bad case folding isn't in unicode.

It's in filesystem people who didn't understand - and still don't,
after decades - that you MUST NOT just blindly follow some external
case folding table that you don't understand and that can change over
time.

The "change overr time" part is particularly vexing to me, because it
breaks one of the fundamental rules that unicode was *supposed* to
fix: no locale garbage.

And the moment you think you need "unicode versioning", you have
basically now created a locale with a different name, and you MISSED
THE WHOLE %^$*ING POINT OF IT ALL.

And yes, *those* problems come from people thinking it's "somebody
else's problem that they solved for me" without actually understanding
that no, that wasn't the case at all. Many of the unicode rules were
about *glyphs*, and simply cannot be used for filesystems or equality
comparisons.

Which isn't to say that Unicode doesn't have problems, but the real
problem is then using it without understanding the problems.

So the real issue with unicode is that it's very complicated, and it
tried to solve many different problems, and that then resulted in
people not understanding that not all of it was appropriate for
*their* use.

Part of it is the "CS disease": thinking that a generic solution is
always "better". Not so. Being overrly generic is often much much
worse than having a targeted solution to a intentionally limited
problem.

   "Everything Should Be Made as Simple as Possible, But Not Simpler".

and involving unicode in case folding is antithetical to that
fundamental concept.

What I personally strongly feel should have been done is to just limit
case folding knowingly to a very strict subset, and people should have
said "we're being backwards compatible with FAT" or something like
that. Instead of extending the problem space to the point where it
becomes a huge problem, re-introduces "locales" in a different guise,
and creates security issues because people don't understand just *how*
big they made the problem space.

Oh well. Rant over.

                Linus
