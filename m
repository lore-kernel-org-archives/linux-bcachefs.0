Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7411E6DE1
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 19:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478744; cv=none; b=urXS6zBfCgWKaITK97g3I4o2kV1Kr0Uuc63cTby70QFZoOMg2jFR2dV8MxBFn7t4yP+YBCZEvtsioOrDTXRqhXYhNtB/OnK/FZ1LcEjLPte/0oYAl5fYOXzJaXDqPKcbDCSSHB9RdHiKc8YCk0D1xGhIBjmqLRDreZbn14FhVW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478744; c=relaxed/simple;
	bh=k+bbzLoQl6jKu2lV2aRKoDIswkDGN3UwLtoMeMUXpPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSLKlWZrJVdDQ1b27gETYq5FUi4SbH476KDPFcJmNwzpgc5D93pn6dRy1pufYNqm2Ls9bak+d/nvG55IsmeRC160gZGC9eoXJL0tZ0OWP0NLFTcizTXRjces+2oWDE/fVhh4vWDwBxmTdWh8tEDuTOXT56f1FJL+R+n9uP6qPYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lHhUgr5M; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lHhUgr5M"
Date: Wed, 4 Sep 2024 15:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725478739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J6gmuXp6dnisw4XeRvNsGcmR9RQsK3p12rHUb+HlQ/A=;
	b=lHhUgr5MJd+BdQeM8YhbBSWylxEFS3lqKjMDXGjcNudGoNIJZp6rPJDAzjNsRenH+IxtxN
	iRgDRiag5FgtKEyyK0a4WU756QA/ImvTQQjKs0r8GjNYXx0dho29zUP/WYfmkn4K7A4Q4j
	fP3EjBsVZABDNQJetG8tsXunCGgBnzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alyssa Ross <hi@alyssa.is>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH bcachefs-tools] Remove udev from PKGCONFIG_LIBS in
 Makefile
Message-ID: <a5dvfqjtaizz7mbej77gvmq5mqas4dmhexdskwxexzmi3wy26b@5rympn3bmhde>
References: <20240903173522.496756-1-hi@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903173522.496756-1-hi@alyssa.is>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 07:35:22PM GMT, Alyssa Ross wrote:
> libudev.pc is the pkg-config file for the udev libraries.  udev.pc is
> just there to define the directory that rules etc. should be installed
> into.  It therefore doesn't need to be included in the list of libraries
> passed to pkg-config --cflags or pkg-config --libs.
> 
> At least one implementation of the libudev API, libudev-zero, does not
> provide a udev.pc file, because it does not implement the udev rules
> language, just the library API.  With this change, it's possible to
> build bcachefs-tools against libudev-zero by pointing PKGCONFIG_UDEVDIR
> somewhere on the make command line.
> 
> Signed-off-by: Alyssa Ross <hi@alyssa.is>

Applied
