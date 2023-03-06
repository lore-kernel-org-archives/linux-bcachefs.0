Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 467BFC678D4
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Mar 2023 13:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjCFNSE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 6 Mar 2023 08:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCFNSD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 6 Mar 2023 08:18:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E042A171
        for <linux-bcachefs@vger.kernel.org>; Mon,  6 Mar 2023 05:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678108635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lKma69BbfqW+zO1KVquAdRUjqpA76J1sPGdwJAC2JXg=;
        b=Hka3BTMNEEjG3wQEpvZw/ZTE8mXA/fgECvn8IzM/f8YZqtGM+SFR4ujARNqx8mm4zrhzJ8
        lPwA/U4EOYBMaPI6mwZ3C6r4dq60HT6qkLyD4oP0UK2+fZAuh03WKwKVaojdtNK1CzY6fo
        WiWrkmS95RWCXYOQJXRGdjvh+IHdKUE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-ZmJ9_6zTNfyqD60eSGcXSQ-1; Mon, 06 Mar 2023 08:17:14 -0500
X-MC-Unique: ZmJ9_6zTNfyqD60eSGcXSQ-1
Received: by mail-qv1-f69.google.com with SMTP id lt7-20020a056214570700b0057290f3623eso5432360qvb.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 Mar 2023 05:17:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678108633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKma69BbfqW+zO1KVquAdRUjqpA76J1sPGdwJAC2JXg=;
        b=KJChlrmRkr7l0df30sN1SVSsGObMqiw02EfuXJS899VU3NOYACS0CgEFm5EAUc45tv
         UQVtPT/vBPAaqGTZ5SfnpYb5VCESRaLCbmwKlDHKpuWKp9TPmSlxH/oiEzrwacSrZCl5
         kp4ouapMiGKm9dUAv21cetUhxbo0Ff0cqOU8XtPe1jdmcRRPAWCgS9A7t7cNLfMt2KWn
         KQNVw6NTlycLBF9hac6yawzcG7WuhSR0cgBhv4ISblSR49tWAA+GtHPZ9bA7ybDpOITZ
         G2bUQsW3Vyws+0C5S0BocG9laWys8O6td2pyYb6iuHCKF1ryTJ2ZM7WxmscR3IQ8eCE5
         WeEA==
X-Gm-Message-State: AO0yUKUaNOoDV8nouy7fFyMnCT9mkFoBlOgMgMetQgC8ZiLnE1phfMba
        dSXVp655yqehkqsKT2amZJRbJCsAyOEKYD17WifsowYO8708ymQoffkdxTp5EYC/nWPDmxl2Jpo
        MNJtGoF9zJejhLWQxfE/5i6qizC35j7eyHBs=
X-Received: by 2002:a05:6214:d42:b0:537:6416:fc2b with SMTP id 2-20020a0562140d4200b005376416fc2bmr19247774qvr.52.1678108633227;
        Mon, 06 Mar 2023 05:17:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+oinHE5uGXiUoToWIow+5eKIZ5lvvO0mlALq2hUzPfJ7bUlcrT1i6sTr9DZu20KFdD6Nq00A==
X-Received: by 2002:a05:6214:d42:b0:537:6416:fc2b with SMTP id 2-20020a0562140d4200b005376416fc2bmr19247729qvr.52.1678108632794;
        Mon, 06 Mar 2023 05:17:12 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q5-20020a37f705000000b0073b929d0371sm7424647qkj.4.2023.03.06.05.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 05:17:12 -0800 (PST)
Date:   Mon, 6 Mar 2023 08:18:55 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: don't bump key cache journal seq on
 nojournal commits
Message-ID: <ZAXoP29b/QVq3Onn@bfoster>
References: <20230302195110.217282-1-bfoster@redhat.com>
 <ZAKwp52iF2v8Okqz@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAKwp52iF2v8Okqz@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Mar 03, 2023 at 09:44:55PM -0500, Kent Overstreet wrote:
> On Thu, Mar 02, 2023 at 02:51:10PM -0500, Brian Foster wrote:
> > As noted on IRC, this patch is RFC because it's definitely broken. I
> > reproduce a generic/036 unmount hang related to pin flushing. I tweaked
> > the logic to also skip the bch2_journal_pin_add() call, which seems to
> > fix generic/036 but then results in a generic/127 panic where
> > atomic_long_read(&bc->nr_keys) == 1 on exit. So this all kind of smells
> > like I'm breaking the journal pin/key cache flushing logic here and so
> > need to grok this a bit better to see what this is getting wrong.
> > 
> > FWIW, I also ran a quick test to just drop the usage of NOJOURNAL from
> > the inode update in the extent update path. That seems to also address
> > the generic/388 problem, but I haven't tested that one more broadly.
> > 
> > One other thing is I know we proved the commit that introduced ck->seq
> > was not the root cause of this problem a week or so ago. I suspect this
> > still occurs prior to that commit because that one also relocated the
> > pin update from the commit path to the journal reclaim (i.e. cache
> > flush) path. IOW, the problem still occurs, it just depends on the
> > NOJOURNAL commit itself to bump the pin and a journal write to race with
> > a cache flush.
> 
> So continuing the IRC conversation, it seems like this is (almost)
> exactly the right fix - and I think I might know why you're seeing the
> generic/036 hang too.
> 
> Without your fix, the bug is that we're setting ck->seq to a newer
> sequence number than the last time this key was updated in the journal.
> That means that when we later update the journal pin, this key cache key
> is pinning a newer journal entry than the last time this key was updated
> in the journal - meaning there's a window in the journal where we've
> lost the inode update.
> 
> Specifically, the inode update _previous_ to this inode update (that was
> not marked as NOJOURNAL) gets lost - the bch2_journal_pin_update() call
> tells the journal we don't need that update anymore (which would be
> correct if we had journalled a newer update) - but we didn't journal a
> newer update, so we did need the older update.
> 

Yep..

> It looks like the generic/036 hang is beacuse with your fix, you're
> calling bch2_journal_pin_add() without updating ck->seq - then we end up
> holding a journal pin while ck->seq is garbage, so
> bch2_btree_key_cache_journal_flush() gets confused - haven't worked out
> what exactly happens then.
> 

Yeah, I tracked the hang problem down to essentially being due to a
"stale" ck->seq value. I.e., a normal commit occurs, updates ck->seq,
the key cache flushes, pin drops, etc. Subsequently a NOJOURNAL commit
occurs and happens to be the only key cache update at that point. It
adds a new pin but does not update ck->seq. The key flush callback sees
an old ck->seq and doesn't flush, which essentially leaves around the
following:

96611: count 1
  flushed:
        ffff99c313fb64d8 bch2_btree_key_cache_journal_flush [bcachefs]
...

... and we're stuck because the callback didn't flush, but the pin
wasn't updated either.

> Try moving the bch2_journal_pin_add() inside your new
> BTREE_UPDATE_NOJOURNAL check, I bet that fixes it.
> 

Hmm.. I want to say I tried that and I ran into another problem with
generic/127 where the key cache wouldn't flush (see the comments in my
initial writeup), I _think_ because we hit a case where we just failed
to add a pin and that is required to tie into journal reclaim and
actually have the cache flush (even if nothing was logged).

I ran with the following logic over the weekend and it seemed to avoid
any problems:

        if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL) ||
            !journal_pin_active(&ck->journal)) {
                ck->seq = trans->journal_res.seq;
        }
        bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
                             &ck->journal, bch2_btree_key_cache_journal_flush);

This addresses the scenario above by updating ck->seq when the key cache
pin happens to be inactive, which is presumably (?) safe because that
means the cache doesn't hold any previous updates. FWIW, I suspect there
are probably multiple ways to fix this, such as allowing pin_add() to
return whether it actually added a pin, or perhaps resetting ck->seq
somewhere on key cache flush so the callback doesn't think it's valid,
etc. Thoughts?

I have a bigger picture question, however. The key cache is intended to
hold updates to multiple different keys that land in the same btree
node, right? If so, is it safe to update the key cache pin on later
updates like this in general? Specifically I was thinking about the
example of two inodes that happen to land in the same key cache (inode
A, A+1) but under different journal seqs.

For example, suppose inode A commits, logs, adds the ck pin, and sets
ck->seq (A). Then inode A+1 commits, logs to seq+1, and updates ck->seq
again. At this point if journal reclaim flushes the cache with the
original pin, we update the pin to the A+1 ck->seq value and return.  If
this moves the pin from the front of the journal, what prevents last_seq
from being updated to A+1 on disk and introducing the same sort of
window where in-core updates aren't covered by the active range of the
journal? I.e., if last_seq updates and the filesystem crashes, ISTM we
potentially lose the inode A key update, even if it was journaled.

Unless I'm missing something (entirely possible), I'm wondering if it
makes sense to update ck->seq like this at all (or if something else is
required to allow a ck to hold reference to multiple pins, etc.). Hm?

Brian

> > 
> >  fs/bcachefs/btree_key_cache.c   | 9 +++++----
> >  fs/bcachefs/btree_key_cache.h   | 2 +-
> >  fs/bcachefs/btree_update_leaf.c | 2 +-
> >  3 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> > index 13df0d408634..272e66437ffc 100644
> > --- a/fs/bcachefs/btree_key_cache.c
> > +++ b/fs/bcachefs/btree_key_cache.c
> > @@ -770,11 +770,11 @@ int bch2_btree_key_cache_flush(struct btree_trans *trans,
> >  
> >  bool bch2_btree_insert_key_cached(struct btree_trans *trans,
> >  				  unsigned flags,
> > -				  struct btree_path *path,
> > -				  struct bkey_i *insert)
> > +				  struct btree_insert_entry *insert_entry)
> >  {
> >  	struct bch_fs *c = trans->c;
> > -	struct bkey_cached *ck = (void *) path->l[0].b;
> > +	struct bkey_cached *ck = (void *) insert_entry->path->l[0].b;
> > +	struct bkey_i *insert = insert_entry->k;
> >  	bool kick_reclaim = false;
> >  
> >  	BUG_ON(insert->u64s > ck->u64s);
> > @@ -804,7 +804,8 @@ bool bch2_btree_insert_key_cached(struct btree_trans *trans,
> >  
> >  	bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
> >  			     &ck->journal, bch2_btree_key_cache_journal_flush);
> > -	ck->seq = trans->journal_res.seq;
> > +	if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL))
> > +		ck->seq = trans->journal_res.seq;
> >  
> >  	if (kick_reclaim)
> >  		journal_reclaim_kick(&c->journal);
> > diff --git a/fs/bcachefs/btree_key_cache.h b/fs/bcachefs/btree_key_cache.h
> > index c86d5e48f6e3..be3acde2caa0 100644
> > --- a/fs/bcachefs/btree_key_cache.h
> > +++ b/fs/bcachefs/btree_key_cache.h
> > @@ -30,7 +30,7 @@ int bch2_btree_path_traverse_cached(struct btree_trans *, struct btree_path *,
> >  				    unsigned);
> >  
> >  bool bch2_btree_insert_key_cached(struct btree_trans *, unsigned,
> > -			struct btree_path *, struct bkey_i *);
> > +			struct btree_insert_entry *);
> >  int bch2_btree_key_cache_flush(struct btree_trans *,
> >  			       enum btree_id, struct bpos);
> >  void bch2_btree_key_cache_drop(struct btree_trans *,
> > diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
> > index c93c132dd815..456375fed276 100644
> > --- a/fs/bcachefs/btree_update_leaf.c
> > +++ b/fs/bcachefs/btree_update_leaf.c
> > @@ -765,7 +765,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
> >  		if (!i->cached)
> >  			btree_insert_key_leaf(trans, i);
> >  		else if (!i->key_cache_already_flushed)
> > -			bch2_btree_insert_key_cached(trans, flags, i->path, i->k);
> > +			bch2_btree_insert_key_cached(trans, flags, i);
> >  		else {
> >  			bch2_btree_key_cache_drop(trans, i->path);
> >  			btree_path_set_dirty(i->path, BTREE_ITER_NEED_TRAVERSE);
> > -- 
> > 2.39.2
> > 
> 

