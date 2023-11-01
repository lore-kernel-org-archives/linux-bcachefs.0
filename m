Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7051AC4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed,  1 Nov 2023 17:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjKARDC (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 13:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjKARDB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 13:03:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4707FD
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 10:02:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA23C433C7;
        Wed,  1 Nov 2023 17:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698858177;
        bh=c6Ba3o56njqd2+encFpg4dJezCru72eL+DgPCZbJy2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1MSPMYlv0pAcjyVjLrPYPewNqFsn4BKStOYTP895OqAmTvZrbcFyhHI7EWUiYXAp
         leW95MlRf9TLMzS4QPwDV9lUopEMJNkWLcQHrQgWpl/j17zovCW0wec1MojBzzlUM1
         cmFsUnq/LmXbtkxZaHs9oYz0eL/mGv186MwZHAnBtnMlD8OI6TrfjNgwqzv/7ccz9F
         kaOeoCXnu8DswsvBsiatx9R5cxh1RKrpJ8v4n0Li90slr3jd6VsRlRfoR46bIaMb34
         48qNC8G3UpZQGmE9+TPS+FN8MmApk/3+WQrvYMsk/7DRrtAGnYmgNTQ9cL8VwkyCoL
         IGE6Jk9ZJFBhQ==
Date:   Wed, 1 Nov 2023 10:02:55 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 6/6] bcachefs: rebalance_work
Message-ID: <20231101170255.GA1158461@dev-arch.thelio-3990X>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
 <20231024191414.2157874-7-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024191414.2157874-7-kent.overstreet@linux.dev>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi Kent,

On Tue, Oct 24, 2023 at 03:14:11PM -0400, Kent Overstreet wrote:
> This adds a new btree, rebalance_work, to eliminate scanning required
> for finding extents that need work done on them in the background - i.e.
> for the background_target and background_compression options.
> 
> rebalance_work is a bitset btree, where a KEY_TYPE_set corresponds to an
> extent in the extents or reflink btree at the same pos.
> 
> A new extent field is added, bch_extent_rebalance, which indicates that
> this extent has work that needs to be done in the background - and which
> options to use. This allows per-inode options to be propagated to
> indirect extents - at least in some circumstances. In this patch,
> changing IO options on a file will not propagate the new options to
> indirect extents pointed to by that file.
> 
> Updating (setting/clearing) the rebalance_work btree is done by the
> extent trigger, which looks at the bch_extent_rebalance field.
> 
> Scanning is still requrired after changing IO path options - either just
> for a given inode, or for the whole filesystem. We indicate that
> scanning is required by adding a KEY_TYPE_cookie key to the
> rebalance_work btree: the cookie counter is so that we can detect that
> scanning is still required when an option has been flipped mid-way
> through an existing scan.
> 
> Future possible work:
>  - Propagate options to indirect extents when being changed
>  - Add other IO path options - nr_replicas, ec, to rebalance_work so
>    they can be applied in the background when they change
>  - Add a counter, for bcachefs fs usage output, showing the pending
>    amount of rebalance work: we'll probably want to do this after the
>    disk space accounting rewrite (moving it to a new btree)
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

<snip>

> diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
> index 540c78cd4b0c..dbbdf1955f76 100644
> --- a/fs/bcachefs/reflink.c
> +++ b/fs/bcachefs/reflink.c
> @@ -7,6 +7,7 @@
>  #include "inode.h"
>  #include "io_misc.h"
>  #include "io_write.h"
> +#include "rebalance.h"
>  #include "reflink.h"
>  #include "subvolume.h"
>  #include "super-io.h"
> @@ -252,6 +253,7 @@ s64 bch2_remap_range(struct bch_fs *c,
>  	struct bpos dst_start = POS(dst_inum.inum, dst_offset);
>  	struct bpos src_start = POS(src_inum.inum, src_offset);
>  	struct bpos dst_end = dst_start, src_end = src_start;
> +	struct bch_io_opts opts;
>  	struct bpos src_want;
>  	u64 dst_done;
>  	u32 dst_snapshot, src_snapshot;
> @@ -269,6 +271,10 @@ s64 bch2_remap_range(struct bch_fs *c,
>  	bch2_bkey_buf_init(&new_src);
>  	trans = bch2_trans_get(c);
>  
> +	ret = bch2_inum_opts_get(trans, src_inum, &opts);
> +	if (ret)
> +		goto err;
> +

Not sure if this has been reported or fixed yet but this appears to
introduce a valid clang warning:

  fs/bcachefs/reflink.c:275:6: error: variable 'dst_done' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
    275 |         if (ret)
        |             ^~~
  fs/bcachefs/reflink.c:405:9: note: uninitialized use occurs here
    405 |         return dst_done ?: ret ?: ret2;
        |                ^~~~~~~~
  fs/bcachefs/reflink.c:275:2: note: remove the 'if' if its condition is always false
    275 |         if (ret)
        |         ^~~~~~~~
    276 |                 goto err;
        |                 ~~~~~~~~
  fs/bcachefs/reflink.c:258:14: note: initialize the variable 'dst_done' to silence this warning
    258 |         u64 dst_done;
        |                     ^
        |                      = 0
  1 error generated.

I tried to reason my way through a patch but I am a little lost, hence
just the report :)

>  	bch2_trans_iter_init(trans, &src_iter, BTREE_ID_extents, src_start,
>  			     BTREE_ITER_INTENT);
>  	bch2_trans_iter_init(trans, &dst_iter, BTREE_ID_extents, dst_start,
> @@ -352,10 +358,13 @@ s64 bch2_remap_range(struct bch_fs *c,
>  				min(src_k.k->p.offset - src_want.offset,
>  				    dst_end.offset - dst_iter.pos.offset));
>  
> -		ret = bch2_extent_update(trans, dst_inum, &dst_iter,
> -					 new_dst.k, &disk_res,
> -					 new_i_size, i_sectors_delta,
> -					 true);
> +		ret =   bch2_bkey_set_needs_rebalance(c, new_dst.k,
> +					opts.background_target,
> +					opts.background_compression) ?:
> +			bch2_extent_update(trans, dst_inum, &dst_iter,
> +					new_dst.k, &disk_res,
> +					new_i_size, i_sectors_delta,
> +					true);
>  		bch2_disk_reservation_put(c, &disk_res);
>  	}
>  	bch2_trans_iter_exit(trans, &dst_iter);
> @@ -386,7 +395,7 @@ s64 bch2_remap_range(struct bch_fs *c,
>  
>  		bch2_trans_iter_exit(trans, &inode_iter);
>  	} while (bch2_err_matches(ret2, BCH_ERR_transaction_restart));
> -
> +err:
>  	bch2_trans_put(trans);
>  	bch2_bkey_buf_exit(&new_src, c);
>  	bch2_bkey_buf_exit(&new_dst, c);

Cheers,
Nathan
