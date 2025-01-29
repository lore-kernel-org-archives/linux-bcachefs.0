Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658FE1A8F97
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 23:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738192691; cv=none; b=FkmRVbiAZZauW0BVKJ3rBG/qdKKiPG5DBoWxDeRrzSkdWmOiCS90BKdQM7oN5ZToXOBGkMRcl5L/21/Fvn6QjQpfj+soCxtexvr3moaLk95K2jYqzECaIJ7d+NuRJrKo/XQln/MDkQf/SxK9jx31gTG1o6LQ9AuvP7MZJ+PGZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738192691; c=relaxed/simple;
	bh=+B49m9IUkhXD30orNv+/xeTmiSHWH28m+HjpA9vJuRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ej1gpjkwkOkyza6Uc4wxZ7GfKuIBOXdMOh/73yzKLrvTPrsCfIL4rN+qFNyxXp0TEMLs4L/Bx9HxiBmwdDls8kT8ZMN5bJEDu+KTvFhWhcdN1Ii+4w/RPECGFLiZsjmtdoy5fju6JoYJRAtrRWEAOccQv1LsiZRmAPk2/9dDkGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UtGzpaIt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UtGzpaIt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738192688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbqU+4TJfsH6reEBEqy0eMHPD7dU0gZz4x/iJbG3ats=;
	b=UtGzpaIt6eZHNPKcxCUzL/HZ4k5OnCpcgeMsNTBeBgErucLtqji0HnwbsFhD4pubYHgKKe
	C7cUjRfALlhavsvff+L8xdOG4JDl6o5DBXYPBE1p83fPdoqtashUIS7bMWU/2hTSV+eHYT
	yHoM2Wz2YUv5u+yc5tBda8F8PM3sNfk=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-XaVc48EDMryrrskF47sGwQ-1; Wed, 29 Jan 2025 18:18:06 -0500
X-MC-Unique: XaVc48EDMryrrskF47sGwQ-1
X-Mimecast-MFC-AGG-ID: XaVc48EDMryrrskF47sGwQ
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2163d9a730aso2558685ad.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 15:18:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738192684; x=1738797484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbqU+4TJfsH6reEBEqy0eMHPD7dU0gZz4x/iJbG3ats=;
        b=LXa157u+Q/Dyl9Se7RpxSYe6lIBhlxBQ5dMzt6Z/kXsEiuARORBpYgT5MlQzB19jes
         /qwygB2IKjbX9BAoOhOntlpYjxzKStUsToYTEcxVdFKcmmxkqJ73hJpVkL4I1JH5cH1m
         WTjuYfPaBiByQIQT8T9L18XGcGOlcLSgnnWiUfIecx0TXALut76oyupVlvVpimf07QY/
         NoSwnh+PzELuEeUabeNiT7OttgpiyR8w/AJ1dSdIELvr7sNYgG4iwFnJnPu656lEqoAa
         3Rj4UkISQntyz2a0IiuBhHi/fNJ209N1I6uv0VKA71OEq6lBEuI8/oSJtI09sM55FpyH
         TBhA==
X-Forwarded-Encrypted: i=1; AJvYcCWtYIuqO9EQxZWuAhRztjNjup6a9Lxlo91cD+eoKFUQ4Uzjlf5D6C01ae6mD/w0ZI3x6JZ3kKYF602uHAwr2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSxjQS2CZvn7M2XGEjAGrRxwWlMaIYppdxupq772R8SJ2zP6LR
	F7lTbn4fQj/6oSC622zxzX+P5UDgTk0/948R6wpEYz2HxyWivHTNfLc58P+258AL2myKrQ4lN8P
	gYx7POyeTRJZ5S+Q/MQb3nHTmI0SiZLK/W79QBvyza3/1+vDWhQThoK1VzKAYOVGE5e9L2fVBgF
	IzMmgToN3JP+PYY3dh+CgHtHo9IEC1X677Yf8bdBy3R172qfn5Fg==
X-Gm-Gg: ASbGncvH9F9EbxH0h5MvoIU+dGAFf4wpUQ2wVlp0/G5x/MdsFbj7tSuB2nI5PqZChcL
	BjdQZjrRwrysr6tNoEHR+QoLw+SUzGkEREHJpacyB7R7KuluCl39LPHkQBeOJ
X-Received: by 2002:a17:902:cecc:b0:215:3998:189f with SMTP id d9443c01a7336-21de19566bemr16077595ad.6.1738192683828;
        Wed, 29 Jan 2025 15:18:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGkJmxG4jPiCULJCmtPlFjZUm44urca4ftNYg6S4q7Zh27QEwohoN1rSLUbKUdoz5/gIVyDg0mQsLTuvG4Kzqg=
X-Received: by 2002:a17:902:cecc:b0:215:3998:189f with SMTP id
 d9443c01a7336-21de19566bemr16077335ad.6.1738192683440; Wed, 29 Jan 2025
 15:18:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128163859.1883260-1-agruenba@redhat.com> <20250128163859.1883260-12-agruenba@redhat.com>
 <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
 <CAHc6FU6Yzk1Si37nRji-5uDZF9uaYo=G5tbtuS_5FiW6BDVTAg@mail.gmail.com>
 <rddasfmbw3ul2iezec7rgit2vxnv4p53uvoydck4b5jxuo44kq@7qlk5cru6w7r>
 <CAHc6FU7oZxP1cy6uihH=m9i=0z8PmCtozwQs2HgnqvbTDhAd_g@mail.gmail.com> <nxabgljkslxwr27wrzgjxao2nr3jh5leytj7f3pjir3t27uf5w@zcdmd4phur2m>
In-Reply-To: <nxabgljkslxwr27wrzgjxao2nr3jh5leytj7f3pjir3t27uf5w@zcdmd4phur2m>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 30 Jan 2025 00:17:51 +0100
X-Gm-Features: AWEUYZnuEtXexgZDdfLWcZJGiewhsvfqT4ZybhlOzAvks9ehbvkhLjS3Pvmq8jg
Message-ID: <CAHc6FU7x8MbRLA9ELYiDM+Srz2FNzOzr28yztBA=CrPsj8X43A@mail.gmail.com>
Subject: Re: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 10:30=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Wed, Jan 29, 2025 at 10:21:31PM +0100, Andreas Gruenbacher wrote:
> > On Wed, Jan 29, 2025 at 9:28=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > On Wed, Jan 29, 2025 at 07:21:49PM +0100, Andreas Gruenbacher wrote:
> > > > On Wed, Jan 29, 2025 at 7:04=E2=80=AFPM Kent Overstreet
> > > > <kent.overstreet@linux.dev> wrote:
> > > > > On Tue, Jan 28, 2025 at 05:38:48PM +0100, Andreas Gruenbacher wro=
te:
> > > > > > Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() =
and add a
> > > > > > new eytzinger0_find_test_val() wrapper that calls it.
> > > > > >
> > > > > > We have already established that the array is sorted in eytzing=
er order,
> > > > > > so we can use the eytzinger iterator functions and check the bo=
undary
> > > > > > conditions to verify the result of eytzinger0_find_le().
> > > > > >
> > > > > > Only scan the entire array if we get an incorrect result.  When=
 we need
> > > > > > to scan, use eytzinger0_for_each_prev() so that we'll stop at t=
he
> > > > > > highest matching element in the array in case there are duplica=
tes;
> > > > > > going through the array linearly wouldn't give us that.
> > > > >
> > > > > For test code, wouldn't it be simpler to iterate over the test ar=
ray,
> > > > > testing with every element as a search value? There's enough corn=
er
> > > > > cases in lookup that I think it'd be worthwhile (and probably add=
 some
> > > > > extra test values, e.g. first/last elements +1/-1).
> > > >
> > > > If you expect to get the same index back, that won't work when ther=
e
> > > > are duplicates.
> > >
> > > No, but we wouldn't expect to get the same index back if we're testin=
g
> > > every combination of elements (+0, -1, +1) x (le, ge, gt) - and it
> > > sounds like perhaps we should, if you've been finding bugs. Thoughts?
> >
> > I don't really know what you're after here. Function
> > eytzinger0_find_test() already tests every combination of elements
> > (+0, -1, +1) x (le, ge, gt).
>
> Ok - it can be hard to tell looking at isolated patches vs. being able
> to fetch a git repo. Do you have it in a branch I can fetch from?
>
> > The full scans of the array in eytzinger0_find_test_{le,gt,ge}() are
> > not there to verify correctness; they're only there to produce
> > slightly nicer debug output. I'm perfectly happy with removing that if
> > you prefer.
>
> No, not at all
>
> > > I think the test code would have to do short linear searches from the
> > > test element, and then verify the search functions against that.
> >
> > What for? We already know from the eytzinger0_for_each loop in
> > eytzinger0_find_test() that the array is in eytzinger sort order, and
> > we also know from eytzinger{0,1}_test() that the _prev() and _next()
> > functions are doing "the right thing". So the one thing left to verify
> > in eytzinger0_find_test_{le,gt,ge}() is that all the search functions
> > always return the boundary element. That's done by going to the next
> > element in search order and by verifying that it no longer fulfils the
> > search criterion.
> >
> > > Have you spotted any issues with searching over arrays with duplicate
> > > elements?
> >
> > Only that eytzinger0_find_ge() didn't always find the first matching
> > element in the array; see patches 17 and 18.
>
> Gotcha
>
> Ok, it sounds like everything I'm after is there - give me a git branch
> so I can read through it that way and I'll be happy to merge when you
> say it's ready

Sure, I've pushed the patches here:

  https://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux.git/log/?h=
=3Dbcachefs

Note that you don't want to merge the following patch:

  bcachefs: Run the eytzinger tests on modprobe

And this minor one should probably be changed to use __maybe_unused or
dropped; not sure which of the two options you prefer:

  bcachefs: remove dead code in is_aligned

I've only run the self tests. They seem to provide good coverage and I
don't expect any trouble, but some real filesystem testing would be
great.

Thanks,
Andreas

