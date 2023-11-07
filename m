Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF522D05E
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ahrEZqIK"
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A67A359B
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 07:32:10 -0800 (PST)
Date: Tue, 7 Nov 2023 10:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699371128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ba8t79DEtUagDJLlr3Lj6m9vQ2YJ+Bry0PCQREwaBxU=;
	b=ahrEZqIKJfCKUNFQu6GzvdRWvMER9wqNETqio9AF0q6Bfr7ol/4qBGqJMBCKxFlD2ITvck
	uV9BgDoeE7R/9hEn1nAKM9amwdARDGtOw3iXGl1mC4JejShU0C6ff8DFzc2Iy2ZQI4YLw8
	yskqBdjjEvzc6V7dol1P71IX4seGyaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix NULL dereference in
 bch2_backpointer_get_node()
Message-ID: <20231107153205.3dvo62rk4ipedssp@moria.home.lan>
References: <5fc3c28b-c232-4ec7-b0ac-4ef220ddf976@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fc3c28b-c232-4ec7-b0ac-4ef220ddf976@moroto.mountain>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 07, 2023 at 06:19:00PM +0300, Dan Carpenter wrote:
> The bch2_btree_iter_peek_node() function returns both error pointers
> and NULL.  Check for NULL before dereferencing "b".
> 
> Fixes: 853960d00b4b ("bcachefs: Simplify, fix bch2_backpointer_get_key()")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  fs/bcachefs/backpointers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
> index ef02c9bb0354..3f9c5c366708 100644
> --- a/fs/bcachefs/backpointers.c
> +++ b/fs/bcachefs/backpointers.c
> @@ -316,7 +316,7 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
>  	if (IS_ERR(b))
>  		goto err;
>  
> -	BUG_ON(b->c.level != bp.level - 1);
> +	BUG_ON(b && b->c.level != bp.level - 1);
>  
>  	if (b && extent_matches_bp(c, bp.btree_id, bp.level,
>  				   bkey_i_to_s_c(&b->key),
> -- 
> 2.42.0
> 

Thanks, applying this fix


commit 75345c6f616cf7c2bf01de2247266fff7e2b54a2
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Nov 7 10:30:22 2023 -0500

    bcachefs: Fix null ptr deref in bch2_backpointer_get_node()
    
    bch2_btree_iter_peek_node() can return a NULL ptr (when the tree is
    shorter than the search depth); handle this with an early return.
    
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
    Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
    Fixes: https://lore.kernel.org/linux-bcachefs/5fc3c28b-c232-4ec7-b0ac-4ef220ddf976@moroto.mountain/T/

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index ef02c9bb0354..23c0834a97a4 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -313,17 +313,17 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 				  bp.level - 1,
 				  0);
 	b = bch2_btree_iter_peek_node(iter);
-	if (IS_ERR(b))
+	if (IS_ERR_OR_NULL(b))
 		goto err;
 
 	BUG_ON(b->c.level != bp.level - 1);
 
-	if (b && extent_matches_bp(c, bp.btree_id, bp.level,
-				   bkey_i_to_s_c(&b->key),
-				   bucket, bp))
+	if (extent_matches_bp(c, bp.btree_id, bp.level,
+			      bkey_i_to_s_c(&b->key),
+			      bucket, bp))
 		return b;
 
-	if (b && btree_node_will_make_reachable(b)) {
+	if (btree_node_will_make_reachable(b)) {
 		b = ERR_PTR(-BCH_ERR_backpointer_to_overwritten_btree_node);
 	} else {
 		backpointer_not_found(trans, bp_pos, bp, bkey_i_to_s_c(&b->key));
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 9f307c7846b9..012c62bb1b94 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -177,7 +177,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 
 	darray_for_each(wb->sorted, i) {
 		struct btree_write_buffered_key *k = &wb->flushing.keys.data[i->idx];
-
+#if 0
 		if (i + 1 < &darray_top(wb->sorted) &&
 		    i[0].btree == i[1].btree &&
 		    bpos_eq(i[0].pos, i[1].pos)) {
@@ -185,7 +185,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 			k->journal_seq = 0;
 			continue;
 		}
-
+#endif
 		if (write_locked &&
 		    (iter.path->btree_id != k->btree ||
 		     bpos_gt(k->k.k.p, iter.path->l[0].b->key.k.p))) {
