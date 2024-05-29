Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959DE16E876
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 23:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717023989; cv=none; b=UCnEjbt/+2gmxGqId1KLM1wgHiOs4mPLDbL9crDEDGYp8fgq+UYW5XZdU/ZTzpu1Y6Ctv7SEcU5O4oyaMqtscbY7ItJaVNYCEk0cT4dycS9oH2FrvLpEJ1S0k1vE6k+uiPWq1SEqM1+J/H25wM7kjDjhSp3V+Y3Gq8LZlDgTPs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717023989; c=relaxed/simple;
	bh=dyorl+G9Znzcd1QaDaxuSCnEMeB+YUqbIRM+cqsSvpg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e4dxvG0A0YaaUfnP5GgMoI/73HAw4nWTyP6BUIVzJxUvOx0NuByBLZ8dRwuPVf3cv1IHCCwbAgMFHp9mb4ygKoBx93dqAAxGdPMndDsdCpVPUB/OttcSpH7cH6sgTtluj30Hxm2cun6yWuSXPGza2LFUX+WfLsp7xHyk60ChjwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IwJ810+s; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IwJ810+s"
X-Envelope-To: linux-bcachefs@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717023982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WxKPVSUFX0WXiXYXUa61moJHKLyc26xoe+l3aExt7J4=;
	b=IwJ810+s+vGjg6Wx6nSq8r/MAhrLz5PBR6+gBIn/WRJGMptnmXC/geA3hWnjyvQ08Vpr4y
	C6ney9mr9iDj+ROya8X8rNlEmQKN7MjmX4woe/5eT8BULsLJtF0+L+tRGrxGBa7jTx9k3w
	w/LmnBp2c/OBgWXrpy4tsJxHYq5dUeE=
X-Envelope-To: kent.overstreet@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Kill bch2_mount()
Date: Wed, 29 May 2024 19:06:11 -0400
Message-ID: <20240529230613.4147855-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fold into bch2_fs_get_tree()

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 46 +++++++++++++++-------------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index d3984f197d9f..61aba7d53194 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1872,25 +1872,24 @@ static int bch2_test_super(struct super_block *s, void *data)
 	return true;
 }
 
-static struct dentry *bch2_mount(struct file_system_type *fs_type,
-				 int flags, const char *dev_name,
-				 struct bch2_opts_parse opts_parse)
+static int bch2_fs_get_tree(struct fs_context *fc)
 {
 	struct bch_fs *c;
 	struct super_block *sb;
 	struct inode *vinode;
-	struct bch_opts opts = opts_parse.opts;
+	struct bch2_opts_parse *opts_parse = fc->fs_private;
+	struct bch_opts opts = opts_parse->opts;
 	int ret;
 
-	opt_set(opts, read_only, (flags & SB_RDONLY) != 0);
+	opt_set(opts, read_only, (fc->sb_flags & SB_RDONLY) != 0);
 
-	if (!dev_name || strlen(dev_name) == 0)
-		return ERR_PTR(-EINVAL);
+	if (!fc->source || strlen(fc->source) == 0)
+		return -EINVAL;
 
 	darray_str devs;
-	ret = bch2_split_devs(dev_name, &devs);
+	ret = bch2_split_devs(fc->source, &devs);
 	if (ret)
-		return ERR_PTR(ret);
+		return ret;
 
 	darray_fs devs_to_fs = {};
 	darray_for_each(devs, i) {
@@ -1901,7 +1900,7 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 		}
 	}
 
-	sb = sget(fs_type, bch2_test_super, bch2_noset_super, flags|SB_NOSEC, &devs_to_fs);
+	sb = sget(fc->fs_type, bch2_test_super, bch2_noset_super, fc->sb_flags|SB_NOSEC, &devs_to_fs);
 	if (!IS_ERR(sb))
 		goto got_sb;
 
@@ -1912,7 +1911,7 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 	}
 
 	/* Some options can't be parsed until after the fs is started: */
-	ret = bch2_parse_mount_opts(c, &opts, NULL, opts_parse.parse_later.buf);
+	ret = bch2_parse_mount_opts(c, &opts, NULL, opts_parse->parse_later.buf);
 	if (ret) {
 		bch2_fs_stop(c);
 		sb = ERR_PTR(ret);
@@ -1921,7 +1920,7 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 
 	bch2_opts_apply(&c->opts, opts);
 
-	sb = sget(fs_type, NULL, bch2_set_super, flags|SB_NOSEC, c);
+	sb = sget(fc->fs_type, NULL, bch2_set_super, fc->sb_flags|SB_NOSEC, c);
 	if (IS_ERR(sb))
 		bch2_fs_stop(c);
 got_sb:
@@ -1936,7 +1935,7 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 	c = sb->s_fs_info;
 
 	if (sb->s_root) {
-		if ((flags ^ sb->s_flags) & SB_RDONLY) {
+		if ((fc->sb_flags ^ sb->s_flags) & SB_RDONLY) {
 			ret = -EBUSY;
 			goto err_put_super;
 		}
@@ -2001,7 +2000,8 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 
 	sb->s_flags |= SB_ACTIVE;
 out:
-	return dget(sb->s_root);
+	fc->root = dget(sb->s_root);
+	return 0;
 
 err_put_super:
 	__bch2_fs_stop(c);
@@ -2015,7 +2015,7 @@ static struct dentry *bch2_mount(struct file_system_type *fs_type,
 	 */
 	if (bch2_err_matches(ret, EROFS) && ret != -EROFS)
 		ret = -EIO;
-	return ERR_PTR(bch2_err_class(ret));
+	return bch2_err_class(ret);
 }
 
 static void bch2_kill_sb(struct super_block *sb)
@@ -2060,22 +2060,6 @@ static int bch2_fs_parse_param(struct fs_context *fc,
 	return bch2_err_class(ret);
 }
 
-static int bch2_fs_get_tree(struct fs_context *fc)
-{
-	struct bch2_opts_parse *opts = fc->fs_private;
-	const char *dev_name = fc->source;
-	struct dentry *root;
-
-	root = bch2_mount(fc->fs_type, fc->sb_flags, dev_name, *opts);
-
-	if (IS_ERR(root))
-		return PTR_ERR(root);
-
-	fc->root = root;
-
-	return 0;
-}
-
 static int bch2_fs_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
-- 
2.45.1

