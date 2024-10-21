Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE78193435
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482088; cv=none; b=q+BQjss5392ZkzZCTaVn4x6NPFDO5Op4shRKV+Rt+vz+gLX3yGsqvmfakg2xZtb5gHFYwHP3fd1EgrOhdZS7ASdBYcLYk63bthCqU1/gBl9xyPEf68gvoxBeCWbIABf+6ek0yi8ZZCvQbbsj95kzhNhygjKMp84JL2B+tVg4qm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482088; c=relaxed/simple;
	bh=ApQAyQohEw1bEL7xugN5yeCD6EbcYWnX/WZFBS4shi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMWRFKXhxBZB4tfDscWGhYQe+KvRBez9LGJRPHeh7fbQS4uGcF7PkGgpEJfgUUHjCuo0dMQAjHq6EgTBq0Uf4DyAMINAGt+i/43HpYgctknnU4RusL8tdsvTrjDTeSME3mvLk/56BkTFwZAROROCEt0M4gpCz5N5p29sz+jjBe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=je52x3N7; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="je52x3N7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l7ad72yryipWvo/cHVr5FfRA4Sj41g4pzFURnp5+B+A=;
	b=je52x3N755Igjgs8XqWOLKkYhD4RwbF6ul8hisLDapD3DEhwPEAj+t2fzl3FQB84ZZHaV+
	2DoDseE3BHKWUCME3A0qtyvpzH4EyQLbv6WPAz5bioWzddjRiiEzsg+wIy894foql85rjJ
	y9vTXHaszPHE9ejH0NHeK2heSoQ+XNQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/12] bcachefs: bch2_io_opts_fixups()
Date: Sun, 20 Oct 2024 23:40:54 -0400
Message-ID: <20241021034106.384756-4-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Centralize some io path option fixups - they weren't always being
applied correctly:

- background_compression uses compression if unset
- background_target uses foreground_target if unset
- nocow disables most fancy io path options

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  4 ++--
 fs/bcachefs/extents.c     |  2 +-
 fs/bcachefs/inode.c       |  4 ++--
 fs/bcachefs/opts.c        |  5 ++++-
 fs/bcachefs/opts.h        | 12 ++++++++++--
 fs/bcachefs/rebalance.c   |  4 ++--
 6 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 5ea432bc0052..a176e5439cbf 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -535,7 +535,7 @@ void bch2_data_update_opts_to_text(struct printbuf *out, struct bch_fs *c,
 	prt_newline(out);
 
 	prt_str(out, "compression:\t");
-	bch2_compression_opt_to_text(out, background_compression(*io_opts));
+	bch2_compression_opt_to_text(out, io_opts->background_compression);
 	prt_newline(out);
 
 	prt_str(out, "opts.replicas:\t");
@@ -647,7 +647,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 		BCH_WRITE_DATA_ENCODED|
 		BCH_WRITE_MOVE|
 		m->data_opts.write_flags;
-	m->op.compression_opt	= background_compression(io_opts);
+	m->op.compression_opt	= io_opts.background_compression;
 	m->op.watermark		= m->data_opts.btree_insert_flags & BCH_WATERMARK_MASK;
 
 	unsigned durability_have = 0, durability_removing = 0;
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 33f611f13570..f0d9390250c4 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1501,7 +1501,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
 	struct bkey_s k = bkey_i_to_s(_k);
 	struct bch_extent_rebalance *r;
 	unsigned target = opts->background_target;
-	unsigned compression = background_compression(*opts);
+	unsigned compression = opts->background_compression;
 	bool needs_rebalance;
 
 	if (!bkey_extent_is_direct_data(k.k))
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 46310fcdd2b3..3af6029ea9b7 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -14,6 +14,7 @@
 #include "extent_update.h"
 #include "fs.h"
 #include "inode.h"
+#include "opts.h"
 #include "str_hash.h"
 #include "snapshot.h"
 #include "subvolume.h"
@@ -1145,8 +1146,7 @@ void bch2_inode_opts_get(struct bch_io_opts *opts, struct bch_fs *c,
 	BCH_INODE_OPTS()
 #undef x
 
-	if (opts->nocow)
-		opts->compression = opts->background_compression = opts->data_checksum = opts->erasure_code = 0;
+	bch2_io_opts_fixups(opts);
 }
 
 int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_io_opts *opts)
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 6673cbd8bdb9..3fa8a85b008b 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -710,11 +710,14 @@ void bch2_opt_set_sb(struct bch_fs *c, struct bch_dev *ca,
 
 struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts src)
 {
-	return (struct bch_io_opts) {
+	struct bch_io_opts opts = {
 #define x(_name, _bits)	._name = src._name,
 	BCH_INODE_OPTS()
 #undef x
 	};
+
+	bch2_io_opts_fixups(&opts);
+	return opts;
 }
 
 bool bch2_opt_is_inode_opt(enum bch_opt_id id)
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 23dda014e331..dd27ef556611 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -626,9 +626,17 @@ struct bch_io_opts {
 #undef x
 };
 
-static inline unsigned background_compression(struct bch_io_opts opts)
+static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
 {
-	return opts.background_compression ?: opts.compression;
+	if (!opts->background_target)
+		opts->background_target = opts->foreground_target;
+	if (!opts->background_compression)
+		opts->background_compression = opts->compression;
+	if (opts->nocow) {
+		opts->compression = opts->background_compression = 0;
+		opts->data_checksum = 0;
+		opts->erasure_code = 0;
+	}
 }
 
 struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts);
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index cd6647374353..2f93ae8781bb 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -257,12 +257,12 @@ static bool rebalance_pred(struct bch_fs *c, void *arg,
 
 	if (k.k->p.inode) {
 		target		= io_opts->background_target;
-		compression	= background_compression(*io_opts);
+		compression	= io_opts->background_compression;
 	} else {
 		const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
 
 		target		= r ? r->target : io_opts->background_target;
-		compression	= r ? r->compression : background_compression(*io_opts);
+		compression	= r ? r->compression : io_opts->background_compression;
 	}
 
 	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, k, target, compression);
-- 
2.45.2

