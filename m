Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D514264
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Dec 2023 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 54EBD140DED0F;
	Fri, 29 Dec 2023 12:44:39 -0800 (PST)
Date: Fri, 29 Dec 2023 12:44:39 -0800 (PST)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Message-ID: <513708765.544.1703882679194@mail.carlthompson.net>
In-Reply-To: <evltrlnkclj3g3yqm2nqyfz63tg53ojxs45uouq5e6nosxz37z@rxqrn6smqmuc>
References: <1804957404.243.1703798376220@mail.carlthompson.net>
 <evltrlnkclj3g3yqm2nqyfz63tg53ojxs45uouq5e6nosxz37z@rxqrn6smqmuc>
Subject: Re: bcachefs subvols / snapshots broken
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

I don't see anything recent on the -testing branch on GitHub so I applied the patch from your email and the other io_write.c patch directly to rc7.

So far it seems to work to fix this issue for me. I'll keep testing. Thanks for such a quick fix!

Thank you,
Carl Thompson


> On 2023-12-29 10:50 AM PST Kent Overstreet <kent.overstreet@linux.dev> wrote:
> ...
> Fix is in the -testing branch, will be making it to the appropriate
> places shortly:
> 
> commit 05b11fb627bcd71cc19e79cdeabfa1b514bf8acf
> Author: Kent Overstreet <kent.overstreet@linux.dev>
> Date:   Fri Dec 29 13:39:07 2023 -0500
> 
>     bcachefs: Fix extents iteration + snapshots interaction
>     
>     peek_upto() checks against the end position and bails out before
>     FILTER_SNAPSHOTS checks; this is because if we end up at a different
>     inode number than the original search key none of the keys we see might
>     be visibile in the current snapshot - we might be looking at inode in a
>     completely different subvolume.
>     
>     But this is broken, because when we're iterating over extents we're
>     checking against the extent start position to decide when to bail out,
>     and the extent start position isn't monotonically increasing until after
>     we've run FILTER_SNAPSHOTS.
>     
>     Fix this by adding a simple inode number check where the old bailout
>     check was, and moving the main check to the correct position.
>     
>     Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> 
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 732c8bb3f803..7e5c797cfaf2 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -2145,18 +2145,16 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
>  			goto out_no_locked;
>  
>  		/*
> -		 * iter->pos should be mononotically increasing, and always be
> -		 * equal to the key we just returned - except extents can
> -		 * straddle iter->pos:
> +		 * We need to check against @end before FILTER_SNAPSHOTS because
> +		 * if we get to a different inode that requested we might be
> +		 * seeing keys for a different snapshot tree that will all be
> +		 * filtered out.
> +		 *
> +		 * But we can't do the full check here, because bkey_start_pos()
> +		 * isn't monotonically increasing before FILTER_SNAPSHOTS, and
> +		 * that's what we check against in extents mode:
>  		 */
> -		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
> -			iter_pos = k.k->p;
> -		else
> -			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
> -
> -		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
> -			     ? bkey_gt(iter_pos, end)
> -			     : bkey_ge(iter_pos, end)))
> +		if (k.k->p.inode > end.inode)
>  			goto end;
>  
>  		if (iter->update_path &&
> @@ -2215,6 +2213,21 @@ struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos e
>  			continue;
>  		}
>  
> +		/*
> +		 * iter->pos should be mononotically increasing, and always be
> +		 * equal to the key we just returned - except extents can
> +		 * straddle iter->pos:
> +		 */
> +		if (!(iter->flags & BTREE_ITER_IS_EXTENTS))
> +			iter_pos = k.k->p;
> +		else
> +			iter_pos = bkey_max(iter->pos, bkey_start_pos(k.k));
> +
> +		if (unlikely(!(iter->flags & BTREE_ITER_IS_EXTENTS)
> +			     ? bkey_gt(iter_pos, end)
> +			     : bkey_ge(iter_pos, end)))
> +			goto end;
> +
>  		break;
>  	}
