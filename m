Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C127D139D
	for <linux-bcachefs@vger.kernel.org>; Sun, 31 Dec 2023 05:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RODvE1sw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703999778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8FtNviBjed9fCZaUm/ihs9w3/HEBoPqV4vd+XNLOiMk=;
	b=RODvE1swIudabuC//bXo56le47q1Oa/V2pVsAUbToBSsMTDQmDEKiHqF21dlibXaU941V1
	Q0SWpwwfvfNP19QcOdAxUZZQW918qrEzew5n+cZB01uv49UcEET3VblhJS9lIEo+Wj30wf
	CZ3QWcOFTwBaEA808Kt1DZW9R92OaJs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Add persistent identifiers for recovery passes
Date: Sun, 31 Dec 2023 00:16:06 -0500
Message-ID: <20231231051608.2558476-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The next patch will start to refer to recovery passes from the
superblock; naturally, we now need identifiers that don't change, since
the existing enum is in the order in which they are run and is not
fixed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c       | 34 ++++++++++++++-
 fs/bcachefs/recovery.h       |  3 ++
 fs/bcachefs/recovery_types.h | 84 ++++++++++++++++++++----------------
 3 files changed, 83 insertions(+), 38 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 5933b02e49e0..e205e7233ef6 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -503,7 +503,7 @@ static int bch2_fs_upgrade_for_subvolumes(struct bch_fs *c)
 }
 
 const char * const bch2_recovery_passes[] = {
-#define x(_fn, _when)	#_fn,
+#define x(_fn, ...)	#_fn,
 	BCH_RECOVERY_PASSES()
 #undef x
 	NULL
@@ -539,11 +539,41 @@ struct recovery_pass_fn {
 };
 
 static struct recovery_pass_fn recovery_pass_fns[] = {
-#define x(_fn, _when)	{ .fn = bch2_##_fn, .when = _when },
+#define x(_fn, _id, _when)	{ .fn = bch2_##_fn, .when = _when },
 	BCH_RECOVERY_PASSES()
 #undef x
 };
 
+u64 bch2_recovery_passes_to_stable(u64 v)
+{
+	static const u8 map[] = {
+#define x(n, id, ...)	[BCH_RECOVERY_PASS_##n] = BCH_RECOVERY_PASS_STABLE_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+	};
+
+	u64 ret = 0;
+	for (unsigned i = 0; i < ARRAY_SIZE(map); i++)
+		if (v & BIT_ULL(i))
+			ret |= BIT_ULL(map[i]);
+	return ret;
+}
+
+u64 bch2_recovery_passes_from_stable(u64 v)
+{
+	static const u8 map[] = {
+#define x(n, id, ...)	[BCH_RECOVERY_PASS_STABLE_##n] = BCH_RECOVERY_PASS_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+	};
+
+	u64 ret = 0;
+	for (unsigned i = 0; i < ARRAY_SIZE(map); i++)
+		if (v & BIT_ULL(i))
+			ret |= BIT_ULL(map[i]);
+	return ret;
+}
+
 static void check_version_upgrade(struct bch_fs *c)
 {
 	unsigned latest_compatible = bch2_latest_compatible_version(c->sb.version);
diff --git a/fs/bcachefs/recovery.h b/fs/bcachefs/recovery.h
index 175a21a0bf26..4e9d24719b2e 100644
--- a/fs/bcachefs/recovery.h
+++ b/fs/bcachefs/recovery.h
@@ -4,6 +4,9 @@
 
 extern const char * const bch2_recovery_passes[];
 
+u64 bch2_recovery_passes_to_stable(u64 v);
+u64 bch2_recovery_passes_from_stable(u64 v);
+
 /*
  * For when we need to rewind recovery passes and run a pass we skipped:
  */
diff --git a/fs/bcachefs/recovery_types.h b/fs/bcachefs/recovery_types.h
index 2d139864e27f..fa0c8efd2a1b 100644
--- a/fs/bcachefs/recovery_types.h
+++ b/fs/bcachefs/recovery_types.h
@@ -8,45 +8,57 @@
 #define PASS_ALWAYS		BIT(3)
 #define PASS_ONLINE		BIT(4)
 
+/*
+ * Passes may be reordered, but the second field is a persistent identifier and
+ * must never change:
+ */
 #define BCH_RECOVERY_PASSES()							\
-	x(alloc_read,				PASS_ALWAYS)			\
-	x(stripes_read,				PASS_ALWAYS)			\
-	x(initialize_subvolumes,		0)				\
-	x(snapshots_read,			PASS_ALWAYS)			\
-	x(check_topology,			0)				\
-	x(check_allocations,			PASS_FSCK)			\
-	x(trans_mark_dev_sbs,			PASS_ALWAYS|PASS_SILENT)	\
-	x(fs_journal_alloc,			PASS_ALWAYS|PASS_SILENT)	\
-	x(set_may_go_rw,			PASS_ALWAYS|PASS_SILENT)	\
-	x(journal_replay,			PASS_ALWAYS)			\
-	x(check_alloc_info,			PASS_ONLINE|PASS_FSCK)		\
-	x(check_lrus,				PASS_ONLINE|PASS_FSCK)		\
-	x(check_btree_backpointers,		PASS_ONLINE|PASS_FSCK)		\
-	x(check_backpointers_to_extents,	PASS_ONLINE|PASS_FSCK)		\
-	x(check_extents_to_backpointers,	PASS_ONLINE|PASS_FSCK)		\
-	x(check_alloc_to_lru_refs,		PASS_ONLINE|PASS_FSCK)		\
-	x(fs_freespace_init,			PASS_ALWAYS|PASS_SILENT)	\
-	x(bucket_gens_init,			0)				\
-	x(check_snapshot_trees,			PASS_ONLINE|PASS_FSCK)		\
-	x(check_snapshots,			PASS_ONLINE|PASS_FSCK)		\
-	x(check_subvols,			PASS_ONLINE|PASS_FSCK)		\
-	x(delete_dead_snapshots,		PASS_ONLINE|PASS_FSCK)		\
-	x(fs_upgrade_for_subvolumes,		0)				\
-	x(resume_logged_ops,			PASS_ALWAYS)			\
-	x(check_inodes,				PASS_FSCK)			\
-	x(check_extents,			PASS_FSCK)			\
-	x(check_indirect_extents,		PASS_FSCK)			\
-	x(check_dirents,			PASS_FSCK)			\
-	x(check_xattrs,				PASS_FSCK)			\
-	x(check_root,				PASS_ONLINE|PASS_FSCK)		\
-	x(check_directory_structure,		PASS_ONLINE|PASS_FSCK)		\
-	x(check_nlinks,				PASS_FSCK)			\
-	x(delete_dead_inodes,			PASS_FSCK|PASS_UNCLEAN)		\
-	x(fix_reflink_p,			0)				\
-	x(set_fs_needs_rebalance,		0)				\
+	x(alloc_read,				 0, PASS_ALWAYS)		\
+	x(stripes_read,				 1, PASS_ALWAYS)		\
+	x(initialize_subvolumes,		 2, 0)				\
+	x(snapshots_read,			 3, PASS_ALWAYS)		\
+	x(check_topology,			 4, 0)				\
+	x(check_allocations,			 5, PASS_FSCK)			\
+	x(trans_mark_dev_sbs,			 6, PASS_ALWAYS|PASS_SILENT)	\
+	x(fs_journal_alloc,			 7, PASS_ALWAYS|PASS_SILENT)	\
+	x(set_may_go_rw,			 8, PASS_ALWAYS|PASS_SILENT)	\
+	x(journal_replay,			 9, PASS_ALWAYS)		\
+	x(check_alloc_info,			10, PASS_ONLINE|PASS_FSCK)	\
+	x(check_lrus,				11, PASS_ONLINE|PASS_FSCK)	\
+	x(check_btree_backpointers,		12, PASS_ONLINE|PASS_FSCK)	\
+	x(check_backpointers_to_extents,	13, PASS_ONLINE|PASS_FSCK)	\
+	x(check_extents_to_backpointers,	14, PASS_ONLINE|PASS_FSCK)	\
+	x(check_alloc_to_lru_refs,		15, PASS_ONLINE|PASS_FSCK)	\
+	x(fs_freespace_init,			16, PASS_ALWAYS|PASS_SILENT)	\
+	x(bucket_gens_init,			17, 0)				\
+	x(check_snapshot_trees,			18, PASS_ONLINE|PASS_FSCK)	\
+	x(check_snapshots,			19, PASS_ONLINE|PASS_FSCK)	\
+	x(check_subvols,			20, PASS_ONLINE|PASS_FSCK)	\
+	x(delete_dead_snapshots,		21, PASS_ONLINE|PASS_FSCK)	\
+	x(fs_upgrade_for_subvolumes,		22, 0)				\
+	x(resume_logged_ops,			23, PASS_ALWAYS)		\
+	x(check_inodes,				24, PASS_FSCK)			\
+	x(check_extents,			25, PASS_FSCK)			\
+	x(check_indirect_extents,		26, PASS_FSCK)			\
+	x(check_dirents,			27, PASS_FSCK)			\
+	x(check_xattrs,				28, PASS_FSCK)			\
+	x(check_root,				29, PASS_ONLINE|PASS_FSCK)	\
+	x(check_directory_structure,		30, PASS_ONLINE|PASS_FSCK)	\
+	x(check_nlinks,				31, PASS_FSCK)			\
+	x(delete_dead_inodes,			32, PASS_FSCK|PASS_UNCLEAN)	\
+	x(fix_reflink_p,			33, 0)				\
+	x(set_fs_needs_rebalance,		34, 0)				\
 
+/* We normally enumerate recovery passes in the order we run them: */
 enum bch_recovery_pass {
-#define x(n, when)	BCH_RECOVERY_PASS_##n,
+#define x(n, id, when)	BCH_RECOVERY_PASS_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+};
+
+/* But we also need stable identifiers that can be used in the superblock */
+enum bch_recovery_pass_stable {
+#define x(n, id, when)	BCH_RECOVERY_PASS_STABLE_##n = id,
 	BCH_RECOVERY_PASSES()
 #undef x
 };
-- 
2.43.0

