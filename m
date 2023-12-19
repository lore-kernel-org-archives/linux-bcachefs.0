Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386940BE1
	for <linux-bcachefs@vger.kernel.org>; Tue, 19 Dec 2023 23:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RSI789r5"
Date: Tue, 19 Dec 2023 18:57:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703030265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mCTTUqTaKDXD0uwsO1dvq2yh4lo4A3LSH4bu2X8ZvJo=;
	b=RSI789r5lTq35QDMc6zdhYw2wV5RIsbrNNnduJpcTVkUJmangP7AZ+2IVoZTr4ogdo0pTb
	pcTd6ycsqnn6wdFjgjrC/CB5cO5uVWtZmVLfqmeayJ26zJe8OZA8M2zhF4CXwJ1wqV0oN8
	pw9c8XJ1sjx0e1WEEb08uvIujDvPn9s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: add fiemap delalloc extent detection
Message-ID: <20231219235742.fmon4qqvbabuxq6c@moria.home.lan>
References: <20231219140215.300753-1-bfoster@redhat.com>
 <20231219140215.300753-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219140215.300753-2-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 19, 2023 at 09:02:14AM -0500, Brian Foster wrote:
> bcachefs currently populates fiemap data from the extents btree.
> This works correctly when the fiemap sync flag is provided, but if
> not, it skips all delalloc extents that have not yet been flushed.
> This is because delalloc extents from buffered writes are first
> stored as reservation in the pagecache, and only become resident in
> the extents btree after writeback completes.
> 
> Update the fiemap implementation to scan the pagecache for data for
> file ranges that are not present in the extents btree. This uses the
> preexisting seek data/hole mechanism to identify data ranges, and
> then formats them as delayed allocation extents in the fiemap info.
> This is done by faking up an extent key and passing that along to
> the fiemap fill handler. We also tweak bch2_fiemap() to save fiemap
> flags for the previous key in order to track that it is delalloc.
> 
> One caveat worth noting with respect to fiemap and COW is that
> extent btree data is reported even when dirty pagecache exists over
> the associated range of the file. This means the range is
> reallocated on the next writeback and thus fiemap data is
> technically out of date. This is not necessarily a serious issue
> given fiemap is racy by definition, the final location of the
> unflushed data is unknown, and the caller should probably use the
> sync flag for most up to date information. FWIW, btrfs exhibits this
> same behavior wrt to dirty pagecache over COW extents as well, so
> this patch brings bcachefs to functional parity with btrfs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/bcachefs/fs.c | 60 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index bc280a0a957d..0b3b35092818 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -868,6 +868,41 @@ static int bch2_fill_extent(struct bch_fs *c,
>  	}
>  }
>  
> +/*
> + * Scan a gap in the extent btree for delayed allocation in pagecache. If found,
> + * fake up an extent key so it looks like an extent to the rest of the fiemap
> + * processing code.
> + */
> +static bool
> +bch2_fiemap_scan_pagecache(struct inode		*vinode,
> +			   u64			start,
> +			   u64			end,
> +			   struct bkey_buf	*cur)
> +{
> +	struct bch_fs		*c = vinode->i_sb->s_fs_info;
> +	struct bch_inode_info	*ei = to_bch_ei(vinode);
> +	struct bkey_i_extent	*delextent;
> +	struct bch_extent_ptr	ptr = {};

funny, for some reason I always thought I had to initialize at least one
member to 0 to do this - I'll remember that

> +
> +	start = bch2_seek_pagecache_data(vinode, start, end, 0, false);
> +	if (start >= end)
> +		return false;
> +	end = bch2_seek_pagecache_hole(vinode, start, end, 0, false);
> +
> +	/*
> +	 * Create a fake extent key in the buffer. We have to add a dummy extent
> +	 * pointer for the fill code to add an extent entry. It's explicitly
> +	 * zeroed to reflect delayed allocation (i.e. phys offset 0).
> +	 */
> +	bch2_bkey_buf_realloc(cur, c, sizeof(*delextent) / sizeof(u64));
> +	delextent = bkey_extent_init(cur->k);
> +	delextent->k.p = POS(ei->v.i_ino, start >> 9);
> +	bch2_key_resize(&delextent->k, (end - start) >> 9);
> +	bch2_bkey_append_ptr(&delextent->k_i, ptr);
> +
> +	return true;
> +}

I don't like that this returns a delalloc extent when data is merely
present in the pagecache - that's wrong.

bch2_seek_pagecache_dirty_data()?

> +
>  static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  		       u64 start, u64 len)
>  {
> @@ -879,6 +914,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  	struct bkey_buf cur, prev;
>  	struct bpos end = POS(ei->v.i_ino, (start + len) >> 9);
>  	unsigned offset_into_extent, sectors;
> +	unsigned cflags, pflags;

Now that we're not compiling in gnu89 mode anymore, I'm moving code away
from this "declare all variables at the top" style - I want variables
declared where they're initialized.

The reason is that bugs of the "I accidently used a var before I
initialized it" are really common, and the compiler does a crap job of
catching them.

Anywhere where we can write our code in a more functional style (in the
SSA sense, variables are declared where they are initialized and never
mutated) without it affecting the quality of the output is a big win.

(across function calls, we can't generally do this because C doesn't
have return value optimization).


>  	bool have_extent = false;
>  	u32 snapshot;
>  	int ret = 0;
> @@ -916,6 +952,19 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  			continue;
>  		}
>  
> +		/*
> +		 * Outstanding buffered writes aren't tracked in the extent
> +		 * btree until dirty folios are written back. Check holes in the
> +		 * extent tree for data in pagecache and report it as delalloc.
> +		 */
> +		if (iter.pos.offset > start &&
> +		    bch2_fiemap_scan_pagecache(vinode, start << 9,
> +					       iter.pos.offset << 9, &cur)) {
> +			cflags = FIEMAP_EXTENT_DELALLOC;

but cflags/plags are unnecessary, no? can't we just detected this in
bch2_fill_extent when the ptr offset is 0?

> +			start = bkey_start_offset(&cur.k->k) + cur.k->k.size;
> +			goto fill;
> +		}

The goto fill is also a code smell.

The right way to do it would be to search, from the same position, both
the btree and the pagecache: then compare those two extents, using
delalloc extent if it comes first, and trimming the btree extent if it
comes first but the delalloc extent overlaps.

Then there's no goto fill; after we've decided which extent to use the
rest of the loop is unchanged.

(The btree iterator code works roughly this way, where it has to overlay
keys from the journal and pending updates).

I would also think about changing this code to use two iterators, since
bch2_btree_iter_peek() will advance the iterator to the key it returns,
and we do not want to advance it yet if we found a delalloc extent at a
prior position - we'd clone the iterator, and peek that.

Right now the code is effectively using start as the first iterator,
which makes sense given that it probably is cleaner to just reinit the
iterator on transaction restart (since snapshot ID may have changed). So
maybe that shouldn't change, just something to consider. Since we're
using set_pos(.., start) at the end of the loop instead of advance -
it's probably fine.

> +
>  		offset_into_extent	= iter.pos.offset -
>  			bkey_start_offset(k.k);
>  		sectors			= k.k->size - offset_into_extent;
> @@ -940,19 +989,22 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  		cur.k->k.p = iter.pos;
>  		cur.k->k.p.offset += cur.k->k.size;
>  
> +		cflags = 0;
> +		start = iter.pos.offset + sectors;
> +fill:
>  		if (have_extent) {
>  			bch2_trans_unlock(trans);
>  			ret = bch2_fill_extent(c, info,
> -					bkey_i_to_s_c(prev.k), 0);
> +					bkey_i_to_s_c(prev.k), pflags);
>  			if (ret)
>  				break;
>  		}
>  
>  		bkey_copy(prev.k, cur.k);
> +		pflags = cflags;
>  		have_extent = true;
>  
> -		bch2_btree_iter_set_pos(&iter,
> -			POS(iter.pos.inode, iter.pos.offset + sectors));
> +		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
>  	}
>  	start = iter.pos.offset;
>  	bch2_trans_iter_exit(trans, &iter);
> @@ -963,7 +1015,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
>  	if (!ret && have_extent) {
>  		bch2_trans_unlock(trans);
>  		ret = bch2_fill_extent(c, info, bkey_i_to_s_c(prev.k),
> -				       FIEMAP_EXTENT_LAST);
> +				       pflags|FIEMAP_EXTENT_LAST);
>  	}
>  
>  	bch2_trans_put(trans);
> -- 
> 2.42.0
> 
