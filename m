Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F0F78C6C
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 23:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725233972; cv=none; b=SNT3KoT0VWiKLxZanJVjGDIHnE/T3AYgm/7YgmR/TeBqsAABlKz9bSdWfOWPix8ksv71GMW18MFv16zM3346rleidifg3vs9aBRQ3a5e4skmfmlgnJD0di/8zLX9R4sB8nytyCl2eSatZjtVv5HbVWY5CT2I0xCFo7kuLzj0emc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725233972; c=relaxed/simple;
	bh=vJJLZL7EXiHDAQZKZt7Ro7eOvHHQwIrsRJlWKWn0FDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UdvMfc0vivZYHJiCWvTQidwQ3ORx0cKx2scd1Ok99++pd7krm1cW/2Emsd3h1L0NLpF5mIb+CGxg58KZdNoX36kxmnR76erZCeND4aUKAEK5C7olKqF19n0QukWEQsverSZYn/q4kXcmsronx/8sewkyjTtEXBda+AfVKS9iAqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MirVDSpE; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MirVDSpE"
Date: Sun, 1 Sep 2024 19:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725233967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7TPE9pQPxvJvC8UseSLNO4rP5+Iiy2ETekuVQASdDi4=;
	b=MirVDSpEeWVf4foQZRRw9YOME9PmDAwXg3L56cV9Zv9e2xm54cTM/3bMzFmhUXQb65Z2Py
	0ixmKe+XNE+DU+D73pTWp56NtvG/sYKRdUN/IlGuBAuWpa2wSTy+vGyUjSdfeeYPjZ5I9x
	/4WC7a/DOHBnDwyDdsm8zUyJxQcn6/o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Feiko Nanninga <feiko.nanninga@fnanninga.de>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix sysfs rebalance duration waited formatting
Message-ID: <q33j7al3vh4bjavsiuwouhrghvoijk2ubi2qvq5ccz5v4ogn7b@yzaki3ispzzr>
References: <20240901170821.10617-2-feiko.nanninga@fnanninga.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240901170821.10617-2-feiko.nanninga@fnanninga.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 01, 2024 at 07:08:05PM GMT, Feiko Nanninga wrote:
> cat /sys/fs/bcachefs/*/internal/rebalance_status
> waiting
>   io wait duration:  13.5 GiB
>   io wait remaining: 627 MiB
>   duration waited:   1392 m
> 
> duration waited was increasing at a rate of about 14 times the expected
> rate.
> 
> div_u64 takes a u32 divisor, but u->nsecs (from time_units[]) can be
> bigger than u32.
> 
> Signed-off-by: Feiko Nanninga <feiko.nanninga@fnanninga.de>

Thanks, applied
