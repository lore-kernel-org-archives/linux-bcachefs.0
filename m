Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833286328
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Apr 2025 17:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744995689; cv=none; b=rIRqC07iBLSyUYxUgTVaocNWXmx9KYSHFM/TuWTe/ZD7DvKc47WXbE4mBPreEFrhkobcVAwcheHvks0q2YiZbHgrotMy+vpb3ihb1doUy8ffNLzV//wi2E/uEPmZq8hYHoPbYJq9EF0QtNpsZXG0ASWo8bRLJ4pX2SpJjeeu0a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744995689; c=relaxed/simple;
	bh=c2cV4U+XoH/x8aYNF4jn7R+VkUVjNu9LfvaV28UX8OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s5dny4/d5FsuKm+pdeeUbdG0t06y0YfR+xlo4s8JIP1XkfCIc4Ud9QLqsMZXvKTkGgawVpk2Y2bCbbz/FSL8yUz7YmWmYO6yz7PsXe8TWhDVyRubGItSObNwUaa/ba5BkHSK2RiAmFtWxIN9OSwcQGcjbD+3n+WDdw9Vjeep0gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z4G6Pg6D; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z4G6Pg6D"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744995683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NrQy3Twr7cK2mf8TEYNJbbIzlW6JggqHNj7sptqjUR8=;
	b=Z4G6Pg6DvKfOcoQ7bX9GZF3MKf3VUxMUaov1+rLtEGw5hLMnC9JYsHRCFA7mK+OezUPj06
	LZt+6MnuJVbBjDvXTT1LharU2WI8jrkv0SrcYLffjPlB6E0JwwrMpRqM0JvaJxwEe5TZYH
	hPG3B0FwxQZ2AK1X6f0ZT0caAbvSLIE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Stricter checks on "key allowed in this btree"
Date: Fri, 18 Apr 2025 13:01:15 -0400
Message-ID: <20250418170115.4186041-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Syzbot managed to come up with a filesystem where check/repair got
rather confused at finding a reflink pointer in the inodes btree.

Currently, the "key allowed in this btree" checks only apply at commit
time, not read time - for forwards compatibility. It seems this is too
loose.

Now, strict key type allowed checks apply:
 - at commit time (no forward compatibility issues)
 - for btree node pointers
 - if it's a known btree, known key type, and the key type has the
   "BKEY_TYPE_strict_btree_checks" flag.

This means we still have the option of using generic key types - e.g.
KEY_TYPE_error, KEY_TYPE_set - on more existing btrees in the future,
while most key types that are intended for only a specific btree get
stricter checks.

Reported-by: syzbot+baee8591f336cab0958b@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h | 80 ++++++++++++++++++-----------------
 fs/bcachefs/bkey_methods.c    | 24 +++++++++--
 2 files changed, 62 insertions(+), 42 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index aa57f4708232..9af2a607db93 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -366,6 +366,10 @@ static inline void bkey_init(struct bkey *k)
 #define __BKEY_PADDED(key, pad)					\
 	struct bkey_i key; __u64 key ## _pad[pad]
 
+enum bch_bkey_type_flags {
+	BKEY_TYPE_strict_btree_checks	= BIT(0),
+};
+
 /*
  * - DELETED keys are used internally to mark keys that should be ignored but
  *   override keys in composition order.  Their version number is ignored.
@@ -383,46 +387,46 @@ static inline void bkey_init(struct bkey *k)
  *
  * - WHITEOUT: for hash table btrees
  */
-#define BCH_BKEY_TYPES()				\
-	x(deleted,		0)			\
-	x(whiteout,		1)			\
-	x(error,		2)			\
-	x(cookie,		3)			\
-	x(hash_whiteout,	4)			\
-	x(btree_ptr,		5)			\
-	x(extent,		6)			\
-	x(reservation,		7)			\
-	x(inode,		8)			\
-	x(inode_generation,	9)			\
-	x(dirent,		10)			\
-	x(xattr,		11)			\
-	x(alloc,		12)			\
-	x(quota,		13)			\
-	x(stripe,		14)			\
-	x(reflink_p,		15)			\
-	x(reflink_v,		16)			\
-	x(inline_data,		17)			\
-	x(btree_ptr_v2,		18)			\
-	x(indirect_inline_data,	19)			\
-	x(alloc_v2,		20)			\
-	x(subvolume,		21)			\
-	x(snapshot,		22)			\
-	x(inode_v2,		23)			\
-	x(alloc_v3,		24)			\
-	x(set,			25)			\
-	x(lru,			26)			\
-	x(alloc_v4,		27)			\
-	x(backpointer,		28)			\
-	x(inode_v3,		29)			\
-	x(bucket_gens,		30)			\
-	x(snapshot_tree,	31)			\
-	x(logged_op_truncate,	32)			\
-	x(logged_op_finsert,	33)			\
-	x(accounting,		34)			\
-	x(inode_alloc_cursor,	35)
+#define BCH_BKEY_TYPES()						\
+	x(deleted,		0,	0)				\
+	x(whiteout,		1,	0)				\
+	x(error,		2,	0)				\
+	x(cookie,		3,	0)				\
+	x(hash_whiteout,	4,	BKEY_TYPE_strict_btree_checks)	\
+	x(btree_ptr,		5,	BKEY_TYPE_strict_btree_checks)	\
+	x(extent,		6,	BKEY_TYPE_strict_btree_checks)	\
+	x(reservation,		7,	BKEY_TYPE_strict_btree_checks)	\
+	x(inode,		8,	BKEY_TYPE_strict_btree_checks)	\
+	x(inode_generation,	9,	BKEY_TYPE_strict_btree_checks)	\
+	x(dirent,		10,	BKEY_TYPE_strict_btree_checks)	\
+	x(xattr,		11,	BKEY_TYPE_strict_btree_checks)	\
+	x(alloc,		12,	BKEY_TYPE_strict_btree_checks)	\
+	x(quota,		13,	BKEY_TYPE_strict_btree_checks)	\
+	x(stripe,		14,	BKEY_TYPE_strict_btree_checks)	\
+	x(reflink_p,		15,	BKEY_TYPE_strict_btree_checks)	\
+	x(reflink_v,		16,	BKEY_TYPE_strict_btree_checks)	\
+	x(inline_data,		17,	BKEY_TYPE_strict_btree_checks)	\
+	x(btree_ptr_v2,		18,	BKEY_TYPE_strict_btree_checks)	\
+	x(indirect_inline_data,	19,	BKEY_TYPE_strict_btree_checks)	\
+	x(alloc_v2,		20,	BKEY_TYPE_strict_btree_checks)	\
+	x(subvolume,		21,	BKEY_TYPE_strict_btree_checks)	\
+	x(snapshot,		22,	BKEY_TYPE_strict_btree_checks)	\
+	x(inode_v2,		23,	BKEY_TYPE_strict_btree_checks)	\
+	x(alloc_v3,		24,	BKEY_TYPE_strict_btree_checks)	\
+	x(set,			25,	0)				\
+	x(lru,			26,	BKEY_TYPE_strict_btree_checks)	\
+	x(alloc_v4,		27,	BKEY_TYPE_strict_btree_checks)	\
+	x(backpointer,		28,	BKEY_TYPE_strict_btree_checks)	\
+	x(inode_v3,		29,	BKEY_TYPE_strict_btree_checks)	\
+	x(bucket_gens,		30,	BKEY_TYPE_strict_btree_checks)	\
+	x(snapshot_tree,	31,	BKEY_TYPE_strict_btree_checks)	\
+	x(logged_op_truncate,	32,	BKEY_TYPE_strict_btree_checks)	\
+	x(logged_op_finsert,	33,	BKEY_TYPE_strict_btree_checks)	\
+	x(accounting,		34,	BKEY_TYPE_strict_btree_checks)	\
+	x(inode_alloc_cursor,	35,	BKEY_TYPE_strict_btree_checks)
 
 enum bch_bkey_type {
-#define x(name, nr) KEY_TYPE_##name	= nr,
+#define x(name, nr, ...) KEY_TYPE_##name	= nr,
 	BCH_BKEY_TYPES()
 #undef x
 	KEY_TYPE_MAX,
diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
index 15c93576b5c2..00d05ccfaf73 100644
--- a/fs/bcachefs/bkey_methods.c
+++ b/fs/bcachefs/bkey_methods.c
@@ -21,7 +21,7 @@
 #include "xattr.h"
 
 const char * const bch2_bkey_types[] = {
-#define x(name, nr) #name,
+#define x(name, nr, ...) #name,
 	BCH_BKEY_TYPES()
 #undef x
 	NULL
@@ -115,7 +115,7 @@ static bool key_type_set_merge(struct bch_fs *c, struct bkey_s l, struct bkey_s_
 })
 
 const struct bkey_ops bch2_bkey_ops[] = {
-#define x(name, nr) [KEY_TYPE_##name]	= bch2_bkey_ops_##name,
+#define x(name, nr, ...) [KEY_TYPE_##name]	= bch2_bkey_ops_##name,
 	BCH_BKEY_TYPES()
 #undef x
 };
@@ -155,6 +155,12 @@ static u64 bch2_key_types_allowed[] = {
 #undef x
 };
 
+static const enum bch_bkey_type_flags bch2_bkey_type_flags[] = {
+#define x(name, nr, flags)	[KEY_TYPE_##name] = flags,
+	BCH_BKEY_TYPES()
+#undef x
+};
+
 const char *bch2_btree_node_type_str(enum btree_node_type type)
 {
 	return type == BKEY_TYPE_btree ? "internal btree node" : bch2_btree_id_str(type - 1);
@@ -177,8 +183,18 @@ int __bch2_bkey_validate(struct bch_fs *c, struct bkey_s_c k,
 	if (type >= BKEY_TYPE_NR)
 		return 0;
 
-	bkey_fsck_err_on(k.k->type < KEY_TYPE_MAX &&
-			 (type == BKEY_TYPE_btree || (from.flags & BCH_VALIDATE_commit)) &&
+	enum bch_bkey_type_flags bkey_flags = k.k->type < KEY_TYPE_MAX
+		? bch2_bkey_type_flags[k.k->type]
+		: 0;
+
+	bool strict_key_type_allowed =
+		(from.flags & BCH_VALIDATE_commit) ||
+		type == BKEY_TYPE_btree ||
+		(from.btree < BTREE_ID_NR &&
+		 (bkey_flags & BKEY_TYPE_strict_btree_checks));
+
+	bkey_fsck_err_on(strict_key_type_allowed &&
+			 k.k->type < KEY_TYPE_MAX &&
 			 !(bch2_key_types_allowed[type] & BIT_ULL(k.k->type)),
 			 c, bkey_invalid_type_for_btree,
 			 "invalid key type for btree %s (%s)",
-- 
2.49.0

