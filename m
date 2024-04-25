Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E922E642
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714016098; cv=none; b=LGuVnuXIGFLDkecKFB7qeZk8tMjWe5vSCTF+mmpllGgOjVcaNxCjnmpDryj3bYlNf9Z5Fcg1VwTGeN5imju2Hi8c9magLT8zACEuWiajqjh2fof0H3af1JlIZo5wHJxsCsZtWFxNnTZF9RBpfT8mCrQi1KPIcccSaCVlfkEl87k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714016098; c=relaxed/simple;
	bh=MYRog5qYHdyY6wgDbPPfGtSidDbAYF4BDDQGAfixxdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AT4D5h8jKovrQCvGyHTdRGyJz4TE60zHmKr7VhjvP5ItUtIvOhSi194qDvR5NtOvko20eZhzfiBKJWNf3z/xQHcQmi50xWkJ2O7M9DD6HyktUSdIGSUHyjyDOd8sPwhonCFMIZGD1bx1Cgx5zGhkh6c7XMDN2M8jSCpH6ID9CJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mPQ9XjSc; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mPQ9XjSc"
Date: Wed, 24 Apr 2024 23:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714016094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6Wxx78aToBqun/rRopiuoY1yVnLqmPzUmwdRRzOiEQ=;
	b=mPQ9XjScGzHM0Qjq3BDkj3WVWJK3U2jKcPs7tufODlFY70cWuNN5opCA/IymuYdCZlvXsH
	tJZIIz83GwM36rCzCVlWIXQktjdwRTQRT+NsEeTOdne3xjxl5lUO6C563fJLy8w6CKE5UV
	P1HkQy8L+UrDlsXbOFgxorCG3A4MhE4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: eliminate the uninitialized compilation
 warning in bch2_reconstruct_snapshots
Message-ID: <iugrlvi6jpwhcliq54e2cxjzfikhm2mpx7hj22sy455xrv6ho2@ch3lbvaeiztz>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
 <20240419074851.1583392-2-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240419074851.1583392-2-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 03:48:50PM +0800, Hongbo Li wrote:
> [BUG]
> When compiling the bcachefs-tools, the following compilation warning
> is reported:
>     libbcachefs/snapshot.c: In function ‘bch2_reconstruct_snapshots’:
>     libbcachefs/snapshot.c:915:19: warning: ‘tree_id’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       915 |  snapshot->v.tree = cpu_to_le32(tree_id);
>     libbcachefs/snapshot.c:903:6: note: ‘tree_id’ was declared here
>       903 |  u32 tree_id;
>        |      ^~~~~~~
> 
> [CAUSE]
> This is a false alert, because @tree_id is changed in
> bch2_snapshot_tree_create after it returns 0. And if this function
> returns other value, @tree_id wouldn't be used. Thus there should
> be nothing wrong in logical.
> 
> [FIX]
> Although the report itself is a false alert, we can still make it more
> explicit by:
>   - check the input parameter 'u32 *tree_id' with WARN_ON_ONCE
>   - initialize @tree_id to U32_MAX
>   - add extra WARN_ON_ONCE to make sure @tree_id is updated
> 
> Fixes: a292be3b68f3 ("bcachefs: Reconstruct missing snapshot nodes")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/snapshot.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index 0b26dee17a5a..cad3408903b2 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -78,6 +78,7 @@ __bch2_snapshot_tree_create(struct btree_trans *trans)
>  static int bch2_snapshot_tree_create(struct btree_trans *trans,
>  				u32 root_id, u32 subvol_id, u32 *tree_id)
>  {
> +	WARN_ON_ONCE(!tree_id);

There's no point checking for a null pointer like that; the oops from a
null ptr deref gives us exactly the same information.

>  	struct bkey_i_snapshot_tree *n_tree =
>  		__bch2_snapshot_tree_create(trans);
>  
> @@ -900,7 +901,7 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
>  	if (bch2_snapshot_equiv(c, id))
>  		return 0;
>  
> -	u32 tree_id;
> +	u32 tree_id = U32_MAX;

Just initialize it to 0. 0 is an invalid tree ID, so it'll be caught by
snapshot_tree_invalid() if it's not set.

>  	int ret = bch2_snapshot_tree_create(trans, id, 0, &tree_id);
>  	if (ret)
>  		return ret;
> @@ -910,6 +911,8 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
>  	if (ret)
>  		return ret;
>  
> +	/* bch2_snapshot_tree_create returned 0, @tree_id must be updated. */
> +	WARN_ON_ONCE(tree_id == U32_MAX);

Nix this as well.

>  	bkey_snapshot_init(&snapshot->k_i);
>  	snapshot->k.p		= POS(0, id);
>  	snapshot->v.tree	= cpu_to_le32(tree_id);
> -- 
> 2.34.1
> 
