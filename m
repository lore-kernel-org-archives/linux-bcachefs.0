Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1021C001DF
	for <linux-bcachefs@archiver.kernel.org>; Fri,  4 Aug 2023 16:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjHDQsn (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 4 Aug 2023 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjHDQsn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 4 Aug 2023 12:48:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8030C3C23
        for <linux-bcachefs@vger.kernel.org>; Fri,  4 Aug 2023 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691167672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xHt1Dl7mMm6yg9uUPC++VXLbZDRt3brUSF4T/MSoXJg=;
        b=EAv/MleuBIhZIse9JuH6lYo9JJsck/vfynuGImro76jDUNfrGe42XKKFZJp35Zmf8FV0H4
        epBEnNYAr8it9XRdAYXNDnH986hkAT7zUW3rfJlso3MIh5wSOnUR/MLHz+ZBjPpPK5CE8y
        piAncRJh/M1Oqs1eTMeDZCqQg8w70w8=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-igCdxg10NY266E6yLVPFgw-1; Fri, 04 Aug 2023 12:47:51 -0400
X-MC-Unique: igCdxg10NY266E6yLVPFgw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-79a068ccf5cso568655241.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 04 Aug 2023 09:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691167670; x=1691772470;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHt1Dl7mMm6yg9uUPC++VXLbZDRt3brUSF4T/MSoXJg=;
        b=FoNSiU6zib/C79YR4s8UuGwprDvnONkhcP4EkP1cgIL471pDDXyuwAXPm7CwHKUcl9
         +S8R8q73nLjLI/g/badyg46EnlxTuzYjKQwHwpWeQ3VEM7etLleV5NfsimUCcATkF/A5
         NaRby0L42X/qjbYLd8R3WL7G9lyG21Ln9gLkV5N2n9/oOdptZBxe7n7oFZUUqKWAlIZB
         xi7IQyVX8QiSIiV/rGchmB3hgt4F/wB16EL2WutNJZswX5h0yYAGb5ET9dm3jsROOtQe
         BKpgRP/IPmolcsTqX24fzcJmvDHniOQB0VcZd5ZmYZfv7vbZYzROI1CMqqU63cjSj6SR
         CokQ==
X-Gm-Message-State: AOJu0Yw/nwpAngFf41PFAqpv6c5OijZV5iiBQYP1CswPObKqHIhl02fX
        fkfLnyeY0zQc/93ptzdwyNgKlahBun0zQYjhXw8dzyZHW3y+q9xrukisVvzjbANeolsiH1wrGhl
        RdAdH79rx4ZhhcqNsV+P7+TY768viR9rn/Sw=
X-Received: by 2002:a05:6102:516:b0:443:91a7:766c with SMTP id l22-20020a056102051600b0044391a7766cmr1768376vsa.27.1691167670235;
        Fri, 04 Aug 2023 09:47:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt3wdq2/NFvf0oC75hn1lI+eNKxb/3u+FHh4rOb6aOJD1cjo0h+2reG63AcYHCTEferbbwEA==
X-Received: by 2002:a05:6102:516:b0:443:91a7:766c with SMTP id l22-20020a056102051600b0044391a7766cmr1768361vsa.27.1691167669986;
        Fri, 04 Aug 2023 09:47:49 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id f28-20020a0caa9c000000b006255bcfca88sm791787qvb.7.2023.08.04.09.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 09:47:49 -0700 (PDT)
Date:   Fri, 4 Aug 2023 12:50:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix lock thrashing in __bchfs_fallocate()
Message-ID: <ZM0sbddS+mKhYkNG@bfoster>
References: <20230803075018.3771018-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803075018.3771018-1-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Aug 03, 2023 at 03:50:18AM -0400, Kent Overstreet wrote:
> We've observed significant lock thrashing on fstests generic/083 in
> fallocate, due to dropping and retaking btree locks when checking the
> pagecache for data.
> 
> This adds a nonblocking mode to bch2_clamp_data_hole(), where we only
> use folio_trylock(), and can thus be used safely while btree locks are
> held - thus we only have to drop btree locks as a fallback, on actual
> lock contention.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/fs-io.c | 80 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 55 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> index dcaf7aad79..d433f4d566 100644
> --- a/fs/bcachefs/fs-io.c
> +++ b/fs/bcachefs/fs-io.c
> @@ -35,7 +35,7 @@
>  
>  #include <trace/events/writeback.h>
>  
> -static void bch2_clamp_data_hole(struct inode *, u64 *, u64 *, unsigned);
> +static int bch2_clamp_data_hole(struct inode *, u64 *, u64 *, unsigned, bool);
>  
>  struct folio_vec {
>  	struct folio	*fv_folio;
> @@ -3410,11 +3410,15 @@ static int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
>  		}
>  
>  		if (!(mode & FALLOC_FL_ZERO_RANGE)) {
> -			ret = drop_locks_do(&trans,
> -				(bch2_clamp_data_hole(&inode->v,
> -						      &hole_start,
> -						      &hole_end,
> -						      opts.data_replicas), 0));
> +			if (bch2_clamp_data_hole(&inode->v,
> +						 &hole_start,
> +						 &hole_end,
> +						 opts.data_replicas, true))
> +				ret = drop_locks_do(&trans,
> +					(bch2_clamp_data_hole(&inode->v,
> +							      &hole_start,
> +							      &hole_end,
> +							      opts.data_replicas, false), 0));

Nice. I recall that I had tried a quick experiment to just remove the
drop_locks_do() here and did end up producing a lockup, but I forget the
details. Aside from the general btree node locking principle you
mentioned in the previous thread, a brief comment on the hard lock
ordering rule here might be nice for future reference.

>  			bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, hole_start));
>  
>  			if (ret)
> @@ -3714,7 +3718,8 @@ static int folio_data_offset(struct folio *folio, loff_t pos,
>  static loff_t bch2_seek_pagecache_data(struct inode *vinode,
>  				       loff_t start_offset,
>  				       loff_t end_offset,
> -				       unsigned min_replicas)
> +				       unsigned min_replicas,
> +				       bool nonblock)
>  {
>  	struct folio_batch fbatch;
>  	pgoff_t start_index	= start_offset >> PAGE_SHIFT;
> @@ -3731,7 +3736,13 @@ static loff_t bch2_seek_pagecache_data(struct inode *vinode,
>  		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			folio_lock(folio);
> +			if (!nonblock) {
> +				folio_lock(folio);
> +			} else if (!folio_trylock(folio)) {
> +				folio_batch_release(&fbatch);
> +				return -EAGAIN;
> +			}
> +
>  			offset = folio_data_offset(folio,
>  					max(folio_pos(folio), start_offset),
>  					min_replicas);
> @@ -3796,7 +3807,7 @@ static loff_t bch2_seek_data(struct file *file, u64 offset)
>  
>  	if (next_data > offset)
>  		next_data = bch2_seek_pagecache_data(&inode->v,
> -						     offset, next_data, 0);
> +					offset, next_data, 0, false);
>  
>  	if (next_data >= isize)
>  		return -ENXIO;
> @@ -3804,18 +3815,24 @@ static loff_t bch2_seek_data(struct file *file, u64 offset)
>  	return vfs_setpos(file, next_data, MAX_LFS_FILESIZE);
>  }
>  
> -static bool folio_hole_offset(struct address_space *mapping, loff_t *offset,
> -			      unsigned min_replicas)
> +static int folio_hole_offset(struct address_space *mapping, loff_t *offset,
> +			      unsigned min_replicas, bool nonblock)
>  {
>  	struct folio *folio;
>  	struct bch_folio *s;
>  	unsigned i, sectors;
>  	bool ret = true;
>  
> -	folio = filemap_lock_folio(mapping, *offset >> PAGE_SHIFT);
> +	folio = __filemap_get_folio(mapping, *offset >> PAGE_SHIFT,
> +				    !nonblock ? FGP_LOCK : 0, 0);
>  	if (IS_ERR_OR_NULL(folio))
>  		return true;

Looks like a bit of return value wonkiness here.. the function now
returns int, but we return true here, ret is a bool, etc.

Also JFYI it looks like filemap has an FGP_NOWAIT flag that when paired
with FGP_LOCK avoids the need for the extra code here.

Those nits aside this looks pretty good to me. Thanks for fixing it.
I'll have to give it a test (once I'm back most likely, I'm away for a
couple or so more days after today).

Brian

>  
> +	if (nonblock && !folio_trylock(folio)) {
> +		folio_put(folio);
> +		return -EAGAIN;
> +	}
> +
>  	s = bch2_folio(folio);
>  	if (!s)
>  		goto unlock;
> @@ -3840,31 +3857,44 @@ static bool folio_hole_offset(struct address_space *mapping, loff_t *offset,
>  static loff_t bch2_seek_pagecache_hole(struct inode *vinode,
>  				       loff_t start_offset,
>  				       loff_t end_offset,
> -				       unsigned min_replicas)
> +				       unsigned min_replicas,
> +				       bool nonblock)
>  {
>  	struct address_space *mapping = vinode->i_mapping;
>  	loff_t offset = start_offset;
>  
>  	while (offset < end_offset &&
> -	       !folio_hole_offset(mapping, &offset, min_replicas))
> +	       !folio_hole_offset(mapping, &offset, min_replicas, nonblock))
>  		;
>  
>  	return min(offset, end_offset);
>  }
>  
> -static void bch2_clamp_data_hole(struct inode *inode,
> -				 u64 *hole_start,
> -				 u64 *hole_end,
> -				 unsigned min_replicas)
> +static int bch2_clamp_data_hole(struct inode *inode,
> +				u64 *hole_start,
> +				u64 *hole_end,
> +				unsigned min_replicas,
> +				bool nonblock)
>  {
> -	*hole_start = bch2_seek_pagecache_hole(inode,
> -		*hole_start << 9, *hole_end << 9, min_replicas) >> 9;
> +	loff_t ret;
> +
> +	ret = bch2_seek_pagecache_hole(inode,
> +		*hole_start << 9, *hole_end << 9, min_replicas, nonblock) >> 9;
> +	if (ret < 0)
> +		return ret;
> +
> +	*hole_start = ret;
>  
>  	if (*hole_start == *hole_end)
> -		return;
> +		return 0;
>  
> -	*hole_end = bch2_seek_pagecache_data(inode,
> -		*hole_start << 9, *hole_end << 9, min_replicas) >> 9;
> +	ret = bch2_seek_pagecache_data(inode,
> +		*hole_start << 9, *hole_end << 9, min_replicas, nonblock) >> 9;
> +	if (ret < 0)
> +		return ret;
> +
> +	*hole_end = ret;
> +	return 0;
>  }
>  
>  static loff_t bch2_seek_hole(struct file *file, u64 offset)
> @@ -3896,12 +3926,12 @@ static loff_t bch2_seek_hole(struct file *file, u64 offset)
>  			   BTREE_ITER_SLOTS, k, ret) {
>  		if (k.k->p.inode != inode->v.i_ino) {
>  			next_hole = bch2_seek_pagecache_hole(&inode->v,
> -					offset, MAX_LFS_FILESIZE, 0);
> +					offset, MAX_LFS_FILESIZE, 0, false);
>  			break;
>  		} else if (!bkey_extent_is_data(k.k)) {
>  			next_hole = bch2_seek_pagecache_hole(&inode->v,
>  					max(offset, bkey_start_offset(k.k) << 9),
> -					k.k->p.offset << 9, 0);
> +					k.k->p.offset << 9, 0, false);
>  
>  			if (next_hole < k.k->p.offset << 9)
>  				break;
> -- 
> 2.40.1
> 

