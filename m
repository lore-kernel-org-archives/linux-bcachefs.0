Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463E33C082
	for <linux-bcachefs@vger.kernel.org>; Sun,  7 Apr 2024 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517055; cv=none; b=uh/EAR9MC9yoeMPyK5JiqLpK0HKqwdUa4AX3a1TJ3C6Lv2F0OwOUC2zm7z2efa5TspTFGMeAHzUi4Y4mZzXmS1aJslNiBIqhwRZNMaVdYH5VA3FmhG8+G1CfEorOJon+7KQOH+LOZOVqFt5U6UnwR8lRdvZc2oAo8FzgGI9rnZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517055; c=relaxed/simple;
	bh=70HHBEd6cxrXlLkgbwjfvu3LYrWt/mT4YkQDDZ2MPi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HKO+uU1sg1ZjopsIBD7QWydAENv2Zvhwf33210yTAZiwv2pac52A3u6zongRSlLr+fnFhbzQ3XF/1+IK/oupqNZ1eVDGFVFnxLWniSN23yfB6M/+bB+AWQYG5QbQf4J7vrIj0Bus83u1f1XF0KIEXzKkImYO6Osz5IaeZWhKeuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=twdFLsYO; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="twdFLsYO"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e42a6158d5so14215ad.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 07 Apr 2024 12:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517053; x=1713121853; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6EUWLXyMd/QrPrA543Vnpb+tkAZZfWHn9rSEQeDI00=;
        b=twdFLsYOYbDEG5VMd/NJt3yra0CScuu6rLvDlvzD0/UcM3ccsSLLWrFRme5S+Qw4tc
         4AY8PNP5cS4iwCjKeWSUZvUbK4MwXP6J37sY0+2ec0UvZFPji/4xxe/VoNNkX6mhwJLC
         hu1+sVaI9v8ro30Kh9TSdyJCvVyrAnB4tSZd6oDpmHx+P1UgL64ssFvTGjV6VdDe3Bwl
         NIIrwkY261Swzjqh5E3Jxh64m+RJzck+Y3HdCqlFgX+7BqC7cVE8eB5tnujEwkgKkqEG
         wOJ+UEfcVumZZ8F5KdDvPayNoa3ekqecmz9NsZiJeQ4n/MsY3l99qQ8MMohBqtBzuUby
         QHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517053; x=1713121853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6EUWLXyMd/QrPrA543Vnpb+tkAZZfWHn9rSEQeDI00=;
        b=WO+vDfkrc72JNhN15LUQiQ6BpE99goz4313SoBZwdmaO9qcfy8VkMmP7Rcb3ixnxiS
         peyn5qebpdfY+52OUxcKxphuVSz8cO6VLwXCCQgSVqtnCvdMojRRKetSEg10l7tMGagl
         fylqji6nW0y1H+nGbqBizjzOcxre4xOmVTrabHcx9b6qWD5ZiTR94gcXnxEkv9fuv5q6
         K2/YWYmQAPQe3KGsX/n+57j97kQ//WvD1GQ0SWqnhcpHxW2fuJLfl9L0no7fFCBo8kWx
         2zLpaEpnrNVuvtkCBCAE+CrSkD1L9G04nPDAEV9SFxJJLNJkXSLr4vCG0Xb1kNioaKAw
         Xc3g==
X-Forwarded-Encrypted: i=1; AJvYcCUezNulrz517s6Rf/Bz7kI4x+vw86G0fz4KNXedLCPV0zC0V4oiG+qvN+KRCCOSB+ITYw3APtlXpCgDyegP5FzPfT94Q3vXfbFGaCvIySA=
X-Gm-Message-State: AOJu0Yxesqejk1C0FQgH/odq3+5ZQiMENtEym3Q2MPp9SW9qWeFoCK9l
	Pr8s7Rjo3/oibE+PK3Ihf0yqhcAh3dtyzKOF8OES0f3jUQWj5mS/kA2YrIPEPf7BXzOT3Bnaq3h
	WV/spCAuGL7f8zCwbfPfF+rEhhcRS8TRUMFyG
X-Google-Smtp-Source: AGHT+IF3K6r9xbBJkilZy6HGKb6dlLXRf6FqatUAZbCIWOQ+wDqVm5LXVF61yEKWVnLToUGV3EtmibzNbcvolpkp1/g=
X-Received: by 2002:a17:903:32c9:b0:1e3:c1a9:ed7e with SMTP id
 i9-20020a17090332c900b001e3c1a9ed7emr176673plr.25.1712517053266; Sun, 07 Apr
 2024 12:10:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-10-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:10:42 -0700
Message-ID: <CAP-5=fWb3eNe3mufRJjPAc=jcHFiHYpPqLuK2H8YiijHu0rLZw@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] lib min_heap: Add min_heap_sift_up()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 9:48=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 9391f7cc9da9..201f59cb3558 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -111,6 +111,26 @@ void __min_heapify(min_heap_char *heap, int pos, siz=
e_t elem_size,
>  #define min_heapify(_heap, _pos, _func, _args) \
>         __min_heapify((min_heap_char *)_heap, _pos, __minheap_obj_size(_h=
eap), _func, _args)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t id=
x,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +       size_t parent;
> +
> +       while (idx) {
> +               parent =3D (idx - 1) / 2;
> +               if (func->less(data + parent * elem_size, data + idx * el=
em_size, args))
> +                       break;
> +               func->swp(data + parent * elem_size, data + idx * elem_si=
ze, args);
> +               idx =3D parent;
> +       }
> +}
> +
> +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> +       __min_heap_sift_up((min_heap_char *)_heap, __minheap_obj_size(_he=
ap), _idx, _func, _args)
> +
>  /* Floyd's approach to heapification that is O(nr). */
>  static __always_inline
>  void __min_heapify_all(min_heap_char *heap, size_t elem_size,
> --
> 2.34.1
>
