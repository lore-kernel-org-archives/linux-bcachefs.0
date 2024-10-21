Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09502C95
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482092; cv=none; b=KqL/vdOxhCrSOQmTDJybr9oRRo0Y2X6I5FfxXGsrkD0OAKR3kFRI26LOluhVBZE1XtbIsv60aByN0jK3aM+Ma1brVjhflzG+GHeqP3ZBuwf+sJ+OR3XTpqMPcSItGSSuVT+iElTINzNh3VcKAWw21EyAe9Wm1kXnz0HGB1ljZ3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482092; c=relaxed/simple;
	bh=DrDmiejQp/288uo/y0MnFnrFoswjZDULxHOAX6BZlww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTXoEojJXjuVopdVk8u5wsZZSLSjhYO9IyYhc3tqpxOV9FUlAu+iE4AnWC9cSbXNWdMvrgYqfdHTGfdILRU7qcwJG8ikixy+UVHE70/reRBZNmGXJAgzGC7LnNaiUcrysGShdQflw1DmEm4L01ePL+qQXHCIC0Y4QVFZygWhSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KyGIBJDg; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KyGIBJDg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ShSZa0JzrgZWgrSmrIY/uws5j82GXaEOORuMV/u92Q=;
	b=KyGIBJDgE5/eoIbfqy2vOT5adaLicJVySDVhL99rZIarlPXwP7trLIexBIqL4fKxnHhbg3
	2LZ97VTUrNMLYEPP7BbOwwoAh5eECIpGUpL5fmq7gsCVeA11NJ5lF3YxShPhBqDsA7BSI7
	gcgU6jrNw2k6YSHjUga2FSPJ/UBuPco=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/12] bcachefs: bch2_indirect_extent_error()
Date: Sun, 20 Oct 2024 23:41:02 -0400
Message-ID: <20241021034106.384756-12-kent.overstreet@linux.dev>
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

Factor out a small helper for missing indirect extents, to be used by
the new move.c support for reflinked data.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c | 25 +++++++------------------
 fs/bcachefs/reflink.c | 13 +++++++++++++
 fs/bcachefs/reflink.h |  2 ++
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 13dc35cd6562..d070482ba533 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -21,6 +21,7 @@
 #include "io_read.h"
 #include "io_misc.h"
 #include "io_write.h"
+#include "reflink.h"
 #include "subvolume.h"
 #include "trace.h"
 
@@ -753,31 +754,19 @@ int __bch2_read_indirect_extent(struct btree_trans *trans,
 				unsigned *offset_into_extent,
 				struct bkey_buf *orig_k)
 {
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	u64 reflink_offset;
-	int ret;
+	struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(bkey_i_to_s_c(orig_k->k));
+	u64 reflink_offset = le64_to_cpu(p.v->idx) + *offset_into_extent;
 
-	reflink_offset = le64_to_cpu(bkey_i_to_reflink_p(orig_k->k)->v.idx) +
-		*offset_into_extent;
-
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_reflink,
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_reflink,
 			       POS(0, reflink_offset), 0);
-	ret = bkey_err(k);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
 	if (k.k->type != KEY_TYPE_reflink_v &&
 	    k.k->type != KEY_TYPE_indirect_inline_data) {
-		bch_err_inum_offset_ratelimited(trans->c,
-			orig_k->k->k.p.inode,
-			orig_k->k->k.p.offset << 9,
-			"%llu len %u points to nonexistent indirect extent %llu",
-			orig_k->k->k.p.offset,
-			orig_k->k->k.size,
-			reflink_offset);
-		bch2_inconsistent_error(trans->c);
-		ret = -BCH_ERR_missing_indirect_extent;
+		ret = bch2_indirect_extent_error(trans, p);
 		goto err;
 	}
 
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 8a36ebd9dd9c..61cc67f8636a 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -27,6 +27,19 @@ static inline unsigned bkey_type_to_indirect(const struct bkey *k)
 	}
 }
 
+int bch2_indirect_extent_error(struct btree_trans *trans, struct bkey_s_c_reflink_p k)
+{
+	bch_err_inum_offset_ratelimited(trans->c,
+		k.k->p.inode,
+		k.k->p.offset << 9,
+		"%llu len %u points to nonexistent indirect extent %llu",
+		k.k->p.offset,
+		k.k->size,
+		le64_to_cpu(k.v->idx));
+	bch2_inconsistent_error(trans->c);
+	return -BCH_ERR_missing_indirect_extent;
+}
+
 /* reflink pointers */
 
 int bch2_reflink_p_validate(struct bch_fs *c, struct bkey_s_c k,
diff --git a/fs/bcachefs/reflink.h b/fs/bcachefs/reflink.h
index 51afe11d8ed6..a4da4bfc2785 100644
--- a/fs/bcachefs/reflink.h
+++ b/fs/bcachefs/reflink.h
@@ -4,6 +4,8 @@
 
 enum bch_validate_flags;
 
+int bch2_indirect_extent_error(struct btree_trans *, struct bkey_s_c_reflink_p);
+
 int bch2_reflink_p_validate(struct bch_fs *, struct bkey_s_c, enum bch_validate_flags);
 void bch2_reflink_p_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 bool bch2_reflink_p_merge(struct bch_fs *, struct bkey_s, struct bkey_s_c);
-- 
2.45.2

