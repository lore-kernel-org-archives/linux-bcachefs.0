Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9KvP2zj"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B232BB5
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702067049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3aDVTdcl5IHMDxaRA+jbWej2fUNkDSWdpb7yG/wKP9A=;
	b=G9KvP2zjum12UPVPVY78ShBauLYOPT+9isUUqkMBViHD1jvHVc3LlCsZLpyRZqAxDkNon7
	n5I5ZhTr6hBSUfjzHFIuZ3goWdIiKPQ1uLJ/3BgKmk9v5QJmaQVwKluRXydDZ30/MtAR46
	dwMkHDjaPbnCg69qyXXkkApms98pi5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-jenPOkGmO72jldhMrNzWAg-1; Fri, 08 Dec 2023 15:24:07 -0500
X-MC-Unique: jenPOkGmO72jldhMrNzWAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1891485A588;
	Fri,  8 Dec 2023 20:24:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDED3111F3C6;
	Fri,  8 Dec 2023 20:24:06 +0000 (UTC)
Date: Fri, 8 Dec 2023 15:25:02 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 4/6] bcachefs: bch2_run_online_recovery_passes()
Message-ID: <ZXN7nrQJCsPzFab3@bfoster>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-5-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206203313.2197302-5-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On Wed, Dec 06, 2023 at 03:33:08PM -0500, Kent Overstreet wrote:
> Add a new helper for running online recovery passes - i.e. online fsck.
> This is a subset of our normal recovery passes, and does not - for now -
> use or follow c->curr_recovery_pass.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/bcachefs.h |  7 ++++++
>  fs/bcachefs/recovery.c | 51 ++++++++++++++++++++++++++++--------------
>  fs/bcachefs/recovery.h |  1 +
>  3 files changed, 42 insertions(+), 17 deletions(-)
> 
...
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 585b4928964f..262c923b2f1a 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
...
> @@ -651,39 +651,56 @@ static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pa
>  
>  static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
>  {
> +	struct recovery_pass_fn *p = recovery_pass_fns + pass;
>  	int ret;
>  
> -	c->curr_recovery_pass = pass;
> +	if (!(p->when & PASS_SILENT))
> +		printk(KERN_INFO bch2_log_msg(c, "%s..."),
> +		       bch2_recovery_passes[pass]);
> +	ret = p->fn(c);
> +	if (ret)
> +		return ret;
> +	if (!(p->when & PASS_SILENT))
> +		printk(KERN_CONT " done\n");
>  
> -	if (should_run_recovery_pass(c, pass)) {
> -		struct recovery_pass_fn *p = recovery_pass_fns + pass;
> +	return 0;
> +}
>  
> -		if (!(p->when & PASS_SILENT))
> -			printk(KERN_INFO bch2_log_msg(c, "%s..."),
> -			       bch2_recovery_passes[pass]);
> -		ret = p->fn(c);
> -		if (ret)
> -			return ret;
> -		if (!(p->when & PASS_SILENT))
> -			printk(KERN_CONT " done\n");
> +static int bch2_run_recovery_passes(struct bch_fs *c)
> +{
> +	int ret = 0;
>  
> -		c->recovery_passes_complete |= BIT_ULL(pass);
> +	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
> +		if (should_run_recovery_pass(c, c->curr_recovery_pass)) {
> +			ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
> +			if (bch2_err_matches(ret, BCH_ERR_restart_recovery))
> +				continue;
> +			if (ret)
> +				break;
> +
> +			c->recovery_passes_complete |= BIT_ULL(c->curr_recovery_pass);
> +		}
> +		c->curr_recovery_pass++;
>  	}
>  
> -	return 0;
> +	return ret;
>  }
>  
> -static int bch2_run_recovery_passes(struct bch_fs *c)
> +int bch2_run_online_recovery_passes(struct bch_fs *c)
>  {
>  	int ret = 0;
>  
> -	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns)) {
> +	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++) {
> +		struct recovery_pass_fn *p = recovery_pass_fns + c->curr_recovery_pass;

Maybe I'm confused, but should this be using i?

Brian

> +
> +		if (!(p->when & PASS_ONLINE))
> +			continue;
> +
>  		ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
>  		if (bch2_err_matches(ret, BCH_ERR_restart_recovery))
>  			continue;
>  		if (ret)
>  			break;
> -		c->curr_recovery_pass++;
>  	}
>  
>  	return ret;
> diff --git a/fs/bcachefs/recovery.h b/fs/bcachefs/recovery.h
> index 852d30567da9..447590f60609 100644
> --- a/fs/bcachefs/recovery.h
> +++ b/fs/bcachefs/recovery.h
> @@ -25,6 +25,7 @@ static inline int bch2_run_explicit_recovery_pass(struct bch_fs *c,
>  	}
>  }
>  
> +int bch2_run_online_recovery_passes(struct bch_fs *);
>  u64 bch2_fsck_recovery_passes(void);
>  
>  int bch2_fs_recovery(struct bch_fs *);
> -- 
> 2.42.0
> 
> 

