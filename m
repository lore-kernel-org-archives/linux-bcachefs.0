Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DAB2500D0
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741690242; cv=none; b=URY3MPfopRw95l60ZLAM1dHLHQsdAD8fJDK7/tF/lDGr8NJC28xzBglCuYBW16ptzW7z24eyLDTj0AvyY7hzzTBZfvHZ972FzVDDS9abRt4IZztGOvmzIC2D5M777uAxicqkyzF9QyDIvagWy+z/zHat7wtWbATIQ3Oy2RZDcyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741690242; c=relaxed/simple;
	bh=nBjZf1u2hN6gZjA+s1zUBKo47rkKQYdv7n5EbBsACOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cF2nBmejnCNlWmA/a0Mr3eawBFZ0FtuiybEIDMQfDr9L2VnCBuOoJPm+XgVy33z4ycMpZRViUw6c6g0ygkDb4U9Yp8wbr3AaNHGtEpprqjmtcXczDc6VXlqcQob/K1cqpToG/I2dPgPTItFCqNPYbs9uqe+NgyiYRHIoJ3bXwA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kUWdCtrC; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kUWdCtrC"
Date: Tue, 11 Mar 2025 06:50:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741690228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1V5hJ26I6gRazId7fU1hqBzw/DYCVhVzgNLV64nnxIo=;
	b=kUWdCtrCYHZ/Nsbw96YfEbwlWjxrxmpU3RzuRBC8TxiqsfxnYbo5qqQtfQEV8GlZ5+KJVk
	MkruHhXGvV9HRpwxBXFR7e0DypxATHE/Dqo7DegRNnw4KWwRWfHzd+ZbZ49yBJrjG1sxZm
	CiFOrrqTukhTsg0Uly/5e3lDp2FWBHE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dave Chinner <david@fromorbit.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, cve@kernel.org, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, linux-security-module@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: CVE-2025-21830: landlock: Handle weird files
Message-ID: <aopeucbzl6v5ptrprc6fz4xpn65ccfg34wl4qiblwvmkkrjx5k@u22nfnxieipc>
References: <2025030611-CVE-2025-21830-da64@gregkh>
 <20250310.ooshu9Cha2oo@digikod.net>
 <2025031034-savanna-debit-eb8e@gregkh>
 <Z8948cR5aka4Cc5g@dread.disaster.area>
 <33m2msv3elqbviurca3ayebwzfzzjenh472b246gf7hbkfjk25@sl7plpwvpxig>
 <Z8-7CH7mwJtxpgyx@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8-7CH7mwJtxpgyx@dread.disaster.area>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 11, 2025 at 03:24:40PM +1100, Dave Chinner wrote:
> On Mon, Mar 10, 2025 at 10:09:22PM -0400, Kent Overstreet wrote:
> > On Tue, Mar 11, 2025 at 10:42:41AM +1100, Dave Chinner wrote:
> > If user mounts are enabled, that comes with UID mapping, and device
> > nodes disabled - no?
> 
> Not necessarily. Those security mechanisms are all optional mount
> options under userspace control....

Well, if someone's being an idiot, that's on them and not something I'm
going to argue about :) Uidmapping has been around for plenty long
enough for userspace to start using it.

> 
> > Out of curiosity, what's keeping us from saying "user mounts are
> > generally expected to be safe" for XFS?
> 
> What does "generally expected to be safe" actually mean?
> 
> If be "safe" you mean "won't crash the kernel if the structure has
> been altered in detectable ways with", then we already largely tick
> that box. However, there are whole classes of DOS attacks that are
> very difficult to detect without rigorous, expensive runtime
> checking (e.g. loops in btree pointers).

btree nodes don't change depth, so just recording the level of a node
and validating it trivially defeats that. bcachefs has that in its on
disk format, but if you don't have that then that might be a problem -
you'd at least need to know a priori the depth of the root node.

> Hence while we catch almost all the the obvious out-of-bounds
> corruptions within an object, detecting corruptions that require
> spanning a largely unbound number of objects to detect are not
> handled at all. I can corrupt a filesystem to induce an endless
> btree search loop like this pretty easily with a little bit of
> xfs_db magic. Yup, we even provide the tools to make doing stuff
> like this easy...

*nod*

In bcachefs, we right now have no way to cleanly detect "filesystem is
actually full, disk accounting info is wrong" so - that means corruption
causes allocations to get stuck. That one is fixable, and I'm going to
have to at some point since syzbot knows how to trigger it :)

> If by "safe" you mean "can detect all cases where a metadata field
> or file data has been tampered with", then XFS is completely unsafe
> and should not be used.
> 
> We can't detect that a malicious actor has changed something like a
> file permission field or the contents of a security xattr.  To do
> that requires cryptographically secure signatures of metadata
> objects and file data. We do not have that sort of feature in the
> on-disk format. We expect users that need protection from such
> tampering will use an envrypted block device to prevent malicious
> actors from being able to mutate the filesystem structure in this
> way.

Yeah, but that's the less interesting case to me. Not uninteresting,
since "I don't fully trust my block device" is a real scenario with
network attached storage. But generally, the tampering would be done by
the user that did the mount - so perhaps we need to find some new nudges
to make uidmapping of user mounts required?

That could be done in util-linux...
