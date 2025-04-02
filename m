Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308F017084F
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 16:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743610640; cv=none; b=rtE//aDeh5vmeMIp+UBpi0e7lHs4jta7nNmOYKR/6b98bQ1TKCzNNU7+KdzWTlwyXpaRrPXvM9hBtjdT0MHZhOSvypbNcph28ypGlR6v+sWSMxDnFZREs7ta3mSVqwKL5VqVK9LhAeXTIBzYIvZPhSLbi25gKbtMi/4pxB5BNU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743610640; c=relaxed/simple;
	bh=a8Oq66aDcTG4GmSrER9QzMzRgsnHux+vgkTcA6pIycY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCLFE4EylpibA5j32WS7H7+Wgj6UsJ2meWIIfAQ7clZUJQ8rRkkIeR+Fgny1IPU+vsKe00CixFu6lD2RTv8YIW0dYrGS5drYuYlS9lrGZhRAI3u/i3MLMS1yJyQGhxcw6cRp13VQtqSyFkLI2Po0COBV+hbjhtGkQ7i92ucNXXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i47BHoka; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i47BHoka"
Date: Wed, 2 Apr 2025 12:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743610636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yIyrX5tl66Za1UHas7Gl65oo4tXGrW/O3Iw+s4K3sQg=;
	b=i47BHokag9yrcA1TwLEbo5v4H0CkS0XKomDU5WAsRJdJqg4XFii26vZgw+1bEV0GPBwQRA
	COeHbJYhuRjp/rfDeOEBaYxcQEs2lK3wjLxs1pDcWJ5eq99NkpZW/2n4lCsMb6eyIla1W+
	IWMxBg1A/LXTrmMcUGPc30rre18UGqw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, shuah@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev, 
	syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: don't call sleeping funcs when handling
 inconsistency errors
Message-ID: <zjqewsg6ijvol3x3rdjfyjeji3wy24nw45yb6mkqj7vwsk7mrn@yxnvgpj4i24k>
References: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402161043.161795-1-bharadwaj.raju777@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 09:40:40PM +0530, Bharadwaj Raju wrote:
> In bch2_bkey_pick_read_device, we're in an RCU lock. So, we can't call
> any potentially-sleeping functions. However, we call bch2_dev_rcu,
> which calls bch2_fs_inconsistent in its error case. That then calls
> bch2_prt_print on a non-atomic printbuf, as well as uses the blocking
> variant of bch2_print_string_as_lines, both of which lead to calls to
> potentially-sleeping functions, namely krealloc with GFP_KERNEL
> and console_lock respectively.
> 
> Give a nonzero atomic to the printbuf, and use the nonblocking variant
> of bch2_print_string_as_lines.

Sorry, beat you to it :)

You also missed the one the syzbot report actually hit -
bch2_inconsistent_error().

commit fef0ac7dbdd3c2166462720a2c0c9b16ad0680a5
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 2 11:02:12 2025 -0400

    bcachefs: Fix scheduling while atomic
    
    bch2_inconsistent(), bch2_fs_inconsistent() be called from interrupt
    context, or with rcu_read_lock() held.
    
    The one syzbot found is in
      bch2_bkey_pick_read_device
      bch2_dev_rcu
      bch2_fs_inconsistent
    
    We're starting to switch to lift the printbufs up to higher levels so we
    can emit better log messages and print them all in one go (avoid
    garbling), so that conversion will help with spotting these in the
    future; when we declare a printbuf it must be flagged if we're in an
    atomic context.
    
    Reported-by: syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index d4dfd13a8076..b885bd92834c 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -45,6 +45,8 @@ bool __bch2_inconsistent_error(struct bch_fs *c, struct printbuf *out)
 bool bch2_inconsistent_error(struct bch_fs *c)
 {
 	struct printbuf buf = PRINTBUF;
+	buf.atomic++;
+
 	printbuf_indent_add_nextline(&buf, 2);
 
 	bool ret = __bch2_inconsistent_error(c, &buf);
@@ -59,6 +61,7 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
 				       const char *fmt, va_list args)
 {
 	struct printbuf buf = PRINTBUF;
+	buf.atomic++;
 
 	bch2_log_msg_start(c, &buf);
 

> 
> Reported-by: syzbot+c82cd2906e2f192410bb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c82cd2906e2f192410bb
> Signed-off-by: Bharadwaj Raju <bharadwaj.raju777@gmail.com>
> ---
>  fs/bcachefs/error.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
> index d4dfd13a8076..6f0f2f12c004 100644
> --- a/fs/bcachefs/error.c
> +++ b/fs/bcachefs/error.c
> @@ -60,6 +60,8 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
>  {
>  	struct printbuf buf = PRINTBUF;
>  
> +	buf.atomic++;
> +
>  	bch2_log_msg_start(c, &buf);
>  
>  	prt_vprintf(&buf, fmt, args);
> @@ -68,7 +70,9 @@ static bool bch2_fs_trans_inconsistent(struct bch_fs *c, struct btree_trans *tra
>  	if (trans)
>  		bch2_trans_updates_to_text(&buf, trans);
>  	bool ret = __bch2_inconsistent_error(c, &buf);
> -	bch2_print_string_as_lines(KERN_ERR, buf.buf);
> +	bch2_print_string_as_lines_nonblocking(KERN_ERR, buf.buf);
> +
> +	buf.atomic--;
>  
>  	printbuf_exit(&buf);
>  	return ret;
> -- 
> 2.49.0
> 
