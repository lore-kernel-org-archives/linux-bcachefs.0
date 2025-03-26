Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D3856B81
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 12:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742991595; cv=none; b=sKHwDUu8/3CdeGup+TWA8IRwhjrvfzH9MFB+lo2aocqklTjhfXXMcmFvlQL48Jxai7JTPhsddmjx2TppgJgagWGOp/tAKXFs9+oB+ifZE7cpC5gcWENLqjaUB8JnCf4uVxIEm179+PQ0zroilP3QA7WquqfN6ZrZUiWV/8I2l2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742991595; c=relaxed/simple;
	bh=tvwT/fpOuTFYDbfORjAlX35n2nxm8ikfrhI81rjIqYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X86N692Jy83o/bU6BhYicEBaybeZDogJqHe0aOw4L3iT8Xj4NNzgFcsVJ1bwC7ESi8KSeNF6okTnUPJ57NnpMEctArqJUDW2e+Sq36pPjItMeA9/W4RQ/tVtLKbgQpmrDZnb9uEkzP46r1a6NpZihVNq61KEtEDcygeGjvPUccI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dTz/KXdR; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dTz/KXdR"
Date: Wed, 26 Mar 2025 08:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742991579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/oaVHLFbWzKfUEG7Im5cPFtABNfTMHVrsIL6fXyC1Gk=;
	b=dTz/KXdRsI44K0SbkNy86I+cCZp2Dz0Xl3EzwAlFHMIEIOhmqWsRbn1YSd2Q3oEQ+DhoPW
	N2N3a5dWi6J8qRoNOwh9+/yFlL9zhbiY+A6x2AsynSziDlS4GvDwtnQYqGFH0WE7YRrufQ
	Jr4sh3AqEGax7XnAW39N0LMtZapqPjI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Roxana Nicolescu <nicolescu.roxana@protonmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy() with strscpy()
Message-ID: <bmjvipermsvb454mdh5zmlmw4gv4oub5fgh4eowedlit75gqei@3or3va3e52ce>
References: <20250326094449.16473-1-nicolescu.roxana@protonmail.com>
 <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5F3AB2BC-43DA-47A6-A07A-72540B327D11@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 06:02:31PM +0800, Alan Huang wrote:
> On Mar 26, 2025, at 17:44, Roxana Nicolescu <nicolescu.roxana@protonmail.com> wrote:
> > 
> > strncpy() is deprecated for NUL-terminated destination buffers. Use
> > strscpy() instead.
> > 
> > Link: https://github.com/KSPP/linux/issues/90
> > Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
> > ---
> > fs/bcachefs/btree_trans_commit.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> > index c4f524b2ca9a..7ab25b425d11 100644
> > --- a/fs/bcachefs/btree_trans_commit.c
> > +++ b/fs/bcachefs/btree_trans_commit.c
> > @@ -364,7 +364,7 @@ static noinline void journal_transaction_name(struct btree_trans *trans)
> > struct jset_entry_log *l =
> > container_of(entry, struct jset_entry_log, entry);
> > 
> > - strncpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> > + strscpy(l->d, trans->fn, JSET_ENTRY_LOG_U64s * sizeof(u64));
> 
> The last time I asked Kent about this line, he didn’t want this.

Yes, the destination buffer isn't required to be nul terminated.

But it seems we should add a comment explaining that :)
