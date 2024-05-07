Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E07158A30
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 May 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715091406; cv=none; b=ZdkSj1emom5jUbFPYBEzu4t9D4qb9C6Rbgp2ddkkX9KkY5pj/7XsuAIYdwN/BFd/biX5mzdIj930zZeYZx9dOh6PhYFYjYna/JT3seomfsHqXLt0ibiVjIQRZGpMK+HRy4fl5e2caw4JNB9itwVD8fhEMFjmRbFraQevgjKVsV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715091406; c=relaxed/simple;
	bh=Jk32hk5WOhtsPVTKlMP4zvg3sbi3DvnLTqWi+0DfZGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=It4NoVxvpOZI8TcQbK2VcRTyE4bnk9cMXY1VhZL+72PzbBeWle3Lz7B3YOmPQ3p4YxUD6z/bU3g+tYQhKdnhABdpBRDIlvKSQpCiQshqUVRlpN35VlvGMWSMCYiue6VZzxzdoxOZKYH2SGKz37soERwYvks4MlSkHN3ek9VokNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fJeUKJOF; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fJeUKJOF"
Date: Tue, 7 May 2024 10:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715091402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d7uYYjOih6xfXmWBun4mkQeyVXiZPiV6sYGIN/5Ync4=;
	b=fJeUKJOFGMcERPeeQHQEds9mFJV5TD9DfE6OpNiASci3NGIqJ3eCUxsbI73mZhUTyIRjQD
	/UZ8hn7tpuZ/NiTckFZCWNSxgT6uXQ4CEb/rA/1fYIGT6yWX1N4CWGkQ3GQ7yqqycNMO2U
	IZNyok0zDC4qVShz0TBW8B/GFNkIyjc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Petr Vorel <pvorel@suse.cz>
Cc: Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>, 
	Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	ltp@lists.linux.it, Coly Li <colyli@suse.com>
Subject: Re: [LTP] [PATCH v2 3/3] statx04: Skip STATX_ATTR_COMPRESSED on
 Bcachefs
Message-ID: <xlqa5l5si2mp3troac56tq7q3gansgi2fqs57rd2i2xrudiq34@iit2ymv4pzy6>
References: <20231207194011.273027-1-pvorel@suse.cz>
 <20231207194011.273027-4-pvorel@suse.cz>
 <20231213024617.vx3epsav2n2lxozi@moria.home.lan>
 <ZZvIBO-a1b_nIHJ8@yuki>
 <gjfjylr4bdytdot7ywjispswvgpvjtkdmtsinsbcbc42ik2y3d@ws4tjmwqywrb>
 <ZZ0guBd48WXYapPL@yuki>
 <ZiJtf07WGFJPb_w2@yuki>
 <20240507081846.GA97446@pevik>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507081846.GA97446@pevik>
X-Migadu-Flow: FLOW_OUT

On Tue, May 07, 2024 at 10:18:46AM +0200, Petr Vorel wrote:
> > Hi!
> > > > > Quite likely, other filesystems does have an inode flag that is set when
> > > > > file has been compressed and simply report that in the foo_getattr()
> > > > > callback. Looking at bcachefs I supose that we need to figure out if the
> > > > > inode is v3 and then unpack the v3 info to get to the compressed flag,
> > > > > you probably know best how to do that.
> 
> > > > I'm still not clear how we want to map STATX_ATTR_COMPRESSED, since it's
> > > > extents that are compressed, not entire files - and just reporting the
> > > > compression option is probably not what we want since it can be flipped
> > > > off, and existing data will still be compressed.
> 
> > > > Do you know anything about the intended use case?
> 
> > > As far as I understand the flag it's a hint that the file I/O may be
> > > slower/need more memory because of the compression.
> 
> > Ping.
> 
> > Kent we are getting closer to a next LTP release, are you going to add
> > the compressed flag support into bcachefs or should we add bcachefs to
> > the test skiplist?
> 
> Kent, gentle ping ^.

Add it to the skiplist for now, thanks
