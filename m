Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110B93C092
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877900; cv=none; b=dFcw773NJAq5Gg4ziifqNCy5ONf97YTqYdCmxz1w83Mlav/m8Xe/1gxig0dLsmugLMNcbhRoqWEjW5D1oDlGgzOkJRC273AVjRA6Rj/zZUYJdeNiqngZOypDwq24lpRvsUElTSS4bJUw/S+X93ymgBKQ9ygHMwOhWVvLGsvDf3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877900; c=relaxed/simple;
	bh=u5ISTVgLFXBHPytLP7czQVcemEzdgRVw+u5krgsn5QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i93c9MWJcdYolHMIZT9TRa/8NOlZEBhCTth7SIDst1WRR4WcG8kQMB7nzaI51yxbUORUSQwXwf/badHROrXooXCCxq7nA8R53/MlYkSvDNZHWSbjB9YTkW3egxvu7Y+xs8824kEUdm38Uwp+4FXZPz19O3kOijVtS80CuwEV5hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j8hm5QRA; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j8hm5QRA"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1dee917abd5so1415ad.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710877897; x=1711482697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=j8hm5QRA91NoXNsZMtjBMmSRGagPsBzX2iJSVImfSyJi1LmFDYrJ5+c1pOezGlbZE0
         5/IY6Qfx73bArihTLDmlyihtIXP5CD3WhBdbfMfrjcf6eldPT8LfO+7LRfTEffCdnDbr
         isJYxwH5tFEaJlMoPvGalXe4zl1CiJoWeSO3zF5X9HAgLqoU0UekFmXDN3wEdIoKGR7Q
         pVP54A38wvPbEPm74idtfRxoQvqQbPhygeMlkatZmD6Ruho59H0SfwvbDrTo3KDBdIBk
         Xhsn0hPph7UEm8bhKXirnnKnTc/ahgALYj22WsLRLrzTEeRaam4WRlj5cvpVVBcpajcD
         X9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710877897; x=1711482697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=E5thYkhRvOLd6ZyQT/v/KEfrGfYKt8R1EM2fBQU2rBV1Vqw1Ado7smCmDvEPzPQ6kk
         AxHsxPqHZvddfuq/ydQusWyArYvgoBpS5utj6FQH2cMGSwbhwJeAmRs+1fV5LAlMtPhc
         ye5oURQFu4SSd4tTijuZWsIWIBKdz3U8eAergNurujWy7UOdoiuUo2LczFCOhdFYanp5
         BZyt1r6hnOvxPX7Ve6VYrYY8tyVgVz5qNAyLGoeNhlkSXUD8GhpJias5YPmWmrDSRMoJ
         hcTW7887SzMPi5/AEnIpWPxVuYzRhjVZTOiGvKSDFUlHwqWdf6+Rsj0x+rAWv/1Hm77W
         X20g==
X-Forwarded-Encrypted: i=1; AJvYcCWgW5grNELT4ZGShJUkkfxNlR5PQ+mS5RbA72GrAWrrFSwiFlcTi6Xc4Y+NZ/gfzZuwba5C7dnTONOS7leUqa84pWw/c9IG2xSzszlPz10=
X-Gm-Message-State: AOJu0Yx1qxA1Di2/WV9I/qBuQl5Q42/hWLI44xz/vh1NyYWIJdbE+PI4
	R4IrN2MhCliUOEI3bNFvEAag2qCkgzcyxRIHNGoXlqbVdiMUQpHnaRbyPy0biOKAFVb1hZTf9NY
	X1itklvd94N1qnZ+BrnJeWrjEBmXfEQMs8eQl
X-Google-Smtp-Source: AGHT+IF+frKKJWR+nVJ2Vrwk/OC3+PDYLd1fNu1rRucHMrbQJorul6XLTLfqlvUhZfZc5d71eG8DO7rmDaJ3MYo16Z4=
X-Received: by 2002:a17:902:ecc8:b0:1de:ff9f:e760 with SMTP id
 a8-20020a170902ecc800b001deff9fe760mr68290plh.0.1710877897067; Tue, 19 Mar
 2024 12:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-6-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-6-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:51:22 -0700
Message-ID: <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>
Subject: Re: [PATCH 05/13] lib min_heap: Add min_heap_init()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_init() for initializing heap with data, nr, and size.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Should this change update lib/test_min_heap.c to use min_heap_init?

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index c3635a7fdb88..ed462f194b88 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -44,6 +44,18 @@ struct min_heap_callbacks {
>         void (*swp)(void *lhs, void *rhs);
>  };
>
> +/* Initialize a min-heap. */
> +static __always_inline
> +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> +{
> +       heap->data =3D data;
> +       heap->nr =3D 0;
> +       heap->size =3D size;
> +}
> +
> +#define min_heap_init(_heap, _data, _size)     \
> +       __min_heap_init(&(_heap)->heap, _data, _size)
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>
