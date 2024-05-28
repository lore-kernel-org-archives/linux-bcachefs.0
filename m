Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7423516ABC1
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716896215; cv=none; b=gJvzapUfG+d03BOdCjtWre3H3zIFhrbgKNQUBweYEtlc8wk92W3uHf5MzlArCm3m8G0KWDgQpGdejYyCQ4AR17APKA3wDf8iz721RMsMEIvBJRvzlw9n7hRvNG+HDUWIBGVpDIlLO7cavz6ZwJfbJ3D9cAWB3cW16RjXyiM9efE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716896215; c=relaxed/simple;
	bh=M0MaGrmyVgPDZ5O+a4ObngblY3U7Ng60oW1EiVKZdNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VW+Yld+OX/0SuzyHp7dq5G/BJjW64xByzUOL6voSo8GHAAGW8RjpNLdf3Yrw3MSwgOj310PBQxA0+8F1Hwl19YcFaoM4J9fAW2p5lDd5Lvo4MWKZn22uIOaNT1ziQYFa8+rIIQBEbnsOXu6JLhUxaXDQv2u7HDt1zRQlSgRL8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v4i+jrAp; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v4i+jrAp"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6ab9ce75777so3926456d6.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 04:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716896213; x=1717501013; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+fy7bxhmTSYRqmL4m3IRHCvKHkrSDKxVpOHKJ74CWc=;
        b=v4i+jrApphkfH7mcoJKI5zVjB4itgKSGZ2HFlkTD7h43d56AyRZq3dltB/wJ0IAh+E
         cpIidJBaGW6SkbWx3lRACVkNXrHKlk77GQdLzBHDdu9uHEazyYA4qMWxCVv6v05/Bypg
         PO+zf+ggzh4C8GGEK2UDbHu461Yf7CpQVztYPCXHpbInUFGkkc7NLVSW1iLv0COcXHFH
         SaKhx3EcEIaxcjJmtZbsBbBFqa9vK8+JymgrK9DZa/yWz0OaiYL0JGofLtqgAREm3TpV
         EFCCwIqDTNEmJSeisn3DjZlGbfC4DUhX7doQKqB93Up12YmM3bpPaIUzKUsY8hsMzgUz
         uNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716896213; x=1717501013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+fy7bxhmTSYRqmL4m3IRHCvKHkrSDKxVpOHKJ74CWc=;
        b=S06UdqWWXwFr/tO0GqULboGh9a6JReqaur5s6TbydrDz6rqoKacx3KnloMpcv6Lmbg
         J55N9TWmMt6scNCNICWDK6je59cqFg8y149Q8f8+rHAci0mX723GnibdoY/CgvpZpxoZ
         R+XAc0AOarJKJyC8ZMmUjb/D2yLk0XrZjzlvT6xjijKqCXy5zgNHCwU6fbSWKZrmzLM+
         yDyQA2mfadYEIbG9ISYgAkFlhYTfUiv+IW6O+6ICW60rAAjMEV0BxK5ZAmYYtLJ0TMVU
         QUAHd5s/WjwEVIJGdz/4N8+g665CWKmN9kQsDN1nOWH9cZJKv/Zfz47Fl1o4Qi9oMkh6
         9ilg==
X-Forwarded-Encrypted: i=1; AJvYcCUUl8WK+ZMPw70ZVkrTkqNIgPpru1zhqVMbWbcEbnqL9U5i/Dcz/wB54vonaeYMinjJZogT1m7rdToJ/NK7ZZ+9hN+/D6VPZmmJfqoyVl8=
X-Gm-Message-State: AOJu0Yw8X0bPM065Jx8soS8hUJlrmGnYkJbDTjtflCMBWYHBpy7T9dEB
	miqoAaMCS9w5GW4T8AEJdsx6FeHQ2eQsMVPEktamRzz+g0nU7XBsMeTMz9G2QACjrqulR8LeSAA
	trygAquQFjrqXhqk3KvBwnycdW7LMbaDi5gS1
X-Google-Smtp-Source: AGHT+IEg6PbfYyP0aS02Mv0srCCx6EfAtwyybRhD4r3hX01VAgUGGxblt8OUbvO4llpryD8LyAH3/0ceqAYcq/6J4a4=
X-Received: by 2002:a05:6214:4602:b0:6ab:92b7:5903 with SMTP id
 6a1803df08f44-6abbbcb0b35mr137433736d6.21.1716896213239; Tue, 28 May 2024
 04:36:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <986294ee-8bb1-4bf4-9f23-2bc25dbad561@efficios.com>
 <vu7w6if47tv3kwnbbbsdchu3wpsbkqlvlkvewtvjx5hkq57fya@rgl6bp33eizt>
 <944d79b5-177d-43ea-a130-25bd62fc787f@efficios.com> <7236a148-c513-4053-9778-0bce6657e358@efficios.com>
 <jqj6do7lodrrvpjmk6vlhasdigs23jkyvznniudhebcizstsn7@6cetkluh4ehl>
In-Reply-To: <jqj6do7lodrrvpjmk6vlhasdigs23jkyvznniudhebcizstsn7@6cetkluh4ehl>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 28 May 2024 13:36:11 +0200
Message-ID: <CAG_fn=Vp+WoxWw_aA9vr9yf_4qRvu1zqfLDWafR8J41Zd9tX5g@mail.gmail.com>
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
To: Kent Overstreet <kent.overstreet@linux.dev>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Brian Foster <bfoster@redhat.com>, Kees Cook <keescook@chromium.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, linux-bcachefs@vger.kernel.org, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 24, 2024 at 7:30=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, May 24, 2024 at 12:04:11PM -0400, Mathieu Desnoyers wrote:
> > On 2024-05-24 11:35, Mathieu Desnoyers wrote:
> > > [ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]
> > >
> > > On 2024-05-24 11:28, Kent Overstreet wrote:
> > > > On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wrote:
> > > > > Hi Kent,
> > > > >
> > > > > Looking around in the bcachefs code for possible causes of this K=
MSAN
> > > > > bug report:
> > > > >
> > > > > https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@google.=
com/
> > > > >
> > > > > I notice the following pattern in the bcachefs structures: zero-l=
ength
> > > > > arrays members are inserted in structures (not always at the end)=
,
> > > > > seemingly to achieve a result similar to what could be done with =
a
> > > > > union:
> > > > >
> > > > > fs/bcachefs/bcachefs_format.h:
> > > > >
> > > > > struct bkey_packed {
> > > > >          __u64           _data[0];
> > > > >
> > > > >          /* Size of combined key and value, in u64s */
> > > > >          __u8            u64s;
> > > > > [...]
> > > > > };
> > > > >
> > > > > likewise:
> > > > >
> > > > > struct bkey_i {
> > > > >          __u64                   _data[0];
> > > > >
> > > > >          struct bkey     k;
> > > > >          struct bch_val  v;
> > > > > };

I took a glance at the LLVM IR for fs/bcachefs/bset.c, and it defines
struct bkey_packed and bkey_i as:

    %struct.bkey_packed =3D type { [0 x i64], i8, i8, i8, [0 x i8], [37 x i=
8] }
    %struct.bkey_i =3D type { [0 x i64], %struct.bkey, %struct.bch_val }

, which more or less looks as expected, so I don't think it could be
causing problems with KMSAN right now.
Moreover, there are cases in e.g. include/linux/skbuff.h where
zero-length arrays are used for the same purpose, and KMSAN handles
them just fine.

Yet I want to point out that even GCC discourages the use of
zero-length arrays in the middle of a struct:
https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html, so Clang is not
unique here.

Regarding the original KMSAN bug, as noted in
https://lore.kernel.org/all/0000000000009f9447061833d477@google.com/T/,
we might be missing the event of copying data from the disk to
bcachefs structs.
I'd appreciate help from someone knowledgeable about how disk I/O is
implemented in the kernel.
