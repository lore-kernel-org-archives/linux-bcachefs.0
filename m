Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438AA198E6C
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 17:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724692324; cv=none; b=MB+zpAxjHL2jOCH5WA/cdrYAfPIaHtsVV3AeFqVzLs59Lw1ChzsWBKQPLQAsDhKkXQChjEZG2RYLOia4yIy3SGO5yaVwCGwl8/CPjTZqrAk3PpgoNYQPJsiTW9GJLOV43GTJnTILm1V64DZdeyVHpyOtNgSek9D+DhWjq3rV7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724692324; c=relaxed/simple;
	bh=tlHm13fgtMH8ly1SsTRgtIahTsWSmWRhdvxw3HaNPVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYKqnte0SFHKRB3F4DazNF/cK6DEagRVdRWxD6ILdw5vOoiuFSN7OUA/SImiWF05LJ7FiW3jRVsmX3mMA/RrIU1nevNi0jnXrs38S5trHA9AkaMq+QTkUTm/Wo4/6phvOVYw/2POt5h5nMoQbQ5ND+JEyCSpNlPKK8mBn7d1to8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MKdWwRY2; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MKdWwRY2"
Date: Mon, 26 Aug 2024 13:11:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724692319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vc3eD739P9v0p0HMmCHQneJWpFHCNMD2wlv0iI6W7R8=;
	b=MKdWwRY26aViDAXinmokETST9r/D0vANUfTI8c3HK/PumRcvtpZJUSqLJjJMPjXJ35I6J+
	DRFUuNtZw0NI6wGdZIV6iLuxMaLVxMIIfXnyW3fzcgbuUIIxAbjiLU5V+igdnParCmseik
	iaoEudgUPp4VbOTG84qR20ho4x3JGg8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kees@kernel.org, gustavoars@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Annotate bch_replicas_entry_{v0,v1} with
 __counted_by()
Message-ID: <rhiuwwxo3yfr6gpltzqraenammvpfzohdjavhacng6bxec62cj@sklevlpi5mto>
References: <20240826101135.31482-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826101135.31482-2-thorsten.blum@toblux.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 26, 2024 at 12:11:36PM GMT, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array members
> devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Increment nr_devs before adding a new device to the devs array and
> adjust the array indexes accordingly. Add a helper macro for adding a
> new device.
> 
> In bch2_journal_read(), explicitly set nr_devs to 0.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>

Applied

> ---
>  fs/bcachefs/buckets.c         | 2 +-
>  fs/bcachefs/journal_io.c      | 3 ++-
>  fs/bcachefs/replicas.c        | 6 +++---
>  fs/bcachefs/replicas_format.h | 9 +++++++--
>  4 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
> index be2bbd248631..eda397c562f5 100644
> --- a/fs/bcachefs/buckets.c
> +++ b/fs/bcachefs/buckets.c
> @@ -740,7 +740,7 @@ static int __trigger_extent(struct btree_trans *trans,
>  				return ret;
>  		} else if (!p.has_ec) {
>  			replicas_sectors       += disk_sectors;
> -			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs++] = p.ptr.dev;
> +			replicas_entry_add_dev(&acc_replicas_key.replicas, p.ptr.dev);
>  		} else {
>  			ret = bch2_trigger_stripe_ptr(trans, k, p, data_type, disk_sectors, flags);
>  			if (ret)
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index 32b886feb2ca..30460bce04be 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1353,6 +1353,7 @@ int bch2_journal_read(struct bch_fs *c,
>  	genradix_for_each(&c->journal_entries, radix_iter, _i) {
>  		struct bch_replicas_padded replicas = {
>  			.e.data_type = BCH_DATA_journal,
> +			.e.nr_devs = 0,
>  			.e.nr_required = 1,
>  		};
>  
> @@ -1379,7 +1380,7 @@ int bch2_journal_read(struct bch_fs *c,
>  			goto err;
>  
>  		darray_for_each(i->ptrs, ptr)
> -			replicas.e.devs[replicas.e.nr_devs++] = ptr->dev;
> +			replicas_entry_add_dev(&replicas.e, ptr->dev);
>  
>  		bch2_replicas_entry_sort(&replicas.e);
>  
> diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
> index 12b1d28b7eb4..e0880cb79345 100644
> --- a/fs/bcachefs/replicas.c
> +++ b/fs/bcachefs/replicas.c
> @@ -122,7 +122,7 @@ static void extent_to_replicas(struct bkey_s_c k,
>  			continue;
>  
>  		if (!p.has_ec)
> -			r->devs[r->nr_devs++] = p.ptr.dev;
> +			replicas_entry_add_dev(r, p.ptr.dev);
>  		else
>  			r->nr_required = 0;
>  	}
> @@ -139,7 +139,7 @@ static void stripe_to_replicas(struct bkey_s_c k,
>  	for (ptr = s.v->ptrs;
>  	     ptr < s.v->ptrs + s.v->nr_blocks;
>  	     ptr++)
> -		r->devs[r->nr_devs++] = ptr->dev;
> +		replicas_entry_add_dev(r, ptr->dev);
>  }
>  
>  void bch2_bkey_to_replicas(struct bch_replicas_entry_v1 *e,
> @@ -180,7 +180,7 @@ void bch2_devlist_to_replicas(struct bch_replicas_entry_v1 *e,
>  	e->nr_required	= 1;
>  
>  	darray_for_each(devs, i)
> -		e->devs[e->nr_devs++] = *i;
> +		replicas_entry_add_dev(e, *i);
>  
>  	bch2_replicas_entry_sort(e);
>  }
> diff --git a/fs/bcachefs/replicas_format.h b/fs/bcachefs/replicas_format.h
> index b97208195d06..b7eff904acdb 100644
> --- a/fs/bcachefs/replicas_format.h
> +++ b/fs/bcachefs/replicas_format.h
> @@ -5,7 +5,7 @@
>  struct bch_replicas_entry_v0 {
>  	__u8			data_type;
>  	__u8			nr_devs;
> -	__u8			devs[];
> +	__u8			devs[] __counted_by(nr_devs);
>  } __packed;
>  
>  struct bch_sb_field_replicas_v0 {
> @@ -17,7 +17,7 @@ struct bch_replicas_entry_v1 {
>  	__u8			data_type;
>  	__u8			nr_devs;
>  	__u8			nr_required;
> -	__u8			devs[];
> +	__u8			devs[] __counted_by(nr_devs);
>  } __packed;
>  
>  struct bch_sb_field_replicas {
> @@ -28,4 +28,9 @@ struct bch_sb_field_replicas {
>  #define replicas_entry_bytes(_i)					\
>  	(offsetof(typeof(*(_i)), devs) + (_i)->nr_devs)
>  
> +#define replicas_entry_add_dev(e, d) ({					\
> +	(e)->nr_devs++;							\
> +	(e)->devs[(e)->nr_devs - 1] = (d);				\
> +})
> +
>  #endif /* _BCACHEFS_REPLICAS_FORMAT_H */
> -- 
> 2.46.0
> 
