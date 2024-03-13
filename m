Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88241A38DB
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 20:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710362900; cv=none; b=fBmr2S6Z1nv9bO8ZkgFsD8HKAYu4tM3Uj0RCZcYSE8xLmjfubXXf5CVQHy1cl+eWKb3B/yRDYFpuPXXDzViZDsdUwl9AnYGT5G/+xIpY3Cwxp1T/ztROc2iYvmxWI2go9hpo0waAuxhdzbRCeeKgE5j22TWMXjyrySfzZKC8eMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710362900; c=relaxed/simple;
	bh=Qs82lcXumefYXpExMq3K66hhPd5zaxuwF7JwqNXx9iQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t/98g8vYb39eJmP/UhSWoAVdUqnpt93ypMsdL6sWdq1g40P2xdJwE+bTjpcebAOGXPxhaZt5L+jOsZPAZ7MD8u49ulUwOco8Ek8T8flLkld0ST6ifOncNya4VzhVp/xKaMuEIeYfqIQMxLc+x3HIuU6Y6ZvcW2Ae3mmbXl5T824=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OF7EDGDB; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OF7EDGDB"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a45f257b81fso37049266b.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 13:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710362897; x=1710967697; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PPuXpkeGm2u0OvGSXHyAWpUcDKXz5BztlE6+aKXcrYM=;
        b=OF7EDGDBmmuyTKI5wyvojDoVQbgQkPFxMtFPvlzVtQMfv04STtxyHTCY6ZI0mt2frT
         1KimqT+tw1aJotnLGnPfqY0BAV3azV0zA6RPZ7Zc/FXC9NrvOgzcKahk/H9UgFdBkH9w
         kG408dtdZTcwDA5xO5NGhW1nGL5qIlsYayKGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710362897; x=1710967697;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PPuXpkeGm2u0OvGSXHyAWpUcDKXz5BztlE6+aKXcrYM=;
        b=artNc6I5bzypH4k5i1eOT03UvpMQv1iARoPIlwK4/gXeE2CIg3Eu8bMOVpHCveBLoc
         gbzBpIUO2TsKCnshPIgqKcHBrB8cwKkUxGMt8Av+SDPSTeog8dK7TkDwN8c0l+AH+I9j
         9W7bRyO5fXAPGiXALKJGaiWzXE/S/9Nl8BmOo6tryaXIauOqzhkMvCnoYcCMdjX0zHZD
         duHkxPFdykNEx5NnW9hjSw/GLcdKffjx61RxhU6HBSJr/GMMtzN8f8oJWrPXOLagGPLT
         WiMEaDrk1d++QgRCVs2p/3mYYlef6EYx6SmMEi3dUpHm6Rtonqv4D86rT+mwpNq2bQWB
         62qg==
X-Gm-Message-State: AOJu0YyNtHGF2pYeNPS1KodnN0rTNQ7B4aeCAwByO+gWwODq6t6DSstV
	QhcnQhVx4FFKkrUPB9kRRPLKxyEOox0coBRmnxZbB5gzyLG3HPa14SLULhwcFlXUwiqGA5Gd95c
	0zUCxKA==
X-Google-Smtp-Source: AGHT+IF8V1yj8tmQ5EsbxWQjoaOm+g4Dfhspwv28O1lsCUxpUsGvqtjXnSE2cHpMTYTNYM9l+M7Xng==
X-Received: by 2002:a17:906:3ad3:b0:a44:9fe3:d7d1 with SMTP id z19-20020a1709063ad300b00a449fe3d7d1mr7440869ejd.43.1710362896910;
        Wed, 13 Mar 2024 13:48:16 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id dc10-20020a170906c7ca00b00a465b72a1f3sm7247ejb.85.2024.03.13.13.48.16
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 13:48:16 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a46692ec303so35800566b.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 13:48:16 -0700 (PDT)
X-Received: by 2002:a17:906:dacc:b0:a45:e270:609c with SMTP id
 xi12-20020a170906dacc00b00a45e270609cmr11079476ejb.23.1710362895736; Wed, 13
 Mar 2024 13:48:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <lfypw4vqq3rkohlh2iwhub3igjopdy26lfforfcjws2dfizk7d@32yk5dnemi4u>
In-Reply-To: <lfypw4vqq3rkohlh2iwhub3igjopdy26lfforfcjws2dfizk7d@32yk5dnemi4u>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Mar 2024 13:47:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg3djFJMeN3L_zx3P-6eN978Y1JTssxy81RhAbxB==L8Q@mail.gmail.com>
Message-ID: <CAHk-=wg3djFJMeN3L_zx3P-6eN978Y1JTssxy81RhAbxB==L8Q@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs updates for 6.9
To: Kent Overstreet <kent.overstreet@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Mar 2024 at 18:10, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Hi Linus, few patches for you - plus a simple merge conflict with VFS
> changes:

The conflicts are trivial.

The "make random bcachefs code be a library function" stuff I looked
at, decided is senseless, and ended up meaning that I'm not pulling
this without a lot more explanation (and honestly, I don't think the
explanations would hold water).

That "stdio_redirect_printf()" and darray_char stuff is just
horrendous interfaces with no explanations. The interfaces are
disgusting.

Keep it in your own code where it belongs, don't try to make it some
generic library thing.

And if you *do* make it a library thing, it needs to be

 (a) much more explained

 (b) have much saner naming, and fewer disgusting and completely
nonsensical interfaces ("DARRAY()").

And no, finding one other filesystem to share this kind of code is not
sufficient to try to claim it's a sane interface and sane naming.

But the main dealbreaker is the insane math.

And dammit, we talked about the idiotic "mean and variance" garbage
long ago. It was wrong back then, it's *still* wrong.

You didn't explain why it couldn't use the *much* simpler MAD (median
absolute deviation) instead of using variance.

That bad decision directly results in that pointless use of overly
complex 128-bit math.

I called it insanely over-engineered back then, and as far as I can
tell, absolutely *NOTHING* has changed apart from some slight type
name details.

As long as you made it some kind of bcachefs-only thing, I don't mind.

But now you're trying to push this garbage as some kind of generic
library code that others would use, and that immediately means that I
*do* mind insanely overengineered interfaces.

The time_stats stuff otherwise looks at leask like a sane interface
with names and uses, but the use of that horrendous infrastructure
scuttles it.

              Linus
