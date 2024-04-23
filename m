Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CBF13E3FA;
	Tue, 23 Apr 2024 18:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713898699; cv=none; b=SlnlGewThw+U9qVdFy1RX43YY3unmBS3YAeF12nb2NyS1Xi70kZQXPTIbKajCPRWqry1BPb8rEM1q/sb6B/hZrZHxHAeXSGe5ajm6o83Bw2cMksaFE/K5SE5fWXiR5wcGWbHi8U0GdsaT/qF2ZlbynBEnKuT9Tu8AsSwRekfjE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713898699; c=relaxed/simple;
	bh=JtyVKDcukUiMNjeUYyQLDUrnZURfO/x78P+1H9cY32g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sVjtcm2ORDc71k6b2XugHHDjIqfyujRT2jE9m7hiK4nMD4AEQfHoqK8vA1joWU7JeWQ1iDYCuX58LjsZk80hBeiYQ46uPGRqXzB4op2C3lTpJczPVv4a7WNIoGJDOgQMjpOHIjT+743Dr0LQTef2+dyVttiGel7GuwOjx3ZDokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnEujHg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnEujHg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483BDC116B1;
	Tue, 23 Apr 2024 18:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713898698;
	bh=JtyVKDcukUiMNjeUYyQLDUrnZURfO/x78P+1H9cY32g=;
	h=From:Date:Subject:To:Cc:From;
	b=nnEujHg0rYPIf1TszblUkm+/9Y9UHg1M/8ohbLraunc0UopqOMjLsX0tWH2j+Fimi
	 Ei2GrMd2wRL7rkfDkJwBD1gyEDQMv8oZPm9cwSVpaDYx9OZqrGxENGtX0OpEfxtbxg
	 FcoBbVDI2kjLUDQyUZPoND9b4gDvh9vdaE62ueg03TM1aaOrDh0k24C3gZjYM5Uflr
	 z8w0pao4/TC3odim0tfE7p+Ezhrwat7EezEN8pQWmGdzPj4iSxHU/UAdH51tUupoM1
	 rygKU9yvQJCMuv8r7vDdKsY57BKvmAtSm4sYEJOA7Tr4UDDLBw0+kCrCBEidu7ETqU
	 /R+ls0PhxzwVA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 23 Apr 2024 11:58:09 -0700
Subject: [PATCH] bcachefs: Fix type of flags parameter for some ->trigger()
 implementations
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240423-bcachefs-fix-wifpts-iter_update_trigger_flags-v1-1-c6a521821863@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMAEKGYC/x3N3QrCMAyG4VsZOTZQ69zEWxEZbZd2AZklqT8wd
 u8GD5+D9/s2UBImhWu3gdCblZ+r4XjoIC1hLYQ8m8E737venzCmkBbKipm/+OFcmyI3kulV59B
 oasKlGPMjFMVxHC4+xIHi2YFtViHr/n+3+77/ACQuEvZ/AAAA
To: kent.overstreet@linux.dev
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=9598; i=nathan@kernel.org;
 h=from:subject:message-id; bh=JtyVKDcukUiMNjeUYyQLDUrnZURfO/x78P+1H9cY32g=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkaLKf+3psbvJLhrO2ay0J/3ryaX3eqIW9Vstb/Ax07r
 n4+8U7kRUcpC4MYF4OsmCJL9WPV44aGc84y3jg1CWYOKxPIEAYuTgGYyFs+RoYJdXOsvTti27Yc
 3GNyVNp9ybnK3c+fPbHt6uWuNveoyjjB8N/VonK9RMNU1lnzb25K5bikn+L16f+0uXG696+s2uJ
 p9JMPAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with clang's -Wincompatible-function-pointer-types-strict
(a warning designed to catch potential kCFI failures at build time),
there are several warnings along the lines of:

  fs/bcachefs/bkey_methods.c:118:2: error: incompatible function pointer types initializing 'int (*)(struct btree_trans *, enum btree_id, unsigned int, struct bkey_s_c, struct bkey_s, enum btree_iter_update_trigger_flags)' with an expression of type 'int (struct btree_trans *, enum btree_id, unsigned int, struct bkey_s_c, struct bkey_s, unsigned int)' [-Werror,-Wincompatible-function-pointer-types-strict]
    118 |         BCH_BKEY_TYPES()
        |         ^~~~~~~~~~~~~~~~
  fs/bcachefs/bcachefs_format.h:394:2: note: expanded from macro 'BCH_BKEY_TYPES'
    394 |         x(inode,                8)                      \
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~
  fs/bcachefs/bkey_methods.c:117:41: note: expanded from macro 'x'
    117 | #define x(name, nr) [KEY_TYPE_##name]   = bch2_bkey_ops_##name,
        |                                           ^~~~~~~~~~~~~~~~~~~~
  <scratch space>:277:1: note: expanded from here
    277 | bch2_bkey_ops_inode
        | ^~~~~~~~~~~~~~~~~~~
  fs/bcachefs/inode.h:26:13: note: expanded from macro 'bch2_bkey_ops_inode'
     26 |         .trigger        = bch2_trigger_inode,           \
      |                           ^~~~~~~~~~~~~~~~~~

There are several functions that did not have their flags parameter
converted to 'enum btree_iter_update_trigger_flags' in the recent
unification, which will cause kCFI failures at runtime because the
types, while ABI compatible (hence no warning from the non-strict
version of this warning), do not match exactly.

Fix up these functions (as well as a few other obvious functions that
should have it, even if there are no warnings currently) to resolve the
warnings and potential kCFI runtime failures.

Fixes: 31e4ef3280c8 ("bcachefs: iter/update/trigger/str_hash flag cleanup")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/bcachefs/alloc_background.c | 2 +-
 fs/bcachefs/alloc_background.h | 3 ++-
 fs/bcachefs/inode.c            | 2 +-
 fs/bcachefs/inode.h            | 3 ++-
 fs/bcachefs/reflink.c          | 6 ++++--
 fs/bcachefs/reflink.h          | 2 +-
 fs/bcachefs/snapshot.c         | 4 ++--
 fs/bcachefs/snapshot.h         | 3 ++-
 fs/bcachefs/subvolume.c        | 2 +-
 fs/bcachefs/subvolume.h        | 3 ++-
 10 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 5de564baa61e..a66575c1be07 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -724,7 +724,7 @@ static noinline int bch2_bucket_gen_update(struct btree_trans *trans,
 int bch2_trigger_alloc(struct btree_trans *trans,
 		       enum btree_id btree, unsigned level,
 		       struct bkey_s_c old, struct bkey_s new,
-		       unsigned flags)
+		       enum btree_iter_update_trigger_flags flags)
 {
 	struct bch_fs *c = trans->c;
 	int ret = 0;
diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index f9589a2c7a1f..b1224e27eb18 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -228,7 +228,8 @@ static inline bool bkey_is_alloc(const struct bkey *k)
 int bch2_alloc_read(struct bch_fs *);
 
 int bch2_trigger_alloc(struct btree_trans *, enum btree_id, unsigned,
-		       struct bkey_s_c, struct bkey_s, unsigned);
+		       struct bkey_s_c, struct bkey_s,
+		       enum btree_iter_update_trigger_flags);
 int bch2_check_alloc_info(struct bch_fs *);
 int bch2_check_alloc_to_lru_refs(struct bch_fs *);
 void bch2_do_discards(struct bch_fs *);
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index f0da2b0048cc..cb69a94771ec 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -594,7 +594,7 @@ int bch2_trigger_inode(struct btree_trans *trans,
 		       enum btree_id btree_id, unsigned level,
 		       struct bkey_s_c old,
 		       struct bkey_s new,
-		       unsigned flags)
+		       enum btree_iter_update_trigger_flags flags)
 {
 	s64 nr = bkey_is_inode(new.k) - bkey_is_inode(old.k);
 
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 08e8505dfa33..46477a40846c 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -18,7 +18,8 @@ int bch2_inode_v3_invalid(struct bch_fs *, struct bkey_s_c,
 void bch2_inode_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
 int bch2_trigger_inode(struct btree_trans *, enum btree_id, unsigned,
-			  struct bkey_s_c, struct bkey_s, unsigned);
+		       struct bkey_s_c, struct bkey_s,
+		       enum btree_iter_update_trigger_flags);
 
 #define bch2_bkey_ops_inode ((struct bkey_ops) {	\
 	.key_invalid	= bch2_inode_invalid,		\
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index a0cf5d97513f..be9bec27be17 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -282,7 +282,9 @@ bool bch2_reflink_v_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r
 }
 #endif
 
-static inline void check_indirect_extent_deleting(struct bkey_s new, unsigned *flags)
+static inline void
+check_indirect_extent_deleting(struct bkey_s new,
+			       enum btree_iter_update_trigger_flags *flags)
 {
 	if ((*flags & BTREE_TRIGGER_insert) && !*bkey_refcount(new)) {
 		new.k->type = KEY_TYPE_deleted;
@@ -327,7 +329,7 @@ void bch2_indirect_inline_data_to_text(struct printbuf *out,
 int bch2_trigger_indirect_inline_data(struct btree_trans *trans,
 			      enum btree_id btree_id, unsigned level,
 			      struct bkey_s_c old, struct bkey_s new,
-			      unsigned flags)
+			      enum btree_iter_update_trigger_flags flags)
 {
 	check_indirect_extent_deleting(new, &flags);
 
diff --git a/fs/bcachefs/reflink.h b/fs/bcachefs/reflink.h
index e34c4bdf7a76..59d4dbae3fb1 100644
--- a/fs/bcachefs/reflink.h
+++ b/fs/bcachefs/reflink.h
@@ -44,7 +44,7 @@ void bch2_indirect_inline_data_to_text(struct printbuf *,
 int bch2_trigger_indirect_inline_data(struct btree_trans *,
 					 enum btree_id, unsigned,
 			      struct bkey_s_c, struct bkey_s,
-			      unsigned);
+			      enum btree_iter_update_trigger_flags);
 
 #define bch2_bkey_ops_indirect_inline_data ((struct bkey_ops) {	\
 	.key_invalid	= bch2_indirect_inline_data_invalid,	\
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 0b26dee17a5a..2368218070d4 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -298,7 +298,7 @@ static void set_is_ancestor_bitmap(struct bch_fs *c, u32 id)
 static int __bch2_mark_snapshot(struct btree_trans *trans,
 		       enum btree_id btree, unsigned level,
 		       struct bkey_s_c old, struct bkey_s_c new,
-		       unsigned flags)
+		       enum btree_iter_update_trigger_flags flags)
 {
 	struct bch_fs *c = trans->c;
 	struct snapshot_t *t;
@@ -352,7 +352,7 @@ static int __bch2_mark_snapshot(struct btree_trans *trans,
 int bch2_mark_snapshot(struct btree_trans *trans,
 		       enum btree_id btree, unsigned level,
 		       struct bkey_s_c old, struct bkey_s new,
-		       unsigned flags)
+		       enum btree_iter_update_trigger_flags flags)
 {
 	return __bch2_mark_snapshot(trans, btree, level, old, new.s_c, flags);
 }
diff --git a/fs/bcachefs/snapshot.h b/fs/bcachefs/snapshot.h
index ccb1f309b8d1..b3c43d579540 100644
--- a/fs/bcachefs/snapshot.h
+++ b/fs/bcachefs/snapshot.h
@@ -22,7 +22,8 @@ void bch2_snapshot_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 int bch2_snapshot_invalid(struct bch_fs *, struct bkey_s_c,
 			  enum bkey_invalid_flags, struct printbuf *);
 int bch2_mark_snapshot(struct btree_trans *, enum btree_id, unsigned,
-		       struct bkey_s_c, struct bkey_s, unsigned);
+		       struct bkey_s_c, struct bkey_s,
+		       enum btree_iter_update_trigger_flags);
 
 #define bch2_bkey_ops_snapshot ((struct bkey_ops) {		\
 	.key_invalid	= bch2_snapshot_invalid,		\
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index 33292dae4d50..3341285e7531 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -245,7 +245,7 @@ static int subvolume_children_mod(struct btree_trans *trans, struct bpos pos, bo
 int bch2_subvolume_trigger(struct btree_trans *trans,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c old, struct bkey_s new,
-			   unsigned flags)
+			   enum btree_iter_update_trigger_flags flags)
 {
 	if (flags & BTREE_TRIGGER_transactional) {
 		struct bpos children_pos_old = subvolume_children_pos(old);
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index d2015d549bd2..1530a10327ab 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -14,7 +14,8 @@ int bch2_subvolume_invalid(struct bch_fs *, struct bkey_s_c,
 			   enum bkey_invalid_flags, struct printbuf *);
 void bch2_subvolume_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 int bch2_subvolume_trigger(struct btree_trans *, enum btree_id, unsigned,
-			   struct bkey_s_c, struct bkey_s, unsigned);
+			   struct bkey_s_c, struct bkey_s,
+			   enum btree_iter_update_trigger_flags);
 
 #define bch2_bkey_ops_subvolume ((struct bkey_ops) {		\
 	.key_invalid	= bch2_subvolume_invalid,		\

---
base-commit: 711f072a8f7f795e63c4f729cc258ba238851333
change-id: 20240423-bcachefs-fix-wifpts-iter_update_trigger_flags-77682ab6eb50

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

