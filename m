Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13BC433CA
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295689; cv=none; b=nYx42dDDGTQBozSWHng0BP0I7dYnrVuU04QVfE6KWPPAEW5l7uPSZcB0M6fPbmXWV3DG+1HfWaqN12ym7AFfpdkZafepYzrpGtBt2/B0cddh+j66cxC1ESCsKssT9FNInkYxpuUZ68YmB1lBIpgqmCUNe3fXVljW3OYeiKPPOsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295689; c=relaxed/simple;
	bh=yoDJJnZ+Xn/jAXpqLOY6g3dJGpq1zThA1sAqh5zgo30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nR5KAI2IfzIZdAeaY/PD+1qYo+OtSrn1yx6cNC4lB9uFmPUe0HLLEwL50/Ff5QQdcrSzhL0uoQTDr86StaUvxx4/ZN71P4S2s3wE6NPy4+wUr+Xl3BnX4w7t3sdFQg9NT37hpheDqkeOsYv3aAQzOmNU9cJRkgx8DdhnYQ8bIlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HFD74vOx; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HFD74vOx"
Date: Wed, 21 Aug 2024 23:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724295682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jiueZ9s/AO2OHEiYoojw4fXRPY2DnVwlCYFnpOkvQDk=;
	b=HFD74vOxRiQFxLcOi1rCgMnkD8/MFrkHSuAf+qGOk0jQfxrdEHXQWzgbB5zjXl7ot9Sf1j
	+6EwPqRvVGU0FYClmw+FrCOHhpbVQpSu7LFfgQvpNzB3fnEKJO6SulzvJHxygC2WKIHaJ2
	ZePm8up+7V5QHGdRei0Gf6lXqbMzYuM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Chen Yufan <chenyufan@vivo.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	opensource.kernel@vivo.com
Subject: Re: [PATCH v1] bcachefs: Convert to use jiffies macros
Message-ID: <vthxausjk2h5dujrtef7odyxpl35l5bgak7ce5sbtietsh43ib@3njnr6xcfdtt>
References: <20240822025731.5651-1-chenyufan@vivo.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822025731.5651-1-chenyufan@vivo.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 22, 2024 at 10:57:31AM GMT, Chen Yufan wrote:
> Use jiffies macros instead of using jiffies directly to handle wraparound.
> 
> Signed-off-by: Chen Yufan <chenyufan@vivo.com>

Applied

> ---
>  fs/bcachefs/alloc_background.c | 3 ++-
>  fs/bcachefs/journal_io.c       | 3 ++-
>  fs/bcachefs/thread_with_file.c | 2 +-
>  3 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index ac933142a..795539556 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -30,6 +30,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/sched/task.h>
>  #include <linux/sort.h>
> +#include <linux/jiffies.h>
>  
>  static void bch2_discard_one_bucket_fast(struct bch_dev *, u64);
>  
> @@ -2181,7 +2182,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
>  	 * freespace/need_discard/need_gc_gens btrees as needed:
>  	 */
>  	while (1) {
> -		if (last_updated + HZ * 10 < jiffies) {
> +		if (time_after(jiffies, last_updated + HZ * 10)) {
>  			bch_info(ca, "%s: currently at %llu/%llu",
>  				 __func__, iter.pos.offset, ca->mi.nbuckets);
>  			last_updated = jiffies;
> diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
> index 7664b68e6..32b886feb 100644
> --- a/fs/bcachefs/journal_io.c
> +++ b/fs/bcachefs/journal_io.c
> @@ -1950,7 +1950,8 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
>  	if (error ||
>  	    w->noflush ||
>  	    (!w->must_flush &&
> -	     (jiffies - j->last_flush_write) < msecs_to_jiffies(c->opts.journal_flush_delay) &&
> +	     time_before(jiffies, j->last_flush_write +
> +		 msecs_to_jiffies(c->opts.journal_flush_delay)) &&
>  	     test_bit(JOURNAL_may_skip_flush, &j->flags))) {
>  		w->noflush = true;
>  		SET_JSET_NO_FLUSH(w->data, true);
> diff --git a/fs/bcachefs/thread_with_file.c b/fs/bcachefs/thread_with_file.c
> index 0807ce9b1..fb3442a7c 100644
> --- a/fs/bcachefs/thread_with_file.c
> +++ b/fs/bcachefs/thread_with_file.c
> @@ -387,7 +387,7 @@ int bch2_stdio_redirect_readline_timeout(struct stdio_redirect *stdio,
>  	seen = buf->buf.nr;
>  	char *n = memchr(buf->buf.data, '\n', seen);
>  
> -	if (!n && timeout != MAX_SCHEDULE_TIMEOUT && jiffies >= until) {
> +	if (!n && timeout != MAX_SCHEDULE_TIMEOUT && time_after_eq(jiffies, until)) {
>  		spin_unlock(&buf->lock);
>  		return -ETIME;
>  	}
> -- 
> 2.39.0
> 
