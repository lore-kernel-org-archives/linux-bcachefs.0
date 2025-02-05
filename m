Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DA22F46
	for <linux-bcachefs@vger.kernel.org>; Wed,  5 Feb 2025 03:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724568; cv=none; b=aHtfQ4xFiO7Cx3bGoov8hWU9mOVGsgRui5oU+xNX4Q6urm/bG3Qd7nJasRfys6qsRT/K54zHAtvfKRQgOVCAkVKC8WPMSOPkCH7i8oWLm44DsM2/pVEn+e+5oa0wfyB4jXp0i8d/r//B7xWiAASJopb5ElOaFc+fFM/7ivS9zKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724568; c=relaxed/simple;
	bh=erYKl0N0wPrBObveS2+hN5xA2PjPW28RuLuNZwKRbEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRgW+mVlyfa1XodC4YYH3HoUF/COYYRQgoyuQaGEP3GxA6tq/hbIDkbiBPJ3tJM7CtTcn1gAHOsemik+3u+HcluOUSHsBgmrz9NtV+u1JShgQ7O4SuAmmSLd3k+bzyJTeb7qi75oOw9y+pQK80Rae+UjWshEnHXGPu6XLMU3suQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CtWUQS1T; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CtWUQS1T"
Date: Tue, 4 Feb 2025 22:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738724557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPnt7Sc74/MtugocWDhsv45pojcg3Z9s+neQMliFAVU=;
	b=CtWUQS1Tecl8U3jo67KBMTcTzeQDE2W5FtU3C7GJkvlONhepGWQEPSP8Yo+3dQliSihgnW
	sO8skCKTeKcKhCDi4THIt/5Chg6cBXGbLaWidE79RcYusYMM3mwB/fY4rZK6oWngjRxkN/
	CApel5doSsoZFKz5jEUfvEIZaJdKdus=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: BCH_IOCTL_QUERY_COUNTERS
Message-ID: <eyjs4zpq4rt2vjhbqfj65qf47whqakwqmeuz3k4zimio7iclq3@bxbldbtwrvfk>
References: <20250129204950.222472-1-kent.overstreet@linux.dev>
 <f7f99f3a-2f1a-4e9c-ad2f-2b182142761d@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7f99f3a-2f1a-4e9c-ad2f-2b182142761d@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 10:23:32AM +0800, Hongbo Li wrote:
> 
> 
> On 2025/1/30 4:49, Kent Overstreet wrote:
> > Add an ioctl for querying counters, the same ones provided in
> > /sys/fs/bcachefs/<uuid>/counters/, but more suitable for a 'bcachefs
> > top' command.
> > 
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >   fs/bcachefs/bcachefs_ioctl.h | 10 ++++++++++
> >   fs/bcachefs/chardev.c        | 32 ++++++++++++++++++++++++++++++++
> >   fs/bcachefs/sb-counters.c    |  2 +-
> >   fs/bcachefs/sb-counters.h    |  1 +
> >   4 files changed, 44 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
> > index 3c23bdf788ce..f1b746fac007 100644
> > --- a/fs/bcachefs/bcachefs_ioctl.h
> > +++ b/fs/bcachefs/bcachefs_ioctl.h
> > @@ -87,6 +87,7 @@ struct bch_ioctl_incremental {
> >   #define BCH_IOCTL_FSCK_OFFLINE	_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
> >   #define BCH_IOCTL_FSCK_ONLINE	_IOW(0xbc,	20,  struct bch_ioctl_fsck_online)
> >   #define BCH_IOCTL_QUERY_ACCOUNTING _IOW(0xbc,	21,  struct bch_ioctl_query_accounting)
> > +#define BCH_IOCTL_QUERY_COUNTERS _IOW(0xbc,	21,  struct bch_ioctl_query_counters)
> >   /* ioctl below act on a particular file, not the filesystem as a whole: */
> > @@ -443,4 +444,13 @@ struct bch_ioctl_query_accounting {
> >   	struct bkey_i_accounting accounting[];
> >   };
> > +#define BCH_IOCTL_QUERY_COUNTERS_MOUNT	(1 << 0)
> > +
> > +struct bch_ioctl_query_counters {
> > +	__u16			nr;
> > +	__u16			flags;
> > +	__u32			pad;
> > +	__u64			d[];
> > +};
> > +
> >   #endif /* _BCACHEFS_IOCTL_H */
> > diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> > index 46e9e32105a9..c2d9efe8db53 100644
> > --- a/fs/bcachefs/chardev.c
> > +++ b/fs/bcachefs/chardev.c
> > @@ -448,6 +448,36 @@ static long bch2_ioctl_query_accounting(struct bch_fs *c,
> >   	return ret;
> >   }
> > +static long bch2_ioctl_query_counters(struct bch_fs *c,
> > +			struct bch_ioctl_query_counters __user *user_arg)
> > +{
> > +	struct bch_ioctl_query_counters arg;
> > +	int ret = copy_from_user_errcode(&arg, user_arg, sizeof(arg));
> > +	if (ret)
> > +		return ret;
> > +
> > +	if ((arg.flags & !BCH_IOCTL_QUERY_COUNTERS_MOUNT) ||
> > +	    arg.pad)
> > +		return -EINVAL;
> > +
> > +	arg.nr = min(arg.nr, BCH_COUNTER_NR);
> > +	ret = put_user(arg.nr, &user_arg->nr);
> This will change the input parameter @nr (records the size of filling
> space). Instead, how about introducing the extra parameter @max to keep the
> input array size?

Well, this is the pattern I've been doing so far through the other
bcachefs ioctls that return arrays, so I'm inclined to stick with that.

Although your idea is a good one, that would be more standard - we'd be
returning something more like just a darray.
