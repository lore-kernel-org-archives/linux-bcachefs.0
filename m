Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7C33A267
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fbZf/fA7"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB75CB
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 05:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699967907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6MEGs290QP31tHD3rihkRa9/003vdplBAVQhb0wON7g=;
	b=fbZf/fA76vYFc4JLHsucz19DGA9sukbFIH/1l8SpARBoGsF2tReKsZbNDoAZehFe2JiuHW
	AKGdX2w5KTHLLaP5cumpo0gAk8NLgmlouV45V3C2kYGNV/lU1P0NZNuELPgzTbKAXGIRG/
	RfLi6t8wn6RK19AIYJpJy3Of7xLiApY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-jl2X5ZSoNPOfF08f9mSBWQ-1; Tue,
 14 Nov 2023 08:18:25 -0500
X-MC-Unique: jl2X5ZSoNPOfF08f9mSBWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 845CF1C0514D;
	Tue, 14 Nov 2023 13:18:25 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DAF940C6EB9;
	Tue, 14 Nov 2023 13:18:25 +0000 (UTC)
Date: Tue, 14 Nov 2023 08:19:04 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 07/17] bcachefs: Make journal replay more efficient
Message-ID: <ZVNzyMRK6BHeEIiS@bfoster>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-8-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110163157.2736111-8-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Fri, Nov 10, 2023 at 11:31:44AM -0500, Kent Overstreet wrote:
> Journal replay now first attempts to replay keys in sorted order,
> similar to how the btree write buffer flush path works.
> 
> Any keys that can not be replayed due to journal deadlock are then left
> for later and replayed in journal order, unpinning journal entries as we
> go.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---

Just a question and a nit..

>  fs/bcachefs/errcode.h  |  1 -
>  fs/bcachefs/recovery.c | 84 ++++++++++++++++++++++++++++--------------
>  2 files changed, 56 insertions(+), 29 deletions(-)
> 
...
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 6eafff2557a4..3524d1e0003e 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
...
> @@ -166,26 +159,61 @@ static int bch2_journal_replay(struct bch_fs *c)
>  			goto err;
>  	}
>  
> -	for (i = 0; i < keys->nr; i++) {
> -		k = keys_sorted[i];
> +	/*
> +	 * First, attempt to replay keys in sorted order. This is more
> +	 * efficient, but some might fail if that would cause a journal
> +	 * deadlock.
> +	 */

What does "sorted order" mean here vs. when we sort by journal seq
below?

> +	for (size_t i = 0; i < keys->nr; i++) {
> +		cond_resched();
> +
> +		struct journal_key *k = keys->d + i;
> +
> +		ret = commit_do(trans, NULL, NULL,
> +				BTREE_INSERT_NOFAIL|
> +				BTREE_INSERT_JOURNAL_RECLAIM|
> +				(!k->allocated ? BTREE_INSERT_JOURNAL_REPLAY : 0),
> +			     bch2_journal_replay_key(trans, k));
> +		BUG_ON(!ret && !k->overwritten);
> +		if (ret) {
> +			ret = darray_push(&keys_sorted, k);
> +			if (ret)
> +				goto err;
> +		}
> +	}
> +
> +	/*
> +	 * Now, replay any remaining keys in the order in which they appear in
> +	 * the journal, unpinning those journal entries as we go:
> +	 */
> +	sort(keys_sorted.data, keys_sorted.nr,
> +	     sizeof(keys_sorted.data[0]),
> +	     journal_sort_seq_cmp, NULL);
>  
> +	darray_for_each(keys_sorted, kp) {
>  		cond_resched();
>  
> +		struct journal_key *k = *kp;
> +
>  		replay_now_at(j, k->journal_seq);
>  
> -		ret = bch2_trans_do(c, NULL, NULL,
> -				    BTREE_INSERT_NOFAIL|
> -				    (!k->allocated
> -				     ? BTREE_INSERT_JOURNAL_REPLAY|BCH_WATERMARK_reclaim
> -				     : 0),
> +		ret = commit_do(trans, NULL, NULL,
> +				BTREE_INSERT_NOFAIL|
> +				(!k->allocated
> +				 ? BTREE_INSERT_JOURNAL_REPLAY|BCH_WATERMARK_reclaim
> +				 : 0),
>  			     bch2_journal_replay_key(trans, k));
> -		if (ret) {
> -			bch_err(c, "journal replay: error while replaying key at btree %s level %u: %s",
> -				bch2_btree_id_str(k->btree_id), k->level, bch2_err_str(ret));
> +		bch_err_msg(c, ret, "while replaying key at btree %s level %u:",
> +			    bch2_btree_id_str(k->btree_id), k->level);
> +		if (ret)
>  			goto err;
> -		}
> +
> +		BUG_ON(!k->overwritten);
>  	}
>  
> +	bch2_trans_put(trans);
> +	trans = NULL;
> +

Nit: This looks spurious w/ the exit path, just FWIW.

Brian

>  	replay_now_at(j, j->replay_journal_seq_end);
>  	j->replay_journal_seq = 0;
>  
> @@ -196,10 +224,10 @@ static int bch2_journal_replay(struct bch_fs *c)
>  	if (keys->nr && !ret)
>  		bch2_journal_log_msg(c, "journal replay finished");
>  err:
> -	kvfree(keys_sorted);
> -
> -	if (ret)
> -		bch_err_fn(c, ret);
> +	if (trans)
> +		bch2_trans_put(trans);
> +	darray_exit(&keys_sorted);
> +	bch_err_fn(c, ret);
>  	return ret;
>  }
>  
> -- 
> 2.42.0
> 
> 

