Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB5620ED
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 17:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750007826; cv=none; b=LasqW0FWPB3Kfxa8163ubGxV16Ih247ga1rC9mpGNiNW5SDbo1TCVCqF1ISByl4rJwYlnvRh22Qh8X1caXSlqmNjeKUBrdoXRPa8fbENtb9T/Eb/Ji63AC9d8oO7XgrXiHB3rzIfhB/BA9esmkm4OtfCVl+xiGhpXgLEaiTJjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750007826; c=relaxed/simple;
	bh=7ADFjAzFShv8nQgxBXisDG7fu58H1QWxVCWt5kTOu4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAZMn4Fk1ulO3/0ucxeAJ3x1vptkAt5/yuxFWVonWP/1c7Jy3Wo1M8EO1yC9j0ZE8rgUo9OSiJEJqrm3YLjF3QNN1KjdGXL40yWakD2DY3SlTWFzkgbVIsxiawXh8SvIfU6M8cBCId375SnyPmnmnXZ7FUe7KJODeAg9DKrtCz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ri4NYucN; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ri4NYucN"
Date: Sun, 15 Jun 2025 13:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750007810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C7TjFeU6Cj9tBybVTwYxJkWNbfXrRrkW8083mmlv3fo=;
	b=Ri4NYucNEIvCNAC6mDd93bwC+ClfpWmZf1Aywn6b6ile3ryKhBLF4yD0Cq++PUYsJO/KA4
	XpeT8vwuOxjWdUWOW9Z7UPtkQUT6+S+5fJcVhr2kxaGxRuevXEvRNrPZrO+2UO7FJpYpTl
	Jhae/TuEd9A54dJ9NpXg0RPJnFKkLWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: don't return fsck_fix for unfixable node
 errors in __btree_err
Message-ID: <p5jd55daetpnpi6gmwn33uhmvz5rvbxlhwkjx454mq2fz7m4nk@pvijq3g7zopm>
References: <20250615164547.11900-1-bharadwaj.raju777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250615164547.11900-1-bharadwaj.raju777@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 15, 2025 at 10:15:38PM +0530, Bharadwaj Raju wrote:
> After cd3cdb1ef706 ("Single err message for btree node reads"),
> all errors caused __btree_err to return -BCH_ERR_fsck_fix no matter what
> the actual error type was if the recovery pass was scanning for btree
> nodes. This lead to the code continuing despite things like bad node
> formats when they earlier would have caused a jump to fsck_err, because
> btree_err only jumps when the return from __btree_err does not match
> fsck_fix. Ultimately this lead to undefined behavior by attempting to
> unpack a key based on an invalid format.
> 
> Make only errors of type -BCH_ERR_btree_node_read_err_fixable cause
> __btree_err to return -BCH_ERR_fsck_fix when scanning for btree nodes.
> 
> Reported-by: syzbot+cfd994b9cdf00446fd54@syzkaller.appspotmail.com
> Fixes: cd3cdb1ef706 ("bcachefs: Single err message for btree node reads")
> Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>

Applied

> ---
> v2: Return the given ret for all errors which are not btree_node_read_err_fixable when in scan_for_btree_nodes
> 
>  fs/bcachefs/btree_io.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index d8f3c4c65e90..940f7ce2e33e 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -557,7 +557,9 @@ static int __btree_err(int ret,
>  		       const char *fmt, ...)
>  {
>  	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
> -		return bch_err_throw(c, fsck_fix);
> +		return ret == -BCH_ERR_btree_node_read_err_fixable
> +			? bch_err_throw(c, fsck_fix)
> +			: ret;
>  
>  	bool have_retry = false;
>  	int ret2;
> -- 
> 2.49.0
> 
