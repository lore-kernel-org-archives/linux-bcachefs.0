Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F233FE36
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709263791; cv=none; b=MreWN0ZtvFmFQaojVE+OyyCK81ney1Fu5NghOTQ/2bDO3i+PeGEGPqtWIezIdRszBEPxck1Q5Tp4gJ/YudPOIGhyOD8F1op0k6US5M+r/kRTYhRESj0YTX9IAJPNUvaH73W2bnZ60q5kh2ZcMjUWzLRFb3lvC0PvKBeZaXD9AYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709263791; c=relaxed/simple;
	bh=XDNUQnfzFqxaZPLcm6KXRcG7WeicsHrZXCmmsg9j7Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ywl5MJ4DJKSO06s+g9gWwV5zYs9L2sPYfeGqmfnH4he5BCzsFq5rnmr2y2CFcpclA0DOELASOLYss7WdNLdkKmxHeEDQm6BCcbm0K9LZlDzR98sFtie6fWNEVub980jiM1I1W/kV+zhdExUxCW2dSbucUn+TEBCFUA9MFX2n6gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kGCSbCPi; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kGCSbCPi"
Date: Thu, 29 Feb 2024 22:29:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709263787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ul822VaDRdyLG289vz9VPxrjoBMUpnEKmwvhqjAC8kY=;
	b=kGCSbCPiQ2BD3nfnos+MobYMlJzIAZuu5sXao/Fa0nNe4gZ7DWL3X4e9WRM3kUYDdI6Faw
	zFqWhQHHgwX0koA83FKK684NeF+sRiPajowBStUpkExepFjTyS6Qo/7D+7L91sQsWQvM+x
	3k2AeO5KKLjXYdKT/pVC+fYOp0fsPcg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, bfoster@redhat.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: avoid returning private error code in
 bch2_xattr_bcachefs_set
Message-ID: <nrmumxwn6hpgjawvwq2d4vjs2mnj3ejgvuc4ua63fxv6kif6eo@w2yrsmmhqv2d>
References: <20240301031745.1912157-1-lihongbo22@huawei.com>
 <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 01, 2024 at 11:26:51AM +0800, Jinjie Ruan wrote:
> 
> 
> On 2024/3/1 11:17, Hongbo Li wrote:
> > Avoid the private error code return to caller. The error code
> > should be transformed into genernal error code.
> > 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >  fs/bcachefs/xattr.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > index 9c0d2316031b..754f17bba68e 100644
> > --- a/fs/bcachefs/xattr.c
> > +++ b/fs/bcachefs/xattr.c
> > @@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
> >  		kfree(buf);
> >  
> >  		if (ret < 0)
> > -			return ret;
> > +			goto err_class_exit;
> >  
> >  		ret = bch2_opt_check_may_set(c, opt_id, v);
> >  		if (ret < 0)
> > -			return ret;
> > +			goto err_class_exit;
> >  
> >  		s.v = v + 1;
> >  		s.defined = true;
> > @@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
> >  	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
> >  		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
> >  
> > +err_class_exit:
> >  	return bch2_err_class(ret);
> 
> 那前面的return -ENOMEM和return -EINVAL不用转换吗

Don't follow?
