Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6B85644E
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879209; cv=none; b=SL5n3DCjeU9DklW9OhDRMBY4P96gjTzX6q03nCCzJUWgbDoBhpZCuOpYP9/hkwDtXZCUEHLzSPWd6XwcJndblgWtdbCqmnU78Tf68M59PaTTufVgks95bjGYN80AJHxaTf2NkrqV9zUy2xAvII3f6/sZf02L0+Flpits+/34N/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879209; c=relaxed/simple;
	bh=+sQCudOZfuqXiUUoG5vR5ACJJLNxAMax7xwD1W4e41A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNQRONB8H8aBHV1pZuho15i9pafkkyuwj3bdToEsUD1sDeUF6E8Oxtu3rOZAva0afspVVvGE149fPg3EgOrzyshyhFsNHX8dPYmYl9uiE/C1w9VKDHBse4eps7wb6FI2r+8Dw3+n1IOHAjiZy/Pu7vILT1Gat1iEmfXN3Ahk1Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lar24pDF; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lar24pDF"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1dddd7d64cdso5675ad.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Mar 2024 13:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879208; x=1711484008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TmjIUAWre/OnPAbZKoo/CqmH4il78nzu/N6uFzuSi8=;
        b=lar24pDFUtX0vMzb51TSzwEnwoyRetN5jsA51ZK+b/N1rz662USWBlivjRosZbUgVu
         VuvOm2WMWPJktHRQI0tmukLK7fj6iW5Cn01nfso20ZqHRt5HJHykOyU680fvDrY3upXz
         Ehhw2tyJOaDF6zLunagaC4gD2vjE+PtWF19b2B4GKeidnrh5OYceD/tYIVdc3jceA3zx
         EoS9/z47ERCRLxCGKGSwEjZmoD8l0sUXDjMGS26CAQR0x20ZE6mCmJ8/zU3eVAlKIpd3
         xa18f/j3Y0FeeLx2JzNNkzSAkxbnHczZ1P/HWr91ZwCiO/6z+aaXVCeODoPFk8dM8gH2
         9nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879208; x=1711484008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TmjIUAWre/OnPAbZKoo/CqmH4il78nzu/N6uFzuSi8=;
        b=knQBSxVhyc73l9htP4QgUdygwU7z0fGGxTSbem6sdS3bb/oTyDNzFUV5jQ7IKlGOIu
         bUooiUnPALMzGmUl3yTdqsNPOvAnL0WeXOQVAehCx0P/rfxV802aQt7xWVHEywslee57
         QM6D663JrBuxOPDVc33NEPUpXD6ZRD58nA6cAlH60tKpoGWaCtEgCPa8RPNaWm7UAB3P
         weD5IO1wuLePEIIuLVy7NxViMKcLMnedwxGwyQE/FpWf7zfargdxqDozlBhDMs807P7W
         qBu31pR22fKhGqr53K6YE9d8OxYmH+j3YAUO/ayj8wngOKXTcHkCOHURXV3WyftzZPQn
         WuMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdG1EfYAznHPWgnoEZUnTjbNtab9XOF8LhR9kDZqovqnOQeLNlDrfsB6bs9kke6faPqMrzUi0rmg9JVKm3p5YzASZSCTXy7oCFDZ3CzuA=
X-Gm-Message-State: AOJu0YwA7c7rE8LdJ/WbrYAKESXw2TAp6yjwONNgnHhin4uUaXxu3Oo/
	I6Wt+GkGQBBp/67TWJsKMrOi6kPgrNihk0/iiSt4Sc7lb9tcXPOrJ1CjtBzI25hIadikf0cOz8S
	nahvn/mzHxOT73KukxhYc1zR3rWzogvbdl6wA
X-Google-Smtp-Source: AGHT+IEw7XqscOujrExd+TjwtySjz62M3/jll6P8bD2QCyweYla8m9DhRt5lU7Qo9n5jCXQMEtTIf22XYc74lAhBJZ8=
X-Received: by 2002:a17:902:ea11:b0:1de:ed50:41f8 with SMTP id
 s17-20020a170902ea1100b001deed5041f8mr65676plg.22.1710879207491; Tue, 19 Mar
 2024 13:13:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-3-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-3-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:13:16 -0700
Message-ID: <CAP-5=fXvQoOOpCTm1FXqatzv-wCTYxAymjAu5Veb2fBZE6KivQ@mail.gmail.com>
Subject: Re: [PATCH 02/13] bcache: Fix typo
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
>  drivers/md/bcache/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc3992e..410d8cb49e50 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
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
