Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AE06FBF
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 03:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730949203; cv=none; b=kBdsQil4fSG8wixrHWOy31d2fJ0acz1U/y4WK22o6nZxZZCazNKdkijezw48BqJgIaypc7KnvbJfEBYz2qtAo5oEcl8PNREjM+3bFHavXFzAOl8sVeEj7B4SX+XPy1Nh4d5ZV23oYX5b6WfciS3eBQGorzF3im5n/a8USzxh7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730949203; c=relaxed/simple;
	bh=XcLfWuYMBg/UDAR93tE6qMlkjDETKCWQ4vWZxHXuu44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGvO4UEsNDE05iiNxgpqj3CLns2CowdchHe60Tuwj9N9oiGZyzq2J5QcdlTA5S/TQcObjcg9w0KoFglEn0h8+uWrkFV09cbhPOkBf5hr9F9Y2LRTBGvLqgvBt81lwrwMH6/KGVxP0fTDGIvDQUYxapg5LYljY4+RtmqlIDHrDsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A6bbv7J1; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A6bbv7J1"
Date: Wed, 6 Nov 2024 22:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730949198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0uu8jWqfTwmoxZOt7kfto8yTk0W3yAmvd2zRy0IBt5Q=;
	b=A6bbv7J12JgsaTHSNzVdull/Xh6TuNYpPMPtGnV3QMgncFPx7OA+cN4+Q535CPE/lQp2PY
	wbDkYgMmFLIZu0tuQxRNzhesUUlp52KyeJz41AXzMsx46EM7DsJ1zNIiWSqHVUuDrx6ONC
	4dZOmgzpBlq8ikGWdz5zGexEKyw1m4c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Integral <integral@murena.io>, 
	Kent Overstreet <kent.overstreet@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] libbcachefs: add support for true/false & yes/no in
 bool-type options
Message-ID: <gylsejwqafif53qs3a35prclpvrjne5d6ku7sml7smfbmj564h@yq5zpwzrrzwi>
References: <20240718071346.68754-3-integral@murena.io>
 <kfqkrmgcyfrtdqqgmohuiykzj54guywr32jbc6a32gny3yk67h@b62qzrg4zr2r>
 <258E7BB1-C6B1-4B3D-ADB2-685C003B9A75@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <258E7BB1-C6B1-4B3D-ADB2-685C003B9A75@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 07, 2024 at 10:14:48AM +0800, Alan Huang wrote:
> On Nov 7, 2024, at 05:20, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Thu, Jul 18, 2024 at 03:13:48PM +0800, Integral wrote:
> >> This is a resend of my previous patch with code style optimized as I
> >> forgot to add Kent Overstreet in "To". The previous patch is
> >> (https://lore.kernel.org/linux-bcachefs/20240718062835.58037-2-integral@murena.io/T/#u).
> >> 
> >> Currently, when using bcachefs-tools to set options, bool-type options can
> >> only accept 1 or 0. Add support for accepting true/false and yes/no for
> >> these options.
> > 
> > Sorry I missed this before - you just need a signed-off-by line and I
> > can apply
> > 
> 
> There is a v5 now:
> 
> https://lore.kernel.org/all/906b76f2-479d-4d12-b9ed-eb19fb108079@murena.io/T/#mea54884e20fa63d4ee32132a1980749e9f6283b9

Thanks, I've applied v5
