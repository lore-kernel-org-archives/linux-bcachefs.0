Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4588028C5B1
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750352407; cv=none; b=uSBbwocNHkZnVo5eIwk6AmcMIytvjS8NK2bPk9ALCppFqRYqIFGh2YMuSRdHIHhdbgLjLXW9fyKKYd+WoayYQr0nhofjG0RuxcCA6vd+9m57xV1GllSm2M+gzikqBx398OymWA5qR7RUl9QZqU+isLs3+5VjKWrsLoOCJjBef+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750352407; c=relaxed/simple;
	bh=x/f7Wm8tNcrscFETy6i+3IGlzkskZh6v40qVemCGeS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8vI4AlBeDMNtiHdgLoeN/+No1XCpy9Fu34xphpcpV8d8IdFKWg/FrdH0ro3VeBtldRlo5h5luqcIEeYvn0eQUzyTfngYKv+GaOEtWnub+E/tP1V8UlcKIX5DNo4q2gNc3ssTPOX280DZ63L68hv5V1VZdZo9h/GujVYpDFvAXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ULQO3z21; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ULQO3z21"
Date: Thu, 19 Jun 2025 12:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750352402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oLhXVo0OAakJREFENIFC6RgF8VOrE8cgcMa6KZpDO+Q=;
	b=ULQO3z21OWb2ck42eQqwG2c7cmLfSQe3ovZNdXyQAFFYdfV3/sKugzXuB2Y/jJT8NQopll
	JBIuUN2QyrA+thhvj5S9L9RYdBzLXiYvU+K4kImQTI2zm3QPTWZ4EvlPB+oDk+B30jsL1h
	WCl2JwDBqUEgJNmFf9Xo3iaIQwz98T8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/3] bcachefs: Fix *__bch2_trans_subbuf_alloc() error path
Message-ID: <tgiblqbdq7ncowqyxr7y63pslqbmwrv3whepyw7aig3fg7k2pj@clzxjiboqxjw>
References: <20250619163714.767851-1-kent.overstreet@linux.dev>
 <20250619163714.767851-2-kent.overstreet@linux.dev>
 <EBCEB9D4-EF19-4424-82A3-DD353FE57712@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EBCEB9D4-EF19-4424-82A3-DD353FE57712@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 12:53:00AM +0800, Alan Huang wrote:
> 
> On Jun 20, 2025, at 00:37, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > Don't change buf->size on error - this would usually be a transaction
> > restart, but it could also be -ENOMEM - when we've exceeded the bump
> > allocator max).
> > 
> > Fixes: 247abee6ae6d ("bcachefs: btree_trans_subbuf")
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> > fs/bcachefs/btree_update.c | 13 ++++++++++---
> > 1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
> > index f7949dbe8f70..668d4feb2879 100644
> > --- a/fs/bcachefs/btree_update.c
> > +++ b/fs/bcachefs/btree_update.c
> > @@ -550,19 +550,26 @@ void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
> > {
> > unsigned new_top = buf->u64s + u64s;
> > unsigned old_size = buf->size;
> > + unsigned new_size = buf->size;
> > 
> > - if (new_top > buf->size)
> > - buf->size = roundup_pow_of_two(new_top);
> > + BUG_ON(roundup_pow_of_two(new_top) > U16_MAX);
> > 
> > - void *n = bch2_trans_kmalloc_nomemzero_ip(trans, buf->size * sizeof(u64), ip);
> > + if (new_top > new_size)
> > + new_size = roundup_pow_of_two(new_top);
> > +
> > + void *n = bch2_trans_kmalloc_nomemzero_ip(trans, new_size * sizeof(u64), ip);
> > if (IS_ERR(n))
> > return n;
> > 
> > + unsigned offset = (u64 *) n - (u64 *) trans->mem;
> > + BUG_ON(offset > U16_MAX);
> 
> offset * sizeof(u64)  ?

btree_trans_subbuf fields are u16s, we're just concerned about integer
overflows here

> 
> > +
> > if (buf->u64s)
> > memcpy(n,
> >       btree_trans_subbuf_base(trans, buf),
> >       old_size * sizeof(u64));
> 
> copy buf->u64s is enough.

yup, already spotted that

> 
> > buf->base = (u64 *) n - (u64 *) trans->mem;
> > + buf->size = new_size;
> > 
> > void *p = btree_trans_subbuf_top(trans, buf);
> > buf->u64s = new_top;
> > -- 
> > 2.50.0
> > 
> 
