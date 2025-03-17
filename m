Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE40324C093
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742226244; cv=none; b=ks0gelON6E9Y15tYz/NK+oNstHlZbkQlCvWYKRvWj38BWdGzT9eGmhF5UkVlFej2AU6fwhA6NOAh/BWEyjBhdaeTGnkOxauLrFqB6mZFctOOvpWCxJ25+Mwk5D0kb7Yws1kFNuYqZ873FO7qHbemK+K33pGvVWjBSVrsLoYgZNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742226244; c=relaxed/simple;
	bh=HweWuXVno1cUPhhRJOlmSfF5CWGKovsXQ5WmNgKz+TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJ3NMSaJqPDF3rflbMArT+nwqmh1gWKGsBT3/O2QeX0qRgWBhN+yySpt/1eN8vOQ7KSgh5t8luOnBeTbuyhsR/HjyhyAqVkgR7QUAPijlh+FDktXmClUl15lDC0X4zwaIMJGbcWA/lxElwho4AQyB4d3hZxFH/23VckDb5V+iJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e7wg9o2E; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e7wg9o2E"
Date: Mon, 17 Mar 2025 11:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742226230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTAvGCZXeahv7plONKJT4xRv09vtBVmg3OlFot8zA2M=;
	b=e7wg9o2EMDHOd5AwIg3MJHcFzLGyBUDdM6bxGL5v5QVcP112akBBLQtNrNEUR06yFGgcy7
	gFz+ojKOZEK7sKGBenOr+n36pOz/GoZi8EqPtzQrk00yilOlpSMGqZnUlS2nIcamzxiG5A
	/T/86M9+uqgzzhdG2Is+TWyuB5+hRXY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
References: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 11:30:13AM -0400, Martin K. Petersen wrote:
> 
> Keith,
> 
> > In my experience, a Read FUA is used to ensure what you're reading has
> > been persistently committed.
> 
> Exactly, that is the intended semantic.
> 
> Kent is trying to address a scenario in which data in the cache is
> imperfect and the data on media is reliable. SCSI did not consider such
> a scenario because the entire access model would be fundamentally broken
> if cache contents couldn't be trusted.
> 
> FUA was defined to handle the exact opposite scenario: Data in cache is
> reliable by definition and the media inherently unreliable.
> Consequently, what all the standards describe is a flush-then-read
> semantic, not an invalidate-cache-then-read ditto. The purpose of FUA is
> to validate endurance of future reads.
> 
> SCSI has a different per-command flag for cache management. However, it
> is only a hint and therefore does not offer the guarantee Kent is
> looking for.
> 
> At least for SCSI, given how FUA is usually implemented, I consider it
> quite unlikely that two read operations back to back would somehow cause
> different data to be transferred. Regardless of which flags you use.

Based on what, exactly?

We're already seeing bit corruption caught - and corrupted with scrub,
when users aren't running with replicas=1 (which is fine for data that's
backed up elsewhere, of course).

Then it's just a question of where in the lower layers it comes from.

We _know_ devices are not perfect, and your claim that "it's quite
unlikely that two reads back to back would return different data"
amounts to claiming that there are no bugs in a good chunk of the IO
path and all that is implemented perfectly.

But that's just bullshit.

When we do a retry after observing bit corruption, we need to retry the
full read, not just from device cache, and the spec is quite specific on
that point.

Now, if you're claiming that a FUA read will behave differently, please
do state clearly what you think will happen with clean cached data in
the cache. But that'll amount to a clear spec violation...

> Also, and obviously this is also highly implementation-dependent, but I
> don't think one should underestimate the amount of checking done along
> the entire data path inside the device, including DRAM to the transport
> interface ASIC. Data is usually validated by the ASIC on the way out and
> from there on all modern transports have some form of checking. Having
> corrupted data placed in host memory without an associated error
> condition is not a common scenario. Bit flips in host memory are much
> more common.

Yeah, I'm not in the business of trusting the lower layers like this.
Trust, but verify :)
