Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A145625
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 00:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742258013; cv=none; b=XzIUfjm82duLo03Uud0VasqHk+ah8K0aHEoyl1utUc4bz7ZEb5+E6ZF9OW21L9yZ8viTXnULR6wi/CF/fjcbGYgQ7JG9V1Wbj2aaO3TlwSsXqHh12NGT17Tn3vWO/R6U2cOWGjQAVafiGlBQFyGf1pb3oVCM1JZ/wTsPDX8dEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742258013; c=relaxed/simple;
	bh=bcwKsyKu/3CzXeVKOLxDYgjZ1JPNGu18svucIzeq19Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJPwA4IC9tf3gdTDKaIAtmSyWjysUfrv5irP4dVUuSIgME6OBCMagBfNl3xpw0Y57Pvbfgz24bc/orKBMbsNTlfY1n7bbFCbbC4f74F5yvr3/B9MbrsWhz9ShP2wgAT0/DQLQ+xkPN1GcJeSneYo9v+fOhEx9DVoHPcfZfcWI+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AZpW89E9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AZpW89E9"
Date: Mon, 17 Mar 2025 20:33:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742258009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wc4+XcYtMXjX+DYrBVLv+gQKvtLxWABVUcd5jBLn9OM=;
	b=AZpW89E9oXKpqog9DwgVecaQcroV7NcqV9dKkpqXvQrJ5Atxt6FSjItlCKZDTx75bOl0PA
	Qn7k0X0xP/2U0alPrySM07p8Jnm22K8nR+8KuaB0uEFAVAKImU511VEKgG5Ft1+E9n5zv1
	bpJOdClYubHQf4LutWwcq0+nBiYf/10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: John Stoffel <john@stoffel.org>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Increase blacklist range
Message-ID: <gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
 <26584.36082.936426.143774@quad.stoffel.home>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26584.36082.936426.143774@quad.stoffel.home>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 17, 2025 at 04:58:26PM -0400, John Stoffel wrote:
> >>>>> "Alan" == Alan Huang <mmpgouride@gmail.com> writes:
> 
> > Now there are 16 journal buffers, 8 is too small to be enough.
> > Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> > ---
> >  fs/bcachefs/recovery.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> > index 71c786cdb192..a6e26733854d 100644
> > --- a/fs/bcachefs/recovery.c
> > +++ b/fs/bcachefs/recovery.c
> > @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
> >  	 * journal sequence numbers:
> >  	 */
> >  	if (!c->sb.clean)
> > -		journal_seq += 8;
> > +		journal_seq += JOURNAL_BUF_NR * 4;
>  
> Instead of magic numbers, could you put in a define with an
> explanation of how you arrived at this number?  Just to document the
> assumptions better?
> 
> John

The * 4 is a fudge factor.

But actually, I was giving this more thought and I don't think we have
the correct number.

The real bound is "number of unflushed journal entries that might have
been allocated, and have other items (btree nodes) referring to that
sequence number, but which don't hit because beacuse they weren't
flushed".

And we don't have an actual bound on that.
