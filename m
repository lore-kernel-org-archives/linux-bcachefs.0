Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE9D199222
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Oct 2024 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727907829; cv=none; b=AlThhY7v748wPFam0vkFf7FdfliG4932jcn12f9CLqg8BBwgxkDAaEjdbHYXaNe4Hj76jwE90q2J/NBbRV9oitpPLXLd6wjmL1xw121LoLfMv2QXGjFp+29m1NTrMf0mSDmdzOxYMJp7UGHjRx0FUH+WDKPJ43LyqI3tNJEbGjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727907829; c=relaxed/simple;
	bh=WVvCANKG1R/Mh/i6YUsuxdAB+u4GzOP800603g+x/QY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aTolzYCgG5fJJgwgPF4RSLrpYoS2dgEch5YDtbe5nzZ2yiZRCFnNBw5hw5u6ghJISgVL0utzjtu8VwolSH8Ut35TpghQppTVeFYUgsniED8B6Ju8gZm/pYknVCNqinAJgfcn5HCGxAJEpUIrxa5iwzqgw4qk7kxKxvJymel6D7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=bKBQ+eBM; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="bKBQ+eBM"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71957eb256bso324501b3a.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 02 Oct 2024 15:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727907827; x=1728512627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dwjrq0eSYmWYSgPDptppz5HY/VTvJD6vQU+3JcRDN44=;
        b=bKBQ+eBMmnS/LBaWKFmtr+KSrf1G+MBhXFzyVV6sOFX0D8NRydLr4M2aCxRwvYjkTx
         yJG+B9M8XEEU5dw5VX2gpvzR4TE71jNTpwUDFBgT7dAanDpf5XxFyVYN2Vt46+X9VkGI
         CZoVBkQyVID50un3zjxddJPlTjDYG1bnHniHwbB0zVJQesM5Y8xNUSOYhaEF4NHZHxxA
         yIii49oclxxuObIeAWPT7fWECL6THEKUmyoWfYidADfOsw5Qoersv7xn6I/23+l2beed
         ULuEN43ySbDw3NY6p8zok0izf08Ha3BKDjJUsAI7hKPj7/8DG0MfLMa19u/R8leClL8k
         7qiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727907827; x=1728512627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwjrq0eSYmWYSgPDptppz5HY/VTvJD6vQU+3JcRDN44=;
        b=b5YXO9Vh3bHB3UzsMVoFLeGTjEw69NLu4lfxlF1CV5rsGavgJnE3EiNco6wyKVDChH
         Cw4lTVuUzHRM4/piUd4UNMSTv5ighzvIGuPlM3WtjMPa62dcf99OjQNP92wrk6Zrwe0T
         k02AV96olXVFPp8Cf+yhCwzixDGuuFcc/qll8oJdBDOzRyrcYO8AgorsgRAXqXCN0pXs
         E71OGca79Uif2hlFZjOiK+2aElF1Oh5RffUFK1xbhL7SPKaY8jjewJ/yR1FKtfyaSrHZ
         UnODIpG04soGxlWoeE94Fl4D+0M+ndi2NzGxcbMyWaa7LCUt1iBu3Q4Ffw1iZy91tC7G
         nmeg==
X-Forwarded-Encrypted: i=1; AJvYcCVU0hOSO19IjcZDuEBhwo8sF5Gg8vDQM60DR8No1xbgbLF/EPzv40eIvKg2az6FrSskO3H7t7zmdBo1JW6OpA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFupziT2AoXksFj3MAIeGzhEQbo7vWZlnJ9o923pkWZDkWeDZa
	MTqCJu+MlJVFIur33+m7//Vus5tJ5Jd6fdcFwtkvTfvL2sjPPPYHtCNn6DXCLWw=
X-Google-Smtp-Source: AGHT+IHOUZOP6Uc7lQ6NhVDS50LjXjhgskC9in5V5GtR9ajsn30Oi2N7nWLojrTJp90Pfg7z+9MFAw==
X-Received: by 2002:a05:6a00:178c:b0:706:29e6:2ed2 with SMTP id d2e1a72fcca58-71dc5c4dc69mr7513289b3a.5.1727907827485;
        Wed, 02 Oct 2024 15:23:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2649878fsm10369400b3a.36.2024.10.02.15.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 15:23:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sw7l2-00D7oS-0w;
	Thu, 03 Oct 2024 08:23:44 +1000
Date: Thu, 3 Oct 2024 08:23:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] vfs: improving inode cache iteration scalability
Message-ID: <Zv3H8BxJX2GwNW2Y@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002-lethargisch-hypnose-fd06ae7a0977@brauner>
 <Zv098heGHOtGfw1R@dread.disaster.area>
 <3lukwhxkfyqz5xsp4r7byjejrgvccm76azw37pmudohvxcxqld@kiwf5f5vjshk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3lukwhxkfyqz5xsp4r7byjejrgvccm76azw37pmudohvxcxqld@kiwf5f5vjshk>

On Wed, Oct 02, 2024 at 03:29:10PM -0400, Kent Overstreet wrote:
> On Wed, Oct 02, 2024 at 10:34:58PM GMT, Dave Chinner wrote:
> > On Wed, Oct 02, 2024 at 12:00:01PM +0200, Christian Brauner wrote:
> > > On Wed, Oct 02, 2024 at 11:33:17AM GMT, Dave Chinner wrote:
> > > > What do people think of moving towards per-sb inode caching and
> > > > traversal mechanisms like this?
> > > 
> > > Patches 1-4 are great cleanups that I would like us to merge even
> > > independent of the rest.
> > 
> > Yes, they make it much easier to manage the iteration code.
> > 
> > > I don't have big conceptual issues with the series otherwise. The only
> > > thing that makes me a bit uneasy is that we are now providing an api
> > > that may encourage filesystems to do their own inode caching even if
> > > they don't really have a need for it just because it's there.  So really
> > > a way that would've solved this issue generically would have been my
> > > preference.
> > 
> > Well, that's the problem, isn't it? :/
> > 
> > There really isn't a good generic solution for global list access
> > and management.  The dlist stuff kinda works, but it still has
> > significant overhead and doesn't get rid of spinlock contention
> > completely because of the lack of locality between list add and
> > remove operations.
> 
> There is though; I haven't posted it yet because it still needs some
> work, but the concept works and performs about the same as dlock-list.
> 
> https://evilpiepirate.org/git/bcachefs.git/log/?h=fast_list
> 
> The thing that needs to be sorted before posting is that it can't shrink
> the radix tree. generic-radix-tree doesn't support shrinking, and I
> could add that, but then ida doesn't provide a way to query the highest
> id allocated (xarray doesn't support backwards iteration).

That's an interesting construct, but...

> So I'm going to try it using idr and see how that performs (idr is not
> really the right data structure for this, split ida and item radix tree
> is better, so might end up doing something else).
> 
> But - this approach with more work will work for the list_lru lock
> contention as well.

....  it isn't a generic solution because it is dependent on
blocking memory allocation succeeding for list_add() operations.

Hence this cannot do list operations under external synchronisation
constructs like spinlocks or rcu_read_lock(). It also introduces
interesting interactions with memory reclaim - what happens we have
to add an object to one of these lists from memory reclaim context?

Taking the example of list_lru, this list construct will not work
for a variety of reasons. Some of them are:

- list_lru_add() being called from list_lru_add_obj() under RCU for
  memcg aware LRUs so cannot block and must not fail.
- list_lru_add_obj() is called under spinlocks from inode_lru_add(),
  the xfs buffer and dquot caches, the workingset code from under
  the address space mapping xarray lock, etc. Again, this must not
  fail.
- list_lru_add() operations take can place in large numbers in
  memory reclaim context (e.g. dentry reclaim drops inodes which
  adds them to the inode lru). Hence memory reclaim becomes even
  more dependent on PF_MEMALLOC memory allocation making forwards
  progress.
- adding long tail list latency to what are currently O(1) fast path
  operations (e.g.  mulitple allocations tree splits for LRUs
  tracking millions of objects) is not desirable.
- LRU lists are -ordered- (it's right there in the name!) and this
  appears to be an unordered list construct.

So while I think this is an interesting idea that might be useful in
some cases, I don't think it is a viable generic scalable list
construct we can use in areas like list_lru or global list
management that run under external synchronisation mechanisms.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
