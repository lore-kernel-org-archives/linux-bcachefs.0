Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29AA32
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810793; cv=none; b=dFgxLwx56kmJrsJHsqFVzPHKIzULn+Dch0C9Atis9tVzvwxYPpquzulu3eaVYBmkOHrlCGlf1L0rBaKCN3VdF11L3KIiyedgETkBencqKjMcpZQGAAdhifQQeXHS77XgocYDUyNIZ/tfHho+Fn5vRg5e0INhkl+gfKRnxu19zmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810793; c=relaxed/simple;
	bh=FmihS2zZZVzpQxJsOSNCEKaSf8vQutzL2QctmDvFVD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSlkC1iFddmqq866L+kbWLMP0iB7SuKrxLOFg+Tiv2nN1yP1b5TgtNRt2uOBlRHZAZc5PPEqiQb7I4qjCisiwIYIGaSAYv9onyN8Qo8KYvnON1LLBuyyVhONC79p5D+HDkDB/VdoXuylnkB27NxjEGBwwFd0ofedTJJBgowLVug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w4ookevy; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w4ookevy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvBGJesxC2J9gQhsWSF9P4n/tKH26aM597KQFdDyQoM=;
	b=w4ookevyqBa1N+a0wD5sRIHME/hNY9rkVJIGsQWqkMUMCxSKnvB/Eq/+MJ1ZBBga4Ue6SQ
	z9B1Y6Thx9SNYcJ6dTeVpbg/Kh41qELlmchTzVb8aiAdFqhlEoCumpXdoKgNp3KON0kRuj
	ChvQ2aoRn6RCHdoYZyD8NBlA+uZ7y5E=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: BCH_FEATURE_small_image
Date: Wed, 16 Apr 2025 09:39:42 -0400
Message-ID: <20250416133943.3654046-2-kent.overstreet@linux.dev>
In-Reply-To: <20250416133943.3654046-1-kent.overstreet@linux.dev>
References: <20250416133943.3654046-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We can't go RW if it's an image file that hasn't been resized.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h | 3 ++-
 fs/bcachefs/errcode.h         | 1 +
 fs/bcachefs/journal.c         | 9 ++++++++-
 fs/bcachefs/super.c           | 5 +++++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 7e2debc40045..aa57f4708232 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -919,7 +919,8 @@ static inline void SET_BCH_SB_BACKGROUND_COMPRESSION_TYPE(struct bch_sb *sb, __u
 	x(extents_across_btree_nodes,	18)	\
 	x(incompat_version_field,	19)	\
 	x(casefolding,			20)	\
-	x(no_alloc_info,		21)
+	x(no_alloc_info,		21)	\
+	x(small_image,			22)
 
 #define BCH_SB_FEATURES_ALWAYS				\
 	(BIT_ULL(BCH_FEATURE_new_extent_overwrite)|	\
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index e54c8264e7e1..996cdf62dad9 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -222,6 +222,7 @@
 	x(EROFS,			erofs_norecovery)			\
 	x(EROFS,			erofs_nochanges)			\
 	x(EROFS,			erofs_no_alloc_info)			\
+	x(EROFS,			erofs_filesystem_full)			\
 	x(EROFS,			insufficient_devices)			\
 	x(0,				operation_blocked)			\
 	x(BCH_ERR_operation_blocked,	btree_cache_cannibalize_lock_blocked)	\
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 23f37dbfaba9..898f61250b5d 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1278,9 +1278,16 @@ int bch2_set_nr_journal_buckets(struct bch_fs *c, struct bch_dev *ca,
 
 int bch2_dev_journal_alloc(struct bch_dev *ca, bool new_fs)
 {
+	struct bch_fs *c = ca->fs;
+
 	if (!(ca->mi.data_allowed & BIT(BCH_DATA_journal)))
 		return 0;
 
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_small_image)) {
+		bch_err(c, "cannot allocate journal, filesystem is an unresized image file");
+		return -BCH_ERR_erofs_filesystem_full;
+	}
+
 	unsigned nr;
 	int ret;
 
@@ -1301,7 +1308,7 @@ int bch2_dev_journal_alloc(struct bch_dev *ca, bool new_fs)
 		     min(1 << 13,
 			 (1 << 24) / ca->mi.bucket_size));
 
-	ret = bch2_set_nr_journal_buckets_loop(ca->fs, ca, nr, new_fs);
+	ret = bch2_set_nr_journal_buckets_loop(c, ca, nr, new_fs);
 err:
 	bch_err_fn(ca, ret);
 	return ret;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 797601756af1..29c4204d2e50 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -472,6 +472,11 @@ static int __bch2_fs_read_write(struct bch_fs *c, bool early)
 		return -BCH_ERR_erofs_unfixed_errors;
 	}
 
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_small_image)) {
+		bch_err(c, "cannot go rw, filesystem is an unresized image file");
+		return -BCH_ERR_erofs_filesystem_full;
+	}
+
 	if (test_bit(BCH_FS_rw, &c->flags))
 		return 0;
 
-- 
2.49.0

