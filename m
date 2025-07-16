Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5591D7E26
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Jul 2025 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752681718; cv=none; b=PWdOLXA5qs3luu3gbcNkCOHEYOGqTj2I553TrEK/ChWKJkdyhi4G36D/+sk7tfp7Dd4LoU1fJ/JReiZVDk7Dz6n2ZrVsZLO7M4ET74k7KnrR8zK/ykAd8tyz4tLog3lqTwcawBontBpKAlCTuf7UU2gHL+sa24QHkDqzZue9gp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752681718; c=relaxed/simple;
	bh=fLvqEokM8rjDCcRc7HCD10Ua1kTVVx6tyjobRzB7yLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xk+9l3LEaFvy5dMk1UQf04Zyr1F9/YtC+Cx9e/3bPFuuaA04KnyN2KsRI0/gxvmJpo1wbyz+9J8tfNwR3JG/WuD6Ox51pxHXV2UWLLQ5AkUQmWbsPyGCm8/53kySXv0pipTiv7eHSrroz2OwTG27klfkYjcA9/mNGVizP+Wyuco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J0NcY0M3; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J0NcY0M3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752681712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2y82NFi7Ka9QUlUfImHIrOpeilIuLIGJeastl6oBK3k=;
	b=J0NcY0M3pSapzdU1KssYamguZniT7sLJ2JYaki4ebmbCnDIpD6buHstVp7G/raNHfEP+GM
	6U7b9JcGrYSkSKiCujdt/i24M+onEx6j6tT14dGlsvYw0K4fDZ7bAxpF0QqeLrrKkL3xXL
	hbldXYM5HcokUlGZCvfCy1aKwxpBe2Y=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/7] bcachefs: Fix build when CONFIG_UNICODE=n
Date: Wed, 16 Jul 2025 12:01:41 -0400
Message-ID: <20250716160141.1158722-7-kent.overstreet@linux.dev>
In-Reply-To: <20250716160141.1158722-1-kent.overstreet@linux.dev>
References: <20250716160141.1158722-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

94426e4201fb, which added the killswitch for casefolding, accidentally
removed some of the ifdefs we need to avoid build errors.

It appears we need better build testing for different configurations, it
took two weeks for the robots to catch this one.

Fixes: 94426e4201fb ("bcachefs: opts.casefold_disabled")
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/dirent.c | 4 ++++
 fs/bcachefs/dirent.h | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index a18d0f78704d..28875c5c86ad 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -13,6 +13,7 @@
 
 #include <linux/dcache.h>
 
+#ifdef CONFIG_UNICODE
 int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
 		  const struct qstr *str, struct qstr *out_cf)
 {
@@ -33,6 +34,7 @@ int bch2_casefold(struct btree_trans *trans, const struct bch_hash_info *info,
 	*out_cf = (struct qstr) QSTR_INIT(buf, ret);
 	return 0;
 }
+#endif
 
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
@@ -254,6 +256,7 @@ int bch2_dirent_init_name(struct bch_fs *c,
 		if (!bch2_fs_casefold_enabled(c))
 			return -EOPNOTSUPP;
 
+#ifdef CONFIG_UNICODE
 		memcpy(&dirent->v.d_cf_name_block.d_names[0], name->name, name->len);
 
 		char *cf_out = &dirent->v.d_cf_name_block.d_names[name->len];
@@ -279,6 +282,7 @@ int bch2_dirent_init_name(struct bch_fs *c,
 		dirent->v.d_cf_name_block.d_cf_name_len = cpu_to_le16(cf_len);
 
 		EBUG_ON(bch2_dirent_get_casefold_name(dirent_i_to_s_c(dirent)).len != cf_len);
+#endif
 	}
 
 	unsigned u64s = dirent_val_u64s(name->len, cf_len);
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index 1e17199cc5c7..2e9cbf8123c4 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -23,6 +23,7 @@ struct bch_fs;
 struct bch_hash_info;
 struct bch_inode_info;
 
+#ifdef CONFIG_UNICODE
 int bch2_casefold(struct btree_trans *, const struct bch_hash_info *,
 		  const struct qstr *, struct qstr *);
 
@@ -37,6 +38,14 @@ static inline int bch2_maybe_casefold(struct btree_trans *trans,
 		return bch2_casefold(trans, info, str, out_cf);
 	}
 }
+#else
+static inline int bch2_maybe_casefold(struct btree_trans *trans,
+				      const struct bch_hash_info *info,
+				      const struct qstr *str, struct qstr *out_cf)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent);
 
-- 
2.50.0

