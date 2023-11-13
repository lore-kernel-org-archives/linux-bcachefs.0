Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98612136A
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 15:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8K4qIQm"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07544171A
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 07:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699889337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeUMDHzpEzSc93rwitKWLVmZCx0V/Wzv7XFDxw/DaxY=;
	b=V8K4qIQmzDPb7Pz3PBzWpwORLUrqM28MSYH/ZQzKHpz31qMMSU+p50IJN7mYgBBaY+gX2/
	hQaHgBNOYem43VA0Tzuzqgvi/eMyu5YkykjfCWl/5KSh0Nh+2a/PeGa/IXeHHeksXIU8E0
	7YBj2Fkz9MUsJnqTeeSYUyVBZVbgT4Y=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-fuHk1gx3Ng2OhBHFaz4c7Q-1; Mon,
 13 Nov 2023 10:28:56 -0500
X-MC-Unique: fuHk1gx3Ng2OhBHFaz4c7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D0D3C14904;
	Mon, 13 Nov 2023 15:28:55 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A951502C;
	Mon, 13 Nov 2023 15:28:55 +0000 (UTC)
Date: Mon, 13 Nov 2023 10:29:34 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 05/17] bcachefs: Kill BTREE_UPDATE_PREJOURNAL
Message-ID: <ZVJA3vcKqur+L9gp@bfoster>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-6-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110163157.2736111-6-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Fri, Nov 10, 2023 at 11:31:42AM -0500, Kent Overstreet wrote:
> With the previous patch that reworks BTREE_INSERT_JOURNAL_REPLAY, we can
> now switch the btree write buffer to use it for flushing.
> 
> This has the advantage that transaction commits don't need to take a
> journal reservation at all.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/bkey_methods.h       |  2 --
>  fs/bcachefs/btree_trans_commit.c |  7 +------
>  fs/bcachefs/btree_types.h        |  1 -
>  fs/bcachefs/btree_update.c       | 23 -----------------------
>  fs/bcachefs/btree_write_buffer.c | 14 ++++++++++----
>  5 files changed, 11 insertions(+), 36 deletions(-)
> 
...
> diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> index ec90a06a6cf9..f231f01072c2 100644
> --- a/fs/bcachefs/btree_trans_commit.c
> +++ b/fs/bcachefs/btree_trans_commit.c
> @@ -779,12 +779,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
>  
>  	trans_for_each_update(trans, i) {
>  		if (!i->cached) {
> -			u64 seq = trans->journal_res.seq;
> -
> -			if (i->flags & BTREE_UPDATE_PREJOURNAL)
> -				seq = i->seq;
> -
> -			bch2_btree_insert_key_leaf(trans, i->path, i->k, seq);
> +			bch2_btree_insert_key_leaf(trans, i->path, i->k, trans->journal_res.seq);

Ok, so instead of passing the seq to the commit path via the insert
entry, we use a flag that enables a means to pass journal_res.seq
straight through to the commit. That seems reasonable to me.

One subtle thing that comes to mind is that the existing mechanism
tracks a seq per key update whereas this looks like it associates the
seq to the transaction and then to every key update. That's how it's
used today AFAICS so doesn't seem like a big deal, but what happens if
this is misused in the future? Does anything prevent having multiple
keys from different journal seqs in the same transaction leading to
pinning the wrong seq for some subset of keys? If not, it would be nice
to have some kind of check or something somewhere to fail an update for
a trans that might already have a pre journaled key.

>  		} else if (!i->key_cache_already_flushed)
>  			bch2_btree_insert_key_cached(trans, flags, i);
>  		else {
...
> diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
> index 9e3107187e1d..f40ac365620f 100644
> --- a/fs/bcachefs/btree_write_buffer.c
> +++ b/fs/bcachefs/btree_write_buffer.c
> @@ -76,12 +76,15 @@ static int bch2_btree_write_buffer_flush_one(struct btree_trans *trans,
>  	(*fast)++;
>  	return 0;
>  trans_commit:
> -	return  bch2_trans_update_seq(trans, wb->journal_seq, iter, &wb->k,
> -				      BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
> +	trans->journal_res.seq = wb->journal_seq;
> +
> +	return  bch2_trans_update(trans, iter, &wb->k,
> +				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
>  		bch2_trans_commit(trans, NULL, NULL,
>  				  commit_flags|
>  				  BTREE_INSERT_NOCHECK_RW|
>  				  BTREE_INSERT_NOFAIL|
> +				  BTREE_INSERT_JOURNAL_REPLAY|
>  				  BTREE_INSERT_JOURNAL_RECLAIM);

This is more of a nit for now, but I find the general use of a flag with
a contextual name unnecessarily confusing. I.e., the flag implies we're
doing journal replay, which we're not, and so makes the code confusing
to somebody who doesn't have the historical development context. Could
we rename or repurpose this to better reflect the functional purpose of
not acquiring a reservation (and let journal replay also use it)? I can
look into that as a followon change if you want to make suggestions or
share any thoughts..

But as a related example, do we care about how this flag modifies
invalid key checks (via __bch2_trans_commit()) for example?

Brian

>  }
>  
> @@ -125,9 +128,11 @@ btree_write_buffered_insert(struct btree_trans *trans,
>  	bch2_trans_iter_init(trans, &iter, wb->btree, bkey_start_pos(&wb->k.k),
>  			     BTREE_ITER_CACHED|BTREE_ITER_INTENT);
>  
> +	trans->journal_res.seq = wb->journal_seq;
> +
>  	ret   = bch2_btree_iter_traverse(&iter) ?:
> -		bch2_trans_update_seq(trans, wb->journal_seq, &iter, &wb->k,
> -				      BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE);
> +		bch2_trans_update(trans, &iter, &wb->k,
> +				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE);
>  	bch2_trans_iter_exit(trans, &iter);
>  	return ret;
>  }
> @@ -260,6 +265,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
>  		ret = commit_do(trans, NULL, NULL,
>  				commit_flags|
>  				BTREE_INSERT_NOFAIL|
> +				BTREE_INSERT_JOURNAL_REPLAY|
>  				BTREE_INSERT_JOURNAL_RECLAIM,
>  				btree_write_buffered_insert(trans, i));
>  		if (bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret)))
> -- 
> 2.42.0
> 
> 

