Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20005B660
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Mar 2024 00:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710291273; cv=none; b=bOux0HY1dMqC9jYwyOsnv2exvpNYVkzoqBXE/FqS236u53XtrU8rymmfH1ZtzpJea6P5hIVBpc6EKiyhLUe0f5KY6IRdiusDna6anscqta4yIpF3J/Zas1VBD930zFP/82zUQEhvUgNs20obBcdj5pw8CWAMD83/QV+b+M0AnfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710291273; c=relaxed/simple;
	bh=3OXtApxekaIscO2m++ymiSGv67gkB+Zwjo+gBgcegT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJjS23IhH3ILcNpNp+24HvyrAi6BhNTrWYVRFJjUlKVeKIswt5E9MobHKi6cLvl7By03Tdvi36Kj/9cAH68/kIrmzAjOmzSqKnhwtHE32Qw6vKNhwqjdz8IbIMLGQQ3orrDkeRwbjbbbr5rVUh6fuVeV95kYIZyfn1edyFvHIqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RL/doPrK; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RL/doPrK"
Date: Tue, 12 Mar 2024 20:54:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710291268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W2B6neHTWJ/PWEeWF+1cmU1FwUVfgcJjA26sfqvTOWM=;
	b=RL/doPrKbR+5zXYVyoT0KUCmYZYv8+189cZHauWaEWx1Jxi5bLgr0bBVY9crrTlzXi3nho
	29FY5FRwb7L90k2ewEuv6ZFTi7E6lYkaAtKI5e9RBhTEyiP0CF0PQ+PpgfUzircULAHhcc
	J6Fqv4vu5tGYnLHtlNhHmQnDMqPZZF0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-stable@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.7.y
Message-ID: <zneppz2ohlalk2qeitdkzxvtexuqgfbhx6sxocgiasuuwsbopl@cr4d3wve2sot>
References: <2zaqetj6wlxgpbxgex643dnudgwhcrz23xgfuai3t3hgavjb2d@vwhyha3hlg5y>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2zaqetj6wlxgpbxgex643dnudgwhcrz23xgfuai3t3hgavjb2d@vwhyha3hlg5y>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 10, 2024 at 03:43:38PM -0400, Kent Overstreet wrote:
> The following changes since commit 2e7cdd29fc42c410eab52fffe5710bf656619222:
> 
>   Linux 6.7.9 (2024-03-06 14:54:01 +0000)
> 
> are available in the Git repository at:
> 
>   https://evilpiepirate.org/git/bcachefs.git tags/bcachefs-for-v6.7-stable-20240310
> 
> for you to fetch changes up to 560ceb6a4d9e3bea57c29f5f3a7a1d671dfc7983:
> 
>   bcachefs: Fix BTREE_ITER_FILTER_SNAPSHOTS on inodes btree (2024-03-10 14:36:57 -0400)
> 
> ----------------------------------------------------------------
> bcachefs fixes for 6.7 stable
> 
> "bcachefs: fix simulateously upgrading & downgrading" is the important
> one here. This fixes a really nasty bug where in a rare situation we
> wouldn't downgrade; we'd write a superblock where the version number is
> higher than the currently supported version.
> 
> This caused total failure to mount multi device filesystems with the
> splitbrain checking in 6.8, since now we wouldn't be updating the member
> sequence numbers used for splitbrain checking, but the version number
> said we would be - and newer versions would attempt to kick every device
> out of the fs.
> 
> ----------------------------------------------------------------
> Helge Deller (1):
>       bcachefs: Fix build on parisc by avoiding __multi3()
> 
> Kent Overstreet (3):
>       bcachefs: check for failure to downgrade
>       bcachefs: fix simulateously upgrading & downgrading
>       bcachefs: Fix BTREE_ITER_FILTER_SNAPSHOTS on inodes btree
> 
> Mathias Krause (1):
>       bcachefs: install fd later to avoid race with close
> 
>  fs/bcachefs/btree_iter.c        |  4 +++-
>  fs/bcachefs/chardev.c           |  3 +--
>  fs/bcachefs/errcode.h           |  1 +
>  fs/bcachefs/mean_and_variance.h |  2 +-
>  fs/bcachefs/super-io.c          | 27 ++++++++++++++++++++++++---
>  5 files changed, 30 insertions(+), 7 deletions(-)

Why wasn't this applied?
