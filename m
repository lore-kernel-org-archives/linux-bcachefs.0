Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9BE3D0AD
	for <linux-bcachefs@vger.kernel.org>; Sun,  7 Apr 2024 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517106; cv=none; b=NtOBrqSy72ijRuEyBo6br0wxDV7abLHaxI8OBI5/b3VE04YzGvGskJPskJszilC5peuDXA+9X81fQhGNFRmxiL9Prjfyt3Q4H3DGkpNPN34O1Nxw7e1wRO5n+B+j+EjrEVjeyPw+CcnDd1+WofIJQ7FuBMtWvaUeo6Divg+8WyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517106; c=relaxed/simple;
	bh=5+ZSDJ1c1wayZpu3rSXMMx/gAZAOYnaNUAMMmnOCKrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YB4raTOHl/Zn9MvcEAyhC8QdzSKluber1j4QCnLyGWJrJW/Y4j8qnAQKD6Qzwv0oEYpNhdj1AJNvqPAJZ0m7VwzeJFkmwCVeuyOpe4bqjVsaPd5XLhCdcdXe7D7gES5AKB6TbStf6mq3N2ulJtymN9PqCNx7+Se6wWkBuh7tnyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fTKLukDG; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fTKLukDG"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-431347c6c99so317151cf.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 07 Apr 2024 12:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517103; x=1713121903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNNV1iViAab2iT4F4Gl3z4rLSdw9SuHLMYt6mT0uMl8=;
        b=fTKLukDGInZUB+fsQg3YPRTy9oXDUyPs1odEsay87TmR44G9qLwV5fwCxW8PlEyG2Y
         xxKX4HFnnEuVrtKLHT08eRxP5YnDkCrvxVQH+7b0eQzRE1M4/SYlenlaZelQMDx2uazL
         Kk7L1AJrxRL7qbojiqeXd7NovGDD3p/RYwHg36+8pRP37sZihDp/AYO/Vk8Z8b92j4Z5
         QXGWDgi0gQFxTVm4Cyi250lvduGLxOir+fVLW611JuqGWYSUiWiqoVOmnn/aHAyylvLU
         jeGkQ2HZaRwUG4/MucAuXA2OqPh9h3HBgD+3/aftJNHbdihvEpV3RauE/trzj9uU1RLV
         sUxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517103; x=1713121903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNNV1iViAab2iT4F4Gl3z4rLSdw9SuHLMYt6mT0uMl8=;
        b=ocqj+nMXiNN38epaX2G5ipoT3okPesz+/bW3QiLxf/Gert7GoV6sJAHOQy5Z4LN4Ep
         bCSGnPoelKdSzTDW27BB20PA3DuozU6EPJPlyEZMXlCcnLRS78yvFkORflV1Cile5OMV
         YE3LS/2lSp8F2QbWZXE1FFIB6N/zWGeA/7fTNg5MB+/P6ZOJizZkW2TL1JqCRPYeGPN6
         +vfK0N2pjEW1V187wSAPjV135+VFQ70Ra3Bgw81EA4Yo/4KakvBKObEmtCePrrRSwXD8
         vhQsVfdEazwf+8Q1qdKn519zsAXSEhdD6klwI9MtNGjBkmzjPY3NPxDEMNvA5Y1gjP6S
         8edA==
X-Forwarded-Encrypted: i=1; AJvYcCU8Nn7+ut7TusUyp3gfOHrCaifGsJGhgngt/y5vjozowLwUj4j88jpMcnfint8OxoLllUHk8usqUXSoFx4TrRkIhjYLbVMre9UOsN6sKE4=
X-Gm-Message-State: AOJu0YwoN0qnoGNl6X3RZilZOA5NuG6eM+/7m1cWsmH4+XFfj2UJz3Dn
	wsB+nmownC8xRB2zM1Es/YmbCQjZ8gwgN+qXKRVhxF/3fqdcpEakiy9V3cZU5hqsCTbd5znVZ0K
	54wKpRHGnmBD+TifsmJQ5E7YcSRQQYxbxMvl/
X-Google-Smtp-Source: AGHT+IEbVQ6rh/yVlB3vPD78DUbrZCMUoVH6z6E9ojPzKJf/d8f7GOzVNi588miJW/ClBy/V8n3f5DvHgoDRclWzJ3s=
X-Received: by 2002:a05:622a:4812:b0:434:7bb9:f231 with SMTP id
 fb18-20020a05622a481200b004347bb9f231mr176338qtb.12.1712517103175; Sun, 07
 Apr 2024 12:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-14-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-14-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:11:31 -0700
Message-ID: <CAP-5=fXYVBeT0Egypq8Ja4DMX=csWBhMoKuuz=WQxsd7iPBAxw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
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
> Update min_heap_push() to use min_heap_sift_up() rather than its origin
> inline version.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 3086612d7cd5..fe037eb5952e 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void =
*element, size_t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
> -       void *child, *parent;
>         int pos;
>
>         if (WARN_ONCE(heap->nr >=3D heap->size, "Pushing on a full heap")=
)
> @@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void=
 *element, size_t elem_size,
>         heap->nr++;
>
>         /* Sift child at pos up. */
> -       for (; pos > 0; pos =3D (pos - 1) / 2) {
> -               child =3D data + (pos * elem_size);
> -               parent =3D data + ((pos - 1) / 2) * elem_size;
> -               if (func->less(parent, child, args))
> -                       break;
> -               func->swp(parent, child, args);
> -       }
> +       __min_heap_sift_up(heap, elem_size, pos, func, args);
>
>         return true;
>  }
> --
> 2.34.1
>
