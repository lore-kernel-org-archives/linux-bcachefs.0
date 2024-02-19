Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0BF32182
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 13:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708350944; cv=none; b=kaqpq5Enf0HbdhWHPfbGL0VPZ9B/DfFfEsfvCFmJDMpX+9B2Ext7Z0hk5wWHeRCl3/3uS4fAYpOwLXYJSHM33GAHXE6p44cUOzBRa3N0K5hOyVfm59Z731153u3RxcuGk7pxYVi5h0dEZUyYfS4wdYHkH79d2x4ftfiImRaLTeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708350944; c=relaxed/simple;
	bh=FZKjCqBR7woVT7lTmOH5M9jMQIV2xwKtPlHWzMvcxPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTiYVXU2B0R14058XFaMWbjNP3ezZdkUJrAx13dMI8zoMPoYMuH7iC3PFou1f5CqsLH+qyQx2EMAwFhK+2j/HxUW/JUMTdeDGSxZzEBtJ+UogDFgITJepBcjSCY8344pRW1chT5Ep4wVwy7w2AxRC9PSnm5bfS2cwP9iqR5gA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=U810OJA7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="U810OJA7"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e104a8e3f7so3719989b3a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 05:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708350942; x=1708955742; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDCm05UH0Ho2Y9Xwe2LKk3TRQTfUo2ZwR0rrArJQL5k=;
        b=U810OJA7QgwRknJEzvnO0Bhl216MEDcK6lwXEV2Rqyg1FpH0Ziz6LIHSsVgqdXh07W
         pmKV6R8bFM8W5l/Gdq07sARPZlnEMYL1MdvaZOIqW6zQ+nj8luazzwVkyBWCphW+0RX3
         bOrVtXkTYKigbu+S3OS5miLp62L4Be/Wu9DUb0qmuv0lqDGg4MkAo2BeP1eS2ut3ME3m
         T6mudJboWR3/laUhqNZSuMJrtboeP28aabz3fnHXnVa+6GmHcrza8SKwQxiSadr+Oyu9
         B9T2g+88S6evjryFXFySa/m4WI/jXCbaaC1FYRH/3Ne8LmTN8IYOZCwXpQrxQmPL+oqh
         SY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708350942; x=1708955742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDCm05UH0Ho2Y9Xwe2LKk3TRQTfUo2ZwR0rrArJQL5k=;
        b=en3l8W1yUnMqZnpVBwEtBsRVZp66XG6MYYQ7SboZ6ADW3dWfuLud/se0A99e6nmCGw
         mF7vpU66ukQhUly/CIjuo6iuMmwPxZAy/hlbqSgg0faCAhL0W/NiVch6Rivf5yqF/czl
         1kd/0fQbzvPRL/s4W5a922iIVR2SgbLvWg2NQtsRfvMKbV9IBxmHNNJVJwiA9awHn2VT
         /ZsgRbryIW0/SJUBG/eFormxDJ5omgsasrUbqEWA21HsfQrXA7RO+TZCg84lk//CouCr
         +zmi9YjRUnr2WiNSXIHPDv2/fpRUyaV02li95phyEAnj5LRI7+qzXsnsaiOrLl9Uuoba
         smyA==
X-Gm-Message-State: AOJu0YyQpsLAAuzM0FAooJRUP46vsmoMOUGu0YumnW1mY+2LNudt9ykL
	QIEA0Ka1D7uhGhHFSF3pLea0oy7eXdonDQNdixKgU2tUTR2j/HpIkJ9N1qRZzENN7nCHHPL/I6+
	y
X-Google-Smtp-Source: AGHT+IF/+T97VeP7mxQ42fm0am+UufGJTlKuFNZI94xcTgRM/jS1ORWiZ8PBdoARMor+RVLhuFG/xA==
X-Received: by 2002:a05:6a20:d38f:b0:19e:9a97:cb12 with SMTP id iq15-20020a056a20d38f00b0019e9a97cb12mr16062422pzb.54.1708350941954;
        Mon, 19 Feb 2024 05:55:41 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id k13-20020aa788cd000000b006e4641f578csm1853499pff.189.2024.02.19.05.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 05:55:41 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 3/3] bcachefs: add hit/miss percent to btree_cache sysfs
Date: Tue, 20 Feb 2024 02:28:40 +1300
Message-ID: <20240219135425.885068-4-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219135425.885068-1-daniel@gluo.nz>
References: <20240219135425.885068-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This should help us identify any performance issues with the btree node
cache.

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/btree_cache.c | 35 +++++++++++++++++++++++++++++++++++
 fs/bcachefs/btree_types.h |  3 +++
 2 files changed, 38 insertions(+)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 799750464969..8d2954ab3598 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -418,6 +418,9 @@ void bch2_fs_btree_cache_exit(struct bch_fs *c)
 	flags = memalloc_nofs_save();
 	mutex_lock(&bc->lock);
 
+	free_percpu(bc->hits);
+	free_percpu(bc->misses);
+
 	if (c->verify_data)
 		list_move(&c->verify_data->list, &bc->live);
 
@@ -467,6 +470,11 @@ int bch2_fs_btree_cache_init(struct bch_fs *c)
 	unsigned i;
 	int ret = 0;
 
+	bc->hits   = __alloc_percpu(sizeof(u64) * BTREE_MAX_DEPTH, sizeof(u64));
+	bc->misses = __alloc_percpu(sizeof(u64) * BTREE_MAX_DEPTH, sizeof(u64));
+	if (!bc->hits || !bc->misses)
+		goto err;
+
 	ret = rhashtable_init(&bc->table, &bch_btree_cache_params);
 	if (ret)
 		goto err;
@@ -833,6 +841,7 @@ static struct btree *__bch2_btree_node_get(struct btree_trans *trans, struct btr
 	struct btree *b;
 	struct bset_tree *t;
 	bool need_relock = false;
+	bool is_hit = true;
 	int ret;
 
 	EBUG_ON(level >= BTREE_MAX_DEPTH);
@@ -852,6 +861,8 @@ static struct btree *__bch2_btree_node_get(struct btree_trans *trans, struct btr
 		if (!b)
 			goto retry;
 
+		is_hit = false;
+
 		if (IS_ERR(b))
 			return b;
 	} else {
@@ -925,6 +936,11 @@ static struct btree *__bch2_btree_node_get(struct btree_trans *trans, struct btr
 	EBUG_ON(BTREE_NODE_LEVEL(b->data) != level);
 	btree_check_header(c, b);
 
+	if (is_hit)
+		this_cpu_inc(bc->hits[level]);
+	else
+		this_cpu_inc(bc->misses[level]);
+
 	return b;
 }
 
@@ -1029,6 +1045,7 @@ struct btree *bch2_btree_node_get_noiter(struct btree_trans *trans,
 	struct btree_cache *bc = &c->btree_cache;
 	struct btree *b;
 	struct bset_tree *t;
+	bool is_hit = true;
 	int ret;
 
 	EBUG_ON(level >= BTREE_MAX_DEPTH);
@@ -1055,6 +1072,8 @@ struct btree *bch2_btree_node_get_noiter(struct btree_trans *trans,
 		    !bch2_btree_cache_cannibalize_lock(trans, NULL))
 			goto retry;
 
+		is_hit = false;
+
 		if (IS_ERR(b))
 			goto out;
 	} else {
@@ -1100,6 +1119,11 @@ struct btree *bch2_btree_node_get_noiter(struct btree_trans *trans,
 	EBUG_ON(BTREE_NODE_LEVEL(b->data) != level);
 	btree_check_header(c, b);
 out:
+	if (is_hit)
+		this_cpu_inc(bc->hits[level]);
+	else
+		this_cpu_inc(bc->misses[level]);
+
 	bch2_btree_cache_cannibalize_unlock(trans);
 	return b;
 }
@@ -1225,4 +1249,15 @@ void bch2_btree_cache_to_text(struct printbuf *out, const struct bch_fs *c)
 	prt_printf(out, "nr nodes:\t\t%u\n", c->btree_cache.used);
 	prt_printf(out, "nr dirty:\t\t%u\n", atomic_read(&c->btree_cache.dirty));
 	prt_printf(out, "cannibalize lock:\t%p\n", c->btree_cache.alloc_lock);
+
+	for (int i = 0; i < BTREE_MAX_DEPTH; i++) {
+		u64 hits = percpu_u64_get(&c->btree_cache.hits[i]);
+		u64 misses = percpu_u64_get(&c->btree_cache.misses[i]);
+		u64 total = hits + misses;
+
+		prt_printf(out, "level %i misses: ", i);
+		bch2_prt_percent_rational_u64(out, misses, total, 0);
+		prt_printf(out, " %llu+%llu/%llu", hits, misses, total);
+		prt_newline(out);
+	}
 }
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index b2ebf143c3b7..a10ab188908d 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -179,6 +179,9 @@ struct btree_cache {
 	struct bbpos		pinned_nodes_end;
 	u64			pinned_nodes_leaf_mask;
 	u64			pinned_nodes_interior_mask;
+
+	u64 __percpu *hits;
+	u64 __percpu *misses;
 };
 
 struct btree_node_iter {
-- 
2.43.0

