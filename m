Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0E16BE11
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 Aug 2024 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722616299; cv=none; b=k9gO566+Xdzdh5LFsEPZH3x8z45xqapo6Fh8NgBFPDOu94whZ4IrQytyGGwxdFMPim8cF2k4iIzctuzhCfD8qI8YXJO4cqBYNicaKiYrjIJF3CmohhmurhfxUABtndTM8D7QelvKSRLZ2hitOy/g6LBDpP/2oWGSF1z4yyaTaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722616299; c=relaxed/simple;
	bh=y0WY3CunhTZIpnuErHAPRcxtXrpO/GfJZIyorvkYkbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKCLX/0AUwLIs6HmMNl+u9X+pOa17ChozkTqFLRZ/CAVfWyuHFS4HC4qMHBbFmq7th16wRVQ7Q+xYa2eYt7jqwHPfdCVi28+8C4iRcMtUSWwX8WFbCywu0ieqjoP746utpFSiga3rqRw1nK+9E+CidAzX9oBtrzh77UL5l1Qqhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k94FDO1e; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k94FDO1e"
Date: Fri, 2 Aug 2024 12:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722616295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CoGEWBiX8wuhk2qDLN5YtQAvEg6xRJzEUoyModN35Ng=;
	b=k94FDO1e0L5uKK7Lwv+iwXpqXrME9UAYCHZVt7gXykYC/o0AjbubXEVcB9IXP44Hk9R8VV
	tVwzKab7KRC+TTlS7K4658XYaZO2+F0l7qjDwWwiontPz/yG9eDh4lbtctozWGnJitRGVR
	Yu2rnEti1h1E/+2BS0tGyTZw58ZTZA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: prevent lookuping excessively long paths
Message-ID: <nulcwctn566adoyulms773fhpxifop7zoqwbt67dj54wfk6qrp@6pdpcy3xntcv>
References: <20240709081020.3728942-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709081020.3728942-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 09, 2024 at 04:10:20PM GMT, Hongbo Li wrote:
> The longest name length for file is BCH_NAME_MAX in bcachefs.
> When looking up a longer path, it does not check this limit. So
> we add the validation for this to avoid undetermined risk.

What's the actual bug this fixes?

> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/fs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index fd01a5402c28..f8da598ca9f8 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -474,6 +474,9 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
>  	struct bch_inode_info *dir = to_bch_ei(vdir);
>  	struct bch_hash_info hash = bch2_hash_info_init(c, &dir->ei_inode);
>  
> +	if (dentry->d_name.len > BCH_NAME_MAX)
> +		return ERR_PTR(-ENAMETOOLONG);
> +
>  	struct bch_inode_info *inode;
>  	bch2_trans_do(c, NULL, NULL, 0,
>  		PTR_ERR_OR_ZERO(inode = bch2_lookup_trans(trans, inode_inum(dir),
> -- 
> 2.34.1
> 
