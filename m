Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E976F06A
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728753990; cv=none; b=eU5Ho67LCMbxx/ssZHN4rNr0sBoqTzG+PVvZwYMmAn0dqVBjoOhaWC/vAAkg7AyqTWUNzTb415FuO/ni/xdlt3bWdx3nYyqTP40slPeHfVbn47GbM8sL4u/JCJCV00oooxOanuM5lXVegxIpPs/TPu+2c7eLBrBWGAG517kWQGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728753990; c=relaxed/simple;
	bh=qwK+5fKwVH0iecgFvEqSy+K/ukH283/eoHSI1I0u46A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmZAr5HO1UF1XpBXyUvXh+7wzIc3ojMw6OWzM17+oa7TCGdVfZRdapeSEQYHHEmREfj5Kz9qaEyt4WoucvmA4zPBivL+xeutVNZR9W96QPHOHl/zOs7JgCrjIjrWMma9DzboqK6p+nBzLzVExz+S6GuxH9HOITHhaXCVutNguKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DxRpjh3R; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DxRpjh3R"
Date: Sat, 12 Oct 2024 13:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728753983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyBGw6nFnYKAGI+eDEpGy4VsTS659AUR7lN22wlsyE8=;
	b=DxRpjh3RLSPnSYCzz01eB67HZcJ3rbm+F5HOSjqfvhj+y8V6DU0jhOkzrX1/6vhT68LzuA
	kNAmSFfjE6P5n8rBtp0s8wW1K4axJKSdH/oZE1nq+xk8HmOm5ptiDZMsrdDD1/KjZoisxw
	Bw6o0UZeJfqoCI5VFZm1C8ofxYxnh+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH bcachefs-tools] Avoid static linking conflicts with
 libblkid
Message-ID: <fsiwe7yc3do7ez5pafxcavt2b3hweaayi2gjehjxutl4qfledh@tddhuiqxvr3b>
References: <20241012160343.239143-2-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012160343.239143-2-hi@alyssa.is>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 12, 2024 at 06:03:44PM GMT, Alyssa Ross wrote:
> When static linking, it's not possible to have two functions with the
> same name in different libraries:
> 
> 	= note: /nix/store/s2cjhni3s6shh0n35ay1hpj8d85k44qk-x86_64-unknown-linux-musl-binutils-2.43.1/bin/x86_64-unknown-linux-musl-ld: /nix/store/zwid05lzfy46k32xljb2alh0gq7ys58a-util-linux-minimal-static-x86_64-unknown-linux-musl-2.39.4-lib/lib/libblkid.a(libcommon_la-crc32c.o): in function `crc32c':
> 	        (.text+0x0): multiple definition of `crc32c'; ./libbcachefs.a(tools-util.o):/build/source/c_src/tools-util.c:484: first defined here
> 	        collect2: error: ld returned 1 exit status
> 
> Work around this by avoiding a known name collision with a function in
> libblkid.
> 
> Closes: https://github.com/koverstreet/bcachefs-tools/issues/311
> Signed-off-by: Alyssa Ross <hi@alyssa.is>

Applied
