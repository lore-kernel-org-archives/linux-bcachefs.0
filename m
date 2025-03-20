Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C9A1EC01E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506388; cv=none; b=ZLCEfAvVYIITtDOk3knno+w9l9nx3VJRKXxzcTlOquJk3D9bcpYoo4vVv8lYPPS2QwRxsYHHKUHU9wsP8S1iS63r9HK29i5lp86hCgWXcIs1iVO3nk8iIo5AnKF4nTam5SHOP4bspNCwLNERRP+mPQJnvhVuICJGzyGK96CBdmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506388; c=relaxed/simple;
	bh=hLpU4dUo5kkxKBKRy0OwzteQTMTgBBaK0hJ9R+qyPjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoPB2d7nlwa+qUYOxKVYoFDuv2u6ksumaMPv19/BMf2x9cAEpONhxQtla2qRTwMoTsf/lBd1yPlb5WpOUGLui17T3zP7+rRKaytFhgC011dcGBW9iptwdcyfOzjS6E7jwTCxAPfEjdmdfRoT6I4tiQ4vldMFMLf4X1AiaC23FBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RrfKFnqD; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RrfKFnqD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F0H0fDGq7oUhyW7LVRANbxtJfyCrAINgRKrf/MARV1E=;
	b=RrfKFnqDW/u+6uTwy3miR9QXYjpg4CleSSESKEJ0/rb0OtWII9n5cdnfiGA+vKPBl1nu45
	buYNqQsYdF+ccwZkxtlGJARgD1Pm80xRIWZPN/bST/JgZcH0+PzERWI7smec9ApHIqQEUQ
	fBIUXJzieVePmbPQIvFCXxNfs+OIsf4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/5] bcachefs: kmsan asserts
Date: Thu, 20 Mar 2025 17:32:51 -0400
Message-ID: <20250320213256.3359777-4-kent.overstreet@linux.dev>
In-Reply-To: <20250320213256.3359777-1-kent.overstreet@linux.dev>
References: <20250320213256.3359777-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Catching these early makes them a lot easier to track down.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 1 +
 fs/bcachefs/btree_update.c       | 2 ++
 fs/bcachefs/btree_update.h       | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index d50dc31d0bea..7d7e52ddde02 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -164,6 +164,7 @@ bool bch2_btree_bset_insert_key(struct btree_trans *trans,
 	EBUG_ON(bpos_gt(insert->k.p, b->data->max_key));
 	EBUG_ON(insert->k.u64s > bch2_btree_keys_u64s_remaining(b));
 	EBUG_ON(!b->c.level && !bpos_eq(insert->k.p, path->pos));
+	kmsan_check_memory(insert, bkey_bytes(&insert->k));
 
 	k = bch2_btree_node_iter_peek_all(node_iter, b);
 	if (k && bkey_cmp_left_packed(b, k, &insert->k.p))
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index b3e346b5f8d7..bd2eb42edb24 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -512,6 +512,8 @@ static noinline int bch2_trans_update_get_key_cache(struct btree_trans *trans,
 int __must_check bch2_trans_update(struct btree_trans *trans, struct btree_iter *iter,
 				   struct bkey_i *k, enum btree_iter_update_trigger_flags flags)
 {
+	kmsan_check_memory(k, bkey_bytes(&k->k));
+
 	btree_path_idx_t path_idx = iter->update_path ?: iter->path;
 	int ret;
 
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index 47d8690f01bf..d2e1c04353f6 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -133,6 +133,8 @@ static inline int __must_check bch2_trans_update_buffered(struct btree_trans *tr
 					    enum btree_id btree,
 					    struct bkey_i *k)
 {
+	kmsan_check_memory(k, bkey_bytes(&k->k));
+
 	if (unlikely(!btree_type_uses_write_buffer(btree))) {
 		int ret = bch2_btree_write_buffer_insert_err(trans, btree, k);
 		dump_stack();
-- 
2.49.0

