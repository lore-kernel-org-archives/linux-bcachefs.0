Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285A44653A
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 19:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723060518; cv=none; b=NvgQyxiu0m5GPcCT+VoACt+OU3kBIe/0riSqyI2Psa1RJKgQ6IaGFr1+qUlyNz9BH2p95gPzCAFFJ+SKNcjGTOb92ohyFuxJ3tygCQR82uKf8HXMaxlJ1jgGpFO6wJCNuYFMvuhsMqCLSZ2UM/AvoJ0a8TSigiXSMUhfgvTrz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723060518; c=relaxed/simple;
	bh=HhsiE/wrHop5akd7kHIxc3p8wNaOs3jaeZzrBgiOwC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlRgJ4ftYMBbsX3GjmLlTDAUl4JbXOPaRJBaGGV+LBlvzvuBSWwLrkMD66sKFtmYICO+Bx3E5EcRRbXgRPHkpww+jfJ49vmB/rGmXtQrqugQyONm5kWc7SrcfWSpc4FIS2HjimLbT2w8L9itSBnP8Ut0lE1yX4LjvEgJMdB/mUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cFAJkMcx; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cFAJkMcx"
Date: Wed, 7 Aug 2024 15:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723060513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iKVcQ7raDkXMrJOeP3tosQtTXeFV9xSiRAlPo2pIuUI=;
	b=cFAJkMcx7pVGzy3INI5bWOXUYc9FNbGp2iHANB0t30w/iW+cF6afxmscMvw6zy6EXqsTXs
	PTmipOpy6pQwkpVwDJ+DD4ivJUm7bcj5JUQ0P9NKpgN3f3CWCiPlNfzo9qpu1v2pMUO+Kq
	2YTwOIFQGfBWRXh7bvXMGkqAHCZky7I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Eli Schwartz <eschwartz@gentoo.org>, 
	"Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Message-ID: <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
 <41409810.56.1723052597872@mail.carlthompson.net>
 <4609869.LvFx2qVVIh@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4609869.LvFx2qVVIh@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 07, 2024 at 08:58:23PM GMT, Martin Steigerwald wrote:
> I amended the subject line a bit. I am not sure whether Debian Testing or 
> Debian Unstable should also be avoided.

Unstable as well - unstable is stuck at 1.9.1 and tools is up to 1.9.4,
and it's their policy of switching rust dependencies to distro packages
that broke the build.
