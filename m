Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D51E260D
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Sep 2025 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756766323; cv=none; b=l1AOYtZCGkvt+qYcipGivWzWsc/K9AHaO7LQc9x/6QjQwn3WLYlMNdj0dkemX4hm5zB1/wP9FqALC0FP7M+GIfz/zLstp5m4PU7Obm7u8auGZYQfwlKYFJnf/SH33rOjaVZ5PCAlX2VPJtqVmh6NIHfpU6+2SykSCJWHSSmcqoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756766323; c=relaxed/simple;
	bh=1LRvez7G23oqTs/cGke5PIZ0iR3nPJIjQ908hMTiBgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMpQaP5Vl9C5PadujNnpdD2ojQPGtwS3ZUwAf7J9uHqLKtn8PVl6UnUsuWfFSGrwHn4eVsAcEsOsy4aBCkrWNLv8TBidCtb6LnyCtt8n+zqlBaF3jYJmg7DC3gWSf7But44g1zMa1G5R65DIM32ePvmvE1QbpvhJvLibo4zBikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YI4G4ClR; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YI4G4ClR"
Date: Mon, 1 Sep 2025 18:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756766309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f8HUpFIh/zYnk5qDXxnDpvmui25C29SBF2HbCeY/aUU=;
	b=YI4G4ClRZlOSVYpa9Y2qlX5diZVzL2WE5Auc7+GOvEQImN8eqvf7giNmKTBMp37Nc/jogL
	dtrthaXXNpOpcWeprPgplaal+SJVBQU7e2Vt90ROMvn/IJeb2qyodK7LbayevwP3Sst6dw
	y+TqGlBSk53iUnmQXAKmhb9IsaU1Ut4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use int type to store negative error codes
Message-ID: <wzcnnfwnjkrkbg7gj64cnddwxwcc5gw3jkv6356qmedjccitt4@3gsixqytzn2i>
References: <20250830135833.112327-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830135833.112327-1-rongqianfeng@vivo.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 30, 2025 at 09:58:33PM +0800, Qianfeng Rong wrote:
> Change the 'ret' variable in __bch2_dev_attach_bdev() from unsigned to
> int, as it needs to store either negative error codes or zero.
> 
> Storing the negative error codes in unsigned type, doesn't cause an issue
> at runtime but can be confusing. Additionally, assigning negative error
> codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
> flag is enabled.
> 
> No effect on runtime.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Thanks, applied

> ---
>  fs/bcachefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index 793c16fa8b09..ec20ab0ad84e 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -1769,7 +1769,7 @@ static int bch2_dev_alloc(struct bch_fs *c, unsigned dev_idx)
>  static int __bch2_dev_attach_bdev(struct bch_dev *ca, struct bch_sb_handle *sb,
>  				  struct printbuf *err)
>  {
> -	unsigned ret;
> +	int ret;
>  
>  	if (bch2_dev_is_online(ca)) {
>  		prt_printf(err, "already have device online in slot %u\n",
> -- 
> 2.34.1
> 
