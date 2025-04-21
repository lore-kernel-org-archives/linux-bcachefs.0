Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE832A8D0
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Apr 2025 01:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745198864; cv=none; b=kVIm+O1IU6r22Sspkn0nNljPLQyB3Z+NDO0QHglq4iAsn8dmB5bG8tRAG6ZSSZdJ3NL8iFKQIHgSIwQ971mkf/jz8tK2dppca4ss2ZVEFjH4sRM7XcX5/SYuwgLMjI3VAK0hQ+HGi2Qr26TX4ugfERA5LaVKtqe+JUI39k8PTm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745198864; c=relaxed/simple;
	bh=J0L+9lfh3W6tuuDJehMuZDOjWAum5k+olTMZ6tMQpx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDGvPPB15k+UtOwTIe7y8TDLuIaTey85C8bs0FrY+yH730NF56buqyCE5NM7LUhlVZNM0n7r5agY3BcyPQygRH+7mVLE+GWwRjQbn/wpqOLt+tCR2KM0Hw2iyVqMutJi4hSgUZkftFf09rtd/DETNa7P1F/TExVEOaVFMb4iCBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZNImUV9V; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZNImUV9V"
Date: Sun, 20 Apr 2025 21:27:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745198850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V2jp3/lO32nyPCKwhyTc5hlOL8Q8zjhzUd2Zj41EJN8=;
	b=ZNImUV9VCk/x5h1xm/UusL8dt0SkYYGONjZCaM/hqF4sA96Cl1kqyUp4N13pzHNN8QO1X4
	Eh1XM5NLiKHhBJ5zuUd4t5EjrgdxC9XrnZ27gno3HDHJLIngSobhp1abxH6TKQ23aX/9jc
	Uw1u4CbAqVPgaWq0sMHQda7+iXRul/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kees Cook <kees@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] enumarated refcounts, for debugging refcount issues
Message-ID: <yd3f6ie56x2dbagqycwluxtz7inrmbub5fg7omp226vrdvxtb2@sjn23uj3r6t7>
References: <20250420155918.749455-1-kent.overstreet@linux.dev>
 <202504201808.3064FFB55E@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202504201808.3064FFB55E@keescook>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 20, 2025 at 06:08:41PM -0700, Kees Cook wrote:
> On Sun, Apr 20, 2025 at 11:59:13AM -0400, Kent Overstreet wrote:
> > Not sure we have a list for library code, but this might be of interest
> > to anyone who's had to debug refcount issues on refs with lots of users
> > (filesystem people), and I know the hardening folks deal with refcounts
> > a lot.
> 
> Why not use refcount_t instead of atomic_t?

It's rather pointless here since percpu refcounts don't (and can't)
support saturation, and atomic_long_t should always suffice - you'd have
to be doing something particularly bizarre for it not to, since
refcounts generally count things in memory.

Out of curiousity, has overflow of an atomic_long_t refcount ever been
observed?
