Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C295405DC
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Mar 2024 03:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265279; cv=none; b=KfKrgIejRDnIFBTWnHSch/7LHgFOj1C8IoT+ijv+btreQrWWysjnfjh56gGY2xx/LV9+MwmK7SJ8MBrM33ndNkULn8leoqAxwbnj9GQUkhkEFhrJNvQ369AzTASfcxf+rRujU0AVWo98NTLW3K7BVatoWmFZTX3MDZkPOpFFuN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265279; c=relaxed/simple;
	bh=+C6EPBO8PXxWs/3Lqts69JRcoxRwpYhNwyKZvnDQfFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ODgPDY74kJVjJi+o3TOH7V9Fm+9QQ/bfl9UqvI3DnFtGY3EFwAk4EiuYidm2a+U4aHMTNyUkkj6BSIRUbmNlbju/4MZ58BklH3mdUYo3nC0f/olUvKBWu6GvjSJY3S4BY/8p5pA/kmrgbXf62Nfp0jIAnno3ljh/PX7yfrQ82ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pxq/U2I+; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pxq/U2I+"
Date: Thu, 29 Feb 2024 22:53:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709265275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2eVTTjx4OQJN/sXKkTUpLUd42i6G4Bf24OhY0EaIk4I=;
	b=Pxq/U2I+3bdUGa4wvfXMTJkq0V2yvnsnJsFwDA9ue91EUullKAKk9eH3VGovHGN2KBGCN7
	QFacCn4RgWL8E6ZE4JyPHYVaTl2GrNHR0JiMtMivNtOdvAOOQth1efv6sW7BHa5Et5/HdU
	wc6Pq+8kIO6Ak5bIdMK2x6UlFrl3jc0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>, bfoster@redhat.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: avoid returning private error code in
 bch2_xattr_bcachefs_set
Message-ID: <dt7bqnq6nptck4s4efbejyz6yupwkqhkl4ypuutzazr5imwxfo@q3laxq364x67>
References: <20240301031745.1912157-1-lihongbo22@huawei.com>
 <27c97dbd-cbc1-f6d3-9114-3eaf27d86c48@huawei.com>
 <nrmumxwn6hpgjawvwq2d4vjs2mnj3ejgvuc4ua63fxv6kif6eo@w2yrsmmhqv2d>
 <8fc75160-69ae-49e1-b89a-550c2ad1e09e@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fc75160-69ae-49e1-b89a-550c2ad1e09e@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 01, 2024 at 11:41:43AM +0800, Hongbo Li wrote:
> Here, ENOMEM and EINVAL are not from internal interface. So I think these
> can return directly.

It's a good patch though, it makes things more consistent so we don't
accidentally get tripped up later - I'm applying it.

> 
> On 2024/3/1 11:29, Kent Overstreet wrote:
> > On Fri, Mar 01, 2024 at 11:26:51AM +0800, Jinjie Ruan wrote:
> > > 
> > > 
> > > On 2024/3/1 11:17, Hongbo Li wrote:
> > > > Avoid the private error code return to caller. The error code
> > > > should be transformed into genernal error code.
> > > > 
> > > > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > > > ---
> > > >   fs/bcachefs/xattr.c | 5 +++--
> > > >   1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
> > > > index 9c0d2316031b..754f17bba68e 100644
> > > > --- a/fs/bcachefs/xattr.c
> > > > +++ b/fs/bcachefs/xattr.c
> > > > @@ -544,11 +544,11 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
> > > >   		kfree(buf);
> > > >   		if (ret < 0)
> > > > -			return ret;
> > > > +			goto err_class_exit;
> > > >   		ret = bch2_opt_check_may_set(c, opt_id, v);
> > > >   		if (ret < 0)
> > > > -			return ret;
> > > > +			goto err_class_exit;
> > > >   		s.v = v + 1;
> > > >   		s.defined = true;
> > > > @@ -595,6 +595,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
> > > >   	     (opt_id == Opt_compression && !inode_opt_get(c, &inode->ei_inode, background_compression))))
> > > >   		bch2_set_rebalance_needs_scan(c, inode->ei_inode.bi_inum);
> > > > +err_class_exit:
> > > >   	return bch2_err_class(ret);
> > > 
> > > 那前面的return -ENOMEM和return -EINVAL不用转换吗
> > 
> > Don't follow?
