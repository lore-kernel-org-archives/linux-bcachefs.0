Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A4D6F06D
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 15:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729957716; cv=none; b=B0QgRcgJIxIrsIIPq3Fgx3TLYSsKoSasTrddTd22KAdknlRJSWXkwNbHORyIwvOc6mAN3ROBgM9QauXr+w6zEpLXa24snThR4BGwxyfCOZtCCi3m1W2pGa7uTOfpMA1AWnO9xMyFSmiFXjrcfmiSjSLoA9i+NVm6HwSVrLk/D+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729957716; c=relaxed/simple;
	bh=vHbrUzCivC+0sWQpXeAfQQnaS30UkBa7QakQ5RLHjqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q7pr6iLkMbcDDS8MnXruFn6p4GzfW2Ue+pJUXeGoeOBzkxiTUGnVYG0flsL98whAE8p+cTLDPK7AOCACu1GWz6uZi56nL9G4QjvDmkAk0KdBEYXmCIV+iBjE+4xawPDlbe5x2QMJGlXLPDuH39WpOppMolxvjmxcd1FqwGrGLFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hw3NxRwk; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hw3NxRwk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729957711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E217QekynhfdE7/Q5qRGmvGmw8LU4yrTMFD02WaTTdA=;
	b=Hw3NxRwk0vxsMOqQWagvKrtS0gea7Gmj6AW8mUQgcWx50hiJeslGswHswroOJkbNSNbAMn
	61o/Iu0v+urSeJ3A0caPW2LPl4TplMhG7QsNQ0WIiIq5ialrK9YChMMF0cq33zX50IFsZG
	K0dkuOwjZ70bSMp3U0Owe3DyrOfC2OQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RESEND PATCH] bcachefs: Annotate struct bucket_gens with __counted_by()
Date: Sat, 26 Oct 2024 17:47:04 +0200
Message-ID: <20241026154704.159305-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the __counted_by compiler attribute to the flexible array member b
to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Use struct_size() to calculate the number of bytes to be allocated.

Update bucket_gens->nbuckets and bucket_gens->nbuckets_minus_first when
resizing.

Compile-tested only.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/buckets.c       | 13 ++++++++-----
 fs/bcachefs/buckets_types.h |  2 +-
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index ec7d9a59bea9..8bd17667e243 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1266,8 +1266,9 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 
 	BUG_ON(resize && ca->buckets_nouse);
 
-	if (!(bucket_gens	= kvmalloc(sizeof(struct bucket_gens) + nbuckets,
-					   GFP_KERNEL|__GFP_ZERO))) {
+	bucket_gens = kvmalloc(struct_size(bucket_gens, b, nbuckets),
+			       GFP_KERNEL|__GFP_ZERO);
+	if (!bucket_gens) {
 		ret = -BCH_ERR_ENOMEM_bucket_gens;
 		goto err;
 	}
@@ -1285,11 +1286,13 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 	old_bucket_gens = rcu_dereference_protected(ca->bucket_gens, 1);
 
 	if (resize) {
-		size_t n = min(bucket_gens->nbuckets, old_bucket_gens->nbuckets);
-
+		bucket_gens->nbuckets = min(bucket_gens->nbuckets,
+					    old_bucket_gens->nbuckets);
+		bucket_gens->nbuckets_minus_first =
+			bucket_gens->nbuckets - bucket_gens->first_bucket;
 		memcpy(bucket_gens->b,
 		       old_bucket_gens->b,
-		       n);
+		       bucket_gens->nbuckets);
 	}
 
 	rcu_assign_pointer(ca->bucket_gens, bucket_gens);
diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
index 28bd09a253c8..7174047b8e92 100644
--- a/fs/bcachefs/buckets_types.h
+++ b/fs/bcachefs/buckets_types.h
@@ -24,7 +24,7 @@ struct bucket_gens {
 	u16			first_bucket;
 	size_t			nbuckets;
 	size_t			nbuckets_minus_first;
-	u8			b[];
+	u8			b[] __counted_by(nbuckets);
 };
 
 struct bch_dev_usage {
-- 
2.47.0

