Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A51157A6B
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Aug 2025 05:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754111534; cv=none; b=iXp8Dqp2UMlhZfk0KsDFXSp9izvuLfatidWsp6/4qdTXzH5CkTDanOzj9bjKeB6DuiwgZlV5wuCecK1knniDIf5lmMLnsZJ2gV9IeWMx3OaSfoT+1qc4SgWiG5JDKcO2Pns1lz7T9WJFO8qZqoRKMm5eoIcRYQERqpcZt0H92Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754111534; c=relaxed/simple;
	bh=iOUu7O/wJesHy8AbfrHhRre3q+kUYf9iGWdLC2vzH0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOWZx6SrdoenF9is5n/k2uV/lN7zVn3gWPcFiT6wSSYdrdixqt6AQRU31ZsyB8MzSjp34kbdguByWMnK7cijGSqfmjG+uuT+na4JsuJbEPgVBmXZ+Ga9A2f6J/vC0Ym89ClgaBf4tj44GGN+ouQLSvYPJGXGpYLHyiePTT6EEU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uvRPJhzO; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uvRPJhzO"
Date: Sat, 2 Aug 2025 01:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754111528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4Uv9OSYn3FxxW4ZOGoLh26ddPpNoj9QuqW7WES3/tI=;
	b=uvRPJhzOwBoAwcYLIDBb6VapBJsnj4uUNq9WEgQrM2MaX257br2DfrV5/TLKRvoXOecTWP
	DaPms0gXWqIfhxhUsngIeJNvfxuVlKHGYFuSUhd2R1iQkSsWf1AbdfUDc38zxi5NrYt6+P
	0vM9ZY9juVMD5FnY5RQooEeMZrJrdzM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+d3fa2fb715cfcc9d201d@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix incorrect transaction handling
Message-ID: <6zhilbfuszhqbmcvzduseu3uztkca6jju34hwby7j24peq6dhw@3lmrcilnaglu>
References: <20250802050511.72518-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802050511.72518-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 02, 2025 at 01:05:11PM +0800, Alan Huang wrote:
> The ')' before the second '?:' is not correct, transaction restart
> handling should include bch2_inode_hash_init_insert.
> 
> Reported-by: syzbot+d3fa2fb715cfcc9d201d@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

hah

applied

> ---
>  fs/bcachefs/fs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 3b289f696612..b5e3090f1cb8 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -511,8 +511,8 @@ struct inode *bch2_vfs_inode_get(struct bch_fs *c, subvol_inum inum)
>  	struct bch_subvolume subvol;
>  	int ret = lockrestart_do(trans,
>  		bch2_subvolume_get(trans, inum.subvol, true, &subvol) ?:
> -		bch2_inode_find_by_inum_trans(trans, inum, &inode_u)) ?:
> -		PTR_ERR_OR_ZERO(inode = bch2_inode_hash_init_insert(trans, inum, &inode_u, &subvol));
> +		bch2_inode_find_by_inum_trans(trans, inum, &inode_u) ?:
> +		PTR_ERR_OR_ZERO(inode = bch2_inode_hash_init_insert(trans, inum, &inode_u, &subvol)));
>  
>  	return ret ? ERR_PTR(ret) : &inode->v;
>  }
> -- 
> 2.49.0
> 
