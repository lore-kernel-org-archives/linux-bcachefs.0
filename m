Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBEE179A7
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744810657; cv=none; b=BfQiC45A1Ok1db+Kz7mnA7KWTvglqVVvUVxzmMj2IaKptvSuy5jKj35q9YVf/QEfWaC64o/6xW7OxzdX1XA7HpbWa8H8eIgd/uNJWDSAvEuOqOnnPHQdwHb0IuRtGcMZ0eze5TY1MtPq9gpUDbycmXCnvim7c3LXaVqstbbLVXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744810657; c=relaxed/simple;
	bh=V5KRbVF/snXQfdnY2PPC5QhwM1h3Ii6cMyMni1BW0IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CW4GD4WT4ng/QHU/8a49QR7FUPfgZUJvKSyi/VNlQeB1YHHCvXipJqAOEG80sYcLgLtyVC6Ps4YOv4BY4vtD5ZZ5hNoQx0yGg7tAPMUkJU+IDhv6dg+jEwRA3OR4+f7re31M5it1ILQ+AizdUGIpwNpsjXt1+KXsiZOWT7tigu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SR+iiiIf; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SR+iiiIf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744810652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JzmI41x92KGIexwSyoxxM8DWgIpe7MNw1xiZL0OShkk=;
	b=SR+iiiIfkZmn3eLRr7Qq2eopNEJJ3EjAu1xwsrS5hBptblv2WzctzsUv4uLjCGS/lJZLPa
	1QlEjFq29XmlmTO+FQtgYIrCXEU5gbdLkcLHf/+AVuIlhvcOIcbGD+TJ4Se5z2zsiCRNe0
	R+FpJ7dQh5fqhs0CydQj5xsle5qyUvY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/6] bcachefs: Add a recovery pass for making sure root inode is readable
Date: Wed, 16 Apr 2025 09:37:24 -0400
Message-ID: <20250416133724.3653606-6-kent.overstreet@linux.dev>
In-Reply-To: <20250416133724.3653606-1-kent.overstreet@linux.dev>
References: <20250416133724.3653606-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If the root inode/subvolume is unreadable we can repair automatically -
but only if we're still in recovery, so that we can rewind to the
appropriate recovery pass.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery_passes.c       | 15 +++++++++++++++
 fs/bcachefs/recovery_passes_types.h |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index d0b8a852efae..92e431af9ac3 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -51,6 +51,21 @@ static int bch2_set_may_go_rw(struct bch_fs *c)
 	return 0;
 }
 
+/*
+ * Make sure root inode is readable while we're still in recovery and can rewind
+ * for repair:
+ */
+static int bch2_lookup_root_inode(struct bch_fs *c)
+{
+	subvol_inum inum = BCACHEFS_ROOT_SUBVOL_INUM;
+	struct bch_inode_unpacked inode_u;
+	struct bch_subvolume subvol;
+
+	return bch2_trans_do(c,
+		bch2_subvolume_get(trans, inum.subvol, true, &subvol) ?:
+		bch2_inode_find_by_inum_trans(trans, inum, &inode_u));
+}
+
 struct recovery_pass_fn {
 	int		(*fn)(struct bch_fs *);
 	unsigned	when;
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index e89b9c783285..4671ccf2d560 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -60,7 +60,8 @@
 	x(resume_logged_ops,			23, PASS_ALWAYS)			\
 	x(delete_dead_inodes,			32, PASS_ALWAYS)			\
 	x(fix_reflink_p,			33, 0)					\
-	x(set_fs_needs_rebalance,		34, 0)
+	x(set_fs_needs_rebalance,		34, 0)					\
+	x(lookup_root_inode,			42, PASS_ALWAYS|PASS_SILENT)
 
 /* We normally enumerate recovery passes in the order we run them: */
 enum bch_recovery_pass {
-- 
2.49.0

