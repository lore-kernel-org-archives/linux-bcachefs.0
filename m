Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB30374420
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 09:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717406002; cv=none; b=uPEGxZPJleqjJh3Hz1f6scALH58ODqjPu4UB6mcTj0XNeE9LcVDzfS8yYIzQjTBtPEBz5nFFB7U/97ynv1U21kUTla4S2Ke1XFuoY3kr9ifxD+NOgGaw/NVv2sqVlGjn2crWzNgCNK/Uml/BfqPr1TZk0lSfx87iZHVxa8ATFQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717406002; c=relaxed/simple;
	bh=UUJ/u6Jum1hxyaC0tZphU6l6+SwdIUNR2yTzwcgGj/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PL/IgQyRbECboHwW+AKoYmFowyk6QZc3mNFULIK2yhsBe1Exkvho5GSFlF1Ab+lNgWYyn6qIOlvUc8LaDXZK7gT8lXNn4qNJwk9F8UaSED0r/x83Jrs03eKmmK2O90HMEWZwGQsYdTtgxPOcfBkmvLjq4pd6T86Tpv+TmldDEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rfxWJskT; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rfxWJskT"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6ae0c4d23ddso21542306d6.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Jun 2024 02:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717406000; x=1718010800; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vAMkiFmM1PgwLYJXTqfVoK4qXe/84aecwt6VcYF0jA=;
        b=rfxWJskTSDCjrh3h2nieV04ArG3TlS5BRqvP+JgxVAya36/qLIr3yB6yDaY6kY1dxw
         pARM7nbF9rEg8EpA5fh/r//yOD7PGRVSYZtv4c0X3mQsxJ9Le+AlQm4YW4aeNsYeuHre
         q2n7KOvfjOGdNcaq3FWgiNUd9A8T8kKEJk4vFKlPdaLXoMU5IovFnijKh/NFOQn0LK/u
         wCW6fn2PSY7OOdnqf2uU3reVFL7FCG+JOwnDGMqD7VEUtfu1yM40NJfAGYjFNlBz4EdN
         LC6Tmz1+SnvsjCTKYXiW4AC67xjPNZCktT2zbmnMiZ3FIW/tP746UvTnCy5s2IFtddtY
         xzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717406000; x=1718010800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vAMkiFmM1PgwLYJXTqfVoK4qXe/84aecwt6VcYF0jA=;
        b=fTvJ6XwITBuH+85s+svkL1Y0QecJl3VcLJ4H7wnbDdac1ni3dxrd19WHbHorj127a5
         cpafpr8l3rz8Au297XMB3Nf1Fs3OwL534DjBODHKPzT8Ww0MygC8JE3TlwjPQcyl/V8L
         lhpzaxdpgPW4+E5Znt30fdijsQPH6U+43NMThKVh24wBzkxqUt8ZCTa1ZQ+ljMXHsLDy
         MDYv+kShaZCP8g1JFKR7YIDjMZUpRY8KfsSUnZeAz8tTnVXV6QJWAmbBWyy/o+c6qlLe
         nEu76wJ58zgV9NopHAMpGvm59rN9bheJfuM/MijLeZg59DU8oITRHhAQP3tl0OrQozxC
         Ge1w==
X-Forwarded-Encrypted: i=1; AJvYcCV6pzmS3RiFwSHJP+maJG3RrKx/sPKCUlYYMnmkGt5zjUxllRWf2gdqwlSTS0N5XFw7H5Y2gSjPh7T7ZlHEBQTVSPqUylTINDxm7+gVhqE=
X-Gm-Message-State: AOJu0YxQwKxMly4ZMoS0p7hyw8ATqKpyHyN5ziuc1Zhtzq9D+Fg7V/0N
	6oTtJy1IcNCtuOEQ4EdBOacrQyUq9xbnEIrnTbly1ofTtktD1CwpjrGQ4JW2JAWV6gy7HFe5M5+
	AtUPNPsblfeXQrzU6iQMZ4aIJ2gTgJonrqxSQ
X-Google-Smtp-Source: AGHT+IGqq0cvFr6S2FwTQ2uRwFai5j3ZKERTTAH2hrIr3+mXsUbWQBgzIzKF98yyF10YV36n4zlwP7k6cd1/9ppj1ok=
X-Received: by 2002:a05:6214:5890:b0:6af:c308:ee31 with SMTP id
 6a1803df08f44-6afc30938f9mr25119606d6.49.1717405999358; Mon, 03 Jun 2024
 02:13:19 -0700 (PDT)
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
 <CAG_fn=Vp+WoxWw_aA9vr9yf_4qRvu1zqfLDWafR8J41Zd9tX5g@mail.gmail.com> <63zx2cnrf5u2slmabde2wptxvq6a3opvrj2zrkcolw3gdkjdpf@bttdonbctura>
In-Reply-To: <63zx2cnrf5u2slmabde2wptxvq6a3opvrj2zrkcolw3gdkjdpf@bttdonbctura>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 3 Jun 2024 11:12:37 +0200
Message-ID: <CAG_fn=W86C4F=nqYqrOCbNgioN5QjOrMjmU9jXYmx-fnZXQXag@mail.gmail.com>
Subject: Re: Use of zero-length arrays in bcachefs structures inner fields
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brian Foster <bfoster@redhat.com>, 
	Kees Cook <keescook@chromium.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-bcachefs@vger.kernel.org, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:02=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Tue, May 28, 2024 at 01:36:11PM +0200, Alexander Potapenko wrote:
> > On Fri, May 24, 2024 at 7:30=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, May 24, 2024 at 12:04:11PM -0400, Mathieu Desnoyers wrote:
> > > > On 2024-05-24 11:35, Mathieu Desnoyers wrote:
> > > > > [ Adding clang/llvm and KMSAN maintainers/reviewers in CC. ]
> > > > >
> > > > > On 2024-05-24 11:28, Kent Overstreet wrote:
> > > > > > On Thu, May 23, 2024 at 01:53:42PM -0400, Mathieu Desnoyers wro=
te:
> > > > > > > Hi Kent,
> > > > > > >
> > > > > > > Looking around in the bcachefs code for possible causes of th=
is KMSAN
> > > > > > > bug report:
> > > > > > >
> > > > > > > https://lore.kernel.org/lkml/000000000000fd5e7006191f78dc@goo=
gle.com/
> > > > > > >
> > > > > > > I notice the following pattern in the bcachefs structures: ze=
ro-length
> > > > > > > arrays members are inserted in structures (not always at the =
end),
> > > > > > > seemingly to achieve a result similar to what could be done w=
ith a
> > > > > > > union:
> > > > > > >
> > > > > > > fs/bcachefs/bcachefs_format.h:
> > > > > > >
> > > > > > > struct bkey_packed {
> > > > > > >          __u64           _data[0];
> > > > > > >
> > > > > > >          /* Size of combined key and value, in u64s */
> > > > > > >          __u8            u64s;
> > > > > > > [...]
> > > > > > > };
> > > > > > >
> > > > > > > likewise:
> > > > > > >
> > > > > > > struct bkey_i {
> > > > > > >          __u64                   _data[0];
> > > > > > >
> > > > > > >          struct bkey     k;
> > > > > > >          struct bch_val  v;
> > > > > > > };
> >
> > I took a glance at the LLVM IR for fs/bcachefs/bset.c, and it defines
> > struct bkey_packed and bkey_i as:
> >
> >     %struct.bkey_packed =3D type { [0 x i64], i8, i8, i8, [0 x i8], [37=
 x i8] }
> >     %struct.bkey_i =3D type { [0 x i64], %struct.bkey, %struct.bch_val =
}
> >
> > , which more or less looks as expected, so I don't think it could be
> > causing problems with KMSAN right now.
> > Moreover, there are cases in e.g. include/linux/skbuff.h where
> > zero-length arrays are used for the same purpose, and KMSAN handles
> > them just fine.
> >
> > Yet I want to point out that even GCC discourages the use of
> > zero-length arrays in the middle of a struct:
> > https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html, so Clang is not
> > unique here.
> >
> > Regarding the original KMSAN bug, as noted in
> > https://lore.kernel.org/all/0000000000009f9447061833d477@google.com/T/,
> > we might be missing the event of copying data from the disk to
> > bcachefs structs.
> > I'd appreciate help from someone knowledgeable about how disk I/O is
> > implemented in the kernel.
>
> If that was missing I'd expect everything to be breaking. What's the
> helper that marks memory as initialized?

There's kmsan_unpoison_memory()
(https://elixir.bootlin.com/linux/latest/source/include/linux/kmsan-checks.=
h#L37).
include/linux/kmsan.h also has several more specific helpers for
various subsystems - we probably need something like that.
I was expecting kmsan_handle_dma() to cover disk IO as well, but
apparently I was wrong.
