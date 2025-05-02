Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F88A1F7554
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216015; cv=none; b=nYAZCsNpYoLuHs6at57we78soRKRi6Hv0oe3JNMcQ6HxiCsYLMTnoO9cg6OnzXCIB2yi4mX/vPHyB22UmbCMgYui3hEbs0AvPSZn1b6bOOBX6lqED+BN0ODXkA4e98bCUIDrp/c4fKMS6H3KZVO3FnZz0y3KTRFzyVdD4Mb+JQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216015; c=relaxed/simple;
	bh=9p+mouHTY72VPq36WvcgDsTvwoxa7aOGfU59JZO9XN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch/IWH4mnke0HqydCUt2SWueRlZV9AM9FaYdryHc5LNCu4RP4NuOEMqChOOlAM4zZ8I+4kWShINSgPUojm/W9pGWodpYZH/GimU9x+/aKJBJ1ZM3NeCF5YN9qPIGdkOVjakuTbA0CBMGy8Dxve8vtCK7Hgm//dfJCY/ltrBQqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FyUMCW3P; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FyUMCW3P"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wr7RceKqg/rAgUJoa76ffr37XLUb8mFMZSWx0uA0JE=;
	b=FyUMCW3PXg/ApW3e54Pv4EU+KN3GIzU+JFLTwVH8hbiEqahyeGcuieJeqZkqle77TkALI0
	i6brdlYrj1N/zgy8uAu1ntqFEie3Pa62giUcsfrqCEHJBa+SjLlKXmn9S8tSdsFch/v6tM
	KnkGm6zgQTKTcCql9puo0aJlFu1h95Y=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/8] bcachefs: Add comments for inode snapshot requirements
Date: Fri,  2 May 2025 15:59:54 -0400
Message-ID: <20250502200002.1309862-3-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/io_write.c | 6 ++++++
 fs/bcachefs/xattr.c    | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index add141ac45b5..399df8fede8b 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -279,6 +279,12 @@ static inline int bch2_extent_update_i_size_sectors(struct btree_trans *trans,
 		inode_update_flags = 0;
 	}
 
+	/*
+	 * extents, dirents and xattrs updates require that an inode update also
+	 * happens - to ensure that if a key exists in one of those btrees with
+	 * a given snapshot ID an inode is also present - so we may have to skip
+	 * the nojournal optimization:
+	 */
 	if (inode->k.p.snapshot != iter.snapshot) {
 		inode->k.p.snapshot = iter.snapshot;
 		inode_update_flags = 0;
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index b8bc2fb04f15..ea3f87f6fe49 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -176,6 +176,11 @@ int bch2_xattr_set(struct btree_trans *trans, subvol_inum inum,
 	if (ret)
 		return ret;
 
+	/*
+	 * Besides the ctime update, extents, dirents and xattrs updates require
+	 * that an inode update also happens - to ensure that if a key exists in
+	 * one of those btrees with a given snapshot ID an inode is also present
+	 */
 	inode_u->bi_ctime = bch2_current_time(c);
 
 	ret = bch2_inode_write(trans, &inode_iter, inode_u);
-- 
2.49.0

