Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DC01C06
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 02:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708052088; cv=none; b=U/gv4lzeO80Bten0GqRgirmEF7ckJDX9ZEbcnypNvuFF2fnm6mBhmAGhT7YXw7688dDr9xcCKgrjXu3In1OT/raCpdsr3x35GZHBCJzYuSW3ntp2pcJI+u2WHYgqMP2bkXRsSHC6HQLBBaheyG925Uxff7UubNLBUCwLp8i2hHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708052088; c=relaxed/simple;
	bh=BriQ20iT0bf4fDcVmae7dCzJNYritsGxBv1R3ylZOS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0w6FCVlzitYnkrCpYXANvPP8CivMvAewabmYwnGeo5aRpdVDm+wvgpL6bvIHOftAPGk9n7sQzsz6tVav2awuDe0W/OlAAY/ysBlAy7Iyl3vm7oS0bldS/W3S+5Cv/hbgQiXC2lwUtQGalXXTeEXrZQD3F/I3NRyPGw9IV7dh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MhkLs1AT; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MhkLs1AT"
Date: Thu, 15 Feb 2024 21:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708052082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=blIeoG3E9SU6i9/RjgjSCItngQlZ3selgSo5Q6BsP8U=;
	b=MhkLs1ATsfL7Q46GBRFo+c8nZAxK7/09kJwD6XtVm0vZQdgJqN+VTdxVIGwJ5pMSyh8Oof
	rFiEw27ihjVKo7ZmIwfbABrIZx4L6zd3T92EGa0CzeqAPCVsmoPWnYWsw6R5aFWu1nTXuO
	mQWfMJhyY4yZhIoLCFSX5bFc99QVvWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH v2] bcachefs: omit alignment attribute on big endian
 struct bkey
Message-ID: <c24r77xcz7yn3wezeudn2fhyhf2qrhiznswjszrah5hhekr2fe@i42ifngbp7oc>
References: <20240216024421.143152-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216024421.143152-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 07:44:21PM -0700, Thomas Bertschinger wrote:
> This is needed for building Rust bindings on big endian architectures
> like s390x. Currently this is only done in userspace, but it might
> happen in-kernel in the future. When creating a Rust binding for struct
> bkey, the "packed" attribute is needed to get a type with the correct
> member offsets in the big endian case. However, rustc does not allow
> types to have both a "packed" and "align" attribute. Thus, in order to
> get a Rust type compatible with the C type, we must omit the "aligned"
> attribute in C.
> 
> This does not affect the struct's size or member offsets, only its
> toplevel alignment, which should be an acceptable impact.
> 
> The little endian version can have the "align" attribute because the
> "packed" attr is redundant, and rust-bindgen will omit the "packed" attr
> when an "align" attr is present and it can do so without changing a
> type's layout
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Thanks, applied
