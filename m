Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1390A5FB8B
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879227; cv=none; b=X/jG93HXM6OYkN2hv32XfIALNOKUHGjq1IkcT7Fiq5xXzHPihGP39RssfcqkPwQlYm764nBxaJuwgnVN3Yi4u9scQWZLhepioBPHuM5G3zcSGxPab5lKm9oNpWT/VK35mkNS9F+e310h1hOLFPfvp4wnBT4P3QLYWeWZlsFXI5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879227; c=relaxed/simple;
	bh=TEI1l16U8O229iRg+bnRlquzTRC42x/8zMW3wG5XbLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsVaTKpj9JM+moY6NfNcIWp7X+mQmvb++2xuczidKNxbVE96MyMHFunmmVPquQVG+IEzuvvLlDeun4rLryeG8YFGqfdlzo075UHp4wXBwmcx5LBTMZQE1lbXVZdyKgaB1j4U2SkWN/j9VaAVWYLuJG6srkOtaLBlD0FvKXVeo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gtAnEDUV; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gtAnEDUV"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1dee917abd5so5775ad.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 13:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879225; x=1711484025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=gtAnEDUVnZvHgfuPvOALSV92laz8czMB1cfJmNpfaAI3SDF8yI8PpIvoIB8wspgUSY
         5w0y9kN4RgfF7ReI8e8vf1xrpiVTr17eG083oEne+DYTGEmE3qgXtLu/7Ad3h+kW1gPX
         GaL5y0w+oY/C33fvFIQYF30A396dqMPN2qPiGBAs5sjCkxnV2Y//egkHXxm/fJGBrhdf
         dVx0alJ9xtYq+nY2azq325TtMfdnKGeP6rsk6yUV/UwKP91IqIs2bgxXabJsNoAZbrI4
         hbursat8QPTCctysg1URfQUtJoyMy7Oc3+xw9D8pgDaTrccOhuEab4eNJr7jzdEgQiLA
         Vuqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879225; x=1711484025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=BssTRPL3c4NA7856rpIYOIXI9PHMWodg6qiFibXsPLacKjDuVAIst6I8kf0YggEbH0
         3NgZh2kPh67bsWxli3tURD8CmD8Z2QOO4GbjYwMo63GmrSvhFP8ult6enSyJmV59x3i1
         eJQNCZ96MTNSvtpJuXNi++qGT60xqCOfDgyw668wr9BtXrocDlxPd11CBNi1Y8PS/7q1
         oQ6uiulpY0dbTZ+8ja/oyIxuROrRzK2shs52a9ccETwoi01bW4SNnbhHLBPNwzVQGI7v
         4u2lYvuY/I6+40YeaDPX5hy0gmyqiDLFxg1rE1Su/CnHknxpZlg5TA7IRsrMTgYYQc2I
         CTYg==
X-Forwarded-Encrypted: i=1; AJvYcCXLbKzdZnn4g8I6NQUf2QoGK0DJ+y8SzOmHJtl2VCJtA7mqIO4UmfbdR7xRBVFGm8gpNVImaMAFpjRzN2jupbLR/Yn9KSqg1isGYA9R0RI=
X-Gm-Message-State: AOJu0YzhpM+4Tof9H95hgHN/EEIuhRJU8mh6y5jHrRE1wHnP+0NnWI1A
	A4lP47yjqi0cWnma9fjuFHDpXf/BRl93gOOTM1s3/tWhsUNBSLP0UagGuZYjBhHNkPYQxIpw7sf
	AnDJcd4sTVI/C55FAFKvQTrJF9fNrp/rEZ4tR
X-Google-Smtp-Source: AGHT+IFREg9SwBdMDFnHH3n5tmN6yW8u/tyc7IrpIagXi7ukyBFEM1dN3wdN7uqPHmnG3vaEtYonkph3M4qPe2lMJDA=
X-Received: by 2002:a17:902:f691:b0:1de:f0f0:90aa with SMTP id
 l17-20020a170902f69100b001def0f090aamr68484plg.26.1710879225101; Tue, 19 Mar
 2024 13:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-4-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-4-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:13:33 -0700
Message-ID: <CAP-5=fUy=m2_f7jKO_kn4+onto5As2fUwrcNBtKEh8uObsNvYA@mail.gmail.com>
Subject: Re: [PATCH 03/13] bcachefs: Fix typo
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
> Replace 'utiility' with 'utility'.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  fs/bcachefs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 216fadf16928..f5a16ad65424 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * random utiility code, for bcache but in theory not specific to bcache
> + * random utility code, for bcache but in theory not specific to bcache
>   *
>   * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
>   * Copyright 2012 Google, Inc.
> --
> 2.34.1
>
