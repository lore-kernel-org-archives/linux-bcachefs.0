Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F353A129A83
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Mar 2024 04:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711426662; cv=none; b=J3YeeGcbExxFQWiF3Isu+gQJpTMyzCkZJ0kk34IWmZV5t6Y1dPGtiCj5KCivSeVM+yOCKa1qYjhp4YwL9lebFyDK/nfHL+21OhIz4llyonGZatTQLnt8ZNWpAtowwz9yXmUM1/VxDJXOGxZsdc8e8wFjERUtdLyWTikOvSdvtdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711426662; c=relaxed/simple;
	bh=Q5K3PK1pHzQsED0lwSfOVy7qCSiUnMX5oxfQe8FFHtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnYES4eWZNoYS1iuYT+jEgflDAFBSvSGNE5pwSUxDWQ/4XVs/2I2EtT+oGGGnp/BwXjmcPI16c8LWGUVH4NfDWtBc2M5KyZZmcORWrlWG+ywJX8i+ElnSsvRe7pnLilbflw866EN5fgIUmNsgJDToGIqoAwoAPN1Tm+veWiSsk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MBE7H/km; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MBE7H/km"
Date: Tue, 26 Mar 2024 00:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711426658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BTCKQYBj5dnBTiwed3M1vE2z1rHGWsDtVKYaTff8mAQ=;
	b=MBE7H/kmUd1YWY1+K57p9GJoYae2+2ywi85FawtvQzK3ajrPuiAZcREFJRXD6B4qlq778r
	6ZQndGxCFYnAEG4HaaHhCw4Gy6d5T5X8xOsZ9ml5LmfP4KskOEIdJoW6ONlMHhvs+SWMS+
	1tqWEGfDnJ8g9GfKhIE1FvLccnnZ/0A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix the count of nr_freed_pcpu after changing
 bc->freed_nonpcpu list
Message-ID: <663jlo5maeoh5dctbepsrnzbk7p5fwjfqaeshhb43ujcnjccdw@22vssecpk7jx>
References: <20240326040456.2587357-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326040456.2587357-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 26, 2024 at 12:04:56PM +0800, Hongbo Li wrote:
> When allocating bkey_cached from bc->freed_pcpu list, it missed
> decreasing the count of nr_freed_pcpu which would cause the mismatch
> between the value of nr_freed_pcpu and the list items. This problem
> also exists in moving new bkey_cached to bc->freed_pcpu list.
> If these happened, the bug info may appear in
> bch2_fs_btree_key_cache_exit by the follow code:
> 
>    BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
>    BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);

Please include the assertions too :)

> Fixes: c65c13f0eac6 ("bcachefs: Run btree key cache shrinker less aggressively")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/btree_key_cache.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 581edcb0911b..e1031b9ba3f4 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -169,6 +169,7 @@ static void bkey_cached_move_to_freelist(struct btree_key_cache *bc,
>  	} else {
>  		mutex_lock(&bc->lock);
>  		list_move_tail(&ck->list, &bc->freed_pcpu);
> +		bc->nr_freed_pcpu++;
>  		mutex_unlock(&bc->lock);
>  	}
>  }
> @@ -245,6 +246,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path,
>  		if (!list_empty(&bc->freed_pcpu)) {
>  			ck = list_last_entry(&bc->freed_pcpu, struct bkey_cached, list);
>  			list_del_init(&ck->list);
> +			bc->nr_freed_pcpu--;
>  		}
>  		mutex_unlock(&bc->lock);
>  	}
> -- 
> 2.34.1
> 
