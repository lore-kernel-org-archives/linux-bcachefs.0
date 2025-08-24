Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832B274658
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039098; cv=none; b=q7hCDMeJzb4/Srj6OKYArBEto06bOZ2XvbT96W8abrxF4lMoZyvU5ZeBCj80CGVCbd3xdE8I2+SwClP9auFh/X8kaZDtJpI+UGDlocAimmcUxSD+LdxPvEK3/lqJBW+wKBy3csihNN2gQKEiMroW/4K5o3LkvZEh2JpPVkAwjVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039098; c=relaxed/simple;
	bh=WYFGKLif3Arx95Mzr3iBr+fcJOIMQcobra+AuXb+JjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W12neQ7kyuyuVChMmz9MBEKeHYbJsbsim5eWPTNgYucH/bEc5+0rWpN8FhjnrmrVdtEtfvw4ErwTfCOmmKx9/DlcFVze/Rsqk1ZG3M1fkR6fKrsUaL92w2GSUbPP6SlfQQsb5oIZiWZOu0k1Xr9sZKFdFfjCZeoAatDna92cL+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X/VZITeO; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X/VZITeO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWTkYVgSaJqD9rQdnqPkdhcXRTOVfmyz9gJ2mDcvfdg=;
	b=X/VZITeO9R/msmWTkWyns+qm910BiqHVpPHQdzkX0jkgjIAYqUw6tEXE+DkY0qLs+MzVJK
	/GDddjyA0abVYYdZqRaF9dqsQvbFTxY74H5F+thHVDp/S86iWm1aDym3e8Fiv+phfWKymP
	Rh61WOVvqX9rtW1S9NSph2QSZAZURbA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/21] bcachefs: Correct propagation of io options to indirect extents
Date: Sun, 24 Aug 2025 08:37:47 -0400
Message-ID: <20250824123800.1617669-11-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

io path options set from the inode should override existing indirect
extent options, if REFLINK_P_MAY_UPDATE_OPTS is set.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index f292c93ddd4d..932998864ad2 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -197,13 +197,23 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 	BUG_ON(iter->flags & BTREE_ITER_is_extents);
 	BUG_ON(iter->flags & BTREE_ITER_filter_snapshots);
 
+	bool may_update_indirect = ctx == SET_NEEDS_REBALANCE_opt_change_indirect;
+
+	/*
+	 * If it's an indirect extent, and we walked to it directly, we won't
+	 * have the options from the inode that were directly applied: options
+	 * from the extent take precedence - unless the io_opts option came from
+	 * the inode and may_update_indirect is true (walked from a
+	 * REFLINK_P_MAY_UPDATE_OPTIONS pointer).
+	 */
 	const struct bch_extent_rebalance *r = k.k->type == KEY_TYPE_reflink_v
 		? bch2_bkey_rebalance_opts(k) : NULL;
 	if (r) {
-#define x(_name)							\
-		if (r->_name##_from_inode) {				\
-			io_opts->_name = r->_name;			\
-			io_opts->_name##_from_inode = true;		\
+#define x(_name)								\
+		if (r->_name##_from_inode &&					\
+		    !(may_update_indirect && io_opts->_name##_from_inode)) {	\
+			io_opts->_name = r->_name;				\
+			io_opts->_name##_from_inode = true;			\
 		}
 		BCH_REBALANCE_OPTS()
 #undef x
-- 
2.50.1

