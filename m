Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF912BF14
	for <linux-bcachefs@vger.kernel.org>; Wed, 21 Feb 2024 23:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559521; cv=none; b=a/PZEw2+XzJgyW+QkXOsMwx2aEL3ji4rTLLYRYYEY2LDMwh1eo5dihb9N1vJH7l6NYuT8EbfBeh9nZU/p4P9KqmbL4f1Hk0jtaCARAiQ2eh1vc76EluiVC5phrGdzyWn2EGUUHLqeRc/rXxdUHVSgMc1rVhEOvD5PILX+cn4+/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559521; c=relaxed/simple;
	bh=aTq3iJxb154Tyx11kmWvdRlkIGKnhvAoAlkSGteEewY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETd1M/+B5/wRR0Hl4eN4OEv2GMjh9P2+2IFx2SFv1dKwdao+ONs6BHv4f5IEjfucDDIcignM010PICeVR0ZaIa/qff+c7IPuxIyzqZxr7sgt+kB2Aq5Kc29C9DEblBKjJzFDk3AWF87EgdfGExrlbGjT646Q08ixTJIfzDoW0rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VrvbDnew; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VrvbDnew"
Date: Wed, 21 Feb 2024 18:51:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708559517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H2VFzXRPfNk1fZnjwn8LBW0u5NZTArsitedBKIFXm70=;
	b=VrvbDnew+2jOaSHSEl/G/3U6vt1b93lmZWLfsyiltajJytUMRGH+8c0eTHfqnYwbxAld9H
	Nna9/avWVAIqyYi/XKtVHfK3NM3gNECMtkTehxoRyn/88PVPO0+7v5u/OXO7YnohcdU+kh
	IbY0jQodeP7RRpPTIUftCY9aOw+h3As=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org, 
	ruanjinjie@huawei.com, chris.zjh@huawei.com
Subject: Re: [PATCH] bcachefs: intercept mountoption value for bool type
Message-ID: <if2d3bmpvm3hvkgahyn5umjdnfwrtft7567opyr6k2bmwxcf4b@gm34y24jpeqy>
References: <20240221093704.3924287-1-lihongbo22@huawei.com>
 <ZdX8ek1o6MQErZMr@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdX8ek1o6MQErZMr@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 21, 2024 at 08:36:58AM -0500, Brian Foster wrote:
> On Wed, Feb 21, 2024 at 05:37:04PM +0800, Hongbo Li wrote:
> > For mount option with bool type, the value must be 0 or 1 (See
> > bch2_opt_parse). But this seems does not well intercepted cause
> > for other value(like 2...), it returns the unexpect return code
> > with error message printed.
> > 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >  fs/bcachefs/opts.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> > index b1ed0b9a20d3..fe1f17830694 100644
> > --- a/fs/bcachefs/opts.c
> > +++ b/fs/bcachefs/opts.c
> > @@ -314,7 +314,7 @@ int bch2_opt_parse(struct bch_fs *c,
> >  		if (ret < 0 || (*res != 0 && *res != 1)) {
> >  			if (err)
> >  				prt_printf(err, "%s: must be bool", opt->attr.name);
> > -			return ret;
> > +			return ret < 0 ?: -EINVAL;
> 
> It might be nice for that error message to be more specific in that the
> bool value must be 0 or 1, but LGTM regardless:

Please give this a distinct private error code as well (just like we
discussed in the previous patch)

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  		}
> >  		break;
> >  	case BCH_OPT_UINT:
> > -- 
> > 2.34.1
> > 
> 
