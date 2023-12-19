Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA23BE56
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 04:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qXH4zxO8"
Date: Mon, 18 Dec 2023 23:17:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702959458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UELOWGm60833bCalbOycSyVux9oWd5oLQ4BrTZf6mOw=;
	b=qXH4zxO8a2MyKsvGKfD5RWjsfKxgp1jTxv8Vm8mZyqtZy8KuM1WGwOUweVZEIIzfv0xyTm
	oaC9IxATYIRoB51nAH5rCW0Bb8Zq/YE7EyAR12KQz1bFeQZWTLkleTO4GSmn7xHtdBKuAY
	mYHSq3iwQgz0RPTUoutul+G0Sn1EBvY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs CLI: question on use of mlockall()
Message-ID: <20231219041736.fuglpnmabylhw3wg@moria.home.lan>
References: <20231219040747.GB251273@fedora>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219040747.GB251273@fedora>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 18, 2023 at 09:07:47PM -0700, Thomas Bertschinger wrote:
> The mlockall(MCL_FUTURE) call at the beginning of the bcachefs CLI
> tool seems problematic in some cases. When running commands as an
> unprivileged user with the default mlock limit (8 MiB), it can cause
> ENOMEM failures, for example:
> 
> $ ulimit -l
> 8192
> $ fallocate -l $((1024 ** 3)) test-image
> $ bcachefs format test-image
> ...
> error opening test-img: ENOMEM_fs_other_alloc
> 
> 
> While this can be worked around by running the bcachefs utility as
> root, or by raising the default limit, I think commands like this
> should work for unprivileged users under a common default configuration.
> 
> I wonder if the mlockall() can be targeted to the scenarios where it's
> really needed, instead of applying to every bcachefs command? Some
> ideas on how to target it: 
> - only call it if running as root
> - check that getrlimit(RLIMIT_MEMLOCK, ...) is at a "high enough" value
> first
> - or, only call it for subcommands that actually need it
> 
> Any thoughts / comments? Would a better, or complementary approach, be
> to reduce the amount of memory mapped for operations like 'format'?

Perhaps it's time to delete it, since our run_shrinkers() path is now
also considering swap usage?

The idea was that we really don't want to be swapping, since generally
memory usage will be dominated by caches that we can evict from - we
would rather have the mmeory allocation fail instead.

But I think we can just delete it if it's not working properly, since we
also have shrinkers running in the background via a thread too.
