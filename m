Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD31D1747
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 23:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729122093; cv=none; b=ZN/zhg78ftGbvlhpGHt5IqA7AV4v41QxRwP/IoIeSzu4dL8vQbwreFQhmX94lqcLwzqYej0/xn48QHbMSeoh72zfTeLrMjlVn0ltTiXR25TndJWNzeIBXu9hwTe9RV5PAdlToA3wNt0HW3Xrheq4wanxI3mlHeTuHAcpdA6HnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729122093; c=relaxed/simple;
	bh=RRswTXU4k/AnzFdLQe+coTcUgPkoL6Vo+dUI8tc4lAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l03wzDgUho6zO1fwF/n8l9YWBQoSzBtxxsVVylwVnihD3L5E2t6+U5muOGZgW/bljMZ9E0hpQuyRCImwl+qd9kLq2I29eq2U8DkqTG1o7OxlswWNYmqL0k8VwAkSzo5MyVHhhByThcdulV7aATaGuWMoj+xbKNYTIrHBagDujtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JVl34fek; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JVl34fek"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a99f629a7aaso59506866b.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 16:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729122090; x=1729726890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3BEZJUSML+8CSCJJzTyo8d6sATot5pW+Vdg7IEDfwPQ=;
        b=JVl34fek3RyPr7fft4WoesHhzaEirOIeuRJtEKyNM5ZvgUdTkNR3WPdyxpw13g5VUK
         Cl0463c9HF7JjGD6F0OAMnSRF55THFB+y89wPoa/FGrRfD6lMYUt/QKC+UFrl8MBcLZf
         0LFbbd8vo7ebRaZw0D8EZykd2G/rholTRzwrLZcTgEQmEe+TDsUJWT36dKsjlLCL3M6w
         nmTqmZsbl4ZmD+EJ+URXohYvTzXAt/Y6OFHCmihkXHSuY2vXBvFYoPY1nW0eGZF2PSFN
         irYD1gYrebiNouFtadD9eUCzcoEPoLFO2uSjw0QJSEBzNSb8vxEBMwpnxnfVBgGcRi/b
         oRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729122090; x=1729726890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3BEZJUSML+8CSCJJzTyo8d6sATot5pW+Vdg7IEDfwPQ=;
        b=OHMYleWGGgqp+ISIItYoGjVT3lvee9CIwWyIkcS7Ox6SLnYqVykihaSZ5PWHzJ/Rj7
         GpW6nS7kXRRtipRl1ZxilQ09vvPlO48fM7pAKl5OLeHe8iwnSuGTfa1NBTE3MInYix7u
         f32TZeVjcxtdh21dG292eRGXaLdDegA6AnBUmF06LzBpXwACRK6Wn45X674QnDo9S3zI
         bK3BWrGBD/ExIFASEYWDonQNPnw4rn1Jyy+HA+OaA+SaD8oNV8RrXdXSM8qcSKrrGkgt
         R0p/xdynAP3H7a0aWBrUPoRw9Sx+T1xwvwFsDb7fsU4TWkB4DBcs3Rzgaov4TSskCz5E
         Od7w==
X-Forwarded-Encrypted: i=1; AJvYcCUrQ7bCu+bqU3UGkGhjkteGD7+8CTB6NL9PN6CIQndV9IfMaW+ofJJ8PzityR6znnW1QlG57ENhlOFdG04cHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2AjVjqenDywpEuvyQHqcT9PfhHdhxbPE9KHGMkGXKnYwd44qp
	gieF8K0u1ovHn8sFhaOoc3k/b+y8dUcTHeGLJt3/Yzi9NNHVFskhDTeYe+Oi4ve4k3MgApVLYX7
	2fOkY09O3D8Yxfqb+Plzn3rT9StiT7R+GCNA=
X-Google-Smtp-Source: AGHT+IFpFNN1yQgdfY9Xjr7hFWqOdaR+k/29nfjRc/jI9+D6aolt4lqR3s1ONz+vmchDUvxgFPjIIg6QjPlmxW61zb8=
X-Received: by 2002:a17:906:478a:b0:a99:f94b:f92e with SMTP id
 a640c23a62f3a-a9a4cc58ef8mr98970966b.27.1729122089676; Wed, 16 Oct 2024
 16:41:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux> <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com> <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com> <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook> <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook> <ZwNb-_UPL9BPSg9N@archlinux>
In-Reply-To: <ZwNb-_UPL9BPSg9N@archlinux>
From: Bill Wendling <morbo@google.com>
Date: Wed, 16 Oct 2024 16:41:11 -0700
Message-ID: <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in bch2_xattr_validate
To: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Kees Cook <kees@kernel.org>, Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev, 
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ardb@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 6, 2024 at 8:56=E2=80=AFPM Jan Hendrik Farr <kernel@jfarr.cc> w=
rote:
> > I want to separate several easily confused issues. Instead of just
> > saying __bdos, let's clearly refer to what calculation within bdos is
> > being used. There are 3 choices currently:
> > - alloc_size attribute
> > - counted_by attribute
> > - fallback to __bos (which is similar to sizeof(), except that FAMs are=
 0 sized)
> >
> > Additionally there are (for all intents and purposes) 2 size
> > determinations to be made by __bos and __bdos, via argument 2:
> > - containing object size (type 0) ("maximum size")
> > - specific object size (type 1) ("minimum size")
>
> "maximum" vs "minimum" size would by type 0 vs type 2, but I think you
> do mean type 0 and type 1 as those are the types currently used by
> __struct_size and __member_size. Those are both "maximum" sizes.
>
> >
> > For example, consider:
> >
> > struct posix_acl *acl =3D malloc(1024);
> > acl->a_count =3D 1;
> >
> > what should these return:
> >
> >       __bos(acl, 0)
> >       __bos(acl, 1)
> >       __bdos(acl, 0)
> >       __bdos(acl, 1)
> >       __bos(acl->a_entries, 0)
> >       __bos(acl->a_entries, 1)
> >       __bdos(acl->a_entries, 0)
> >       __bdos(acl->a_entries, 1)
> >
>
Thank you for this detailed write-up! I'm sorry for my late response.

> I gathered some data from clang and gcc on all for all these cases and
> additionally varied whether the allocation size is a compile time known
> constant, runtime known, or not known. I also varied whether
> __counted_by was used.
>
> Source code: [1]
>
>
> Abbreviations:
>
> FAM      =3D flexible array member
> -1       =3D SIZE_MAX
> p->a_ent =3D p->a_entries
> comp.    =3D allocation size is compile time known
> run.     =3D allocation size is compile time known
> none     =3D allocation size is unknown
> count    =3D __counted_by attribute in use
> correct  =3D What I think the correct answers should be. In some places I
> have two answers. In that case the second number is what the kernel
> currently expects.
>
>
> And here's the data:
>
> function        |comp.|run.|none|count| gcc  |clang |correct
> ----------------|-----|----|----|-----|------|------|-----
> bos(p, 0)       |  x  |    |    |     | 1024 | 1024 | 1024
> bos(p, 0)       |     | x  |    |     |  -1  |  -1  | -1
> bos(p, 0)       |     |    | x  |     |  -1  |  -1  | -1
> bos(p, 0)       |  x  |    |    |  x  | 1024 | 1024 | 1024
> bos(p, 0)       |     | x  |    |  x  |  -1  |  -1  | -1
> bos(p, 0)       |     |    | x  |  x  |  -1  |  -1  | -1
> ----------------|-----|----|----|-----|------|------|-----
> bos(p, 1)       |  x  |    |    |     | 1024 | 1024 | 1024
> bos(p, 1)       |     | x  |    |     |  -1  |  -1  | -1
> bos(p, 1)       |     |    | x  |     |  -1  |  -1  | -1
> bos(p, 1)       |  x  |    |    |  x  | 1024 | 1024 | 1024
> bos(p, 1)       |     | x  |    |  x  |  -1  |  -1  | -1
> bos(p, 1)       |     |    | x  |  x  |  -1  |  -1  | -1
> ----------------|-----|----|----|-----|------|------|-----
> bdos(p, 0)      |  x  |    |    |     | 1024 | 1024 | 1024
> bdos(p, 0)      |     | x  |    |     | 1024 | 1024 | 1024
> bdos(p, 0)      |     |    | x  |     |  -1  |  -1  | -1
> bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> ----------------|-----|----|----|-----|------|------|-----
> bdos(p, 1)      |  x  |    |    |     | 1024 | 1024 | 1024
> bdos(p, 1)      |     | x  |    |     | 1024 | 1024 | 1024
> bdos(p, 1)      |     |    | x  |     |  -1  |  -1  | -1
> bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> ----------------|-----|----|----|-----|------|------|-----
> bos(p->a_ent, 0)|  x  |    |    |     |  996 | 996  | 996
> bos(p->a_ent, 0)|     | x  |    |     |  -1  |  -1  | -1
> bos(p->a_ent, 0)|     |    | x  |     |  -1  |  -1  | -1
> bos(p->a_ent, 0)|  x  |    |    |  x  |  996 | 996  | 996
> bos(p->a_ent, 0)|     | x  |    |  x  |  -1  |  -1  | -1
> bos(p->a_ent, 0)|     |    | x  |  x  |  -1  |  -1  | -1
> ----------------|-----|----|----|-----|------|------|-----
> bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
> bos(p->a_ent, 1)|     | x  |    |     |  -1  |  -1  | -1
> bos(p->a_ent, 1)|     |    | x  |     |  -1  |  -1  | -1
> bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
> bos(p->a_ent, 1)|     | x  |    |  x  |  -1  |  -1  | -1
> bos(p->a_ent, 1)|     |    | x  |  x  |  -1  |  -1  | -1
> ----------------|-----|----|----|-----|------|------|-----
> bdos(p->a_ent,0)|  x  |    |    |     |  996 | 996  | 996
> bdos(p->a_ent,0)|     | x  |    |     |  996 | 996  | 996
> bdos(p->a_ent,0)|     |    | x  |     |  -1  |  -1  | -1
> bdos(p->a_ent,0)|  x  |    |    |  x  |   8  |  8   |  8
> bdos(p->a_ent,0)|     | x  |    |  x  |   8  |  8   |  8
> bdos(p->a_ent,0)|     |    | x  |  x  |   8  |  8   |  8
> ----------------|-----|----|----|-----|------|------|-----
> bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
> bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992
> bdos(p->a_ent,1)|     |    | x  |     |  -1  |  -1  | -1
> bdos(p->a_ent,1)|  x  |    |    |  x  |   8  |  8   |  8
> bdos(p->a_ent,1)|     | x  |    |  x  |   8  |  8   |  8
> bdos(p->a_ent,1)|     |    | x  |  x  |   8  |  8   |  8
> ----------------|-----|----|----|-----|------|------|-----
>
> bos only uses the allocation size to give it's answers. It only works if
> it is a compile time known constant. bos also does not utilize the
> __counted_by attribute.
>
> bdos on the other hand allows the allocation size to be runtime known.
> It also makes use of the __counted_by attribute if present, which always
> takes precedence over the allocation size when the compiler supports it
> for the particular case. So in those cases you can "lie" to the compiler
> about the size of an object.
>
> clang supports the __counted_by attribute for both cases (p and
> p->a_entries). gcc only supports it for p->a_entries cases.
>
>
>
> Issue A (clang)
> =3D=3D=3D=3D=3D=3D=3D
>
> function        |comp.|run.|none|count| gcc  |clang |correct
> ----------------|-----|----|----|-----|------|------|-----
> bdos(p, 0)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 0)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 0)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
> bdos(p, 1)      |  x  |    |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 1)      |     | x  |    |  x  | 1024 |  36  | 43 / 40
> bdos(p, 1)      |     |    | x  |  x  |  -1  |  36  | 43 / 40
>
> These cases also represent the "bdos off by 4" issue in clang. clang
> will compute these results using:
>
> max(sizeof(struct posix_acl), offsetof(struct posix_acl, a_entries) +
> count * sizeof(struct posix_acl_entries)) =3D 36
>
> The kernel on the other hand expects this behavior:
>
> sizeof(struct posix_acl) + count * sizeof(struct posix_acl_entries) =3D 4=
0
>
>
> I think the correct calculation would actually be this:
>
> offsetof(struct posix_acl, a_entries)
> + (acl->a_count + 1) * sizeof(struct posix_acl_entry) - 1 =3D 43
>
> The C11 standard says that when the . or -> operator is used on a struct
> with an FAM it behaves like the FAM was replaced with the largest array
> (with the same element type) that would not make the object any larger
> (see page 113 and 114 of [2]).
> So there are actually multiple sizes of the object that are consistent
> with a count of 1.
>
> malloc-max =3D maximum size of the object
> malloc-min =3D minimum size of the object
> FAME =3D flexible array member element
> (FAME) =3D hypothetical 2nd FAME
>
> <-----------------malloc-max-------------->
> <-----------------malloc-min------->
> <------sizeof(posix_acl)------->
>                             <-FAME-><(FAME)>
>
> The clang documentation of type 0 (vs type 2) bdos says this:
>
> If ``type & 2 =3D=3D 0``, the least ``n`` is returned such that accesses =
to
>    ``(const char*)ptr + n`` and beyond are known to be out of bounds.
>
> We only _know_ that that access to the last byte of a 2nd hypothetical FA=
ME
> would be out of bounds. All the bytes before that are padding that is
> allowed by the standard.
>
>
> However, also this calculation doesn't get the kernel out
> of trouble here. While this would fix the issue for this particular
> struct it does not solve it for all structs:
>
> What if the elements of the FAM were chars instead of
> struct posix_acl_entries here? In that case the kernel is back to
> overestimating the size of the struct / underreporting the count to the
> compiler. So while I think this answer is more correct it doesn't
> actually solve the issue.
>
> Example:
> Let's say the kernel allocates one of these posix_acl_char structs for a
> single char in the array:
>
> malloc(sizeof(posix_acl_char) + 1 * sizeof(char)) =3D 33
>
> The C standard actually says that this object will behave like this when
> the FAM is accessed:
>
> struct posix_acl {
>     refcount_t a_refcount;
>     struct rcu_head a_rcu;
>     unsigned int a_count;
>     char a_entries[5];
> };
>
> a_count should be set to 5, not 1!
>
While the standard says that it should act as 5 instead of 1 and that
it's not an error to access padding, the point of the __counted_by
attribute is to check that the user isn't doing anything "bad" by
going outside of whatever bounds have been put in place. So I wouldn't
want __bdos(p->a_entries, 0) to return 5 when the initial allocation
is for 1. It's confusing given the documentation for the attribute.

> So we would really need an option to tell the compiler to use the same
> size calculation as the kernel expects here, or maybe be able to specify
> an offset in the __counted_by attribute. Alternatively clang could use
> an option to disable the use of __counted_by for cases where the whole
> struct is passed. This would make it behave like gcc.
>
I would be in favor of disabling __bdos on a whole struct pointer if
it will match the functionality between the compilers. I don't think
Qing has that on her plate at the moment, but when / if she revisits
that we can discuss exactly how to perform the calculations then.

> Issue B (clang + gcc)
> =3D=3D=3D=3D=3D=3D=3D
>
> A less serious issue happens with these cases:
>
> function        |comp.|run.|none|count| gcc  |clang |correct
> ----------------|-----|----|----|-----|------|------|-----
> bos(p->a_ent, 1)|  x  |    |    |     |  996 | 996  | 992
> bos(p->a_ent, 1)|  x  |    |    |  x  |  996 | 996  | 992
> bdos(p->a_ent,1)|  x  |    |    |     |  996 | 996  | 992
> bdos(p->a_ent,1)|     | x  |    |     |  996 | 996  | 992
>
> In this case the size returned by bos/bdos is too large, so this won't
> lead to false positives. Both clang and gcc simply compute the difference
> between the pointer from the start of the FAM to the end of the whole
> struct. I believe this is wrong. According to the C standard the object
> should behave like the FAM was replaced with the largest array that does
> not make the object any larger. The size of that array is 124 elements.
> So the posix_acl becomes:
>
I reported a similar issue to GCC a while back. The response is that
it's not incorrect, because the size is still valid (padding, etc.).
Their view is that, even when asked for the size of the subobject,
they want to return some value, even if it's larger than the
subobject, but not outside the bounds of the full object. I strongly
disagree that it's okay to do that, but I'm probably in the minority.
Clang's support for 1 as the __bdos's second argument isn't great. I'm
trying to fix it, but got sidetracked by higher priority issues.

So in conclusion, if turning off the calculation for a pointer to the
whole struct works, then I'm okay with it.

-bw

> struct posix_acl {
>     refcount_t a_refcount;
>     struct rcu_head a_rcu;
>     unsigned int a_count;
>     struct posix_acl_entry a_entries[124];
> };
>
> Since this is a type 1 bos/bdos it should return the size of just the
> array, which is 124 * 8 =3D 992, and not 124.5 * 8 =3D 996.
>
> [1] https://godbolt.org/z/a5eM3z8PY
> [2] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf
>
> Best Regards
> Jan
>
