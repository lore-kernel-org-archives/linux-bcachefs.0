Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4075A21355
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNzCZyEP"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EF0D67
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 Nov 2023 07:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699888897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gnoo2ofbI6CJAJa7kjLqcSfHeWq8SpDkCYs/i/Xm3vM=;
	b=FNzCZyEPc6AE+CKQoumamvvytsX7skF+cEayXZMeY4Khikjo4Ly4jMwGnJ8llO4wUD8aWN
	jWaSHCLCIOnGeJOhblOsI/qhE8NowLU0JEytWBtOFjTMFiAmQrKToR5ph6o1rmHtlQTqPa
	5zt1P3SJZshexku87I/UbXxqBjZPZxI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-cBHnzD81O_qqKis7WQOvAA-1; Mon,
 13 Nov 2023 10:21:34 -0500
X-MC-Unique: cBHnzD81O_qqKis7WQOvAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F348F3813BC8;
	Mon, 13 Nov 2023 15:21:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDDB0C1596F;
	Mon, 13 Nov 2023 15:21:33 +0000 (UTC)
Date: Mon, 13 Nov 2023 10:22:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 03/17] bcachefs: Journal pins must always have a flush_fn
Message-ID: <ZVI/JaW+btefRvj3@bfoster>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-4-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231110163157.2736111-4-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Fri, Nov 10, 2023 at 11:31:40AM -0500, Kent Overstreet wrote:
> flush_fn is how we identify journal pins in debugfs - this is a
> debugging aid.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/btree_trans_commit.c    |  9 ++++++++-
>  fs/bcachefs/btree_update_interior.c | 21 ++++++++++++++++++---
>  fs/bcachefs/btree_write_buffer.c    | 18 +++++++-----------
>  fs/bcachefs/journal_reclaim.c       | 12 +++++++-----
>  4 files changed, 40 insertions(+), 20 deletions(-)
> 
...
> diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
> index 5c398b05cb39..9e3107187e1d 100644
> --- a/fs/bcachefs/btree_write_buffer.c
> +++ b/fs/bcachefs/btree_write_buffer.c
...
> @@ -148,7 +151,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
>  	if (!locked && !mutex_trylock(&wb->flush_lock))
>  		return 0;
>  
> -	bch2_journal_pin_copy(j, &pin, &wb->journal_pin, NULL);
> +	bch2_journal_pin_copy(j, &pin, &wb->journal_pin,
> +			      bch2_btree_write_buffer_journal_flush);
>  	bch2_journal_pin_drop(j, &wb->journal_pin);
>  
>  	s = btree_write_buffer_switch(wb);
> @@ -250,16 +254,8 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
>  		if (!i->journal_seq)
>  			continue;
>  
> -		if (i->journal_seq > pin.seq) {
> -			struct journal_entry_pin pin2;
> -
> -			memset(&pin2, 0, sizeof(pin2));
> -
> -			bch2_journal_pin_add(j, i->journal_seq, &pin2, NULL);
> -			bch2_journal_pin_drop(j, &pin);
> -			bch2_journal_pin_copy(j, &pin, &pin2, NULL);
> -			bch2_journal_pin_drop(j, &pin2);
> -		}
> +		bch2_journal_pin_update(j, i->journal_seq, &pin,
> +			      bch2_btree_write_buffer_journal_flush);

Hmm.. I recall looking at this on the previous improvements to this
path, but I don't quite remember why I didn't make this sort of change.
The existing code implies a race (i.e., using pin2 to ensure the pin is
never fully absent from the pin list) as opposed to what _pin_update()
does (remove then add). Any idea why the existing code does what it does
and/or can you explain why this change is safe? Thanks.

Brian

>  
>  		ret = commit_do(trans, NULL, NULL,
>  				commit_flags|
> diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
> index 79a6fdc6e6ef..8fa05bedb7df 100644
> --- a/fs/bcachefs/journal_reclaim.c
> +++ b/fs/bcachefs/journal_reclaim.c
> @@ -378,14 +378,16 @@ static inline void bch2_journal_pin_set_locked(struct journal *j, u64 seq,
>  {
>  	struct journal_entry_pin_list *pin_list = journal_seq_pin(j, seq);
>  
> +	/*
> +	 * flush_fn is how we identify journal pins in debugfs, so must always
> +	 * exist, even if it doesn't do anything:
> +	 */
> +	BUG_ON(!flush_fn);
> +
>  	atomic_inc(&pin_list->count);
>  	pin->seq	= seq;
>  	pin->flush	= flush_fn;
> -
> -	if (flush_fn)
> -		list_add(&pin->list, &pin_list->list[type]);
> -	else
> -		list_add(&pin->list, &pin_list->flushed);
> +	list_add(&pin->list, &pin_list->list[type]);
>  }
>  
>  void bch2_journal_pin_copy(struct journal *j,
> -- 
> 2.42.0
> 
> 

