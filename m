Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C336921A92F
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355387; cv=none; b=eaEG2DRw9m5+gh1TOBhBBJs/4NHePlqkBRqywN58GEADEcXlQ4FhBIxObloYTWv6CMSZmhDA+5BAr7cMgnKafTGZNKLdH/CSk8Lr/BlqJtWa6QAaUcRz2W9LVvKppFk+vcoeTKX+SufUfrn/8XPPb+lp5tPvJG/xrxYh25ZoyvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355387; c=relaxed/simple;
	bh=6/9dePklkamGE2mIb0m9BJD4GTgSdC+9+BIK/NkFMw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o51LO/pkWiHbfafg25giRd+WqbF8RnaXRgD0MSezSxROG+HIHgqone8Zq3nLqs8eugROUubAj4Fzu/gZYbH9uXRiuN4Fj1otj4BuYQwf6xIFa/1PtxYBgENqrnRlmT4A4kp1dGWY3zPV/oP7JFkL8TItsF9lcEfXZuVWU296OAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PcEi05Wk; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PcEi05Wk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DdISwa6vH5Zc+6gigrn+eRpFYfzF0XduhqRKofHcLvo=;
	b=PcEi05Wkd5VwVMLybQnLfJe8dPQDxc5/fAEeBjcFpP5lMz0eu9fY7Z5FnBHaaQAHZM6RX5
	8pBtz3kxUZK4jnYM3hmtMz4cK5WqYmLib0v97a0oZaBvw95lT7AxhkaoxKFdbMQehKbd9Z
	RC1YbZsILToDhHH24N/QD1qDykHcb/s=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/7] bcachefs: Make sure c->vfs_sb is set before starting fs
Date: Fri,  7 Mar 2025 08:49:27 -0500
Message-ID: <20250307134933.1033872-4-kent.overstreet@linux.dev>
In-Reply-To: <20250307134933.1033872-1-kent.overstreet@linux.dev>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This is necessary for the new blk_holder_ops, which want the vfs
super_block available for synchronization.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 2c011a465588..459ca8259fc0 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2218,9 +2218,10 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 
 	bch2_opts_apply(&c->opts, opts);
 
-	ret = bch2_fs_start(c);
-	if (ret)
-		goto err_stop_fs;
+	/*
+	 * need to initialise sb and set c->vfs_sb _before_ starting fs,
+	 * for blk_holder_ops
+	 */
 
 	sb = sget(fc->fs_type, NULL, bch2_set_super, fc->sb_flags|SB_NOSEC, c);
 	ret = PTR_ERR_OR_ZERO(sb);
@@ -2282,6 +2283,10 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 
 	sb->s_shrink->seeks = 0;
 
+	ret = bch2_fs_start(c);
+	if (ret)
+		goto err_put_super;
+
 	vinode = bch2_vfs_inode_get(c, BCACHEFS_ROOT_SUBVOL_INUM);
 	ret = PTR_ERR_OR_ZERO(vinode);
 	bch_err_msg(c, ret, "mounting: error getting root inode");
-- 
2.47.2

