Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBDE187325
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 20:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738183786; cv=none; b=JM/IwEAgKaXb6S2xYLwWL0s3yWRUu9Pah1WO4UCkjoPHGNljVZ2zqXQLBKvCSYXl0mQhXeJ+6q6TUGnAl37DXE86Uk1gn8F3cPc7jkHtnPJNxzknQwjfnxLXvnXcsmxCKQc94FMFjRSQirepMfaD0UvqcrGHS0SkBFJ3IcU1gt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738183786; c=relaxed/simple;
	bh=AIZSoeUu9BUwl1tVdlvUvUMyhYKXmR1/5TLzsCORNzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oeQgTLJHvTTigWcqT7biRaX5bA0vjY9WrunUhXAUAPvdMtGPGtrC5TsAqFCdKf2LbdL1WDfUtISDkUqmkkEvHQJdcKbq6OI5xdculgu0tYpqt0ZQP+gRyfHKjb+MyW8Jla0myI8ZoDBPMgpqb865HZ+ATYvBF1SuTSF0r7U3r3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y0XTUyxP; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y0XTUyxP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738183781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b9fXDl5H9wNFRwD7u8jZ11Ag4A7dYm+0JF9FIF7iK9U=;
	b=Y0XTUyxPKYPp1BGgsbrTujmbt480ondWpRGerPwaQiXsjqE1qrjUhWyALdcPD1fRWJF0sg
	e6BpfRZtclgW9s8UayT5/ZcQyBaB/OEfKVusLbn5z9cDhbGfmef4VkTSzvP04z2eKozt21
	Y3VwNrEnvEGpmE5eESE5PfphC054SVA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: bch2_bkey_sectors_need_rebalance() now only depends on bch_extent_rebalance
Date: Wed, 29 Jan 2025 15:49:33 -0500
Message-ID: <20250129204933.222442-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previously, bch2_bkey_sectors_need_rebalance() called
bch2_target_accepts_data(), checking whether the target is writable.

However, this means that adding or removing devices from a target would
change the value of bch2_bkey_sectors_need_rebalance() for an existing
extent; this needs to be invariant so that the extent trigger can
correctly maintain rebalance_work accounting.

Instead, check target_accepts_data() in io_opts_to_rebalance_opts(),
before creating the bch_extent_rebalance entry.

This fixes (one?) cause of rebalance_work accounting being off.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/inode.h     |  4 +++-
 fs/bcachefs/opts.h      | 14 --------------
 fs/bcachefs/rebalance.c |  8 +++-----
 fs/bcachefs/rebalance.h | 20 ++++++++++++++++++++
 4 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index d2e134528f0e..428b9be6af34 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -285,12 +285,14 @@ void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
 int bch2_inum_opts_get(struct btree_trans*, subvol_inum, struct bch_io_opts *);
 
+#include "rebalance.h"
+
 static inline struct bch_extent_rebalance
 bch2_inode_rebalance_opts_get(struct bch_fs *c, struct bch_inode_unpacked *inode)
 {
 	struct bch_io_opts io_opts;
 	bch2_inode_opts_get(&io_opts, c, inode);
-	return io_opts_to_rebalance_opts(&io_opts);
+	return io_opts_to_rebalance_opts(c, &io_opts);
 }
 
 int bch2_inode_rm_snapshot(struct btree_trans *, u64, u32);
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index a182b5d454ba..9d397fc2a1f0 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -659,18 +659,4 @@ static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
 struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts);
 bool bch2_opt_is_inode_opt(enum bch_opt_id);
 
-/* rebalance opts: */
-
-static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_io_opts *opts)
-{
-	return (struct bch_extent_rebalance) {
-		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
-#define x(_name)							\
-		._name = opts->_name,					\
-		._name##_from_inode = opts->_name##_from_inode,
-		BCH_REBALANCE_OPTS()
-#undef x
-	};
-};
-
 #endif /* _BCACHEFS_OPTS_H */
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 90dbf04c07a1..58f6d97e506c 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -121,12 +121,10 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 		}
 	}
 incompressible:
-	if (opts->background_target &&
-	    bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target)) {
+	if (opts->background_target)
 		bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
 			if (!p.ptr.cached && !bch2_dev_in_target(c, p.ptr.dev, opts->background_target))
 				sectors += p.crc.compressed_size;
-	}
 
 	return sectors;
 }
@@ -140,7 +138,7 @@ static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_io_opt
 	const struct bch_extent_rebalance *old = bch2_bkey_rebalance_opts(k);
 
 	if (k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k)) {
-		struct bch_extent_rebalance new = io_opts_to_rebalance_opts(opts);
+		struct bch_extent_rebalance new = io_opts_to_rebalance_opts(c, opts);
 		return old == NULL || memcmp(old, &new, sizeof(new));
 	} else {
 		return old != NULL;
@@ -163,7 +161,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
 			k.k->u64s += sizeof(*old) / sizeof(u64);
 		}
 
-		*old = io_opts_to_rebalance_opts(opts);
+		*old = io_opts_to_rebalance_opts(c, opts);
 	} else {
 		if (old)
 			extent_entry_drop(k, (union bch_extent_entry *) old);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 0a0821ab895d..62a3859d3823 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -4,8 +4,28 @@
 
 #include "compress.h"
 #include "disk_groups.h"
+#include "opts.h"
 #include "rebalance_types.h"
 
+static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_fs *c,
+								    struct bch_io_opts *opts)
+{
+	struct bch_extent_rebalance r = {
+		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
+#define x(_name)							\
+		._name = opts->_name,					\
+		._name##_from_inode = opts->_name##_from_inode,
+		BCH_REBALANCE_OPTS()
+#undef x
+	};
+
+	if (r.background_target &&
+	    !bch2_target_accepts_data(c, BCH_DATA_user, r.background_target))
+		r.background_target = 0;
+
+	return r;
+};
+
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
 int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_io_opts *, struct bkey_i *);
 int bch2_get_update_rebalance_opts(struct btree_trans *,
-- 
2.45.2

