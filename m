Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B20D69E07
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954921; cv=none; b=TPoyHcgtwS4ciwZlr1U5VmQZ/YrzRMA3NMNbtskHbGnxuowL3nL7Qt5rpkycegHNoaUHEOtutezsCIomL1c0bxPAOHY3mujCSTjiWKUCLl0moVE6tz6NTRiA9AUm1oU7XZSYz+lRF4sfMK1v2bSWELDZNqdZc/T2FBo8JEuRmgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954921; c=relaxed/simple;
	bh=XgLLe/0HidMplx5GiFezhsQrFnXrNoWbzeUa4QSU3u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jx2EOH47BtRK/AtfmMIh4NXjoBx0feWfnneFhXlNP95OtJuFLiDkKRRcnDpiNdfx95KAd67jmJMZAExENV0istw8ImdMr+wOUolikafYiNQdere3KYmUWXAA3TBWwHpPGOSaZEJPhYknUszw7Wnl+W7opJycZi2ffF4ZNVKMi1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pR69oNWA; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pR69oNWA"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1deddb82b43so8855ad.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954920; x=1711559720; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=pR69oNWAtkN+GiSMjWpsJnAJ72L/JqDjqlcqvtEKFJxR1JKCfVsKNCJS9ybu+cHC7Y
         hFnpoIkFoYFyiJpys7mnlZsgrHHVCDOeZ9hoZdlQvDNBne19YdrfTNqscdjsaZWdN+Ez
         1HptVFHo0/jvY8kfl+yNSj/7PiXCuNUsUdp5IgrS4BEWb11su4friYTSbsOiyaU+n6q3
         FBOj8wN6Tjy0uD3Tqcu05aztGo9MCs+TVM1SEaOo1m5BjfXqs641D/4atLLpVB0v0Bem
         GkkfymRISyVahaFYVB4PvATpEn6nnNkwQpHPCal8QyUMq+ZJs/eP9fYIHPFX+Ef+zZ1K
         oNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954920; x=1711559720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=aADmTMSMBHQEJtWdprWZg7gx/uLw8a7nNq6CJqza3mBDOJLU/DlGzyYTM/9Z9srEtS
         c5RDdDkBn33xI5nsfVGxXKpZnU4r8Fx7ZKX2QG2MoC2CcUJDLTGOHho2KAPGphWu4bgZ
         juBOi4i5SvUj/+2cjrnF1Sik5aOJI+Ggp6t4S+xSbbz2znkHKEHc8Y0DV2hkMiVOUbz5
         J2n4/WR7q8nGcK/M5qna8uaU8YkDV5ImBy/d7X5ZIfIjDL5bIJ8S6AmuEr0BqVY9R5CE
         +rEWvtjhoZXJN/ifmtT6+ISkHUDhX0V1noJY3FLzLuBgKd+AJEhFEk+dI97E9qUJeD/O
         NBGw==
X-Forwarded-Encrypted: i=1; AJvYcCWGanG9kPYDbdvgkGrRAxntKinKgDDwO9eyb/AH2fQIzf0yc7KD2gYy6Y+zLRqvGu8BQ5Ln21c/z7iWXdQeslzafiyLpaBMfP6uJTX3hD4=
X-Gm-Message-State: AOJu0YxoVYN0pD2vScT/LFtWidIvZXxL/lNVtvJBoCy9LomBwvGxhbLD
	u8nfgzo8gbde8caSYtU7I1V71BuPHsZUAHmPthY5T8p56A0R7CT7IYjnaOw2AEN0zRgrQLFPlY2
	x9x522WU9oYiifB5DL4UWwls9bmAtoVmIwFlW
X-Google-Smtp-Source: AGHT+IGD/YlWW3iEs0IrRWmm6hXwC9f92VNOJhCPilELzQoK/i7dejWld8froyLEaz/lQCnkq961NX8v3FntamPL7Gw=
X-Received: by 2002:a17:902:e74d:b0:1dd:9e99:f6b2 with SMTP id
 p13-20020a170902e74d00b001dd9e99f6b2mr306294plf.20.1710954919511; Wed, 20 Mar
 2024 10:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-10-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:15:08 -0700
Message-ID: <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
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

On Wed, Mar 20, 2024 at 7:55=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.

Thanks, should min_heap_push be updated to use this sift up rather
than its inline version?

Ian

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 36023e0be232..af12531474a4 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func)  \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_=
t idx,
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
> +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _id=
x, _func, _args)
> +
>  /* Remove ith element from the heap, O(log2(nr)). */
>  static __always_inline
>  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> --
> 2.34.1
>
