Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3554BE2
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Apr 2024 03:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712633594; cv=none; b=FgeKF51s7iEkErBpFiIZxDVQhy5wify8FbBWi572e0txCH0s5Qxs97+KBmei5Nq4BUxjTje3kYsDAPbTml+FDjo981HfHsvltA04G5jG0ID4GZ0u/pU6Urlie4w54OwQil1bLxcO/gcgrIBL6x560C0y7xAxEoosy3q3ZxSZSR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712633594; c=relaxed/simple;
	bh=WG7c11lRenLEhO0VEIaPnYm9oN5JnQhokyTfJqFW5mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6bGwouLqy+AReA8JGzjqmdbefe48RbdjhDhOhREYiStd7f6jQJZQqglm/kVBrFJDJ+8DczGmhTrx7d4oGcHr04aGoieAMSPJen9eLzJ/KMn7r4XC0K5UynJqfuD6mFjodG/8hgmvintjZtWCVIw996f9EqQkWEu5G8+hfsfoF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f3GD228K; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f3GD228K"
Date: Mon, 8 Apr 2024 23:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1712633589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=amEXq2nmknYgeO6zm431Sd7JCaCkZoq9ZftbqI/6A/E=;
	b=f3GD228KnPO/CqlbxDicH0BJJnDfv6pfqiSdLy5bltm7Zrb4oWc64f2HBzI1OK/OWsX3ws
	7wOJaUvRfFKquHsA47cerDIgl2S0bVIi+SOV1fLMccNh/HW16bKObgAQSG6axUaLQZyt4s
	9VA9LClgVy5IkhT0Iyc5MBIR7Y9fhhs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Eric Van Hensbergen <eric.vanhensbergen@linux.dev>, v9fs@lists.linux.dev
Subject: Re: [PATCH v3 0/4] bcachefs: fiemap delalloc support and cleanup
Message-ID: <bytl4gftjro45osrlzqeokzci2imtdidne5a7pkn3xtr6fdbhf@mxjefwpljsto>
References: <20240408144846.1001243-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408144846.1001243-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 08, 2024 at 10:48:42AM -0400, Brian Foster wrote:
> Hi all,
> 
> Here's v3 of the fiemap delalloc support patches for bcachefs. The main
> difference from v2 is that the pagecache seek calls are now using
> nonblocking mode to avoid deadlocks between fiemap and the write path.
> The write path locks in folio -> extent btree order while fiemap walks
> the extent btree and scans for folios in transaction context. Therefore,
> the latter must restart the iterating transaction in the event of folio
> trylock failure and restart the scan from where it left off.
> 
> The series is pushed to CI via my test branch, as usual:
> 
> https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

So our testing is currently busted because of a bug in 9pfs - I need you
to rebase onto my 9p-revert branch so we can get test results we can
look at:
https://evilpiepirate.org/git/bcachefs.git/log/?h=9p-revert

Eric, is this getting fixed? If it's not, and _soon_, we need to send
this revert to Linus - then put it through more testing, more asserts,
whatever you need and send it again next cycle, _after_ you've figured
out what wwent wrong.

Patch series looks good, though - if there's nothing you think needs
special attention I'll go ahead and merge it.

I wonder if at some point we could clean up the indirect extent lookup,
that's common between this code and the read paths, but that's low
priority.
