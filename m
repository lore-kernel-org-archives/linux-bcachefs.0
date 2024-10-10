Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1990E1CFB9
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 02:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728525842; cv=none; b=OqV5G3WUudrmQEX29M40DF1UFEOwQGga/zWkvFRUypokTKoS2vzp3rYCgZ7tSt+boBcXQm/9/DZZszD6uGqMuwTi/j8ywjsnggm77L0LLSlZp3MirZxz2eIqVvGmM0tEtbrh6p8s0QZelG6ZBQOWPNwsHjc761WKZUKsP4ar5VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728525842; c=relaxed/simple;
	bh=BDjxCKFfyLilIFJFYy6/pxzquUHxABEXXsUrxbro9vE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4szWOC704oEzSPbwoynKT3Yyp9ZbQ9DoQkGVFymbmn9ydJVJTqdw8H9FKhS38gcoIH37snU3AzWEI13+zfw58GJAnzFtHQL4TKr7MtPKU0R4HAkKQzrImoyC9DX9f/gcy2XpB77fetlFH9gZSnUMTaJxg9znTHW4hexG8KslK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bA2yEOS9; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bA2yEOS9"
Date: Wed, 9 Oct 2024 22:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728525837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQLc8O+ab0p95H3jJhE8eF6aq82ovQFxvMQYryqmvSY=;
	b=bA2yEOS9bmkh2ml8BexztiznNDsCJd0kgGNykZsrxz7I9U2g2Y7dHb+D9G1CeMOWV0GXGL
	a+wSnToBW/fuTjcnVNhk8Ju8GYacMYFrbHQhn2Ofopio6evpqJPOUza+cO6eDCckbgA1NX
	QFffIlSnOPoYtZwW30EABR8+a8uYceU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Zhao Mengmeng <zhaomzhao@126.com>
Cc: zhaomengmeng@kylinos.cn, lihongbo22@huawei.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] bcachefs: Fix shift-out-of-bounds in
 bch2_stripe_to_text
Message-ID: <jvqgq5ekxbeims7qolka5xewgwwsdo5okkxvjfkbyenr6rk2r3@qbrg2klzzutp>
References: <20241009140755.725629-1-zhaomzhao@126.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009140755.725629-1-zhaomzhao@126.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 10:07:55PM GMT, Zhao Mengmeng wrote:
> From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
> 
> syzbot report a shift-out-of-bounds issue:
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/ec.c:147:2
> shift exponent 108 is too large for 32-bit type 'unsigned int'
> ----
> Here s.csum_granularity_bits = 108, so shift is impossible for unsigned
> int. To fix, add a check in bch2_stripe_validate() to bail out, it has
> same checking logic with ec_stripe_key_init().
> 
> Reported-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
> Tested-by: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f8c98a50c323635be65d
> Suggested-by: Hongbo Li <lihongbo22@huawei.com>
> Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
> ---
>  fs/bcachefs/ec.c      | 6 ++++++
>  fs/bcachefs/errcode.h | 4 +++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
> index 564841e5a24b..f6a02123144d 100644
> --- a/fs/bcachefs/ec.c
> +++ b/fs/bcachefs/ec.c
> @@ -114,6 +114,12 @@ int bch2_stripe_validate(struct bch_fs *c, struct bkey_s_c k,
>  	const struct bch_stripe *s = bkey_s_c_to_stripe(k).v;
>  	int ret = 0;
>  
> +	if (s->csum_granularity_bits >= ilog2(le16_to_cpu(s->sectors))) {
> +		bch_err_ratelimited(c, "stripe csum gran bits %u too big",
> +				    s->csum_granularity_bits);
> +		return -BCH_ERR_stripe_csum_granularity_bits_too_big;
> +	}
> +

that should be a bkey_fsck_err_on(), and you'll add to the enum in
sb-errors_format.h

>  	bkey_fsck_err_on(bkey_eq(k.k->p, POS_MIN) ||
>  			 bpos_gt(k.k->p, POS(0, U32_MAX)),
>  			 c, stripe_pos_bad,
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index 26990ad584d5..83659cdb93c8 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -270,7 +270,9 @@
>  	x(BCH_ERR_nopromote,		nopromote_enomem)			\
>  	x(0,				invalid_snapshot_node)			\
>  	x(0,				option_needs_open_fs)			\
> -	x(0,				remove_disk_accounting_entry)
> +	x(0,				remove_disk_accounting_entry)		\
> +	x(EINVAL,			stripe_csum_granularity_bits_too_big)
> +
>  
>  enum bch_errcode {
>  	BCH_ERR_START		= 2048,
> -- 
> 2.43.0
> 
