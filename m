Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5281BC9E2;
	Tue, 10 Dec 2024 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858268; cv=none; b=TrtW3YMN2l3p3279Nrf5dgEMmDpQ3VHbREGGOOjahYJjYqUCuN1P5tau2vb02dku+IpDnuvclRDFY4N/87AZY2FXlR9ZJfuYFXmc89QoU+hZBqugj7cevgBY3an0xPtWcaluJGa3uaqmKc9nySp/kBl4kpTlyL6OkWqt6EE8iEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858268; c=relaxed/simple;
	bh=DtSI4q9agKjvQP+kvF0OA0ulQMNOErz0r1oRKwcrUwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kF6np+sWxJxx+o8uYYe/V7EyjwO4GNlqNT1lABeZGrFVPfCPFkA4s0Qv9rQWpxcj/2xkPZa3BcE2/+/LBhg3lb/IkTOpSsWm59zk40QQZMSz2JMsaT5p+Ym0OagEZC1nfjGe8pjn308Hv1D+I+328p7CFzxIHS9utUH46o6ykRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A86BA1063;
	Tue, 10 Dec 2024 11:18:12 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEF653F5A1;
	Tue, 10 Dec 2024 11:17:43 -0800 (PST)
Date: Tue, 10 Dec 2024 19:17:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: arm64: stacktrace: unwind exception boundaries
Message-ID: <Z1iT0AQqu5dqdCSg@J2N7QTR9R3>
References: <36kx57aw46vwykgckr5cm4fafhw54tjuj4cqljrdnpfwvjl7if@a7znuhpfu54o>
 <zbwbgkuvvciezpmigcp6gaahfxwm7cwhpzus7gtbfnbzsjb2n3@kfbdppbd74o4>
 <Z1bWaGCvUrwrj2fZ@J2N7QTR9R3>
 <Z1gll87-TkAqFwUz@J2N7QTR9R3>
 <rxc57eg65sg4iayhj7gc7yl24w524lviedxnydl2mggqnatglq@iairj2ci7ioj>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rxc57eg65sg4iayhj7gc7yl24w524lviedxnydl2mggqnatglq@iairj2ci7ioj>

On Tue, Dec 10, 2024 at 07:40:04AM -0500, Kent Overstreet wrote:
> On Tue, Dec 10, 2024 at 11:27:19AM +0000, Mark Rutland wrote:
> > On Mon, Dec 09, 2024 at 11:37:12AM +0000, Mark Rutland wrote:
> > > On Thu, Dec 05, 2024 at 01:04:59PM -0500, Kent Overstreet wrote:

> > Looking some more, I see that bch2_btree_transactions_read() is trying
> > to unwind other tasks, and I believe what's happening here is that the
> > unwindee isn't actually blocked for the duration of the unwind, leading
> > to the unwinder encountering junk and consequently producing the
> > warning.
> > 
> > As a test case, it's possible to trigger similar with a few parallel
> > instances of:
> > 
> > 	while true; do cat /proc/*/stack > /dev/null
> > 
> > The only thing we can do on the arm64 side is remove the WARN_ON_ONCE(),
> > which'll get rid of the splat. It seems we've never been unlucky enough
> > to hit a stale fgraph entry, or that would've blown up also.
> > 
> > Regardless of the way arm64 behaves here, the unwind performed by
> > bch2_btree_transactions_read() is going to contain garbage unless the
> > task is pinned in a blocked state. AFAICT the way
> > btree_trans::locking_wait::task is used is here is racy, and there's no
> > guarantee that the unwindee is actually blocked.
> 
> Occasionally returning garbage is completely fine, as long as the
> interface is otherwise safe. This is debug info; it's important that it
> be available and we can't impose additional synchronization for it.

Sure thing; just note that there's no guarantee that this is only
"occasionally" garbage -- this could be wrong 1% of the time or 99% of
the time depending on the specific scenario, HW it's running on, etc. As
long as you're happy to hold the pieces when that happens, that's fine.

I've pushed out fixes to the arm64/stacktrace/fixes branch on my
kernel.org git repo:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/stacktrace/fixes
  git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/stacktrace/fixes

... and I'll get that out as a series on the list tomorrow.

Mark.
