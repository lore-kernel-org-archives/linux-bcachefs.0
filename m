Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86410FF
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 19:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710964658; cv=none; b=WHZFZBxkHw5VqUhM/ey6SYWjqanGD6PAntfA1vJcwQ0UZEeLI1GdGgevq2w+dB+lrkASd7OSBpBrjA17381n0QFOTxUaDM4qIFw4irX5XXs/JtPO1FVZRXP6SatIB8CimKiqzk8FP/8+IsouQ0Em43pVBW2HCgBVrMxLgLu7ESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710964658; c=relaxed/simple;
	bh=CgafMsHaMOLCU0ErG9a6IrAq4ku7yaVLCQiXnCCZ7T0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAjctrGjYBL9jTDT78qI9CC8qSxcniu1bAlT9vZiQLXvfS9iJRdNmYnln7YKNRnN0gtFYcEn4pd6VTtVGwLcgrn4xWgoVKJnHOrJtqlnVCXRzKyF2qemVLpFzpZY6RJf0mqbrbV8BgcOwYrQwzuxEyVkBw9kEwAqRF0Hp4NCVOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=poy5DLGd; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="poy5DLGd"
Date: Wed, 20 Mar 2024 15:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710964654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rlIi1jn5SPBGSlU0ZL3qwVhWPYcqGfuTGmCu75bm3E=;
	b=poy5DLGd2olYOCmT0zoE3G1IKgAIOtNDeV83yLWHf/9Ak1AcgqTq3Zv64n/oPdqGdvLEJc
	wHiHqpAIhFU3ZYVmjBxAKh/vbFHfjYeNB/M+9uWAjIN54pXMVD5r7prnmIjO5h/WXiTTBd
	kprCAJMT9rDO7bJFgdColPDcQCxSGO8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] bcachefs: use btree_path_state to represent
 btree_path status
Message-ID: <wjhkm67yim5irw2jodqbj6vx53orixmt3g3jc4lhysvwknz2iy@cozso6u3e7gs>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-2-lihongbo22@huawei.com>
 <ZfsfZby1X6XAbhql@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfsfZby1X6XAbhql@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 01:39:49PM -0400, Brian Foster wrote:
> On Wed, Mar 20, 2024 at 02:29:22PM +0800, Hongbo Li wrote:
> > First, the old structure cannot clearly represent the state changes
> > of btree_path (such as BTREE_ITER_xxx). Secondly, the member (
> > btree_path->uptodate) cannot express its purpose intuitively. It's
> > essentially a state value if I understand correctly. Using this way
> > can makes the representation of member variables more reasonable.
> > 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >  fs/bcachefs/btree_iter.c         | 22 +++++++++++-----------
> >  fs/bcachefs/btree_iter.h         |  6 +++---
> >  fs/bcachefs/btree_key_cache.c    | 12 ++++++------
> >  fs/bcachefs/btree_locking.c      | 14 +++++++-------
> >  fs/bcachefs/btree_locking.h      |  8 ++++----
> >  fs/bcachefs/btree_trans_commit.c |  2 +-
> >  fs/bcachefs/btree_types.h        | 10 +++++-----
> >  7 files changed, 37 insertions(+), 37 deletions(-)
> > 
> ...
> > diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
> > index 9404d96c38f3..7146d6cf9fba 100644
> > --- a/fs/bcachefs/btree_types.h
> > +++ b/fs/bcachefs/btree_types.h
> > @@ -218,10 +218,10 @@ static const __maybe_unused u16 BTREE_ITER_CACHED_NOFILL	= 1 << 13;
> >  static const __maybe_unused u16 BTREE_ITER_KEY_CACHE_FILL	= 1 << 14;
> >  #define __BTREE_ITER_FLAGS_END					       15
> >  
> > -enum btree_path_uptodate {
> > -	BTREE_ITER_UPTODATE		= 0,
> > -	BTREE_ITER_NEED_RELOCK		= 1,
> > -	BTREE_ITER_NEED_TRAVERSE	= 2,
> > +enum btree_path_state {
> > +        UPTODATE		= 0,
> > +        NEED_RELOCK		= 1,
> > +        NEED_TRAVERSE		= 2
> >  };
> >  
> >  #if defined(CONFIG_BCACHEFS_LOCK_TIME_STATS) || defined(CONFIG_BCACHEFS_DEBUG)
> > @@ -241,7 +241,7 @@ struct btree_path {
> >  	enum btree_id		btree_id:5;
> >  	bool			cached:1;
> >  	bool			preserve:1;
> > -	enum btree_path_uptodate uptodate:2;
> > +	enum btree_path_state   status:2;
> 
> Personally I don't mind the field rename, but the loss of any prefix on
> the flags urks me a bit. Any reason not to use something like
> BTREE_PATH_UPTODATE..?
> 
> It also would be nice to be consistent between the field and enum names.
> Perhaps rename the field to 'state' if it's of type btree_path_state?
> 
> Finally, if we are going to tweak this, it seems like a nice opportunity
> to add a comment above btree_path_state to (briefly) explain what each
> state means and perhaps how they relate.
> 
> Just my .02 of course. ;)

yes, there should always be a prefix

I'm also leaning more and more towards defining /all/ enums with
x-macros; that gets us array-of-names-as-strings for free and just makes
debugging so much nicer than having to remember what integers correspond
to
