Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960B858205
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705701636; cv=none; b=ccpVYz0Cp+zHt2Q0urIu/m+JvCwez3eXasknNF4jJxLR9aRu2mP/KbJkEI7e9jONqistWOjMHwfhdS0khhXKoN8BgfH7eU4axC/nzoFT511/kctoSDlIth4TMTWYBwb7watIKjacj+nTB6tX3w0Yy6tQb8I4M35VnZjWsn3NF6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705701636; c=relaxed/simple;
	bh=Xqh2spPXg/36Nd5acHIcaHi1wPMckOnZCFfqASQrpgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Us0Uzd1wShPZu3JDgXi6YPupWj+PyaUMVg+GA8Atx/zQawy9zEENB9HIKTNZQACSkU6hbOaoQzvswD+8daUq4sLRllx7p/7H4F+w61W9emgBE5+TunK9WEp2uSjlWSMzPv/w9SKrC8/kBzG4Kw9fIh3/fNzoLREvc+VNMWy42mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FXP9BOi8; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FXP9BOi8"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a28fb463a28so126859466b.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 14:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1705701632; x=1706306432; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/xlofjQtofHXFjo9khK5kC3pChLQbc+i5Psd0zeHygA=;
        b=FXP9BOi8lJxESl4aQoNDvBYdmNGftf8GHq4kmSUcVujGGSTLWLwMpmE2CcGvpgInhR
         8u014PV3juo9tNlK+V3DJ9BBPYTuvgwxBExSnRIZbiuLYh/yrU1teZ6KGJepiNrZUVW6
         EakghN4Rv4jwso9qObAvoFX4pF7R9H+87Ld/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705701632; x=1706306432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/xlofjQtofHXFjo9khK5kC3pChLQbc+i5Psd0zeHygA=;
        b=Ed4+zv8sD6+wB+nxDG905hE4uY7Uk2e5gea3Kpzx9GDMCCbQuk7bFjVRGHUuzTlX7O
         f/Hxf4HiG3gqEDIszJqoZRELArzR/6D/UjsGRsgiXr+1Ho2kWlECahGAsC5wU5y0yYsX
         j/A1c+l7yEUJB3NjrIC+IKvHxqAyCOTJN+6lTyaEX0/kAg92NM2KRDAXNDhhIU7iRoh9
         KYSFJCS6vcfz7rGItZJyLjHHGMWgq3g/9dze0LjXDiYs1f+snLB50KDDDk0NGjXfPt+I
         ksM0OXiupHkbpH0qDYA5akOTaxeaTqRl7FmMqe0TzUPuEftB0ILY9wlk9C91/tf/mUSq
         NxLg==
X-Gm-Message-State: AOJu0YzOgLt78CE5kVuWFnWruI+z1vflF6WXtYjf1uHoeD0yuT1aPyxw
	Mj4TmAGDXw8iKP7l6ok8Gii+ox9TVOYQfPPxiAQgdYeIKQX/osIne2CzV8hljulFmteaObd+UgZ
	NENBHog==
X-Google-Smtp-Source: AGHT+IH2lMvAlIXvtJQ+ydzusgdUUnv+1s6Mj6YP0zTp+Iv1i936D/JM5Eil9xwywzUvOIOxF6CEaA==
X-Received: by 2002:a17:907:a0d1:b0:a2c:189d:8707 with SMTP id hw17-20020a170907a0d100b00a2c189d8707mr306575ejc.99.1705701632658;
        Fri, 19 Jan 2024 14:00:32 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id fj21-20020a1709069c9500b00a2da3bbeb4esm7259644ejc.26.2024.01.19.14.00.31
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 14:00:31 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55817a12ad8so1477241a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 14:00:31 -0800 (PST)
X-Received: by 2002:a05:6402:28a2:b0:55a:590f:3464 with SMTP id
 eg34-20020a05640228a200b0055a590f3464mr186462edb.3.1705701630814; Fri, 19 Jan
 2024 14:00:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202401191311.B6AA79D@keescook>
In-Reply-To: <202401191311.B6AA79D@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Jan 2024 14:00:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj0j07B=n1Bt4EkDJpN5CBmxMuZhv+nnFdi0DxDVSiZAA@mail.gmail.com>
Message-ID: <CAHk-=wj0j07B=n1Bt4EkDJpN5CBmxMuZhv+nnFdi0DxDVSiZAA@mail.gmail.com>
Subject: Re: [GIT PULL] strlcpy removal for v6.8-rc1
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Shevchenko <andy.shevchenko@gmail.com>, Andy Whitcroft <apw@canonical.com>, 
	Azeem Shaikh <azeemshaikh38@gmail.com>, Brian Foster <bfoster@redhat.com>, 
	Dwaipayan Ray <dwaipayanray1@gmail.com>, Joe Perches <joe@perches.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 13:14, Kees Cook <keescook@chromium.org> wrote:
>
> The kernel is now free of the strlcpy() API!

.. still mentioned in docs and checkpatch. Maybe remove that too?

              Linus
