Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236D56745
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705691131; cv=none; b=mIhiv9bie8haKbrFctmxTHradHGVzw3kq7ssPYaC2mx7l9+9dxHIRMxHReWIzozCR0cwXiIKtNVT4/aY2P1LDA9QOUXj3GZ90qvbXjfONxqB7kfWrTnXyGG9onjqzfwMBjuXShmmw0wQ6z7iFOzILDy/kNpeTFsFYwQKwGEow7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705691131; c=relaxed/simple;
	bh=Dv3AKUp9mbZLCqHHcZN6aA7o9Ua0jZarcVy11aFogys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nHyHpwI8/rr8Didgf5VGbb6at8GMxKkD8gdS1MQ6s9xDbC2Jm2O8DhIvxSd2KMJqCFhXH3aCNqNFDq1dzL3lFTYaJUfG/fwmQHGuU2gN5YY5UifL1xvusZjmB/rk0JqDlhih2B+pXulPtfiJRL+HoVJXqSQYsPT0gZSkyo6SNRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=U8oul7eb; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="U8oul7eb"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-5f0c0ca5ef1so11395047b3.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 11:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1705691128; x=1706295928; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dv3AKUp9mbZLCqHHcZN6aA7o9Ua0jZarcVy11aFogys=;
        b=U8oul7ebgW1gli+UqF4RtBK9JXpntiTkh0NET0aYdEN2SaNx8KDgk/QF7WluqdJ9UE
         /cMIsQXN8ThsFuMS7pJPHuJEbNmfQOO5C1NuqpsdEYCViyz9uj1HHfOryQKfFn1EbY+p
         qneNKnT8S1Wspxb4R0WgWkC+sGMXteMpqet5tzTyxP4pIrfkake0Y6bzrr6S6lB6HJ7T
         vWCWr07zLktVzGGlq/kU2SHpYu3h63VDN3Ojmov2xJAcJZv06m7aJFii39hbdYF9eWnr
         Uh18CNHmoq/xJ5TJchwQDUKWl5YxFQsv5t+6iPo+eISQbGPKBhGbg8MJppNawxs2biWc
         dZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705691128; x=1706295928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dv3AKUp9mbZLCqHHcZN6aA7o9Ua0jZarcVy11aFogys=;
        b=Ph1jlsMqvK42QgMhqcT+ejoll4oWj7mmAzhd7MfJ+HCuaNqZ6MHPi/B8onk20hKm0a
         8f8OxxQZUKcLjDtpTX5xvKtLIF4HAz54AImhmleBpzn22WwvQ81mVTBOMov00SjTLg+G
         BFtUUblZAF7ilbvtTAY1XLFdtU+rea3eDCdMx+ML39Bkw0LLDW9c0c5R84XHSg9NHH/B
         t9102lgBVop/9NGLIWrh05ixnKlOyKqEaMikaNGLudn+im/SmF5Sm/8xC+t7e2+gZCS4
         ZImoXILQfLN2qzMYKqx9tb2hJRpNOT2dufCHP5irEUcY20ipYk/4XgVE9QW3oAzdt+Z7
         s8Kw==
X-Gm-Message-State: AOJu0YwQ0TFP4YmweuUCaSo6lRGKUfYcVjRvzxYIrPpZYAWgxsQVL5VB
	8h7AwKTTeViQhzWtSNiyoV52hlV39xnOSuybJoXsl6qO7u+EstfxEOlZ3gh+t4v4hII7OAoq/4t
	M2bLRUey4b67HiKbiCXoc4FkAmHWf4qR2iBbNUQ==
X-Google-Smtp-Source: AGHT+IFEtiDHLie/I5GCf60H90tgsZGXreXdh8cYWtzorAUnHqVop0/IV4mf/+HjXVenA3nTnnZ+KYXfOHHsHSvx2RA=
X-Received: by 2002:a0d:cb85:0:b0:5ff:5e94:277b with SMTP id
 n127-20020a0dcb85000000b005ff5e94277bmr404871ywd.45.1705691128652; Fri, 19
 Jan 2024 11:05:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop> <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop> <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
In-Reply-To: <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
From: Trevor Gross <tmgross@umich.edu>
Date: Fri, 19 Jan 2024 13:05:17 -0600
Message-ID: <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
Subject: Re: [PATCH TOOLS 0/2] convert main() from C to Rust
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, linux-bcachefs@vger.kernel.org, 
	bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org, 
	Benno Lossin <benno.lossin@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 15, 2024 at 1:22=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Mon, Jan 15, 2024 at 12:10:22PM -0700, Thomas Bertschinger wrote:
> > On Mon, Jan 15, 2024 at 01:45:22PM -0500, Kent Overstreet wrote:
> > > On Mon, Jan 15, 2024 at 10:55:09AM -0700, Thomas Bertschinger wrote:
> > > > I'm leaning towards keeping Make as the primary build tool for now =
and
> > > > perhaps a future patch can move towards using Cargo. But other opin=
ions
> > > > are welcome.
> > >
> > > Let's hold off on that for now.
> > >
> > > I'm planning on pullling the Rust code in bch_bindgen into the kernel
> > > soon, and I want to see how that interacts with the kernel build syst=
em.
> > > If there's potential for commonality with the kernel build system, we
> > > might want to take advantage of that.
> > >
> > > (Also, if you're interested in that project, let me know! Getting tha=
t
> > > ready for the next merge window is a high priority item, but I have a
> > > lot of high priority items at the moment... :)
> >
> > Sure, I would definitely be interested in helping out with that. I don'=
t
> > want to make any promises regarding timeline, since this combines two
> > worlds--Rust, and Linux Kernel development--that are both still very
> > new to me. But I can certainly give it an honest try :) as long as you,
> > or someone else experienced, can help with any questions I might run
> > into.
>
> Of course :)
>
> Join the IRC channel - irc.oftc.net#bcache, we've got quite a few people
> acquainted with Rust there.
>
> The main thing that needs to be sorted out is that we require a patched
> version of bindgen (since rustc can't yet handle types that are both
> packed and aligned); we need to talk to the rust-for-linux people about
> whether they'll be ok with switching the kernel to the patched bindgen
> until we can get a proper fix into rustc.
>

Do you have a link to the patches needed? We are wondering if this is
something that could be upstreamed.

Miguel found [1] which seems to be the rustc fix but I am curious how
you work around this.

[1]: https://github.com/rust-lang/rust/issues/59154#issuecomment-1899563996
