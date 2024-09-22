Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CB22C95
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727010103; cv=none; b=sJ1V+aPeYbVXbr1BQWztREh3nT8G2+FDRcjPtYOdYuGMDw+QfMSe54Jheout3iypDSlTYAli0hJa8LP9lpXnVSM8J7eMXW0kMQLekSfPv+0kCwbmFKe03VZhgjVAORgD87jHs0Vb31JsAcObfDknZ+gf8H6IasU6y9LNXSYrGuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727010103; c=relaxed/simple;
	bh=w7ignNwAUjgKE88MKV4rSraNJf+14vjnp7NEQZSGUXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOLFdnYRBnhZg+nf9bXtYxoeKRqCduYT6AY+/aZyQXIFJP0TJdjnFCFlQVMe6vLXRKZQNJf1Hz/y3A2KGt07t5GeqpkYOUFi/toG4k2CEv3yRR5rOnDbLoSVC+c9zCI6BIWLWWZ/aEd/8YSGBXALIVNXjX6sTCZ6TD5SdzSSSoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xIERoA5p; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xIERoA5p"
Date: Sun, 22 Sep 2024 09:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727010098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DU7kZSFllaH5n+JDlLu+UutJOi6tO+GS2RXmP75/jP0=;
	b=xIERoA5peMzoBRBFk5qxr9XpCyFBFKpUwp4ETwDt9Qr+Y00VC3NjzUC0/TviCShozBLmmQ
	rggOTbTeH5sA42j0Awzegu62PDIt7ndl2xmOKsYv9NgxJ58cKjMNdcBge3y559GmwRoN2h
	Et1Qw+h4rKfgYJthaGEMbiqSg8Upmwc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: add GFP_ZERO flag in btree_bounce_alloc
Message-ID: <bkmt2z7b6o3bhbzkwvkg4gr6ikem6ojclg63g26qg4gxi67uhv@w4gstbihgwtj>
References: <20240916224746.692973-1-pZ010001011111@proton.me>
 <frpohbqgpyhd6fkwkd5h6efqiph27mgmcbex3bipmksyc2vocp@tfz6oynigmgi>
 <uDWtvpxzXCkjTZVPdrrhrF_wVv8J6JS1gb1Cy_l6uM6houxjn23qXxT4u8YxzVRJrh0LnMIBOa8Zl_NIVyWZPblDTblYi_VJ357130uk0q4=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uDWtvpxzXCkjTZVPdrrhrF_wVv8J6JS1gb1Cy_l6uM6houxjn23qXxT4u8YxzVRJrh0LnMIBOa8Zl_NIVyWZPblDTblYi_VJ357130uk0q4=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 22, 2024 at 12:40:07PM GMT, Piotr Zalewski wrote:
> 
> On Saturday, September 21st, 2024 at 8:47 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Mon, Sep 16, 2024 at 10:47:57PM GMT, Piotr Zalewski wrote:
> > 
> > > Add __GFP_ZERO flag to kvmalloc call in btree_bounce_alloc to mitigate
> > > later uinit-value use KMSAN warning[1].
> > > 
> > > After applying the patch reproducer still triggers stack overflow[2] but
> > > it seems unrelated to the uninit-value use warning. After further
> > > investigation it was found that stack overflow occurs because KMSAN adds
> > > additional function calls. Backtrace of where the stack magic number gets
> > > smashed was added as a reply to syzkaller thread[3].
> > > 
> > > I confirmed that task's stack magic number gets smashed after the code path
> > > where KSMAN detects uninit-value use is executed, so it can be assumed that
> > > it doesn't contribute in any way to uninit-value use detection.
> > > 
> > > [1] https://syzkaller.appspot.com/bug?extid=6f655a60d3244d0c6718
> > > [2] https://lore.kernel.org/lkml/66e57e46.050a0220.115905.0002.GAE@google.com
> > > [3] https://lore.kernel.org/all/rVaWgPULej8K7HqMPNIu8kVNyXNjjCiTB-QBtItLFBmk0alH6fV2tk4joVPk97Evnuv4ZRDd8HB5uDCkiFG6u81xKdzDj-KrtIMJSlF6Kt8=@proton.me
> > > 
> > > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > 
> > 
> > Oh hey, nice find :)
> 
> Hi!
> 
> > We should be able to fix this in a more performant way, though; btree
> > node resort is a path where we do care about performance, we don't want
> > to touch the whole buffer more times than necessary.
> > 
> > Can you try zeroing out the portion after what we consumed, after we
> > sort into the bounce buffer?
> 
> Do you mean something like this? :
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 56ea9a77cd4a..c737ece6f628 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -1195,6 +1195,10 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
>  	set_btree_bset(b, b->set, &b->data->keys);
>  
>  	b->nr = bch2_key_sort_fix_overlapping(c, &sorted->keys, iter);
> +	memset((uint8_t*)(sorted + 1) + b->nr.live_u64s * sizeof(u64), 0,
> +			btree_buf_bytes(b) -
> +			sizeof(struct btree_node) -
> +			b->nr.live_u64s * sizeof(u64));
>  
>  	u64s = le16_to_cpu(sorted->keys.u64s);
>  	*sorted = *b->data;
> 
> I tested that above doesn't trigger uinit-value usage.
> 
> Best regards, Piotr Zalewski

Yeah, I think that should do it :)

Send it, I'll apply it...
