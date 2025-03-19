Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451A81E1E13
	for <linux-bcachefs@vger.kernel.org>; Wed, 19 Mar 2025 16:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403598; cv=none; b=L5dcxyeFqJT/Zz54GSCV6rsXyOIrK0+x6HtMEJJvE6YQzQyRvOi75JuW1nxIydFJdmZK7diNrpIFdty+U4elmpqrjfKHLWnNpmlfYByFpZpnUcEH9g2ej4c+/0ew0jefWK8ccMgtzlDJsib7FE07GIRqNyycxoh9PyCDDb2mYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403598; c=relaxed/simple;
	bh=BXq1QOWw/7VgVsJrNZFj5k8jfNhbMlnp19P3R1b+ios=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kk8w4GKUgHxTBMMTZasysN4y1kL+aCdYdUZnuFU8ckxkfIt098dLxB8QvnLm3zXNoG/g/gx53lJuAgzYSv0evje25dZNVyunAvfLKan85aEXL0l2exiEMo9oz26rFJKMjY2hzahAZGco9OFO52NnZ3xo9ljjNyRirMfrbEWWARc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-222.bstnma.fios.verizon.net [173.48.82.222])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 52JGxWYl023358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 12:59:32 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F20252E010B; Wed, 19 Mar 2025 12:59:31 -0400 (EDT)
Date: Wed, 19 Mar 2025 12:59:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Cc: Dave Chinner <david@fromorbit.com>, cve@kernel.org, gnoack@google.com,
        gregkh@linuxfoundation.org, kent.overstreet@linux.dev,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, mic@digikod.net,
        Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: Unprivileged filesystem mounts
Message-ID: <20250319165931.GD1061595@mit.edu>
References: <Z8948cR5aka4Cc5g@dread.disaster.area>
 <20250311021957.2887-1-demi@invisiblethingslab.com>
 <Z8_Q4nOR5X3iZq3j@dread.disaster.area>
 <Z9CYzjpQUH8Bn4AL@itl-email>
 <Z9kC7MKTGS_RB-2Q@dread.disaster.area>
 <Z9rbDdLr0ai-UFE_@itl-email>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9rbDdLr0ai-UFE_@itl-email>

On Wed, Mar 19, 2025 at 10:55:39AM -0400, Demi Marie Obenour wrote:
> What kind of performance do the existing solutions (libguestfs, lklfuse)
> have?

For most of the use cases that I'm aware of, which is to support
occasional file transfers through crappy USB thumb drives (the kind
which a nation state actor would to scatter in the parking lot of
their target), the performance doesn't really matter.  Certainly these
are the ones which apply for the Android and ChromeOS use cases.

I suppose there is the use case of people who are running Adobe
Lightroom Classic on their Macbook Air where they are using an
external SSD because Apple's storage pricing is highway robbery, but
(a) it's MacOS, not Linux, and (b) this is arguably a much smaller
percentage of the use case cases in terms of millions and millions of
Android and Chrome Users.  Most of the more naive Mac users probably
just pay $$$ to Apple and don't use external storage anyway.  :-)

> There are other options, like "run the filesystem in a tightly sandboxed
> userspace process, especially compiled through WebAssembly".  The
> difficulty is making them sufficiently performant for distributions to
> actually use them.

I suspect that using a kernel file system running in a guest VM and
then making it available via 9pfs would be far more performant than
something involving FUSE.  But the details would all be in the
implementation, and the skill level of the engineer doing the work.

I'll also note that since you are mentioning Chrome OS and Android a
lot, there seems to be a lot of interest in using VM's as a security
boundary (see CrosVM[1] which is a Rust-based VMM).  So it's likely
that this infrastructure would be available to you if you are doing
work in this area.

[1] https://github.com/google/crosvm

Cheers,

					- Ted
