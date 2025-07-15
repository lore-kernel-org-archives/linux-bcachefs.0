Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3144F26CE3A
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Jul 2025 07:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752563025; cv=none; b=EC14BeR9epdXi0CSoYLQH1LW/Ig5mm14oGmTzNWRCctQ2LWMJ6i47+eknjvrDHom+6gjGOGKAdye1uq5O3eBMSAjdtFgHdgvyDKB408lM7Ir8zNuW+ysRno0PAh240lLbO12XFGY6MmcnRJMrv18zJP/v1rCA8cl00aYEw99u40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752563025; c=relaxed/simple;
	bh=jGIHWJIRk9i2hR7tXdegBVyUzLtZws4m098Ez8HCiu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFneMXD2JjJ2FuM9ok9x+0aHkedKrrWg2L/zsBqk6QNvInhMIJdVXVdfV57Mm1su6KVxI1S26L7BLGIftF2hYctQc3W+8ORYzVJ/alQ1FzhiLD/xFbL8yUkA53usTcfh8huZ97CNigMbFjXGw04myDBn14Ccuzy2TbrahkN8Bcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p6di1us/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p6di1us/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a5257748e1so3393319f8f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 15 Jul 2025 00:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752563020; x=1753167820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jt/6M57mZgMPhITvF8HdLS12vV1vFn0N4xhHPTTFoy0=;
        b=p6di1us/YOoA1lZHdJKciAn/weTVp3gueuCxxgxq0vox0P1weH/XwtFqEzh7VG8rdE
         z/8Ok3qMaemxdgDCx3iENLGbHdvgZD8fsioGrTK8eWKyVl8EXeXjT87ZyNXwOgV0xjr/
         1ptF1Bzg65wX4mYOInpU7lCCH8mgq1sWxn9UB2X8VvhX2NmQuXyPja6UF8r+sJaUyaR4
         Lsejui+EiNRyPQDOtDghE81neDRuCYhPB/mp71EX3Ne7pCdRiqjyCItgH6awQjiTqH0S
         0seB7xl69ukokxhyGUBRrOnW7Zw+qODHBzgsbnqdy2qrnnYqCMJCtSpWF5aa0MnT5nPu
         edGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752563020; x=1753167820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jt/6M57mZgMPhITvF8HdLS12vV1vFn0N4xhHPTTFoy0=;
        b=meS+qc/hFlOYuzhnMxNHnBEaXXs+YrhIvKvGy/RKf3TYC8jlfcNmLFeur2YHc+JNFw
         dVzMMcIx4xsHxfJffMYq1qTmkct2uFkRF5qOzmr8LX2zDJ8abpgPK/log/WimJJrhvMa
         xAtd34O3nFiJD4Z6tHKR2XwQf9XkOWqTuw/XZgrPE7nSn6T7zHgs6SnBbyXo9y9EyCcl
         WZY6qwFlyrml/eTZIQ25+pPXkZo7g1fCt+4EB7zWnD0DhbLpVRaWUYMD+Htpt76UyAb5
         7O0sSmVBFy58eMOzSJk/znRFOhKRzGiPLtpJZnJWT2aYd4HsVog7e4oixSd0zB7OQL26
         0AVg==
X-Forwarded-Encrypted: i=1; AJvYcCVKrDyO8+9xaG8jxB6rfyO6MdXXsgsZwxCfE07VGarNhybu3uZJaN1TVti0ylF7E2sYhEGBXJ0yivwPkaA2rA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJHwr7jsvn06ysX52IShWQIg0sCWriyU0HNCT3omc+JqRWzDs+
	3x96JqnIsrJ+g93ReT1UDaYUIyEfb0NfQ8T16buL7ZbfNVcErhGUvG9G1q8CKkoEQkXRuAEVOjn
	QXXr7dSM9hrDQHsyZ5eiaZ8YgDPv9hxI3R2XnDHKf
X-Gm-Gg: ASbGncu46XsD0c88C9aR1PaT4qPX90HwD4gVI8B9kreH/AvqvuX8QCn5SLy6WNrQpFi
	1aibMDJqP+Ptz/H93osilrm62BFLRpVGeGwHi5kDKTQT2b1rqxn4MPaDGMvd9paVzGNRmVZh5qn
	oLqjKxBEDIlGlo/pjVm0PDHVGX3zpgl92eR/vARWJIvOmdisrc1lRf7s+tqYpyI1TjpCajeE37I
	olMbqmF
X-Google-Smtp-Source: AGHT+IE1/MY0RQcecLFoHvQZdO+7sZGnb0kcJHS9oa/ewG1ZdNmenXVcPC2k1yhTjRTUuDq69k9FOq7rxEcXnfgllNg=
X-Received: by 2002:a05:6000:1a86:b0:3a4:eda1:6c39 with SMTP id
 ffacd0b85a97d-3b5f2dc216dmr10969220f8f.13.1752563020324; Tue, 15 Jul 2025
 00:03:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709172345.1031907-1-vitaly.wool@konsulko.se>
 <20250709172441.1032006-1-vitaly.wool@konsulko.se> <aHDSLyHZ8b1ELeWe@hyeyoo>
 <5bc89531-ab09-4690-aae4-a44f9ddb4a68@suse.cz> <3AD3F7B5-679F-4DC8-968F-9FE991B56A5C@konsulko.se>
 <1dedcee0-c5a2-47b3-ae13-315ad437ae1a@suse.cz>
In-Reply-To: <1dedcee0-c5a2-47b3-ae13-315ad437ae1a@suse.cz>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 15 Jul 2025 09:03:27 +0200
X-Gm-Features: Ac12FXx5pgrLnvLVllVwWAxwc6ktT76M5E8OvULeGL7H3WltRDY_yqdMh5SmBiA
Message-ID: <CAH5fLggV2Y+N7k=+b5z=Hy5a556VomEZEa3bGhufvKBU+Fd=Ug@mail.gmail.com>
Subject: Re: [PATCH v12 2/4] mm/slub: allow to set node and align in k[v]realloc
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 10:14=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 7/12/25 14:43, Vitaly Wool wrote:
> >
> >
> >> On Jul 11, 2025, at 5:43=E2=80=AFPM, Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >>
> >> On 7/11/25 10:58, Harry Yoo wrote:
> >>> On Wed, Jul 09, 2025 at 07:24:41PM +0200, Vitaly Wool wrote:
> >>>> static __always_inline __realloc_size(2) void *
> >>>> -__do_krealloc(const void *p, size_t new_size, gfp_t flags)
> >>>> +__do_krealloc(const void *p, size_t new_size, unsigned long align, =
gfp_t flags, int nid)
> >>>> {
> >>>> void *ret;
> >>>> size_t ks =3D 0;
> >>>> @@ -4859,6 +4859,20 @@ __do_krealloc(const void *p, size_t new_size,=
 gfp_t flags)
> >>>> if (!kasan_check_byte(p))
> >>>> return NULL;
> >>>>
> >>>> + /* refuse to proceed if alignment is bigger than what kmalloc() pr=
ovides */
> >>>> + if (!IS_ALIGNED((unsigned long)p, align) || new_size < align)
> >>>> + return NULL;
> >>>
> >>> Hmm but what happens if `p` is aligned to `align`, but the new object=
 is not?
> >>>
> >>> For example, what will happen if we  allocate object with size=3D64, =
align=3D64
> >>> and then do krealloc with size=3D96, align=3D64...
> >>>
> >>> Or am I missing something?
> >>
> >> Good point. We extended the alignment guarantees in commit ad59baa3169=
5
> >> ("slab, rust: extend kmalloc() alignment guarantees to remove Rust pad=
ding")
> >> for rust in a way that size 96 gives you alignment of 32. It assumes t=
hat
> >> rust side will ask for alignments that are power-of-two and sizes that=
 are
> >> multiples of alignment. I think if that assumption is still honored th=
an
> >> this will keep working, but the check added above (is it just a sanity=
 check
> >> or something the rust side relies on?) doesn't seem correct?
> >>
> >
> > It is a sanity check and it should have looked like this:
> >
> >         if (!IS_ALIGNED((unsigned long)p, align) && new_size <=3D ks)
> >                 return NULL;
> >
> > and the reasoning for this is the following: if we don=E2=80=99t intend=
 to reallocate (new size is not bigger than the original size), but the use=
r requests a larger alignment, it=E2=80=99s a miss. Does that sound reasona=
ble?
>
> So taking a step back indeed the align passed to krealloc is indeed used
> only for this check. If it's really just a sanity check, then I'd rather =
not
> add this parameter to krealloc functions at all - kmalloc() itself also
> doesn't have it, so it's inconsistent that krealloc() would have it - but
> only to return NULL and not e.g. try to reallocate for alignment.
>
> If it's not just a sanity check, it means it's expected that for some
> sequence of valid kvrealloc_node_align() calls it can return NULL and the=
n
> rely on the fallback to vmalloc. That would be rather wasteful for the ca=
ses
> like going from 64 to 96 bytes etc. So in that case it would be better if
> krealloc did the reallocation, same as in cases when size increases. Of
> course it would still have to rely on the documented alignment guarantees
> only and not provide anything arbitrary. aligned_size() in
> rust/kernel/alloc/allocator.rs is responsible for that, AFAIK.
>
> And I think it's not a sanity check but the latter - if the following is =
a
> valid k(v)realloc sequence (from Rust POV). The individual size+align
> combinations AFAIK are, but if it's valid to make them follow one another
> them like this, I don't know.
>
> krealloc(size=3D96, align=3D32) -> can give object with 32 alignment only
> krealloc(size=3D64, align=3D64) -> doesn't increase size but wants alignm=
ent 64

On the Rust side, you specify what the old size/align was, and what
you which size/align you want after the call, and they can be anything
including that combination.

Alice
