Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526FE225D6
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893833; cv=none; b=k93mjBHZ8lVqAUbN53VM77bMx0nuNf0KBxum+u3jr/4bmuqRypNsIW1QhMJci17d8YICNKxyuAZlZ+mawv/M8IjRXaqg5W8+RJ80RUB+KYWZ9Qam+Wo6lZIokIb5fBqCOqv9Y8T3DO8cDrjk+pwCHxPEPWSe/jUx+urPHhjjZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893833; c=relaxed/simple;
	bh=X0T3Kx12sLZlNPu9rZOg6Hn/LPf/TePw4hZvJpRopjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzJRz9DOZ6zZXsLeVzTbSJEdcuMlm71IS4BTYjKheYSaGqW/yqsQ+vOSAgOgG0qSKDlCYKkkaJJAJj0g18Ns9gIUvb8xbcwPFL5nurANJm8E27uFtWZgz5LkDsdAQeu07455L1KAvcg3oOIJ5waESYG+MHVddbtcdnvWII5hA4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iuk9iGk0; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iuk9iGk0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8KcUlIeXVdPujkCIlcmtwFqBk0kWqs50cmT7lVspF0=;
	b=iuk9iGk01dvbByczYn0MYvA5gHxYCh4D4zDkpj8e6zcuq55/rsENbiA+yHHE9LSmbre9F6
	yFenvYGRuQHTia3VmFh8MXpmXIPBcvpdWIy4RJ763duLeB7rPvc8FBgTzQaNCEzqLkhFvd
	tpOpOIUWhU86pB+SyIiPSco2VHVBsHQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+cb3fbcfb417448cfd278@syzkaller.appspotmail.com
Subject: [PATCH 3/3] bcachefs: Don't BUG_ON() when superblock feature wasn't set for compressed data
Date: Sun, 17 Nov 2024 20:36:51 -0500
Message-ID: <20241118013651.2275187-3-kent.overstreet@linux.dev>
In-Reply-To: <20241118013651.2275187-1-kent.overstreet@linux.dev>
References: <20241118013651.2275187-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't allocate the mempools for compression/decompression unless we
need them - but that means there's an inconsistency to check for.

Reported-by: syzbot+cb3fbcfb417448cfd278@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/compress.c         | 29 +++++++++++++++++++++++++++--
 fs/bcachefs/errcode.h          |  1 +
 fs/bcachefs/opts.c             |  2 +-
 fs/bcachefs/opts.h             |  1 +
 fs/bcachefs/sb-errors_format.h |  4 +++-
 5 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 2813e4556f0d..f99ff1819597 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -2,7 +2,9 @@
 #include "bcachefs.h"
 #include "checksum.h"
 #include "compress.h"
+#include "error.h"
 #include "extents.h"
+#include "opts.h"
 #include "super-io.h"
 
 #include <linux/lz4.h>
@@ -178,7 +180,16 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 
 	enum bch_compression_opts opt = bch2_compression_type_to_opt(crc.compression_type);
 	mempool_t *workspace_pool = &c->compress_workspace[opt];
-	BUG_ON(!mempool_initialized(workspace_pool));
+	if (unlikely(!mempool_initialized(workspace_pool))) {
+		if (fsck_err(c, compression_type_not_marked_in_sb,
+			     "compression type %s set but not marked in superblock",
+			     __bch2_compression_types[crc.compression_type]))
+			ret = bch2_check_set_has_compressed_data(c, opt);
+		else
+			ret = -BCH_ERR_compression_workspace_not_initialized;
+		if (ret)
+			goto out;
+	}
 
 	src_data = bio_map_or_bounce(c, src, READ);
 
@@ -234,6 +245,7 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 		BUG();
 	}
 	ret = 0;
+fsck_err:
 out:
 	bio_unmap_or_unbounce(c, src_data);
 	return ret;
@@ -420,7 +432,17 @@ static unsigned __bio_compress(struct bch_fs *c,
 	BUG_ON(compression.type >= BCH_COMPRESSION_OPT_NR);
 
 	mempool_t *workspace_pool = &c->compress_workspace[compression.type];
-	BUG_ON(!mempool_initialized(workspace_pool));
+	if (unlikely(!mempool_initialized(workspace_pool))) {
+		if (fsck_err(c, compression_opt_not_marked_in_sb,
+			     "compression opt %s set but not marked in superblock",
+			     bch2_compression_opts[compression.type])) {
+			ret = bch2_check_set_has_compressed_data(c, compression.type);
+			if (ret) /* memory allocation failure, don't compress */
+				return 0;
+		} else {
+			return 0;
+		}
+	}
 
 	/* If it's only one block, don't bother trying to compress: */
 	if (src->bi_iter.bi_size <= c->opts.block_size)
@@ -502,6 +524,9 @@ static unsigned __bio_compress(struct bch_fs *c,
 err:
 	ret = BCH_COMPRESSION_TYPE_incompressible;
 	goto out;
+fsck_err:
+	ret = 0;
+	goto out;
 }
 
 unsigned bch2_bio_compress(struct bch_fs *c,
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 3affdafc2c04..2dda7f962e5b 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -54,6 +54,7 @@
 	x(ENOMEM,			ENOMEM_compression_bounce_read_init)	\
 	x(ENOMEM,			ENOMEM_compression_bounce_write_init)	\
 	x(ENOMEM,			ENOMEM_compression_workspace_init)	\
+	x(EIO,				compression_workspace_not_initialized)	\
 	x(ENOMEM,			ENOMEM_bucket_gens)			\
 	x(ENOMEM,			ENOMEM_buckets_nouse)			\
 	x(ENOMEM,			ENOMEM_usage_init)			\
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 0ba58d74c21f..6772faf385a5 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -54,7 +54,7 @@ const char * const __bch2_csum_opts[] = {
 	NULL
 };
 
-static const char * const __bch2_compression_types[] = {
+const char * const __bch2_compression_types[] = {
 	BCH_COMPRESSION_TYPES()
 	NULL
 };
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 6b29339ea725..ea69099e681d 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -17,6 +17,7 @@ extern const char * const bch2_sb_features[];
 extern const char * const bch2_sb_compat[];
 extern const char * const __bch2_btree_ids[];
 extern const char * const __bch2_csum_opts[];
+extern const char * const __bch2_compression_types[];
 extern const char * const bch2_compression_opts[];
 extern const char * const __bch2_str_hash_types[];
 extern const char * const bch2_str_hash_opts[];
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index f2b38493356d..d5b18ff1645c 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -305,7 +305,9 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							295,	0)
+	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
+	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
+	x(MAX,							297,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

