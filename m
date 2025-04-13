Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83799A927
	for <linux-bcachefs@vger.kernel.org>; Sun, 13 Apr 2025 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744538180; cv=none; b=jaSjn5cCd4dNn1/rCRXdMy/VdcUg9luk+yCoE7QkKiRbafi6h82TDmbUtJ0UMxLOyftnEeoJUO3Yr1pPqMRhmPVp8dV/dxN9rte3BQtIBLP1s8EUHfODum14bR5pS88CVdNvHtW+AYyq3XB0SjbGv4cIsed6qxFIpesdq9DlUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744538180; c=relaxed/simple;
	bh=3sgm1ligwS3sXF5UycnDq5klhRh0HiWrV7UILfwQoyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAKuQKvIJlSEawCy3pcYtWuraTb9dPQIqOrpCEQc9ITS+bYBFBd1W2AxNGQo9yNWwSBHQlg2Q0yKG0C+hfTpsD5W9XO+M2Y6mPON1cQ64dgI+pcAWyX/dW03/X9t7RCnPmqi2J+38gJismd+t5/XgndxPu3iF0dDC4xPvmO8oeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H9d1r5LP; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H9d1r5LP"
Date: Sun, 13 Apr 2025 05:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744538174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CiKCtlqXO8mCqTofdtC4oND1oA6Yac7QW74NWPQH4bM=;
	b=H9d1r5LPFMaCp166/+ClC+VJ0ZqpBwc6HxU2vs7CdkEn2Xd7rV/EZDA0XIQ/dpa4SoWc7s
	pmL11tDBmiXihKU9MWeggh617YXqG+0VnSr4zLWPYCFaKLMbGwt/3Mjm6mczjPsOPmkZNy
	tI+/Bx/ByyvLre13vGY5L5iQ9iesqDs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Cc: syzbot <syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	charmitro@posteo.net, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Subject: Re: [PATCH] bcache: Prevent granting write refs when filesystem is
 read-only
Message-ID: <hiv262ds55eob3ymy4g3lcgwuvab52qwrr2rwhkn4spurzvql2@7e3woaekd23c>
References: <20250412183933.252062-1-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412183933.252062-1-gshahrouzi@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 12, 2025 at 02:39:33PM -0400, Gabriel Shahrouzi wrote:
> Fix a shutdown WARNING in bch2_dev_free caused by active write I/O
> references (ca->io_ref[WRITE]) on a device being freed.
> 
> The problem occurs when:
> - The filesystem is marked read-only (BCH_FS_rw clear in c->flags).
> - A subsequent operation (e.g., error handling for device removal)
>   incorrectly tries to grant write references back to a device.
> - During final shutdown, the read-only flag causes the system to skip
>   stopping write I/O references (bch2_dev_io_ref_stop(ca, WRITE)).
> - The leftover active write reference triggers the WARN_ON in
>   bch2_dev_free.
> 
> Prevent this by checking if the filesystem is read-only before
> attempting to grant write references to a device in the problematic
> code path. Ensure consistency between the filesystem state flag
> and the device I/O reference state during shutdown.
> 
> ---
> Not sure what to put for the fixes tag so I omitted it. The bisection
> that Syzkaller found technically is correct but only because additional
> warn_on checks were added recently. The git blame shows code from 8
> years ago for the specific lines being modified.
> 
> Also not sure if devices should have read and write permissions
> (ca->mi.state = BCH_MEMBER_STATE_rw) when filesystem is in read-only
> mode. If that is what intended, then I believe this solution works.There
> could potentially be other places where a similar scenario occurs.

Yes, that is intended. BCH_MEMBER_STATE is persistent state, stored in
the superblock and controlled by the user or when we notice a device is
going bad.

> 
> Reported-by: syzbot+aec9606169fbc3a12ca6@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67f50e3e.050a0220.396535.0560.GAE@google.com/T/
> Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>

Nice find - applied.

> ---
>  fs/bcachefs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index b79e80a435e09..788e870bfef6a 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -1757,7 +1757,8 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags)
>  	up_write(&c->state_lock);
>  	return 0;
>  err:
> -	if (ca->mi.state == BCH_MEMBER_STATE_rw &&
> +	if (test_bit(BCH_FS_rw, &c->flags) &&
> +	    ca->mi.state == BCH_MEMBER_STATE_rw &&
>  	    !percpu_ref_is_zero(&ca->io_ref[READ]))
>  		__bch2_dev_read_write(c, ca);
>  	up_write(&c->state_lock);
> -- 
> 2.43.0
> 
