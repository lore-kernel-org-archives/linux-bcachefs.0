Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC4E196C97
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Jun 2024 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717689112; cv=none; b=PM2fsB0OxwV8ahfY4RoGvz0esM8UDi7n2MLflYUpByhx1ZZjX2mVqEyG327O7ma2DFVgePuZsFEtfYJ2VEKf/Nt+I8UPAMEIQTwpcykUTtndKiHGlqoVWshSNvMvCztw3ueGHX6kKWL04bv6Ox7SuedgFCYlXQsMIli+SUOZ0xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717689112; c=relaxed/simple;
	bh=KYsGIKq+KTTsjKehjIcAGkJK/T+lNAKwpgCCtx6Y96w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJT3NtJvWswSI/fPxpe12g1EOxE65QHLIPmWiikhIXVuHqQQqSXB8AWLvo+kSKAwboR7EVe9O57sQS3FVad4BBMLM5n3MCnKGSyTiCrAG6SuVsZL2I/j9J62MNGUW9pj5Lr90EojoVFzkaQdFB3Mh1pDr4wC/z3tvZKMnnil2/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KZss0Lcz; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KZss0Lcz"
X-Envelope-To: ariel.miculas@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717689107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4EGIfDOXXMiEQrqHoR5vzhQdDp9bCVM2Kd8y6EI9ljA=;
	b=KZss0Lcz+fs3X8SKsl/I6JCKPWrrFdIZvV9W8oup8OgZcoXIzRgv7AIcaVPbIP1m75puIK
	u/35XpiqNf9y85gB0LYvLpV352qJmk3ItXEnep/6aefPNRVtJdpVjEbdcKSQyoD/V7M63K
	rG/PzeubbZ/xtbfSiTxufeqme5gY+eM=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Thu, 6 Jun 2024 11:51:42 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ariel Miculas <ariel.miculas@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] tests/bcachefs/single_device: test bcachefs format from
 source
Message-ID: <nidy6o2yr3j4g4mpu77mrcbifvqandqkqf46gdjkwnszkniksn@7axvgq2xomj4>
References: <20240606152804.866509-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606152804.866509-1-ariel.miculas@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 06, 2024 at 06:28:04PM +0300, Ariel Miculas wrote:
> Add a test which checks formatting and initializing a bcachefs
> filesystem from a source directory:
> `bcachefs format --source=source_dir`
> 
> Create a new `prepare_fs` function shared by both `migrate_from_fs` and
> `build_from_fs`.
> 
> Other changes:
> - add `ro` mount options when `nochanges` is supplied
> - add a function which checks rsync's --itemize-changes output
> - pass the --hard-links options to rsync when comparing changes
> - avoid creating hardlinks for symlinks
> 
> Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>

Applied
