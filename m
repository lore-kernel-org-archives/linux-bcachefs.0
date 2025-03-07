Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74E321ABBD
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355387; cv=none; b=m30hP1zX0alHH5bvR775SxmTbSefZumn1Cu7aS/f0aUjkYoQhapp9CW749QmtTDNjFdCfgxGvKJCsMbixaY3490DQo4y0l2BPGBbwJL/OAaNuuEeItDg0oR4HOZhStygakgmFPFINNTSqvz3xz68jn7jUdIp/qaQa0zkILwFCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355387; c=relaxed/simple;
	bh=zh5le6Hk0IC6liNliAEcDtVoAZPfkDLXdIbmjjiPhiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjMIOsppuUcxcGiIS/QJ6tRpqL/jIFxXiQmjxkgrWOcOPT2o+IBMpgaFNZdRkUNkx5CzptVNqAzgL/lsOWsbRJ9TxpjhrrA27/giFbMfK2F1pvQagE/klCoBpkuIYJb9FqstGoUFSpUyLw5Pd7EXIyTIvyf3qG2A5iOlKO6uqaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ICcPpJyL; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ICcPpJyL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741355383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NwljdDtq7nkUuYkVfOdGvy8BRX+vk42k62VOJkp6OfU=;
	b=ICcPpJyL7CNsC6grbF3ZtzCtam4+ngOXzLOhrn6CkV0df0Y1ISMeSsjwYsfTufc6ililWb
	g9IbPF6hF+5wmLoBaWLYSDW/RGAzGtNvx8K8sOs22iS47T0xoqjvJxH32tnpmVhfklfS7Z
	tPqAwGF6xo3UAW5PTaWmjL5mmCmOWZ0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/7] bcachefs: Implement blk_holder_ops
Date: Fri,  7 Mar 2025 08:49:28 -0500
Message-ID: <20250307134933.1033872-5-kent.overstreet@linux.dev>
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

We can't use the standard fs_holder_ops because they're meant for single
device filesystems - fs_bdev_mark_dead() in particular - and they assume
that the blk_holder is the super_block, which also doesn't work for a
multi device filesystem.

These generally follow the standard fs_holder_ops; the
locking/refcounting is a bit simplified because c->ro_ref suffices, and
bch2_fs_bdev_mark_dead() is not necessarily shutting down the entire
filesystem.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super-io.c |  3 --
 fs/bcachefs/super.c    | 97 ++++++++++++++++++++++++++++++++++++++++++
 fs/bcachefs/super.h    |  2 +
 3 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index bd24b4f7eeb6..dcb69c72555e 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -25,9 +25,6 @@
 #include <linux/sort.h>
 #include <linux/string_choices.h>
 
-static const struct blk_holder_ops bch2_sb_handle_bdev_ops = {
-};
-
 struct bch2_metadata_version {
 	u16		version;
 	const char	*name;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index b653dd480591..05a2dc5ef513 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1075,6 +1075,7 @@ int bch2_fs_start(struct bch_fs *c)
 	}
 
 	set_bit(BCH_FS_started, &c->flags);
+	wake_up(&c->ro_ref_wait);
 
 	if (c->opts.read_only) {
 		bch2_fs_read_only(c);
@@ -2023,6 +2024,102 @@ struct bch_dev *bch2_dev_lookup(struct bch_fs *c, const char *name)
 	return ERR_PTR(-BCH_ERR_ENOENT_dev_not_found);
 }
 
+/* blk_holder_ops: */
+
+static struct bch_fs *bdev_get_fs(struct block_device *bdev)
+	__releases(&bdev->bd_holder_lock)
+{
+	struct bch_sb_handle_holder *holder = bdev->bd_holder;
+	struct bch_fs *c = holder->c;
+
+	if (c && !bch2_ro_ref_tryget(c))
+		c = NULL;
+
+	mutex_unlock(&bdev->bd_holder_lock);
+
+	if (c)
+		wait_event(c->ro_ref_wait, test_bit(BCH_FS_started, &c->flags));
+	return c;
+}
+
+/* returns with ref on ca->ref */
+static struct bch_dev *bdev_to_bch_dev(struct bch_fs *c, struct block_device *bdev)
+{
+	for_each_member_device(c, ca)
+		if (ca->disk_sb.bdev == bdev)
+			return ca;
+	return NULL;
+}
+
+static void bch2_fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
+{
+	struct bch_fs *c = bdev_get_fs(bdev);
+	if (!c)
+		return;
+
+	struct super_block *sb = c->vfs_sb;
+	if (sb) {
+		/*
+		 * Not necessary, c->ro_ref guards against the filesystem being
+		 * unmounted - we only take this to avoid a warning in
+		 * sync_filesystem:
+		 */
+		down_read(&sb->s_umount);
+	}
+
+	down_write(&c->state_lock);
+	struct bch_dev *ca = bdev_to_bch_dev(c, bdev);
+	if (!ca)
+		goto unlock;
+
+	if (bch2_dev_state_allowed(c, ca, BCH_MEMBER_STATE_failed, BCH_FORCE_IF_DEGRADED)) {
+		__bch2_dev_offline(c, ca);
+	} else {
+		if (sb) {
+			if (!surprise)
+				sync_filesystem(sb);
+			shrink_dcache_sb(sb);
+			invalidate_inodes(sb);
+		}
+
+		bch2_journal_flush(&c->journal);
+		bch2_fs_emergency_read_only(c);
+	}
+
+	bch2_dev_put(ca);
+unlock:
+	if (sb)
+		up_read(&sb->s_umount);
+	up_write(&c->state_lock);
+	bch2_ro_ref_put(c);
+}
+
+static void bch2_fs_bdev_sync(struct block_device *bdev)
+{
+	struct bch_fs *c = bdev_get_fs(bdev);
+	if (!c)
+		return;
+
+	struct super_block *sb = c->vfs_sb;
+	if (sb) {
+		/*
+		 * Not necessary, c->ro_ref guards against the filesystem being
+		 * unmounted - we only take this to avoid a warning in
+		 * sync_filesystem:
+		 */
+		down_read(&sb->s_umount);
+		sync_filesystem(sb);
+		up_read(&sb->s_umount);
+	}
+
+	bch2_ro_ref_put(c);
+}
+
+const struct blk_holder_ops bch2_sb_handle_bdev_ops = {
+	.mark_dead		= bch2_fs_bdev_mark_dead,
+	.sync			= bch2_fs_bdev_sync,
+};
+
 /* Filesystem open: */
 
 static inline int sb_cmp(struct bch_sb *l, struct bch_sb *r)
diff --git a/fs/bcachefs/super.h b/fs/bcachefs/super.h
index 04f8287eff5c..23533bce5709 100644
--- a/fs/bcachefs/super.h
+++ b/fs/bcachefs/super.h
@@ -42,4 +42,6 @@ void bch2_fs_stop(struct bch_fs *);
 int bch2_fs_start(struct bch_fs *);
 struct bch_fs *bch2_fs_open(char * const *, unsigned, struct bch_opts);
 
+extern const struct blk_holder_ops bch2_sb_handle_bdev_ops;
+
 #endif /* _BCACHEFS_SUPER_H */
-- 
2.47.2

