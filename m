Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0DA23AD
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 13:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738156806; cv=none; b=fdxK08OvVtjVKfiEcUsguI+T3y6rKwIMM6GBRmyp4lOv53WIOL/hGMoKqzhqW/c2vik59YxvvEIjvr+nzrUCuw6trKqeiTsdbFF/c9qxCjBPCRNU0rT7FZhPRN9eeJ+hAjf1w773G3FOeDsmmP70d2MB/aknjgLVoUIK7mNpCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738156806; c=relaxed/simple;
	bh=peuzQRxLcZOMOzgrWwphrulzp+cj5EWTU/8yNTxbp5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ze3paS4uG4Azo8NjXBzepHdTBgaM+N01hqaShUJl64EW+ILffN3KGJzKZnqMdENq50sTVsl/0DNCu0/srPhCFdiidcgdD8rMzpHGtFss1HMjy1/tlmEiHuhgKn3NI4e0gCKpbkH4h20LAgNgI/BqTFh9d0da5krqU75wM84KkS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/NbaWv3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/NbaWv3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738156803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EnrxopPQtzOwNQ5afpRaG6zifnqXxokYRkRHUpSs4uU=;
	b=g/NbaWv398mLIc8dvbiohtGUikuv7RSZONQWdsVhu5uT70D6yeihttwFlw7/xEjxNm1RAY
	4/THUqEzP723iWZMHCdbmtxl6ccHUQDX75sqq3XSZXWzHxUrCSfyhQ3DzxmST5jsXxF/33
	TjVTukgflM94peb/j0H97BrAuGK8bEY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-p9l8vRZTMv-qcbRPDNL87g-1; Wed, 29 Jan 2025 08:20:02 -0500
X-MC-Unique: p9l8vRZTMv-qcbRPDNL87g-1
X-Mimecast-MFC-AGG-ID: p9l8vRZTMv-qcbRPDNL87g
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-21648c8601cso118184575ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 05:20:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738156801; x=1738761601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnrxopPQtzOwNQ5afpRaG6zifnqXxokYRkRHUpSs4uU=;
        b=QoADJQrgGd5ZqkiNcVXPuT006cskynSqDTcg8znKI2Cq/Q/Jfs/RTtCvG+47ZGSH3H
         riZW55f0ogyxGe2cEqCDQO3zxD0ncNapuEoLZxODdVWHviU/9oClK8LrlUxuT36L1Dbw
         uLZ++78Ga7axBClF4P723cKjeoiiB08OhRgyy6m6QWbjcoEk1I9D/4na133Xnrm3e6WW
         8sc6XUF311CfqdeXJhQX7bMzAxEz5yQ3eGgkh1cgoluz9ocnRfAjVV5c1HTNdCVV8Qxs
         sPbo6fwfnmwXBF5/dnpgk7CnkkADeeXLanjXil9Rc670Z1xZbj4r0Xo+hCVmTID9OyAK
         v3bA==
X-Forwarded-Encrypted: i=1; AJvYcCX5bn5j+U8WAj9eDYIF7tB6SjG7uAZZL/9Ne/EdDI8mgxwSsXZjeR93Rlha2pQKLN7A6yvwwBUSVsRjXHHhxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYnUbBzyjwp3v3D8vWzLAmqXcLS7FImoZG9BkVcdI9gk2R/TZP
	3Tfb0y1WxOl3iNUX8CnaICwUkl3oOKe3erJ89qi6dDcBcP8WfEcLnkZsgpZOmPKA730eJNxQp/2
	0TfE9tKArtDJbm4YCnmeeLUPXVlzKwtBeAu1iPyfEvRzRRyUWQfx7MS3PL9w81qjyV6ADxciaHZ
	6gwhVlYqlVp1pVsRqcE/eeAM47BNI5WBDvx68QDs4=
X-Gm-Gg: ASbGncsT6cNQ4LPA/wSM+PalLITRVwfYaNySWK3kH4+30sFrcGPzaC7/QuYFBNS7cXL
	It5hsOToepQjNkuuvTu/+gOvoDaz8/oUizPbwvq6lkxPNcWSJln1w2kgo/fK+
X-Received: by 2002:a17:903:11c3:b0:215:b1a3:4701 with SMTP id d9443c01a7336-21dd7d64c1emr46673105ad.13.1738156801132;
        Wed, 29 Jan 2025 05:20:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQOZFr2V4TbmZwoo+kjh3T0bkY5fZi6e4r8aC+hRmcxbxhVHpJsolfTlYRNmwWDDXduhCBAbyy0OdHsGwDTmE=
X-Received: by 2002:a17:903:11c3:b0:215:b1a3:4701 with SMTP id
 d9443c01a7336-21dd7d64c1emr46672865ad.13.1738156800881; Wed, 29 Jan 2025
 05:20:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128163859.1883260-1-agruenba@redhat.com> <20250128163859.1883260-2-agruenba@redhat.com>
 <aaac3569-2c96-45dd-bd3b-4a5080833767@commonscaretakers.com>
In-Reply-To: <aaac3569-2c96-45dd-bd3b-4a5080833767@commonscaretakers.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 29 Jan 2025 14:19:49 +0100
X-Gm-Features: AWEUYZmtzUeFlio5DE8H9dBw0ziDp6A5hWvbBPuPSisEKGVu7uJfHu9v2WZB-U4
Message-ID: <CAHc6FU5rWFosNax-1f9K4ihk-Y==Cd5RXj+xsHzxkyLvmdLmng@mail.gmail.com>
Subject: Re: [PATCH 01/21] bcachefs: remove dead code in is_aligned
To: Eric Herman <eric@commonscaretakers.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Shuah Khan <shuah@kernel.org>, 
	linux-bcachefs@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 11:32=E2=80=AFAM Eric Herman <eric@commonscaretaker=
s.com> wrote:
> Hello Andreas,
>
> On 2025-01-28 17:38, Andreas Gruenbacher wrote:
> > This statement does nothing.
>
> I would suggest this statement does nothing only in the case of #ifndef
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.
>
> In the case where CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS _is_ defined,
> it tells the compiler that it should not emit a warning for an unused
> parameter.
>
> Perhaps it should be moved in to an #else of the #ifndef in order to
> more clearly communicate that it is expected and okay to ignore this
> parameter in this case.

How about declaring base __maybe_unused?

Thanks,
Andreas

> Cheers,
> -Eric
>
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> > ---
> >   fs/bcachefs/eytzinger.c | 1 -
> >   1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/bcachefs/eytzinger.c b/fs/bcachefs/eytzinger.c
> > index 2eaffe37b5e7..c0fdfe909cf2 100644
> > --- a/fs/bcachefs/eytzinger.c
> > +++ b/fs/bcachefs/eytzinger.c
> > @@ -20,7 +20,6 @@ static bool is_aligned(const void *base, size_t size,=
 unsigned char align)
> >   {
> >       unsigned char lsbits =3D (unsigned char)size;
> >
> > -     (void)base;
> >   #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >       lsbits |=3D (unsigned char)(uintptr_t)base;
> >   #endif
>

