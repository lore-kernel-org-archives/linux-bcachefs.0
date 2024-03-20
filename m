Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBBD6A02E
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955045; cv=none; b=tFujMFytzpUe9AKtvV4oFn9yO4h1yT+3WJ2+W6hvtOtV8DC8y/BAdaP/St0SdWXvZYCpNDA5aosshTvE0dye/+0VRa3p/XZJvhhg+20HNbO3wwG3CDsdHAcSkDV9Ht2q0JGo0NKEn3V1/ZzzfJidP5xCrb64pS3w88b02lESX0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955045; c=relaxed/simple;
	bh=E27O7oDV0qY/I1mKc9MBZuLsSH7nRcB25vJ+wBcgPpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PY1XKuiUba6rA/yyIT2TGqtziExOoEVY+PPsKN0HX8OXw0bI6smhsQjDLHyevDITE/6xzgHMdnd4s0cfkjEssgP0RPFmm1p1GZGc4HRV2zDrIukLiLu9AcWGG06bqpBA0+PJzetWOz3BNO04biXEwxx/CzR8QzvsHaBHKC6jcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OdFFgspP; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OdFFgspP"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-430d3fcc511so9201cf.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955042; x=1711559842; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpUfckfHblkI2O0whTqTHBYzMNvVrRqXL/Jx1TZ/mus=;
        b=OdFFgspPOBXCugwtTjFG+7n4fhEzDvbD+bhZx2GXJS5bT+N/08FPUCf+0Rot2U7FeA
         I31C7ZVn8FTFY1VHcPcM+uvrfFcemdXfZuPKV5M/daqnP74rQaeAQRNO4s+wBz4hf6X6
         LW3JKmDyYyqq5d794d6A4EKtf90jTAATSeVqYYYSEtKGHc8spDMoi1kBfru2xfCNiXN9
         P9US9WWwUpI3PIhJRYdlFOohZIsXsu5hW8VfWAHUvyXEv53YIBp/OnZXMg7r3OV/zgs5
         FWcQXV69s/5A+pAzdEd22ssnn1u5TFq4+GCVug82JyOVkIniHCOsGO79FhFiz7aIdcbU
         G05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955042; x=1711559842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpUfckfHblkI2O0whTqTHBYzMNvVrRqXL/Jx1TZ/mus=;
        b=GG2dhQb6Xoz4W/JBWV45CIsi4sm1uqHoSJXv80ywuNomoGYkA/qbSrG0hSGppPHWlv
         i4Vnh2Q9Ql/b1LemWd5Fnl4ukr/qVdASKfEcWLCpfXV158L1btphLOzFpggZGHAwquAU
         Bm8mvUNczbH5FF34qfzd3DGJlmpoOVOQaiWhRcOEEu8B0xlEsldH5UKaUfvWwXKTe2g4
         hip2e9fP2gUhieSH7BLZLNcdsaRnVGgRttE/4vD4w/kyc7HpqArQSavmh1S8oSkPpcbv
         0dHxh1Jf2GGQtI7IthLFiccVXgzCN85Wwr9pbnhG4AfqGU702kZ0/AYeU8niWaU3Sksw
         /czA==
X-Forwarded-Encrypted: i=1; AJvYcCV26XZOAMrnkWu2gOwglcY0pw77wjmEzVJQES3IzAsAa4kyA6Eg13S/33fRANE5rXv1GkcSFvNk4MnCujIjR2kx6RuLqUcPNMpJpKmYNGA=
X-Gm-Message-State: AOJu0Yw+8y9nSJAkd56oK3TLDz11KvIlIKWZG1JeyeOq06/qLoZsB+O6
	nnZsd5T7yvOlMiIw9VaZCKfBcME1CHlfQHbon1d7gctxGB1s7zFc4bveqhE2LH0KNWxBcl0jxPb
	29Enf20xnoSZPGNpXZe4vTrpetMyq678yzRBi
X-Google-Smtp-Source: AGHT+IFLYdQAuPvBBhJS/6SJFiSfMmYOd8EZJYjEr8SWoFWEUig1E5IadmU/lhuafRa8gSpXkf/xKrC3O60jQR7iw54=
X-Received: by 2002:a05:622a:30b:b0:431:1d88:ce5b with SMTP id
 q11-20020a05622a030b00b004311d88ce5bmr34205qtw.23.1710955042395; Wed, 20 Mar
 2024 10:17:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-6-visitorckw@gmail.com>
 <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
In-Reply-To: <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:17:11 -0700
Message-ID: <CAP-5=fVPZ+Nt_wub1iTpN=pa-1zJkeS5Sa+XHmG6=DnuWLiyNQ@mail.gmail.com>
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

On Wed, Mar 20, 2024 at 10:13=E2=80=AFAM Ian Rogers <irogers@google.com> wr=
ote:
>
> On Wed, Mar 20, 2024 at 7:54=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.c=
om> wrote:
> >
> > Add min_heap_init() for initializing heap with data, nr, and size.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
>
> Thanks, is it possible to update lib/test_min_heap.c to use min_heap_init=
?

Found in patch 13, thanks!

Reviewed-by: Ian Rogers <irogers@google.com>

Ian


> Ian
>
> > ---
> >  include/linux/min_heap.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c3635a7fdb88..ed462f194b88 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -44,6 +44,18 @@ struct min_heap_callbacks {
> >         void (*swp)(void *lhs, void *rhs);
> >  };
> >
> > +/* Initialize a min-heap. */
> > +static __always_inline
> > +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> > +{
> > +       heap->data =3D data;
> > +       heap->nr =3D 0;
> > +       heap->size =3D size;
> > +}
> > +
> > +#define min_heap_init(_heap, _data, _size)     \
> > +       __min_heap_init(&(_heap)->heap, _data, _size)
> > +
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> > --
> > 2.34.1
> >
