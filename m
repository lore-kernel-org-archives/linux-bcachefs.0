Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E3E258ED7
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 02:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853424; cv=none; b=FUd1MBiNHFQz5pQNlxNg3vRQ8VtLMlJ1Kh7RWadjdDGrJ+m/rtNDmdxeyYNwHAL2kODPel4snWwkVeqnYLnqbE7EIN/rsnSjNFYVj3voAU4l69t+Td+V62ibdz/7zx6kNa7AK8tGKu9P82cJey0aaKHvspiqvLLrAOkUGOwK5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853424; c=relaxed/simple;
	bh=04GF3OnZ/QyVrtEwN7P7etDZ6D8+7rjpnX26eWB/D34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cObN65W9RFW/GrPktSDJ6D2bTiwj3I+8lhFr7O4vI5H789dkOX8LVqeLynyWmJVz0lED1T+bk0/+wbZf0KcCKXUIDFwsJxeuDzEP4MqLJ8WypGfw5AWj3TsoQ4KCWwBdwMaMVOKBPYXCqJ1ED+nPZNiqHxptUJSjX0oK2NsYg0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xjEVrX1C; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xjEVrX1C"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758853420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNKNWfE1GCfxOnqhCzzOBU2T4tSbBc4ZLZn+yzvKoWA=;
	b=xjEVrX1CbvdFD/dNj5SNlLvH/uTQpgumurH/yvZ96H0RJzZjIk+g3wVrKwylOq/YOL7w9e
	4zP6PqRV1Prv0DHls3KdlRmAJ0u1RHVtAqk8kFNMBILWv0tlsjgw3TCD3Bd7HivdwyC8Ys
	ctLPf+1/sbDch7nCS5rLrMlt9kCYRMU=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 2/3] bcachefs: Fix maximum link count check when creating hard links
Date: Fri, 26 Sep 2025 10:21:49 +0800
Message-ID: <20250926022150.493115-3-youling.tang@linux.dev>
In-Reply-To: <20250926022150.493115-1-youling.tang@linux.dev>
References: <20250926022150.493115-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

When I changed the maximum link count U32_MAX to 4 for testing purposes, I
discovered that for regular files, the maximum number of hard links created
could actually reach 5 (`inode->i_nlink`).

This occurs because `bi->bi_nlink` does not represent the actual `inode->i_nlink`
value, but rather equals `inode->i_nlink - nlink_bias(bi->bi_mode)`. Therefore,
the `bi->bi_nlink` check in bch2_inode_nlink_inc() needs to be corrected.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
NOTE: If pathconf is to be added to support _PC_LINK_MAX for bcachefs in
libc later, BCH_LINK_MAX can be defined as ((1U << 31) - 1U) like xfs.

 fs/bcachefs/bcachefs.h | 1 +
 fs/bcachefs/inode.c    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index ddfacad0f70c..9d5e6866b1b6 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -714,6 +714,7 @@ struct btree_debug {
 	unsigned		id;
 };
 
+#define BCH_LINK_MAX	U32_MAX
 #define BCH_TRANSACTIONS_NR 128
 
 struct btree_transaction_stats {
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 5765144b4d65..eedffb505517 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1192,7 +1192,7 @@ int bch2_inode_nlink_inc(struct bch_inode_unpacked *bi)
 	if (bi->bi_flags & BCH_INODE_unlinked)
 		bi->bi_flags &= ~BCH_INODE_unlinked;
 	else {
-		if (bi->bi_nlink == U32_MAX)
+		if (bi->bi_nlink == BCH_LINK_MAX - nlink_bias(bi->bi_mode))
 			return -BCH_ERR_too_many_links;
 
 		bi->bi_nlink++;
-- 
2.43.0

