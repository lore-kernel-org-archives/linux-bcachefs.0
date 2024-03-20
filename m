Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67569DEE
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954832; cv=none; b=O5Bu/1z/wHaJtS+QFsEt24TxP2W2YTTCzYjIj2Neh8rvfF1myQ7JgISpsFYuiCenYli47JUtffEb2jga7SJz3yw34+4IxYWaDAn4XnisNsjVszCSNcOHKPuP/3SkIVcMCb6vB9Yg9+2BbpQcC7+4brEa59lRHCezilhKrssUEX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954832; c=relaxed/simple;
	bh=Z2QMshSRUV/Ic6Kf5osNo4mJkuPuXiVLb5k5is3/ucs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBfnGSWASa/HHfi8XlrpktGR76TOehy7upWTO2OutI5L4cfL1DB85hB+vyv5OJ86JUlBAAvsEANH81tQjGbMDqdACmVRnN4rsU/VWOkL5xFPRDilEYYVUywCFePjad6BtOLHPZ2mL5njfDtp3+Pwp49PnZvrvmeM3GGMiMIO1OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZK+zV9NB; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZK+zV9NB"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e058b9e479so8675ad.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 10:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954830; x=1711559630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+GdX2jdkDlWHWBVOsGIoAg8YOz++4sTFpjiRVGx7IY=;
        b=ZK+zV9NBZTGdUYxJDa0k4CUSddFVcRdznVDuyaWV2v9j+WFlVMsdDdBRV1L+CmxX0X
         bmo3Z+MMeBnkO3FqSMVNsTJM9g0iCFHq+bJV5VX6JYMsm5Kw8EGBjbfn4Jhb1bWwYgaD
         Prrgc0ja1NiG3CP++dvo52ABLpFt1wXJ5vJUy3DpvJFa8pScbd7ZK0Dz9uv+7OTPxbTh
         JosWOiQdZuEBKQi9XlkDxbR1Ch6d5jdqza0hkWfrNRwFKqR9jganS7bPoT9mihccCGHZ
         2n788+mQpUecUZ1ErlGOyPm55tcvJn8L52TNtou7B0KHq84EF4neGpyOA0mpqBJ/4DMF
         rb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954830; x=1711559630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+GdX2jdkDlWHWBVOsGIoAg8YOz++4sTFpjiRVGx7IY=;
        b=h9SmFKUKNk8gdLhvEF3tCltPExWISNbk528BTwc7JGZKDXYa2jZBWB0BvFcIUxoZuE
         YUK3q1YihPvlVADKy9mllyGnIFo9zQ2DiRhggZmrD9gRnLO8G7RDTpc8zkE7V+Ts92W3
         dFNkY+S35pD9Bq3v9F/ks+PRz0hFD2N11oh+Kv0bd9Okb4sM7SuIc+7tt+QOL7Q++fsf
         yIgWST9CHCbvUW8NTwJCNWk52CcjnquVPHITXOKdFrUpldw2/GCugHvIguUcEHqsJIlf
         YbyGgmJ9NdiBndchLO7aKHmG1DqJ0G3iUTXbeqhTIQsmGPswJH0he1QnHFvwwYMcnGBL
         AHzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv27+2wdEedGsjh++I0X3rdU7iPkJos7DNKV6ekeED3vJ6tZ3BI7pwufifUVzlL3Nk8rtL7BQtNoPa8AnlOyZCnXzDdpaiXKAd+gJDbM0=
X-Gm-Message-State: AOJu0YzYVTeOQVNgeb5+oc6AqvBmhQYBAsWek9tTzKdyKtKfNQnf/HgG
	5ZmYtjANMsOx89uTKhWIZ4Zyyud/mX2cV5AB+0EkBvXJGl82Er/H2ABv7gyU7Y/TPCLV75p0YYX
	3GG6X29YoyrFLB8e1B8LQF86KHON3VGaJz75a
X-Google-Smtp-Source: AGHT+IH0qAID20MP6jp6NpXqn9mW2kuq00RtO9yb0PwCHdZ99yKuZBY632oWoHKU4JglvZUaklYHu5xGsWpmsCAynaA=
X-Received: by 2002:a17:902:6805:b0:1de:fdbd:930d with SMTP id
 h5-20020a170902680500b001defdbd930dmr312651plk.16.1710954830070; Wed, 20 Mar
 2024 10:13:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-6-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-6-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:13:38 -0700
Message-ID: <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] lib min_heap: Add min_heap_init()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 7:54=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> Add min_heap_init() for initializing heap with data, nr, and size.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Thanks, is it possible to update lib/test_min_heap.c to use min_heap_init?

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
