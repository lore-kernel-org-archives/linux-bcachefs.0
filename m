Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCB5C133
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728753971; cv=none; b=KDnw4jOHLzKI5rsUq/6dpTkUy+xDE+KmFZUYwgeldaviqOUTPvPS3GI0qHfIzj+nW4ikmzEq+W/8hBhDkQlHzuGss5NlSHyJ+v3lyfBA/lQEcgf9On3oOHefgLXaNWCYXXyiEsx5jNPULjSn9gUUIpQLaTzxqAr+I6r9e6TPDXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728753971; c=relaxed/simple;
	bh=CFRaC33reB4E51lm61Bhx6B1qhbEnjs7QYlKPGM8AAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rihqMe9b4cTugLfoKfAjpFw6YQK5Vmr1TUM/jHQaqVAxhL/Y8r5xpWLgbUDKz5g0OiYVeLxIX61rAg6WiHwBnAp3mIDT1M1306JCD8JRBLGOyQ3sRO75sF9AS3vbKCq40b0M/oLjZFW3qPEQJk6taesJwHJinisYueJUmlVIJNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dUnNh2Nc; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dUnNh2Nc"
Date: Sat, 12 Oct 2024 13:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728753965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6I83bisceL9nu8hNd1MTI4wjQKD4kDUlTgtIzxvxMi8=;
	b=dUnNh2NcsIry5oieqwx1EoANxIC3EowwEZz5NZx3jO9bf8A5AuCaT3N1lIe6o9Z4Q9nWw3
	pQkp9QjTHacWNbwc85oK3nvM8AVSoGVeYEF1n0h4QNln5q40y5N8BAL5qifvmW8ctWNvNV
	GzluJDu6wVhmjZUGNHuLbAe21Yjxk6k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH bcachefs-tools] Pass -C default-linker-libraries to rustc
Message-ID: <kd373bxcq2s5gekcpl2wbqpxv2atsbwvf5akzhafnyfzi24754@pmtekusfilx5>
References: <20241012161319.305837-1-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012161319.305837-1-hi@alyssa.is>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 12, 2024 at 06:13:19PM GMT, Alyssa Ross wrote:
> By default, rustc passes -nodefaultlibs to the linker.  In some cases,
> this can cause compiler builtins (e.g. __cpu_model, used by
> __builtin_cpu_supports) not to be linked in:
> 
> = note: /nix/store/s2cjhni3s6shh0n35ay1hpj8d85k44qk-x86_64-unknown-linux-musl-binutils-2.43.1/bin/x86_64-unknown-linux-musl-ld: ./libbcachefs.a(tools-util.o): in function `resolve_crc32c':
>         /build/source/c_src/tools-util.c:457:(.text+0x1023): undefined reference to `__cpu_model'
>         collect2: error: ld returned 1 exit status
> 
> I saw this with static musl GCC builds, and others have reported it with
> Clang.
> 
> Link: https://github.com/koverstreet/bcachefs-tools/issues/300
> Signed-off-by: Alyssa Ross <hi@alyssa.is>

Thanks! Applied
