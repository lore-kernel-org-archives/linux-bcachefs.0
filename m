Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0811F1527
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 16:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754323852; cv=none; b=BKe99mmYQRBNIlfC26vm/TTc/8IvDfWAgytgl8CB6ELLGNuoQz0Oi12LvszunL8DdYXkQfE/aQ08eW9sA0F/NU4TGR8wXGWQNtjfs5SWAw4pcNAa6BHqOcKs47QrRXIGaOngw7LdB1amG5fZUIUNcDwHCXcJXHUJT5JsGchgitA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754323852; c=relaxed/simple;
	bh=zBXvSXUV43PXred6w12OLbaOpadIBuXQI/D8w08s5z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZx/PedVhkhwzTsiL2q9qd7m46xH5KmT9YE8k89j/oclgIDkCaTsEwyon3m4R0oYMa+p8Nc+aoUdzQNKpSNpHVJJ6stF/WlshZB6qGQbCydrA9VdwL9nGZ6RnwqBuJLVVberjcEEJHtGwhxYZQPDMww6R82+MfJUoO9fQy9rZgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pu2yTrqW; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pu2yTrqW"
Date: Mon, 4 Aug 2025 12:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754323848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9uGXvT12DuJ+a5s1CM+GVGEdSF0iplhRkVjGaiYabs=;
	b=pu2yTrqWqv++g8iSMDIkdlx/zvqIay05s1J0ItgMlodevuzGWXhWHrBwOw2E9hLuCT6Xw8
	KZ7NOzyRzkXQLeR+1BIVjxIsoumOiVKBIvfPAu0jYRzySWs51f8wiVHFOFNcyb9ux3wO5P
	3RRY9BYVyB+PL/8JrdcUsmda9GRyqgQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Add missing accounting key type validation
Message-ID: <nsan46g4mg57uqqi4jhl3nuncru2latgh4kanrwlqkuvjlae53@hbge4ci2yn2h>
References: <20250804160224.189956-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804160224.189956-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 05, 2025 at 12:02:24AM +0800, Alan Huang wrote:
> Reported-by: syzbot+cd063f869beedf5b9cd7@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/disk_accounting.c  | 5 +++++
>  fs/bcachefs/sb-errors_format.h | 3 ++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index f96530c70262..4f5b290dc8f1 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -184,6 +184,11 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
>  	void *end = &acc_k + 1;
>  	int ret = 0;
>  
> +	bkey_fsck_err_on(acc_k.type >= BCH_DISK_ACCOUNTING_TYPE_NR,
> +			 c, accounting_key_type_invalid,
> +			 "invalid accounting type (%u >= %u)",
> +			 acc_k.type, BCH_DISK_ACCOUNTING_TYPE_NR);
> +

No, this isn't a validate error - this breaks forwards compatibility.

Other code paths just need to silently ignore unknown accounting types.

>  	bkey_fsck_err_on((from.flags & BCH_VALIDATE_commit) &&
>  			 bversion_zero(k.k->bversion),
>  			 c, accounting_key_version_0,
> diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
> index 5317b1bfe2e5..5ba28a684f51 100644
> --- a/fs/bcachefs/sb-errors_format.h
> +++ b/fs/bcachefs/sb-errors_format.h
> @@ -328,6 +328,7 @@ enum bch_fsck_flags {
>  	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
>  	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
>  	x(accounting_key_nr_counters_wrong,			307,	FSCK_AUTOFIX)	\
> +	x(accounting_key_type_invalid,				325,	FSCK_AUTOFIX)	\
>  	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
>  	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
>  	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
> @@ -336,7 +337,7 @@ enum bch_fsck_flags {
>  	x(dirent_stray_data_after_cf_name,			305,	0)		\
>  	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
>  	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
> -	x(MAX,							325,	0)
> +	x(MAX,							326,	0)
>  
>  enum bch_sb_error_id {
>  #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
> -- 
> 2.49.0
> 
