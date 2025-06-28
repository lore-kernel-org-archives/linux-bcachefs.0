Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD931C8633
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Jun 2025 01:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751075982; cv=none; b=G+oRel1pZGkgrrW8nlPM7TDHzzgRwmJe6tNTCGOQv+NMM4OiLEIjlzbQnMZ+XfK+lju3hcpmjIdHAnfXm2583PSndWk+GpRSYVqpVhHoGtow7klt1HeHXkrinpsUxmRaLcpGnwnz/OZi+08+YNgrcfgxJakD+2qDS4nUb+I2N8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751075982; c=relaxed/simple;
	bh=zKekZwSqQusN2Lf8w2F4JMK3LpxFMNG4m1N534slQrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bq+0l6qqrK3x0UHTGR6kqHYn9iI9es/P1uOjv5mJ2VsAIYBMWf0ttVSMHljqDtY4NLgXhlt/5k36xVOr8M4J1hTqrCawwtKL+BiBc4nvG4F+KAJ5CF2f+cXEWIonqOh3+hf37rk+WWA9TFO8lp7uKDymKtj4wWn+h47zmcli3+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from macsyma.thunk.org ([70.33.172.117])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 55S1xYIu025556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 21:59:35 -0400
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id AB867340685; Fri, 27 Jun 2025 21:59:34 -0400 (EDT)
Date: Fri, 27 Jun 2025 21:59:34 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kerenl@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Message-ID: <20250628015934.GB4253@mit.edu>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
 <20250627144441.GA349175@fedora>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627144441.GA349175@fedora>

On Fri, Jun 27, 2025 at 10:46:04AM -0400, Josef Bacik wrote:
> On Thu, Jun 26, 2025 at 10:22:52PM -0400, Kent Overstreet wrote:
> > per the maintainer thread discussion and precedent in xfs and btrfs
> > for repair code in RCs, journal_rewind is again included
> 
> I'm replying to set the record straight. This is not the start of the
> discussion. I am not going to let false statements stand by unchallenged
> however.
> 
> Sterba has never sent large pull requests in RCs, certainly not with
> features in them.  Even when Chris was the maintainer and we were a
> little faster and looser and were pushing the envelope to see what
> Linus would accept we didn't ship anything near this volume of
> patches past rc1.

And as far as XFS is concerned, "citation needed".  Dave Chinner (who
is not the current XFS maintainer) has asserted that there might be a
time when XFS *might* want to send repair code post merge window.
However, I'm not aware of any time when Darrick Wong was working on
XFS online repair that he sent changes outside of the merge window as
the XFS maintainer.

And now that XFS online repair feature is upstream, *bug fixes* can be
sent at any time.  So (a) I am not aware of any time that XFS *has*
sent online repair changes upstream outside of a merge window --- this
is just an assertion by Kent --- and (b) I am not sure when XFS would
need to send some kind of new feature involving online repair
upstream, given that online repair is *already* upstream.

							- Ted
