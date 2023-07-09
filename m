Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268CCEB64DD
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjGIRQH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjGIRQG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:06 -0400
Received: from out-48.mta0.migadu.com (out-48.mta0.migadu.com [IPv6:2001:41d0:1004:224b::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4C3129
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:02 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1C1K3f+qS/3rO1WrS7kDFenrvdrbeLRJj3MEyMfql2k=;
        b=bZ36MijV9rlQ2z26cFg9YR1TyHv4CucI1jPVVFFVCHJPaRwy9c8Bnct2e4Vf6t11np739d
        m4B4+nTeMFBG4tZPCMfj76W6h4oLtbmhbjEw6Fc5t/dQMJvsSo1a2M2O5eBz+tVDQ8F5gk
        MgHEg8Y2/j97UbKXNLhRuWZHc4Vygw4=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 02/10] bcachefs: Allow for unknown key types
Date:   Sun,  9 Jul 2023 13:15:43 -0400
Message-Id: <20230709171551.2349961-3-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This adds a new helper for lookups bkey_ops for a given key type, which
returns a null bkey_ops for unknown key types; various bkey_ops users
are tweaked as well to handle unknown key types.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bkey_methods.c      | 38 +++++++++++++++------------------
 fs/bcachefs/bkey_methods.h      | 12 +++++++++--
 fs/bcachefs/btree_update_leaf.c | 10 +++++----
 3 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
index ee7275c9d1..985ea2daa8 100644
--- a/fs/bcachefs/bkey_methods.c
+++ b/fs/bcachefs/bkey_methods.c
@@ -118,17 +118,14 @@ const struct bkey_ops bch2_bkey_ops[] = {
 #undef x
 };
 
+const struct bkey_ops bch2_bkey_null_ops = {
+	.min_val_size = U8_MAX,
+};
+
 int bch2_bkey_val_invalid(struct bch_fs *c, struct bkey_s_c k,
 			  unsigned flags, struct printbuf *err)
 {
-	const struct bkey_ops *ops;
-
-	if (k.k->type >= KEY_TYPE_MAX) {
-		prt_printf(err, "invalid type (%u >= %u)", k.k->type, KEY_TYPE_MAX);
-		return -BCH_ERR_invalid_bkey;
-	}
-
-	ops = &bch2_bkey_ops[k.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 
 	if (bkey_val_bytes(k.k) < ops->min_val_size) {
 		prt_printf(err, "bad val size (%zu < %u)",
@@ -136,6 +133,9 @@ int bch2_bkey_val_invalid(struct bch_fs *c, struct bkey_s_c k,
 		return -BCH_ERR_invalid_bkey;
 	}
 
+	if (!ops->key_invalid)
+		return 0;
+
 	return ops->key_invalid(c, k, flags, err);
 }
 
@@ -340,14 +340,10 @@ void bch2_bkey_to_text(struct printbuf *out, const struct bkey *k)
 void bch2_val_to_text(struct printbuf *out, struct bch_fs *c,
 		      struct bkey_s_c k)
 {
-	if (k.k->type < KEY_TYPE_MAX) {
-		const struct bkey_ops *ops = &bch2_bkey_ops[k.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 
-		if (likely(ops->val_to_text))
-			ops->val_to_text(out, c, k);
-	} else {
-		prt_printf(out, "(invalid type %u)", k.k->type);
-	}
+	if (likely(ops->val_to_text))
+		ops->val_to_text(out, c, k);
 }
 
 void bch2_bkey_val_to_text(struct printbuf *out, struct bch_fs *c,
@@ -363,7 +359,7 @@ void bch2_bkey_val_to_text(struct printbuf *out, struct bch_fs *c,
 
 void bch2_bkey_swab_val(struct bkey_s k)
 {
-	const struct bkey_ops *ops = &bch2_bkey_ops[k.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 
 	if (ops->swab)
 		ops->swab(k);
@@ -371,7 +367,7 @@ void bch2_bkey_swab_val(struct bkey_s k)
 
 bool bch2_bkey_normalize(struct bch_fs *c, struct bkey_s k)
 {
-	const struct bkey_ops *ops = &bch2_bkey_ops[k.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 
 	return ops->key_normalize
 		? ops->key_normalize(c, k)
@@ -380,11 +376,11 @@ bool bch2_bkey_normalize(struct bch_fs *c, struct bkey_s k)
 
 bool bch2_bkey_merge(struct bch_fs *c, struct bkey_s l, struct bkey_s_c r)
 {
-	const struct bkey_ops *ops = &bch2_bkey_ops[l.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(l.k->type);
 
-	return bch2_bkey_maybe_mergable(l.k, r.k) &&
+	return ops->key_merge &&
+		bch2_bkey_maybe_mergable(l.k, r.k) &&
 		(u64) l.k->size + r.k->size <= KEY_SIZE_MAX &&
-		bch2_bkey_ops[l.k->type].key_merge &&
 		!bch2_key_merging_disabled &&
 		ops->key_merge(c, l, r);
 }
@@ -509,7 +505,7 @@ void __bch2_bkey_compat(unsigned level, enum btree_id btree_id,
 		if (big_endian != CPU_BIG_ENDIAN)
 			bch2_bkey_swab_val(u);
 
-		ops = &bch2_bkey_ops[k->type];
+		ops = bch2_bkey_type_ops(k->type);
 
 		if (ops->compat)
 			ops->compat(btree_id, version, big_endian, write, u);
diff --git a/fs/bcachefs/bkey_methods.h b/fs/bcachefs/bkey_methods.h
index a65756e306..32b86c74cc 100644
--- a/fs/bcachefs/bkey_methods.h
+++ b/fs/bcachefs/bkey_methods.h
@@ -11,6 +11,7 @@ struct bkey;
 enum btree_node_type;
 
 extern const char * const bch2_bkey_types[];
+extern const struct bkey_ops bch2_bkey_null_ops;
 
 /*
  * key_invalid: checks validity of @k, returns 0 if good or -EINVAL if bad. If
@@ -41,6 +42,13 @@ struct bkey_ops {
 
 extern const struct bkey_ops bch2_bkey_ops[];
 
+static inline const struct bkey_ops *bch2_bkey_type_ops(enum bch_bkey_type type)
+{
+	return likely(type < KEY_TYPE_MAX)
+		? &bch2_bkey_ops[type]
+		: &bch2_bkey_null_ops;
+}
+
 #define BKEY_INVALID_FROM_JOURNAL		(1 << 1)
 
 int bch2_bkey_val_invalid(struct bch_fs *, struct bkey_s_c, unsigned, struct printbuf *);
@@ -75,7 +83,7 @@ static inline int bch2_mark_key(struct btree_trans *trans,
 		struct bkey_s_c old, struct bkey_s_c new,
 		unsigned flags)
 {
-	const struct bkey_ops *ops = &bch2_bkey_ops[old.k->type ?: new.k->type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(old.k->type ?: new.k->type);
 
 	return ops->atomic_trigger
 		? ops->atomic_trigger(trans, btree, level, old, new, flags)
@@ -125,7 +133,7 @@ static inline int bch2_trans_mark_key(struct btree_trans *trans,
 				      struct bkey_s_c old, struct bkey_i *new,
 				      unsigned flags)
 {
-	const struct bkey_ops *ops = &bch2_bkey_ops[old.k->type ?: new->k.type];
+	const struct bkey_ops *ops = bch2_bkey_type_ops(old.k->type ?: new->k.type);
 
 	return ops->trans_trigger
 		? ops->trans_trigger(trans, btree_id, level, old, new, flags)
diff --git a/fs/bcachefs/btree_update_leaf.c b/fs/bcachefs/btree_update_leaf.c
index dc105a7c2e..1474dca26d 100644
--- a/fs/bcachefs/btree_update_leaf.c
+++ b/fs/bcachefs/btree_update_leaf.c
@@ -407,6 +407,8 @@ static int run_one_mem_trigger(struct btree_trans *trans,
 {
 	struct bkey_s_c old = { &i->old_k, i->old_v };
 	struct bkey_i *new = i->k;
+	const struct bkey_ops *old_ops = bch2_bkey_type_ops(old.k->type);
+	const struct bkey_ops *new_ops = bch2_bkey_type_ops(i->k->k.type);
 	int ret;
 
 	verify_update_old_key(trans, i);
@@ -417,8 +419,7 @@ static int run_one_mem_trigger(struct btree_trans *trans,
 	if (!btree_node_type_needs_gc(i->btree_id))
 		return 0;
 
-	if (bch2_bkey_ops[old.k->type].atomic_trigger ==
-	    bch2_bkey_ops[i->k->k.type].atomic_trigger &&
+	if (old_ops->atomic_trigger == new_ops->atomic_trigger &&
 	    ((1U << old.k->type) & BTREE_TRIGGER_WANTS_OLD_AND_NEW)) {
 		ret   = bch2_mark_key(trans, i->btree_id, i->level,
 				old, bkey_i_to_s_c(new),
@@ -450,6 +451,8 @@ static int run_one_trans_trigger(struct btree_trans *trans, struct btree_insert_
 	 */
 	struct bkey old_k = i->old_k;
 	struct bkey_s_c old = { &old_k, i->old_v };
+	const struct bkey_ops *old_ops = bch2_bkey_type_ops(old.k->type);
+	const struct bkey_ops *new_ops = bch2_bkey_type_ops(i->k->k.type);
 
 	verify_update_old_key(trans, i);
 
@@ -459,8 +462,7 @@ static int run_one_trans_trigger(struct btree_trans *trans, struct btree_insert_
 
 	if (!i->insert_trigger_run &&
 	    !i->overwrite_trigger_run &&
-	    bch2_bkey_ops[old.k->type].trans_trigger ==
-	    bch2_bkey_ops[i->k->k.type].trans_trigger &&
+	    old_ops->trans_trigger == new_ops->trans_trigger &&
 	    ((1U << old.k->type) & BTREE_TRIGGER_WANTS_OLD_AND_NEW)) {
 		i->overwrite_trigger_run = true;
 		i->insert_trigger_run = true;
-- 
2.40.1

