Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21792AE7C
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738185708; cv=none; b=Pgyu6j/q7S7eah4lcUcSjYQhD7hYZlxk3kRj4agTZFBP8weaabZwYVgelO/rtLxgeKi9SAefE7g4zSuW2PP/UVgalfFEj7Cg/sOvHF0qfr4L5YsGlcx8xMoKjnyjH3mCIthzhWCfwci48B2m2MH468MPQKw182okhlvqehS/wAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738185708; c=relaxed/simple;
	bh=RobWR3W+k8C+CJCrQ4Q+6jdj9PcWOKqhIs8hko5VTi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U9Dh5JmZmGDTEW41ZVGZXdNvcPzgJutzbpfOMOV9I70N119dgjul0Z2Tu4g10JOnpFpV8HlQ7fBX2LAd+ih/q5HQ+1l8y7bq2jnHx2ZkOc86ETZKLe9+DeylgdGDBd3GiLwZSmXWW/eddDT3SQQld7LtCEpZT3QmERBpy/oPTSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cyCGREp8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cyCGREp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738185705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5B5s1soOSVtHPF0j3YsjMfi+df/kHS6e1AwQLgHvws=;
	b=cyCGREp8RH8G0OldOZDNvzKfji8OZMrH3RWKjtDJ3XJlhx5hpgpCZkeGOjDmsvflqqBm0l
	gZMuWn0Eb3Lc9zvDA8Sdwn1q/xANHln3TlZ4ORTwjVhZPgSsS00Wrd4aBol/5C8QOAv9cb
	+i/xM662K6jaZ4z35cgCg60xSEctDPw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-q45wtvZePWOaVWaF21YP_g-1; Wed, 29 Jan 2025 16:21:44 -0500
X-MC-Unique: q45wtvZePWOaVWaF21YP_g-1
X-Mimecast-MFC-AGG-ID: q45wtvZePWOaVWaF21YP_g
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-21648c8601cso1345625ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 13:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738185703; x=1738790503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5B5s1soOSVtHPF0j3YsjMfi+df/kHS6e1AwQLgHvws=;
        b=qGyD9CPh3iGkkHp24o+4aCNyLoxpFWMGuCcnxi1kkKSnFXRRJ4YENQnJFFJd6tBG+K
         8xwxuhx+Po/U7UkCqT5xwAeYOPCwowsH4y2KNVZatmZ2gLkSkMqe6vkN4w8/rhqaX/7a
         j8bE/4vdiW4AHmibPcoVuhwNsrfgmrMNISIyUOoTk+DP+OQSsiHG1FtZHucst0ifuIRG
         nWlgKyr9CBUzQY/3RPmaAi5FcugQL/Ja8xXG42OMeshwGmlJI+iZfsTwMagosA6T6Vox
         3h66syYbwYraCoQeUyVUaRsY7QoTS1JGgM8Zqw4G2VCRgSOy5sfvcDbJ5fwsjhnuxnzS
         XfHA==
X-Forwarded-Encrypted: i=1; AJvYcCWYLhNRyGuZtxPwSE1pdZCCJWfedSfvIrOVRwaF3yFaLhDWDazjQW7S1Wg6TWHilN88JfdqKm5mOvfqkd4j0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVFx33DNikaipJqEMqq8CJ7cSTDpwcEvnEniiXBuRpTDbU3l3F
	Jgl5QWcLXww8a1NhfY8P9a3wROFcERSl+UO9asBwUs5C8Z7MaQXqk+XURuAjbrehVVv+aywP+UZ
	Ujeweor3RDzGDa3uxY+oGkbwzVUL26INK4hrMEbfw6rgCJ1EgVnOqjESGOnBxuyLDVHRrOakQaU
	EGnLCOpF1KUIR193amiOUFIi67caDJvJxA4NTmJDY=
X-Gm-Gg: ASbGncvJC3uQ6C56RgGlKo3QC0D+BhmsFAVyx+SzmOEY8n5p0H54hxvOf0cez3Z9Ntn
	nOI6Ja9wpMpfJycDuMPCFyZqaOradEpb6QBh4DJTkf2GpHWE19+iETUr5HXv4
X-Received: by 2002:a17:902:e751:b0:21d:dae6:d956 with SMTP id d9443c01a7336-21ddae6df49mr57143795ad.24.1738185702995;
        Wed, 29 Jan 2025 13:21:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiQ3DFwtHCzWWCjvRJXFfmr9YJZG0hu8Kfc0/zDrtvtrpQixJI5+VyKmiJNCy1/A45b9C5zMyPhFhX6sJ7WPM=
X-Received: by 2002:a17:902:e751:b0:21d:dae6:d956 with SMTP id
 d9443c01a7336-21ddae6df49mr57143535ad.24.1738185702630; Wed, 29 Jan 2025
 13:21:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128163859.1883260-1-agruenba@redhat.com> <20250128163859.1883260-12-agruenba@redhat.com>
 <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
 <CAHc6FU6Yzk1Si37nRji-5uDZF9uaYo=G5tbtuS_5FiW6BDVTAg@mail.gmail.com> <rddasfmbw3ul2iezec7rgit2vxnv4p53uvoydck4b5jxuo44kq@7qlk5cru6w7r>
In-Reply-To: <rddasfmbw3ul2iezec7rgit2vxnv4p53uvoydck4b5jxuo44kq@7qlk5cru6w7r>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 29 Jan 2025 22:21:31 +0100
X-Gm-Features: AWEUYZnLMn0BfwMoxgEY5raT0-dNixUOgtPWdpFrR_-TsOntnYQ54oO31qd_ZLs
Message-ID: <CAHc6FU7oZxP1cy6uihH=m9i=0z8PmCtozwQs2HgnqvbTDhAd_g@mail.gmail.com>
Subject: Re: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 9:28=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Wed, Jan 29, 2025 at 07:21:49PM +0100, Andreas Gruenbacher wrote:
> > On Wed, Jan 29, 2025 at 7:04=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > > On Tue, Jan 28, 2025 at 05:38:48PM +0100, Andreas Gruenbacher wrote:
> > > > Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() and =
add a
> > > > new eytzinger0_find_test_val() wrapper that calls it.
> > > >
> > > > We have already established that the array is sorted in eytzinger o=
rder,
> > > > so we can use the eytzinger iterator functions and check the bounda=
ry
> > > > conditions to verify the result of eytzinger0_find_le().
> > > >
> > > > Only scan the entire array if we get an incorrect result.  When we =
need
> > > > to scan, use eytzinger0_for_each_prev() so that we'll stop at the
> > > > highest matching element in the array in case there are duplicates;
> > > > going through the array linearly wouldn't give us that.
> > >
> > > For test code, wouldn't it be simpler to iterate over the test array,
> > > testing with every element as a search value? There's enough corner
> > > cases in lookup that I think it'd be worthwhile (and probably add som=
e
> > > extra test values, e.g. first/last elements +1/-1).
> >
> > If you expect to get the same index back, that won't work when there
> > are duplicates.
>
> No, but we wouldn't expect to get the same index back if we're testing
> every combination of elements (+0, -1, +1) x (le, ge, gt) - and it
> sounds like perhaps we should, if you've been finding bugs. Thoughts?

I don't really know what you're after here. Function
eytzinger0_find_test() already tests every combination of elements
(+0, -1, +1) x (le, ge, gt).

The full scans of the array in eytzinger0_find_test_{le,gt,ge}() are
not there to verify correctness; they're only there to produce
slightly nicer debug output. I'm perfectly happy with removing that if
you prefer.

> I think the test code would have to do short linear searches from the
> test element, and then verify the search functions against that.

What for? We already know from the eytzinger0_for_each loop in
eytzinger0_find_test() that the array is in eytzinger sort order, and
we also know from eytzinger{0,1}_test() that the _prev() and _next()
functions are doing "the right thing". So the one thing left to verify
in eytzinger0_find_test_{le,gt,ge}() is that all the search functions
always return the boundary element. That's done by going to the next
element in search order and by verifying that it no longer fulfils the
search criterion.

> Have you spotted any issues with searching over arrays with duplicate
> elements?

Only that eytzinger0_find_ge() didn't always find the first matching
element in the array; see patches 17 and 18.

Thanks,
Andreas

