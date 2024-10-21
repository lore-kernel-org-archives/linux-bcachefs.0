Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378A71F9400;
	Mon, 21 Oct 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729523636; cv=none; b=NB9WaKWBUBkAJ6WBaXB/5y7PStJssmOTJtiH6Zio35WCn+dGfmF9OeQcTDr2k+jNyEzCwfFP0Rgw2l5OgMPkQrTuR2N/MvpKuKkKMTSqPMb4mu5uyL5jHJYrXFdUJS6ikAguAk0kTphaLKUnsYq0aBNIE8FHYN4IR7hdbGxBxts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729523636; c=relaxed/simple;
	bh=49N5VKSySbtliRwXOzIYpfzoQzjDrQP7uCdd295VepQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=r/C1t51QB3AZ2PxQ8LK4K3fL5l3Ek0Tio7sfVuZh1s97weFeD9+SZSsBLwLsVGaAAR3OUG6G2qz4xrBbU6D8ASz+ztfIvVbR2xsD5A182xKnAZWpu1ocWuHBpIuggSZneJV1VPrMGfGw0wfu1XzFOWkffhLwLgVaAOFPk2vgV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bgk9sQT2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bgk9sQT2"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c6f492d2dso53183455ad.0;
        Mon, 21 Oct 2024 08:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729523634; x=1730128434; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxYG0K82tGIikDdAvIHwwgggZl99rm7a6utz2gNU0e8=;
        b=Bgk9sQT2Ynrq1C3bYcinyV+zmGExcKIf+5Jyrr1pv7LPnZK03D5KdpBjUUu0E98pTE
         nEyjRDWNGrjR4XSNOkCJWZqfUDhrh2/YFyr2GXp18idwlGFtn6j8wWJGCpDB5Tt4xeyS
         3wzS2pcq8+XMc1wFSTyHNb86jIGB17ITlKbTo6lMd4J/ebYb3v8K5KoF9PQeuLrP6E3B
         oaIjYOZGHvZWOtYqebpNce5KkiFBkaru6cEC/V90QTdYouJV0bczHaeRynulMHT1w3CF
         FYAj4UThOLgcb7jvUELH4KnmKemruTApWGhgCkZlaQj4iQvXM6tGmaVlY6vaHl226FSe
         lMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729523634; x=1730128434;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxYG0K82tGIikDdAvIHwwgggZl99rm7a6utz2gNU0e8=;
        b=lz8H9JmD1MP4OMyGArfcgsB+HiwGmrYFocKAM0JuyHMtkrAPen7cyN9m63+IS7Mrpi
         +Z7bSYJseIaqJEdQrRotwdMF+C1LFVB2h1WAfdBU57bdN5/C7Z7WzAlNMaLdw1Ju3KHZ
         CYrvStkNDS+S6B5F2Zy0M/KxRSkLxzvr4iO7QwWQYN8KP0Fkvwx4PKfL9AlIqNDW1RMv
         +8Qg02ri3DKcXJd9g+TLQlFT1eH+mtQov5idoSz8UDDpuCtzCgRQ8ENWNDI8NeFLCC4N
         4MBzITqszH6RBA4LSwp44ZzudQSz+jpBe4scBUCcwn92GvYQppwtDUa/vv8+OdGjqBqc
         P3UA==
X-Forwarded-Encrypted: i=1; AJvYcCWVPBz2OWqeFat/03R0DH89QweHJoDLlbEiJJx68R1rQZw03Xyl3tRyGvzc+1A2jZ7//VcM2jHimp2jDTAN@vger.kernel.org, AJvYcCXfGdf/xqAsnLKjRnsOi8Sh9TjVGtUg6Ji8fhvyH5IvyBQFCgG8UeKTf+fn3zKZnDAQD+2No1/5OdgdBW/gZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWTe1sykcRqCGEk7dIRe4eJMVeVG9GLgKNixofe9LQCUYlockQ
	YjB7Hi2GuY9UDdvJgU/0IjTPTDUm6tbpAUHiZ0OLn0bWlkvgDUS10c/9vRfP
X-Google-Smtp-Source: AGHT+IF1xmuPRiFmthIiN+NHjFojO2ALGYc5pakgdevqHg7LKpXEuBfV1fcpi4mGORPshWWn/pyeQA==
X-Received: by 2002:a17:903:2a90:b0:205:8407:6321 with SMTP id d9443c01a7336-20e5a70d669mr160210395ad.9.1729523634259;
        Mon, 21 Oct 2024 08:13:54 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee6583sm27348195ad.8.2024.10.21.08.13.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:13:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v2] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20241021151036.34383-1-aha310510@gmail.com>
Date: Mon, 21 Oct 2024 23:13:39 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E6F9687B-700A-4A02-8A7F-4C9ED648D746@gmail.com>
References: <20241021151036.34383-1-aha310510@gmail.com>
To: Jeongjun Park <aha310510@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)

On Oct 21, 2024, at 23:10, Jeongjun Park <aha310510@gmail.com> wrote:
>=20
> The size of a.data_type is set abnormally large, causing =
shift-out-of-bounds.
> To fix this, we need to add validation on a.data_type in=20
> alloc_lru_idx_fragmentation().
>=20
> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> ---
> fs/bcachefs/alloc_background.h | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/fs/bcachefs/alloc_background.h =
b/fs/bcachefs/alloc_background.h
> index f8e87c6721b1..91eb96b19a76 100644
> --- a/fs/bcachefs/alloc_background.h
> +++ b/fs/bcachefs/alloc_background.h
> @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum =
bch_data_type type)
> static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
>      struct bch_dev *ca)
> {
> + if (a.data_type > BCH_DATA_NR)

This should be  >=3D ?

> + return 0;
> +
> if (!data_type_movable(a.data_type) ||
>    !bch2_bucket_sectors_fragmented(ca, a))
> return 0;
> --

