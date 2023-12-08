Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GjquG+1M"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCA410D
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Dec 2023 12:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702067160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IWG29Gwco08doxTxbOeySaYWLvki+X0W+uFODGm7A/8=;
	b=GjquG+1MTZQc43HoY46votJj0LMQx+9uhngoZF5ww2DWhUrp/ugTPDeVtHNvjTLKN2FgDX
	eps0fv5saCASY/T9mUEgBJHZTfNZ4EJxbw+h/oTwlMcLwfTh7fmTBltMW4IF8/ocExClGU
	wqm7KVAhXjfoKvMjpSEsqkBu1ySczTk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-b0W7n1myOjyQSQATWrpvtw-1; Fri,
 08 Dec 2023 15:25:58 -0500
X-MC-Unique: b0W7n1myOjyQSQATWrpvtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C4213CBDFA7;
	Fri,  8 Dec 2023 20:25:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E37592026D66;
	Fri,  8 Dec 2023 20:25:57 +0000 (UTC)
Date: Fri, 8 Dec 2023 15:26:53 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH 5/6] bcachefs: BCH_IOCTL_FSCK_OFFLINE
Message-ID: <ZXN8DXEWJ7WbjxHV@bfoster>
References: <20231206203313.2197302-1-kent.overstreet@linux.dev>
 <20231206203313.2197302-6-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206203313.2197302-6-kent.overstreet@linux.dev>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Dec 06, 2023 at 03:33:09PM -0500, Kent Overstreet wrote:
> This adds a new ioctl for running fsck on a list of devices.
> 
> Normally, if we wish to use the kernel's implementation of fsck we'd run
> it at mount time with -o fsck. This ioctl lets us run fsck without
> mounting, so that userspace bcachefs-tools can transparently switch to
> the kernel's implementation of fsck when appropriate - primarily if the
> kernel version of bcachefs better matches the filesystem on disk.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  fs/bcachefs/bcachefs_ioctl.h |  13 +++
>  fs/bcachefs/chardev.c        | 206 ++++++++++++++++++++++++++++++++++-
>  fs/bcachefs/recovery.c       |   6 +-
>  3 files changed, 219 insertions(+), 6 deletions(-)
> 
...
> diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> index 8e3ac2d32298..03082a001036 100644
> --- a/fs/bcachefs/chardev.c
> +++ b/fs/bcachefs/chardev.c
...
> @@ -193,8 +196,196 @@ static long bch2_ioctl_incremental(struct bch_ioctl_incremental __user *user_arg
>  }
>  #endif
>  
...
> +
> +static const struct file_operations fsck_thread_ops = {
> +	.release	= bch2_fsck_thread_release,
> +	.read		= bch2_fsck_thread_read,
> +	.llseek		= no_llseek,
> +};
> +
> +static int bch2_fsck_offline_thread_fn(void *arg)
> +{
> +	struct fsck_thread *thr = container_of(arg, struct fsck_thread, thr);
> +	struct bch_fs *c = bch2_fs_open(thr->devs, thr->nr_devs, thr->opts);
> +
> +	thr->thr.ret = PTR_ERR_OR_ZERO(c);
> +	if (!thr->thr.ret)
> +		bch2_fs_stop(c);
> +

Looks pretty neat. Mainly just curious if I'm following this right...
Basically it looks like we wire up the log output redirect to c->output
via options, then start/stop the fs which runs "mount time" fsck (?),
but feeding the message output to the redirect (and then fed to
userspace via the fd/read handler just above). Hm?

Brian

> +	thr->thr.done = true;
> +	wake_up(&thr->output.wait);
> +	return 0;
> +}
> +
> +static long bch2_ioctl_fsck_offline(struct bch_ioctl_fsck_offline __user *user_arg)
> +{
> +	struct bch_ioctl_fsck_offline arg;
> +	struct fsck_thread *thr = NULL;
> +	u64 *devs = NULL;
> +	long ret = 0;
> +
> +	if (copy_from_user(&arg, user_arg, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (arg.flags)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (!(devs = kcalloc(arg.nr_devs, sizeof(*devs), GFP_KERNEL)) ||
> +	    !(thr = kzalloc(sizeof(*thr), GFP_KERNEL)) ||
> +	    !(thr->devs = kcalloc(arg.nr_devs, sizeof(*thr->devs), GFP_KERNEL))) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	thr->nr_devs = arg.nr_devs;
> +	thr->output.buf	= PRINTBUF;
> +	thr->output.buf.atomic++;
> +	spin_lock_init(&thr->output.lock);
> +	init_waitqueue_head(&thr->output.wait);
> +	darray_init(&thr->output2);
> +
> +	if (copy_from_user(devs, &user_arg->devs[0], sizeof(user_arg->devs[0]) * arg.nr_devs)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	for (size_t i = 0; i < arg.nr_devs; i++) {
> +		thr->devs[i] = strndup_user((char __user *)(unsigned long) devs[i], PATH_MAX);
> +		ret = PTR_ERR_OR_ZERO(thr->devs[i]);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	if (arg.opts) {
> +		char *optstr = strndup_user((char __user *)(unsigned long) arg.opts, 1 << 16);
> +
> +		ret =   PTR_ERR_OR_ZERO(optstr) ?:
> +			bch2_parse_mount_opts(NULL, &thr->opts, optstr);
> +		kfree(optstr);
> +
> +		if (ret)
> +			goto err;
> +	}
> +
> +	opt_set(thr->opts, log_output, (u64)(unsigned long)&thr->output);
> +
> +	ret = run_thread_with_file(&thr->thr,
> +				   &fsck_thread_ops,
> +				   bch2_fsck_offline_thread_fn,
> +				   "bch-fsck");
> +err:
> +	if (ret < 0) {
> +		if (thr)
> +			bch2_fsck_thread_free(thr);
> +		pr_err("ret %s", bch2_err_str(ret));
> +	}
> +	kfree(devs);
> +	return ret;
> +}
> +
>  static long bch2_global_ioctl(unsigned cmd, void __user *arg)
>  {
> +	long ret;
> +
>  	switch (cmd) {
>  #if 0
>  	case BCH_IOCTL_ASSEMBLE:
> @@ -202,9 +393,18 @@ static long bch2_global_ioctl(unsigned cmd, void __user *arg)
>  	case BCH_IOCTL_INCREMENTAL:
>  		return bch2_ioctl_incremental(arg);
>  #endif
> +	case BCH_IOCTL_FSCK_OFFLINE: {
> +		ret = bch2_ioctl_fsck_offline(arg);
> +		break;
> +	}
>  	default:
> -		return -ENOTTY;
> +		ret = -ENOTTY;
> +		break;
>  	}
> +
> +	if (ret < 0)
> +		ret = bch2_err_class(ret);
> +	return ret;
>  }
>  
>  static long bch2_ioctl_query_uuid(struct bch_fs *c,
> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> index 262c923b2f1a..2f5daecfbcf7 100644
> --- a/fs/bcachefs/recovery.c
> +++ b/fs/bcachefs/recovery.c
> @@ -655,13 +655,13 @@ static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
>  	int ret;
>  
>  	if (!(p->when & PASS_SILENT))
> -		printk(KERN_INFO bch2_log_msg(c, "%s..."),
> -		       bch2_recovery_passes[pass]);
> +		bch2_print(c, KERN_INFO bch2_log_msg(c, "%s..."),
> +			   bch2_recovery_passes[pass]);
>  	ret = p->fn(c);
>  	if (ret)
>  		return ret;
>  	if (!(p->when & PASS_SILENT))
> -		printk(KERN_CONT " done\n");
> +		bch2_print(c, KERN_CONT " done\n");
>  
>  	return 0;
>  }
> -- 
> 2.42.0
> 
> 

