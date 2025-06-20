Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2CF30E852
	for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 02:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750386129; cv=none; b=JxWWsCs+iM5sKoWsgygV0P+sZuhWQFiiw3IvYTzq4fTE1+prETR89Mq5wdDzMWf8iTd5vxRmh8+i9mGCsSQ5eyg9O6Ne4Y1iiNQ8tBFT0uOllayFk6Vjt4XLmRYJw4T3RRiQB4HvRI3+p1ONK4dBTDU5PyOOyoO0rkzi9NO3R1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750386129; c=relaxed/simple;
	bh=YxsTricwM4Rh/pQZlHqyutuQvqs+STli7oFGxmpMPmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q2UWD9V/ikghtddurmZUOl3CJCAYvqiyrEKJBxns9QeXjU6JiITIoiCKczYlOQX1Qrl9CrevVMvaaqC0u/LGjB5sMWwKOD1gXiqtOwauq8ykeoEgvlqWyTPzGKwln3ive7JI9zDHGkjw1e68QHT2Bh2pMEA9Xm8UKb4wkHZlNFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h0Yk9sEO; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h0Yk9sEO"
Date: Thu, 19 Jun 2025 22:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750386123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/MvNOYPug8XL+Kx6PSRk1Y9fQz3XUFPwVHY7MOHvpZo=;
	b=h0Yk9sEO3vnayNDtEcvDQbTV25mEzyW42kfNZCGJcby9Ldlv9Kwkzwy6RQ35lUA3w5WDQt
	nVg4f/mqcG53TtCz2LnsGPykenT8f9WhwwEJP8P1f0qUxsQfCCkuEM4AoUng4W6Mw+10cZ
	5GH6kIy3nn+oMmJbs8f3mFeZF7OybOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Refactor trans->mem allocation
Message-ID: <vfyvki4bskt3wkuj4ji6badnoynvc3nv7jsgjizqfdfla4i2od@ntjzwghel22p>
References: <20250619195826.983765-1-mmpgouride@gmail.com>
 <c37jfoo6eldcxjhe5uyyxwtwb4koegnw5euetnlrs5nkxkyxbz@kiehaju5g7ek>
 <93E5D6CB-99AE-41AE-AF50-A6985774222C@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93E5D6CB-99AE-41AE-AF50-A6985774222C@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 10:03:03AM +0800, Alan Huang wrote:
> 
> 
> > On Jun 20, 2025, at 04:35, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Fri, Jun 20, 2025 at 03:58:26AM +0800, Alan Huang wrote:
> >> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> >> ---
> >> fs/bcachefs/btree_iter.c | 65 ++++++++++++++++++++--------------------
> >> fs/bcachefs/btree_iter.h | 14 +++++++++
> >> 2 files changed, 46 insertions(+), 33 deletions(-)
> >> 
> >> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> >> index 352f9cd2634f..0168c4023c74 100644
> >> --- a/fs/bcachefs/btree_iter.c
> >> +++ b/fs/bcachefs/btree_iter.c
> >> @@ -3238,32 +3238,30 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
> >> }
> >> 
> >> EBUG_ON(trans->mem);
> >> + EBUG_ON(trans->mem_bytes);
> >> + EBUG_ON(trans->mem_top);
> > 
> > ???
> 
> It’s the first time we allocate memory.

Ok, I went and looked at the actual code from your repository; the diff
was missing critical context.

And it does look nicer when I'm looking at the code and not the diff -
I'll go ahead and apply it.
