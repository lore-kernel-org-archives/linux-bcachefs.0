Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E3D188596
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821252; cv=none; b=IP1j0pxlu7yD/wITT8gD7Yg1/u4h1LeKfdBJz/792m77nUWK6qNqRlmMG7Te9ElhxjRKnnS/YZ2vPvxv/qPcVtMWu/MCaSx2oH6HMaoC/n5WLPpx89W8BLizWI3dmzLmXfS4brGJ8YaBjhmWahFeStCSiCn+3PQk9PyK5FglW78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821252; c=relaxed/simple;
	bh=PccrzY3+CuMIlOt8cB04pj/boZxmXED6O+M2ICMATGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z31QqnzfqZcV02zajnpI/0GPZ51RZhhM+5uP+BJa92Md/OqdjKJha4PGXPIkBnpPf0Sjd1/dxQ9QrN/gdbM4a0jvB5CW+4HL0yiCovJWM8yiVxZC8MyhgErd/MQ52aZP9X1arNSJObbeVmoiuypFo5uIczjMru1pfd0GLeW6hAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hU2xVK4S; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hU2xVK4S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752821247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGUsxdXfCMuarhwWcY7zlOidO7efkOaTGTdhzeOyXOo=;
	b=hU2xVK4SDRdEsFZO2moduxIo9WfJ/Dl8UpqLjgFMZ55ay5hjklnPCfqlgDsELouvsezgem
	RrgAPl9ULU4qsv5yH8RchOZGndsJwODOOrEnHQTQqd121e9xi30Hp2U7/FyaTJFLB7L2Gd
	tmJpM5KpUp/OTi/j6mARBGoFi7RbauY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] bcachefs: can_use_btree_node()
Date: Fri, 18 Jul 2025 02:47:15 -0400
Message-ID: <20250718064715.333124-4-kent.overstreet@linux.dev>
In-Reply-To: <20250718064715.333124-1-kent.overstreet@linux.dev>
References: <20250718064715.333124-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Make sure btree_node_alloc() respects allocation policy when allocating
from the btree node reserve.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_update_interior.c | 41 ++++++++++++++++++++++++++---
 fs/bcachefs/extents.c               | 14 ++++++++++
 fs/bcachefs/extents.h               |  2 ++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 312ef203b27b..e4aa4fa749bc 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -14,6 +14,7 @@
 #include "btree_locking.h"
 #include "buckets.h"
 #include "clock.h"
+#include "disk_groups.h"
 #include "enumerated_ref.h"
 #include "error.h"
 #include "extents.h"
@@ -277,6 +278,36 @@ static void bch2_btree_node_free_never_used(struct btree_update *as,
 	bch2_trans_node_drop(trans, b);
 }
 
+static bool can_use_btree_node(struct bch_fs *c,
+			       struct disk_reservation *res,
+			       unsigned target,
+			       struct bkey_s_c k)
+{
+	if (!bch2_bkey_devs_rw(c, k))
+		return false;
+
+	if (target && !bch2_bkey_in_target(c, k, target))
+		return false;
+
+	unsigned durability = bch2_bkey_durability(c, k);
+
+	if (durability >= res->nr_replicas)
+		return true;
+
+	struct bch_devs_mask devs = target_rw_devs(c, BCH_DATA_btree, target);
+
+	guard(rcu)();
+
+	unsigned durability_available = 0, i;
+	for_each_set_bit(i, devs.d, BCH_SB_MEMBERS_MAX) {
+		struct bch_dev *ca = bch2_dev_rcu_noerror(c, i);
+		if (ca)
+			durability_available += ca->mi.durability;
+	}
+
+	return durability >= durability_available;
+}
+
 static struct btree *__bch2_btree_node_alloc(struct btree_trans *trans,
 					     struct disk_reservation *res,
 					     struct closure *cl,
@@ -303,10 +334,14 @@ static struct btree *__bch2_btree_node_alloc(struct btree_trans *trans,
 	mutex_lock(&c->btree_reserve_cache_lock);
 	if (c->btree_reserve_cache_nr > nr_reserve) {
 		for (struct btree_alloc *a = c->btree_reserve_cache;
-		     a < c->btree_reserve_cache + c->btree_reserve_cache_nr;
-		     a++) {
-			if (target && !bch2_bkey_in_target(c, bkey_i_to_s_c(&a->k), target))
+		     a < c->btree_reserve_cache + c->btree_reserve_cache_nr;) {
+			/* check if it has sufficient durability */
+
+			if (!can_use_btree_node(c, res, target, bkey_i_to_s_c(&a->k))) {
+				bch2_open_buckets_put(c, &a->ob);
+				*a = c->btree_reserve_cache[--c->btree_reserve_cache_nr];
 				continue;
+			}
 
 			bkey_copy(&b->key, &a->k);
 			b->ob = a->ob;
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index b36ecfc0ab9d..8152ef1cbbcd 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1006,6 +1006,20 @@ const struct bch_extent_ptr *bch2_bkey_has_device_c(struct bkey_s_c k, unsigned
 	return NULL;
 }
 
+bool bch2_bkey_devs_rw(struct bch_fs *c, struct bkey_s_c k)
+{
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+
+	guard(rcu)();
+	bkey_for_each_ptr(ptrs, ptr) {
+		CLASS(bch2_dev_tryget, ca)(c, ptr->dev);
+		if (!ca || ca->mi.state != BCH_MEMBER_STATE_rw)
+			return false;
+	}
+
+	return true;
+}
+
 bool bch2_bkey_has_target(struct bch_fs *c, struct bkey_s_c k, unsigned target)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index f212f91c278d..35ee03cd5065 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -614,6 +614,8 @@ static inline struct bch_extent_ptr *bch2_bkey_has_device(struct bkey_s k, unsig
 	return (void *) bch2_bkey_has_device_c(k.s_c, dev);
 }
 
+bool bch2_bkey_devs_rw(struct bch_fs *, struct bkey_s_c);
+
 bool bch2_bkey_has_target(struct bch_fs *, struct bkey_s_c, unsigned);
 bool bch2_bkey_in_target(struct bch_fs *, struct bkey_s_c, unsigned);
 
-- 
2.50.0

