Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3E81AF0D3
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 11:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729769422; cv=none; b=mgQzp4T2EkgoHG4EFovfnSwrX49HV/8dHD2NxO6n6eVFxmuR5D2QVtm475/mFnp312B6l9ByfTcE7erKdOXV+D7iO/QqktwMVw7r0684uVZ5hljSY1mAUeWGKOXvdWEnc+VXEsKlZGHZkZ/IrfK52xuwo5M7xhL6C9RIhumorSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729769422; c=relaxed/simple;
	bh=gqCwOa6WUDvOOY/KfgF4EVFQFU95tHUNA/x7kfIBcLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNUEs5bBHsASOig6uPdAQyrkO5NNtTKzqnB7Kyt2+BUqg4G6YlPyOenbLA4jwJhBPXrKx4tQvyM0Uw0BtcrueSfgw5ivON6CTBBIyvTqDUpHtRKGREsC7r1ifZgRfSF5KgFDHG/w08bP/IjCelryuMMI0CK/zPZF6iVJrUx+n0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SB1ItGz4; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SB1ItGz4"
Date: Thu, 24 Oct 2024 07:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729769417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uvpXFdO1fMRPhRKLb0e0DbG2kGykG6FHwbUwvY7MxmA=;
	b=SB1ItGz40uIYq4i26qPBSmlvT6Ze853rYaRj3zLkCnWaUD569Lh6XdCWfExwR9HV53UH2g
	q1WI7esOLMX4tQbnHPa0le+2cbXb43y5YGyBQCl1Wvukg+NnfG+xGXyl8eW2q6lae7JImK
	H2Yxtf7FP0VGsKHs6gsuUN8XRJKx7pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Jeongjun Park <aha310510@gmail.com>, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Message-ID: <5a2uq4p74ilwtgnq47qlceiwceyttx7zqgovn7ph3jyuaf2dlm@2rqzwizdamdc>
References: <20241021154356.38221-1-aha310510@gmail.com>
 <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e46f070-3e78-4a81-b7c7-ea021271b12b@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 22, 2024 at 10:26:18AM +0800, Hongbo Li wrote:
> 
> 
> On 2024/10/21 23:43, Jeongjun Park wrote:
> > The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
> > To fix this, we need to add validation on a.data_type in
> > alloc_lru_idx_fragmentation().
> > 
> > Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> > Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > ---
> >   fs/bcachefs/alloc_background.h | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
> > index f8e87c6721b1..163a67b97a40 100644
> > --- a/fs/bcachefs/alloc_background.h
> > +++ b/fs/bcachefs/alloc_background.h
> > @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
> >   static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
> >   					      struct bch_dev *ca)
> >   {
> > +	if (a.data_type >= BCH_DATA_NR)
> > +		return 0;
> > +
> 
> oh, I found I have done the same thing in [1]("Re: [syzbot] [bcachefs?]
> UBSAN: shift-out-of-bounds in bch2_alloc_to_text"). But in my humble
> opinion, the validation changes also should be added. And in addition, move
> the condition about a.data_type into data_type_movable will be better. Just
> my personal opinion.:)

Unknown data types (and key types, btree IDs, etc.) are allowed for
forwards compatibility - they should just be ignored
