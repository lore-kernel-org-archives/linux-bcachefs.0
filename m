Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF7420B0F
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 03:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728443635; cv=none; b=p+BMBW5UfhKmxT5tgN09jmsNM6YvdwW/+dh2U4ujeorlSOqG6VmVU+V3XdDzngZS7MCA37zkoesjYPuMzzTMzXufKqsBz/sJ5ey1ohz8N2AtMfvxLsubF47mg8nxeOgpCoyV+Jay8ili3kTlWpYNp1s8ZWjOpAkMjUMqPN2ZlxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728443635; c=relaxed/simple;
	bh=qn0AEyQBy2dsIJsRn0rfGMJedq27YmY5AAJ98L3TI/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f16HaIlpDkTJTqj3oyn+krn86pIko+X9Lb6ruJrQg/UDFg1w5E7c7uN3LjBoF5l+LIvmJu6NX0lCdlFJTvv5p0wnH4Tw99iNLRXtY5gDj6GqFPpZfilRUc+fga9nw57fb6JNj0mJ5auySTcXuxuZmnIlv8ZOe+n59A56+zA5x1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AIYSgrt9; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AIYSgrt9"
Date: Tue, 8 Oct 2024 23:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728443630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cR88bg/ceODtECJbhDj1UZkjyBdIn9PbU0RuisltAhs=;
	b=AIYSgrt9+RERWdYnxaSWL41YjZI3iwUM8JfKTy7y5YWzLwDrgNzcrqzmMbyxIGx6+XHncF
	n0MxFqofxjm9xtrBt3aQy6vy8so1iLlts4NkNzcrb3uBoM6YaxqXXVO4RAzvWLg7aTGpWU
	VcFxnac+dDWtc/XQeVHsySvGg/FTBoY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, chris.zjh@huawei.com, ddiss@suse.de
Subject: Re: [PATCH v2 1/2] bcachefs: avoid copy from NULL printbuf
Message-ID: <zahnaoa6rppe7niu3erezprogadzdym5rbktqpgp7cseqqqp65@dylrno7fewka>
References: <20240926020002.1746333-1-lihongbo22@huawei.com>
 <20240926020002.1746333-2-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926020002.1746333-2-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 26, 2024 at 10:00:00AM GMT, Hongbo Li wrote:
> printbuf.buf may be NULL if allocation_failure is true. Check
> for this prior to using it as a seq_puts() source.
> 
> Fixes: fa8e94faeece ("bcachefs: Heap allocate printbufs")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Let's do this by adding a proper printbuf_err() helper - have it return
-ENOMEM on allocation failure, and do a normal
if (ret)
	goto err;

so it looks more standard.

> ---
>  fs/bcachefs/fs.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> index e774cb3e6b1a..d6e26b5056f3 100644
> --- a/fs/bcachefs/fs.c
> +++ b/fs/bcachefs/fs.c
> @@ -1923,13 +1923,16 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
>  {
>  	struct bch_fs *c = root->d_sb->s_fs_info;
>  	struct printbuf buf = PRINTBUF;
> +	int ret = 0;
>  
>  	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
>  			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
>  	printbuf_nul_terminate(&buf);
> -	seq_puts(seq, buf.buf);
> +	if (buf.allocation_failure)
> +		ret = -ENOMEM;
> +	else
> +		seq_puts(seq, buf.buf);
>  
> -	int ret = buf.allocation_failure ? -ENOMEM : 0;
>  	printbuf_exit(&buf);
>  	return ret;
>  }
> -- 
> 2.34.1
> 
