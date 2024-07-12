Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AD77E6
	for <linux-bcachefs@vger.kernel.org>; Fri, 12 Jul 2024 00:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720742650; cv=none; b=GNrz3XLI5JhVgr2TmsEFOYbM6EFuFOljjOaye5sgpA++ihUDIBYlSxluZakH33lpwdcDx5msFWwv+jNGIqOuJ34HyInbRFDefL+wMMN0NPolgkTcPvAPJheAkJkrMeW7hvCViKe+nZ8BzyiZKcvrnZ0gBlmneckgnoZTbqlYyRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720742650; c=relaxed/simple;
	bh=jYDWG2Rccc9ppOjbT7ur995CyzIfZJTFU2E/CNxS6+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAkFlVAuESxRhG6GtTjbsjUlvrqXQZXn2CJzuRP6nJc/WBFVP9cTouRHywhV3+Xmy1bVozZH2C2lFtAK9Lg3I+bM9iRXT8RuG3OryHNyRZBpZ0cpudJiEwbcXxFHZi+A6r+zdB//YxS71f9jM642uqqkr4ddvKwc5I0kBYB5Isk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fcJRjWMW; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fcJRjWMW"
X-Envelope-To: youling.tang@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720742643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NpmF92RZAvQ03CCdChNzGq2NVsojJt2MFtSgcPMbVSI=;
	b=fcJRjWMWIo2M49WUPcJKl0JZesnUa0m+46U6b4WRe3KR9vP36YGcpR40f7e8JpuPyPEhPy
	m/MwfkcAfKxvnqpX14T/QlnptvqQORM+H+qKWnWgn3SL0dlHaJIXQhSYmy7Yy58h4ocmsT
	yQqRm+XGxQfcGc/qI/7qB+j/BBK2SKs=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Date: Thu, 11 Jul 2024 20:03:59 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Mark bch_inode_info as SLAB_ACCOUNT
Message-ID: <m5jemgkisszzs564ikvo6q6qr73tadanvoyyqstthzyamzsr3n@33quhsmhaxhz>
References: <20240703070955.104163-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703070955.104163-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 03, 2024 at 03:09:55PM GMT, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> After commit 230e9fc28604 ("slab: add SLAB_ACCOUNT flag"), we need to mark
> the inode cache as SLAB_ACCOUNT, similar to commit 5d097056c9a0 ("kmemcg:
> account for certain kmem allocations to memcg")
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

Turns out this was never tested with memcg enabled (!).

I'm reverting it, please feel free to send me a fixed version.
