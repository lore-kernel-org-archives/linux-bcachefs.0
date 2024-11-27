Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86EEF9DD
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 21:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744123; cv=none; b=qOGKwm76jvBrRw2NtgHkclUv/jF9nHJpd5nXeKOZzc7yqJsEIM88Fgu6EjBiyy5R4WEqHnrNFYdHtm1XdnJBJ9uIHhWnc8SxLd81PJ9ZpDFamjQE2+tuB2adEkT9hx10Gg9A6k+GoiXrEyKcQBRetE08oq9D70JpnOvzrRzjcsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744123; c=relaxed/simple;
	bh=tjfGbFPl2W8J2CzAwDCRYiA9Zq/G1AEgpjSEPPSI6Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rnbhh11jsS8Eo4RvUmOkjALdknrjoqbjVemIwCyheyCIC+jCqER7RdyRFAphqOTIpeTUoiUcdrucyt09orpH+oSyU0WvCc1kCxLYudWJCnrx+Ya63z3tt/ZDsLMOuHUZ+/XfpdavUlvec4ZJaYZBYkb3GqkyXAjDkUpYvogIZcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UzjGRjd6; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UzjGRjd6"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d027dc53ccso1742a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 13:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732744120; x=1733348920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjfGbFPl2W8J2CzAwDCRYiA9Zq/G1AEgpjSEPPSI6Gk=;
        b=UzjGRjd6zh0tRL9C7dMpbq2emW2H8cWQ20JuF3eriuxDpL54HnCV8MvDvypi1V5dsW
         YLJmS6nEksGZPzi8gJez6uK+guAWhw46ouTrITDtyFpRt2b6vjkPp7u5fVXUIlWtlMi/
         yZyF5AkGW9IfEMn00/8/xMr47IT1pTJCoEGV5gHdh+fxNf13zCu6fqMuR1Mxnd9rc+Ij
         vQzv25nxKiKqtUF5KpH58WxXgmoomcXBSNicHkdgqNIyi32f9uD1IxPX58mRyHC+jNN/
         0UCKlP/847p8sgR4mXfC+EfOtb2HVIQNNYvV1AMr1BcjYnRAvWg8KwWuhlgc2QyKRzcE
         lcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744120; x=1733348920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tjfGbFPl2W8J2CzAwDCRYiA9Zq/G1AEgpjSEPPSI6Gk=;
        b=RJYgZ/7DYX8gZTaPfcfnW2HakncY5l12mUIzy5RtoCx8k+WIY9lbT47y2FbZqhAJ06
         Jf6+D7W2WEUZdxdovRLTb0WUsFjhIbtjHEMe9RHWOtdPnxM81l0/IWbTTrsxDKYosq61
         dLt48vo6FUYG6YnMgyveDXFZEP+WwOFV55lJyiy9isPQoGaDU798zxmyzHVI1LlGjXtz
         +q0GpeDemy0b+eNUHbe9UDq0U8fZj+7S84yoIp1fGuZmR15/yf6B5B0jjo4+0r7+hTta
         p4QYQrzk0gGba5IZPKaaZjvunQn8bQZgKA207ZOfeCP7sD+EEJo0Gmz9U9yaFDlzKO3o
         emEw==
X-Gm-Message-State: AOJu0YzyJ4CO8JTY1gXeMDOt15ARopXrGb1eBBi9i9EpkLYDw5b6rMZe
	SG/SRJt1shJdz93dIJzyW86LJ3+eVN+/W6X7V5JqTVavLQv+ctyP0kpVQEAXImqDv+hfN3g0Ma0
	608dHl9OiFJciuSEqHkmAKjoX6bISmLkpTDB4
X-Gm-Gg: ASbGnctXPEM4OTC051+dH1yFskgTe/qQWmqKmI8I3L2ZSlBj9qAis72V9p44AUOkzpz
	WgTcqwyvIaraGzzq2K3/u/mrlbOGotIoNoq6gCQb/jEjOV9/Bb6mg5iDhzPk=
X-Google-Smtp-Source: AGHT+IEswfpZIkUvqfzOeh4C8Gp8lVRv2wSMm2oZLZLP9VUaY5M0qEHVBmjV4qPXN76A/lhtWCRz2I7KJkCAGkr1vgI=
X-Received: by 2002:a05:6402:759:b0:5cf:deaf:ac2 with SMTP id
 4fb4d7f45d1cf-5d095b58598mr14971a12.2.1732744119925; Wed, 27 Nov 2024
 13:48:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127213649.1615078-1-kent.overstreet@linux.dev>
In-Reply-To: <20241127213649.1615078-1-kent.overstreet@linux.dev>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 22:48:03 +0100
Message-ID: <CAG48ez2CXiAieL5-htj86p0cwVOoD5S5Pq=-E+Sf03ifzfYqdQ@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: dio write: Take ref on mm_struct when using asynchronously
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 10:36=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
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

Ah, one thing to look out for is that mm_struct has two types of
refcounting, this patch mixes them up - I don't think my explanation
of that was very clear:

 - mmgrab()/mmdrop() prevent the mm_struct itself being freed, but
don't properly keep the mappings in it alive
 - mmget()/mmput() fully keep the MM alive

An mmget() reference automatically also holds an mmgrab() reference, basica=
lly.

For kthread_use_mm(), you need an mmget() reference; so the most
straightforward option would be to mmget() when creating the
asynchronous work and mmput() when you're done. But that has the
disadvantage that the reference keeps the entire mm_struct with all
the mappings inside it alive, and it even indirectly holds a reference
to all the files mapped in the MM; though I don't know if that's
really a problem here.

If you want to avoid keeping the MM of an exiting process alive while
the I/O is running, the neater pattern is to use mmgrab()/mmdrop() for
your long-term reference, and then use mmget_not_zero()/mmput() around
kthread_use_mm()/kthread_unuse_mm() (and bail if mmget_not_zero()
fails). You can see this pattern in places like
vfio_iommu_type1_dma_rw_chunk().
