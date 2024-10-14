Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571CD27470
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728872257; cv=none; b=VnfSwbMUslx0Bg3+Oz1Hpxu63Byrp7v8LknOfX8YcuniZsH1KZgL+W+5VjMatUiKRXQIu82dBiuDQYDXy2XzneIOCar8BI0NFFUUz1Tdml5naIgmLK/wgf5jhNmhE7AZljEiKY5incT1Y6R/zgZWLLSb9ni1Y1HQAxU/S4sbG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728872257; c=relaxed/simple;
	bh=aIVAxmXSgk7qEworWBlOEn47a4Q/klvRMU01BvICDzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpdOzEsXa7rI+dskhm4Uk7QgVVJNs6A3B9qqVrZVFfDZvVoy1NbyuJdimUw55R4bz21IJkOe/RBH9GiVNKkNamWAgMbEOMtvHPw1Bjk9o6bdabxepDYShOjxCVvJtng980Ui3XhCdu0GG/RWmGBvoOHqD42zBCPCwS7TnBquUUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GmC/PhM4; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GmC/PhM4"
Date: Sun, 13 Oct 2024 22:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728872253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGyz0fSy67XViqigomv+Fd54OQhAmSnKSm9Vu73oekc=;
	b=GmC/PhM4imsYhmIn2sBjbeLr82MmPX8pnxAFOA/2i0EhsTh3iaGZOingBN2u6omUTnQ55V
	X8+zxzLSK7zMr4YUL7RHB9YcgIhNJ1uwUwLo8A+uR0yuzTOq5HV/2VA5ggCpDMC59Ft3M2
	xI32RLOZgYs7Om5qgntUozQtl0ssOEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Naoki MATSUMOTO <m.naoki9911@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix incorrect a year to seconds calculation
Message-ID: <3dw34mgm7mbo3epvdntmw3dtml22tgvfbwzgsdpqdqh3ehd7yw@5hkbgi7tc6ej>
References: <3966a95c-7ff1-49f9-90b0-3326fb21ecfe@Spark>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3966a95c-7ff1-49f9-90b0-3326fb21ecfe@Spark>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 13, 2024 at 06:13:13PM GMT, Naoki MATSUMOTO wrote:
> A year to seconds calculation includes '*7', but it is wrong.
> Fixed to accurate calculation.
> 
> Signed-off-by: Naoki MATSUMOTO <m.naoki9911@gmail.com>
> ---
>  fs/bcachefs/time_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/time_stats.c b/fs/bcachefs/time_stats.c
> index 3fe82757f..d9bddda45 100644
> --- a/fs/bcachefs/time_stats.c
> +++ b/fs/bcachefs/time_stats.c
> @@ -19,7 +19,7 @@ static const struct time_unit time_units[] = {
>         { "h",          (u64) NSEC_PER_SEC * 3600},
>         { "d",          (u64) NSEC_PER_SEC * 3600 * 24},
>         { "w",          (u64) NSEC_PER_SEC * 3600 * 24 * 7},
> -       { "y",          (u64) NSEC_PER_SEC * ((3600 * 24 * 7 * 365) + (3600 * (24 / 4) * 7))}, /* 365.25d */
> +       { "y",          (u64) NSEC_PER_SEC * ((3600 * 24 * 365) + (3600 * (24 / 4)))}, /* 365.25d */
>         { "eon",        U64_MAX          },
>  };
> 
> --
> 2.34.1

patch is mangled
