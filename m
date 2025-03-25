Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890D825A2BF
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Mar 2025 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742912974; cv=none; b=uCpHfVo2PW6EMK3AvjqoWlWDSZf1+GMkcY1gvHRkp/aPoyhLdIFo8tyunIPP4jrwpOvcJl7p66ptIcV9YNcXlYSt9p9ZzBafWw2HfDpvbfHKkC12UqWagGejGL/fHtfMDYRei8Wyxc7X+8rYLGdqUuDdgmgWljiVBbry4Q2jRFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742912974; c=relaxed/simple;
	bh=Pp2dOwEyZckqZhfV12l+0XnhWjtie6+RIdYu9jcOMXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kxePQnG93hTDd6AuyoT8i2L3l7QfnIiHXcJeiZn2iD4DtEwzLSdUoN/2YXBMqloCEuhMYOvlfbo3xeiiwNCQiGb442AzfOAI0wutLsj7uTxFZWxBXAQ7ybK8iWBVSucPE74vn1rEfX2AABruiLiuHBMnViMNLLQeqO4Jok1gCZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XfYMbKzh; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XfYMbKzh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742912969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=K06mKF+8359jXwNZVKjd5ia975r6DmqrR5EEwQmXHZA=;
	b=XfYMbKzhV0QEcPE7kRJdAEz31eQK4EagzweZyL/pHmu09B3Cti8KwU/CUo3Td0ANKVc+rk
	s/XwQK/I7jLwByLxzhLBbJ1RaXa99JAWAKngofFbdsywQpQQixvsbfNQKtKo60SVK7ewIV
	24B2vmNt2Wd1IdyU1JOozSoPQ+irDdI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Validate number of counters for accounting keys
Date: Tue, 25 Mar 2025 10:29:24 -0400
Message-ID: <20250325142925.1999166-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We weren't checking that accounting keys have the expected number of
accounters. Originally we probably wanted to be flexible on this, but it
doesn't look like that will be required - accounting is extended by
adding new counter types, not more counters to an existing type.

This means we can drop a BUG_ON() that popped once in automated testing,
and the new validation will make that bug easier to track down.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting.c        | 11 +++++++++++
 fs/bcachefs/disk_accounting.h        |  8 +++++---
 fs/bcachefs/disk_accounting_format.h | 26 ++++++++++++++++----------
 fs/bcachefs/sb-errors_format.h       |  3 ++-
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index b32e91ba8be8..8a8de61429d8 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -135,6 +135,12 @@ static inline bool is_zero(char *start, char *end)
 
 #define field_end(p, member)	(((void *) (&p.member)) + sizeof(p.member))
 
+static const unsigned bch2_accounting_type_nr_counters[] = {
+#define x(f, id, nr)	[BCH_DISK_ACCOUNTING_##f]	= nr,
+	BCH_DISK_ACCOUNTING_TYPES()
+#undef x
+};
+
 int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 			     struct bkey_validate_context from)
 {
@@ -193,6 +199,11 @@ int bch2_accounting_validate(struct bch_fs *c, struct bkey_s_c k,
 	bkey_fsck_err_on(!is_zero(end, (void *) (&acc_k + 1)),
 			 c, accounting_key_junk_at_end,
 			 "junk at end of accounting key");
+
+	bkey_fsck_err_on(bch2_accounting_counters(k.k) != bch2_accounting_type_nr_counters[acc_k.type],
+			 c, accounting_key_nr_counters_wrong,
+			 "accounting key with %u counters, should be %u",
+			 bch2_accounting_counters(k.k), bch2_accounting_type_nr_counters[acc_k.type]);
 fsck_err:
 	return ret;
 }
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index f9214e2d1346..abb1f6206fe9 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -33,10 +33,12 @@ static inline bool bch2_accounting_key_is_zero(struct bkey_s_c_accounting a)
 static inline void bch2_accounting_accumulate(struct bkey_i_accounting *dst,
 					      struct bkey_s_c_accounting src)
 {
-	EBUG_ON(dst->k.u64s != src.k->u64s);
-
-	for (unsigned i = 0; i < bch2_accounting_counters(&dst->k); i++)
+	for (unsigned i = 0;
+	     i < min(bch2_accounting_counters(&dst->k),
+		     bch2_accounting_counters(src.k));
+	     i++)
 		dst->v.d[i] += src.v->d[i];
+
 	if (bversion_cmp(dst->k.bversion, src.k->bversion) < 0)
 		dst->k.bversion = src.k->bversion;
 }
diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
index 15190196485f..09198ffb57b1 100644
--- a/fs/bcachefs/disk_accounting_format.h
+++ b/fs/bcachefs/disk_accounting_format.h
@@ -95,19 +95,25 @@ static inline bool data_type_is_hidden(enum bch_data_type type)
 	}
 }
 
+/*
+ * field 1: name
+ * field 2: id
+ * field 3: number of counters (max 3)
+ */
+
 #define BCH_DISK_ACCOUNTING_TYPES()		\
-	x(nr_inodes,		0)		\
-	x(persistent_reserved,	1)		\
-	x(replicas,		2)		\
-	x(dev_data_type,	3)		\
-	x(compression,		4)		\
-	x(snapshot,		5)		\
-	x(btree,		6)		\
-	x(rebalance_work,	7)		\
-	x(inum,			8)
+	x(nr_inodes,		0,	1)	\
+	x(persistent_reserved,	1,	1)	\
+	x(replicas,		2,	1)	\
+	x(dev_data_type,	3,	3)	\
+	x(compression,		4,	3)	\
+	x(snapshot,		5,	1)	\
+	x(btree,		6,	1)	\
+	x(rebalance_work,	7,	1)	\
+	x(inum,			8,	3)
 
 enum disk_accounting_type {
-#define x(f, nr)	BCH_DISK_ACCOUNTING_##f	= nr,
+#define x(f, nr, ...)	BCH_DISK_ACCOUNTING_##f	= nr,
 	BCH_DISK_ACCOUNTING_TYPES()
 #undef x
 	BCH_DISK_ACCOUNTING_TYPE_NR,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 67455beb8358..1736abea9ed1 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -311,13 +311,14 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_nr_required_bad,		279,	FSCK_AUTOFIX)	\
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
+	x(accounting_key_nr_counters_wrong,			307,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
 	x(compression_opt_not_marked_in_sb,			295,	FSCK_AUTOFIX)	\
 	x(compression_type_not_marked_in_sb,			296,	FSCK_AUTOFIX)	\
 	x(directory_size_mismatch,				303,	FSCK_AUTOFIX)	\
 	x(dirent_cf_name_too_big,				304,	0)		\
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
-	x(MAX,							307,	0)
+	x(MAX,							308,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.49.0

