Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74182142649
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Feb 2024 22:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708727182; cv=none; b=D5yiprraDiQVVH48Uf8yxowIPoeAYumCZdS1LzoAnMz1T5RB+vG2D3D1qn+L3I0j24gLww87Vt+8Do9gX7y/D0k66/UsMO9ePeGk8VGu4zNKdnDwKAKV8znUCqTZoqalih9lM++XpMjSdT3POtpluQwY1Ey5gUIZmwfSUUCuXNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708727182; c=relaxed/simple;
	bh=r/8ihvr6Da18aP4GFlG82i9adpWtWtntfM6Q7goeZM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoeGPMct9jXZ59AWgTgAex0N1gbNAn6ez6QZA4v/C06Va9z6M7QHd3C+ijvi24f47bIXp9aIwlOMti1wWgfRPbC7Te2VqboBMR+zhqjmv+JMcQ3ZcXmqF6DOiWBMqLGMS7abApxYvYALU3rb3KfG67cjl40CCROr4owcP9woc7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=arHVjsvO; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="arHVjsvO"
Date: Fri, 23 Feb 2024 17:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708727177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ZNerckWAr+g8f7ydfg+WkrraeKECrFVnmbpf/hfrCA=;
	b=arHVjsvOZqtszJPdVIf3LfadJyp+86MzCjPzlOO6/Fwu0IZZA4PF6ClhL368F1ZMr214nm
	m1DBiPt15+EwjGHKV30vRxMYpynjYWEVaMRFgMQ1Cegilh2Z/KSjhHe3tQnl/SDT+5xeS6
	7cQ0BFPQ+SCTaaraQcRZ5MrecrHXISw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS] powerpc: use "long long" for 64-bit types in
 userspace
Message-ID: <whevkmac2xshxdfwzgwnkvgpnwhjypyji5j7qt24zdvdloregc@v5rmffessdrj>
References: <20240223222042.140688-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223222042.140688-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 23, 2024 at 03:20:42PM -0700, Thomas Bertschinger wrote:
> This resolves build warnings and failures for architectures where the
> Linux userspace `asm/types.h` header defines 64-bit types (u64, s64) as
> `long` instead of `long long`.
> 
> By defining `__SANE_USERSPACE_TYPES__`, these types are defined as
> `long long` instead.

Never realized this was a thing! This fixes all the printf format
madness.
