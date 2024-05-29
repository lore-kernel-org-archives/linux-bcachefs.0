Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ED916E876
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717024000; cv=none; b=pFcms6m8W+Lyzfbj05vCbfJ88ALkDXkZRIXHhUAhHkGqb3CpZkcLdUbBg3xwh89jhn3gjHMhA0HOjuzh/05fnBcLo0eUwjGzSaArnZ72HyDHNMt4V7BxOezBBI/xOT4wHUlqngPhjDBw2L29QzQoccqpWLv5Wz8ER2sHVaJBFNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717024000; c=relaxed/simple;
	bh=7f4L6J6WnTpDGW1DfkATtcCDvovoemylV3IBqazeG6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzyu+TiweVGqAbel0wAKBsDzDe9SYBfENZvXCuYZfH2W/0EMya17eBjiDXjYsNMXUdbXpG4Yu5nTHJoGw9SP437ABK06IIjNhkeU/C40Jg0aAlS+EX/swIdbQ1eB4w0RkJJLN7W4F2gzNmwjkQMVe+MI8fzI2fvRC7oHjX7B5v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YGNQVoWb; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YGNQVoWb"
X-Envelope-To: linux-bcachefs@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717023996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ixHPT8CPV8vhwZqSh9uloFd52EaPxdjvLaZOPAlvkY=;
	b=YGNQVoWbGR5kaBpnWzZndoyEjAeJc7fQGxMViluP9NHlP0nROlCJzFg44TpgcQ6lsVzTmB
	jC8StLeXDI57NuTgcq4CJzcxTl7c8LuH/hj7Xe9fOZGQGh3eHjYF/FZqBpOwQMJF0ubVYf
	/yQO34WdF8INiVtz6mOe84JrC7Q4FpQ=
X-Envelope-To: kent.overstreet@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: bch2_fs_get_tree() cleanup
Date: Wed, 29 May 2024 19:06:12 -0400
Message-ID: <20240529230613.4147855-2-kent.overstreet@linux.dev>
In-Reply-To: <20240529230613.4147855-1-kent.overstreet@linux.dev>
References: <20240529230613.4147855-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

- improve error paths
- call bch2_fs_start() separately, after applying late-parsed options

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c | 59 ++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 61aba7d53194..d4e7d6dc61cb 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1879,25 +1879,24 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	struct inode *vinode;
 	struct bch2_opts_parse *opts_parse = fc->fs_private;
 	struct bch_opts opts = opts_parse->opts;
+	darray_str devs;
+	darray_fs devs_to_fs = {};
 	int ret;
 
 	opt_set(opts, read_only, (fc->sb_flags & SB_RDONLY) != 0);
+	opt_set(opts, nostart, true);
 
 	if (!fc->source || strlen(fc->source) == 0)
 		return -EINVAL;
 
-	darray_str devs;
 	ret = bch2_split_devs(fc->source, &devs);
 	if (ret)
 		return ret;
 
-	darray_fs devs_to_fs = {};
 	darray_for_each(devs, i) {
 		ret = darray_push(&devs_to_fs, bch2_path_to_fs(*i));
-		if (ret) {
-			sb = ERR_PTR(ret);
-			goto got_sb;
-		}
+		if (ret)
+			goto err;
 	}
 
 	sb = sget(fc->fs_type, bch2_test_super, bch2_noset_super, fc->sb_flags|SB_NOSEC, &devs_to_fs);
@@ -1905,33 +1904,27 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 		goto got_sb;
 
 	c = bch2_fs_open(devs.data, devs.nr, opts);
-	if (IS_ERR(c)) {
-		sb = ERR_CAST(c);
-		goto got_sb;
-	}
+	ret = PTR_ERR_OR_ZERO(c);
+	if (ret)
+		goto err;
 
 	/* Some options can't be parsed until after the fs is started: */
+	opts = bch2_opts_empty();
 	ret = bch2_parse_mount_opts(c, &opts, NULL, opts_parse->parse_later.buf);
-	if (ret) {
-		bch2_fs_stop(c);
-		sb = ERR_PTR(ret);
-		goto got_sb;
-	}
+	if (ret)
+		goto err_stop_fs;
 
 	bch2_opts_apply(&c->opts, opts);
 
+	ret = bch2_fs_start(c);
+	if (ret)
+		goto err_stop_fs;
+
 	sb = sget(fc->fs_type, NULL, bch2_set_super, fc->sb_flags|SB_NOSEC, c);
-	if (IS_ERR(sb))
-		bch2_fs_stop(c);
+	ret = PTR_ERR_OR_ZERO(sb);
+	if (ret)
+		goto err_stop_fs;
 got_sb:
-	darray_exit(&devs_to_fs);
-	bch2_darray_str_exit(&devs);
-
-	if (IS_ERR(sb)) {
-		ret = PTR_ERR(sb);
-		goto err;
-	}
-
 	c = sb->s_fs_info;
 
 	if (sb->s_root) {
@@ -2001,12 +1994,9 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	sb->s_flags |= SB_ACTIVE;
 out:
 	fc->root = dget(sb->s_root);
-	return 0;
-
-err_put_super:
-	__bch2_fs_stop(c);
-	deactivate_locked_super(sb);
 err:
+	darray_exit(&devs_to_fs);
+	bch2_darray_str_exit(&devs);
 	/*
 	 * On an inconsistency error in recovery we might see an -EROFS derived
 	 * errorcode (from the journal), but we don't want to return that to
@@ -2016,6 +2006,15 @@ static int bch2_fs_get_tree(struct fs_context *fc)
 	if (bch2_err_matches(ret, EROFS) && ret != -EROFS)
 		ret = -EIO;
 	return bch2_err_class(ret);
+
+err_stop_fs:
+	bch2_fs_stop(c);
+	goto err;
+
+err_put_super:
+	__bch2_fs_stop(c);
+	deactivate_locked_super(sb);
+	goto err;
 }
 
 static void bch2_kill_sb(struct super_block *sb)
-- 
2.45.1

