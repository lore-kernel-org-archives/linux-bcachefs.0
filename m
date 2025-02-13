Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E37242913
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472384; cv=none; b=kZphUQrhBfNg5meA7Im6hn4rD2wF5QUGQiLXkZs8lAa+5psyKp84yvMF3wdeGiGo48w4kgAptMbOBaDvIPfnTCgUlaS9hzLOrlbKd1tZVOT+zsnl6bP1pN5PLmVEhnnELmTZpPF9qEs6laAW02Ix1EukpiF3SAwytFBg0nA1jnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472384; c=relaxed/simple;
	bh=N0yoAsJ3/iQKXdGxvv1mEeqNCcTGh3OgpRgpo2Vb854=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j13unmAqs0Yx5pESZ3eaHWdTyieK0pviqSz91gZqEhEa6OybJHCaLalZxwDYs+EKgY+5yGlVxkOo+9qRb6j4lWC1LiWNLvcFvAWXDWVR/ZRyMv8PfMVaJqetB+uc1Ru9n3S//I7EMz21YsXFArrX0leDaojCxN5+AyeD79NJyWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nd93lRxp; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nd93lRxp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EkKRgVfibZEaeUjt+03bfTsXho3Uw+VBIwvQCzjY8uM=;
	b=nd93lRxpofbn4msRICtHuJu3SZh/hG8q5wmPnx7RO8mvA5wMiv5j0Zx6ZVRzq2gPf9MAw0
	kJ6g/GMS2F86AFh35xP3YHdC6njm4W1CmlU2mTtCHizF3VLnVTnK1m8Q8uWQD9iE+bDcc4
	F1io9J0QJDsMMLoJq3jC13H51mDBYF4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/18] bcachefs: Better trigger ordering
Date: Thu, 13 Feb 2025 13:45:51 -0500
Message-ID: <20250213184607.18237-7-kent.overstreet@linux.dev>
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

Transactional triggers need to run in a defined ordering, which is not
quite the same as btree ID integer comparison.

Previously this was handled in a hacky way in
bch2_trans_commit_run_triggers(), since it was only the alloc btree that
needed special handling, but upcoming stripe btree changes are going to
require more ordering changes - so, define that ordering.

Next patch will change the transaction commit path to use it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_types.h  | 13 +++++++++++++
 fs/bcachefs/btree_update.c |  1 +
 2 files changed, 14 insertions(+)

diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index a09cbe9cd94f..77578da2d23f 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -423,6 +423,7 @@ static inline struct bpos btree_node_pos(struct btree_bkey_cached_common *b)
 
 struct btree_insert_entry {
 	unsigned		flags;
+	u8			sort_order;
 	u8			bkey_type;
 	enum btree_id		btree_id:8;
 	u8			level:4;
@@ -853,6 +854,18 @@ static inline bool btree_type_uses_write_buffer(enum btree_id btree)
 	return BIT_ULL(btree) & mask;
 }
 
+static inline u8 btree_trigger_order(enum btree_id btree)
+{
+	switch (btree) {
+	case BTREE_ID_alloc:
+		return U8_MAX;
+	case BTREE_ID_stripes:
+		return U8_MAX - 1;
+	default:
+		return btree;
+	}
+}
+
 struct btree_root {
 	struct btree		*b;
 
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 13d794f201a5..47e54eedd0bc 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -397,6 +397,7 @@ bch2_trans_update_by_path(struct btree_trans *trans, btree_path_idx_t path_idx,
 
 	n = (struct btree_insert_entry) {
 		.flags		= flags,
+		.sort_order	= btree_trigger_order(path->btree_id),
 		.bkey_type	= __btree_node_type(path->level, path->btree_id),
 		.btree_id	= path->btree_id,
 		.level		= path->level,
-- 
2.45.2

