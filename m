Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7F6192B84
	for <linux-bcachefs@vger.kernel.org>; Tue, 21 Jan 2025 19:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737487027; cv=none; b=rHcTawJgyYpA+fhBMo0zHkY1tsSU3aSi4mIr2ynwUgNkaPy3wVuCsDdg/xmybfIxoRGJizhzB11hTEA9OoY95H0dyrg2zJWpqcdjvdnkEY+5id4OZHhEQ+nej39t+H12wBKaExQNzRzazkYOzRm6RuBaLdFe3PlqxsnyEoCwqA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737487027; c=relaxed/simple;
	bh=mR7l/a+1cTBvITTTNwsqZQvnsFbi9is+o0xLLJoPSq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X17FUPACBlmRPG35plww/Y1DN5cTu+x01KQaPOUwdr4NxxnqkzY5fv2unxi0ggBV6NoVYcMDZf9lFTkHJXffP86jKeR8IgypGgtcvPr8jxcH5aUfUSaPoAw0mKcwD+V7vzsT0QJWZNrNjVt5WPY5syh22Quftd/1xJsqaTo9I7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TUzgA59w; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TUzgA59w"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d9f0ab2313so1377a12.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Jan 2025 11:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737487024; x=1738091824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWZ21AesQg/I498ppJJkHkVAdVP9uJ8q5XJOQ8AZMK0=;
        b=TUzgA59wEi9TlfbR1gGegIw34AWM3sg4u9XeZKpos/cgkmuUPEIfxh73wkm1K/GpxK
         lt46+pu9UyJqAAj5yK2mB9D9DW78xzlxZvdj78hP4lOMs33jyG1CtDfLKPmSl6aDt+8a
         AWkqmUfz/um9WOsb15bQugHB0370FMKsp7fin+fm91fHC7dgaTvYVDWB74OKkGvdBpZW
         VaKmOHKq0KcfC1Ek5IBL+9ryOEzRIfXjCQVPaf9chOfksohtwD1sFx4aDK2/lP8ldLc3
         wzm5k/Lc8GHz2Sv7c8h3Rc2XMpZYnk+h01s6CMoln6YZKmXtA7GUDcj7KExewTNdkZvU
         TAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737487024; x=1738091824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wWZ21AesQg/I498ppJJkHkVAdVP9uJ8q5XJOQ8AZMK0=;
        b=WAxksjfdQSfyYolj1EnETlRss5pvT2841vdRSM0mvizeyvrScQhjh327K3y1muNOAY
         2lQyzH7X04sBuiFyTL/I8JwXieL/8b5cDujQgl/iNb6sAU2pnWFgk1L6ZGwHCcpR4gja
         xaV8foeKM4khS5gJV1bWUo0fjZupRYU1+RH3OowiLzmurSQ1PLkzaaLnwqJOBYhqfECi
         8HaevoE52L8vN5ianvNIlbITpx6oEKOIbsrTkoV4YHyGRv9IaFuxcJVubJwiItKGT9G6
         lz/k7/HbPKoAr8rUXPaij5O7rnJcNw6k/yDbbQ3iWQ8xVp4ha0TNwtBxlnH2AEu6okQ2
         TWEA==
X-Gm-Message-State: AOJu0YxDiNHZJ4iaSxgYWEHBR0lJTs8ZVLy1fp8GbXEXtZ9kcANXcIBI
	4JQc0pyCPjvzQ8CR95OTmVHUTRMZbXthbOkeFaKR93h0i/qpVE7m9hyrYh1m0I0t9Be8N5lUpjh
	oRITpcxqlKQxC7sydoGB8WhvaQwfhcxDthjUE
X-Gm-Gg: ASbGnctucYUyhCqIOK5zJvqghb533jwtZtNk528pND5m+6CrsDkQmke+HhT30SQTNor
	QYJklB2Io3pcn5k6QWv4rYgZAT2tINeY+kqM74N8pWWguAD5q1lNNPA3xay1pUVsIYxAmh3sm7z
	iSz7w=
X-Google-Smtp-Source: AGHT+IErqyWzmemXVd1nAV0ZZ28xFQBN0gYTCHzluFhRcPh4XKI3Mq2GsI9pWQRTisPIErg2ogP0lorkHbusKOhg7f4=
X-Received: by 2002:a05:6402:175a:b0:5d0:eb21:264d with SMTP id
 4fb4d7f45d1cf-5dbf31ba89cmr3476a12.1.1737487023836; Tue, 21 Jan 2025 11:17:03
 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez3_ROkVPgh2CDqL26RdVgfMJvgtmDHB5FMSdrQ7-POeHg@mail.gmail.com>
 <cj26hlynh6wiluvn5cg5qdzlcpxxyjirzgr3oho5244k7xzy4v@3p433x77w7nf>
In-Reply-To: <cj26hlynh6wiluvn5cg5qdzlcpxxyjirzgr3oho5244k7xzy4v@3p433x77w7nf>
From: Jann Horn <jannh@google.com>
Date: Tue, 21 Jan 2025 20:16:27 +0100
X-Gm-Features: AbW1kvact_5QdpY82oieGVMKhJw0_nU7WgrphGqtnH4InqfjL3R4Z8FKgLaob38
Message-ID: <CAG48ez0NOpCp1HkD55v8QCmjmhrd0b+G-u8XtyVt=K2pTJRuFg@mail.gmail.com>
Subject: Re: kernel build error due to large stack frame in __bch2_str_hash_check_key
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 7:01=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Tue, Jan 21, 2025 at 05:01:26PM +0100, Jann Horn wrote:
> > Hi!
> >
> > I'm trying to build the mainline kernel at commit
> > 95ec54a420b8f445e04a7ca0ea8deb72c51fe1d3 (upstream git master), but
> > the build fails with the following error:
> >
> > ```
> > [...]/fs/bcachefs/str_hash.c: In function =E2=80=98__bch2_str_hash_chec=
k_key=E2=80=99:
> > [...]/fs/bcachefs/str_hash.c:295:1: error: the frame size of 2400
> > bytes is larger than 2048 bytes [-Werror=3Dframe-larger-than=3D]
> >   295 | }
> >       | ^
> > cc1: all warnings being treated as errors
> > ```
> >
> > I am building with "gcc (Debian 14.2.0-3+build3) 14.2.0", using the
> > attached kernel config. I think this used to work with the mainline
> > kernel before the 6.14 merge window opened.
>
> Well, your kernel config has something that doubles stack frame size,
> it's 1200 bytes here.

It does have things like KASAN and lockdep enabled, it seems plausible
that that could bloat up the stack frames quite a bit.
