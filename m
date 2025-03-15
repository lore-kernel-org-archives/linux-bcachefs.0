Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9E62046A4
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742059695; cv=none; b=d3gdQ9pKtX14rt90Zfk++Ram9g2Le2czi36dp7osl1eGUSmRV/rAH+BzoUmaJ9Kbg4fr2cO2VEWuo4C2dTQriAn/1nx4rOYRbkskHdNrwxTaJgHYXiJZbwz1tqV7jql6I60leE8HanwVybDM9ps5/KKCT1Ny+hzSyn6PehK8lhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742059695; c=relaxed/simple;
	bh=1REHPeYYE1pQ/ISEBu9d7w6bQ5SenFcDz7jDjpbLDzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaLgtcgjipe/PG0jSzXMZoLI/fNuJq+KqhPO/5vGo5poD6VmLVVSHzdrwXu0t2FPYw4peh9tr93dfBzGALPrgzGWhAQ+N9gyDnVj2zuTzU8+Yvbqh40V7ZNV8LaqIugOjs30w0p+XrEA5dksSmbagucb69dB89bFoNDza7qqz8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wqXLDC9l; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wqXLDC9l"
Date: Sat, 15 Mar 2025 13:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742059679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0G4db+CqLI7kZ8kLbNGSnqdaGWwmvGd9xz1e8aGybHg=;
	b=wqXLDC9lqOG8iunzDqyI6Xc07YfFDn8EQpN/9OEp/aXhJh1Np0e0k09NaWlGDrwYo16YLx
	Na9DQ4HDQ8jLsKdxmgmRjyd0B6pncmtloO/D3OQ5QEHxMXkNwnB2VLb2ybQYUwf9B24Rfw
	gDzSrG49kJs9+Uycl/m6JmXokcGj+ks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <20250311201518.3573009-14-kent.overstreet@linux.dev>
 <9db17620-4b93-4c01-b7f8-ecab83b12d0f@kernel.dk>
 <abk74sbsvsuijqhohyenl2mecz6unmkhavkga55fxsld6m6ise@ncbz3xmjlymw>
 <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 11:03:20AM -0600, Jens Axboe wrote:
> On 3/15/25 11:01 AM, Kent Overstreet wrote:
> > On Sat, Mar 15, 2025 at 10:47:09AM -0600, Jens Axboe wrote:
> >> On 3/11/25 2:15 PM, Kent Overstreet wrote:
> >>> REQ_FUA|REQ_READ means "do a read that bypasses the controller cache",
> >>> the same as writes.
> >>>
> >>> This is useful for when the filesystem gets a checksum error, it's
> >>> possible that a bit was flipped in the controller cache, and when we
> >>> retry we want to retry the entire IO, not just from cache.
> >>>
> >>> The nvme driver already passes through REQ_FUA for reads, not just
> >>> writes, so disabling the warning is sufficient to start using it, and
> >>> bcachefs is implementing additional retries for checksum errors so can
> >>> immediately use it.
> >>
> >> This one got effectively nak'ed by various folks here:
> >>
> >>> Link: https://lore.kernel.org/linux-block/20250311133517.3095878-1-kent.overstreet@linux.dev/
> >>
> >> yet it's part of this series and in linux-next? Hmm?
> > 
> > As I explained in that thread, they were only thinking about the caching
> > of writes.
> > 
> > That's not what we're concerned about; when we retry a read due to a
> > checksum error we do not want the previous _read_ cached.
> 
> Please follow the usual procedure of getting the patch acked/reviewed on
> the block list, and go through the usual trees. Until that happens, this
> patch should not be in your tree, not should it be staged in linux-next.

It's been posted to linux-block and sent to your inbox. If you're going
to take it that's fine, otherwise - since this is necessary for handling
bitrotted data correctly and I've got users who've been waiting on this
patch series, and it's just deleting a warning, I'm inclined to just
send it.

I'll make sure he's got the lore links and knows what's going on, but
this isn't a great thing to be delaying on citing process.
