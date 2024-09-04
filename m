Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60FB1DA11C
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725467464; cv=none; b=g34oXz3GN6YpduqKVYhbIOEx2jPVx1Gk1brXyxMHyMpaDCZoJEGVLAfiOp6zoFvYWAio3taZJzNycpRObWkZSroMk980OTO8Z/qqOgCTztDzk39W5vjgNseKgq9bNRMSvhZ4gQKoOh1rWYwgd+9LKhXSKvM8/xiDLFSD80sp6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725467464; c=relaxed/simple;
	bh=Kg4S4b/xZkaF//f0XNRs+m1On6nZQOArGO3Yi6YY+js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHihg4kQkLvcWIV8E5wy8teJE9FRvLs6At5gJTos2/DOMiGVUSUYwcjF6AH2+wSu86RuCuIxVJ/nCrn89gQAlFh9pk62sFoYPC39N4ErD13CWte6icVewq1y2ln/gRft3blH2FbPGw9pzVjXONztpaSn4yaepr3fHVfK9IpV4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UCJIIoeP; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UCJIIoeP"
Date: Wed, 4 Sep 2024 12:30:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725467459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQJDb5RyIUhpOdtCpdo72WdiRTDKeiHxOmskrJE3SR4=;
	b=UCJIIoePw3fQbeBVqEgVdbcWAbFcBUdpQ0zkbf3APfz/nD+TbHWcO7aRsFK8Si+RdBvna6
	vemZFxhQkUC5mjVEIbR3zy79UuHpK1XXdYs8bFo7rxc84eswnTw6LL3nepKffkYv1jVb9t
	qCZo5YH8cPLWDD5w0dHVtdUbtcVN7lY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix compilation error for bch2_sb_member_alloc
Message-ID: <jhc6xj7bhrcokxbxyvnezgbdjcaxje5nqyhjqwwzczmidsm3qd@n3u5b72zioy3>
References: <20240904071532.2812271-1-lihongbo22@huawei.com>
 <ea07e075-de91-40cf-ae14-5542f34c48ae@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea07e075-de91-40cf-ae14-5542f34c48ae@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 04, 2024 at 03:12:33PM GMT, Hongbo Li wrote:
> 
> 
> On 2024/9/4 15:15, Hongbo Li wrote:
> > Fix the following compilation error:
> > 
> > ```
> > fs/bcachefs/sb-members.c: In function ‘bch2_sb_member_alloc’:
> > fs/bcachefs/sb-members.c:508:2: error: a label can only be part of a statement and a declaration is not a statement
> >    508 |  unsigned nr_devices = max_t(unsigned, dev_idx + 1, c->sb.nr_devices);
> > ```
> > 
> > Fixes: a7d364a133c7 ("bcachefs: bch2_sb_member_alloc()")
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >   fs/bcachefs/sb-members.c | 16 ++++++++++------
> >   1 file changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> > index 2aad62961938..02bcde3c1b02 100644
> > --- a/fs/bcachefs/sb-members.c
> > +++ b/fs/bcachefs/sb-members.c
> > @@ -478,11 +478,15 @@ unsigned bch2_sb_nr_devices(const struct bch_sb *sb)
> >   int bch2_sb_member_alloc(struct bch_fs *c)
> >   {
> >   	unsigned dev_idx = c->sb.nr_devices;
> > +	struct bch_sb_field_members_v2 *mi;
> > +	unsigned nr_devices;
> > +	unsigned u64s;
> > +	int best = -1;
> > +	u64 best_last_mount = 0;
> > +
> >   	if (dev_idx < BCH_SB_MEMBERS_MAX)
> >   		goto have_slot;
> > -	int best = -1;
> > -	u64 best_last_mount = 0;
> >   	for (dev_idx = 0; dev_idx < BCH_SB_MEMBERS_MAX; dev_idx++) {
> >   		/* eventually BCH_SB_MEMBERS_MAX will be raised */
> >   		if (dev_idx == BCH_SB_MEMBER_INVALID)
> > @@ -505,11 +509,11 @@ int bch2_sb_member_alloc(struct bch_fs *c)
> >   	return -BCH_ERR_ENOSPC_sb_members;
> >   have_slot:
> Or add ";" after this label. But I choice move the declared variables to the
> front. May be this way is more closely to the specifications.

Yeah, the first way is fine - thanks! applied.
