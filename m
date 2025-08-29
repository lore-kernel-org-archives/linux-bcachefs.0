Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB38825F997
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Aug 2025 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450462; cv=none; b=KNPg3yW+7Vk8Ev84pPdp4ngP/kRCY8YqgZ2OGyWCzTYYY8hZMVc2s1IdWPRl9NrOAEdSJ1j8khPS+takcMoQEbzU6PYwp8PHZ7YtzHD7FMrZO9CTC7YBfnsRY58h/2SOVKRJh0keCuWoPC3yiZq/xv7qepdxYvCLPAe3e1B52l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450462; c=relaxed/simple;
	bh=M380CQ+UmOwOyJo/zbbfWF6pFEh/sxK02qXDX4ZTNbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+nVsxA5ruEdQWsWJ6uPohmCq4GJ+Lvihf3mPmz8P+ACMEIKOBE+0DfpqX+zGqhc9A9QJi9jT/Oscq7crXWY4x+tikdbzTqN9hIuxZN2C0CiVRVCmJh/7MPvfbS1j0GyMrnt54scyuhCwU1URh7A40Tp0S9r93Hi3buYPIJMsUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PrAjFlV0; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PrAjFlV0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756450456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u29N3Wt7hqocAxX+/xPeziqTs0DKfggWFzGfDGA4Ux0=;
	b=PrAjFlV04axYNHHeHQ0yr3fcCzxy7yaBzvlYZ28Z4woHMMuV3wrFoCJzQjEZKylUCTB0F5
	MecQU8lY/+XuE7O7L1FkqoAxNVCY5rgyNgT7xCcNFRWUNrG6X4rGC18922tZ/Kf2UxnFDx
	PYOA2QF2knMtKpLOJzNYuT+6OJ47/dI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: v2 versions of subvolume ioctls
Date: Fri, 29 Aug 2025 02:54:06 -0400
Message-ID: <20250829065409.3248746-3-kent.overstreet@linux.dev>
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

Like we recently did for the device ioctl, add v2 versions that can
return error strings.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h | 12 +++++
 fs/bcachefs/chardev.c        | 16 +++----
 fs/bcachefs/chardev.h        |  3 ++
 fs/bcachefs/fs-ioctl.c       | 91 +++++++++++++++++++++++++++++++++---
 4 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 5dc562f2a881..6043a8d93b1e 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -87,7 +87,9 @@ struct bch_ioctl_incremental {
 #define BCH_IOCTL_DISK_RESIZE_JOURNAL_v2 _IOW(0xbc,	28, struct bch_ioctl_disk_resize_journal_v2)
 
 #define BCH_IOCTL_SUBVOLUME_CREATE	_IOW(0xbc,	16, struct bch_ioctl_subvolume)
+#define BCH_IOCTL_SUBVOLUME_CREATE_v2	_IOW(0xbc,	29, struct bch_ioctl_subvolume_v2)
 #define BCH_IOCTL_SUBVOLUME_DESTROY	_IOW(0xbc,	17, struct bch_ioctl_subvolume)
+#define BCH_IOCTL_SUBVOLUME_DESTROY_v2	_IOW(0xbc,	30, struct bch_ioctl_subvolume_v2)
 
 #define BCH_IOCTL_DEV_USAGE_V2		_IOWR(0xbc,	18, struct bch_ioctl_dev_usage_v2)
 
@@ -451,6 +453,16 @@ struct bch_ioctl_subvolume {
 	__u64			src_ptr;
 };
 
+struct bch_ioctl_subvolume_v2 {
+	__u32			flags;
+	__u32			dirfd;
+	__u16			mode;
+	__u16			pad[3];
+	__u64			dst_ptr;
+	__u64			src_ptr;
+	struct bch_ioctl_err_msg	err;
+};
+
 #define BCH_SUBVOL_SNAPSHOT_CREATE	(1U << 0)
 #define BCH_SUBVOL_SNAPSHOT_RO		(1U << 1)
 
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index f6f90d421f27..108c362a0ff4 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -187,7 +187,7 @@ static long bch2_ioctl_stop(struct bch_fs *c)
 }
 #endif
 
-static int copy_ioctl_err_msg(struct bch_ioctl_err_msg *dst, struct printbuf *src, int ret)
+int bch2_copy_ioctl_err_msg(struct bch_ioctl_err_msg *dst, struct printbuf *src, int ret)
 {
 	if (ret) {
 		prt_printf(src, "error=%s", bch2_err_str(ret));
@@ -243,7 +243,7 @@ static long bch2_ioctl_disk_add_v2(struct bch_fs *c, struct bch_ioctl_disk_v2 ar
 	CLASS(printbuf, err)();
 	ret = bch2_dev_add(c, path, &err);
 	kfree(path);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 static long bch2_ioctl_disk_remove(struct bch_fs *c, struct bch_ioctl_disk arg)
@@ -287,7 +287,7 @@ static long bch2_ioctl_disk_remove_v2(struct bch_fs *c, struct bch_ioctl_disk_v2
 
 	CLASS(printbuf, err)();
 	int ret = bch2_dev_remove(c, ca, arg.flags, &err);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 static long bch2_ioctl_disk_online(struct bch_fs *c, struct bch_ioctl_disk arg)
@@ -333,7 +333,7 @@ static long bch2_ioctl_disk_online_v2(struct bch_fs *c, struct bch_ioctl_disk_v2
 	CLASS(printbuf, err)();
 	ret = bch2_dev_online(c, path, &err);
 	kfree(path);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 static long bch2_ioctl_disk_offline(struct bch_fs *c, struct bch_ioctl_disk arg)
@@ -377,7 +377,7 @@ static long bch2_ioctl_disk_offline_v2(struct bch_fs *c, struct bch_ioctl_disk_v
 
 	CLASS(printbuf, err)();
 	int ret = bch2_dev_offline(c, ca, arg.flags, &err);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 static long bch2_ioctl_disk_set_state(struct bch_fs *c,
@@ -429,7 +429,7 @@ static long bch2_ioctl_disk_set_state_v2(struct bch_fs *c,
 
 	ret = bch2_dev_set_state(c, ca, arg.new_state, arg.flags, &err);
 err:
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 struct bch_data_ctx {
@@ -783,7 +783,7 @@ static long bch2_ioctl_disk_resize_v2(struct bch_fs *c,
 
 	CLASS(printbuf, err)();
 	int ret = bch2_dev_resize(c, ca, arg.nbuckets, &err);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 static long bch2_ioctl_disk_resize_journal(struct bch_fs *c,
@@ -825,7 +825,7 @@ static long bch2_ioctl_disk_resize_journal_v2(struct bch_fs *c,
 
 	CLASS(printbuf, err)();
 	int ret = bch2_set_nr_journal_buckets(c, ca, arg.nbuckets);
-	return copy_ioctl_err_msg(&arg.err, &err, ret);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
 }
 
 #define BCH_IOCTL(_name, _argtype)					\
diff --git a/fs/bcachefs/chardev.h b/fs/bcachefs/chardev.h
index 0f563ca53c36..cdd63e7618e9 100644
--- a/fs/bcachefs/chardev.h
+++ b/fs/bcachefs/chardev.h
@@ -4,6 +4,9 @@
 
 #ifndef NO_BCACHEFS_FS
 
+struct printbuf;
+int bch2_copy_ioctl_err_msg(struct bch_ioctl_err_msg *, struct printbuf *, int);
+
 long bch2_fs_ioctl(struct bch_fs *, unsigned, void __user *);
 
 void bch2_fs_chardev_exit(struct bch_fs *);
diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 8b9d3c7d1f57..20b46126c066 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -199,8 +199,9 @@ static int bch2_ioc_goingdown(struct bch_fs *c, u32 __user *arg)
 	return ret;
 }
 
-static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
-					struct bch_ioctl_subvolume arg)
+static long __bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
+					  struct bch_ioctl_subvolume_v2 arg,
+					  struct printbuf *err)
 {
 	struct inode *dir;
 	struct bch_inode_info *inode;
@@ -214,13 +215,17 @@ static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
 	unsigned create_flags = BCH_CREATE_SUBVOL;
 
 	if (arg.flags & ~(BCH_SUBVOL_SNAPSHOT_CREATE|
-			  BCH_SUBVOL_SNAPSHOT_RO))
+			  BCH_SUBVOL_SNAPSHOT_RO)) {
+		prt_str(err, "invalid flasg");
 		return -EINVAL;
+	}
 
 	if (!(arg.flags & BCH_SUBVOL_SNAPSHOT_CREATE) &&
 	    (arg.src_ptr ||
-	     (arg.flags & BCH_SUBVOL_SNAPSHOT_RO)))
+	     (arg.flags & BCH_SUBVOL_SNAPSHOT_RO))) {
+		prt_str(err, "invalid flasg");
 		return -EINVAL;
+	}
 
 	if (arg.flags & BCH_SUBVOL_SNAPSHOT_CREATE)
 		create_flags |= BCH_CREATE_SNAPSHOT;
@@ -243,6 +248,7 @@ static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
 
 		if (src_path.dentry->d_sb->s_fs_info != c) {
 			path_put(&src_path);
+			prt_str(err, "src_path not on dst filesystem");
 			error = -EXDEV;
 			goto err1;
 		}
@@ -258,6 +264,7 @@ static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
 		goto err2;
 
 	if (dst_dentry->d_sb->s_fs_info != c) {
+		prt_str(err, "dst_path not on dst filesystem");
 		error = -EXDEV;
 		goto err3;
 	}
@@ -276,6 +283,7 @@ static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
 	s_user_ns = dir->i_sb->s_user_ns;
 	if (!kuid_has_mapping(s_user_ns, current_fsuid()) ||
 	    !kgid_has_mapping(s_user_ns, current_fsgid())) {
+		prt_str(err, "current uid/gid not mapped into fs namespace");
 		error = -EOVERFLOW;
 		goto err3;
 	}
@@ -315,8 +323,35 @@ static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
 	return error;
 }
 
-static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
-				struct bch_ioctl_subvolume arg)
+static long bch2_ioctl_subvolume_create(struct bch_fs *c, struct file *filp,
+					struct bch_ioctl_subvolume arg)
+{
+	struct bch_ioctl_subvolume_v2 arg_v2 = {
+		.flags		= arg.flags,
+		.dirfd		= arg.dirfd,
+		.mode		= arg.mode,
+		.dst_ptr	= arg.dst_ptr,
+		.src_ptr	= arg.src_ptr,
+	};
+
+	CLASS(printbuf, err)();
+	long ret = __bch2_ioctl_subvolume_create(c, filp, arg_v2, &err);
+	if (ret)
+		bch_err_msg(c, ret, "%s", err.buf);
+	return ret;
+}
+
+static long bch2_ioctl_subvolume_create_v2(struct bch_fs *c, struct file *filp,
+					   struct bch_ioctl_subvolume_v2 arg)
+{
+	CLASS(printbuf, err)();
+	long ret = __bch2_ioctl_subvolume_create(c, filp, arg, &err);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
+static long __bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
+					   struct bch_ioctl_subvolume_v2 arg,
+					   struct printbuf *err)
 {
 	const char __user *name = (void __user *)(unsigned long)arg.dst_ptr;
 	struct path path;
@@ -350,6 +385,32 @@ static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
 	return ret;
 }
 
+static long bch2_ioctl_subvolume_destroy(struct bch_fs *c, struct file *filp,
+					 struct bch_ioctl_subvolume arg)
+{
+	struct bch_ioctl_subvolume_v2 arg_v2 = {
+		.flags		= arg.flags,
+		.dirfd		= arg.dirfd,
+		.mode		= arg.mode,
+		.dst_ptr	= arg.dst_ptr,
+		.src_ptr	= arg.src_ptr,
+	};
+
+	CLASS(printbuf, err)();
+	long ret = __bch2_ioctl_subvolume_destroy(c, filp, arg_v2, &err);
+	if (ret)
+		bch_err_msg(c, ret, "%s", err.buf);
+	return ret;
+}
+
+static long bch2_ioctl_subvolume_destroy_v2(struct bch_fs *c, struct file *filp,
+					    struct bch_ioctl_subvolume_v2 arg)
+{
+	CLASS(printbuf, err)();
+	long ret = __bch2_ioctl_subvolume_destroy(c, filp, arg, &err);
+	return bch2_copy_ioctl_err_msg(&arg.err, &err, ret);
+}
+
 long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
 	struct bch_inode_info *inode = file_bch_inode(file);
@@ -391,6 +452,15 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
+	case BCH_IOCTL_SUBVOLUME_CREATE_v2: {
+		struct bch_ioctl_subvolume_v2 i;
+
+		ret = copy_from_user(&i, (void __user *) arg, sizeof(i))
+			? -EFAULT
+			: bch2_ioctl_subvolume_create_v2(c, file, i);
+		break;
+	}
+
 	case BCH_IOCTL_SUBVOLUME_DESTROY: {
 		struct bch_ioctl_subvolume i;
 
@@ -400,6 +470,15 @@ long bch2_fs_file_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		break;
 	}
 
+	case BCH_IOCTL_SUBVOLUME_DESTROY_v2: {
+		struct bch_ioctl_subvolume_v2 i;
+
+		ret = copy_from_user(&i, (void __user *) arg, sizeof(i))
+			? -EFAULT
+			: bch2_ioctl_subvolume_destroy_v2(c, file, i);
+		break;
+	}
+
 	default:
 		ret = bch2_fs_ioctl(c, cmd, (void __user *) arg);
 		break;
-- 
2.50.1

