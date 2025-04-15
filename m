Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC1F28BA93
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727344; cv=none; b=OoDCYzvY2N/y9VdWG8MNbppDSZAfPYU9mkZCeC4c5FcKsPFyFF/VRohLZ/PReFV5TxM+W+EZOTCUDsg0rrrznk/KPxGxKmeWVH/YyX3+ZTcarP9VfjjRqhZcgV1PB/ep7yPWMeg8+43rIZT2JKzUotXTT0M6ZCazYEMYnbC9CHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727344; c=relaxed/simple;
	bh=NUQkhjeuWYaJcwcwAxBJxtasq7I8oJEUZe7Mm4gSs7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTZ25sock+mRwWy/evywpkKO1qtlF+FwGNMckGFsvagw2m8sYC10zOWgsgjPke1VRlb+wMH/0yVkt4jwxeQ9HWrtlL/3cPodfvO8KLAHpsUmrOFFMv1fiY3oJdhRDgZFRPhvT4bDJitCl8li/h67mB8AB9b/s0zYMED37funn+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jmt+G71d; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jmt+G71d"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t1Vm7ixy4qRt1deGKwYTocQ2+zvvZdj0oR3Oz6swYYI=;
	b=Jmt+G71dJoojtNI7bXbxqplprxQuxz2stIWzhW0gQENL7EnDzUdJJgYgwGCy4uREDJ/gDp
	0v/8O7scVROwpnyBXoztkOarPfBUuvRPzIv+R+sogI3tLZ7J0Hreel2dWUZlRiODFvQx6H
	/NmGTKpeEm3Lw7pS5d0pdUdL59MNeuU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: Log message when incompat version requested but not enabled
Date: Tue, 15 Apr 2025 10:28:53 -0400
Message-ID: <20250415142853.2624553-2-kent.overstreet@linux.dev>
In-Reply-To: <20250415142853.2624553-1-kent.overstreet@linux.dev>
References: <20250415142853.2624553-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/bcachefs.h |  2 ++
 fs/bcachefs/fs-ioctl.c |  2 +-
 fs/bcachefs/super-io.c | 20 ++++++++++++++++++--
 fs/bcachefs/super.c    |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 5cb0fc384ac0..75f7408da173 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -788,6 +788,8 @@ struct bch_fs {
 		unsigned long	errors_silent[BITS_TO_LONGS(BCH_FSCK_ERR_MAX)];
 		u64		btrees_lost_data;
 	}			sb;
+	DARRAY(enum bcachefs_metadata_version)
+				incompat_versions_requested;
 
 #ifdef CONFIG_UNICODE
 	struct unicode_map	*cf_encoding;
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index c1553e44e049..14886e1d4d6d 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -69,7 +69,7 @@ static int bch2_inode_flags_set(struct btree_trans *trans,
 		if (ret < 0)
 			return ret;
 
-		ret = bch2_request_incompat_feature(c,bcachefs_metadata_version_casefolding);
+		ret = bch2_request_incompat_feature(c, bcachefs_metadata_version_casefolding);
 		if (ret)
 			return ret;
 
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index e27422b6d9c6..25b6bce05c3c 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -73,14 +73,30 @@ int bch2_set_version_incompat(struct bch_fs *c, enum bcachefs_metadata_version v
 		? 0
 		: -BCH_ERR_may_not_use_incompat_feature;
 
+	mutex_lock(&c->sb_lock);
 	if (!ret) {
-		mutex_lock(&c->sb_lock);
 		SET_BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb,
 			max(BCH_SB_VERSION_INCOMPAT(c->disk_sb.sb), version));
 		bch2_write_super(c);
-		mutex_unlock(&c->sb_lock);
+	} else {
+		darray_for_each(c->incompat_versions_requested, i)
+			if (version == *i)
+				goto out;
+
+		darray_push(&c->incompat_versions_requested, version);
+		struct printbuf buf = PRINTBUF;
+		prt_str(&buf, "requested incompat feature ");
+		bch2_version_to_text(&buf, version);
+		prt_str(&buf, " currently not enabled");
+		prt_printf(&buf, "\n  set version_upgrade=incompat to enable");
+
+		bch_notice(c, "%s", buf.buf);
+		printbuf_exit(&buf);
 	}
 
+out:
+	mutex_unlock(&c->sb_lock);
+
 	return ret;
 }
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index f1eef5e7698b..e8a17ed1615d 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -589,6 +589,7 @@ static void __bch2_fs_free(struct bch_fs *c)
 		free_percpu(c->online_reserved);
 	}
 
+	darray_exit(&c->incompat_versions_requested);
 	darray_exit(&c->btree_roots_extra);
 	free_percpu(c->pcpu);
 	free_percpu(c->usage);
-- 
2.49.0

