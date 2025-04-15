Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E982827B51D
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727372; cv=none; b=KqDOL11L8KM7CHNQo6y+OF7u2SDWfX8brlInex07CWaM7lKd51AfJZMpgNX+snJ2XUjZLWSFKZ3FE1t+Ml/zH9Bp2lB8tWqhqM9esO25/s6cZNL4TmhxBVLM7WR3obwomNyTFK0+/6mMTiwI3eYjlJ+Kdn8ZaS6OeME4uqYEU6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727372; c=relaxed/simple;
	bh=pFqXPnXuaLulskROIsCuhboZRK6X+ItzUcfF2gEUH4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ9uA1E5SS7Ka8xB5NMWdj0qS0WL2D8pJCLJ8VZfKgIaKK/JN+MkcnUCxnzM4plR312Sy73R9Egs25isReGLC+knhkRZ+ph/mmdTqAY2TI5e63ds8ruIhg4sYt7Q0FNGKqbflJ1IucHGtfiQXCzY/E/LdN7YXVvWc4bJr5xDEbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=abi7dhYH; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="abi7dhYH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/E6VxhqLqx2YBKbYMKUMnFIVJODNfLGjufKRoWaJdpc=;
	b=abi7dhYHTAw23cr+i7vbKAhLSYDx3mBd4dpPdxfWK4fAHjzViWBLi7M8xKuRXM5wlbShko
	m9WvVfC2kOJ8mzRTI48BE9J0CS9Voxr/yNL3BUWCJC1FtfyJ21yRUR//9qf78nMo2idd27
	57GgF3HNugrYen1wgpprrx6olGAXqZ8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Incompatible features may now be enabled at runtime
Date: Tue, 15 Apr 2025 10:29:21 -0400
Message-ID: <20250415142921.2624601-3-kent.overstreet@linux.dev>
In-Reply-To: <20250415142921.2624601-1-kent.overstreet@linux.dev>
References: <20250415142921.2624601-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

version_upgrade is now a runtime option.

In the future we'll want to add compatible upgrades at runtime, and call
the full check_version_upgrade() when the option changes, but we don't
have compatible optional upgrades just yet.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/opts.c     |  9 +++++++++
 fs/bcachefs/opts.h     |  2 +-
 fs/bcachefs/recovery.c |  4 ++--
 fs/bcachefs/super-io.c | 25 +++++++++++++++++++++++++
 fs/bcachefs/super-io.h |  1 +
 5 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 386482ff8e7b..b1cf88905b81 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -595,6 +595,15 @@ void bch2_opt_hook_post_set(struct bch_fs *c, struct bch_dev *ca, u64 inum,
 			mutex_unlock(&c->sb_lock);
 		}
 		break;
+	case Opt_version_upgrade:
+		/*
+		 * XXX: in the future we'll likely want to do compatible
+		 * upgrades at runtime as well, but right now there's nothing
+		 * that does that:
+		 */
+		if (new_opts->version_upgrade == BCH_VERSION_UPGRADE_incompatible)
+			bch2_sb_upgrade_incompat(c);
+		break;
 	default:
 		break;
 	}
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index f69ba5e63e15..5cdb18802138 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -445,7 +445,7 @@ enum fsck_err_opts {
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		"Reconstruct alloc btree")			\
 	x(version_upgrade,		u8,				\
-	  OPT_FS|OPT_MOUNT,						\
+	  OPT_FS|OPT_MOUNT|OPT_RUNTIME,					\
 	  OPT_STR(bch2_version_upgrade_opts),				\
 	  BCH_SB_VERSION_UPGRADE,	BCH_VERSION_UPGRADE_compatible,	\
 	  NULL,		"Set superblock to latest version,\n"		\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 606d684e6f23..58ee1ebdcbaa 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -666,7 +666,7 @@ static bool check_version_upgrade(struct bch_fs *c)
 				     bch2_recovery_passes_from_stable(le64_to_cpu(passes)));
 		}
 
-		bch_info(c, "%s", buf.buf);
+		bch_notice(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 
 		ret = true;
@@ -682,7 +682,7 @@ static bool check_version_upgrade(struct bch_fs *c)
 		bch2_version_to_text(&buf, c->sb.version_incompat_allowed);
 		prt_newline(&buf);
 
-		bch_info(c, "%s", buf.buf);
+		bch_notice(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 
 		ret = true;
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index fa4d323ddada..791dee30f042 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1273,6 +1273,31 @@ void bch2_sb_upgrade(struct bch_fs *c, unsigned new_version, bool incompat)
 	}
 }
 
+void bch2_sb_upgrade_incompat(struct bch_fs *c)
+{
+	mutex_lock(&c->sb_lock);
+	if (c->sb.version == c->sb.version_incompat_allowed)
+		goto unlock;
+
+	struct printbuf buf = PRINTBUF;
+
+	prt_str(&buf, "Now allowing incompatible features up to ");
+	bch2_version_to_text(&buf, c->sb.version);
+	prt_str(&buf, ", previously allowed up to ");
+	bch2_version_to_text(&buf, c->sb.version_incompat_allowed);
+	prt_newline(&buf);
+
+	bch_notice(c, "%s", buf.buf);
+	printbuf_exit(&buf);
+
+	c->disk_sb.sb->features[0] |= cpu_to_le64(BCH_SB_FEATURES_ALL);
+	SET_BCH_SB_VERSION_INCOMPAT_ALLOWED(c->disk_sb.sb,
+			max(BCH_SB_VERSION_INCOMPAT_ALLOWED(c->disk_sb.sb), c->sb.version));
+	bch2_write_super(c);
+unlock:
+	mutex_unlock(&c->sb_lock);
+}
+
 static int bch2_sb_ext_validate(struct bch_sb *sb, struct bch_sb_field *f,
 				enum bch_validate_flags flags, struct printbuf *err)
 {
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index 78f708a6fbcd..a3b7a90f2533 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -107,6 +107,7 @@ static inline void bch2_check_set_feature(struct bch_fs *c, unsigned feat)
 
 bool bch2_check_version_downgrade(struct bch_fs *);
 void bch2_sb_upgrade(struct bch_fs *, unsigned, bool);
+void bch2_sb_upgrade_incompat(struct bch_fs *);
 
 void __bch2_sb_field_to_text(struct printbuf *, struct bch_sb *,
 			     struct bch_sb_field *);
-- 
2.49.0

