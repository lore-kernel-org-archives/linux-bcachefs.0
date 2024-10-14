Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C32827470
	for <linux-bcachefs@vger.kernel.org>; Mon, 14 Oct 2024 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728872413; cv=none; b=rMGqh98aOvxdz54Ciy99jRU8UsiIFz4XH8gTlXMP6G8z51J8UhdygRvczKPR/TURfN+LLt4ofbJkbh+gO85+NfmG9JTRDpL0A40PEn0eN0oF6eNa1v5NiDDh3VqheJYB7I8zXy18H6+hhEATnbLe9eILtG7tOkp3GNtFIIcNk6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728872413; c=relaxed/simple;
	bh=B6/pWRt6lM6YQ+z9hBVpAFaNBor+o1zA4AQKOo7xxxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hffGWYK23mw80rFhwp5N8y0xJGIfaONCcC0/vKsLe9plxaB7YY4nl2vARIajaD58PLrvIZKiTYddOfNJTnWiWyLFh62pUxpJE0l8FdPPKuSvNQ9eAsRW4IbQlly3nUuO55rSR+113jh3COIq8i2AINfiX1vXJGLxtnU/y6x+/BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tk+GcWae; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tk+GcWae"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728872407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mtU+Tm1+I5t3aFlR48cXmm/PuYxaWIrwdEFA8g91lBk=;
	b=Tk+GcWaefvbH6CTCyNuRd042dWmhvtsMNLtJ/wPQAp4GCC78xP3nBUgz+WQNloGFsIiSus
	6NReYLF0jYO4+AWVDW2ud/RxKeocgmD9LgtDwqMdt3ipOmmbSbE8NjMkV5xjh7CDh9ENEc
	6pUVRF30MeUagcIDpPbYwEqmuDluLfo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Handle race between stripe reuse, invalidate_stripe_to_dev
Date: Sun, 13 Oct 2024 22:19:57 -0400
Message-ID: <20241014021957.746617-2-kent.overstreet@linux.dev>
In-Reply-To: <20241014021957.746617-1-kent.overstreet@linux.dev>
References: <20241014021957.746617-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When creating a new stripe, we may reuse an existing stripe that has
some empty and some nonempty blocks.

Generally, the existing stripe won't change underneath us - except for
block sector counts, which we copy to the new key in
ec_stripe_key_update.

But the device removal path can now invalidate stripe pointers to a
device, and that can race with stripe reuse.

Change ec_stripe_key_update() to check for and resolve this
inconsistency.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c      | 73 ++++++++++++++++++++++++++-----------------
 fs/bcachefs/extents.h | 10 ++++++
 2 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 668d013cc97f..e410cfe37b1a 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1206,47 +1206,62 @@ void bch2_do_stripe_deletes(struct bch_fs *c)
 /* stripe creation: */
 
 static int ec_stripe_key_update(struct btree_trans *trans,
-				struct bkey_i_stripe *new,
-				bool create)
+				struct bkey_i_stripe *old,
+				struct bkey_i_stripe *new)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	int ret;
+	bool create = !old;
 
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_stripes,
-			       new->k.p, BTREE_ITER_intent);
-	ret = bkey_err(k);
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_stripes,
+					       new->k.p, BTREE_ITER_intent);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
-	if (k.k->type != (create ? KEY_TYPE_deleted : KEY_TYPE_stripe)) {
-		bch2_fs_inconsistent(c, "error %s stripe: got existing key type %s",
-				     create ? "creating" : "updating",
-				     bch2_bkey_types[k.k->type]);
+	if (bch2_fs_inconsistent_on(k.k->type != (create ? KEY_TYPE_deleted : KEY_TYPE_stripe),
+				    c, "error %s stripe: got existing key type %s",
+				    create ? "creating" : "updating",
+				    bch2_bkey_types[k.k->type])) {
 		ret = -EINVAL;
 		goto err;
 	}
 
 	if (k.k->type == KEY_TYPE_stripe) {
-		const struct bch_stripe *old = bkey_s_c_to_stripe(k).v;
-		unsigned i;
+		const struct bch_stripe *v = bkey_s_c_to_stripe(k).v;
 
-		if (old->nr_blocks != new->v.nr_blocks) {
-			bch_err(c, "error updating stripe: nr_blocks does not match");
-			ret = -EINVAL;
-			goto err;
-		}
+		BUG_ON(old->v.nr_blocks != new->v.nr_blocks);
+		BUG_ON(old->v.nr_blocks != v->nr_blocks);
+
+		for (unsigned i = 0; i < new->v.nr_blocks; i++) {
+			unsigned sectors = stripe_blockcount_get(v, i);
+
+			if (!bch2_extent_ptr_eq(old->v.ptrs[i], new->v.ptrs[i]) && sectors) {
+				struct printbuf buf = PRINTBUF;
 
-		for (i = 0; i < new->v.nr_blocks; i++) {
-			unsigned v = stripe_blockcount_get(old, i);
+				prt_printf(&buf, "stripe changed nonempty block %u", i);
+				prt_str(&buf, "\nold: ");
+				bch2_bkey_val_to_text(&buf, c, k);
+				prt_str(&buf, "\nnew: ");
+				bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&new->k_i));
+				bch2_fs_inconsistent(c, "%s", buf.buf);
+				printbuf_exit(&buf);
+				ret = -EINVAL;
+				goto err;
+			}
 
-			BUG_ON(v &&
-			       (old->ptrs[i].dev != new->v.ptrs[i].dev ||
-				old->ptrs[i].gen != new->v.ptrs[i].gen ||
-				old->ptrs[i].offset != new->v.ptrs[i].offset));
+			/*
+			 * If the stripe ptr changed underneath us, it must have
+			 * been dev_remove_stripes() -> * invalidate_stripe_to_dev()
+			 */
+			if (!bch2_extent_ptr_eq(old->v.ptrs[i], v->ptrs[i])) {
+				BUG_ON(v->ptrs[i].dev != BCH_SB_MEMBER_INVALID);
+
+				if (bch2_extent_ptr_eq(old->v.ptrs[i], new->v.ptrs[i]))
+					new->v.ptrs[i].dev = BCH_SB_MEMBER_INVALID;
+			}
 
-			stripe_blockcount_set(&new->v, i, v);
+			stripe_blockcount_set(&new->v, i, sectors);
 		}
 	}
 
@@ -1508,8 +1523,10 @@ static void ec_stripe_create(struct ec_stripe_new *s)
 			    BCH_TRANS_COMMIT_no_check_rw|
 			    BCH_TRANS_COMMIT_no_enospc,
 			    ec_stripe_key_update(trans,
-					bkey_i_to_stripe(&s->new_stripe.key),
-					!s->have_existing_stripe));
+					s->have_existing_stripe
+					? bkey_i_to_stripe(&s->existing_stripe.key)
+					: NULL,
+					bkey_i_to_stripe(&s->new_stripe.key)));
 	bch_err_msg(c, ret, "creating stripe key");
 	if (ret) {
 		goto err;
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index ed5001dd662e..923a5f1849a8 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -695,6 +695,16 @@ void bch2_bkey_ptrs_to_text(struct printbuf *, struct bch_fs *,
 int bch2_bkey_ptrs_validate(struct bch_fs *, struct bkey_s_c,
 			    enum bch_validate_flags);
 
+static inline bool bch2_extent_ptr_eq(struct bch_extent_ptr ptr1,
+				      struct bch_extent_ptr ptr2)
+{
+	return (ptr1.cached	== ptr2.cached &&
+		ptr1.unwritten	== ptr2.unwritten &&
+		ptr1.offset	== ptr2.offset &&
+		ptr1.dev	== ptr2.dev &&
+		ptr1.dev	== ptr2.dev);
+}
+
 void bch2_ptr_swab(struct bkey_s);
 
 const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
-- 
2.45.2

