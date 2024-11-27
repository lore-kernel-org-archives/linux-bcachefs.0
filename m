Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4614AD29
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 20:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740301; cv=none; b=IuUlCHk2fmFEjmyc6QT0wyRViE4BmbVI9NBTZDoMVgGxPLBsNmYedL9D6qcegKJTg2xyS0vQczU/svZY/Vww2JHcpEwExKkLxqln1fc/CT2JlYTRBD8+u/+xPgwaNAoT4ke++rr68TjyqX4fUOt+cgZLbwMC6SlxTJDrEx1moX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740301; c=relaxed/simple;
	bh=jggjXI19QomOcJC0VrOzKt7+E3raOImS+ezgvPUnZc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M9hM8vPhrGr2eJcTYaGPQz330N5OYnpPbXlNw1f0q1WuvK5tQK6XYvkYBSAUK9HmPdJ1EocH0Cq9hOm9u/3+Tw2Q+NsHfjuFT/jBjUz21LpLt5GdYZR4DT58hD2CRNBPyKETJlDN2AcTooceRiTlSiVmGyxeAw3JGqW9V2JIQQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n4xBvR6M; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4xBvR6M"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d027dc53ccso1056a12.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 12:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732740298; x=1733345098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jggjXI19QomOcJC0VrOzKt7+E3raOImS+ezgvPUnZc0=;
        b=n4xBvR6MJDL+2p5LRR4BSyUs4ZF6kKh3QXyTjVveK6Rz/fQPhnpGHIlfyNCIHyTPqR
         Mjwf3lwHJUxyxyX9JcjKBuP5MHurCZ3zxEULxDLXy2PyX91FNXV4G+m5lktSglxMQeyQ
         0PiF9ZHcIq+5jTtlJIOcYKFyZM86dkTLoNJE4HuMHJDYdO7ZJnKzung+9rjHPkPh8C1U
         3G5oM/3LyDz+JR0KEZz22O0Y/KtHBGPT9CdzOfgikyFmyUhpOQcy9pVmDsI/HP9fHQOl
         i5LjRdVNsACQru5UWZieU1F7Wou2xrtpaXq3LOCuWfCKHPWG/WVN4A6QmSEUzMNlvN52
         0D2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740298; x=1733345098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jggjXI19QomOcJC0VrOzKt7+E3raOImS+ezgvPUnZc0=;
        b=tFPBm6qEoMaSn9QoMGnE3GqrroXiSTjdPXiDBOsuL4jMtmfpfQZn61sdwOqYQBFbF2
         641aFqpRBI4SbaeneafgVFG1Uw9dNrozh8OU/Wq4Kb/wKzCrXqjD2byFrlP5BVx7OWDD
         ikcxaZrUv44PvhkBmVoWTU3fjrOfzME+Yh5zATlciPDSmU8DH5pfDBIQZ3deeUdTMFo2
         eB2DUxwKpwYR1eFu7RcLfGfAKW3bzsfxBiSISiePaivBLLhw2WkQwVUMS262Rzlkhd/O
         0XsHxW/jay+BvJo7NFibZyK3KC87+LxSl9L009CJdTsNkFUY31MBHlYG65GSrR2FPFSW
         dPWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYhcTvyJ9/1LhYMH07z5VKXX6ggyRAbubR04NgSleRHp4bE+vMrJEcklgkMFDgtWtqoz+5EBtsy++lQXIfyg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzbzq/+YtqnB6P2ZX1e9Ic1px2TOsi9bRGbdoMeOC6ZMyeGBMiE
	+anaCqAtk4cpLYc4SRQcDr40xR6x15jRkmX5Zz/ybTSAuVZmoDYxDNO0tiXDZvEgZIVnDNOfxEF
	LObKRomBZGrLIYuN2MOsHyzVpUdzlnbjJB9JasIYH0Hxu1rixW0FHCag=
X-Gm-Gg: ASbGncspzqCQfkkb7HgGLl4mX209aLirb0HWG8emZrx3e0E4qdxjejiyOrA+dsXpnV0
	QqdGpx3GJ6qOC4b4ZHaIukAa9+kaITZi/PP0wcCfxe93rfSfC9X4A4glu+Lk=
X-Google-Smtp-Source: AGHT+IHQB+8oGSK3zdPvtgz6S6SyiqPETkntE12pYAX253PuYuK4Vzv21Xyw9t/bTWzeeChut+pQa8GfhYvgY9/IrYY=
X-Received: by 2002:a05:6402:3184:b0:5d0:8723:487d with SMTP id
 4fb4d7f45d1cf-5d096427400mr8792a12.5.1732740297709; Wed, 27 Nov 2024 12:44:57
 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk> <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
In-Reply-To: <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 21:44:21 +0100
Message-ID: <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 9:25=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Wed, Nov 27, 2024 at 11:09:14AM -0700, Jens Axboe wrote:
> > On 11/27/24 9:57 AM, Jann Horn wrote:
> > > Hi!
> > >
> > > In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> > > to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > > (without any kind of refcount increment), and used in
> > > bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> > > which are used to enable userspace memory access from kthread context=
.
> > > I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> > > guarantees that the MM hasn't gone through exit_mmap() yet (normally
> > > by holding an mmget() reference).
> > >
> > > If we reach this codepath via io_uring, do we have a guarantee that
> > > the mm_struct that called bch2_direct_write() is still alive and
> > > hasn't yet gone through exit_mmap() when it is accessed from
> > > bch2_dio_write_continue()?
> > >
> > > I don't know the async direct I/O codepath particularly well, so I
> > > cc'ed the uring maintainers, who probably know this better than me.
> >
> > I _think_ this is fine as-is, even if it does look dubious and bcachefs
> > arguably should grab an mm ref for this just for safety to avoid future
> > problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> > means that on the io_uring side it cannot do non-blocking issue of
> > requests. This is slower as it always punts to an io-wq thread, which
> > shares the same mm. Hence if the request is alive, there's always a
> > thread with the same mm alive as well.
> >
> > Now if FMODE_NOWAIT was set, then the original task could exit. I'd nee=
d
> > to dig a bit deeper to verify that would always be safe and there's not
> > a of time today with a few days off in the US looming, so I'll defer
> > that to next week. It certainly would be fine with an mm ref grabbed.
>
> Wouldn't delivery of completions be tied to an address space (not a
> process) like it is for aio?

An io_uring instance is primarily exposed to userspace as a file
descriptor, so AFAIK it is possible for the io_uring instance to live
beyond when the last mmput() happens. io_uring initially only holds an
mmgrab() reference on the MM (a comment above that explains: "This is
just grabbed for accounting purposes"), which I think is not enough to
make it stable enough for kthread_use_mm(); I think in io_uring, only
the worker threads actually keep the MM fully alive (and AFAIK the
uring worker threads can exit before the uring instance itself is torn
down).

To receive io_uring completions, there are multiple ways, but they
don't use a pointer from the io_uring instance to the MM to access
userspace memory. Instead, you can have a VMA that points to the
io_uring instance, created by calling mmap() on the io_uring fd; or
alternatively, with IORING_SETUP_NO_MMAP, you can have io_uring grab
references to userspace-provided pages.

On top of that, I think it might currently be possible to use the
io_uring file descriptor from another task to submit work. (That would
probably be fairly nonsensical, but I think the kernel does not
currently prevent it.)
