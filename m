Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C8E2DE6E3
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Dec 2025 17:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766769008; cv=none; b=dbQrZpjxzghwxfV7kJeFgTn5uHKqGAoAK7O9SljOxnfeQo5o+Wj4rNKRlxwP8f8EChDE/7F4tEHCnGffHFtSkY4xt8JJe94mjFyLRQ7iHGj8GNrXb0Dr63hgTfwoRdlWvu9/YfyP/v3Wgs1zTgZOkcBMtpK6ZDK8Hj19AEPn6X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766769008; c=relaxed/simple;
	bh=9SFsznR0+NPGDnXeoeabnAZTkfZ2ucMwQmHSPfNREus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyzrpUIsvJ4UmV1hx69F8P5iC+gOKlxQchIO6635dgSvHAWCmRDtRl8S5j4Z+UShVqDQ3SpeEltypiymauxggl1dvbTUfj4SBALLTYDvyQXqtLnpCi73sNvZdIu/tSM0Eloy/R9/rn8+NYo0sRnOHamCfgoPkx953R4mj3hHU00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ESgnAbEe; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ESgnAbEe"
Date: Fri, 26 Dec 2025 12:09:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766769000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9SFsznR0+NPGDnXeoeabnAZTkfZ2ucMwQmHSPfNREus=;
	b=ESgnAbEe1sL2cZCUrAPXhUaBuJtx7qslEzwhFTdDcN5bExhuWEVIRc1l2oqydNXEdNqR77
	o9ZZF4uarBIEHLD743XLYxXlLANNCJmxvUlLV7u7N/iV4rWx6aYul9CsqzgAXXIir8iRTc
	psLvvY+RhN8AlvQFecJO1/B1ySsiptI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: BP25 <bp25@posteo.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Version Control capabilities plus two small unrelated questions
Message-ID: <7dgvgc3usnl4nbpivj3wuemprknevx5tudji4ldzqkq7ngvfva@sbdg5tfhjnll>
References: <f284018630d0a24414d38028cd397345@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f284018630d0a24414d38028cd397345@posteo.net>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 24, 2025 at 04:02:01PM +0000, BP25 wrote:
> Hello, would someone kindly advise whether bcachefs supports file
> versioning, somewhat in the spirit of Stallman (lecture at KTH Sweden in
> 1986) where files are individually versioned (as opposed as taking snapshots
> of entire volumes) but the versions are not just ordinary distinct files,
> they are hidden files connected with each other.

Got a link to the lecture?

> In particular is there a standard way to 'follow' the same file along its
> snapshotted versions? Say, ask bcachefs to return the list of snapshotted
> versions by giving input this or that file in the current version of the
> filesystem? Note that if such file was deleted and another with the same
> name created I don't want that new file also to show up. And related
> question, is there any command that would list the snapshotted files which
> have no corresponding in the current version of the file system (for example
> because I deleted such file after having snapshotted it)?

Snapshotting is only at subvolume granularity, and right now there's no
way to create a subvolume that points to a single file. There's no
reason that couldn't be added, but if you do that you'll probably still
want to be able to follow history at the outer subvolume level; we don't
have proper support for recursive subvolumes.

History between different subvolumes is completely distinct; I could see
us wanting to support some sort of concept of "nested histories", but
that'd be a project for down the road.

> First small unrelated question: do you confirm that standard Guix is
> currently incompatible with bcachefs as root filesystem and is there any
> plan to patch Guix so that it's possible (with standard Guix installation)?
> Note: "Currently Guix System only supports ext4, btrfs, JFS, F2FS, and XFS
> file systems. In particular, code that reads file system UUIDs and labels
> only works for these file system types."

I haven't seen any incompatibilities reported. Util-linux supports
bcachefs and has for ages, so I'm not sure what that would be.

> Why does the generation number in bcachefs snapshots starts from U32max and
> goes down, instead of the naive start from 0 and goes up? There must be some
> strong conceptual reason for doing the first because I see already a few
> small conceptual reasons to do the second.

It's because of the way snapshot lookups work. When we do a lookup
within a subvolume, we first get the subvolume's current snapshot ID,
and then we do a lookup for SPOS(inode, offset, snapshot).

We want either the key for snapshot, or the closest descendent;
allocating snapshot IDs in reverse order means that ancestors come after
our search key, not before, and this is important because iterating
forwards is much cheaper than iterating backwards.
