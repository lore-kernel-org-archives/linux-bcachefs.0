Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6717BCC
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 21:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727127615; cv=none; b=rohu3t6XUD1rt1WbtQjn/+/cz0wtET4C0K8dXh0BD6IaNrWtMHhPlYNXHCCCzQUaWB213AWZMwQ7uPrA/pRDwfgWvSKPLl5u6q206TLsQMC5QD77r1CIdDW7Pq+bGkvwiGy1MeueTMAM6r9P/Ctem0sALTJXj4PMXTVhgeNouGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727127615; c=relaxed/simple;
	bh=RdUFfxySdjhWiFM9yaif4iQGL0aaSKMJmYk877OsASQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=STun2Adgwck+zl6e7uaxmP+B9lVQnr/CqCqjh1Ef0fv3MtrpK6o6ks+a5ixktAmxQcp4kS69aV5wVQZ7wqRP3i7qLsGrrtdVUw2+xbGCor7JEu2GiSLVimlSpPtdvFvL0haT+sxMsIw8hkP4TRBAxnhou4RirAksWC4HR1uc5lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eZcrNzEo; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eZcrNzEo"
Date: Mon, 23 Sep 2024 17:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727127610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MWVnlpKi/RrDupobKW1fqfV/s9EUz1uzJZek6KcbaSg=;
	b=eZcrNzEorBq5fzlmCM5cjSxeNh15Me1uvcTWvaWIcQlFQpt6pL05hSiKKuWaF6gHPi7ONl
	ZGXIr/MVJWcF8rDTcgbU+hmvgh+Jy1Ujy4kBXt3PUqIdff9dSCiF8dCedY0Bs4M9T6kpt/
	TTgpdyUw7LrmJ8PTL2ymJj8kQPt3/s8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Disseldorp <ddiss@suse.de>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org, 
	liaochang1@huawei.com
Subject: Re: [PATCH] bcachefs: fix incorrect show_options results
Message-ID: <sufy3jfju76sqh4eplc5hmsrfrpa4dtt3bocovfeygxclkvgql@ukd2pvvxn5jr>
References: <20240923095003.3559171-1-lihongbo22@huawei.com>
 <20240923143931.3a24e3c9.ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923143931.3a24e3c9.ddiss@suse.de>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 23, 2024 at 02:39:31PM GMT, David Disseldorp wrote:
> On Mon, 23 Sep 2024 17:50:03 +0800, Hongbo Li wrote:
> 
> > When call show_options in bcachefs, the options buffer is appeneded
> > to the seq variable. In fact, it requires an additional comma to be
> > appended first. This will affect the remount process when reading
> > existing mount options.
> > 
> > Fixes: 9305cf91d05e ("bcachefs: bch2_opts_to_text()")
> 
> Ah, that'd explain why I wasn't seeing this alongside the
> fail-on-unknown-opt fix. FWIW, this first appears in
> bcachefs-2024-09-21 as 3621ecc10f831f4fd27784083dfaf5b8481098b5 .
> 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >  fs/bcachefs/fs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
> > index e774cb3e6b1a..79c3a650b714 100644
> > --- a/fs/bcachefs/fs.c
> > +++ b/fs/bcachefs/fs.c
> > @@ -1927,7 +1927,7 @@ static int bch2_show_options(struct seq_file *seq, struct dentry *root)
> >  	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
> >  			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
> >  	printbuf_nul_terminate(&buf);
> > -	seq_puts(seq, buf.buf);
> > +	seq_printf(seq, ",%s", buf.buf);
> 
> Looks okay, although it might be simpler to just drop the !first
> conditionals from bch2_opts_to_text() as things were prior to the
> regression.
> 
> >  	int ret = buf.allocation_failure ? -ENOMEM : 0;
> 
> Should the copy from buf into seq occur if allocation_failure
> is already flagged? I'd expect seq_puts() to have oopsed.

That's a good point; it might be the first allocation that fails, not a
realloc. It won't be in practice, buuuut....
