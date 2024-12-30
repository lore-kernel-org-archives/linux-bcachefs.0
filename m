Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34887381C4
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594981; cv=none; b=cGOHmHMNiUPp2eCvRUUZR/pEdur71CLvwLoHg9NKA0A5alkkvLANkvcBm/IQwJIlm0vTTh42R5HyuPeKCsg+dKiDAQ6LqCwZpzzgNreqhYCjeookqiNyJNesOIaRbulVh9XSo5qU5PuIMc/3p0TeVt3wqjUHETvr7fj4rGB5n+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594981; c=relaxed/simple;
	bh=yDPy/5jDOQrBKlWtEIgjYT9MjTla9YCw85fPqoePxqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/SKUFDHuT+6cABDqKVEtdBD1Y1hX/xAxh8LuSvWGAL06UBNv+2BBoKyD7S/xuuhuhLntL99z6+Ttg1V7CHE8BvZkjkjJOTbFaJ5C6/8aQC05Njf5PhGT4qTjmmCnDr1r50wmvoo0xARSDbY5NWtZ21LSb6C5SAZY8zs14Tqa+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jEr6D0Ro; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jEr6D0Ro"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YeVCbkjcPKEL/WJomStBQXB6ZfS8uH0c2Y0Of7kM2fs=;
	b=jEr6D0RotoU+6Q+Nj79uOJGzTJ/SfK/r3UkjvxUoCbIvL/DAs/PPt/5qCEjEf0387iJ9QA
	4xcl9GT9lJZUbiB3iMXCAkz/c5xT0iCPyItSmQyvyh/VqjvZwVeas0wy/5QEQXQEvIm/0J
	JZBiXmZwxXK8d/Z73Z2lTjySRfA9URs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/11] bcachefs: bch2_btree_iter_peek_slot() handles navigating to nonexistent depth
Date: Mon, 30 Dec 2024 16:42:39 -0500
Message-ID: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index c291d495b85b..367231ab1980 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2770,6 +2770,10 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 		goto out_no_locked;
 	}
 
+	struct btree_path *path = btree_iter_path(trans, iter);
+	if (unlikely(!btree_path_node(path, path->level)))
+		return bkey_s_c_null;
+
 	if ((iter->flags & BTREE_ITER_cached) ||
 	    !(iter->flags & (BTREE_ITER_is_extents|BTREE_ITER_filter_snapshots))) {
 		k = bkey_s_c_null;
-- 
2.45.2

