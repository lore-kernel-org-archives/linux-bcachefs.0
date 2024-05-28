Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C913AA59
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716884385; cv=none; b=Gq3uVhEPflvyNwo4AvJDtURrKjbp8r7XIxbCVAcoTqfbE/dRkGS5z3fbeAkwGjl1x/SXVuhiW+nb0ieiJLxak0l58w3Xv9q4ZvFA92afOfIDsMnABncFc/Fam0saNFwzgWtwbTNlEz89rDogbTzN691Iast9ZoIZKpRhhAWfgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716884385; c=relaxed/simple;
	bh=APKFV9eb2v+VaT8bLUdlycdrBfJ2rlkBUd7qW2g0UHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCHgS6ZOwbDaVElNzFTNUTip2r2IwU7iXLaX60kL3p2DyiAGybo40I5RwWb7r9RPIC4HqDbe/ZIMyDNeFVgWTKrsbshMuoW1GcI27rt4PgcPV9VRkB4HvSP50ValA8n2PKNLAwLVow8UIBU5rwz3w3IpcDsCsBkgaez+bLxL3js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ISvD7liY; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ISvD7liY"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6ad97c087c8so847356d6.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 01:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716884383; x=1717489183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APKFV9eb2v+VaT8bLUdlycdrBfJ2rlkBUd7qW2g0UHk=;
        b=ISvD7liYK1sLfzoTUpCqHA+K/e2a9dfp8hMeBD/sByy7tzypcXcD9vov3UIhnInSSN
         z2PzxiLcOCspIsSqASDG59X6x8JCyVBatdgPYkUzIxsabctzw8UA2pH2HolEAzwFdraC
         NZWwkirqlxr8nyPY3iejFeN8N4d2zASwpuUqHxY4PGzzA4ROG7YdZYVJ7MccGWcmGnnD
         lvkMt/y90mdCpQ12Yi1AlZe0vNvNwFim8B7JPwB4v9Y4r9AdJsY+0VBuEkQWv59vpr/e
         1L2UeYxklQ1LZsOYqsHutTY+XI+kD/P77psBapIMa91iBY7U716xFGEXMFM058GKcM0p
         UB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716884383; x=1717489183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APKFV9eb2v+VaT8bLUdlycdrBfJ2rlkBUd7qW2g0UHk=;
        b=M8yR7pZGvD/vKPYXi4J34q5Qtw5mBj9grNI1ACaOOVo0IH953Weqz2mFJmHntYfrRN
         EDd4GwN7GYRg6qFUocXgVkrAvCtM3HHRvILkaCX3UkdWjddrPanPuG2kDRVQ7Nwp6J4H
         0h6suCxbgF79mzuaIM1B/khpMDQqeH+bVDyCAZgyY3lsBHI5eWGhxDLrE+I/dKXbhgCN
         j708sCjWbhx7YWlCf32L3kSmLujlRJaoIN/LpewPskNGs6sqU4vMq08LOrC6zE/LY9gv
         Ujywk4dBmNlqt55SgLkE5Y/Hz20Ab5WMuq2x9huayRlUG5E8NJLDHjlzc/Ns+zBN/9Lt
         FqaA==
X-Forwarded-Encrypted: i=1; AJvYcCXMAX9D3HrDj3ZNuGRwk+h/2waFUqen4w0QUT/XCwurK4oZRGgM/BhbeOvw/NmoV+q97q8qI62kALSX+rTSjANMlS+nGLK2w2W1ruGwvvk=
X-Gm-Message-State: AOJu0YzOe21Gmx5xYHlydftrCr7t/84sSYowshTaBF3tAJnJ+fxeMrKV
	7OPSsnAsGru3frWbfTop5GRyTq7IK4v+cbGyw4oRr9VubD7Z6G/Xa9PpoFy3L7IV19rznmyRenG
	3x4TWHJDvMpopGfpHZqPRhWdHPqLIVHI0LIiC
X-Google-Smtp-Source: AGHT+IG9kXoWpuC4Ix7V4wPnSa5HxxGbI3O7kucQ+Z4K1uR5nDxN08cLZOYJo2Jd8QQ3aZOHyTkIGsHohuSwHfrZh+0=
X-Received: by 2002:a0c:fe8e:0:b0:6ad:16a5:4842 with SMTP id
 6a1803df08f44-6ad16a54a20mr114449566d6.15.1716884382871; Tue, 28 May 2024
 01:19:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000009f9447061833d477@google.com> <jgtxdyooy6zyettrj53qi7s7z5fs5zpnwdjm7eqpihwo32lxzx@v2234ezsba4d>
 <CAG_fn=WmDCOXxAzaEJtDYuEY4b3Nq99Z7=1-tmwTx9Ox7BG0AA@mail.gmail.com>
In-Reply-To: <CAG_fn=WmDCOXxAzaEJtDYuEY4b3Nq99Z7=1-tmwTx9Ox7BG0AA@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 28 May 2024 10:19:02 +0200
Message-ID: <CAG_fn=WZ=i2WLAVcLGhXkfm_9CouEf8v9PoLL-zJ0TJZZSXZ6Q@mail.gmail.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_extent_update_i_size_sectors
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: syzbot <syzbot+eceea46e8838baeeba67@syzkaller.appspotmail.com>, 
	bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 10:15=E2=80=AFAM Alexander Potapenko <glider@google=
.com> wrote:
>
> On Thu, May 23, 2024 at 1:49=E2=80=AFAM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > This (and a few others I've looked at) look more likely to be bugs in
> > KMSAN, not bcachefs.
>
> Yeah, this is possible if we are missing some initialization.
>
> >
> > here, the supposedly uninitialized key was read in from disk, so the ke=
y
> > couldn't possibly have been legitimately marked uninitialized.
>
> Am I right that the key is supposed to be initialized before the first
> call of memcpy_u64s_small() (the _lower_ "Uninit was stored to memory
> at:" stack trace)?
> Do you have an idea what code performed the actual load of the data from =
disk?
> If that load was done by some assembly routine, we could've easily
> missed that - in that case we'll need to annotate it to fix the false
> positives.

I thought the initialization here was done by constructing a `struct
bio` in fs/bcachefs/btree_io.c and passing it to
submit_bio()/submit_bio_wait(), but I couldn't see return values of
btree_bounce_alloc() being used in bio_vec elements.
Are there other places that perform disk I/O?

We need something similar to kmsan_handle_dma()
(https://elixir.bootlin.com/linux/latest/source/mm/kmsan/hooks.c#L328),
but for block IO, so that data copied from the device can be marked as
initialized.
