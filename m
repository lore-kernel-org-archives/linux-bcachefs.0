Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E378B13A26F
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 21:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730928042; cv=none; b=eM9Mb5BUAqmnmxjGgBrJ6c/WsvFB6fQZ75+K6mSgKR72nz6bbRqJwG2xpKjNz909d33Rg6kHfEKx3eL8RrLsA8auquu7yJ+D9isG469/txfw4UtGmrhzKuvgVFe8fN8aCduzvikCLPAsfbTREe3pS/WCJrru6vuAOxz+YbdJS4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730928042; c=relaxed/simple;
	bh=ms//Jkv5rz+6NUQhIAjV9EZZVf8hDuTOO+1xfZEzqYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njXljvJrvNGb32njaB6RAgIqQx2KmCegSS+fkD5QwCXJpeceu8O/91aiz5M6l/GbJTbgLUhpkPuhhTvdlJEixrihWEDPVMj9fZgH+nKDd/f6k4OHunDcCOscQXcqmiuUa584sc6saLObh31hDMgBmbY39q6v+D7zYLx66POFIrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FklueWkO; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FklueWkO"
Date: Wed, 6 Nov 2024 16:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730928036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMzukzz88pQDlIlbE/HJ00DSWnypu+RKHDnMzAH3iIc=;
	b=FklueWkOXeL1botA+otx+HIPbl+9fRU4UNitrKiBQuet2F+/C0Yax9RPBSKg+9c4YHFI1y
	7G4HUNWD1vUQVLmE/adbKBgDJmWT9IwykF40hmAbvjcD44YcsGvOwLjXFyFqbDLcD59Te6
	jagjnYuij2XOJFsPQwx7GbFn00orPWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@murena.io>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] libbcachefs: add support for true/false & yes/no in
 bool-type options
Message-ID: <kfqkrmgcyfrtdqqgmohuiykzj54guywr32jbc6a32gny3yk67h@b62qzrg4zr2r>
References: <20240718071346.68754-3-integral@murena.io>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718071346.68754-3-integral@murena.io>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 03:13:48PM +0800, Integral wrote:
> This is a resend of my previous patch with code style optimized as I
> forgot to add Kent Overstreet in "To". The previous patch is
> (https://lore.kernel.org/linux-bcachefs/20240718062835.58037-2-integral@murena.io/T/#u).
> 
> Currently, when using bcachefs-tools to set options, bool-type options can
> only accept 1 or 0. Add support for accepting true/false and yes/no for
> these options.

Sorry I missed this before - you just need a signed-off-by line and I
can apply
