Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7F33062
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 20:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967818; cv=none; b=YqObslSeS3Uj6RX75m9JQ5aNntuYsetch+4Xatw3EwLJ0eQH5t5AJRyoNckzmotDOVHomBf61bsi9lj0uWP2k3npfp58bGLdkH0KfyWdlqr0lcoFwSZxplbazrYNsOxY+vodDDSqYPoMT/bqcixXCeeHotqNjCMQU0Kl9UAiiRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967818; c=relaxed/simple;
	bh=HyoUoNN7CQPpuqtuLsACobqEewOPDnEYyHqK9BdloAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4vNCs+w30C3FB6e17kHkWHHu+MX5qKNrtmX52SvUfhFn4+w9nWH52Jd+BeyvMX0XwxvwupX6CWInh4+zzwXCaxAXS54RuNEx3o5SDTEDMumPLGCyRy1DT8h8C9qUZ/dXvGyARzwZ6W0t+mMYkXsJdRTxPW2RfdF3KZt5l/MHBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cwsphyLa; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cwsphyLa"
Date: Wed, 20 Mar 2024 16:50:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710967814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L8S17QZeLnhV+2/ajl9JS2x/ELLJqHFU1bsfNHo+2k4=;
	b=cwsphyLaYpB9RCHQcDkSgqWhRDUgsGqIXoSsyIYbjgsM2kQrCeZxj6cX+6GDr3fuRXckd2
	VzkSarYI/kNXPU2vI6gZMdNG9Hw9BIvLjoTDs2FU4KUAwLujgWNXpoT/qH//9u7rWtHDk4
	fPq8SQyrIoM2vHcTJdXESAm6iw6ykwk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] bcachefs: optimize btree_path status
 representation
Message-ID: <g6xkofl46rtle32t4kmyqc65nwdm6ksfzxa5khhirzqgkigqon@gfmoep2ua5nm>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-3-lihongbo22@huawei.com>
 <ZfsftT1Wd0K6daOy@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfsftT1Wd0K6daOy@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 01:41:09PM -0400, Brian Foster wrote:
> On Wed, Mar 20, 2024 at 02:29:23PM +0800, Hongbo Li wrote:
> > UPTODATE means btree_path is useable, so here use
> > btree_path_is_uptodate to check this status. And the old
> > function btree_path_set_dirty cannot represent what it really
> > does (such as if UPTODATE is passed into it, btree_path sometime
> > wasn't dirty).
> > 
> > Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> > ---
> >  fs/bcachefs/btree_iter.c         | 16 ++++++++--------
> >  fs/bcachefs/btree_iter.h         | 13 +++++++++----
> >  fs/bcachefs/btree_key_cache.c    |  2 +-
> >  fs/bcachefs/btree_locking.c      | 10 +++++-----
> >  fs/bcachefs/btree_locking.h      |  8 ++++----
> >  fs/bcachefs/btree_trans_commit.c |  2 +-
> >  6 files changed, 28 insertions(+), 23 deletions(-)
> > 
> ...
> > diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
> > index c76070494284..f9ed8c44ab5a 100644
> > --- a/fs/bcachefs/btree_iter.h
> > +++ b/fs/bcachefs/btree_iter.h
> > @@ -27,10 +27,15 @@ static inline bool __btree_path_put(struct btree_path *path, bool intent)
> >  	return --path->ref == 0;
> >  }
> >  
> > -static inline void btree_path_set_dirty(struct btree_path *path,
> > -					enum btree_path_state u)
> > +static inline bool btree_path_is_uptodate(struct btree_path *path)
> >  {
> > -	path->status = max_t(unsigned, path->status, u);
> > +    return path->status == UPTODATE;
> > +}
> > +
> > +static inline void btree_path_update_state(struct btree_path *path,
> > +                    enum btree_path_state u)
> > +{
> > +    path->status = max_t(unsigned, path->status, u);
> >  }
> >  
> 
> Hmm.. I'm kind of neutral on the update_state() rename, but I like the
> btree_path_is_uptodate() helper to clean up some of the wonky logic.

*nod*

Rather than doing some renaming I'd like to see further work in this
area of the code being done based on some deep profiling, studying of
ways to simplify the codepaths, etc. - just renaming the helpers a bit,
we can do that if it makes things clearer but it's not terribly
important. By the time you've spent enough time with code like this to
do deep and interesting work - this is just details that you'll skip
over when you're reading. I can take a few renaming patches if they make
things clearer, but let's not go overboard.
> 
> My initial thought was to wonder whether it's worth creating some macro
> helpers for each state, but after looking through the code a bit that
> seems like overkill. In fact AFAICT, the only purpose of the
> NEED_TRAVERSE state is so that a lock cycle doesn't return the path back
> to UPTODATE in that particular case. Otherwise nothing else actually
> seems to explicitly check for NEED_TRAVERSE state.
> 
> Am I missing something there? If not, I'd say just replace the enum with
> an explicit 2-bit field called something like 'path_invalid' and define
> the states as corresponding flags. For example:
> 
> #define BTREE_PATH_INVALID		(1 << 0)
> #define BTREE_PATH_INVALID_LOCKS	(1 << 1)
> 
> Then the helpers just manage the validation flags appropriately (i.e.
> is_uptodate() means path_invalid == 0). I suppose you could also invert
> that logic and call the field path_valid or whatever too. Thoughts, or
> other ideas?

I generally (and here) prefer an enum to multiple flags.

It might be possible to get rid of path->uptodate entirely; that's
something I was considering in the past. "has locks" is redundant, we
always have either all or none of the locks we want so checking if
path->nodes_locked is nonzero should always tell you if a path is
uptodate.

for "path needs traverse" - path_set_pos() ensures that a path has a
node at the current level iff it's traversed, i.e.
!IS_ERR_OR_NULL(path->l[path->level].b) means a path doesn't need to be
traversed (still needs to be locked).

but again - the btree_path stuff is tricky and subtle, I would advise
against fooling around with this code, unless you're willing to invest
the time and effort into really studying it and finding some substantive
improvements.

There are performance improvements to be had in the btree iterator code,
so there is work to be done here, but right now it's low priority -
we've got higher level performance bugs that are much more serious than
anything going on in this code.
