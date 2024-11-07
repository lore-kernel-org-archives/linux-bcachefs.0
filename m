Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD97D51C;
	Thu,  7 Nov 2024 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730941840; cv=none; b=ems6r/eV/VWWKe2gCgXYM7ONMfX86OL+eXxS4W//p1B4GLOMh0TOKs8PSF7B0x9mrxjCpSXY+4Con9PAgJkojHs5RalasAHe6ffLaexn/ezOFMLPRuXb3/TbCpjoT7t84h4tEsr//CrBi27L0Cq9CZ7t55Oex6de/MG8WjJpsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730941840; c=relaxed/simple;
	bh=yYzRkTCC8+BZTwvmyQ31+uFBqyuZMzibFmimTlIPkgc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fnRjmHQdJ4oblrNB+2VliNbeEkTU2hRe0FTnHixbRHl4iq4emsMUvgEW+Geq/DNF3G0m02AyYHC/8JhwBbwp0pz78YmmFmkNhMQOoCrbdXrgTZvG0SUAVB3U/SHVSYPcandpIUn5pLIXxfHOwZ1f2kcAixlBnk+lFT9DbedWzXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AjJGYyVt; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AjJGYyVt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730941830; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=H+X1MYoCvR+sYhxbevfm5tdtbXienJemgk+boeH6x6M=;
	b=AjJGYyVtrps77FyGVS7VRHGyBPD4xMU24/IkqxyqoMJy7vNIPzT5xtjuG41kIDqePlrbvOSwtvqGIBozh6nwxLEAf6CzuzWGk7EF7rilEF55i74lxb7vXWN3opOFlgHH1Hnv/9OMVpS/d1sfIGAXBYoaREm9oPHYJt4gHrtJX6w=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WItX.O9_1730941828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 07 Nov 2024 09:10:29 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove unneeded semicolon
Date: Thu,  7 Nov 2024 09:10:27 +0800
Message-Id: <20241107011027.56783-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch removes an redundant semicolon.

./fs/bcachefs/btree_iter.c:2702:41-42: Unneeded semicolon
./fs/bcachefs/btree_cache.c:522:13-14: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=11751
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/btree_cache.c | 2 +-
 fs/bcachefs/btree_iter.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index a0a406b0c7bc..c313a5bce886 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -519,7 +519,7 @@ static unsigned long bch2_btree_cache_scan(struct shrinker *shrink,
 		if (btree_node_accessed(b)) {
 			clear_btree_node_accessed(b);
 			bc->not_freed[BCH_BTREE_CACHE_NOT_FREED_access_bit]++;
-			--touched;;
+			--touched;
 		} else if (!btree_node_reclaim(c, b, true)) {
 			__bch2_btree_node_hash_remove(bc, b);
 			__btree_node_data_free(bc, b);
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b47bfcc438f3..cc13fe1d2be6 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2699,7 +2699,7 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 	}
 
 	/* Extents can straddle iter->pos: */
-	iter->pos = bpos_min(iter->pos, k.k->p);;
+	iter->pos = bpos_min(iter->pos, k.k->p);
 
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		iter->pos.snapshot = iter->snapshot;
-- 
2.32.0.3.g01195cf9f

