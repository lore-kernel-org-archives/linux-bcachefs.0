Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB90ECF
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 04:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728707138; cv=none; b=S/Cy3vPo4eBq6+niqCT2OjTAU+WnStUlebISWwSr2JsESrgOZox6nBT1boBnyFlUtFuOVMNhXyj0+Y3DskjxrTuQNHRS3CtItUG39Dz+YtvYQJr3f808aO3zT+V/dVEgRvUI70sMMbQoo2wHGIsJCdrR1Vo8Ry+TRreR/gYdST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728707138; c=relaxed/simple;
	bh=hmGqcKcY789w7h4nkQ2AmPyaj2SEALIuRNEhDVfLTm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieAq1/NGq9KHCY7YehD2EMwYLCW5hTazYRKRg/+qpV/CGH23kL1+Ft9msf+KRJGTcJVnbBJrSUl78uh5ZYRUmvxKPHR1xY4u+n6xI+Tyx59GpBppR5+pSgFn1GmW08RaatYkyDD4Wn9OPGF+0TCFndCex22s09+0Bn9nP1Y4/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XJ216GLK; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XJ216GLK"
Date: Sat, 12 Oct 2024 00:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728707134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HDYHUx8Wnz/F66RdwbA/z0KkOAacazohUO5bCWJZPWA=;
	b=XJ216GLKM2GvikB+fQi+udE/gCEKc8wHMC2tVCVnp0+yRzp0mmtTCefXSlWKzI8nwbdBit
	dcjXq9g/4Pm4gHutxBMlKJsnWW/kygBp3PGl+9wvLuOZ9CTdTC8snly4VVKKqmRS1fCMb6
	Ju5pe8AnTtt6sWpgbsrJ6Gm5ok16uTk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix invalid shift in member_to_text()
Message-ID: <n3xk3j3gu43gdnrlrkca6xkcyd2rwdvwowmvyvafzqxqgyt5np@lgsfdqvispus>
References: <20241012020953.3306834-1-kent.overstreet@linux.dev>
 <e15d904d-1a0b-4492-94e4-8fe6db6a22ac@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e15d904d-1a0b-4492-94e4-8fe6db6a22ac@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 12, 2024 at 11:37:27AM GMT, Hongbo Li wrote:
> 
> 
> On 2024/10/12 10:09, Kent Overstreet wrote:
> > Reported-by: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >   fs/bcachefs/sb-members.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> > index 02bcde3c1b02..b06ba1d0d037 100644
> > --- a/fs/bcachefs/sb-members.c
> > +++ b/fs/bcachefs/sb-members.c
> > @@ -247,7 +247,10 @@ static void member_to_text(struct printbuf *out,
> >   	prt_newline(out);
> >   	prt_printf(out, "Btree allocated bitmap blocksize:\t");
> > -	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> > +	if (m.btree_bitmap_shift < 64)
> > +		prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> > +	else
> > +		prt_printf(out, "(invalid shift %u)", m.btree_bitmap_shift);
> 
> I wonder why we don't check in .validate, like the former
> csum_granularity_bits does.

actually we need to do both; we want to be able to print things that
don't validate so that we can debug. I'll make that change, thanks
