Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1D5200132
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 23:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732749142; cv=none; b=APD/FIbQqCDbUJ3r8CWgb9iMHEDRihLyRUhQFT9iOo10t+RvBHTYLPENKwiwxjBBjbgLOASqW2XoEF65Jz86zTkN/KbzJJChErk9VKrmTwhRyGB0aHevZsFJYWFWvJQ+PL8qkGEbT9Y0YM4F8GobIFGNMeYZskF/QhOjJmvIEg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732749142; c=relaxed/simple;
	bh=cStj2fP0Vv8l6LKQMAkdHslkMvCc5UvMm4OZxfeuklY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jCFWcvFi/cTsKUOSAyWj4ScGGwzVBxF9vESbCYLVekV/j7sUwxrUr1vkIUeHorneGqklqvJypkaJTzlUnIupkwuOIF9relAyaJEs0j2Bw2VqiNvKn/bG1VPCMwgguXibQiILiwQszzs6XpIMnQ+Bp2niJ/579wdd0zMKUgftXiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OnycTi6R; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OnycTi6R"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d027dc53ccso404a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 15:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732749138; x=1733353938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6rGUma6jF63ostW+xDzQQPk4HM0eNqbzYZSGRYgAps=;
        b=OnycTi6RicMmY5XTMJVlaDQ7aju60dlmYrNJy4kwd+JmXco/dA9NZv+Z/H4vKnIWAN
         /hRQ4pxM7bosNvThkMsABmmzbgmehSN+yaLg2vi+nqanYbF6JnmNI068g5aJ+H0q01PB
         EYhF6vwhZqZYK1xUk71hNx3h2QvpaXDK3wjRV8FDW1seCUlE4b2o18i4cG61b7PIQpLE
         SmYvEaCXNPhmWZPo4hGsekHQ+wcGWbKlhSG8EioiEhi7owzmlz2FXRIbOWQniWsQ2kNL
         yEP37FeawpHusWEWd9lUgwZdJNVcDThwFo8vOe5Y80vUKjF7PTfz0qK+UZLkHl7Ew02N
         hI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732749138; x=1733353938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y6rGUma6jF63ostW+xDzQQPk4HM0eNqbzYZSGRYgAps=;
        b=wDNp84YoUZm1SBGouJOp6gXuQcrDdJQrjNr8Tqh69/n00dt2TWUM73L1m8RXOYncOg
         ZF1lypBwbayMDz2cwnXEtZ2fdkHqqOtPVoEGg90KCRyViZJQE43lTLzPt9Xmze5ZrcR1
         xyKopO10giGo93V+JA1FLT71SelJLT0VdUrj7ndTxNHUVpn0E+yH9B+579lWVv6Y4OY/
         OFYy/dqevOBxEKYvnRlBcptPVVnwgXBl2KzWX3Gaz75tcQ29M8xA1eoNG22GQ7fUW7V6
         hNqUJ++gHYqHwYlxHqYQTi5dDktFHfKyUsaOILd+QwJ2FDuWsUWMLvWdzawMSg+8fxfd
         o0rg==
X-Gm-Message-State: AOJu0YxeKUs8FLyO5G1vID3PbktpeJz0/jA7a362pxaJ/DgYr6SmmWKL
	/WRydKACkhgbIp2y7/mBeOenmTGRxH9cNW0w0ef3M+Xh/C1jS53jdxA3RAV+LpA6HIMtrM/VXRe
	G/O+swGAYK5WTBLF1Npcj0uSBJQsQp/3AT0aP
X-Gm-Gg: ASbGnctZ8obNABD5YIYasGJ2QCVGsDfXUtSOtKPBYLP67rxTDQTesBex3/ruAGZkwNs
	IcLPVt2ye6jx1gVwIWObFu4j25PFO6ixYN7Tz29pNyhlqNhQXdLs6SMucoNA=
X-Google-Smtp-Source: AGHT+IEe/sI18LVtDivB32ygN4nFY2Idz9NI9hT2UV1+x8eMG1e474eFOR5ebcwICQyhczw5YZFeF+1woT/o6CtnrY0=
X-Received: by 2002:a05:6402:1cb7:b0:5d0:84a6:f1a1 with SMTP id
 4fb4d7f45d1cf-5d09625061amr21444a12.6.1732749137604; Wed, 27 Nov 2024
 15:12:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127213649.1615078-1-kent.overstreet@linux.dev>
 <CAG48ez2CXiAieL5-htj86p0cwVOoD5S5Pq=-E+Sf03ifzfYqdQ@mail.gmail.com> <xrjd4otiojkszczc2u2buwbnb6sw2z7u2p66evivsgxrpkidxq@55yc6lbcnhh2>
In-Reply-To: <xrjd4otiojkszczc2u2buwbnb6sw2z7u2p66evivsgxrpkidxq@55yc6lbcnhh2>
From: Jann Horn <jannh@google.com>
Date: Thu, 28 Nov 2024 00:11:41 +0100
Message-ID: <CAG48ez00YBBb9fpNOknoWamuy5e9WSOTq84MxXSi2eGP3A8kfQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: dio write: Take ref on mm_struct when using asynchronously
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 11:11=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Wed, Nov 27, 2024 at 10:48:03PM +0100, Jann Horn wrote:
> > On Wed, Nov 27, 2024 at 10:36=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > When invoked from aio, mm_struct is guaranteed to outlive the request
> > > since its lifetime is tied to the io_context - but that's not the cas=
e
> > > for io_uring, it's possible that a process could be killed and mm_str=
uct
> > > goes away while a request is in flight.
> > >
> > > So if we're submitting the rest of the io asynchronously, we may need=
 a
> > > ref on mm_struct.
> > >
> > > Per Jens, this is not actually a bug because we're not yet flipping o=
n
> > > FMODE_NOWAIT, meaning io_uring will do the submission from an io_work=
er
> > > kthread - but this patch is necessary for safely flipping on
> > > FMODE_NOWAIT for more efficient submissions in the future.
> >
> > Ah, one thing to look out for is that mm_struct has two types of
> > refcounting, this patch mixes them up - I don't think my explanation
> > of that was very clear:
> >
> >  - mmgrab()/mmdrop() prevent the mm_struct itself being freed, but
> > don't properly keep the mappings in it alive
> >  - mmget()/mmput() fully keep the MM alive
> >
> > An mmget() reference automatically also holds an mmgrab() reference, ba=
sically.
> >
> > For kthread_use_mm(), you need an mmget() reference; so the most
> > straightforward option would be to mmget() when creating the
> > asynchronous work and mmput() when you're done. But that has the
> > disadvantage that the reference keeps the entire mm_struct with all
> > the mappings inside it alive, and it even indirectly holds a reference
> > to all the files mapped in the MM; though I don't know if that's
> > really a problem here.
> >
> > If you want to avoid keeping the MM of an exiting process alive while
> > the I/O is running, the neater pattern is to use mmgrab()/mmdrop() for
> > your long-term reference, and then use mmget_not_zero()/mmput() around
> > kthread_use_mm()/kthread_unuse_mm() (and bail if mmget_not_zero()
> > fails). You can see this pattern in places like
> > vfio_iommu_type1_dma_rw_chunk().
>
> gotcha...
>
> From 3ef3067690d838dfc9a12686caa015e85e217f01 Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Wed, 27 Nov 2024 16:32:26 -0500
> Subject: [PATCH] bcachefs: dio write: Take ref on mm_struct when using
>  asynchronously
>
> When invoked from aio, mm_struct is guaranteed to outlive the request
> since its lifetime is tied to the io_context - but that's not the case
> for io_uring, it's possible that a process could be killed and mm_struct
> goes away while a request is in flight.
>
> So if we're submitting the rest of the io asynchronously, we may need a
> ref on mm_struct.
>
> Per Jens, this is not actually a bug because we're not yet flipping on
> FMODE_NOWAIT, meaning io_uring will do the submission from an io_worker
> kthread - but this patch is necessary for safely flipping on
> FMODE_NOWAIT for more efficient submissions in the future.
>
> Reported-by: Jann Horn <jannh@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index 2089c36b5866..8da0577411e8 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -226,6 +226,7 @@ struct dio_write {
>         struct mm_struct                *mm;
>         const struct iovec              *iov;
>         unsigned                        loop:1,
> +                                       have_mm_ref:1,
>                                         extending:1,
>                                         sync:1,
>                                         flush:1;
> @@ -390,6 +391,9 @@ static __always_inline long bch2_dio_write_done(struc=
t dio_write *dio)
>
>         kfree(dio->iov);
>
> +       if (dio->have_mm_ref)
> +               mmdrop(dio->mm);
> +
>         ret =3D dio->op.error ?: ((long) dio->written << 9);
>         bio_put(&dio->op.wbio.bio);
>
> @@ -529,9 +533,24 @@ static __always_inline long bch2_dio_write_loop(stru=
ct dio_write *dio)
>
>                 if (unlikely(dio->iter.count) &&
>                     !dio->sync &&
> -                   !dio->loop &&
> -                   bch2_dio_write_copy_iov(dio))
> -                       dio->sync =3D sync =3D true;
> +                   !dio->loop) {
> +                       /*
> +                        * Rest of write will be submitted asynchronously=
 -
> +                        * unless copying the iov fails:
> +                        */
> +                       if (likely(!bch2_dio_write_copy_iov(dio))) {
> +                               /*
> +                                * aio guarantees that mm_struct outlives=
 the
> +                                * request, but io_uring does not
> +                                */
> +                               if (dio->mm) {
> +                                       mmgrab(dio->mm);
> +                                       dio->have_mm_ref =3D true;
> +                               }
> +                       } else {
> +                               dio->sync =3D sync =3D true;
> +                       }
> +               }
>
>                 dio->loop =3D true;
>                 closure_call(&dio->op.cl, bch2_write, NULL, NULL);
> @@ -559,15 +578,25 @@ static __always_inline long bch2_dio_write_loop(str=
uct dio_write *dio)
>
>  static noinline __cold void bch2_dio_write_continue(struct dio_write *di=
o)
>  {
> -       struct mm_struct *mm =3D dio->mm;
> +       struct mm_struct *mm =3D dio->have_mm_ref ? dio->mm: NULL;
>
>         bio_reset(&dio->op.wbio.bio, NULL, REQ_OP_WRITE);
>
> -       if (mm)
> +       if (mm) {
> +               if (unlikely(!mmget_not_zero(mm))) {
> +                       /* process exited */
> +                       dio->op.error =3D -ESRCH;
> +                       bch2_dio_write_done(dio);
> +                       return;
> +               }
> +
>                 kthread_use_mm(mm);
> +       }
>         bch2_dio_write_loop(dio);
> -       if (mm)
> +       if (mm) {
> +               mmput(mm);
>                 kthread_unuse_mm(mm);
> +       }

I think the mmput() should go after kthread_unuse_mm(), though I don't
know if this ordering actually breaks anything.

Looks fine apart from that at a glance.


>  }
>
>  static void bch2_dio_write_loop_async(struct bch_write_op *op)
