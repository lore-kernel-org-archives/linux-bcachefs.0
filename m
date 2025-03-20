Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C92222B6
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505698; cv=none; b=gan6FyejF8Fpo5P3aDURP8hdExxPfzXrmhPSGMX5Ct7XXZ2w1XK9uF1oANltdkyO4d4/hvlXIVjid7g7VO2o1vXisL2jF4GCHsf+BeGG8A0/BGvyUPLbbdv5cVTlJO8zos/QgIdJSW3pTRDM78JuTK0Dj7rr+wzZDlAK4ekW7Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505698; c=relaxed/simple;
	bh=+OjLmH+T2Re84JSvcdiOe1yWkdbrVRw0XRXBAiMirFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stfa94GO+s2swTfaK4BCBdNFa41XpWxs/44YEAeLudseyQa1ctEy3AkXWeIsmIvWmmO6AlOORv6M+Y66vprroNp3pvtCP5VN41EJmtUaYm/VkY0B/2+qUPy7d744681kkj8/oWdZUThgTG2DxP2W++s7jAM5Z2Am5+rEHLd6A1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hMonokID; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hMonokID"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RxCOqkMlsHUY7kk2Z+MeJPINSq+SB5zgTW4Kk1XHC3o=;
	b=hMonokIDOHajZYe3vzh9LzeSRqh3rbh8FD3Q3mPGU0xtdqFhHqftXrgR2KuJTl1kNlmgBU
	l65EvFbpfc1oQ4kqMCq3/7XuFXrLPNZqrGSgDsCrZvPgUaPsNp5f8efVmMZkO6vXajxKCe
	b48IyKPvZudDbjwyy9kqxK7YuBIkJ1M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/5] bcachefs: Device options now use standard sysfs code
Date: Thu, 20 Mar 2025 17:21:20 -0400
Message-ID: <20250320212125.3359155-3-kent.overstreet@linux.dev>
In-Reply-To: <20250320212125.3359155-1-kent.overstreet@linux.dev>
References: <20250320212125.3359155-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Device options now use the common code for sysfs, and can superblock
fields (in a struct bch_member).

This replaces BCH_DEV_OPT_SETTERS(), which was weird and easy to miss.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/opts.c  |   4 +-
 fs/bcachefs/opts.h  |   2 +-
 fs/bcachefs/super.c |   6 +--
 fs/bcachefs/sysfs.c | 113 +++++++++++++++++++++++---------------------
 fs/bcachefs/sysfs.h |   5 +-
 fs/bcachefs/xattr.c |   2 +-
 6 files changed, 69 insertions(+), 63 deletions(-)

diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 0dc0ce37a6e1..6c6ba23e9fbc 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -480,7 +480,7 @@ void bch2_opts_to_text(struct printbuf *out,
 	}
 }
 
-int bch2_opt_check_may_set(struct bch_fs *c, int id, u64 v)
+int bch2_opt_check_may_set(struct bch_fs *c, struct bch_dev *ca, int id, u64 v)
 {
 	int ret = 0;
 
@@ -501,7 +501,7 @@ int bch2_opt_check_may_set(struct bch_fs *c, int id, u64 v)
 int bch2_opts_check_may_set(struct bch_fs *c)
 {
 	for (unsigned i = 0; i < bch2_opts_nr; i++) {
-		int ret = bch2_opt_check_may_set(c, i, bch2_opt_get_by_id(&c->opts, i));
+		int ret = bch2_opt_check_may_set(c, NULL, i, bch2_opt_get_by_id(&c->opts, i));
 		if (ret)
 			return ret;
 	}
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index c0adfd5b4f1c..19fcc0e51c0b 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -635,7 +635,7 @@ void bch2_opts_to_text(struct printbuf *,
 		       struct bch_fs *, struct bch_sb *,
 		       unsigned, unsigned, unsigned);
 
-int bch2_opt_check_may_set(struct bch_fs *, int, u64);
+int bch2_opt_check_may_set(struct bch_fs *, struct bch_dev *, int, u64);
 int bch2_opts_check_may_set(struct bch_fs *);
 int bch2_parse_one_mount_opt(struct bch_fs *, struct bch_opts *,
 			     struct printbuf *, const char *, const char *);
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 8e928b3d8ef4..d662adfbdbcc 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -715,7 +715,7 @@ static int bch2_fs_online(struct bch_fs *c)
 	    kobject_add(&c->time_stats, &c->kobj, "time_stats") ?:
 #endif
 	    kobject_add(&c->counters_kobj, &c->kobj, "counters") ?:
-	    bch2_opts_create_sysfs_files(&c->opts_dir);
+	    bch2_opts_create_sysfs_files(&c->opts_dir, OPT_FS);
 	if (ret) {
 		bch_err(c, "error creating sysfs objects");
 		return ret;
@@ -1297,8 +1297,8 @@ static int bch2_dev_sysfs_online(struct bch_fs *c, struct bch_dev *ca)
 		return 0;
 
 	if (!ca->kobj.state_in_sysfs) {
-		ret = kobject_add(&ca->kobj, &c->kobj,
-				  "dev-%u", ca->dev_idx);
+		ret =   kobject_add(&ca->kobj, &c->kobj, "dev-%u", ca->dev_idx) ?:
+			bch2_opts_create_sysfs_files(&ca->kobj, OPT_DEVICE);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index 2ed3f755eadd..4c5b585041be 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -152,10 +152,8 @@ read_attribute(gc_gens_pos);
 read_attribute(uuid);
 read_attribute(minor);
 read_attribute(flags);
-read_attribute(bucket_size);
 read_attribute(first_bucket);
 read_attribute(nbuckets);
-rw_attribute(durability);
 read_attribute(io_done);
 read_attribute(io_errors);
 write_attribute(io_errors_reset);
@@ -208,8 +206,6 @@ read_attribute(usage_base);
 BCH_PERSISTENT_COUNTERS()
 #undef x
 
-rw_attribute(discard);
-read_attribute(state);
 rw_attribute(label);
 
 read_attribute(copy_gc_wait);
@@ -599,26 +595,34 @@ struct attribute *bch2_fs_internal_files[] = {
 
 /* options */
 
-SHOW(bch2_fs_opts_dir)
+static ssize_t sysfs_opt_show(struct bch_fs *c,
+			      struct bch_dev *ca,
+			      enum bch_opt_id id,
+			      struct printbuf *out)
 {
-	struct bch_fs *c = container_of(kobj, struct bch_fs, opts_dir);
-	const struct bch_option *opt = container_of(attr, struct bch_option, attr);
-	int id = opt - bch2_opt_table;
-	u64 v = bch2_opt_get_by_id(&c->opts, id);
+	const struct bch_option *opt = bch2_opt_table + id;
+	u64 v;
+
+	if (opt->flags & OPT_FS) {
+		v = bch2_opt_get_by_id(&c->opts, id);
+	} else if ((opt->flags & OPT_DEVICE) && opt->get_member)  {
+		v = bch2_opt_from_sb(c->disk_sb.sb, id, ca->dev_idx);
+	} else {
+		return -EINVAL;
+	}
 
 	bch2_opt_to_text(out, c, c->disk_sb.sb, opt, v, OPT_SHOW_FULL_LIST);
 	prt_char(out, '\n');
-
 	return 0;
 }
 
-STORE(bch2_fs_opts_dir)
+static ssize_t sysfs_opt_store(struct bch_fs *c,
+			       struct bch_dev *ca,
+			       enum bch_opt_id id,
+			       const char *buf, size_t size)
 {
-	struct bch_fs *c = container_of(kobj, struct bch_fs, opts_dir);
-	const struct bch_option *opt = container_of(attr, struct bch_option, attr);
-	int ret, id = opt - bch2_opt_table;
-	char *tmp;
-	u64 v;
+	const struct bch_option *opt = bch2_opt_table + id;
+	int ret = 0;
 
 	/*
 	 * We don't need to take c->writes for correctness, but it eliminates an
@@ -627,23 +631,21 @@ STORE(bch2_fs_opts_dir)
 	if (unlikely(!bch2_write_ref_tryget(c, BCH_WRITE_REF_sysfs)))
 		return -EROFS;
 
-	tmp = kstrdup(buf, GFP_KERNEL);
+	char *tmp = kstrdup(buf, GFP_KERNEL);
 	if (!tmp) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	ret = bch2_opt_parse(c, opt, strim(tmp), &v, NULL);
+	u64 v;
+	ret =   bch2_opt_parse(c, opt, strim(tmp), &v, NULL) ?:
+		bch2_opt_check_may_set(c, ca, id, v);
 	kfree(tmp);
 
 	if (ret < 0)
 		goto err;
 
-	ret = bch2_opt_check_may_set(c, id, v);
-	if (ret < 0)
-		goto err;
-
-	bch2_opt_set_sb(c, NULL, opt, v);
+	bch2_opt_set_sb(c, ca, opt, v);
 	bch2_opt_set_by_id(&c->opts, id, v);
 
 	if (v &&
@@ -664,22 +666,41 @@ STORE(bch2_fs_opts_dir)
 	bch2_write_ref_put(c, BCH_WRITE_REF_sysfs);
 	return ret;
 }
+
+SHOW(bch2_fs_opts_dir)
+{
+	struct bch_fs *c = container_of(kobj, struct bch_fs, opts_dir);
+	int id = bch2_opt_lookup(attr->name);
+	if (id < 0)
+		return 0;
+
+	return sysfs_opt_show(c, NULL, id, out);
+}
+
+STORE(bch2_fs_opts_dir)
+{
+	struct bch_fs *c = container_of(kobj, struct bch_fs, opts_dir);
+	int id = bch2_opt_lookup(attr->name);
+	if (id < 0)
+		return 0;
+
+	return sysfs_opt_store(c, NULL, id, buf, size);
+}
 SYSFS_OPS(bch2_fs_opts_dir);
 
 struct attribute *bch2_fs_opts_dir_files[] = { NULL };
 
-int bch2_opts_create_sysfs_files(struct kobject *kobj)
+int bch2_opts_create_sysfs_files(struct kobject *kobj, unsigned type)
 {
-	const struct bch_option *i;
-	int ret;
-
-	for (i = bch2_opt_table;
+	for (const struct bch_option *i = bch2_opt_table;
 	     i < bch2_opt_table + bch2_opts_nr;
 	     i++) {
-		if (!(i->flags & OPT_FS))
+		if (i->flags & OPT_HIDDEN)
+			continue;
+		if (!(i->flags & type))
 			continue;
 
-		ret = sysfs_create_file(kobj, &i->attr);
+		int ret = sysfs_create_file(kobj, &i->attr);
 		if (ret)
 			return ret;
 	}
@@ -750,11 +771,8 @@ SHOW(bch2_dev)
 
 	sysfs_printf(uuid,		"%pU\n", ca->uuid.b);
 
-	sysfs_print(bucket_size,	bucket_bytes(ca));
 	sysfs_print(first_bucket,	ca->mi.first_bucket);
 	sysfs_print(nbuckets,		ca->mi.nbuckets);
-	sysfs_print(durability,		ca->mi.durability);
-	sysfs_print(discard,		ca->mi.discard);
 
 	if (attr == &sysfs_label) {
 		if (ca->mi.group)
@@ -767,11 +785,6 @@ SHOW(bch2_dev)
 		prt_char(out, '\n');
 	}
 
-	if (attr == &sysfs_state) {
-		prt_string_option(out, bch2_member_states, ca->mi.state);
-		prt_char(out, '\n');
-	}
-
 	if (attr == &sysfs_io_done)
 		dev_io_done_to_text(out, ca);
 
@@ -797,6 +810,10 @@ SHOW(bch2_dev)
 	if (attr == &sysfs_open_buckets)
 		bch2_open_buckets_to_text(out, c, ca);
 
+	int opt_id = bch2_opt_lookup(attr->name);
+	if (opt_id >= 0)
+		return sysfs_opt_show(c, ca, opt_id, out);
+
 	return 0;
 }
 
@@ -805,18 +822,6 @@ STORE(bch2_dev)
 	struct bch_dev *ca = container_of(kobj, struct bch_dev, kobj);
 	struct bch_fs *c = ca->fs;
 
-	if (attr == &sysfs_discard) {
-		bool v = strtoul_or_return(buf);
-
-		bch2_opt_set_sb(c, ca, bch2_opt_table + Opt_discard, v);
-	}
-
-	if (attr == &sysfs_durability) {
-		u64 v = strtoul_or_return(buf);
-
-		bch2_opt_set_sb(c, ca, bch2_opt_table + Opt_durability, v);
-	}
-
 	if (attr == &sysfs_label) {
 		char *tmp;
 		int ret;
@@ -834,20 +839,20 @@ STORE(bch2_dev)
 	if (attr == &sysfs_io_errors_reset)
 		bch2_dev_errors_reset(ca);
 
+	int opt_id = bch2_opt_lookup(attr->name);
+	if (opt_id >= 0)
+		return sysfs_opt_store(c, ca, opt_id, buf, size);
+
 	return size;
 }
 SYSFS_OPS(bch2_dev);
 
 struct attribute *bch2_dev_files[] = {
 	&sysfs_uuid,
-	&sysfs_bucket_size,
 	&sysfs_first_bucket,
 	&sysfs_nbuckets,
-	&sysfs_durability,
 
 	/* settings: */
-	&sysfs_discard,
-	&sysfs_state,
 	&sysfs_label,
 
 	&sysfs_has_data,
diff --git a/fs/bcachefs/sysfs.h b/fs/bcachefs/sysfs.h
index 222cd5062702..303e0433c702 100644
--- a/fs/bcachefs/sysfs.h
+++ b/fs/bcachefs/sysfs.h
@@ -23,7 +23,7 @@ extern const struct sysfs_ops bch2_fs_opts_dir_sysfs_ops;
 extern const struct sysfs_ops bch2_fs_time_stats_sysfs_ops;
 extern const struct sysfs_ops bch2_dev_sysfs_ops;
 
-int bch2_opts_create_sysfs_files(struct kobject *);
+int bch2_opts_create_sysfs_files(struct kobject *, unsigned);
 
 #else
 
@@ -41,7 +41,8 @@ static const struct sysfs_ops bch2_fs_opts_dir_sysfs_ops;
 static const struct sysfs_ops bch2_fs_time_stats_sysfs_ops;
 static const struct sysfs_ops bch2_dev_sysfs_ops;
 
-static inline int bch2_opts_create_sysfs_files(struct kobject *kobj) { return 0; }
+static inline int bch2_opts_create_sysfs_files(struct kobject *kobj, unsigned type)
+{ return 0; }
 
 #endif /* NO_BCACHEFS_SYSFS */
 
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index aed7c6984173..f9667b944c0d 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -523,7 +523,7 @@ static int bch2_xattr_bcachefs_set(const struct xattr_handler *handler,
 		if (ret < 0)
 			goto err_class_exit;
 
-		ret = bch2_opt_check_may_set(c, opt_id, v);
+		ret = bch2_opt_check_may_set(c, NULL, opt_id, v);
 		if (ret < 0)
 			goto err_class_exit;
 
-- 
2.49.0

