Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFBAA29
	for <linux-bcachefs@vger.kernel.org>; Thu, 31 Jul 2025 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753989556; cv=none; b=iA9ZkZou+De1KOIpGWCU5yBUFYr9Ocw2ntxSXEujoZkvTUVN3mUI6oH0vPBW7/Hkk3Au17Zg2leDVLBiHq7nsJCk9UAx/wP7IM61KV6Kbyp285pIbc3gDQS4S+SljTdoeOkZO/8+GgvKSyo8dYatpBWzOD0dPgHOk7eGYtoy5zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753989556; c=relaxed/simple;
	bh=tTZVv3cfx3QGRrCZEPJ4BXZuZFTPtRGYKHO3SK8AD1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahDaOIeVe85Er1Vu4i/kIJqfKfCP0MF60hxQ6wt2uRtxnumsEaCpHBp0FirO1QwzMFCyrH74xhK5OIHi2xg/xdabBAZmn4U5qqSzCCjOMMS4Y0nOEcpAqOyCo/8K4pv6HtKyMEyyHAvGmOvaD1VXKxT66ardWWKqjECd4mDAbAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XZjy9PaV; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XZjy9PaV"
Date: Thu, 31 Jul 2025 15:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753989551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc8D0RQaHuyAnixC7iaU53d7zEvqsRiInD0e2ojPo0E=;
	b=XZjy9PaVlUEkp/GMzuDrVq0fpNZwOwPJTbi+mq3rfNY14d5Lb9vCtBTI/SAwBZwUVXLDtE
	mxGevStEuq+EYUcJ6VoeOCm7L0RGSoujnsRm/BQSUX85Rh/lABNGPxON/xWQr+zN/yxvEb
	OwH8iRKb1rxKJlNei1K3rhdiXy7PZoo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: Simplify kzalloc usage
Message-ID: <ztnjjzlx3a2cvmxnc3jx2umwlh2faetdy6rzhmuc746vppmuns@lzn33bv2smpz>
References: <20250731131551.218666-1-liaoyuanhong@vivo.com>
 <32fbb160-4888-4d57-bd16-62ece192e81c@web.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32fbb160-4888-4d57-bd16-62ece192e81c@web.de>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 31, 2025 at 08:52:44PM +0200, Markus Elfring wrote:
> > Use the shorter variants will improves further maintainability. 
> > Convenient for subsequent code updates or refactoring.
> 
> Please improve such a change description.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16#n45
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.16#n941

The commit message is reasonable, it communicates the intent.

I haven't decided if I want to apply it; the dereference approach is
better in principle but it's very far off into the weeds of "things that
will never, ever cause an actual problem".
