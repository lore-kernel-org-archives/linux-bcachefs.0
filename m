Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088B17BB6
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 01:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745977260; cv=none; b=ZogOeB95vEENfpGDWV6QQHgDvX4atCVS4pma4Ep4LmLSIi7IraYnQo9eqMsZVuOIELu5jcWjILb5IFnw40/BcaiQAm0WE5P6GQf6x6HMUmlf72tSBSDvjS/xsYZR10dbb44JaHoN1jppwePluwfNftn7OFYR/RYuE5UPGYh0eRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745977260; c=relaxed/simple;
	bh=I/yJ7As0yS1EXOecG8a0jm7a78WycbJrEvPmfpjrgr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilyROCiHR9syVs/SQ7qqOaH/NhEEJCdYwyH6K3N2/OVhoNMyl2VwXiXf2QXiWxSsmNpurqBb3OrDRl1koca5F+kXTFzKrboe9Q8L+Osr6VUhdiCDvtQ2zWkQJDubsadII5LrYOSjWx9w9LqZAgh7lUrySarhbjsj3SRfFcElhLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wje3AQ/4; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wje3AQ/4"
Date: Tue, 29 Apr 2025 21:40:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745977244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT0Ns1yTHTF77wV9yl7kVMKkGAxsBIOUmKBLMn8Q2aE=;
	b=wje3AQ/4vSNKD28SkGTGB8GkvLgCw9VgA72a5dH3TbuQQGmcjxWesrFxvK/QgfQ/fuNRtJ
	e98kgdohaF0upK0OTuzHmDIJ6zAsmiBGPLvcwCf7ZjAe+EstfSoYRAlgHMps8I2YS81pT8
	mRxzYoNX2XuiacEtHsF8fFxgx0QQCLA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <wxh5qw7hzvvyg4texozjbviicfe2xmbjxngwlc3a7xef6jm6kn@wi3f25t2fftd>
References: <aBF5udHEHwWvmWJw@kspp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBF5udHEHwWvmWJw@kspp>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 29, 2025 at 07:15:37PM -0600, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the `DEFINE_FLEX()` helper for on-stack definitions of a flexible
> structure where the size of the flexible-array member is known at
> compile-time, and refactor the rest of the code, accordingly.
> 
> So, with these changes, fix the following warning:
> 
> fs/bcachefs/disk_accounting.c:429:51: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

We also have bch_replicas_padded, does that also need a fix?

And, DEFINE_FLEX() is gross, can we try to stop reinventing language
syntax with macros?

Could we not have done this with an __attribute__(())?

Or just swap the anonymous struct for a union, since that's apparently
what DEFINE_FLEX() does?

> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  fs/bcachefs/disk_accounting.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index 7be71952425c..381e666679d2 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -425,24 +425,22 @@ int bch2_fs_replicas_usage_read(struct bch_fs *c, darray_char *usage)
>  
>  	percpu_down_read(&c->mark_lock);
>  	darray_for_each(acc->k, i) {
> -		struct {
> -			struct bch_replicas_usage r;
> -			u8 pad[BCH_BKEY_PTRS_MAX];
> -		} u;
> +		DEFINE_FLEX(struct bch_replicas_usage, u, r.devs, r.nr_devs,
> +			    BCH_BKEY_PTRS_MAX);
>  
> -		if (!accounting_to_replicas(&u.r.r, i->pos))
> +		if (!accounting_to_replicas(&u->r, i->pos))
>  			continue;
>  
>  		u64 sectors;
>  		bch2_accounting_mem_read_counters(acc, i - acc->k.data, &sectors, 1, false);
> -		u.r.sectors = sectors;
> +		u->sectors = sectors;
>  
> -		ret = darray_make_room(usage, replicas_usage_bytes(&u.r));
> +		ret = darray_make_room(usage, replicas_usage_bytes(u));
>  		if (ret)
>  			break;
>  
> -		memcpy(&darray_top(*usage), &u.r, replicas_usage_bytes(&u.r));
> -		usage->nr += replicas_usage_bytes(&u.r);
> +		memcpy(&darray_top(*usage), u, replicas_usage_bytes(u));
> +		usage->nr += replicas_usage_bytes(u);
>  	}
>  	percpu_up_read(&c->mark_lock);
>  
> -- 
> 2.43.0
> 
