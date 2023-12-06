Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pQoj2+36"
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D523D59
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Dec 2023 14:42:14 -0800 (PST)
Date: Wed, 6 Dec 2023 17:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701902532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t2m72v5HZ7R0UwS9FWmyAhbAr8kC1G8ORLtc5501wbE=;
	b=pQoj2+36c5P9p4Ec4RlKEOPtddnG+30SULucbEyKSRICko0xFSc7s115iSUegwcw0kK/MO
	RswJef6kja7gaIJvEdrKSIV0iH9xhcAcM+t4i1uVO0/GSJoNLR71ItFy7GZ9YLSuJHtd6S
	iJwGeO7Kfeg4F54FubLFy2u2fjMLfls=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Steve Smith <tarkasteve@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [bug]: fiemap returns zero extents for all files
Message-ID: <20231206224209.d6xkiv6v3t2qbozg@moria.home.lan>
References: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
 <ZW85rKUfEXeaWqsL@bfoster>
 <CAHLWS5GOqsSZH5rZ4yobzUH+RbhznoQW0z1E_T=rTTJAXqXVTw@mail.gmail.com>
 <ZXDE7gn7xw5Hsli+@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXDE7gn7xw5Hsli+@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 06, 2023 at 02:01:02PM -0500, Brian Foster wrote:
> On Wed, Dec 06, 2023 at 10:26:14AM +1100, Steve Smith wrote:
> > Hi Brian,
> > 
> > Thanks for the suggestion. Yes, the ioctl call that xfs_io makes is
> > basically identical to the one the test makes, except it has the SYNC
> > flag set. Adding this flag (or calling fsync) results in expected
> > behaviour (mapped_extents > 0).
> > 
> 
> Ah..
> 
> > I assume that the bcachefs fiemap impl ignores unwritten data and only
> > responds with flushed extents? I'm not sure if this is correct; for
> > comparison, XFS, Btfs, zfs, and ext4, all return the extent map
> > immediately after write without syncing.
> > 
> 
> Ok, thanks for digging into the difference. I can reproduce what you
> observe by just removing the sync flag from the xfs_io command.

Whoops, yes, this is missing.

> 
> I know that XFS basically looks up extents in the in-core extent tree,
> which will include things like delayed allocation (i.e. buffered writes
> that have not yet been physically allocated and flushed to disk). It
> looks like bcachefs fiemap just walks the extents btree for associated
> inode keys. I suspect the buffered write path is just not updating the
> tree in any way, which means fiemap won't see extents until dirty data
> is flushed out. FWIW, this can also be observed by doing buffered
> overwrites and observing that the underlying block range does not change
> until the file data is flushed.

Correct - the only place dirty data can be found is in the pagecache
(which means the buffered write path doesn't have any other data
structures to update).

Don't know if it'll be useful, but the lseek() (SEEK_DATA, SEEK_HOLE)
also has to do this "check both the extents btree and the pagecache at
the same time" thing - might be worth looking at that to see if any of
that code can be abstracted/reused.
