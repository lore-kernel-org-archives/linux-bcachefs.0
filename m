Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C28A168AE6
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Apr 2024 14:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713451469; cv=none; b=om/BzrGgFMqUseamLErq+Shs+a8q9WIXDajoakSq/g99dL9UBZ24/rHHZWYDCAR5/fP2KX/diAURdG4f9VcDfAnRgb9XuvEyJ1+J0pLPBiul75eRBGFmaCDtafgb3MBdswd7C6ZB5e16HAfruoZxxGljiM0KeCYhX16T3QyiJX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713451469; c=relaxed/simple;
	bh=Wtyj6XNyV+j0msmDhpfKwfjOsGcf+GyUL3oWRAs9gvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rgtil/Y/1O0ukKWss8XGsPinE8O3IiNrVaD5SxPKQ3iFPwdCvHj0RgPoDk9J4CITF+Tz4mCrYLToUQRRgvjzfMTo89yg23moWg1O0vcGlcQHRNR0nJXHXc+o7q9k+WQQe6tbn9qwBL58seihAPZSXC8bYaHF8258YUVWANKTrdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnIgW7c6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnIgW7c6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713451466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TUzHE7AzlGCXYHU1SlxNB9Z7IpMWdb6s7yf8TRxxL9k=;
	b=CnIgW7c6z2y20mZBOUz9nK3KTtGKPADIn/0UENumgQvCjt8aR7Yn3HNwpGGG43l2hZwhCH
	ftA/NIkT3c6YBSFSukCNMpLT79JpLgcKgn9A28O9wirJi3ABbWOOEB5zXYE9hogg67uuu7
	KFbFlU3jKTa55fNJih8uRPf4x1bvglM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-SYE2d7p3NguIfNVCdV1w5w-1; Thu, 18 Apr 2024 10:44:24 -0400
X-MC-Unique: SYE2d7p3NguIfNVCdV1w5w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 929F118065B2;
	Thu, 18 Apr 2024 14:44:24 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.10])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3A9CC2595D;
	Thu, 18 Apr 2024 14:44:23 +0000 (UTC)
Date: Thu, 18 Apr 2024 10:46:21 -0400
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH v3 4/4] bcachefs: add fiemap delalloc extent detection
Message-ID: <ZiEyPYV52CKVpOpS@bfoster>
References: <20240408144846.1001243-1-bfoster@redhat.com>
 <20240408144846.1001243-5-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408144846.1001243-5-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Mon, Apr 08, 2024 at 10:48:46AM -0400, Brian Foster wrote:
> bcachefs currently populates fiemap data from the extents btree.
> This works correctly when the fiemap sync flag is provided, but if
> not, it skips all delalloc extents that have not yet been flushed.
> This is because delalloc extents from buffered writes are first
> stored as reservation in the pagecache, and only become resident in
> the extents btree after writeback completes.
> 
> Update the fiemap implementation to process holes between extents by
> scanning pagecache for data, via seek data/hole. If a valid data
> range is found over a hole in the extent btree, fake up an extent
> key and flag the extent as delalloc for reporting to userspace.
> 
> Note that this does not necessarily change behavior for the case
> where there is dirty pagecache over already written extents, where
> when in COW mode, writeback will allocate new blocks for the
> underlying ranges. The existing behavior is consistent with btrfs
> and it is recommended to use the sync flag for the most up to date
> extent state from fiemap.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/bcachefs/fs.c | 87 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 79 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index 9f14eb256c09..77a8c826b637 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -993,6 +993,51 @@ static int bch2_fiemap_extent(struct btree_trans *trans,
>  	return 0;
>  }
>  
> +/*
> + * Scan a range of pagecache that corresponds to a file mapping hole in the
> + * extent btree. If found, fake up an extent key so it looks like a delalloc
> + * extent to the rest of the fiemap processing code.
> + *
> + * Returns 0 if cached data was found, -ENOENT if not, or -EAGAIN for folio
> + * trylock failure.
> + */
> +static int
> +bch2_fiemap_hole(struct inode *vinode, u64 start, u64 end,
> +		 struct bch_fiemap_extent *cur)
> +{
> +	struct bch_fs		*c = vinode->i_sb->s_fs_info;
> +	struct bch_inode_info	*ei = to_bch_ei(vinode);
> +	struct bkey_i_extent	*delextent;
> +	struct bch_extent_ptr	ptr = {};
> +	loff_t			dstart, dend;
> +
> +	/*
> +	 * We hold btree node locks here so we cannot block on folio locks.
> +	 * Propagate -EAGAIN errors so the caller can retry.
> +	 */
> +	dstart = bch2_seek_pagecache_data(vinode, start, end, 0, true);
> +	if (dstart < 0)
> +		return dstart;
> +	if (dstart >= end)
> +		return -ENOENT;
> +	dend = bch2_seek_pagecache_hole(vinode, dstart, end, 0, true);
> +
> +	/*
> +	 * Create a fake extent key in the buffer. We have to add a dummy extent
> +	 * pointer for the fill code to add an extent entry. It's explicitly
> +	 * zeroed to reflect delayed allocation (i.e. phys offset 0).
> +	 */
> +	bch2_bkey_buf_realloc(&cur->kbuf, c, sizeof(*delextent) / sizeof(u64));
> +	delextent = bkey_extent_init(cur->kbuf.k);
> +	delextent->k.p = POS(ei->v.i_ino, dstart >> 9);
> +	bch2_key_resize(&delextent->k, (dend - dstart) >> 9);
> +	bch2_bkey_append_ptr(&delextent->k_i, ptr);
> +
> +	cur->flags = FIEMAP_EXTENT_DELALLOC;
> +
> +	return 0;
> +}
> +
>  static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  		       u64 start, u64 len)
>  {
> @@ -1032,16 +1077,41 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  	while (!(ret = btree_trans_too_many_iters(trans)) &&
>  	       (k = bch2_btree_iter_peek_upto(&iter, end)).k &&
>  	       !(ret = bkey_err(k))) {
> +		bool have_delalloc = false;
>  
> -		if (!bkey_extent_is_data(k.k) &&
> -		    k.k->type != KEY_TYPE_reservation) {
> -			bch2_btree_iter_advance(&iter);
> -			continue;
> +		/*
> +		 * If a hole exists before the start of the extent key, scan the
> +		 * range for pagecache data that might be pending writeback and
> +		 * thus not yet exist in the extent tree. Note that this can
> +		 * return -EAGAIN to request to retry folio locks.
> +		 */
> +		if (iter.pos.offset > start) {
> +			ret = bch2_fiemap_hole(vinode, start << 9,
> +					       iter.pos.offset << 9, &cur);
> +			if (!ret)
> +				have_delalloc = true;
> +			else if (ret != -ENOENT)
> +				break;
>  		}

So Kent had pointed out in an earlier chat that this needs to be a
little more robust wrt to transaction restart because there is the
potential for spinning under folio lock contention. I think there are a
couple ways to do this that don't necessarily require reworking a bunch
more of this code. One is to simply run a serialization sequence where
we drop trans locks, run a blocking pagecache scan, and then restart
this particular iteration of the loop to account for the fact that the
extent btree may have changed since the btree locks were dropped.

When thinking about that, it occurred to me that this is roughly
equivalent to the TOCTOU nature of fiemap in general, where we may or
may not have caught a delalloc extent before or after it was written
back. Therefore, it seems reasonable to just do the lock cycle, grab the
range of folios covering what was previously identified as a hole
(before dropping locks), and then just report it as delalloc as we would
have had we not dropped locks at all. The code for that seems less
kludgy and follows the allocate_dropping_locks() pattern.

So this is the relevant bit of code I'm working with currently:

                /*
                 * If a hole exists before the start of the extent key, scan the
                 * range for pagecache data that might be pending writeback and
                 * thus not yet exist in the extent tree.
                 *
                 * Since we hold extent btree locks here, we must trylock the
                 * folios to avoid deadlocks with the write path. On trylock
                 * failure, redo the scan with blocking locks in proper lock
                 * order.
                 *
                 * Technically this means that the extent btree could have been
                 * updated from folio writeback, but this is a TOCTOU race and
                 * so we just report the delalloc extent based on the state of
                 * the iter prior to the unlock.
                 */
                if (iter.pos.offset > start) {
                        ret = bch2_fiemap_hole(vinode, start << 9,
                                               iter.pos.offset << 9, &cur, true);
                        if (ret == -EAGAIN) {
                                ret = drop_locks_do(trans,
                                        bch2_fiemap_hole(vinode, start << 9,
                                                         iter.pos.offset << 9,
                                                         &cur, false));
                        }
                        if (!ret)
                                have_delalloc = true;
                        else if (ret != -ENOENT)
                                break;
                }

Note that the last param to bch2_fiemap_hole() is the nonblock param
lifted up from bch2_seek_pagecache_[data|hole](). I also haven't done
anything with -EAGAIN because it originates from the latter and is more
isolated than it was previously (actually I'm thinking about pushing
trans and the whole drop locks sequence down into bch2_fiemap_hole() if
this otherwise seems reasonable). Thoughts?

Brian

>  
> -		ret = bch2_fiemap_extent(trans, &iter, k, &cur);
> -		if (ret)
> -			break;
> +		 /* process the current key if there's no delalloc to report */
> +		if (!have_delalloc) {
> +			if (!bkey_extent_is_data(k.k) &&
> +			    k.k->type != KEY_TYPE_reservation) {
> +				start = bkey_start_offset(k.k) + k.k->size;
> +				bch2_btree_iter_advance(&iter);
> +				continue;
> +			}
> +
> +			ret = bch2_fiemap_extent(trans, &iter, k, &cur);
> +			if (ret)
> +				break;
> +		}
> +
> +		/*
> +		 * Store the current extent in prev so we can flag the last
> +		 * extent on the way out.
> +		 */
>  		bch2_bkey_buf_realloc(&prev.kbuf, c, cur.kbuf.k->k.u64s);
>  		start = cur.kbuf.k->k.p.offset;
>  
> @@ -1061,7 +1131,8 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  	start = iter.pos.offset;
>  	bch2_trans_iter_exit(trans, &iter);
>  err:
> -	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
> +	if (ret == -EAGAIN ||
> +	    bch2_err_matches(ret, BCH_ERR_transaction_restart))
>  		goto retry;
>  
>  	if (!ret && have_extent) {
> -- 
> 2.44.0
> 
> 

