Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9B2D272
	for <linux-bcachefs@vger.kernel.org>; Sun,  4 Feb 2024 23:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707090339; cv=none; b=TUvKcBsUkgbsXiwK+l7lEwXn9sBXTpfEeec4BevqLK472kPiiNX7/vEyvRLoGODiPvx7P1j+WxutsFN2AQouevJMWmtSbfwK10tkAu/8AiMcJsq+umRi5kB+4rvuwlMrwsZTJfwiLy6qPL0gsveEhzK++42AWaXmTszDG1n9b24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707090339; c=relaxed/simple;
	bh=vAqgJfJFkSQJoAzYlFwQvovMb21ijCrO0qywwdIZyuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZkUzKk7f40vU2vVM3j8eenpGW/rQPgxG0IXJ3i9wmb1D/h+ebVWShoZpUy6ooQvaMgfLG9GBGoFR162sa12VMbIySDP97F3a/9HWWQjNl+xHzxAcTFI+hIKUPJZ8ERHJNHrxuTwqsEGPcoWaXGmo3gusr35nDXM4AoA9xZJMoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sG1h6taF; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sG1h6taF"
Date: Sun, 4 Feb 2024 18:45:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707090333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wwOLrGwsOecYswDEXc4aSPNWwUQzxHlYsc5rtuzgyKo=;
	b=sG1h6taFN38dJxaTwrsYGof/tC7Y5DChk/SlHV9pQFIBHA150pZA51i7/V0q77rwW/V2cb
	pTcu9OmWRUlDcsconII9bpAFEhuOPJUoZb2AMiPqgDwaRe5MAhTmYBr6VYXfbGbDOfHf0p
	zNFqjFiQbP6+Hz+brfqRsdETAgQMkN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] rust: update bindgen to 0.69.4; remove custom type
 modifications
Message-ID: <pcj3od6gpxug7rwksamxfn2hnz2mrebrypa6ss67igmupeqvip@7r2s22ajvygg>
References: <20240204204923.332908-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240204204923.332908-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Feb 04, 2024 at 01:49:23PM -0700, Thomas Bertschinger wrote:
> This updates rust-bindgen to version 0.69.4 which includes the patch
> 199bee441ad0: "try to avoid #[repr(packed)] when align is needed". With
> this patch, bindgen generates code that is both ABI-correct and can be
> compiled by rustc, for 3 bcachefs types:
> 
> - bkey
> - bch_extent_crc32
> - bch_extent_ptr
> 
> This allows us to remove the custom treatment for these three types.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Thanks! Applied.
