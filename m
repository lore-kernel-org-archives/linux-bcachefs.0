Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZMPdHjvJ"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BC5B5
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702067002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=roqII/jTL3i+9xne2QejhZ/alJeHd1jyK0MibiT/g9Q=;
	b=ZMPdHjvJgM2Pp/4P7SW5s3MnQJCI8uFFJIvUHC2ub44tDPk05eBFGFyG9NRyfT1THgmx7s
	IyP1d4pmDWlKy8jAo7LGdaOsreofXnvnl7OYfIN4OncGUg9fTN3BVFOQcCzb7rSmnh4M/7
	rh7hkx+d3m/ZvHxYThpo4n6u9slO7b4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-0UmTC3BlMEutDSypXRhXfA-1; Fri, 08 Dec 2023 15:23:19 -0500
X-MC-Unique: 0UmTC3BlMEutDSypXRhXfA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CE6E87DC03;
	Fri,  8 Dec 2023 20:23:18 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B73E492BE6;
	Fri,  8 Dec 2023 20:23:18 +0000 (UTC)
Date: Fri, 8 Dec 2023 15:24:13 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 2/6] bcachefs: Add ability to redirect log output
Message-ID: <ZXN7bctKO+Rc/pm4@bfoster>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-3-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206203313.2197302-3-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Dec 06, 2023 at 03:33:06PM -0500, Kent Overstreet wrote:
> Upcoming patches are going to add two new ioctls for running fsck in the
> kernel, but pretending that we're running our normal userspace fsck.
> 
> This patch adds some plumbing for redirecting our normal log messages
> away from the dmesg log to a thread_with_file file descriptor - via a
> struct log_output, which will be consumed by the fsck f_op's read method.
> 
> The new ioctls will allow for running fsck in the kernel against an
> offline filesystem (without mounting it), and an online filesystem. For
> an offline filesystem we need a way to pass in a pointer to the
> log_output, which is done via a new hidden opts.h option.
> 
> For online fsck, we can set c->output directly, but only want to
> redirect log messages from the thread running fsck - hence the new
> c->output_filter method.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/bcachefs.h | 54 +++++++++++++++++++++++++++++++-----------
>  fs/bcachefs/opts.h     |  5 ++++
>  fs/bcachefs/super.c    | 28 ++++++++++++++++++++++
>  3 files changed, 73 insertions(+), 14 deletions(-)
> 
...
> diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
> index 8526f177450a..91026dfb8c83 100644
> --- a/fs/bcachefs/opts.h
> +++ b/fs/bcachefs/opts.h
> @@ -419,6 +419,11 @@ enum fsck_err_opts {
>  	  OPT_BOOL(),							\
>  	  BCH2_NO_SB_OPT,		false,				\
>  	  NULL,		"Allocate the buckets_nouse bitmap")		\
> +	x(log_output,			u64,				\
> +	  0,								\
> +	  OPT_UINT(0, S64_MAX),						\
> +	  BCH2_NO_SB_OPT,		false,				\
> +	  NULL,		"Allocate the buckets_nouse bitmap")		\

I assume you want to update the string to something more related. :)

Brian

>  	x(project,			u8,				\
>  	  OPT_INODE,							\
>  	  OPT_BOOL(),							\
> diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
> index e7f186b45df1..6c320defd593 100644
> --- a/fs/bcachefs/super.c
> +++ b/fs/bcachefs/super.c
> @@ -80,6 +80,32 @@ const char * const bch2_fs_flag_strs[] = {
>  	NULL
>  };
>  
> +void __bch2_print(struct bch_fs *c, const char *fmt, ...)
> +{
> +	struct log_output *output = c->output;
> +	va_list args;
> +
> +	if (c->output_filter && c->output_filter != current)
> +		output = NULL;
> +
> +	va_start(args, fmt);
> +	if (likely(!output)) {
> +		vprintk(fmt, args);
> +	} else {
> +		unsigned long flags;
> +
> +		if (fmt[0] == KERN_SOH[0])
> +			fmt += 2;
> +
> +		spin_lock_irqsave(&output->lock, flags);
> +		prt_vprintf(&output->buf, fmt, args);
> +		spin_unlock_irqrestore(&output->lock, flags);
> +
> +		wake_up(&output->wait);
> +	}
> +	va_end(args);
> +}
> +
>  #define KTYPE(type)							\
>  static const struct attribute_group type ## _group = {			\
>  	.attrs = type ## _files						\
> @@ -703,6 +729,8 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
>  		goto out;
>  	}
>  
> +	c->output = (void *)(unsigned long) opts.log_output;
> +
>  	__module_get(THIS_MODULE);
>  
>  	closure_init(&c->cl, NULL);
> -- 
> 2.42.0
> 
> 

