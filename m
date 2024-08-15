Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E402B762D2
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Aug 2024 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731372; cv=none; b=cOYD+pAs4XM6F6g7kS0g5t0+AH9GCOakEzueVjt//YNxxfS5t6jAt0D7nrZxtD5H0ZKzACM8ZME8DNLGapiLsIlnW+jXlUr22rsPpdvFW/90NXuiqeaNul3U4xXTqhFxa9PKExV1AEsqVvpRxWNcy+RLX3UHx3UKPrjn3F74H34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731372; c=relaxed/simple;
	bh=CBbGXwKpWfZtOY3lnfYDdW3hW5Y5Qg6Ws+FAdH/xFo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcUSD1tOz9pm9aqyzBlihSH2JoOagZv5uXrRrMCVh0h7sssN2Dm5T4gCbYdSXr/symyQncnw0Wz3boFHyh3l5rNFgqD7ZQfMasNxnD9NE3p4YlHWLNe63Vc5pRTU7VFUTl3nTNpq7eKNG0ZUHscB4FkoOGMBB4T8WdlGTD9a9/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ECYrY2g+; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ECYrY2g+"
Date: Thu, 15 Aug 2024 10:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723731367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2tYSK8p06bsoRJhHkMdpM1MeiXSBmcTwCM5x9J+HYkw=;
	b=ECYrY2g+yuAy3gfdijn+s+i2cA/mvWkyyAVM1mDye+m3PxD2pkCcsOj2r7sN4sZTejwn6V
	VmB5dC4h6ImwRZ0Qmcx2y31vNJ8oiPMH7BJ7GoLGU/1AiINnMEjoZol+sBiz1oVfms9NUM
	e5hXaBJYVX9Cpm1i1Bz+Vee3D3JNXDA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Li Zetao <lizetao1@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] bcachefs: support iopoll method
Message-ID: <rqt2hvqaukziy5pzg3v7conihbjwa2icej23qbay3zm5b5kn5s@cvccny7kpz7p>
References: <20240815142034.1561661-1-lizetao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240815142034.1561661-1-lizetao1@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 15, 2024 at 10:20:34PM GMT, Li Zetao wrote:
> When bcachefs uses io_uring, implement the iopoll method to support
> IORING_SETUP_IOPOLL.
> 
> Signed-off-by: Li Zetao <lizetao1@huawei.com>

tested?
