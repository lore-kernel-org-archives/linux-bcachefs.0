Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D879155742
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 18:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724611406; cv=none; b=EcWelihQdJ46knOkBp3lDcqKqCJp+douAWARKaoqP4x53ZzDNVLYIHfrZq1GEiYt9nvXiDxZOO5k5MsEIgglqGKzLuYb09uwPFPqbfMLbgFmr4oSlet/2rgJDjDgGvZAKQhOdlH7kbaIgsniuwWxjzT5iswoP7/by+cpNvKI9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724611406; c=relaxed/simple;
	bh=bD2/x+0opolo4shekMlLc3lwxnFeu+TOE1RPC+j2CMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sJnDa9RgMYynjJ67v76YfA2/cqkormcZ8Z1nGCievM5cMBNEi52tItW4kNT+HorRi7V/d4FVkXe8l02T39zh1odncTDstb0ufuIyPlFLugTLV5BYdbN/eKeLqLj0dC3HCEsnehsQSSo5XbIVSXRBBR/95HzpeZ6izv+p6qtu7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RRxZsR9Q; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RRxZsR9Q"
Date: Sun, 25 Aug 2024 14:43:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724611401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IWZF8cgdRpy8POz9dmk7qaJyxeNkE/0T2W0ZlBhFHv8=;
	b=RRxZsR9QT2uGHB23JCPzneeO4RdqKEiTOCwtZpk5NSV13+8XaKKEw+eJ8NEx76j2gGL+fL
	m5dniHb+DNF7cdJKqY2K/+TGXZVMGfWFanqPAdGdfS52TpdktDfVSL3PzWgZMA5S8/vTD7
	9sczD6Fi+en5RQLhJVTIF8l9ZaAgb8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: kees@kernel.org, gustavoars@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Annotate bch_replicas_entry_{v0,v1} with
 __counted_by()
Message-ID: <cqyrlfpjprkwdteljmtcnl3z2etzitvodrlv7v57tuizvklpcx@gg7dbstowwd6>
References: <20240825133601.24036-2-thorsten.blum@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825133601.24036-2-thorsten.blum@toblux.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 25, 2024 at 03:36:02PM GMT, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array members
> devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Increment nr_devs before adding a new device to the devs array and
> adjust the array indexes accordingly.

The nr_devs changes are pretty gross - please add a helper for that

> 
> In bch2_journal_read(), explicitly set nr_devs to 0.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
> ---
>  fs/bcachefs/buckets.c         | 3 ++-
>  fs/bcachefs/journal_io.c      | 3 ++-
>  fs/bcachefs/replicas.c        | 6 +++---
>  fs/bcachefs/replicas_format.h | 4 ++--
>  4 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
> index be2bbd248631..1e6badf9ddd2 100644
> --- a/fs/bcachefs/buckets.c
> +++ b/fs/bcachefs/buckets.c
> @@ -740,7 +740,8 @@ static int __trigger_extent(struct btree_trans *trans,
>  				return ret;
>  		} else if (!p.has_ec) {
>  			replicas_sectors       += disk_sectors;
> -			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs++] = p.ptr.dev;
> +			acc_replicas_key.replicas.nr_devs++;
> +			acc_replicas_key.replicas.devs[acc_replicas_key.replicas.nr_devs - 1] = p.ptr.dev;
>  		} else {
>  			ret = bch2_trigger_stripe_ptr(trans, k, p, data_type, disk_sectors, flags);
>  			if (ret)
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index 7664b68e6a15..d1bd883c2c55 100644
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
> +			replicas.e.devs[++replicas.e.nr_devs - 1] = ptr->dev;
>  
>  		bch2_replicas_entry_sort(&replicas.e);
>  
> diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
> index 1223b710755d..90d9b7d761bc 100644
> --- a/fs/bcachefs/replicas.c
> +++ b/fs/bcachefs/replicas.c
> @@ -122,7 +122,7 @@ static void extent_to_replicas(struct bkey_s_c k,
>  			continue;
>  
>  		if (!p.has_ec)
> -			r->devs[r->nr_devs++] = p.ptr.dev;
> +			r->devs[++r->nr_devs - 1] = p.ptr.dev;
>  		else
>  			r->nr_required = 0;
>  	}
> @@ -139,7 +139,7 @@ static void stripe_to_replicas(struct bkey_s_c k,
>  	for (ptr = s.v->ptrs;
>  	     ptr < s.v->ptrs + s.v->nr_blocks;
>  	     ptr++)
> -		r->devs[r->nr_devs++] = ptr->dev;
> +		r->devs[++r->nr_devs - 1] = ptr->dev;
>  }
>  
>  void bch2_bkey_to_replicas(struct bch_replicas_entry_v1 *e,
> @@ -180,7 +180,7 @@ void bch2_devlist_to_replicas(struct bch_replicas_entry_v1 *e,
>  	e->nr_required	= 1;
>  
>  	darray_for_each(devs, i)
> -		e->devs[e->nr_devs++] = *i;
> +		e->devs[++e->nr_devs - 1] = *i;
>  
>  	bch2_replicas_entry_sort(e);
>  }
> diff --git a/fs/bcachefs/replicas_format.h b/fs/bcachefs/replicas_format.h
> index b97208195d06..d2e080d0ecb7 100644
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
> -- 
> 2.46.0
> 
