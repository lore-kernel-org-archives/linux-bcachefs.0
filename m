Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B988226CF7
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Aug 2025 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450464; cv=none; b=JadOoejcaTFDLOwGBdHAvPwqeGycu56TGdnTZ3dD7NKR1bAvalrnrLwpJhj4aXW3GIddGwoNR1/9eS7wr4zWyVtZfLfYJ0bIu8BKtbde9JeIs/BeuetN+YoAq2w20jhcX8Nl5tdihNusl9KUWJBscS33iboHQEYglfXE/QHneNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450464; c=relaxed/simple;
	bh=uBMkocGWru6TA/hbxNcdcGTsOAyURexj7pFil/yeKo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWqzpxtWfD3Y0gVlmZRhY3cGkLWdho6huO587uj9dzoYOxr9roE527HngZt6t28P0i/rpscOr3wVKczVKGtr8bB6dS+TlS83a1U3FgShUK5xrApKWlKOatd2YqBJSRFuJOHpFNZafOBEWAKbdOQHHQ4N33fx6lC7/Uq5X7FfrPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pm3uVXr3; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pm3uVXr3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756450455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQS7krkVlGvlaeKWd1xx3dohxK5KjW8WLoSsToI50vw=;
	b=pm3uVXr3Wrr+K25pMTrPzC4BamrnRDmS6z5qc8YDHGgQQmugr2KK8sdqZLdEDlrK1ljUt2
	VKmUAW+VCVKmE/95HzdKY63k+2NjQav280STtUjDYJj/3qCsBQq0l4t3hcqmOqDIrE1yJs
	0KwlnS0lCcYCgmhjecrKvVZbftGpZ7o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Add v2 ioctls that return error strings
Date: Fri, 29 Aug 2025 02:54:05 -0400
Message-ID: <20250829065409.3248746-2-kent.overstreet@linux.dev>
In-Reply-To: <20250829065409.3248746-1-kent.overstreet@linux.dev>
References: <20250829065409.3248746-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Like BCH_IOCTL_DISK_SET_STATE_v2, implement v2 of other device ioctls
that return error messages via 'struct bch_ioctl_err_msg'.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h |  75 ++++++++++++-----
 fs/bcachefs/chardev.c        | 159 +++++++++++++++++++++++++++++++++--
 2 files changed, 204 insertions(+), 30 deletions(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 08fa1636dde2..5dc562f2a881 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -66,29 +66,35 @@ struct bch_ioctl_incremental {
 #define BCH_IOCTL_STOP		_IO(0xbc,	3)
 #endif
 
-#define BCH_IOCTL_DISK_ADD	_IOW(0xbc,	4,  struct bch_ioctl_disk)
-#define BCH_IOCTL_DISK_REMOVE	_IOW(0xbc,	5,  struct bch_ioctl_disk)
-#define BCH_IOCTL_DISK_ONLINE	_IOW(0xbc,	6,  struct bch_ioctl_disk)
-#define BCH_IOCTL_DISK_OFFLINE	_IOW(0xbc,	7,  struct bch_ioctl_disk)
-#define BCH_IOCTL_DISK_SET_STATE _IOW(0xbc,	8,  struct bch_ioctl_disk_set_state)
-#define BCH_IOCTL_DISK_SET_STATE_v2 _IOW(0xbc,	22,  struct bch_ioctl_disk_set_state_v2)
-#define BCH_IOCTL_DATA		_IOW(0xbc,	10, struct bch_ioctl_data)
-#define BCH_IOCTL_FS_USAGE	_IOWR(0xbc,	11, struct bch_ioctl_fs_usage)
-#define BCH_IOCTL_DEV_USAGE	_IOWR(0xbc,	11, struct bch_ioctl_dev_usage)
-#define BCH_IOCTL_READ_SUPER	_IOW(0xbc,	12, struct bch_ioctl_read_super)
-#define BCH_IOCTL_DISK_GET_IDX	_IOW(0xbc,	13,  struct bch_ioctl_disk_get_idx)
-#define BCH_IOCTL_DISK_RESIZE	_IOW(0xbc,	14,  struct bch_ioctl_disk_resize)
-#define BCH_IOCTL_DISK_RESIZE_JOURNAL _IOW(0xbc,15,  struct bch_ioctl_disk_resize_journal)
-
-#define BCH_IOCTL_SUBVOLUME_CREATE _IOW(0xbc,	16,  struct bch_ioctl_subvolume)
-#define BCH_IOCTL_SUBVOLUME_DESTROY _IOW(0xbc,	17,  struct bch_ioctl_subvolume)
-
-#define BCH_IOCTL_DEV_USAGE_V2	_IOWR(0xbc,	18, struct bch_ioctl_dev_usage_v2)
-
-#define BCH_IOCTL_FSCK_OFFLINE	_IOW(0xbc,	19,  struct bch_ioctl_fsck_offline)
-#define BCH_IOCTL_FSCK_ONLINE	_IOW(0xbc,	20,  struct bch_ioctl_fsck_online)
-#define BCH_IOCTL_QUERY_ACCOUNTING _IOW(0xbc,	21,  struct bch_ioctl_query_accounting)
-#define BCH_IOCTL_QUERY_COUNTERS _IOW(0xbc,	21,  struct bch_ioctl_query_counters)
+#define BCH_IOCTL_DISK_ADD		_IOW(0xbc,	4,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_ADD_v2		_IOW(0xbc,	23, struct bch_ioctl_disk_v2)
+#define BCH_IOCTL_DISK_REMOVE		_IOW(0xbc,	5,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_REMOVE_v2	_IOW(0xbc,	24, struct bch_ioctl_disk_v2)
+#define BCH_IOCTL_DISK_ONLINE		_IOW(0xbc,	6,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_ONLINE_v2	_IOW(0xbc,	25, struct bch_ioctl_disk_v2)
+#define BCH_IOCTL_DISK_OFFLINE		_IOW(0xbc,	7,  struct bch_ioctl_disk)
+#define BCH_IOCTL_DISK_OFFLINE_v2	_IOW(0xbc,	26, struct bch_ioctl_disk_v2)
+#define BCH_IOCTL_DISK_SET_STATE	_IOW(0xbc,	8,  struct bch_ioctl_disk_set_state)
+#define BCH_IOCTL_DISK_SET_STATE_v2	_IOW(0xbc,	22, struct bch_ioctl_disk_set_state_v2)
+#define BCH_IOCTL_DATA			_IOW(0xbc,	10, struct bch_ioctl_data)
+#define BCH_IOCTL_FS_USAGE		_IOWR(0xbc,	11, struct bch_ioctl_fs_usage)
+#define BCH_IOCTL_DEV_USAGE		_IOWR(0xbc,	11, struct bch_ioctl_dev_usage)
+#define BCH_IOCTL_READ_SUPER		_IOW(0xbc,	12, struct bch_ioctl_read_super)
+#define BCH_IOCTL_DISK_GET_IDX		_IOW(0xbc,	13, struct bch_ioctl_disk_get_idx)
+#define BCH_IOCTL_DISK_RESIZE		_IOW(0xbc,	14, struct bch_ioctl_disk_resize)
+#define BCH_IOCTL_DISK_RESIZE_v2	_IOW(0xbc,	27, struct bch_ioctl_disk_resize_v2)
+#define BCH_IOCTL_DISK_RESIZE_JOURNAL	_IOW(0xbc,	15, struct bch_ioctl_disk_resize_journal)
+#define BCH_IOCTL_DISK_RESIZE_JOURNAL_v2 _IOW(0xbc,	28, struct bch_ioctl_disk_resize_journal_v2)
+
+#define BCH_IOCTL_SUBVOLUME_CREATE	_IOW(0xbc,	16, struct bch_ioctl_subvolume)
+#define BCH_IOCTL_SUBVOLUME_DESTROY	_IOW(0xbc,	17, struct bch_ioctl_subvolume)
+
+#define BCH_IOCTL_DEV_USAGE_V2		_IOWR(0xbc,	18, struct bch_ioctl_dev_usage_v2)
+
+#define BCH_IOCTL_FSCK_OFFLINE		_IOW(0xbc,	19, struct bch_ioctl_fsck_offline)
+#define BCH_IOCTL_FSCK_ONLINE		_IOW(0xbc,	20, struct bch_ioctl_fsck_online)
+#define BCH_IOCTL_QUERY_ACCOUNTING	_IOW(0xbc,	21, struct bch_ioctl_query_accounting)
+#define BCH_IOCTL_QUERY_COUNTERS	_IOW(0xbc,	21, struct bch_ioctl_query_counters)
 
 /* ioctl below act on a particular file, not the filesystem as a whole: */
 
@@ -164,6 +170,13 @@ struct bch_ioctl_disk {
 	__u64			dev;
 };
 
+struct bch_ioctl_disk_v2 {
+	__u32				flags;
+	__u32				pad;
+	__u64				dev;
+	struct bch_ioctl_err_msg	err;
+};
+
 /*
  * BCH_IOCTL_DISK_SET_STATE: modify state of a member device of a filesystem
  *
@@ -400,6 +413,14 @@ struct bch_ioctl_disk_resize {
 	__u64			nbuckets;
 };
 
+struct bch_ioctl_disk_resize_v2 {
+	__u32				flags;
+	__u32				pad;
+	__u64				dev;
+	__u64				nbuckets;
+	struct bch_ioctl_err_msg	err;
+};
+
 /*
  * BCH_IOCTL_DISK_RESIZE_JOURNAL: resize journal on a device
  *
@@ -413,6 +434,14 @@ struct bch_ioctl_disk_resize_journal {
 	__u64			nbuckets;
 };
 
+struct bch_ioctl_disk_resize_journal_v2 {
+	__u32				flags;
+	__u32				pad;
+	__u64				dev;
+	__u64				nbuckets;
+	struct bch_ioctl_err_msg	err;
+};
+
 struct bch_ioctl_subvolume {
 	__u32			flags;
 	__u32			dirfd;
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 2370c15e28b6..f6f90d421f27 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -187,6 +187,18 @@ static long bch2_ioctl_stop(struct bch_fs *c)
 }
 #endif
 
+static int copy_ioctl_err_msg(struct bch_ioctl_err_msg *dst, struct printbuf *src, int ret)
+{
+	if (ret) {
+		prt_printf(src, "error=%s", bch2_err_str(ret));
+		ret = copy_to_user_errcode((void __user *)(ulong)dst->msg_ptr,
+					   src->buf,
+					   min(src->pos, dst->msg_len)) ?: ret;
+	}
+
+	return ret;
+}
+
 static long bch2_ioctl_disk_add(struct bch_fs *c, struct bch_ioctl_disk arg)
 {
 	char *path;
@@ -212,6 +224,28 @@ static long bch2_ioctl_disk_add(struct bch_fs *c, struct bch_ioctl_disk arg)
 	return ret;
 }
 
+static long bch2_ioctl_disk_add_v2(struct bch_fs *c, struct bch_ioctl_disk_v2 arg)
+{
+	char *path = NULL;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (arg.flags || arg.pad)
+		return -EINVAL;
+
+	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
+	ret = PTR_ERR_OR_ZERO(path);
+	if (ret)
+		return ret;
+
+	CLASS(printbuf, err)();
+	ret = bch2_dev_add(c, path, &err);
+	kfree(path);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 static long bch2_ioctl_disk_remove(struct bch_fs *c, struct bch_ioctl_disk arg)
 {
 	if (!capable(CAP_SYS_ADMIN))
@@ -235,6 +269,27 @@ static long bch2_ioctl_disk_remove(struct bch_fs *c, struct bch_ioctl_disk arg)
 	return ret;
 }
 
+static long bch2_ioctl_disk_remove_v2(struct bch_fs *c, struct bch_ioctl_disk_v2 arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if ((arg.flags & ~(BCH_FORCE_IF_DATA_LOST|
+			   BCH_FORCE_IF_METADATA_LOST|
+			   BCH_FORCE_IF_DEGRADED|
+			   BCH_BY_INDEX)) ||
+	    arg.pad)
+		return -EINVAL;
+
+	struct bch_dev *ca = bch2_device_lookup(c, arg.dev, arg.flags);
+	if (IS_ERR(ca))
+		return PTR_ERR(ca);
+
+	CLASS(printbuf, err)();
+	int ret = bch2_dev_remove(c, ca, arg.flags, &err);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 static long bch2_ioctl_disk_online(struct bch_fs *c, struct bch_ioctl_disk arg)
 {
 	char *path;
@@ -259,6 +314,28 @@ static long bch2_ioctl_disk_online(struct bch_fs *c, struct bch_ioctl_disk arg)
 	return ret;
 }
 
+static long bch2_ioctl_disk_online_v2(struct bch_fs *c, struct bch_ioctl_disk_v2 arg)
+{
+	char *path;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (arg.flags || arg.pad)
+		return -EINVAL;
+
+	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
+	ret = PTR_ERR_OR_ZERO(path);
+	if (ret)
+		return ret;
+
+	CLASS(printbuf, err)();
+	ret = bch2_dev_online(c, path, &err);
+	kfree(path);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 static long bch2_ioctl_disk_offline(struct bch_fs *c, struct bch_ioctl_disk arg)
 {
 	if (!capable(CAP_SYS_ADMIN))
@@ -282,6 +359,27 @@ static long bch2_ioctl_disk_offline(struct bch_fs *c, struct bch_ioctl_disk arg)
 	return ret;
 }
 
+static long bch2_ioctl_disk_offline_v2(struct bch_fs *c, struct bch_ioctl_disk_v2 arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if ((arg.flags & ~(BCH_FORCE_IF_DATA_LOST|
+			   BCH_FORCE_IF_METADATA_LOST|
+			   BCH_FORCE_IF_DEGRADED|
+			   BCH_BY_INDEX)) ||
+	    arg.pad)
+		return -EINVAL;
+
+	CLASS(bch2_device_lookup, ca)(c, arg.dev, arg.flags);
+	if (IS_ERR(ca))
+		return PTR_ERR(ca);
+
+	CLASS(printbuf, err)();
+	int ret = bch2_dev_offline(c, ca, arg.flags, &err);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 static long bch2_ioctl_disk_set_state(struct bch_fs *c,
 			struct bch_ioctl_disk_set_state arg)
 {
@@ -331,13 +429,7 @@ static long bch2_ioctl_disk_set_state_v2(struct bch_fs *c,
 
 	ret = bch2_dev_set_state(c, ca, arg.new_state, arg.flags, &err);
 err:
-	if (ret) {
-		prt_printf(&err, "error=%s", bch2_err_str(ret));
-		ret = copy_to_user_errcode((void __user *)(ulong)arg.err.msg_ptr,
-					   err.buf,
-					   min(err.pos, arg.err.msg_len)) ?: ret;
-	}
-	return ret;
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 struct bch_data_ctx {
@@ -675,6 +767,25 @@ static long bch2_ioctl_disk_resize(struct bch_fs *c,
 	return ret;
 }
 
+static long bch2_ioctl_disk_resize_v2(struct bch_fs *c,
+				      struct bch_ioctl_disk_resize_v2 arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if ((arg.flags & ~BCH_BY_INDEX) ||
+	    arg.pad)
+		return -EINVAL;
+
+	CLASS(bch2_device_lookup, ca)(c, arg.dev, arg.flags);
+	if (IS_ERR(ca))
+		return PTR_ERR(ca);
+
+	CLASS(printbuf, err)();
+	int ret = bch2_dev_resize(c, ca, arg.nbuckets, &err);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
 				   struct bch_ioctl_disk_resize_journal arg)
 {
@@ -695,6 +806,28 @@ static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
 	return bch2_set_nr_journal_buckets(c, ca, arg.nbuckets);
 }
 
+static long bch2_ioctl_disk_resize_journal_v2(struct bch_fs *c,
+				   struct bch_ioctl_disk_resize_journal_v2 arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if ((arg.flags & ~BCH_BY_INDEX) ||
+	    arg.pad)
+		return -EINVAL;
+
+	if (arg.nbuckets > U32_MAX)
+		return -EINVAL;
+
+	CLASS(bch2_device_lookup, ca)(c, arg.dev, arg.flags);
+	if (IS_ERR(ca))
+		return PTR_ERR(ca);
+
+	CLASS(printbuf, err)();
+	int ret = bch2_set_nr_journal_buckets(c, ca, arg.nbuckets);
+	return copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 #define BCH_IOCTL(_name, _argtype)					\
 do {									\
 	_argtype i;							\
@@ -736,12 +869,20 @@ long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
 	switch (cmd) {
 	case BCH_IOCTL_DISK_ADD:
 		BCH_IOCTL(disk_add, struct bch_ioctl_disk);
+	case BCH_IOCTL_DISK_ADD_v2:
+		BCH_IOCTL(disk_add_v2, struct bch_ioctl_disk_v2);
 	case BCH_IOCTL_DISK_REMOVE:
 		BCH_IOCTL(disk_remove, struct bch_ioctl_disk);
+	case BCH_IOCTL_DISK_REMOVE_v2:
+		BCH_IOCTL(disk_remove_v2, struct bch_ioctl_disk_v2);
 	case BCH_IOCTL_DISK_ONLINE:
 		BCH_IOCTL(disk_online, struct bch_ioctl_disk);
+	case BCH_IOCTL_DISK_ONLINE_v2:
+		BCH_IOCTL(disk_online_v2, struct bch_ioctl_disk_v2);
 	case BCH_IOCTL_DISK_OFFLINE:
 		BCH_IOCTL(disk_offline, struct bch_ioctl_disk);
+	case BCH_IOCTL_DISK_OFFLINE_v2:
+		BCH_IOCTL(disk_offline_v2, struct bch_ioctl_disk_v2);
 	case BCH_IOCTL_DISK_SET_STATE:
 		BCH_IOCTL(disk_set_state, struct bch_ioctl_disk_set_state);
 	case BCH_IOCTL_DISK_SET_STATE_v2:
@@ -750,8 +891,12 @@ long bch2_fs_ioctl(struct bch_fs *c, unsigned cmd, void __user *arg)
 		BCH_IOCTL(data, struct bch_ioctl_data);
 	case BCH_IOCTL_DISK_RESIZE:
 		BCH_IOCTL(disk_resize, struct bch_ioctl_disk_resize);
+	case BCH_IOCTL_DISK_RESIZE_v2:
+		BCH_IOCTL(disk_resize_v2, struct bch_ioctl_disk_resize_v2);
 	case BCH_IOCTL_DISK_RESIZE_JOURNAL:
 		BCH_IOCTL(disk_resize_journal, struct bch_ioctl_disk_resize_journal);
+	case BCH_IOCTL_DISK_RESIZE_JOURNAL_v2:
+		BCH_IOCTL(disk_resize_journal_v2, struct bch_ioctl_disk_resize_journal_v2);
 	case BCH_IOCTL_FSCK_ONLINE:
 		BCH_IOCTL(fsck_online, struct bch_ioctl_fsck_online);
 	case BCH_IOCTL_QUERY_ACCOUNTING:
-- 
2.50.1

