Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C45146A63
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951177; cv=none; b=OfsnwazDVO7bIxCWkNmsbMf9SfDkc7YcO7zKboYXxuJ6v8R+qCrbE+DQp6LJ8RKkVcjVRQSXYPrUkuHFhePL5LZzkg4t+KeYV++HieM7l83CSuo2vonSXq4RrISsxHIUXjLm43K8UgKsxn1J73a3YRSbkYBINaXOgevUtCyHHZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951177; c=relaxed/simple;
	bh=wlNX5E5PK5WgPPQQBDi8J3TFRjLbRiOEBsxXrELACKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTenLEM0mN558dKtXoxSapTH0u+kFkZQeKA7IKCYfHjcma4bKlxhLAZghllLdoUfapbDSyUS1t3ioxYvAvZos+5iSDv8iI/v1PpJ3XJj1yV4pG23djpQabSKIv3TZnosybnORB1268w8QDm6ExIIYzgj/qIsC/uypfrTiFnM7Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gzUNsAxE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gzUNsAxE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0kFQfIrozJIJzcCVerOsqn7i9EzFCnoaWeeAftMEooQ=;
	b=gzUNsAxEI/Lsh96+abQDHoNNP7dyUECLM1LkJ2GOtnqEELym30zL5ccxXxJKjJoAKQvyZk
	wiciOt3Ir5HG0j7VXXS6hOcu01SGqllV0IO2XcD/X3xlVGCjEyBDpOp1cguG1FwtS9bYAW
	kjgmkeEazkF2SgKuv7jMaLSqPqW+iA8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/11] bcachefs: Reduce stack frame size of __bch2_str_hash_check_key()
Date: Sun, 26 Jan 2025 23:12:28 -0500
Message-ID: <20250127041239.2693707-3-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't need all the helpers inlined here.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/str_hash.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index 8c2c5539de2e..d78451c2a0c6 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -31,11 +31,11 @@ static int bch2_dirent_has_target(struct btree_trans *trans, struct bkey_s_c_dir
 	}
 }
 
-static int fsck_rename_dirent(struct btree_trans *trans,
-			      struct snapshots_seen *s,
-			      const struct bch_hash_desc desc,
-			      struct bch_hash_info *hash_info,
-			      struct bkey_s_c_dirent old)
+static noinline int fsck_rename_dirent(struct btree_trans *trans,
+				       struct snapshots_seen *s,
+				       const struct bch_hash_desc desc,
+				       struct bch_hash_info *hash_info,
+				       struct bkey_s_c_dirent old)
 {
 	struct qstr old_name = bch2_dirent_get_name(old);
 	struct bkey_i_dirent *new = bch2_trans_kmalloc(trans, bkey_bytes(old.k) + 32);
@@ -71,11 +71,11 @@ static int fsck_rename_dirent(struct btree_trans *trans,
 	return bch2_fsck_update_backpointers(trans, s, desc, hash_info, &new->k_i);
 }
 
-static int hash_pick_winner(struct btree_trans *trans,
-			    const struct bch_hash_desc desc,
-			    struct bch_hash_info *hash_info,
-			    struct bkey_s_c k1,
-			    struct bkey_s_c k2)
+static noinline int hash_pick_winner(struct btree_trans *trans,
+				     const struct bch_hash_desc desc,
+				     struct bch_hash_info *hash_info,
+				     struct bkey_s_c k1,
+				     struct bkey_s_c k2)
 {
 	if (bkey_val_bytes(k1.k) == bkey_val_bytes(k2.k) &&
 	    !memcmp(k1.v, k2.v, bkey_val_bytes(k1.k)))
@@ -142,8 +142,8 @@ static int repair_inode_hash_info(struct btree_trans *trans,
  * All versions of the same inode in different snapshots must have the same hash
  * seed/type: verify that the hash info we're using matches the root
  */
-static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inum,
-					      struct bch_hash_info *hash_info)
+static noinline int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inum,
+						       struct bch_hash_info *hash_info)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
-- 
2.45.2

