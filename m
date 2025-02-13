Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02522242913
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472382; cv=none; b=lJjSHiQ/vcc9ARMx8/Osnrcqr/97+6k7qtdiugHNG0svCf1yY7XhC1yjBmU9GYo6YZx+einqhI5N8khGheP4QGOzKGOOCbnEfezDbUmVRlV1YUlhTdx9VlZ98GSXzZiuJl0h+XlEqi0eXKnXSNMbWEE/U/aAmWrnoys+4zRgWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472382; c=relaxed/simple;
	bh=7MFTJu08u5gtoexuANltB/ShscFMKAYVF5fGGMgpSvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCL+8FpqOGTUYs8gUi3nFEHdit5xauV/gcx/i+OtvQgDaxhfMWlpJSPtTyARAZN25/1TjADWgrXjQE1pEDIcpGtq7LKDezG+SfXZyrIw3rHCgvXTWiXtC9nANWJcubh2jRNxchBJHLgUkYOdQ9a9Jz854svNFt4lHO26dYE2sFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cG9JefjE; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cG9JefjE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UzuML/G0QvKixoboOHYK3sIS/6NpSy9A3n6i8FCrFes=;
	b=cG9JefjE/IZv3IK5VG0GgbxGGiNQtU8J005lIPM8fhY2Hqxh4XENnHYhLkgxfgxr+O4p1p
	hqrYexzabyCa1HTRWy7Gio1+y8oVoO/5sGCtZ6u0uaLZ8aMQ2O5DFubNgZ/0KwQv0YKHdP
	TS3dnqXyqnc+fx6aly8zTKJaoHUNNdc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/18] bcachefs: bch2_lru_change() checks for no-op
Date: Thu, 13 Feb 2025 13:45:46 -0500
Message-ID: <20250213184607.18237-2-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Minor cleanup, no reason for the caller to have to this.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 32 +++++++++++++-------------------
 fs/bcachefs/lru.c              |  6 +++---
 fs/bcachefs/lru.h              | 11 ++++++++++-
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index a35455802280..e1061524bdf5 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -889,26 +889,20 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 		    !new_a->io_time[READ])
 			new_a->io_time[READ] = bch2_current_io_time(c, READ);
 
-		u64 old_lru = alloc_lru_idx_read(*old_a);
-		u64 new_lru = alloc_lru_idx_read(*new_a);
-		if (old_lru != new_lru) {
-			ret = bch2_lru_change(trans, new.k->p.inode,
-					      bucket_to_u64(new.k->p),
-					      old_lru, new_lru);
-			if (ret)
-				goto err;
-		}
+		ret = bch2_lru_change(trans, new.k->p.inode,
+				      bucket_to_u64(new.k->p),
+				      alloc_lru_idx_read(*old_a),
+				      alloc_lru_idx_read(*new_a));
+		if (ret)
+			goto err;
 
-		old_lru = alloc_lru_idx_fragmentation(*old_a, ca);
-		new_lru = alloc_lru_idx_fragmentation(*new_a, ca);
-		if (old_lru != new_lru) {
-			ret = bch2_lru_change(trans,
-					BCH_LRU_FRAGMENTATION_START,
-					bucket_to_u64(new.k->p),
-					old_lru, new_lru);
-			if (ret)
-				goto err;
-		}
+		ret = bch2_lru_change(trans,
+				      BCH_LRU_FRAGMENTATION_START,
+				      bucket_to_u64(new.k->p),
+				      alloc_lru_idx_fragmentation(*old_a, ca),
+				      alloc_lru_idx_fragmentation(*new_a, ca));
+		if (ret)
+			goto err;
 
 		if (old_a->gen != new_a->gen) {
 			ret = bch2_bucket_gen_update(trans, new.k->p, new_a->gen);
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index ce794d55818f..8ec16ae8daa6 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -59,9 +59,9 @@ int bch2_lru_set(struct btree_trans *trans, u16 lru_id, u64 dev_bucket, u64 time
 	return __bch2_lru_set(trans, lru_id, dev_bucket, time, KEY_TYPE_set);
 }
 
-int bch2_lru_change(struct btree_trans *trans,
-		    u16 lru_id, u64 dev_bucket,
-		    u64 old_time, u64 new_time)
+int __bch2_lru_change(struct btree_trans *trans,
+		      u16 lru_id, u64 dev_bucket,
+		      u64 old_time, u64 new_time)
 {
 	if (old_time == new_time)
 		return 0;
diff --git a/fs/bcachefs/lru.h b/fs/bcachefs/lru.h
index f31a6cf1514c..2facc0758cb3 100644
--- a/fs/bcachefs/lru.h
+++ b/fs/bcachefs/lru.h
@@ -46,7 +46,16 @@ void bch2_lru_pos_to_text(struct printbuf *, struct bpos);
 
 int bch2_lru_del(struct btree_trans *, u16, u64, u64);
 int bch2_lru_set(struct btree_trans *, u16, u64, u64);
-int bch2_lru_change(struct btree_trans *, u16, u64, u64, u64);
+int __bch2_lru_change(struct btree_trans *, u16, u64, u64, u64);
+
+static inline int bch2_lru_change(struct btree_trans *trans,
+		      u16 lru_id, u64 dev_bucket,
+		      u64 old_time, u64 new_time)
+{
+	return old_time != new_time
+		? __bch2_lru_change(trans, lru_id, dev_bucket, old_time, new_time)
+		: 0;
+}
 
 struct bkey_buf;
 int bch2_lru_check_set(struct btree_trans *, u16, u64, struct bkey_s_c, struct bkey_buf *);
-- 
2.45.2

