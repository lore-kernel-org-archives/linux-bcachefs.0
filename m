Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E10A1DFC6
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710956289; cv=none; b=SQH2HJ1DBJttULyNwO7QVjPhPbAB1SMTbD8TYbVwOi8so9cTAozNl2ihDDn9AupMQbh5v8hdkirIq39PE94QhvjbOMnsYZp08Tag9UfL3up14hZ/NUaEAXtLxvQfZT/ndWgQgnw3EXUlTE3NoJoiLAsqNQFjaGTVnoHbqc2u5ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710956289; c=relaxed/simple;
	bh=4AhwnaYDs90ZXi+bJDBH+gp2T/8B1zvDAeEEAOkIYYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZI/xtcrKUT1eQl+nXjSv7WV05+678QCX8CK2c1quDrLAkdZ9asWPTk0jkM0c+Hati75K3e5nhbcxA8lop/aizDYbZ+6KZedp526aiwL5oEYx+7HgAAZa8wv+Y2NjognGPoMnRi4B+x1pFElJTaT8x8pMFpelTyMmmp9waLvS0oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OzQRWmAu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OzQRWmAu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710956287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgaUtl6Hq6HdwPF3xnPavvteJ95v1abcnLrgCYW7/2w=;
	b=OzQRWmAu+SMYq2WRe7N7eXqrR7DCnmtx5FN3OpqpaOGKYc0ULkfCSQ4E+MgyoKVct/Y7Ns
	RGND4tD0ph5+Tc7ENFtZXdgV8MzEjNs4+uJMJspjitFf6dLt41jgTHvfP86BWr/q6brAZ2
	JaSm0YcVJu2fZUKq78bptbNfAVSxUkw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-l7LOvBznMGSmYGICeIvKaw-1; Wed, 20 Mar 2024 13:38:01 -0400
X-MC-Unique: l7LOvBznMGSmYGICeIvKaw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C062085CBAF;
	Wed, 20 Mar 2024 17:38:00 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 852D510189;
	Wed, 20 Mar 2024 17:38:00 +0000 (UTC)
Date: Wed, 20 Mar 2024 13:39:49 -0400
From: Brian Foster <bfoster@redhat.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] bcachefs: use btree_path_state to represent
 btree_path status
Message-ID: <ZfsfZby1X6XAbhql@bfoster>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-2-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320062923.305431-2-lihongbo22@huawei.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Mar 20, 2024 at 02:29:22PM +0800, Hongbo Li wrote:
> First, the old structure cannot clearly represent the state changes
> of btree_path (such as BTREE_ITER_xxx). Secondly, the member (
> btree_path->uptodate) cannot express its purpose intuitively. It's
> essentially a state value if I understand correctly. Using this way
> can makes the representation of member variables more reasonable.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/btree_iter.c         | 22 +++++++++++-----------
>  fs/bcachefs/btree_iter.h         |  6 +++---
>  fs/bcachefs/btree_key_cache.c    | 12 ++++++------
>  fs/bcachefs/btree_locking.c      | 14 +++++++-------
>  fs/bcachefs/btree_locking.h      |  8 ++++----
>  fs/bcachefs/btree_trans_commit.c |  2 +-
>  fs/bcachefs/btree_types.h        | 10 +++++-----
>  7 files changed, 37 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
> index 9404d96c38f3..7146d6cf9fba 100644
> --- a/fs/bcachefs/btree_types.h
> +++ b/fs/bcachefs/btree_types.h
> @@ -218,10 +218,10 @@ static const __maybe_unused u16 BTREE_ITER_CACHED_NOFILL	= 1 << 13;
>  static const __maybe_unused u16 BTREE_ITER_KEY_CACHE_FILL	= 1 << 14;
>  #define __BTREE_ITER_FLAGS_END					       15
>  
> -enum btree_path_uptodate {
> -	BTREE_ITER_UPTODATE		= 0,
> -	BTREE_ITER_NEED_RELOCK		= 1,
> -	BTREE_ITER_NEED_TRAVERSE	= 2,
> +enum btree_path_state {
> +        UPTODATE		= 0,
> +        NEED_RELOCK		= 1,
> +        NEED_TRAVERSE		= 2
>  };
>  
>  #if defined(CONFIG_BCACHEFS_LOCK_TIME_STATS) || defined(CONFIG_BCACHEFS_DEBUG)
> @@ -241,7 +241,7 @@ struct btree_path {
>  	enum btree_id		btree_id:5;
>  	bool			cached:1;
>  	bool			preserve:1;
> -	enum btree_path_uptodate uptodate:2;
> +	enum btree_path_state   status:2;

Personally I don't mind the field rename, but the loss of any prefix on
the flags urks me a bit. Any reason not to use something like
BTREE_PATH_UPTODATE..?

It also would be nice to be consistent between the field and enum names.
Perhaps rename the field to 'state' if it's of type btree_path_state?

Finally, if we are going to tweak this, it seems like a nice opportunity
to add a comment above btree_path_state to (briefly) explain what each
state means and perhaps how they relate.

Just my .02 of course. ;)

Brian

>  	/*
>  	 * When true, failing to relock this path will cause the transaction to
>  	 * restart:
> -- 
> 2.34.1
> 

