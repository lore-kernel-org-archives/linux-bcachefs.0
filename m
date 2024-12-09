Received: from wiki.archlinuxcn.org (wiki.archlinuxcn.org [104.245.9.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09614A4DF
	for <linux-bcachefs@vger.kernel.org>; Mon,  9 Dec 2024 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.245.9.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733768197; cv=none; b=HoJwqC1TyqBJvTSTF9XGZTiVrao7NdOuYWUw6Pjtde9HSJApPwbQctReFeTzf51y9/ZndChyBu4RtYACMFIdDs/WzNQFsWEOYosimwnwmIVnq8Y/Z8I+sivrRLll2tMeiwyXrW9cPHhKvkHXy9uUm/hx80mGmndsG8ewsi6G04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733768197; c=relaxed/simple;
	bh=fNhhyY+2OW8APMFgEmeoyzm8JwtdNRzuJnF9CcpPENI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgQpeezEXdu80UkOjrjY8oPIgehJp7otYXEh7KobOV8Ug/hNdnfIF4sVeC0O2nv3ngQ5hluAK7kc7OQ98XRx5LXCEKWbMu3J0CvaJhVNixTPQqmWQbJDZr5h4WKK7tDf3pUTvEbiLf6dDUxmML13x8y3045MMQwHwiP7qrOp7s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org; spf=pass smtp.mailfrom=archlinuxcn.org; dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b=hU85b8Or; arc=none smtp.client-ip=104.245.9.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinuxcn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=archlinuxcn.org header.i=@archlinuxcn.org header.b="hU85b8Or"
DKIM-Signature: a=rsa-sha256; bh=DGfmGZhzfTbzaZ0K/ZCwX3zJi7Zul3Kzx3FuqdA60VA=;
 c=relaxed/relaxed; d=archlinuxcn.org;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@archlinuxcn.org; s=default; t=1733768172; v=1; x=1734200172;
 b=hU85b8Orzba3XlGU9hJYvkifVpz+yTapDXg22EwSiLkPqHxezqnpsrN9YkXAdRwDNA3xo7dF
 C2QxKGhe1yX/qfqy1Nq3mfabHgMY9BgBR10IUk6l9EgRW5AFXUeOkPl868Klhv4LTHaAIr5prSW
 QJMT8mI+tO/z7LheRNRRKTirXj4l/XpR9XTwBUy4w7MR1LmGivliSHz3SCqZNBhpaMjGIyfiP1J
 8nh0Jk0uP6Dc3FNOHcLZwxfnJ305aNuo7kt1FuuLgJJBga19pqEIa7RrKFw2dS59VfEUVyPmTpa
 eg0R5Jt2MjzimzyxxgxzDvrVx6VQqN2XTGvXuDbzJeh6g==
Received: by wiki.archlinuxcn.org (envelope-sender
 <integral@archlinuxcn.org>) with ESMTPS id 80fe1d99; Tue, 10 Dec 2024
 02:16:12 +0800
From: Integral <integral@archlinuxcn.org>
To: integral@archlinuxcn.org
Cc: kent.overstreet@gmail.com,
	kent.overstreet@linux.dev,
	lihongbo22@huawei.com,
	linux-bcachefs@vger.kernel.org,
	mmpgouride@gmail.com
Subject: [PATCH resend] bcachefs: use strscpy & strscpy_pad to make string copying simpler & safer
Date: Tue, 10 Dec 2024 02:15:51 +0800
Message-ID: <20241209181551.817659-1-integral@archlinuxcn.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241110064138.79527-1-integral@archlinuxcn.org>
References: <20241110064138.79527-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use safe string copying macros (strscpy & strscpy_pad) to make string
copying simpler & safer.
---
 fs/bcachefs/dirent.c      | 10 +++-------
 fs/bcachefs/disk_groups.c |  5 ++---
 fs/bcachefs/fs-ioctl.c    | 17 ++++++++---------
 fs/bcachefs/fs.c          |  6 +-----
 4 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 600eee936f13..8bc6696115c0 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -191,13 +191,9 @@ static struct bkey_i_dirent *dirent_create_key(struct btree_trans *trans,
 
 	dirent->v.d_type = type;
 
-	memcpy(dirent->v.d_name, name->name, name->len);
-	memset(dirent->v.d_name + name->len, 0,
-	       bkey_val_bytes(&dirent->k) -
-	       offsetof(struct bch_dirent, d_name) -
-	       name->len);
-
-	EBUG_ON(bch2_dirent_name_bytes(dirent_i_to_s_c(dirent)) != name->len);
+	EBUG_ON(strscpy_pad(dirent->v.d_name, name->name,
+			    bkey_val_bytes(&dirent->k) - offsetof(struct bch_dirent, d_name))
+		!= name->len);
 
 	return dirent;
 }
diff --git a/fs/bcachefs/disk_groups.c b/fs/bcachefs/disk_groups.c
index 5df8de0b8c02..c2fc575e38d1 100644
--- a/fs/bcachefs/disk_groups.c
+++ b/fs/bcachefs/disk_groups.c
@@ -319,9 +319,8 @@ static int __bch2_disk_group_add(struct bch_sb_handle *sb, unsigned parent,
 
 	g = &groups->entries[i];
 
-	memcpy(g->label, name, namelen);
-	if (namelen < sizeof(g->label))
-		g->label[namelen] = '\0';
+	strscpy(g->label, name, namelen);
+
 	SET_BCH_GROUP_DELETED(g, 0);
 	SET_BCH_GROUP_PARENT(g, parent);
 	SET_BCH_GROUP_DATA_ALLOWED(g, ~0);
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 15725b4ce393..4233707bec9d 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -279,26 +279,25 @@ static int bch2_ioc_getversion(struct bch_inode_info *inode, u32 __user *arg)
 
 static int bch2_ioc_getlabel(struct bch_fs *c, char __user *user_label)
 {
-	int ret;
-	size_t len;
 	char label[BCH_SB_LABEL_SIZE];
+	size_t len;
 
 	BUILD_BUG_ON(BCH_SB_LABEL_SIZE >= FSLABEL_MAX);
 
 	mutex_lock(&c->sb_lock);
-	memcpy(label, c->disk_sb.sb->label, BCH_SB_LABEL_SIZE);
+	int ret = strscpy(label, c->disk_sb.sb->label, BCH_SB_LABEL_SIZE);
 	mutex_unlock(&c->sb_lock);
 
-	len = strnlen(label, BCH_SB_LABEL_SIZE);
-	if (len == BCH_SB_LABEL_SIZE) {
+	if (ret == -E2BIG) {
+		len = BCH_SB_LABEL_SIZE - 1;
 		bch_warn(c,
 			"label is too long, return the first %zu bytes",
-			--len);
+			len);
+	} else {
+		len = ret;
 	}
 
-	ret = copy_to_user(user_label, label, len);
-
-	return ret ? -EFAULT : 0;
+	return copy_to_user(user_label, label, len) ? -EFAULT : 0;
 }
 
 static int bch2_ioc_setlabel(struct bch_fs *c,
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 3f83f131d0e8..b553dae38e80 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1656,7 +1656,6 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 	subvol_inum target;
 	u32 snapshot;
 	struct qstr dirent_name;
-	unsigned name_len = 0;
 	int ret;
 
 	if (!S_ISDIR(dir->v.i_mode))
@@ -1732,10 +1731,7 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 	goto err;
 found:
 	dirent_name = bch2_dirent_get_name(d);
-
-	name_len = min_t(unsigned, dirent_name.len, NAME_MAX);
-	memcpy(name, dirent_name.name, name_len);
-	name[name_len] = '\0';
+	strscpy(name, dirent_name.name, NAME_MAX);
 err:
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		goto retry;
-- 
2.47.1

