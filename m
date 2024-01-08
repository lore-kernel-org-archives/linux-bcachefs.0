Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B355E70
	for <linux-bcachefs@vger.kernel.org>; Mon,  8 Jan 2024 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hArcSTsZ"
Date: Mon, 8 Jan 2024 15:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1704747279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RcYTwFfSB+4FKsdjsP7P++2hZCBcGK1EdtN9nb4v1IU=;
	b=hArcSTsZ/Ctb7L81FQJl0LBtNkZbCuNF3zeMTbiHhuE+hFnfb8tuSTPRuWOEHX59Eqgdma
	StObN5+3huGXnaWIM6Pqhpjg8aBKXGxo0K7GoSq9ZoZrgt1eRxEZ9PBRI3eAY3jTTiJsZS
	i0OyKpTi3u5KCJnhgmQq9nlALvu11CM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Petr Vorel <pvorel@suse.cz>, ltp@lists.linux.it, 
	Li Wang <liwang@redhat.com>, Richard Palethorpe <rpalethorpe@suse.com>, 
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>, 
	Yang Xu <xuyang2018.jy@fujitsu.com>, Brian Foster <bfoster@redhat.com>, 
	linux-bcachefs@vger.kernel.org, fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on Bcachefs
Message-ID: <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
 <ZZvIBO-a1b_nIHJ8@yuki>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZvIBO-a1b_nIHJ8@yuki>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 08, 2024 at 11:01:40AM +0100, Cyril Hrubis wrote:
> Hi!
> > On Thu, Dec 07, 2023 at 08:40:11PM +0100, Petr Vorel wrote:
> > > STATX_ATTR_COMPRESSED is not supported on Bcachefs, thus skip it
> > > (it's already skipped on tmpfs and XFS).
> > 
> > Hang on, bcachefs most definitely does hae compression. This would be
> > just because statx isn't plumbed through?
> 
> Quite likely, other filesystems does have an inode flag that is set when
> file has been compressed and simply report that in the foo_getattr()
> callback. Looking at bcachefs I supose that we need to figure out if the
> inode is v3 and then unpack the v3 info to get to the compressed flag,
> you probably know best how to do that.

I'm still not clear how we want to map STATX_ATTR_COMPRESSED, since it's
extents that are compressed, not entire files - and just reporting the
compression option is probably not what we want since it can be flipped
off, and existing data will still be compressed.

Do you know anything about the intended use case?
