Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A733A28E
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fislzxYs"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EAE196
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Nov 2023 05:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699967820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7tNMQLVBZEtA442fWww4CoL8nwFpz535KDPpBYz3NOg=;
	b=fislzxYsp8dGAqBhT/CbCCn4nDk9YEdqjGxqAnd6lCIdxGl8YkOGMWUlTmiFx+eG1P1Z64
	kCCp961g1Q8ttfBY92s26K7VWUf6vVITK5Cy7uRKgEALCpqQj9/W8YTlbRHhlxufXOSezu
	DXi7p6+6G4OSL2m0ladIX1fH/0OWGMI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-5YQNo4BrMbS2TW2rcGhamw-1; Tue, 14 Nov 2023 08:16:57 -0500
X-MC-Unique: 5YQNo4BrMbS2TW2rcGhamw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5460785D182;
	Tue, 14 Nov 2023 13:16:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.127])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2BE451C060AE;
	Tue, 14 Nov 2023 13:16:57 +0000 (UTC)
Date: Tue, 14 Nov 2023 08:17:36 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 05/17] bcachefs: Kill BTREE_UPDATE_PREJOURNAL
Message-ID: <ZVNzcE9EopgWAepU@bfoster>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
 <20231110163157.2736111-6-kent.overstreet@linux.dev>
 <ZVJA3vcKqur+L9gp@bfoster>
 <20231113164910.bcfhm4pathhfsbxg@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113164910.bcfhm4pathhfsbxg@moria.home.lan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Mon, Nov 13, 2023 at 11:49:10AM -0500, Kent Overstreet wrote:
> On Mon, Nov 13, 2023 at 10:29:34AM -0500, Brian Foster wrote:
> > On Fri, Nov 10, 2023 at 11:31:42AM -0500, Kent Overstreet wrote:
> > > With the previous patch that reworks BTREE_INSERT_JOURNAL_REPLAY, we can
> > > now switch the btree write buffer to use it for flushing.
> > > 
> > > This has the advantage that transaction commits don't need to take a
> > > journal reservation at all.
> > > 
> > > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > > ---
> > >  fs/bcachefs/bkey_methods.h       |  2 --
> > >  fs/bcachefs/btree_trans_commit.c |  7 +------
> > >  fs/bcachefs/btree_types.h        |  1 -
> > >  fs/bcachefs/btree_update.c       | 23 -----------------------
> > >  fs/bcachefs/btree_write_buffer.c | 14 ++++++++++----
> > >  5 files changed, 11 insertions(+), 36 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> > > index ec90a06a6cf9..f231f01072c2 100644
> > > --- a/fs/bcachefs/btree_trans_commit.c
> > > +++ b/fs/bcachefs/btree_trans_commit.c
> > > @@ -779,12 +779,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
> > >  
> > >  	trans_for_each_update(trans, i) {
> > >  		if (!i->cached) {
> > > -			u64 seq = trans->journal_res.seq;
> > > -
> > > -			if (i->flags & BTREE_UPDATE_PREJOURNAL)
> > > -				seq = i->seq;
> > > -
> > > -			bch2_btree_insert_key_leaf(trans, i->path, i->k, seq);
> > > +			bch2_btree_insert_key_leaf(trans, i->path, i->k, trans->journal_res.seq);
> > 
> > Ok, so instead of passing the seq to the commit path via the insert
> > entry, we use a flag that enables a means to pass journal_res.seq
> > straight through to the commit. That seems reasonable to me.
> > 
> > One subtle thing that comes to mind is that the existing mechanism
> > tracks a seq per key update whereas this looks like it associates the
> > seq to the transaction and then to every key update. That's how it's
> > used today AFAICS so doesn't seem like a big deal, but what happens if
> > this is misused in the future? Does anything prevent having multiple
> > keys from different journal seqs in the same transaction leading to
> > pinning the wrong seq for some subset of keys? If not, it would be nice
> > to have some kind of check or something somewhere to fail an update for
> > a trans that might already have a pre journaled key.
> 
> Well, anything to do with taking a journal reservation or a journal pin
> really does go with the transaction commit, not an individual update -
> if we were doing multiple updates that went with different journal
> updates it wouldn't really be a transaction at that point.
> 

Yep that makes complete sense. I'm just lamenting that it seems a little
easy to misuse. I think this is partly due to the disconnected nature of
setting journal_res.seq and passing INSERT_JOURNAL_REPLAY at commit
time.

If the no_res mode were a fundamental transaction state, that could
potentially facilitate error checks that could help prevent adding keys
from multiple journal seqs to the same transaction. For example,
consider something like the original update helper that took the seq as
a param, but set some state on the transaction such that any further
updates could be validated to require the same seq (knowing that the
transaction is now "nores").

It's relatively minor in theory but in practice that could be the
difference between identifying a problem via runtime error vs. possibly
missing the bug and spending a bunch of time triaging an out of order
log recovery bug or whatever might occur as a result. Anyways, this is
mainly just a thought around possibly making things a bit more (noob)
developer friendly.

> > > -	return  bch2_trans_update_seq(trans, wb->journal_seq, iter, &wb->k,
> > > -				      BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
> > > +	trans->journal_res.seq = wb->journal_seq;
> > > +
> > > +	return  bch2_trans_update(trans, iter, &wb->k,
> > > +				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
> > >  		bch2_trans_commit(trans, NULL, NULL,
> > >  				  commit_flags|
> > >  				  BTREE_INSERT_NOCHECK_RW|
> > >  				  BTREE_INSERT_NOFAIL|
> > > +				  BTREE_INSERT_JOURNAL_REPLAY|
> > >  				  BTREE_INSERT_JOURNAL_RECLAIM);
> >
> > This is more of a nit for now, but I find the general use of a flag with
> > a contextual name unnecessarily confusing. I.e., the flag implies we're
> > doing journal replay, which we're not, and so makes the code confusing
> > to somebody who doesn't have the historical development context. Could
> > we rename or repurpose this to better reflect the functional purpose of
> > not acquiring a reservation (and let journal replay also use it)? I can
> > look into that as a followon change if you want to make suggestions or
> > share any thoughts..
> 
> Agreed - I didn't post this patch to the list because it was a simpler
> one, but:
> https://evilpiepirate.org/git/bcachefs.git/commit/?id=ed1e075104f3768375e1e8d3efcf87d9641029a7
> 
> (renaming all the BTREE_INSERT flags to BCH_TRANS_COMMIT, and with
> better anmes).
> 

Yeah, that is much better at a quick glance. Thanks.

> > But as a related example, do we care about how this flag modifies
> > invalid key checks (via __bch2_trans_commit()) for example?
> 
> There are key invalid checks that we want to run whenever doing new
> updates (because it's good to check inconsistencies as soon as
> possible), but we can't run on existing keys - possibly because the
> check didn't exist in the past, and so could cause us to throw away
> existing metadata.
> 

Ok, thanks for the context. My question as it relates to this patch is
consider the following hunk in the flag rename patch above:

@@ -1048,7 +1048,7 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		struct printbuf buf = PRINTBUF;
 		enum bkey_invalid_flags invalid_flags = 0;
 
-		if (!(flags & BTREE_INSERT_JOURNAL_REPLAY))
+		if (!(flags & BCH_TRANS_COMMIT_no_journal_res))
 			invalid_flags |= BKEY_INVALID_WRITE|BKEY_INVALID_COMMIT;
 
 		if (unlikely(bch2_bkey_invalid(c, bkey_i_to_s_c(i->k),

We've effectively removed these invalid_flags for the write buffer key
flush path by virtue of turning on no_journal_res there. Should those
flags be elided because there is no journal res, or are they more
associated with journal replay context (which happens to not use journal
res)?

Brian

> The snapshot skiplist checks are a good example. There were (multiple)
> bugs where we'd delete a snapshot tree node and end up with snapshot
> keys with bad skiplist pointers. Now, we can detect and repair this
> during fsck, but it's much better if we can catch this right away, when
> writing the new snapshot key; i.e. if a skiplist node points to an id
> smaller than the parent, then it's obviously bad.
> 
> But, since that check didn't exist when skiplist nodes were first
> introduced we can't run it when checking existing snapshot nodes,
> otherwise a filesystem would with corrupt skiplist nodes would have
> those snapshot keys deleted entirely instead of letting fsck repair just
> the skiplist entries.
> 
> .key_invalid()s cause those key to be deleted because those checks run
> e.g. every time we run a btree node in from disk - we're very limited in
> what kinds of updates we can do then.
> 

