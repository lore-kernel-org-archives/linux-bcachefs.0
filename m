Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4BCB651;
	Mon,  3 Jun 2024 20:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717447670; cv=none; b=eXyx0jS93wg3YuKnAGR7wtg6xLx/RNUS82JvlZk6aY5RJDzzJWSkrBZnSKV0QIKqdwY2KiWs52EnD+zBL8Qa6stz7/oG1kDLQdrfvRW8P5GaBhsaZ7FnV0ADpuMiO8NyIvmtftfSfZ1Q3IVxdWv2nrP+mN9049BzF3rFTwQaITU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717447670; c=relaxed/simple;
	bh=l0a9VlAFEDGi4YhEYOO/yi9W3MqDDl+qKS1hX5k7FuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sIOTrg+xpJ5laVwnyXv0K68tWquztE+wyK97+KwwvXhP9gpKauQOQO5t2PgOiN+fnzaFaBttztWvCrjooDrHtf39BJpbjgDcOxXi0iTNiBN8rSwtjyisyko/wUmjRrQfq1r4e70bo5kidRGx/WBxK3xLf2Js0gxjuWGWUivnY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1/TVA35; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1/TVA35"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6269885572so854612166b.1;
        Mon, 03 Jun 2024 13:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717447666; x=1718052466; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AMmIMYjYO0Bl1l9jdTbFqjY6a0nD6DdVVojvXYLifmg=;
        b=K1/TVA350m7WMg5/WbqNkPCaCYhYl5mLxeQBmWFG+6dU6AIRZ5/lsAf9V+qm5ETMbv
         e5RdAK5EQg2srxmFU+dV0IkTikal2T5+edfoSo/U1EI7aUasYgBUPUbqghY9mzSTXmeL
         FNwewReg9QQJo0WdUL89VpbnWROj0qQJ2ykjJFLtfTQlTR3bWZhzYzxTO8gwpyZdU1XM
         8ZHC+EvViLMR3Ev/0w0RbQgQpFZjQS1xEJST8bLg3ALTnr3ICNfGxg3yvR7GxjlXwjqE
         /FhEdHE37OET+V+PZGqC+gTZ5QgJ4x191mnuwFnhBNb50REdbGFHQ1/ArOahT8KMs3y7
         geqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717447666; x=1718052466;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMmIMYjYO0Bl1l9jdTbFqjY6a0nD6DdVVojvXYLifmg=;
        b=bP773/Wae8dpAhT6UxkrkOTn26pfeyBEfyILjjeaET6v/FBAifZReYsZxjq7kscTiC
         gdhadqKrLzv0gtR3i24yNLFXJsBUQvVX+Ycu7LLmWU46vwwgloFVuTEaG9IXBfGfOySL
         5Ap9VvpsOIs1NBb5mbGIG4zAhXXqpgR3E8LQ3UIFB1YvYRsGK/474MpqQMCUHzQYB718
         WHZxj5LRPSwEG1cGnpm7NX1iHZMNLhtC+n6kqIcdXGGrZ1+ssy2Hgq5HA2k+a0ZFu2iz
         RbBwtbFDGihSdxg2XQLeOoIU/4NUYTcjpURUb8ptK7Fd/UCxTr3movrBwNYf4+8UZnVJ
         ep9A==
X-Forwarded-Encrypted: i=1; AJvYcCUHDHRdcovxPvSkdKDz8jUWzLA3Nh29kG0nv6jqHWZMctC/nbHOx5PXvpqUlHsIz0Fy7RBYNlEAWLvOm+d3TOv4QZxbQvtIK5yaqRdi
X-Gm-Message-State: AOJu0Yx3DnyID4iNREoXC85eMb3zLWroqNvdu12iOIX8L3gmQ3zi3/R5
	ICk0J7fYTAnXUDj9k63yGw0xSEpczAQ5TmbE+Bnupv9ZQ/TPq5F8mCc4UZiOd4c=
X-Google-Smtp-Source: AGHT+IE1UKLB07HkQbrxAY67RronyDIyHFnDqtlzJ6tRfq/c1q71j7vwbcWOP5mXmghk0E1Z5Wqi7g==
X-Received: by 2002:a17:906:70cf:b0:a68:f6b8:5239 with SMTP id a640c23a62f3a-a695425f854mr56045666b.13.1717447665630;
        Mon, 03 Jun 2024 13:47:45 -0700 (PDT)
Received: from localhost ([2a02:2f0e:516:6100:f071:96ae:5df9:e7e4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68e9eed9b1sm307823366b.131.2024.06.03.13.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 13:47:45 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: bch2_btree_insert() - add btree iter flags
Date: Mon,  3 Jun 2024 23:47:31 +0300
Message-Id: <20240603204732.2011734-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 65bd44239727 ("bcachefs: bch2_btree_insert_trans() no longer
specifies BTREE_ITER_cached") removes BTREE_ITER_cached from
bch2_btree_insert_trans, which causes the update_inode function from
bcachefs-tools to take a long time (~20s).  Add an iter_flags parameter
to bch2_btree_insert, so the users can specify iter update trigger
flags, such as BTREE_ITER_cached.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 fs/bcachefs/btree_update.c |  6 ++++--
 fs/bcachefs/btree_update.h |  5 +++--
 fs/bcachefs/recovery.c     |  2 +-
 fs/bcachefs/subvolume.c    |  6 +++---
 fs/bcachefs/tests.c        | 14 +++++++-------
 5 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index f3c645a43dcb..d6f6df10dcc3 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -656,14 +656,16 @@ int bch2_btree_insert_trans(struct btree_trans *trans, enum btree_id id,
  * @disk_res:		must be non-NULL whenever inserting or potentially
  *			splitting data extents
  * @flags:		transaction commit flags
+ * @iter_flags:		btree iter update trigger flags
  *
  * Returns:		0 on success, error code on failure
  */
 int bch2_btree_insert(struct bch_fs *c, enum btree_id id, struct bkey_i *k,
-		      struct disk_reservation *disk_res, int flags)
+		      struct disk_reservation *disk_res, int flags,
+		      enum btree_iter_update_trigger_flags iter_flags)
 {
 	return bch2_trans_do(c, disk_res, NULL, flags,
-			     bch2_btree_insert_trans(trans, id, k, 0));
+			     bch2_btree_insert_trans(trans, id, k, iter_flags));
 }
 
 int bch2_btree_delete_extent_at(struct btree_trans *trans, struct btree_iter *iter,
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index b4894e4d5447..272788782fc0 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -56,8 +56,9 @@ int bch2_btree_insert_nonextent(struct btree_trans *, enum btree_id,
 
 int bch2_btree_insert_trans(struct btree_trans *, enum btree_id, struct bkey_i *,
 			enum btree_iter_update_trigger_flags);
-int bch2_btree_insert(struct bch_fs *, enum btree_id, struct bkey_i *,
-		     struct disk_reservation *, int flags);
+int bch2_btree_insert(struct bch_fs *, enum btree_id, struct bkey_i *, struct
+		disk_reservation *, int flags, enum
+		btree_iter_update_trigger_flags iter_flags);
 
 int bch2_btree_delete_range_trans(struct btree_trans *, enum btree_id,
 				  struct bpos, struct bpos, unsigned, u64 *);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index cf513fc79ce4..6cd9becbc6ae 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1019,7 +1019,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	bch2_inode_pack(&packed_inode, &root_inode);
 	packed_inode.inode.k.p.snapshot = U32_MAX;
 
-	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed_inode.inode.k_i, NULL, 0);
+	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed_inode.inode.k_i, NULL, 0, 0);
 	bch_err_msg(c, ret, "creating root directory");
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index dfc9cf305756..2cb385a6cb6f 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -630,9 +630,9 @@ int bch2_initialize_subvolumes(struct bch_fs *c)
 	root_volume.v.snapshot	= cpu_to_le32(U32_MAX);
 	root_volume.v.inode	= cpu_to_le64(BCACHEFS_ROOT_INO);
 
-	ret =   bch2_btree_insert(c, BTREE_ID_snapshot_trees,	&root_tree.k_i, NULL, 0) ?:
-		bch2_btree_insert(c, BTREE_ID_snapshots,	&root_snapshot.k_i, NULL, 0) ?:
-		bch2_btree_insert(c, BTREE_ID_subvolumes,	&root_volume.k_i, NULL, 0);
+	ret =   bch2_btree_insert(c, BTREE_ID_snapshot_trees,	&root_tree.k_i, NULL, 0, 0) ?:
+		bch2_btree_insert(c, BTREE_ID_snapshots,	&root_snapshot.k_i, NULL, 0, 0) ?:
+		bch2_btree_insert(c, BTREE_ID_subvolumes,	&root_volume.k_i, NULL, 0, 0);
 	bch_err_fn(c, ret);
 	return ret;
 }
diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index 68104b2056d9..01b768c9b767 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -121,7 +121,7 @@ static int test_iterate(struct bch_fs *c, u64 nr)
 		ck.k.p.offset = i;
 		ck.k.p.snapshot = U32_MAX;
 
-		ret = bch2_btree_insert(c, BTREE_ID_xattrs, &ck.k_i, NULL, 0);
+		ret = bch2_btree_insert(c, BTREE_ID_xattrs, &ck.k_i, NULL, 0, 0);
 		bch_err_msg(c, ret, "insert error");
 		if (ret)
 			return ret;
@@ -176,7 +176,7 @@ static int test_iterate_extents(struct bch_fs *c, u64 nr)
 		ck.k.p.snapshot = U32_MAX;
 		ck.k.size = 8;
 
-		ret = bch2_btree_insert(c, BTREE_ID_extents, &ck.k_i, NULL, 0);
+		ret = bch2_btree_insert(c, BTREE_ID_extents, &ck.k_i, NULL, 0, 0);
 		bch_err_msg(c, ret, "insert error");
 		if (ret)
 			return ret;
@@ -232,7 +232,7 @@ static int test_iterate_slots(struct bch_fs *c, u64 nr)
 		ck.k.p.offset = i * 2;
 		ck.k.p.snapshot = U32_MAX;
 
-		ret = bch2_btree_insert(c, BTREE_ID_xattrs, &ck.k_i, NULL, 0);
+		ret = bch2_btree_insert(c, BTREE_ID_xattrs, &ck.k_i, NULL, 0, 0);
 		bch_err_msg(c, ret, "insert error");
 		if (ret)
 			return ret;
@@ -292,7 +292,7 @@ static int test_iterate_slots_extents(struct bch_fs *c, u64 nr)
 		ck.k.p.snapshot = U32_MAX;
 		ck.k.size = 8;
 
-		ret = bch2_btree_insert(c, BTREE_ID_extents, &ck.k_i, NULL, 0);
+		ret = bch2_btree_insert(c, BTREE_ID_extents, &ck.k_i, NULL, 0, 0);
 		bch_err_msg(c, ret, "insert error");
 		if (ret)
 			return ret;
@@ -396,7 +396,7 @@ static int insert_test_extent(struct bch_fs *c,
 	k.k_i.k.size = end - start;
 	k.k_i.k.version.lo = test_version++;
 
-	ret = bch2_btree_insert(c, BTREE_ID_extents, &k.k_i, NULL, 0);
+	ret = bch2_btree_insert(c, BTREE_ID_extents, &k.k_i, NULL, 0, 0);
 	bch_err_fn(c, ret);
 	return ret;
 }
@@ -481,7 +481,7 @@ static int test_snapshot_filter(struct bch_fs *c, u32 snapid_lo, u32 snapid_hi)
 
 	bkey_cookie_init(&cookie.k_i);
 	cookie.k.p.snapshot = snapid_hi;
-	ret = bch2_btree_insert(c, BTREE_ID_xattrs, &cookie.k_i, NULL, 0);
+	ret = bch2_btree_insert(c, BTREE_ID_xattrs, &cookie.k_i, NULL, 0, 0);
 	if (ret)
 		return ret;
 
@@ -506,7 +506,7 @@ static int test_snapshots(struct bch_fs *c, u64 nr)
 
 	bkey_cookie_init(&cookie.k_i);
 	cookie.k.p.snapshot = U32_MAX;
-	ret = bch2_btree_insert(c, BTREE_ID_xattrs, &cookie.k_i, NULL, 0);
+	ret = bch2_btree_insert(c, BTREE_ID_xattrs, &cookie.k_i, NULL, 0, 0);
 	if (ret)
 		return ret;
 
-- 
2.34.1

