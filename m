Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4774B3C092
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878123; cv=none; b=dTMmhT5BsLfgQGqQFtWfny8FLxvbKf+VOyyuLkklpSRuyKvi/5Dhtrd6UjDO57OoWiWtVMeHtSQGwpQBs/qI4dMEZbX0qYX1HTqFAnBm/xQPJfX03XXa46auZeiXUYasSBwAooWRa69usKG0AmFNlDyJLk0W7MtYl5EpWWaNqMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878123; c=relaxed/simple;
	bh=tq/1pPtVk4bFy1TUWWqhNCcGUABz2Wn0gW+04VmLGUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZJuMMcY8gfT541iCOav4rjGHLIR36V26J8pezTCFhU85GBYxVUphgkw7LmCo62Pmd65ZZi0IL6LDiDon8+setvLpoMWPPcXjM+OmfnbqUCHqH5hvH1lI48gAbhulaWVSf/VDAavtxNS6ATFxmwSytCvss5yoRGCCdFSyb6aVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/Gg2Usb; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/Gg2Usb"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-366a04fb186so34035ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878121; x=1711482921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=i/Gg2UsbI+WuXMivJK5yDnCJA8uYabgTTBLxhQMw5fQ//qS+w29wcwbyExemOyWlcK
         DIQxAE5ceQYKlRHIBZ7kIXn68al8eQlCZMnrap7wG3IPdS9L1deXQ6doSUtoONwYSsC8
         DKFYVMsd2FPDL/C2RJcUGsLwd0+YLOzjJEsuCAes6fnRoLN2flirAsNsIpcXPNktLsZU
         I2wX8nwHBoZCEHxTBxfAxKIDzKF7EGFySyJxZuW2LIn2nXF73jYT1kTZLQtiefaNj+GM
         ifXMz9UBjHjeRqGHJOQIUD7sv8AwmEd51FXBaYxFmpAn785lNM1nv3NkklCGeR6xMsRo
         FYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878121; x=1711482921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=tpdi1TXYsoOBxJ+AceL76+nnjP7K2iINAEBkgz61Ngska9n9WzXD63s47F08ih0uix
         uviRovy1qqfJOPkDq0GA0++OIss5gkK2nGFPv/sDOqMxRPsz0JzihBuSP8/DguhJPlMX
         bcBSC3GRczXgHiWjnEu02LxvlhWgIghGM/qJsQKCyT6uS9OqA6qzdXcpM+aqMnaHK6DA
         dcrGWSolq93mkqnpmzQGYvkEJmznhoq1djvm6S2hAPmZAVbLvrc1Ayr+9rDnsYQX41ak
         yhXQwPVwsTw9EXhl6TslvdkX1IW+RViIf01TINhdaPojrDnwkBtNYUAvBAI70wOJ7wJt
         y6uQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM7gEksGjLA6+Y/fqut2GjhD4kUOsQbYecQHOB2z7Y8rh60MAiwvcwZ4CVJ8tWjgoL6n4xBcW90pVzQNG/ISFYQ5k1UxmBo2AdSRbz6BA=
X-Gm-Message-State: AOJu0YwFR3Xj6WzLszlWdmcU6RYEpDXAXH2w/WXpLHHVv44lJXBx9gFm
	tiO27snl9sWd4rFnxTGGOtr4I8bM8zv6CCPYwWyRKbQhQR21QGw+ef453UVi5sVqXIvRBGfOqf5
	Cp5lrea5By2H9tA37mhYO6HpchQincrzEzO0n
X-Google-Smtp-Source: AGHT+IERlmpYbi7scXHRweGWqKFANu4nCnjg91c1eLgZPt1tpqmLTiArMaKYHHFVGIrDmnNDhYnBI2oLyIaUqaSz3v8=
X-Received: by 2002:a05:6e02:1aa7:b0:365:a6a3:9c82 with SMTP id
 l7-20020a056e021aa700b00365a6a39c82mr63098ilv.26.1710878121279; Tue, 19 Mar
 2024 12:55:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-7-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-7-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:55:10 -0700
Message-ID: <CAP-5=fURxwVSddrNRhRwT4rWsRhq+BLkAzqi7ooZ6JQbPsOP8A@mail.gmail.com>
Subject: Re: [PATCH 06/13] lib min_heap: Add min_heap_peek()
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
> Add min_heap_peek() function to retrieve a pointer to the smallest
> element. The pointer is cast to the appropriate type of heap elements.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

I see there's coverage of these functions caused by later changes.

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index ed462f194b88..7c1fd1ddc71a 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -56,6 +56,16 @@ void __min_heap_init(struct __min_heap *heap, void *da=
ta, int size)
>  #define min_heap_init(_heap, _data, _size)     \
>         __min_heap_init(&(_heap)->heap, _data, _size)
>
> +/* Get the minimum element from the heap. */
> +static __always_inline
> +void *__min_heap_peek(struct __min_heap *heap)
> +{
> +       return heap->nr ? heap->data : NULL;
> +}
> +
> +#define min_heap_peek(_heap)   \
> +       (__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>
