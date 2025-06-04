Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AD525179A;
	Wed,  4 Jun 2025 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749036082; cv=none; b=NdKXZ4L413LMW7espPFrxfWUJHiKyoaPOWZ6JmpN07ajSJVQIEthAwUo8yOgMomU4BWdUwXaHK5uwdhLE2UTmBEtVn23Dii/vz8G07VSqBUP9+qusvRXKS5HkhnolVHfN1BBkMbMO7yy1Wxw5uwnWT78iC8VtSWaLJa+kOArMwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749036082; c=relaxed/simple;
	bh=xqm5cHFk20wFqyERODHx0A5Yo7HzFZcrbSgFQoBjAkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fz5sfAKkqci9c8sLlFlAx3Qoh+jJ0B+0+rlbeVpP9RlfYsQNBPvvl7GfeSWRiFFhDotM2bmBGzX9v1CwVPpu2LntSRGJjSEGr/N+v0isSWAnWNBDNe40MSlMDNh/Mak/gVpY98IvNul/+IXwvSUEdMepnik11G5IYdWif5zDcrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XjMjnOOc; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XjMjnOOc"
Date: Wed, 4 Jun 2025 07:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749036073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6tNxQUm7SiMLlUyYYyUWjpyr8owNk6jHSf4TF5Pg7E=;
	b=XjMjnOOc0hWHjQJHHVVufwJrf8aH7eM5YKXzzrR3q4EoLO9Kc6vjJh3r1iDoK0rRqiBa51
	w+rF5p+hTTVqnXv37+TVNjU17atj6QugExvDXYQEQyr9S6UvHWObqv78OXx/MuG64gMP5s
	QyQIC9nczpm+ovVfYO62LaiYxfsuFg0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 4 (fs/bcachefs/dirent.o)
Message-ID: <mhmmdwdgody7hmoltfdgyfhnmk5vyydgopzmru3wjmbnyydhkl@di4wpd3e3pvx>
References: <20250604140235.2f14220f@canb.auug.org.au>
 <c15ba8f1-4bf4-4b14-ba79-440a3b17a021@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c15ba8f1-4bf4-4b14-ba79-440a3b17a021@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 03, 2025 at 11:45:14PM -0700, Randy Dunlap wrote:
> 
> 
> On 6/3/25 9:02 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any material destined for v6.17 to you rlinux-next
> > included branches until after v6.16-rc1 has been released.
> > 
> > Changes since 20250603:
> > 
> > The bacahefs tree lost its build failure.
> > 
> 
> I am seeing on x86_64 when
> # CONFIG_UNICODE is not set:
> 
> ld: fs/bcachefs/dirent.o: in function `bch2_dirent_init_name':
> dirent.c:(.text+0x13bb): undefined reference to `utf8_casefold'

thanks
