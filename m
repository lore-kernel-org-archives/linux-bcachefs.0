Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE931DA21
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893554; cv=none; b=kjF976hy9Pg0phxJcdSfo93fYfa/166qw3EVKVqoBYOeYB5CLcUZyoTwYil5IW9zzybpRAEU1dc4sYV+KINuOzLi8aDj0WsWGqD4iGUCyRArqbHiEOOQpCLCtwlaJ0cVBIslQj/2IEVQWalvhjJYnIjWfXNc2gYa3N3DLhdwhic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893554; c=relaxed/simple;
	bh=oSM7pj/ixTmYiF1/y9YQ/4qPvCb+nrQ29mcMH0KKnw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZPLVd8tT42D6XetFxWUhzajA4J0Ugqsy8S4367gHVfiRJThkkQOSDyrkUwqF27lrnIcRQplCoXiH73J8aR3IiKZsKQIw2fLE0LkYwO9sjvwskcWRI2GflYPugZ42PAinLOGKtOprq0s7z4V4nU3XDQSFkVCSeafdCuwIgD9wVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZCVWA2hK; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZCVWA2hK"
Date: Sun, 17 Nov 2024 20:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J39uwACjJIBlwffCvkAxz54QC2YS5dLdBtCbyHjkNfk=;
	b=ZCVWA2hKDaJx5ZKvgOFqJWDOd2DJ3qUrybotXd+zI8YDPsOGQGJ7bUYl/vpqxDPVV/JaXy
	TY5EQxitWsiStABOlKoROjQsCJmlaba8MD3CZ7EF91Q5PNLoT0zpLtcVFqvpfDe45laAaW
	PtZWXPI98Vr0pfGSDtCLSnBLJ1vSIRE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Piotr Zalewski <pZ010001011111@proton.me>, ndesaulniers@google.com, 
	morbo@google.com, justinstitt@google.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, skhan@linuxfoundation.org
Subject: Re: [PATCH] bcachefs: initialize local variables in
 bch2_evacuate_bucket
Message-ID: <jwob7wwk6eijpsusqfuqllnmo4e5wj7a7lwnbmcp5exgrpkget@b4lo6d4yy5ya>
References: <20241117234334.722730-4-pZ010001011111@proton.me>
 <20241118010040.GB3588455@thelio-3990X>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241118010040.GB3588455@thelio-3990X>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 17, 2024 at 06:00:40PM -0700, Nathan Chancellor wrote:
> On Sun, Nov 17, 2024 at 11:48:23PM +0000, Piotr Zalewski wrote:
> > Compiling bcachefs sources with LLVM triggers uninitialized variables
> > warnings.
> > 
> > Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
> > ---
> >  fs/bcachefs/move.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
> > index 8c032ef3a567..94cac498d372 100644
> > --- a/fs/bcachefs/move.c
> > +++ b/fs/bcachefs/move.c
> > @@ -674,8 +674,8 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
> >  	struct bkey_buf sk;
> >  	struct bkey_s_c k;
> >  	struct data_update_opts data_opts;
> > -	unsigned dirty_sectors, bucket_size;
> > -	u64 fragmentation;
> > +	unsigned dirty_sectors = 0, bucket_size = 0;
> > +	u64 fragmentation = 0;
> 
> Shouldn't these just be removed altogether...? They are only used in a
> trace event and now only zero.

Actually, I think we want to bring them back; being able to understand
the behaviour of these background tasks is important whenever we have to
debug something.

Hasn't come up as much with copygc recently, but it has with rebalance
and I was just improving the rebalance tracepoint.

(The copygc issue that does come up is that it behaves poorly with a
multi device tiering filesystem where it's rebalance's job to move data
off a full foreground device, not copygc, but that doesn't hit this
codepath).

But - fragmentation is not really a "evacuate_bucket()" concern, that's
a generic codepath, so I think I'll do something simpler here and then
later we can add a dedicated copygc tracepoint, and that can include
information about the fragmentation LRU that copygc looks at.

So...

From 6e1a9826444612f49e3667a0c0f4cd592dad9948 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Sun, 17 Nov 2024 20:27:34 -0500
Subject: [PATCH] bcachefs: Fix evacuate_bucket tracepoint

86a494c8eef9 ("bcachefs: Kill bch2_get_next_backpointer()") dropped some
things the tracepoint emitted because bch2_evacuate_bucket() no longer
looks at the alloc key - but we did want at least some of that.

We still no longer look at the alloc key so we can't report on the
fragmentation number, but that's a direct function of dirty_sectors and
a copygc concern anyways - copygc should get its own tracepoint that
includes information from the fragmentation LRU.

But we can report on the number of sectors we moved and the bucket size.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index a98a0893a03b..07064872a697 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -674,8 +674,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	struct bkey_buf sk;
 	struct bkey_s_c k;
 	struct data_update_opts data_opts;
-	unsigned dirty_sectors = 0, bucket_size = 0;
-	u64 fragmentation = 0;
+	unsigned sectors_moved = 0;
 	struct bkey_buf last_flushed;
 	int ret = 0;
 
@@ -750,15 +749,18 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 			data_opts.target	= io_opts.background_target;
 			data_opts.rewrite_ptrs = 0;
 
-			unsigned i = 0;
-			bkey_for_each_ptr(bch2_bkey_ptrs_c(k), ptr) {
-				if (ptr->dev == bucket.inode) {
-					data_opts.rewrite_ptrs |= 1U << i;
-					if (ptr->cached) {
+			unsigned i = 0, sectors = 0;
+			const union bch_extent_entry *entry;
+			struct extent_ptr_decoded p;
+			bkey_for_each_ptr_decode(k.k, bch2_bkey_ptrs_c(k), p, entry) {
+				if (p.ptr.dev == bucket.inode) {
+					if (p.ptr.cached) {
 						bch2_trans_iter_exit(trans, &iter);
 						goto next;
 					}
+					data_opts.rewrite_ptrs |= 1U << i;
 				}
+					sectors = ptr_disk_sectors(k.k->size, p);
 				i++;
 			}
 
@@ -777,7 +779,8 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 				goto err;
 
 			if (ctxt->stats)
-				atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
+				atomic64_add(sectors, &ctxt->stats->sectors_seen);
+			sectors_moved += sectors;
 		} else {
 			struct btree *b;
 
@@ -808,12 +811,13 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 				atomic64_add(sectors, &ctxt->stats->sectors_seen);
 				atomic64_add(sectors, &ctxt->stats->sectors_moved);
 			}
+			sectors_moved += btree_sectors(c);
 		}
 next:
 		bch2_btree_iter_advance(&bp_iter);
 	}
 
-	trace_evacuate_bucket(c, &bucket, dirty_sectors, bucket_size, fragmentation, ret);
+	trace_evacuate_bucket(c, &bucket, sectors_moved, ca->mi.bucket_size, ret);
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
 	bch2_dev_put(ca);
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 5597b9d6297f..2d5932d2881e 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -848,8 +848,8 @@ TRACE_EVENT(move_data,
 TRACE_EVENT(evacuate_bucket,
 	TP_PROTO(struct bch_fs *c, struct bpos *bucket,
 		 unsigned sectors, unsigned bucket_size,
-		 u64 fragmentation, int ret),
-	TP_ARGS(c, bucket, sectors, bucket_size, fragmentation, ret),
+		 int ret),
+	TP_ARGS(c, bucket, sectors, bucket_size, ret),
 
 	TP_STRUCT__entry(
 		__field(dev_t,		dev		)
@@ -857,7 +857,6 @@ TRACE_EVENT(evacuate_bucket,
 		__field(u64,		bucket		)
 		__field(u32,		sectors		)
 		__field(u32,		bucket_size	)
-		__field(u64,		fragmentation	)
 		__field(int,		ret		)
 	),
 
@@ -867,15 +866,14 @@ TRACE_EVENT(evacuate_bucket,
 		__entry->bucket			= bucket->offset;
 		__entry->sectors		= sectors;
 		__entry->bucket_size		= bucket_size;
-		__entry->fragmentation		= fragmentation;
 		__entry->ret			= ret;
 	),
 
-	TP_printk("%d,%d %llu:%llu sectors %u/%u fragmentation %llu ret %i",
+	TP_printk("%d,%d %llu:%llu sectors %u/%u ret %i",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->member, __entry->bucket,
 		  __entry->sectors, __entry->bucket_size,
-		  __entry->fragmentation, __entry->ret)
+		  __entry->ret)
 );
 
 TRACE_EVENT(copygc,
