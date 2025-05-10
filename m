Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950C61E9B29
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 May 2025 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746838989; cv=none; b=TlWQehJJOUb6/nr8xniWdSpmvGTDBkbP7TX+v0fpRXxNNTE4ekyBJqtsIBJPmPoKZYli4UCGZ5qx0lSYtE4sWBxRBOUbV0WlxF3AFy7iyhkxfVe2GiLkocJhbOutYUg7PoZM69Kwoc2tNX5vXr7TCoQBbrxzq9JYxrZX49xQ77I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746838989; c=relaxed/simple;
	bh=AThFsDLgjCUVJmNl7SSnqyFxejI+9eFC6gglAzO5NEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxkiX/mgGN4U4AI/ZQfoQhAdoJCG+wl9FbtFWwvNK02/k29Ad1Jk93NMURGUiiaX2EyS1vZvxaowHQSBjmjdOJi8FzC2vPb7Cty6QZ0PwcyT+Nw0bGwDqc02NZDvrS7t0odf8rIDIM7fQOQRp2vIMud1u36WXO10xD1tJ5ci/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p+uoBGx/; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p+uoBGx/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746838982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9B/7q8nyOqNorSFjNijN+4mlaINfm4OvAV23Dbf7j1E=;
	b=p+uoBGx/6ANQuaSLY7RPZD79lFioeMRImK8CLdog3Sha4czIY7yEclCH0zM4rO5Wlwg92P
	8gCCbi+JjsqQW1qdB3pU7Crpwf+XijmaEDb4Hd0gL2D7FoSMUzGwqZZSK21cxo9QlV82rt
	czjXwoQnAWOlhUxu+oA61CLQQFOJVWo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: bch_sb_field_recovery_passes
Date: Fri,  9 May 2025 21:02:54 -0400
Message-ID: <20250510010254.3790016-2-kent.overstreet@linux.dev>
In-Reply-To: <20250510010254.3790016-1-kent.overstreet@linux.dev>
References: <20250510010254.3790016-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

New superblock section for statistics on recovery passes - last time
ran (successfully), last runtime.

This will be used by self healing code to determine when to kick off
potentially expensive recovery passes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c           |   7 ++
 fs/bcachefs/bcachefs_format.h        |   3 +-
 fs/bcachefs/recovery_passes.c        | 181 +++++++++++++++++++--------
 fs/bcachefs/recovery_passes.h        |   2 +
 fs/bcachefs/recovery_passes_format.h |  20 +++
 fs/bcachefs/sb-members.c             |  14 +--
 6 files changed, 161 insertions(+), 66 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 321c7b53d970..597ea0a65c6e 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -1228,6 +1228,13 @@ int bch2_check_bucket_backpointer_mismatch(struct btree_trans *trans,
 	if (nr > allowed)
 		bch2_check_extents_to_backpointers_async(trans->c);
 
+	/*
+	 * Track duration of last check_extents_to_backpointers (all recovery
+	 * passes?)
+	 *
+	 * Track when we last ran check_extents_to_backpointers
+	 */
+
 	return ret;
 }
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index df5a4d4df640..5900ff3715c6 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -497,7 +497,8 @@ struct bch_sb_field {
 	x(members_v2,			11)	\
 	x(errors,			12)	\
 	x(ext,				13)	\
-	x(downgrade,			14)
+	x(downgrade,			14)	\
+	x(recovery_passes,		15)
 
 #include "alloc_background_format.h"
 #include "dirent_format.h"
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index e14aca00cb7d..a9df3717d619 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -28,6 +28,125 @@ const char * const bch2_recovery_passes[] = {
 	NULL
 };
 
+static const u8 passes_to_stable_map[] = {
+#define x(n, id, ...)	[BCH_RECOVERY_PASS_##n] = BCH_RECOVERY_PASS_STABLE_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+};
+
+static const u8 passes_from_stable_map[] = {
+#define x(n, id, ...)	[BCH_RECOVERY_PASS_STABLE_##n] = BCH_RECOVERY_PASS_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+};
+
+static enum bch_recovery_pass_stable bch2_recovery_pass_to_stable(enum bch_recovery_pass pass)
+{
+	return passes_to_stable_map[pass];
+}
+
+u64 bch2_recovery_passes_to_stable(u64 v)
+{
+	u64 ret = 0;
+	for (unsigned i = 0; i < ARRAY_SIZE(passes_to_stable_map); i++)
+		if (v & BIT_ULL(i))
+			ret |= BIT_ULL(passes_to_stable_map[i]);
+	return ret;
+}
+
+static enum bch_recovery_pass bch2_recovery_pass_from_stable(enum bch_recovery_pass_stable pass)
+{
+	return pass < ARRAY_SIZE(passes_from_stable_map)
+		? passes_from_stable_map[pass]
+		: 0;
+}
+
+u64 bch2_recovery_passes_from_stable(u64 v)
+{
+	u64 ret = 0;
+	for (unsigned i = 0; i < ARRAY_SIZE(passes_from_stable_map); i++)
+		if (v & BIT_ULL(i))
+			ret |= BIT_ULL(passes_from_stable_map[i]);
+	return ret;
+}
+
+static int bch2_sb_recovery_passes_validate(struct bch_sb *sb, struct bch_sb_field *f,
+					    enum bch_validate_flags flags, struct printbuf *err)
+{
+	return 0;
+}
+
+static void bch2_sb_recovery_passes_to_text(struct printbuf *out,
+					    struct bch_sb *sb,
+					    struct bch_sb_field *f)
+{
+	struct bch_sb_field_recovery_passes *r =
+		field_to_type(f, recovery_passes);
+	unsigned nr = recovery_passes_nr_entries(r);
+
+	if (out->nr_tabstops < 1)
+		printbuf_tabstop_push(out, 32);
+	if (out->nr_tabstops < 2)
+		printbuf_tabstop_push(out, 16);
+
+	prt_printf(out, "Pass\tLast run\tLast runtime\n");
+
+	for (struct recovery_pass_entry *i = r->start; i < r->start + nr; i++) {
+		if (!i->last_run)
+			continue;
+
+		unsigned idx = i - r->start;
+
+		prt_printf(out, "%s\t", bch2_recovery_passes[bch2_recovery_pass_from_stable(idx)]);
+
+		bch2_prt_datetime(out, le64_to_cpu(i->last_run));
+		prt_tab(out);
+
+		bch2_pr_time_units(out, le32_to_cpu(i->last_runtime) * NSEC_PER_SEC);
+		prt_newline(out);
+	}
+}
+
+static void bch2_sb_recovery_pass_complete(struct bch_fs *c,
+					   enum bch_recovery_pass pass,
+					   s64 start_time)
+{
+	enum bch_recovery_pass_stable stable = bch2_recovery_pass_to_stable(pass);
+	s64 end_time = ktime_get_real_seconds();
+
+	mutex_lock(&c->sb_lock);
+	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+	__clear_bit_le64(stable, ext->recovery_passes_required);
+
+	struct bch_sb_field_recovery_passes *r =
+		bch2_sb_field_get(c->disk_sb.sb, recovery_passes);
+
+	if (stable >= recovery_passes_nr_entries(r)) {
+		unsigned u64s = struct_size(r, start, stable + 1) / sizeof(u64);
+
+		r = bch2_sb_field_resize(&c->disk_sb, recovery_passes, u64s);
+		if (!r) {
+			bch_err(c, "error creating recovery_passes sb section");
+			goto out;
+		}
+	}
+
+	r->start[stable].last_run	= cpu_to_le64(end_time);
+	r->start[stable].last_runtime	= cpu_to_le32(max(0, end_time - start_time));
+
+	/*
+	 * Don't bother with writing the superblock just for this, there'll be a
+	 * superblock write before we shutdown:
+	 */
+out:
+	mutex_unlock(&c->sb_lock);
+}
+
+const struct bch_sb_field_ops bch_sb_field_ops_recovery_passes = {
+	.validate	= bch2_sb_recovery_passes_validate,
+	.to_text	= bch2_sb_recovery_passes_to_text
+};
+
 /* Fake recovery pass, so that scan_for_btree_nodes isn't 0: */
 static int bch2_recovery_pass_empty(struct bch_fs *c)
 {
@@ -88,41 +207,6 @@ static struct recovery_pass_fn recovery_pass_fns[] = {
 #undef x
 };
 
-static const u8 passes_to_stable_map[] = {
-#define x(n, id, ...)	[BCH_RECOVERY_PASS_##n] = BCH_RECOVERY_PASS_STABLE_##n,
-	BCH_RECOVERY_PASSES()
-#undef x
-};
-
-static enum bch_recovery_pass_stable bch2_recovery_pass_to_stable(enum bch_recovery_pass pass)
-{
-	return passes_to_stable_map[pass];
-}
-
-u64 bch2_recovery_passes_to_stable(u64 v)
-{
-	u64 ret = 0;
-	for (unsigned i = 0; i < ARRAY_SIZE(passes_to_stable_map); i++)
-		if (v & BIT_ULL(i))
-			ret |= BIT_ULL(passes_to_stable_map[i]);
-	return ret;
-}
-
-u64 bch2_recovery_passes_from_stable(u64 v)
-{
-	static const u8 map[] = {
-#define x(n, id, ...)	[BCH_RECOVERY_PASS_STABLE_##n] = BCH_RECOVERY_PASS_##n,
-	BCH_RECOVERY_PASSES()
-#undef x
-	};
-
-	u64 ret = 0;
-	for (unsigned i = 0; i < ARRAY_SIZE(map); i++)
-		if (v & BIT_ULL(i))
-			ret |= BIT_ULL(map[i]);
-	return ret;
-}
-
 /*
  * For when we need to rewind recovery passes and run a pass we skipped:
  */
@@ -219,21 +303,6 @@ int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *c,
 	return ret;
 }
 
-static void bch2_clear_recovery_pass_required(struct bch_fs *c,
-					      enum bch_recovery_pass pass)
-{
-	enum bch_recovery_pass_stable s = bch2_recovery_pass_to_stable(pass);
-
-	mutex_lock(&c->sb_lock);
-	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
-
-	if (test_bit_le64(s, ext->recovery_passes_required)) {
-		__clear_bit_le64(s, ext->recovery_passes_required);
-		bch2_write_super(c);
-	}
-	mutex_unlock(&c->sb_lock);
-}
-
 u64 bch2_fsck_recovery_passes(void)
 {
 	u64 ret = 0;
@@ -266,14 +335,19 @@ static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pa
 static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
 	struct recovery_pass_fn *p = recovery_pass_fns + pass;
-	int ret;
 
 	if (!(p->when & PASS_SILENT))
 		bch2_print(c, KERN_INFO bch2_log_msg(c, "%s..."),
 			   bch2_recovery_passes[pass]);
-	ret = p->fn(c);
+
+	s64 start_time = ktime_get_real_seconds();
+	int ret = p->fn(c);
 	if (ret)
 		return ret;
+
+	if (!test_bit(BCH_FS_error, &c->flags))
+		bch2_sb_recovery_pass_complete(c, pass, start_time);
+
 	if (!(p->when & PASS_SILENT))
 		bch2_print(c, KERN_CONT " done\n");
 
@@ -326,9 +400,6 @@ int bch2_run_recovery_passes(struct bch_fs *c)
 			spin_unlock_irq(&c->recovery_pass_lock);
 			ret =   bch2_run_recovery_pass(c, pass) ?:
 				bch2_journal_flush(&c->journal);
-
-			if (!ret && !test_bit(BCH_FS_error, &c->flags))
-				bch2_clear_recovery_pass_required(c, pass);
 			spin_lock_irq(&c->recovery_pass_lock);
 
 			if (c->next_recovery_pass < c->curr_recovery_pass) {
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index f33dd005beb4..d39856f908da 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -3,6 +3,8 @@
 
 extern const char * const bch2_recovery_passes[];
 
+extern const struct bch_sb_field_ops bch_sb_field_ops_recovery_passes;
+
 u64 bch2_recovery_passes_to_stable(u64 v);
 u64 bch2_recovery_passes_from_stable(u64 v);
 
diff --git a/fs/bcachefs/recovery_passes_format.h b/fs/bcachefs/recovery_passes_format.h
index 291f58dfbd24..c434eafbca19 100644
--- a/fs/bcachefs/recovery_passes_format.h
+++ b/fs/bcachefs/recovery_passes_format.h
@@ -81,4 +81,24 @@ enum bch_recovery_pass_stable {
 #undef x
 };
 
+struct recovery_pass_entry {
+	__le64			last_run;
+	__le32			last_runtime;
+	__le32			flags;
+};
+
+struct bch_sb_field_recovery_passes {
+	struct bch_sb_field	field;
+	struct recovery_pass_entry start[];
+};
+
+static inline unsigned
+recovery_passes_nr_entries(struct bch_sb_field_recovery_passes *r)
+{
+	return r
+		? ((vstruct_end(&r->field) - (void *) &r->start[0]) /
+		   sizeof(struct recovery_pass_entry))
+		: 0;
+}
+
 #endif /* _BCACHEFS_RECOVERY_PASSES_FORMAT_H */
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 563263d65cf0..0cc26ebceb30 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -222,17 +222,11 @@ static void member_to_text(struct printbuf *out,
 	printbuf_indent_add(out, 2);
 
 	prt_printf(out, "Label:\t");
-	if (BCH_MEMBER_GROUP(&m)) {
-		unsigned idx = BCH_MEMBER_GROUP(&m) - 1;
-
-		if (idx < disk_groups_nr(gi))
-			prt_printf(out, "%s (%u)",
-				   gi->entries[idx].label, idx);
-		else
-			prt_printf(out, "(bad disk labels section)");
-	} else {
+	if (BCH_MEMBER_GROUP(&m))
+		bch2_disk_path_to_text_sb(out, sb,
+				BCH_MEMBER_GROUP(&m) - 1);
+	else
 		prt_printf(out, "(none)");
-	}
 	prt_newline(out);
 
 	prt_printf(out, "UUID:\t");
-- 
2.49.0

