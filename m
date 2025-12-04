Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6817E2EFDA6
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Dec 2025 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764875007; cv=none; b=RrbUUhnpuDhubkm3z1d5HrTDeDHQg9TF5MEXzXOjpOAbrTdYFKk7C5aad7MlSZOrcwesOUGbJE/acAoraCew25gBDFzrnSrKYEd6O2nGP0cjVFpZGqT84DTph35PYrVqPsslEtXCcHKxO4Wqqku+etO8MH8+CeAFQ+4OUjOak+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764875007; c=relaxed/simple;
	bh=Zt1VjS4/NFWZ0IDdwoLB+za+1Q21Wb6wfHd0YzZokTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfHsNoadD8CgIwQo/PRPyrXpY0UVMjcUyHSREi8BU9DOAW870gSk9n1wNNJL5qFl5VgeS7TN/Z0CIBAQoNIPOLLxR4te2MKNYcnwmpPBkUiPtQP2JcLl30ce6F1PvAz+4pInM2Yoxxq01aGTbJ/eoqgZEPyulHyWxvaNOioiHYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hh18ka5X; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hh18ka5X"
Date: Thu, 4 Dec 2025 14:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764875001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sQsED77vrnGba+s0q4MTPPWn4fnnyrdY3LNjg8qShgM=;
	b=Hh18ka5XMFSM3SWD91g96Fmq0P6ocpRP720QGxV/8bqIO/EDFcpTdUH0RKOoF+9T5ZXtML
	ejoUUU3Y8i5zSdd7O4shO0/CgzvMdKvUuUBKRTKEALOBVfsHN1+bQ37cQsj6kSOWC5dbET
	YhTMMdj/S8ZZczfQbq5Ke3Ea1kxQ5CQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org
Subject: Re: [PATCH] bcachefs: fix potential NULL deref in
 bch2_sb_members_v2_init
Message-ID: <epfc24ypenk5tnps6o53sjchdgup7ix4hg5aosege6orodavab@4diqwzz6v7wm>
References: <20251202172047.216045-1-mdmitrichenko@astralinux.ru>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202172047.216045-1-mdmitrichenko@astralinux.ru>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 02, 2025 at 08:20:46PM +0300, Mikhail Dmitrichenko wrote:
> bch2_sb_members_v2_init calls bch2_sb_field_resize to allocate the
> members_v2 superblock field, but does not check the returned pointer
> before dereferencing it. bch2_sb_field_resize may return NULL if
> superblock reallocation fails. In this case dereferencing mi2=NULL
> will cause crash during superblock upgrade from members_v1 to members_v2.
> 
> Add check for bch2_sb_field_resize call result for NULL.
> sb_members_v2_resize_entries function already has such check and returns
> error in this case. Make bch2_sb_members_v2_init() consistent and return
> the same error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 3f7b9713dae0 ("bcachefs: New superblock section members_v2")
> Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>

Thanks! Applied.

> ---
>  fs/bcachefs/sb/members.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/sb/members.c b/fs/bcachefs/sb/members.c
> index 8bf8f5ca3470..a610426b6013 100644
> --- a/fs/bcachefs/sb/members.c
> +++ b/fs/bcachefs/sb/members.c
> @@ -116,6 +116,9 @@ int bch2_sb_members_v2_init(struct bch_fs *c)
>  				DIV_ROUND_UP(sizeof(*mi2) +
>  					     sizeof(struct bch_member) * c->sb.nr_devices,
>  					     sizeof(u64)));
> +		if (!mi2)
> +			return bch_err_throw(c, ENOSPC_sb_members_v2);
> +
>  		mi1 = bch2_sb_field_get(c->disk_sb.sb, members_v1);
>  		memcpy(&mi2->_members[0], &mi1->_members[0],
>  		       BCH_MEMBER_V1_BYTES * c->sb.nr_devices);
> -- 
> 2.39.2
> 
