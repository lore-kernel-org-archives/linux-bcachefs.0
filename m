Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA0575805
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 04:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104288; cv=none; b=Kj0gymjYsMlBbrIkxK+PG2sK/lIA7F1IJcuP2xignPtYTK7GG2IOq7oxTsEW4c54194NF6M+Uvwkf/WS3I+ePER2AQViT10/KriDYH6PdqznqaIoVoufwEnM6oopYPyjw4roYFoqL0JZH/2f+rsALG1EsfQowkL3ukHw9UHC19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104288; c=relaxed/simple;
	bh=Z2HlDeAC9TBXtkatI1nuhpbt+GIHKTmJeiXfyoCQ7Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtH/BsL9z8vS6VAVYeHh8YrZ6/1lagJVhUov8qgKaPs4K0NIJ/zhl2IzFbybOpMenYoRMCD1yxJVU6L/6yNiaOsPQIfULkusEOUr1+ud5wC0+b5SLVBdClpvYpsdufR6v8P1jTXOmP1B36cAV3RLHRyAn2mJVo6IWp53bvaSig4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PYU7DGTD; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PYU7DGTD"
Date: Fri, 26 Apr 2024 00:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714104283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDTEZxiz5QlMPHXlPeDQbjwG5BL9Nni514enOu53Cdk=;
	b=PYU7DGTDcsS43ebJSAogz90CMqsNb1RRr2WnN5705RuQH9o+dlYL2xvq41+ZYAesiEMz0h
	YV0fEG2llvPOiBuIIukdWOgqNzFOEWVz/mVzEQz+SIhfJcJYI5cGyj5jare36C38c9aP1w
	cJNwsI1UvZfsIXP22MgT9D4AcI5Ghz8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] bcachefs: eliminate the uninitialized compilation
 warning in bch2_reconstruct_snapshots
Message-ID: <klmvmcxhce2yd2xdmeyrnvxdvh25jykwwpzov7volswdzrrff3@4bpqb6erpimf>
References: <20240426032136.2551471-1-lihongbo22@huawei.com>
 <20240426032136.2551471-2-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240426032136.2551471-2-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 26, 2024 at 11:21:35AM +0800, Hongbo Li wrote:
> When compiling the bcachefs-tools, the following compilation warning
> is reported:
>     libbcachefs/snapshot.c: In function ‘bch2_reconstruct_snapshots’:
>     libbcachefs/snapshot.c:915:19: warning: ‘tree_id’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>       915 |  snapshot->v.tree = cpu_to_le32(tree_id);
>     libbcachefs/snapshot.c:903:6: note: ‘tree_id’ was declared here
>       903 |  u32 tree_id;
>        |      ^~~~~~~
> 
> This is a false alert, because @tree_id is changed in
> bch2_snapshot_tree_create after it returns 0. And if this function
> returns other value, @tree_id wouldn't be used. Thus there should
> be nothing wrong in logical.
> 
> Although the report itself is a false alert, we can still make it more
> explicit by setting the initial value of @tree_id to 0 (an invalid
> tree ID).
> 
> Fixes: a292be3b68f3 ("bcachefs: Reconstruct missing snapshot nodes")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

this works - applied

> ---
> v2:
>   - Revise the code based on Kent's reviews.
> 
> v1: https://lore.kernel.org/all/20240419074851.1583392-2-lihongbo22@huawei.com/T/#u
> ---
> ---
>  fs/bcachefs/snapshot.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index 2368218070d4..3aa4686cc71f 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -900,7 +900,8 @@ static int check_snapshot_exists(struct btree_trans *trans, u32 id)
>  	if (bch2_snapshot_equiv(c, id))
>  		return 0;
>  
> -	u32 tree_id;
> +	/* 0 is an invalid tree ID */
> +	u32 tree_id = 0;
>  	int ret = bch2_snapshot_tree_create(trans, id, 0, &tree_id);
>  	if (ret)
>  		return ret;
> -- 
> 2.34.1
> 
