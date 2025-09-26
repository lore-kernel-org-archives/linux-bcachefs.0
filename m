Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F8625A2BB
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Sep 2025 02:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758853425; cv=none; b=npuxjAa2QNSY7z/L7RMcvA+5LNqcvDBW+ILDQqiwe51XV9vC6KdmGcIwZc6r3i4n4VEg8ErIXREPsOxHaTSAuvdQiOzlDp3ZddGH5xz5m//9Pev8b2AIT3jOjWGDdz7mBOmTsFCpFxvOJECjqtuFJqpWY/TCneTjtXvcHdsqRuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758853425; c=relaxed/simple;
	bh=0NXTGrLTPNSxZcUiq6+ZbqY/OReSGiuA7MewAxYgCiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpxNufP03u9d4U6Kd7Vxb7k8+XbeedvgeKCOi/EU4BPmlFeVdGaOnx1QnHE/c+pZhtGUuKNv9YxA5DfyNGROcB4cptqc4leCvEqmbeu+rOnf3pYqVG7yDbB43uiI6cWUVr/RJ2rPiTgAQPHbx0s5jqLdSw2wdqoAShHBSO6+XYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GrCqayRs; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GrCqayRs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758853421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73MJ7cpZle+sMbrPOgXtkiLILSGA2P6+DUvxQ0cmryc=;
	b=GrCqayRshtnlk4PLiLqMbdEKJqnAHc/DgbGbDqUqtrKXwoJqO5YVpN7vaukGrLUupLH41f
	C5nOhHSU3vGtErDeuTO60+Tk2AN7t5ADbjQrX4X9WMtoieil9G+mcuhIoKLgwE88TgUOVO
	8Uv4XH/hqm4jzIZYOapwOp1XFKVK91c=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH 3/3] bcachefs: Move the link counting check to the VFS layer
Date: Fri, 26 Sep 2025 10:21:50 +0800
Message-ID: <20250926022150.493115-4-youling.tang@linux.dev>
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

Currently bcachefs only performs link count checks during link operations,
during rename and mkdir operations, the link count should also be checked.

This patch moves the checks to the vfs_{link,rename,mkdir} functions when
sb->s_max_links is set, eliminating the need for filesystem-specific checks.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/errcode.h |  1 -
 fs/bcachefs/fs.c      |  1 +
 fs/bcachefs/inode.c   | 10 ++--------
 fs/bcachefs/inode.h   |  2 +-
 fs/bcachefs/namei.c   |  4 +---
 5 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index b22a694ec750..acc3b7b67704 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -215,7 +215,6 @@
 	x(EINVAL,			varint_decode_error)			\
 	x(EINVAL,			erasure_coding_found_btree_node)	\
 	x(EINVAL,			option_negative)			\
-	x(EMLINK,			too_many_links)				\
 	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
 	x(EROFS,			erofs_trans_commit)			\
 	x(EROFS,			erofs_no_writes)			\
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 687af0eea0c2..6b60c97c5610 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2526,6 +2526,7 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	sb->s_time_gran		= c->sb.nsec_per_time_unit;
 	sb->s_time_min		= div_s64(S64_MIN, c->sb.time_units_per_sec) + 1;
 	sb->s_time_max		= div_s64(S64_MAX, c->sb.time_units_per_sec);
+	sb->s_max_links		= BCH_LINK_MAX;
 	super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
 
 	if (c->sb.multi_device)
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index eedffb505517..20e58258c813 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1187,18 +1187,12 @@ int bch2_inode_rm(struct bch_fs *c, subvol_inum inum)
 	return ret;
 }
 
-int bch2_inode_nlink_inc(struct bch_inode_unpacked *bi)
+void bch2_inode_nlink_inc(struct bch_inode_unpacked *bi)
 {
 	if (bi->bi_flags & BCH_INODE_unlinked)
 		bi->bi_flags &= ~BCH_INODE_unlinked;
-	else {
-		if (bi->bi_nlink == BCH_LINK_MAX - nlink_bias(bi->bi_mode))
-			return -BCH_ERR_too_many_links;
-
+	else
 		bi->bi_nlink++;
-	}
-
-	return 0;
 }
 
 void bch2_inode_nlink_dec(struct btree_trans *trans, struct bch_inode_unpacked *bi)
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index b8ec3e628d90..99de17e9f32c 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -285,7 +285,7 @@ static inline void bch2_inode_nlink_set(struct bch_inode_unpacked *bi,
 	}
 }
 
-int bch2_inode_nlink_inc(struct bch_inode_unpacked *);
+void bch2_inode_nlink_inc(struct bch_inode_unpacked *);
 void bch2_inode_nlink_dec(struct btree_trans *, struct bch_inode_unpacked *);
 
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index c3f87c59922d..42e06baa2e43 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -221,9 +221,7 @@ int bch2_link_trans(struct btree_trans *trans,
 		return ret;
 
 	inode_u->bi_ctime = now;
-	ret = bch2_inode_nlink_inc(inode_u);
-	if (ret)
-		goto err;
+	bch2_inode_nlink_inc(inode_u);
 
 	ret = bch2_inode_peek(trans, &dir_iter, dir_u, dir, BTREE_ITER_intent);
 	if (ret)
-- 
2.43.0

