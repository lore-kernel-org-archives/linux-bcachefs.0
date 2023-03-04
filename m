Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC87C64EC4
	for <linux-bcachefs@archiver.kernel.org>; Sat,  4 Mar 2023 02:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCDCpD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Mar 2023 21:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCDCpD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Mar 2023 21:45:03 -0500
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2398E265B0
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Mar 2023 18:45:01 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:44:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677897898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/C1+7m0khNn+8UH280IDNqVe6xxyJVg8gt6EZa7rRk=;
        b=NJ+i8IFpOljpGiZ6qFNKufr/9wcfqPIN0C1VbhPE01W2sbcwHrEVNGuguHIvWEQxNGYf/q
        //xG18C03cHBTVCiWZdh8e0OdQMGcHPLz4akxBUBdKyEcrS+9JfSs4of87SWmdFUUIuFMr
        1M027GWZZYyCmQVSITC20mfFteRc1yA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: don't bump key cache journal seq on
 nojournal commits
Message-ID: <ZAKwp52iF2v8Okqz@moria.home.lan>
References: <20230302195110.217282-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302195110.217282-1-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Mar 02, 2023 at 02:51:10PM -0500, Brian Foster wrote:
> As noted on IRC, this patch is RFC because it's definitely broken. I
> reproduce a generic/036 unmount hang related to pin flushing. I tweaked
> the logic to also skip the bch2_journal_pin_add() call, which seems to
> fix generic/036 but then results in a generic/127 panic where
> atomic_long_read(&bc->nr_keys) == 1 on exit. So this all kind of smells
> like I'm breaking the journal pin/key cache flushing logic here and so
> need to grok this a bit better to see what this is getting wrong.
> 
> FWIW, I also ran a quick test to just drop the usage of NOJOURNAL from
> the inode update in the extent update path. That seems to also address
> the generic/388 problem, but I haven't tested that one more broadly.
> 
> One other thing is I know we proved the commit that introduced ck->seq
> was not the root cause of this problem a week or so ago. I suspect this
> still occurs prior to that commit because that one also relocated the
> pin update from the commit path to the journal reclaim (i.e. cache
> flush) path. IOW, the problem still occurs, it just depends on the
> NOJOURNAL commit itself to bump the pin and a journal write to race with
> a cache flush.

So continuing the IRC conversation, it seems like this is (almost)
exactly the right fix - and I think I might know why you're seeing the
generic/036 hang too.

Without your fix, the bug is that we're setting ck->seq to a newer
sequence number than the last time this key was updated in the journal.
That means that when we later update the journal pin, this key cache key
is pinning a newer journal entry than the last time this key was updated
in the journal - meaning there's a window in the journal where we've
lost the inode update.

Specifically, the inode update _previous_ to this inode update (that was
not marked as NOJOURNAL) gets lost - the bch2_journal_pin_update() call
tells the journal we don't need that update anymore (which would be
correct if we had journalled a newer update) - but we didn't journal a
newer update, so we did need the older update.

It looks like the generic/036 hang is beacuse with your fix, you're
calling bch2_journal_pin_add() without updating ck->seq - then we end up
holding a journal pin while ck->seq is garbage, so
bch2_btree_key_cache_journal_flush() gets confused - haven't worked out
what exactly happens then.

Try moving the bch2_journal_pin_add() inside your new
BTREE_UPDATE_NOJOURNAL check, I bet that fixes it.

> 
>  fs/bcachefs/btree_key_cache.c   | 9 +++++----
>  fs/bcachefs/btree_key_cache.h   | 2 +-
>  fs/bcachefs/btree_update_leaf.c | 2 +-
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 13df0d408634..272e66437ffc 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -770,11 +770,11 @@ int bch2_btree_key_cache_flush(struct btree_trans *trans,
>  
>  bool bch2_btree_insert_key_cached(struct btree_trans *trans,
>  				  unsigned flags,
> -				  struct btree_path *path,
> -				  struct bkey_i *insert)
> +				  struct btree_insert_entry *insert_entry)
>  {
>  	struct bch_fs *c = trans->c;
> -	struct bkey_cached *ck = (void *) path->l[0].b;
> +	struct bkey_cached *ck = (void *) insert_entry->path->l[0].b;
> +	struct bkey_i *insert = insert_entry->k;
>  	bool kick_reclaim = false;
>  
>  	BUG_ON(insert->u64s > ck->u64s);
> @@ -804,7 +804,8 @@ bool bch2_btree_insert_key_cached(struct btree_trans *trans,
>  
>  	bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
>  			     &ck->journal, bch2_btree_key_cache_journal_flush);
> -	ck->seq = trans->journal_res.seq;
> +	if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL))
> +		ck->seq = trans->journal_res.seq;
>  
>  	if (kick_reclaim)
>  		journal_reclaim_kick(&c->journal);
> diff --git a/fs/bcachefs/btree_key_cache.h b/fs/bcachefs/btree_key_cache.h
> index c86d5e48f6e3..be3acde2caa0 100644
> --- a/fs/bcachefs/btree_key_cache.h
> +++ b/fs/bcachefs/btree_key_cache.h
> @@ -30,7 +30,7 @@ int bch2_btree_path_traverse_cached(struct btree_trans *, struct btree_path *,
>  				    unsigned);
>  
>  bool bch2_btree_insert_key_cached(struct btree_trans *, unsigned,
> -			struct btree_path *, struct bkey_i *);
> +			struct btree_insert_entry *);
>  int bch2_btree_key_cache_flush(struct btree_trans *,
>  			       enum btree_id, struct bpos);
>  void bch2_btree_key_cache_drop(struct btree_trans *,
> diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
> index c93c132dd815..456375fed276 100644
> --- a/fs/bcachefs/btree_update_leaf.c
> +++ b/fs/bcachefs/btree_update_leaf.c
> @@ -765,7 +765,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
>  		if (!i->cached)
>  			btree_insert_key_leaf(trans, i);
>  		else if (!i->key_cache_already_flushed)
> -			bch2_btree_insert_key_cached(trans, flags, i->path, i->k);
> +			bch2_btree_insert_key_cached(trans, flags, i);
>  		else {
>  			bch2_btree_key_cache_drop(trans, i->path);
>  			btree_path_set_dirty(i->path, BTREE_ITER_NEED_TRAVERSE);
> -- 
> 2.39.2
> 
