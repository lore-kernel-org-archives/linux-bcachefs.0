Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5445B2E3F9
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 Feb 2024 04:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707365956; cv=none; b=gANAtGwJ1YcR7BCnyy32jOLCS6LZEHR5SW12fJaVHlmCX/NHfpilIqN2eXf6oiT685ekhLlj/2whFFP9NBhehWLR3dFA9v6uJC3+lkv9UoxPoiCIFzYOF4MmDOSccbhVAFfFLi9gpqKXKPQiLJPBKlDYhJb6BmmnrsaDsM9COUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707365956; c=relaxed/simple;
	bh=NGGl+yhBQ3UuLPGGYs/icqIBUq5Q0ZOnWSdq8ZZ3yNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCyavw8oXtlw0piGnxUzS7SV3CvO6o/Uwj0bj28BmfTTUYbKJECYKcR+B5rSXQFyw+MVA17s3Qi4Y3sdrESb5yCGEoEghFZVM+dIZ7VdYf+J9pGE/Vnr88rHodPiOkkeUCI2leAmtAa2xmkqV/+S5SwBgIoXYGwLAlhSfFyBIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=Svov09+P; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="Svov09+P"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-604a05a36d2so8350697b3.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 07 Feb 2024 20:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1707365952; x=1707970752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6Rsu7zMx9101ReVRLly7pW/OCnK9YhpRRktI8iHZFI=;
        b=Svov09+Pa+DWOjlAMNKp9qeZ1xJoPtmNqbnuaGVwezsEOv7YtXYWkDCY6RDe/RjotS
         OhpZaZ3MSajD/FY+pAcWmAERoivq30GQ93VNafsPDyS08LyLpAzOR4TVr1yw7oYjb4yT
         g1iQrSEpgOorJyJorME0z2nDtczHixMNmpjvyUVEzdQv1AkH3NgsXTnfMrE6shn6C40r
         MBoCn3zLKgry46NZFZrmxEapC8rv+uZ0f17gMxsLQL4VMGSxv6ABkh9wlYB2rvXryNac
         3AdP/v91GAlW/19gnsiQbQs37msJiV9cxkJlT3Nl7hppXkLck7TTxD54ODRaTTj7kBWE
         xyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707365952; x=1707970752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6Rsu7zMx9101ReVRLly7pW/OCnK9YhpRRktI8iHZFI=;
        b=dqKWGfr3fs5oenurKMEZ0HDZKWwzoyEZ8GUZvCcn9ZrbN9/9j440ZRxWnSaMsNzqqF
         o9N+apib4LHadZ7bljLNAcztv/KyZZ/KelZaL1O1+Selp6GIsw6C6ElKgudKseXmUMj+
         WXPaZoLzKd2xBk8b13mcWCHraSU6+KERjifUJKVkCZlpL/jtEph4L7J98TwycvesyMIF
         ACrG+uOgAewP8t9k/zPtv5zRpzwzEWPGeI9HFqnz/PyoMtXbhX9rlFP+SrT/M8Eu+ocj
         Y6J0LKLNWMiUBS+ddLdVMWy6iYtkvsPX0Tii8+6Q2Np8D2j7QLx+dI921pVPQbV8vgYL
         6lQQ==
X-Gm-Message-State: AOJu0Yw97tTaIumztG+5hQ4U2lXqpUY5halYkAlWBrYtE8lE59PHN5zK
	cMSfDXyDA32MNqFoPkPOe099ZV0OipndFjtcVnBdP24oUBslg0uo/jx4OrwnF/VgogSIW3zutL1
	SE0vZVSzsU15K0g0IuXzr+TUKjSko/y8u04OHoQ==
X-Google-Smtp-Source: AGHT+IE23A27tLG6Zbdgze019TxOSOcO6pq7eWFrGwYWhqlbeni3gNe7Qel902A26fgZTDZqrCIeQ/H4+LhEAwmGhwQ=
X-Received: by 2002:a81:d306:0:b0:5fc:b5d4:f1cf with SMTP id
 y6-20020a81d306000000b005fcb5d4f1cfmr7446477ywi.35.1707365952128; Wed, 07 Feb
 2024 20:19:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207055558.611606-1-tahbertschinger@gmail.com>
 <CANiq72=00+vZ+BqacSh+Xk8_VtNPVADH2Hcsyo-MPufojXvNFQ@mail.gmail.com>
 <qo637rxuw5tcskmgubutpe6dfmhhms4d4pjivzhewl5tpg3eth@xil6gpcvdiya> <20240207223927.GM6184@frogsfrogsfrogs>
In-Reply-To: <20240207223927.GM6184@frogsfrogsfrogs>
From: Trevor Gross <tmgross@umich.edu>
Date: Wed, 7 Feb 2024 23:19:00 -0500
Message-ID: <CALNs47uR5ab_dm6ryET4ZkL2nj=ykhGYAyjB6FY4skBZhKqmKQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] bcachefs: add framework for internal Rust code
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, bfoster@redhat.com, ojeda@kernel.org, 
	alex.gaynor@gmail.com, wedsonaf@gmail.com, masahiroy@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 5:39=E2=80=AFPM Darrick J. Wong <djwong@kernel.org> =
wrote:
> [..]
> Which architectures are supported by RoL at this point?
>
> I can't speak for kmo, but bcachefs is new(ish) to the kernel, and
> restricting support to the five major 64-bit arches (x64, arm64, ppc64,
> s390x, riscv64) might be quite a load off him and his team.
>
> Just speaking for myself, where xfs gets occasional weird bug reports of
> strange behavior on platforms that none of us can test (csky) or OOM
> reports with multi-TB filesystems on m68k.

6.7 only has x86. Loongarch is in for 6.8, aarch64 [1] and riscv [2]
shouldn't be too far away, and there has been some interest in the IBM
targets but they haven't sent anything yet.

Any of Rust's tier 2 targets [3] should be reasonably feasible to
support at some point if the maintainers are interested. csky and m68k
are both tier 3 targets so less likely anytime soon, anything more
niche than tier 3 will need GCC support. Which isn't terribly far
off...

[1]: https://lore.kernel.org/rust-for-linux/20231020155056.3495121-1-Jamie.=
Cunliffe@arm.com/
[2]: https://lore.kernel.org/rust-for-linux/20230307102441.94417-1-conor.do=
oley@microchip.com/
[3]: https://doc.rust-lang.org/beta/rustc/platform-support.html

> > > Instead, to bootstrap things, what about writing a bcachefs module in
> > > Rust that uses e.g. the VFS abstractions posted by Wedson, and
> > > perhaps, to experiment/prototype, fill it with calls to the relevant =
C
> > > parts of bcachefs? That way you can start working on the abstractions
> > > and code you will eventually need for a Rust bcachefs module, without
> > > limiting what C bcachefs can do/build for. And that way it would also
> > > help to justify the upstreaming of the VFS abstractions too, since yo=
u
> > > would be another expected user of them, and so on.
> >
> > You mean a new, from scratch bcachefs module? Sorry, but that would not
> > be practical :)
> >
> > Wedson's work is on my radar too - that opens up a lot of possibilities=
.
> > But right now my goal is just to get /some/ Rust code into bcachefs,
> > and make sure we can incrementally bring in more Rust code within the s=
ame
> > module.
>
> Is the ultimate goal of the RoL project to build Rust wrappers around
> the C filesystem objects?  Or to design something more Rustic(?) and
> present the interfaces that the VFS wants to the VFS only as needed?
>
> I might be talking nonsense here, I've only started learning Rust.  But
> I /can/ speculate about what a Rust fs will need based on all the stuff
> I've learned over the past 20y of wrangling the C filesystems.
> [..]

The current approach is:

1. Raw bindings to needed APIs are autogenerated with bindgen
2. Abstractions are written on top of the bindings. These should
provide a safe interface where, as much as possible, you can't
accidentally misuse them to do something "wrong" (no UB by Rust's
definitions, plus a fair bit of functional safety).
3. Modules use abstractions, no C bindings directly

So Rust code is currently strictly a consumer of public core APIs,
which cuts off at the module boundary. No reason there couldn't also
be some core functionality, but there is a pretty strong goal of not
keeping duplicate logic between Rust and C. Just not much of a use
case yet.

It works out best if bcachefs uses the same model, so future code can
make use of whatever abstractions come along - at least for the core
APIs, I can imagine bcache-c to bcache-rust will look different. There
is a reasonably complete VFS abstraction available [4] (looks like you
know of this already). I keep a loose list of what is being worked on,
for any other interfaces needed [5].

- Trevor

[4]: https://lore.kernel.org/rust-for-linux/20231018122518.128049-1-wedsona=
f@gmail.com/#t
[5]: https://github.com/tgross35/RFL-patch-registry/
