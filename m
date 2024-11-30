Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636E0482EF
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930783; cv=none; b=EQgAoWHn1lSqD4QLYrCUEhRXlhD5y0yIljdk4WKMjkn85UzwKzaFFvAo9lq/tF1VQn3L2OqHboGTrYxHHMtrjerocaRJ/dKyoyMOx21fCB9caTcV4ftKeJl6ZCTIaQafIOXvZFEsemjBKrYQyE58PzovfA4J1UBmTTkSrNQreMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930783; c=relaxed/simple;
	bh=PrdyMpUF6VxIcBD08M5Z2UZddy5hm4MuhQ3KOYnnRMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqcsQYkHaN3ReHVAr+CJ73jhaK64ILvCYdmRoaLHuYAGdHWVYcbVIzBhTplKREzrhOqAuTD5hL67x8/PnFbB/kiDIUVOhSRP6OTnnXhESEu/8Vm8NJU0E1Fwu9Z8/8S4eyB8DvSh4RgqBZQSuJ5K+JdYDdle3AFm41sLO9ggYNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ucRoFGwG; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ucRoFGwG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BBlegEcrZT7h08LtpxpwQUmVxswENPWsPjC4p6y5RqQ=;
	b=ucRoFGwGfWuIR9CCbaWNV9lSQh6oTvGCVZOKeJru4ZJUco3GKdt+SWHgIUYbeH3fLn5/dN
	jTAOd5Rq1TAWNlBozguK4X3DO7zzHSlq6KDe5VuYpfiS/pf0bAMPTdj6YqvalPuL+xAPaC
	uGbObf/zE1K/2pGG62U0SQBRD4cuGMU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/8] bcachefs: Only run check_backpointers_to_extents in debug mode
Date: Fri, 29 Nov 2024 20:39:20 -0500
Message-ID: <20241130013922.3135792-9-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The backpointers passes, check_backpointers_to_extents() and
check_extents_to_backpointers() are the most expensive fsck passes.

Now that we're running the same check and repair code when using a
backpointer at runtime (via bch2_backpointer_get_key()) that fsck does,
there's no reason fsck needs to - except to verify that the filesystem
really has no errors in debug mode.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery_passes_types.h | 92 +++++++++++++++--------------
 fs/bcachefs/sb-errors_format.h      |  4 +-
 2 files changed, 51 insertions(+), 45 deletions(-)

diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index 94dc20ca2065..f967b23d50c8 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -8,53 +8,59 @@
 #define PASS_ALWAYS		BIT(3)
 #define PASS_ONLINE		BIT(4)
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+#define PASS_FSCK_DEBUG		BIT(1)
+#else
+#define PASS_FSCK_DEBUG		0
+#endif
+
 /*
  * Passes may be reordered, but the second field is a persistent identifier and
  * must never change:
  */
-#define BCH_RECOVERY_PASSES()							\
-	x(recovery_pass_empty,			41, PASS_SILENT)		\
-	x(scan_for_btree_nodes,			37, 0)				\
-	x(check_topology,			 4, 0)				\
-	x(accounting_read,			39, PASS_ALWAYS)		\
-	x(alloc_read,				 0, PASS_ALWAYS)		\
-	x(stripes_read,				 1, PASS_ALWAYS)		\
-	x(initialize_subvolumes,		 2, 0)				\
-	x(snapshots_read,			 3, PASS_ALWAYS)		\
-	x(check_allocations,			 5, PASS_FSCK)			\
-	x(trans_mark_dev_sbs,			 6, PASS_ALWAYS|PASS_SILENT)	\
-	x(fs_journal_alloc,			 7, PASS_ALWAYS|PASS_SILENT)	\
-	x(set_may_go_rw,			 8, PASS_ALWAYS|PASS_SILENT)	\
-	x(journal_replay,			 9, PASS_ALWAYS)		\
-	x(check_alloc_info,			10, PASS_ONLINE|PASS_FSCK)	\
-	x(check_lrus,				11, PASS_ONLINE|PASS_FSCK)	\
-	x(check_btree_backpointers,		12, PASS_ONLINE|PASS_FSCK)	\
-	x(check_backpointers_to_extents,	13, PASS_ONLINE|PASS_FSCK)	\
-	x(check_extents_to_backpointers,	14, PASS_ONLINE|PASS_FSCK)	\
-	x(check_alloc_to_lru_refs,		15, PASS_ONLINE|PASS_FSCK)	\
-	x(fs_freespace_init,			16, PASS_ALWAYS|PASS_SILENT)	\
-	x(bucket_gens_init,			17, 0)				\
-	x(reconstruct_snapshots,		38, 0)				\
-	x(check_snapshot_trees,			18, PASS_ONLINE|PASS_FSCK)	\
-	x(check_snapshots,			19, PASS_ONLINE|PASS_FSCK)	\
-	x(check_subvols,			20, PASS_ONLINE|PASS_FSCK)	\
-	x(check_subvol_children,		35, PASS_ONLINE|PASS_FSCK)	\
-	x(delete_dead_snapshots,		21, PASS_ONLINE|PASS_FSCK)	\
-	x(fs_upgrade_for_subvolumes,		22, 0)				\
-	x(check_inodes,				24, PASS_FSCK)			\
-	x(check_extents,			25, PASS_FSCK)			\
-	x(check_indirect_extents,		26, PASS_FSCK)			\
-	x(check_dirents,			27, PASS_FSCK)			\
-	x(check_xattrs,				28, PASS_FSCK)			\
-	x(check_root,				29, PASS_ONLINE|PASS_FSCK)	\
-	x(check_unreachable_inodes,		40, PASS_ONLINE|PASS_FSCK)	\
-	x(check_subvolume_structure,		36, PASS_ONLINE|PASS_FSCK)	\
-	x(check_directory_structure,		30, PASS_ONLINE|PASS_FSCK)	\
-	x(check_nlinks,				31, PASS_FSCK)			\
-	x(resume_logged_ops,			23, PASS_ALWAYS)		\
-	x(delete_dead_inodes,			32, PASS_ALWAYS)		\
-	x(fix_reflink_p,			33, 0)				\
-	x(set_fs_needs_rebalance,		34, 0)				\
+#define BCH_RECOVERY_PASSES()								\
+	x(recovery_pass_empty,			41, PASS_SILENT)			\
+	x(scan_for_btree_nodes,			37, 0)					\
+	x(check_topology,			 4, 0)					\
+	x(accounting_read,			39, PASS_ALWAYS)			\
+	x(alloc_read,				 0, PASS_ALWAYS)			\
+	x(stripes_read,				 1, PASS_ALWAYS)			\
+	x(initialize_subvolumes,		 2, 0)					\
+	x(snapshots_read,			 3, PASS_ALWAYS)			\
+	x(check_allocations,			 5, PASS_FSCK)				\
+	x(trans_mark_dev_sbs,			 6, PASS_ALWAYS|PASS_SILENT)		\
+	x(fs_journal_alloc,			 7, PASS_ALWAYS|PASS_SILENT)		\
+	x(set_may_go_rw,			 8, PASS_ALWAYS|PASS_SILENT)		\
+	x(journal_replay,			 9, PASS_ALWAYS)			\
+	x(check_alloc_info,			10, PASS_ONLINE|PASS_FSCK)		\
+	x(check_lrus,				11, PASS_ONLINE|PASS_FSCK)		\
+	x(check_btree_backpointers,		12, PASS_ONLINE|PASS_FSCK)		\
+	x(check_backpointers_to_extents,	13, PASS_ONLINE|PASS_FSCK_DEBUG)	\
+	x(check_extents_to_backpointers,	14, PASS_ONLINE|PASS_FSCK)		\
+	x(check_alloc_to_lru_refs,		15, PASS_ONLINE|PASS_FSCK)		\
+	x(fs_freespace_init,			16, PASS_ALWAYS|PASS_SILENT)		\
+	x(bucket_gens_init,			17, 0)					\
+	x(reconstruct_snapshots,		38, 0)					\
+	x(check_snapshot_trees,			18, PASS_ONLINE|PASS_FSCK)		\
+	x(check_snapshots,			19, PASS_ONLINE|PASS_FSCK)		\
+	x(check_subvols,			20, PASS_ONLINE|PASS_FSCK)		\
+	x(check_subvol_children,		35, PASS_ONLINE|PASS_FSCK)		\
+	x(delete_dead_snapshots,		21, PASS_ONLINE|PASS_FSCK)		\
+	x(fs_upgrade_for_subvolumes,		22, 0)					\
+	x(check_inodes,				24, PASS_FSCK)				\
+	x(check_extents,			25, PASS_FSCK)				\
+	x(check_indirect_extents,		26, PASS_FSCK)				\
+	x(check_dirents,			27, PASS_FSCK)				\
+	x(check_xattrs,				28, PASS_FSCK)				\
+	x(check_root,				29, PASS_ONLINE|PASS_FSCK)		\
+	x(check_unreachable_inodes,		40, PASS_ONLINE|PASS_FSCK)		\
+	x(check_subvolume_structure,		36, PASS_ONLINE|PASS_FSCK)		\
+	x(check_directory_structure,		30, PASS_ONLINE|PASS_FSCK)		\
+	x(check_nlinks,				31, PASS_FSCK)				\
+	x(resume_logged_ops,			23, PASS_ALWAYS)			\
+	x(delete_dead_inodes,			32, PASS_ALWAYS)			\
+	x(fix_reflink_p,			33, 0)					\
+	x(set_fs_needs_rebalance,		34, 0)
 
 /* We normally enumerate recovery passes in the order we run them: */
 enum bch_recovery_pass {
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 3bbda181f314..4248ff3c894a 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -140,8 +140,8 @@ enum bch_fsck_flags {
 	x(backpointer_bucket_offset_wrong,			125,	0)		\
 	x(backpointer_level_bad,				294,	0)		\
 	x(backpointer_dev_bad,					297,	0)		\
-	x(backpointer_to_missing_device,			126,	0)		\
-	x(backpointer_to_missing_alloc,				127,	0)		\
+	x(backpointer_to_missing_device,			126,	FSCK_AUTOFIX)	\
+	x(backpointer_to_missing_alloc,				127,	FSCK_AUTOFIX)	\
 	x(backpointer_to_missing_ptr,				128,	FSCK_AUTOFIX)	\
 	x(lru_entry_at_time_0,					129,	FSCK_AUTOFIX)	\
 	x(lru_entry_to_invalid_bucket,				130,	FSCK_AUTOFIX)	\
-- 
2.45.2

