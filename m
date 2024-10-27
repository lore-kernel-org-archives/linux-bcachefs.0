Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4BA801
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729988921; cv=none; b=vFCsHh+GJYuBP2v3QUHmXM4YbxFabI2i4CyWk5/b2TdO1IxMsQbZ2m17hFY+QFwkHzfS/Za45MQ6p4P8oUUYMYOX07hPj29IGySBb02qs3elN/S1RG3H0Hq7/4ZhubjtSDwN51LauMH2qtCGgOvm8NYe0+K3Q3N/dro+mdhBnbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729988921; c=relaxed/simple;
	bh=9y72LuXV5Hi0GojIzO0cwS/Umb97djz1Ndsr8dJFL7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXxkEfzg8rm95iXqrc3t/zWMZv6/jyHWk9cGV+gdqEf51BhoZ3AjWMwMJtBmLHdPH7jZByRSlHVHdvqQzlzOPd7ElKo+fEqiPTM22UN7EqXiOk2w0EFlKF83EISiRxVZ8tygVWta14VJbbQLlgL2vpSprCnc/RFsOOH8QfOL2+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=altVUNfl; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="altVUNfl"
Date: Sat, 26 Oct 2024 20:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729988916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QAc3bO5AF1gjwZ0MxsZnJQetoPvQQq9XvHRS1GyOAW8=;
	b=altVUNfl+xiJnIdznLR+x6ObXsfOLmtfoFUHY5eeYfan4eEfkiN8oVZHRP8SJDiLi1vzRd
	nsk6aCTZ0uXSpxgbvuSczlK5wwyY2FcFg9tiLJ4Ihfe0xqih5O/TgCzr+cH7+gNvFd2IAc
	hP+Q5RRTHo9XBFuDZdkNKZ3byE/7Aqc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, 
	Alan Huang <mmpgouride@gmail.com>
Subject: Re: [PATCH v2] bcachefs: Fix NULL ptr dereference in
 btree_node_iter_and_journal_peek
Message-ID: <j3aypufmcezitilxlgkfyetnonkzlkst3hx4zxr4zspfonh5pm@mwngtgo4h4vb>
References: <20241026174155.233430-3-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026174155.233430-3-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 05:46:33PM +0000, Piotr Zalewski wrote:
> Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
> btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> bch2_bkey_buf_reassemble.
> 
> When key returned from bch2_btree_and_journal_iter_peek is NULL it means
> that btree topology needs repair. Print error message with position at
> which node wasn't found and its parent node information. Call
> bch2_topology_error and return error code returned by it to ensure that
> topology error is handled properly.
> 
> Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=005ef9aa519f30d97657
> Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> Suggested-by: Alan Huang <mmpgouride@gmail.com>
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> ---
> 
> Notes:
>     changes in v2:
>         - make commit message more verbose.
>         - set topology error, print error message and return
>           appropriate error code.
> 
>     link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.98915-3-pZ010001011111@proton.me/
> 
>  fs/bcachefs/btree_iter.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 15ac72b1af51..40c824779b15 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -880,6 +880,18 @@ static noinline int btree_node_iter_and_journal_peek(struct btree_trans *trans,
>  	__bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->iter, path->pos);
>  
>  	k = bch2_btree_and_journal_iter_peek(&jiter);
> +	if (!k.k) {
> +		struct printbuf buf = PRINTBUF;
> +
> +		prt_str(&buf, "node not found at pos ");
> +		bch2_bpos_to_text(&buf, path->pos);
> +		prt_str(&buf, " within parent node ");
> +		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&l->b->key));
> +
> +		ret = bch2_fs_topology_error(c, "%s", buf.buf);
> +		printbuf_exit(&buf);
> +		goto err;
> +	}

We'll want to add at least the btree ID and level to that.

Could you also look over the other places we report topology errors and
inconstencies for any commonality? btree_cache.c has some stuff, and I
think there's a helper in there that might give you the error message
you want (instead of just the btree node key), and I'd have a glance at
the topology error reporting in btree_update_interior.c and btree_gc.c
as well.

>  
>  	bch2_bkey_buf_reassemble(out, c, k);
>  
> @@ -887,6 +899,7 @@ static noinline int btree_node_iter_and_journal_peek(struct btree_trans *trans,
>  	    c->opts.btree_node_prefetch)
>  		ret = btree_path_prefetch_j(trans, path, &jiter);
>  
> +err:
>  	bch2_btree_and_journal_iter_exit(&jiter);
>  	return ret;
>  }
> -- 
> 2.47.0
> 
> 
