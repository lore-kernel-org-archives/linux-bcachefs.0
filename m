Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A3B63D
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 04:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734065842; cv=none; b=Lb8Am0BC5wZB09pDKVJo1NgvjIm57tDiwq03ij/pRSYouICgA80gewqzVQd5M3rTiGALH4PHgWqSXwv7ytT/kVZ7AJAQiauX7alXe3e29A0EWp2MjVSTn5Na6BADT/lf/g36fjr5XWSEJGJ1CsM4elX3JnksUVl19dff7FLckJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734065842; c=relaxed/simple;
	bh=DSB+8ApQ65o86S0IGjY/QueyQaGvbocdIEM6YqOFh2I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=szzKwC5IP+xXUJQQ2XAsQSVYcecVWpAxU9CALJyui0v4FvWLJuH6oVxTpplEpKWQP3PnK6JWQOlESeXV8zzuCM55WORGck29+RROwgxj6zp+0lOY1HItwJWwCH9aZlioeMSujGHjviKLrxvgtVpyJkDShSanHEtptWsph75khFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D1D32g7j; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D1D32g7j"
Date: Thu, 12 Dec 2024 23:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734065831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tucbBBhS8ft12IM7U4fPjLTOosK3+hwcC4K0vKssbkk=;
	b=D1D32g7j25EBiuljsAcnNYgC4HGN/4nnDYkS4rvMGLyKuBWNPoLzCANr+U5/ZvKA975XMv
	GgLMzeWmgYR3lJsfL+GlBxyiukRBH4OLl8AohWPYwYEL3CIo8ctl0LxHdWvkbhqwl+DbNY
	MRdIHqj1a0xzL7b9IhGf/V6gpN78Sz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 0/3] bcachefs: add and use printbuf_err helper
Message-ID: <4qcmnsjtriihdobz3sbd7patscqj72x3vx44iizvyoiw5fpvkz@bezvyxum6yl7>
References: <20241213040328.2921159-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213040328.2921159-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 13, 2024 at 12:03:25PM +0800, Hongbo Li wrote:
> Add printbuf_err helper to return standard error when
> allocation failure.
> 
> v3:
>   - Remove extra sign-off and rebase the code.
> 
> v2: https://lore.kernel.org/linux-bcachefs/20241112074745.407848-1-lihongbo22@huawei.com/
>   - add printbuf_err helper and use it.
> 
> v1: https://lore.kernel.org/all/20240926020002.1746333-2-lihongbo22@huawei.com/
> 
> Hongbo Li (3):
>   bcachefs: add printbuf_err helper
>   bcachefs: avoid copy from NULL printbuf when allocation failure
>   bcachefs: use printbuf_err helper
> 
>  fs/bcachefs/fs.c       | 9 +++++++--
>  fs/bcachefs/opts.c     | 7 +------
>  fs/bcachefs/printbuf.h | 5 +++++
>  fs/bcachefs/sysfs.c    | 4 +---
>  4 files changed, 14 insertions(+), 11 deletions(-)
> 
> -- 
> 2.34.1
> 

A thought.

I haven't been liking the idea of adding new error checks all over the
place (and if we interpret this strictly, they'd need to be added
_everywhere_) - a lot of pain for very little gain, considering that in
practice small allocations will never fail.

And most printbuf uses wouldn't be doing anything with an extra -ENOMEM
check, the few that need it do check for it explicitly.

But this is something that we should handle, because we could be using
a printbuf in an atomic context, or the debate over memory allocator
failure behaviour could change (unlikely, but) - or we could be trying
to print a string for which the initial allocation was over the size
that's guaranteed not to fail by the allocator.

So we want a way to make getting the string safe, without affecting the
ergonomics so much.

So...

What if we had a printbuf_str() method for getting the buffer, instead
of accessing printbuf.buf directly?

Then instead of returning a NULL pointer, if printbuf.buf is null it
could just return a pointer to the zero page (which conveniently is a
null terminated zero length string, for our purposes).
