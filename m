Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133571E1C36
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738174926; cv=none; b=k2MdNVTej56f5Wr4ash+S+kjPBn5Nhn2VLsVVzp7i/WeJMEGWFOYU+vpkwHcrsP2+W8i8Dd0UPuVl55Ywh9xrP31gJAWxBJNGiLXGGh32NRcf+EihEaDKv2ArL8pnPd3b/fviM+T/yo5mP1sdk+SRKDZUeT17C8o2d88WW5iCm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738174926; c=relaxed/simple;
	bh=lsaUG6o3qihqxjqzbj4fHVtLhJfu4dvDi15dE28PoFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jgFA/SwJM4wELk/woythu6hqrUpWrK7gjmLVLfIAPaXy/HYVKEes5ISDUEG7Eg7ttZMx/aT4rl5HDk3DNs2lA2aS6qZ3U1AtTKroc/8TNmawcFqHryrThd7JIjraNi/O1NTE8IpwEtzbMZcBxGRmvAgU4z4wg6wBhgbeV9pH2QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vwg/LGl6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vwg/LGl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738174923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vwvdh5o59AfjX+xyiOuePStNuB1CoftM4eJYE4dSFr0=;
	b=Vwg/LGl6yVbSCzD/TKQbjuRIEV2vBvPNizpELUxLZMGSNcrix6KhTMtg3GGLMp1N6bnw6m
	MrpzvmmA2zhC6F9ttwgkzOYPAjtDI8zvfj4N0WeZgykIVSQyDVY0fh2ftGzXW3gMgBH4F2
	oqp61Yx6FJlTDJbHqR/h6lNSSyYtPIU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-PumtaeSmPlmOwpaJ_3AhJw-1; Wed, 29 Jan 2025 13:22:02 -0500
X-MC-Unique: PumtaeSmPlmOwpaJ_3AhJw-1
X-Mimecast-MFC-AGG-ID: PumtaeSmPlmOwpaJ_3AhJw
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2166464e236so211549625ad.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 10:22:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738174921; x=1738779721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vwvdh5o59AfjX+xyiOuePStNuB1CoftM4eJYE4dSFr0=;
        b=l8FdhBESE82OVISt35nCUFBRc+pjSFJjQdpj5smGyLSScJDHuU33KcRumsPndOm0nr
         W54BS89Auh9h/RCUuOvoxoRxtiodHYUqbE/PIx1lw0tqnfuWjJ96t0g4FQicRD81xA33
         TIsSMRh0fOJWkES6bxt04xNgURq4hBuY5K08sXyAWS+QLK0W1zmNM6KrOcpfUM4qgi1V
         UfbBID4zEMuc5X6YpPz/YNPCLtXMrzFyuEB4x/sQaQCMrkXdBDRCqTYfQxpFv/u/WVjw
         ysenm7ac7nv8ineup824gBi6RX6Wh4MeCk3hYHH94R17cfzuFJzn5EKWRTj43zt+kmX5
         ytHg==
X-Forwarded-Encrypted: i=1; AJvYcCVIJa2AY58lKKmsFC98jw/pMzFoV6P/x02dHMvP553xfg/97UXRJ7q+8yZOcFwmSvttndjd1963IXN1U02nLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzuDxn7MCJ5a8wA8dxWhK4+waWtF0/5FhZv0FtuVaJPmHsyeFoj
	SdFRc/7M56AXczecDaE6RndNAy4wX32K+OyUi+rb4NGnLVN/thTLFDk0eN08XBVdi9hBHqQenaF
	IqXUKVQvFnamMf+9c3pnYtAhChnZ0YuozY3m0TtDwh0t10RQabNHDsG8WjDVl7fMN6v3VJAexum
	9bZIjw3WopC1JkS5IvSFzXQOqtF8Exgeml7Xfmn4M=
X-Gm-Gg: ASbGncvy+RRV1qzf3I9M6WoM9LEbAw0br+NJcbik0gaM8Lz0GnarzrXGbzcUE9vgdUF
	RVLXK/RuxVT+PvkLLXaAbUhKivD3a2FUeWLSThMcTY+ROjkINBQe7oo0sLMW4
X-Received: by 2002:a17:903:191:b0:215:a3fb:b4d6 with SMTP id d9443c01a7336-21dd7c46c2bmr52962925ad.8.1738174921339;
        Wed, 29 Jan 2025 10:22:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFptm1UwGo2W05+wxJUDKK2S8w38oe09PVLSommj0ey+wlSbU7v2JPCWDRl68vDt0awHZUBWs4SYgdxF0NnzuM=
X-Received: by 2002:a17:903:191:b0:215:a3fb:b4d6 with SMTP id
 d9443c01a7336-21dd7c46c2bmr52962655ad.8.1738174921020; Wed, 29 Jan 2025
 10:22:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128163859.1883260-1-agruenba@redhat.com> <20250128163859.1883260-12-agruenba@redhat.com>
 <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
In-Reply-To: <ajfehauvtid4d7pqy7o3uhe6p7buohwe542wqddkwpdq62lr4g@6cgcfpzcyag3>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 29 Jan 2025 19:21:49 +0100
X-Gm-Features: AWEUYZkSBdaXjPPHE2wqhh6qQSkUStuBuJVEdnsHM8It449daZy7EWOkh9lv5f0
Message-ID: <CAHc6FU6Yzk1Si37nRji-5uDZF9uaYo=G5tbtuS_5FiW6BDVTAg@mail.gmail.com>
Subject: Re: [PATCH 11/21] bcachefs: improve the eytzinger0_find_le tests
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 7:04=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Tue, Jan 28, 2025 at 05:38:48PM +0100, Andreas Gruenbacher wrote:
> > Rename eytzinger0_find_test_val() to eytzinger0_find_test_le() and add =
a
> > new eytzinger0_find_test_val() wrapper that calls it.
> >
> > We have already established that the array is sorted in eytzinger order=
,
> > so we can use the eytzinger iterator functions and check the boundary
> > conditions to verify the result of eytzinger0_find_le().
> >
> > Only scan the entire array if we get an incorrect result.  When we need
> > to scan, use eytzinger0_for_each_prev() so that we'll stop at the
> > highest matching element in the array in case there are duplicates;
> > going through the array linearly wouldn't give us that.
>
> For test code, wouldn't it be simpler to iterate over the test array,
> testing with every element as a search value? There's enough corner
> cases in lookup that I think it'd be worthwhile (and probably add some
> extra test values, e.g. first/last elements +1/-1).

If you expect to get the same index back, that won't work when there
are duplicates.

Andreas

> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >  fs/bcachefs/util.c | 41 ++++++++++++++++++++++++++++++-----------
> >  1 file changed, 30 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> > index 3fe9a3b8c696..c772629783f3 100644
> > --- a/fs/bcachefs/util.c
> > +++ b/fs/bcachefs/util.c
> > @@ -782,29 +782,48 @@ static inline int cmp_u16(const void *_l, const v=
oid *_r)
> >       return (*l > *r) - (*r > *l);
> >  }
> >
> > -static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16=
 search)
> > +static void eytzinger0_find_test_le(u16 *test_array, unsigned nr, u16 =
search)
> >  {
> > -     int i, c1 =3D -1, c2 =3D -1;
> > -     ssize_t r;
> > +     int r, s;
> > +     bool bad;
> >
> >       r =3D eytzinger0_find_le(test_array, nr,
> >                              sizeof(test_array[0]),
> >                              cmp_u16, &search);
> > -     if (r >=3D 0)
> > -             c1 =3D test_array[r];
> > +     if (r >=3D 0) {
> > +             if (test_array[r] > search) {
> > +                     bad =3D true;
> > +             } else {
> > +                     s =3D eytzinger0_next(r, nr);
> > +                     bad =3D s >=3D 0 && test_array[s] <=3D search;
> > +             }
> > +     } else {
> > +             s =3D eytzinger0_last(nr);
> > +             bad =3D s >=3D 0 && test_array[s] <=3D search;
> > +     }
> >
> > -     for (i =3D 0; i < nr; i++)
> > -             if (test_array[i] <=3D search && test_array[i] > c2)
> > -                     c2 =3D test_array[i];
> > +     if (bad) {
> > +             s =3D -1;
> > +             eytzinger0_for_each_prev(j, nr) {
> > +                     if (test_array[j] <=3D search) {
> > +                             s =3D j;
> > +                             break;
> > +                     }
> > +             }
> >
> > -     if (c1 !=3D c2) {
> >               eytzinger0_for_each(j, nr)
> >                       pr_info("[%3u] =3D %12u\n", j, test_array[j]);
> > -             pr_info("find_le(%2u) -> [%2zi] =3D %2i should be %2i\n",
> > -                     i, r, c1, c2);
> > +             pr_info("find_le(%12u) =3D %3i should be %3i\n",
> > +                     search, r, s);
> > +             BUG();
> >       }
> >  }
> >
> > +static void eytzinger0_find_test_val(u16 *test_array, unsigned nr, u16=
 search)
> > +{
> > +     eytzinger0_find_test_le(test_array, nr, search);
> > +}
> > +
> >  void eytzinger0_find_test(void)
> >  {
> >       unsigned i, nr, allocated =3D 1 << 12;
> > --
> > 2.48.1
> >
>

