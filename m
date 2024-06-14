Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F29049638
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718390825; cv=none; b=KLj1a9pHG8kt780A/XQA+Advc3ud6f966Xyua+zWH+KWSGUC5hpMugb94HoyDHkDzF460mm0g8QPUibiMcj8EGmA9XWMjjzaDNmu9qeemO/CZAXnxeiqThDL25fb9gRooitH69ZZLmTnSjbtd3J/nUioWXzmzmSkC5mbe/kNCj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718390825; c=relaxed/simple;
	bh=IqiE30DC3HWyQ5izUGyYaISSaCk37IQ9Dzw3KnSK85c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QN2q2zLZO9ChYGx8/EbTLZ/9kJWSwuSizbJuGioL0jfVgTgjUlMT/Nc9rkwppqoiRtV0MvLfHyPgZkdea86Ys3+qgN564FS2yTLuABqScsbg9o0+gql2IN558cstBbBnt7JDeimKdS/GMhqxr3KwRgDDxqY3dfKwAz1RdDTUqAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHg4EEz6; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHg4EEz6"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a68b41ef3f6so290249266b.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Jun 2024 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718390820; x=1718995620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EU1eVmJEq4sGh5e2qBEn+IFbGR0pRJFjvh3itDapAOA=;
        b=eHg4EEz6Ug/Z6R8H0i/yfnpolgv1bJO2k4LVzFiDJ/PQKcRbzlV5mk34YNUA9i218S
         G0jqRmdECBt2VkEUYxasU3WQ4OQglBbEfQC4ZiiiJkBUTrblrvhMd4PoYRGB11F5zair
         kk8acIL5iNBqcarz7F0d09Sa4IWFeG+l/v/uS9ortV9C9YmySuTFbWq1oxFVJuN5s3zv
         JpktDf42LIGmwAnh6tmdYn2I4h/uWzYxmB5gUAg5Muz0CzhJ9H3fHx8lu4K5KtX2jE3w
         okAguwZC5gFaNVhBawTNFRF3xWZej25NxUSKrYSjDx+mdyV9/i5bFWGzUTFERVqQBC9v
         kNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718390820; x=1718995620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EU1eVmJEq4sGh5e2qBEn+IFbGR0pRJFjvh3itDapAOA=;
        b=IR6YGfAeDiX/1voFIIYPclnxVuj9qoU4zBoDq4iLEaHx9fZyJnLrXOcmrSGCsD5gwa
         w3lQcsxLvs0VYwfjAljzMSJuJTKgIheAzyRVeSlIHnsTulHLIVMHCRO3Cz57km9GH8Cy
         3au8JM+ubsVsYIlCOt0XEYw8+n6wUoAIIEBtOdhGoB1OvsKWXcKauMmN1m2iw0YJlVnU
         3BcIO17WoIqBpyOjEbbnoiX61s82dYvI2giQ7tGL26sybMb9KaOJIc+Gpq+qeOfxEh0T
         VUozRSyZmTEtMoIRw8DCq+0iZ+7vEkg9FCn5//7TGNjWAM0UwqBUX6PGZj1SovbWiwSO
         zOgw==
X-Gm-Message-State: AOJu0YzZc5TWpEBBsWQ1lOnwhD7Qj7l2o7PGLlm9TH+iE7L/KDcrftG8
	Sv/m/44hPT8f4OHL5Ps6ZR/CTJ27dEqgfztqwD10Kl6Jl6RiHac2uCRfDLJA
X-Google-Smtp-Source: AGHT+IH7YKGGwyuRRHCBFCBg/WLy1U3+XiaGKW+b0e/tZx9/E/8FHpft7tXxhSQRB6PoQpi19xgjNg==
X-Received: by 2002:a17:906:34d9:b0:a6f:15a3:b085 with SMTP id a640c23a62f3a-a6f60dc5539mr212246866b.51.1718390819611;
        Fri, 14 Jun 2024 11:46:59 -0700 (PDT)
Received: from localhost ([2a02:2f0e:615:a300:e591:7f5f:c9d3:c3f5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed369bsm209782666b.100.2024.06.14.11.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 11:46:59 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH v2 1/4] bcachefs: allow initializing a bcachefs filesystem from a source directory
Date: Fri, 14 Jun 2024 21:46:50 +0300
Message-Id: <20240614184653.276043-1-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new source command line argument which specifies the directory
tree that will be copied onto the newly formatted bcachefs filesystem.

This commit also fixes an issue in copy_link where uninitialized data is
copied into the symlink because of a round_up of the buffer size.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/cmd_format.c        |  29 +++
 c_src/cmd_migrate.c       | 472 +-------------------------------------
 c_src/libbcachefs.h       |   2 +
 c_src/posix_to_bcachefs.c | 460 +++++++++++++++++++++++++++++++++++++
 c_src/posix_to_bcachefs.h |  54 +++++
 libbcachefs/bkey.h        |   1 +
 libbcachefs/fs-common.h   |   1 +
 libbcachefs/inode.h       |   1 +
 8 files changed, 557 insertions(+), 463 deletions(-)
 create mode 100644 c_src/posix_to_bcachefs.c
 create mode 100644 c_src/posix_to_bcachefs.h

diff --git a/c_src/cmd_format.c b/c_src/cmd_format.c
index 4bafa171..d0c8e197 100644
--- a/c_src/cmd_format.c
+++ b/c_src/cmd_format.c
@@ -21,6 +21,7 @@
 #include <uuid/uuid.h>
 
 #include "cmds.h"
+#include "posix_to_bcachefs.h"
 #include "libbcachefs.h"
 #include "crypto.h"
 #include "libbcachefs/errcode.h"
@@ -45,6 +46,7 @@ x(0,	data_allowed,		required_argument)	\
 x(0,	durability,		required_argument)	\
 x(0,	version,		required_argument)	\
 x(0,	no_initialize,		no_argument)		\
+x(0,	source,			required_argument)	\
 x('f',	force,			no_argument)		\
 x('q',	quiet,			no_argument)		\
 x('v',	verbose,		no_argument)		\
@@ -66,6 +68,7 @@ static void usage(void)
 	     "  -L, --fs_label=label\n"
 	     "  -U, --uuid=uuid\n"
 	     "      --superblock_size=size\n"
+	     "      --source=path           Initialize the bcachefs filesystem from this root directory\n"
 	     "\n"
 	     "Device specific options:");
 
@@ -113,6 +116,18 @@ u64 read_flag_list_or_die(char *opt, const char * const list[],
 	return v;
 }
 
+void build_fs(struct bch_fs *c, const char *src_path)
+{
+	struct copy_fs_state s = {};
+	int src_fd = xopen(src_path, O_RDONLY|O_NOATIME);
+	struct stat stat = xfstat(src_fd);
+
+	if (!S_ISDIR(stat.st_mode))
+		die("%s is not a directory", src_path);
+
+	copy_fs(c, src_fd, src_path, &s);
+}
+
 int cmd_format(int argc, char *argv[])
 {
 	DARRAY(struct dev_opts) devices = { 0 };
@@ -145,6 +160,9 @@ int cmd_format(int argc, char *argv[])
 			opt_set(fs_opts, metadata_replicas, v);
 			opt_set(fs_opts, data_replicas, v);
 			break;
+		case O_source:
+			opts.source = optarg;
+			break;
 		case O_encrypted:
 			opts.encrypted = true;
 			break;
@@ -277,6 +295,12 @@ int cmd_format(int argc, char *argv[])
 
 	darray_exit(&devices);
 
+	/* don't skip initialization when we have to build an image from a source */
+	if (opts.source && !initialize) {
+		printf("Warning: Forcing the initialization because the source flag was supplied\n");
+		initialize = 1;
+	}
+
 	if (initialize) {
 		struct bch_opts mount_opts = bch2_opts_empty();
 
@@ -294,6 +318,11 @@ int cmd_format(int argc, char *argv[])
 			die("error opening %s: %s", device_paths.data[0],
 			    bch2_err_str(PTR_ERR(c)));
 
+		if (opts.source) {
+			build_fs(c, opts.source);
+		}
+
+
 		bch2_fs_stop(c);
 	}
 
diff --git a/c_src/cmd_migrate.c b/c_src/cmd_migrate.c
index 24937822..a5b7786d 100644
--- a/c_src/cmd_migrate.c
+++ b/c_src/cmd_migrate.c
@@ -1,9 +1,7 @@
-#include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <getopt.h>
 #include <string.h>
-#include <sys/xattr.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
@@ -20,24 +18,18 @@
 #include "cmds.h"
 #include "crypto.h"
 #include "libbcachefs.h"
+#include "posix_to_bcachefs.h"
 
 #include <linux/dcache.h>
 #include <linux/generic-radix-tree.h>
-#include <linux/xattr.h>
 #include "libbcachefs/bcachefs.h"
-#include "libbcachefs/alloc_background.h"
-#include "libbcachefs/alloc_foreground.h"
 #include "libbcachefs/btree_update.h"
 #include "libbcachefs/buckets.h"
 #include "libbcachefs/dirent.h"
 #include "libbcachefs/errcode.h"
-#include "libbcachefs/fs-common.h"
 #include "libbcachefs/inode.h"
-#include "libbcachefs/io_write.h"
 #include "libbcachefs/replicas.h"
-#include "libbcachefs/str_hash.h"
 #include "libbcachefs/super.h"
-#include "libbcachefs/xattr.h"
 
 /* XXX cut and pasted from fsck.c */
 #define QSTR(n) { { { .len = strlen(n) } }, .name = n }
@@ -117,403 +109,6 @@ static void mark_unreserved_space(struct bch_fs *c, ranges extents)
 	}
 }
 
-static void update_inode(struct bch_fs *c,
-			 struct bch_inode_unpacked *inode)
-{
-	struct bkey_inode_buf packed;
-	int ret;
-
-	bch2_inode_pack(&packed, inode);
-	packed.inode.k.p.snapshot = U32_MAX;
-	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed.inode.k_i,
-				NULL, 0, 0);
-	if (ret)
-		die("error updating inode: %s", bch2_err_str(ret));
-}
-
-static void create_link(struct bch_fs *c,
-			struct bch_inode_unpacked *parent,
-			const char *name, u64 inum, mode_t mode)
-{
-	struct qstr qstr = QSTR(name);
-	struct bch_inode_unpacked parent_u;
-	struct bch_inode_unpacked inode;
-
-	int ret = bch2_trans_do(c, NULL, NULL, 0,
-		bch2_link_trans(trans,
-				(subvol_inum) { 1, parent->bi_inum }, &parent_u,
-				(subvol_inum) { 1, inum }, &inode, &qstr));
-	if (ret)
-		die("error creating hardlink: %s", bch2_err_str(ret));
-}
-
-static struct bch_inode_unpacked create_file(struct bch_fs *c,
-					     struct bch_inode_unpacked *parent,
-					     const char *name,
-					     uid_t uid, gid_t gid,
-					     mode_t mode, dev_t rdev)
-{
-	struct qstr qstr = QSTR(name);
-	struct bch_inode_unpacked new_inode;
-
-	bch2_inode_init_early(c, &new_inode);
-
-	int ret = bch2_trans_do(c, NULL, NULL, 0,
-		bch2_create_trans(trans,
-				  (subvol_inum) { 1, parent->bi_inum }, parent,
-				  &new_inode, &qstr,
-				  uid, gid, mode, rdev, NULL, NULL,
-				  (subvol_inum) {}, 0));
-	if (ret)
-		die("error creating %s: %s", name, bch2_err_str(ret));
-
-	return new_inode;
-}
-
-#define for_each_xattr_handler(handlers, handler)		\
-	if (handlers)						\
-		for ((handler) = *(handlers)++;			\
-			(handler) != NULL;			\
-			(handler) = *(handlers)++)
-
-static const struct xattr_handler *xattr_resolve_name(char **name)
-{
-	const struct xattr_handler **handlers = bch2_xattr_handlers;
-	const struct xattr_handler *handler;
-
-	for_each_xattr_handler(handlers, handler) {
-		char *n;
-
-		n = strcmp_prefix(*name, xattr_prefix(handler));
-		if (n) {
-			if (!handler->prefix ^ !*n) {
-				if (*n)
-					continue;
-				return ERR_PTR(-EINVAL);
-			}
-			*name = n;
-			return handler;
-		}
-	}
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
-static void copy_times(struct bch_fs *c, struct bch_inode_unpacked *dst,
-		       struct stat *src)
-{
-	dst->bi_atime = timespec_to_bch2_time(c, src->st_atim);
-	dst->bi_mtime = timespec_to_bch2_time(c, src->st_mtim);
-	dst->bi_ctime = timespec_to_bch2_time(c, src->st_ctim);
-}
-
-static void copy_xattrs(struct bch_fs *c, struct bch_inode_unpacked *dst,
-			char *src)
-{
-	struct bch_hash_info hash_info = bch2_hash_info_init(c, dst);
-
-	char attrs[XATTR_LIST_MAX];
-	ssize_t attrs_size = llistxattr(src, attrs, sizeof(attrs));
-	if (attrs_size < 0)
-		die("listxattr error: %m");
-
-	char *next, *attr;
-	for (attr = attrs;
-	     attr < attrs + attrs_size;
-	     attr = next) {
-		next = attr + strlen(attr) + 1;
-
-		char val[XATTR_SIZE_MAX];
-		ssize_t val_size = lgetxattr(src, attr, val, sizeof(val));
-
-		if (val_size < 0)
-			die("error getting xattr val: %m");
-
-		const struct xattr_handler *h = xattr_resolve_name(&attr);
-		struct bch_inode_unpacked inode_u;
-
-		int ret = bch2_trans_do(c, NULL, NULL, 0,
-				bch2_xattr_set(trans,
-					       (subvol_inum) { 1, dst->bi_inum },
-					       &inode_u, &hash_info, attr,
-					       val, val_size, h->flags, 0));
-		if (ret < 0)
-			die("error creating xattr: %s", bch2_err_str(ret));
-	}
-}
-
-#define WRITE_DATA_BUF	(1 << 20)
-
-static char buf[WRITE_DATA_BUF] __aligned(PAGE_SIZE);
-
-static void write_data(struct bch_fs *c,
-		       struct bch_inode_unpacked *dst_inode,
-		       u64 dst_offset, void *buf, size_t len)
-{
-	struct bch_write_op op;
-	struct bio_vec bv[WRITE_DATA_BUF / PAGE_SIZE];
-
-	BUG_ON(dst_offset	& (block_bytes(c) - 1));
-	BUG_ON(len		& (block_bytes(c) - 1));
-	BUG_ON(len > WRITE_DATA_BUF);
-
-	bio_init(&op.wbio.bio, NULL, bv, ARRAY_SIZE(bv), 0);
-	bch2_bio_map(&op.wbio.bio, buf, len);
-
-	bch2_write_op_init(&op, c, bch2_opts_to_inode_opts(c->opts));
-	op.write_point	= writepoint_hashed(0);
-	op.nr_replicas	= 1;
-	op.subvol	= 1;
-	op.pos		= SPOS(dst_inode->bi_inum, dst_offset >> 9, U32_MAX);
-	op.flags |= BCH_WRITE_SYNC;
-
-	int ret = bch2_disk_reservation_get(c, &op.res, len >> 9,
-					    c->opts.data_replicas, 0);
-	if (ret)
-		die("error reserving space in new filesystem: %s", bch2_err_str(ret));
-
-	closure_call(&op.cl, bch2_write, NULL, NULL);
-
-	BUG_ON(!(op.flags & BCH_WRITE_DONE));
-	dst_inode->bi_sectors += len >> 9;
-
-	if (op.error)
-		die("write error: %s", bch2_err_str(op.error));
-}
-
-static void copy_data(struct bch_fs *c,
-		      struct bch_inode_unpacked *dst_inode,
-		      int src_fd, u64 start, u64 end)
-{
-	while (start < end) {
-		unsigned len = min_t(u64, end - start, sizeof(buf));
-		unsigned pad = round_up(len, block_bytes(c)) - len;
-
-		xpread(src_fd, buf, len, start);
-		memset(buf + len, 0, pad);
-
-		write_data(c, dst_inode, start, buf, len + pad);
-		start += len;
-	}
-}
-
-static void link_data(struct bch_fs *c, struct bch_inode_unpacked *dst,
-		      u64 logical, u64 physical, u64 length)
-{
-	struct bch_dev *ca = c->devs[0];
-
-	BUG_ON(logical	& (block_bytes(c) - 1));
-	BUG_ON(physical & (block_bytes(c) - 1));
-	BUG_ON(length	& (block_bytes(c) - 1));
-
-	logical		>>= 9;
-	physical	>>= 9;
-	length		>>= 9;
-
-	BUG_ON(physical + length > bucket_to_sector(ca, ca->mi.nbuckets));
-
-	while (length) {
-		struct bkey_i_extent *e;
-		BKEY_PADDED_ONSTACK(k, BKEY_EXTENT_VAL_U64s_MAX) k;
-		u64 b = sector_to_bucket(ca, physical);
-		struct disk_reservation res;
-		unsigned sectors;
-		int ret;
-
-		sectors = min(ca->mi.bucket_size -
-			      (physical & (ca->mi.bucket_size - 1)),
-			      length);
-
-		e = bkey_extent_init(&k.k);
-		e->k.p.inode	= dst->bi_inum;
-		e->k.p.offset	= logical + sectors;
-		e->k.p.snapshot	= U32_MAX;
-		e->k.size	= sectors;
-		bch2_bkey_append_ptr(&e->k_i, (struct bch_extent_ptr) {
-					.offset = physical,
-					.dev = 0,
-					.gen = *bucket_gen(ca, b),
-				  });
-
-		ret = bch2_disk_reservation_get(c, &res, sectors, 1,
-						BCH_DISK_RESERVATION_NOFAIL);
-		if (ret)
-			die("error reserving space in new filesystem: %s",
-			    bch2_err_str(ret));
-
-		ret = bch2_btree_insert(c, BTREE_ID_extents, &e->k_i, &res, 0, 0);
-		if (ret)
-			die("btree insert error %s", bch2_err_str(ret));
-
-		bch2_disk_reservation_put(c, &res);
-
-		dst->bi_sectors	+= sectors;
-		logical		+= sectors;
-		physical	+= sectors;
-		length		-= sectors;
-	}
-}
-
-static void copy_link(struct bch_fs *c, struct bch_inode_unpacked *dst,
-		      char *src)
-{
-	ssize_t ret = readlink(src, buf, sizeof(buf));
-	if (ret < 0)
-		die("readlink error: %m");
-
-	write_data(c, dst, 0, buf, round_up(ret, block_bytes(c)));
-}
-
-static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
-		      int src_fd, u64 src_size,
-		      char *src_path, ranges *extents)
-{
-	struct fiemap_iter iter;
-	struct fiemap_extent e;
-
-	fiemap_for_each(src_fd, iter, e)
-		if (e.fe_flags & FIEMAP_EXTENT_UNKNOWN) {
-			fsync(src_fd);
-			break;
-		}
-	fiemap_iter_exit(&iter);
-
-	fiemap_for_each(src_fd, iter, e) {
-		u64 src_max = roundup(src_size, block_bytes(c));
-
-		e.fe_length = min(e.fe_length, src_max - e.fe_logical);
-
-		if ((e.fe_logical	& (block_bytes(c) - 1)) ||
-		    (e.fe_length	& (block_bytes(c) - 1)))
-			die("Unaligned extent in %s - can't handle", src_path);
-
-		if (e.fe_flags & (FIEMAP_EXTENT_UNKNOWN|
-				  FIEMAP_EXTENT_ENCODED|
-				  FIEMAP_EXTENT_NOT_ALIGNED|
-				  FIEMAP_EXTENT_DATA_INLINE)) {
-			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
-				      e.fe_length));
-			continue;
-		}
-
-		/*
-		 * if the data is below 1 MB, copy it so it doesn't conflict
-		 * with bcachefs's potentially larger superblock:
-		 */
-		if (e.fe_physical < 1 << 20) {
-			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
-				      e.fe_length));
-			continue;
-		}
-
-		if ((e.fe_physical	& (block_bytes(c) - 1)))
-			die("Unaligned extent in %s - can't handle", src_path);
-
-		range_add(extents, e.fe_physical, e.fe_length);
-		link_data(c, dst, e.fe_logical, e.fe_physical, e.fe_length);
-	}
-	fiemap_iter_exit(&iter);
-}
-
-struct copy_fs_state {
-	u64			bcachefs_inum;
-	dev_t			dev;
-
-	GENRADIX(u64)		hardlinks;
-	ranges			extents;
-};
-
-static void copy_dir(struct copy_fs_state *s,
-		     struct bch_fs *c,
-		     struct bch_inode_unpacked *dst,
-		     int src_fd, const char *src_path)
-{
-	DIR *dir = fdopendir(src_fd);
-	struct dirent *d;
-
-	while ((errno = 0), (d = readdir(dir))) {
-		struct bch_inode_unpacked inode;
-		int fd;
-
-		if (fchdir(src_fd))
-			die("chdir error: %m");
-
-		struct stat stat =
-			xfstatat(src_fd, d->d_name, AT_SYMLINK_NOFOLLOW);
-
-		if (!strcmp(d->d_name, ".") ||
-		    !strcmp(d->d_name, "..") ||
-		    !strcmp(d->d_name, "lost+found") ||
-		    stat.st_ino == s->bcachefs_inum)
-			continue;
-
-		char *child_path = mprintf("%s/%s", src_path, d->d_name);
-
-		if (stat.st_dev != s->dev)
-			die("%s does not have correct st_dev!", child_path);
-
-		u64 *dst_inum = S_ISREG(stat.st_mode)
-			? genradix_ptr_alloc(&s->hardlinks, stat.st_ino, GFP_KERNEL)
-			: NULL;
-
-		if (dst_inum && *dst_inum) {
-			create_link(c, dst, d->d_name, *dst_inum, S_IFREG);
-			goto next;
-		}
-
-		inode = create_file(c, dst, d->d_name,
-				    stat.st_uid, stat.st_gid,
-				    stat.st_mode, stat.st_rdev);
-
-		if (dst_inum)
-			*dst_inum = inode.bi_inum;
-
-		copy_times(c, &inode, &stat);
-		copy_xattrs(c, &inode, d->d_name);
-
-		/* copy xattrs */
-
-		switch (mode_to_type(stat.st_mode)) {
-		case DT_DIR:
-			fd = xopen(d->d_name, O_RDONLY|O_NOATIME);
-			copy_dir(s, c, &inode, fd, child_path);
-			close(fd);
-			break;
-		case DT_REG:
-			inode.bi_size = stat.st_size;
-
-			fd = xopen(d->d_name, O_RDONLY|O_NOATIME);
-			copy_file(c, &inode, fd, stat.st_size,
-				  child_path, &s->extents);
-			close(fd);
-			break;
-		case DT_LNK:
-			inode.bi_size = stat.st_size;
-
-			copy_link(c, &inode, d->d_name);
-			break;
-		case DT_FIFO:
-		case DT_CHR:
-		case DT_BLK:
-		case DT_SOCK:
-		case DT_WHT:
-			/* nothing else to copy for these: */
-			break;
-		default:
-			BUG();
-		}
-
-		update_inode(c, &inode);
-next:
-		free(child_path);
-	}
-
-	if (errno)
-		die("readdir error: %m");
-	closedir(dir);
-}
-
 static ranges reserve_new_fs_space(const char *file_path, unsigned block_size,
 				   u64 size, u64 *bcachefs_inum, dev_t dev,
 				   bool force)
@@ -561,62 +156,6 @@ static ranges reserve_new_fs_space(const char *file_path, unsigned block_size,
 	return extents;
 }
 
-static void reserve_old_fs_space(struct bch_fs *c,
-				 struct bch_inode_unpacked *root_inode,
-				 ranges *extents)
-{
-	struct bch_dev *ca = c->devs[0];
-	struct bch_inode_unpacked dst;
-	struct hole_iter iter;
-	struct range i;
-
-	dst = create_file(c, root_inode, "old_migrated_filesystem",
-			  0, 0, S_IFREG|0400, 0);
-	dst.bi_size = bucket_to_sector(ca, ca->mi.nbuckets) << 9;
-
-	ranges_sort_merge(extents);
-
-	for_each_hole(iter, *extents, bucket_to_sector(ca, ca->mi.nbuckets) << 9, i)
-		link_data(c, &dst, i.start, i.start, i.end - i.start);
-
-	update_inode(c, &dst);
-}
-
-static void copy_fs(struct bch_fs *c, int src_fd, const char *src_path,
-		    u64 bcachefs_inum, ranges *extents)
-{
-	syncfs(src_fd);
-
-	struct bch_inode_unpacked root_inode;
-	int ret = bch2_inode_find_by_inum(c, (subvol_inum) { 1, BCACHEFS_ROOT_INO },
-					  &root_inode);
-	if (ret)
-		die("error looking up root directory: %s", bch2_err_str(ret));
-
-	if (fchdir(src_fd))
-		die("chdir error: %m");
-
-	struct stat stat = xfstat(src_fd);
-	copy_times(c, &root_inode, &stat);
-	copy_xattrs(c, &root_inode, ".");
-
-	struct copy_fs_state s = {
-		.bcachefs_inum	= bcachefs_inum,
-		.dev		= stat.st_dev,
-		.extents	= *extents,
-	};
-
-	/* now, copy: */
-	copy_dir(&s, c, &root_inode, src_fd, src_path);
-
-	reserve_old_fs_space(c, &root_inode, &s.extents);
-
-	update_inode(c, &root_inode);
-
-	darray_exit(&s.extents);
-	genradix_free(&s.hardlinks);
-}
-
 static void find_superblock_space(ranges extents,
 				  struct format_opts opts,
 				  struct dev_opts *dev)
@@ -739,7 +278,14 @@ static int migrate_fs(const char		*fs_path,
 	if (ret)
 		die("Error starting new filesystem: %s", bch2_err_str(ret));
 
-	copy_fs(c, fs_fd, fs_path, bcachefs_inum, &extents);
+	struct copy_fs_state s = {
+		.bcachefs_inum	= bcachefs_inum,
+		.dev		= stat.st_dev,
+		.extents	= extents,
+		.type		= BCH_MIGRATE_migrate,
+	};
+
+	copy_fs(c, fs_fd, fs_path, &s);
 
 	bch2_fs_stop(c);
 
diff --git a/c_src/libbcachefs.h b/c_src/libbcachefs.h
index 5c7ef6c7..60332bb8 100644
--- a/c_src/libbcachefs.h
+++ b/c_src/libbcachefs.h
@@ -6,6 +6,7 @@
 
 #include "libbcachefs/bcachefs_format.h"
 #include "libbcachefs/bcachefs_ioctl.h"
+#include "libbcachefs/inode.h"
 #include "libbcachefs/opts.h"
 #include "libbcachefs/vstructs.h"
 #include "tools-util.h"
@@ -37,6 +38,7 @@ struct format_opts {
 	unsigned	superblock_size;
 	bool		encrypted;
 	char		*passphrase;
+	char		*source;
 };
 
 static inline struct format_opts format_opts_default()
diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
new file mode 100644
index 00000000..ee0e300f
--- /dev/null
+++ b/c_src/posix_to_bcachefs.c
@@ -0,0 +1,460 @@
+#include <dirent.h>
+#include <sys/xattr.h>
+#include <linux/xattr.h>
+
+#include "posix_to_bcachefs.h"
+#include "libbcachefs/alloc_foreground.h"
+#include "libbcachefs/buckets.h"
+#include "libbcachefs/fs-common.h"
+#include "libbcachefs/io_write.h"
+#include "libbcachefs/str_hash.h"
+#include "libbcachefs/xattr.h"
+
+void update_inode(struct bch_fs *c,
+			 struct bch_inode_unpacked *inode)
+{
+	struct bkey_inode_buf packed;
+	int ret;
+
+	bch2_inode_pack(&packed, inode);
+	packed.inode.k.p.snapshot = U32_MAX;
+	ret = bch2_btree_insert(c, BTREE_ID_inodes, &packed.inode.k_i,
+				NULL, 0, 0);
+	if (ret)
+		die("error updating inode: %s", bch2_err_str(ret));
+}
+
+void create_link(struct bch_fs *c,
+			struct bch_inode_unpacked *parent,
+			const char *name, u64 inum, mode_t mode)
+{
+	struct qstr qstr = QSTR(name);
+	struct bch_inode_unpacked parent_u;
+	struct bch_inode_unpacked inode;
+
+	int ret = bch2_trans_do(c, NULL, NULL, 0,
+		bch2_link_trans(trans,
+				(subvol_inum) { 1, parent->bi_inum }, &parent_u,
+				(subvol_inum) { 1, inum }, &inode, &qstr));
+	if (ret)
+		die("error creating hardlink: %s", bch2_err_str(ret));
+}
+
+struct bch_inode_unpacked create_file(struct bch_fs *c,
+					     struct bch_inode_unpacked *parent,
+					     const char *name,
+					     uid_t uid, gid_t gid,
+					     mode_t mode, dev_t rdev)
+{
+	struct qstr qstr = QSTR(name);
+	struct bch_inode_unpacked new_inode;
+
+	bch2_inode_init_early(c, &new_inode);
+
+	int ret = bch2_trans_do(c, NULL, NULL, 0,
+		bch2_create_trans(trans,
+				  (subvol_inum) { 1, parent->bi_inum }, parent,
+				  &new_inode, &qstr,
+				  uid, gid, mode, rdev, NULL, NULL,
+				  (subvol_inum) {}, 0));
+	if (ret)
+		die("error creating %s: %s", name, bch2_err_str(ret));
+
+	return new_inode;
+}
+
+#define for_each_xattr_handler(handlers, handler)		\
+	if (handlers)						\
+		for ((handler) = *(handlers)++;			\
+			(handler) != NULL;			\
+			(handler) = *(handlers)++)
+
+static const struct xattr_handler *xattr_resolve_name(char **name)
+{
+	const struct xattr_handler **handlers = bch2_xattr_handlers;
+	const struct xattr_handler *handler;
+
+	for_each_xattr_handler(handlers, handler) {
+		char *n;
+
+		n = strcmp_prefix(*name, xattr_prefix(handler));
+		if (n) {
+			if (!handler->prefix ^ !*n) {
+				if (*n)
+					continue;
+				return ERR_PTR(-EINVAL);
+			}
+			*name = n;
+			return handler;
+		}
+	}
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+void copy_times(struct bch_fs *c, struct bch_inode_unpacked *dst,
+		       struct stat *src)
+{
+	dst->bi_atime = timespec_to_bch2_time(c, src->st_atim);
+	dst->bi_mtime = timespec_to_bch2_time(c, src->st_mtim);
+	dst->bi_ctime = timespec_to_bch2_time(c, src->st_ctim);
+}
+
+void copy_xattrs(struct bch_fs *c, struct bch_inode_unpacked *dst,
+			char *src)
+{
+	struct bch_hash_info hash_info = bch2_hash_info_init(c, dst);
+
+	char attrs[XATTR_LIST_MAX];
+	ssize_t attrs_size = llistxattr(src, attrs, sizeof(attrs));
+	if (attrs_size < 0)
+		die("listxattr error: %m");
+
+	char *next, *attr;
+	for (attr = attrs;
+	     attr < attrs + attrs_size;
+	     attr = next) {
+		next = attr + strlen(attr) + 1;
+
+		char val[XATTR_SIZE_MAX];
+		ssize_t val_size = lgetxattr(src, attr, val, sizeof(val));
+
+		if (val_size < 0)
+			die("error getting xattr val: %m");
+
+		const struct xattr_handler *h = xattr_resolve_name(&attr);
+		struct bch_inode_unpacked inode_u;
+
+		int ret = bch2_trans_do(c, NULL, NULL, 0,
+				bch2_xattr_set(trans,
+					       (subvol_inum) { 1, dst->bi_inum },
+					       &inode_u, &hash_info, attr,
+					       val, val_size, h->flags, 0));
+		if (ret < 0)
+			die("error creating xattr: %s", bch2_err_str(ret));
+	}
+}
+
+#define WRITE_DATA_BUF	(1 << 20)
+
+static char buf[WRITE_DATA_BUF] __aligned(PAGE_SIZE);
+
+static void write_data(struct bch_fs *c,
+		       struct bch_inode_unpacked *dst_inode,
+		       u64 dst_offset, void *buf, size_t len)
+{
+	struct bch_write_op op;
+	struct bio_vec bv[WRITE_DATA_BUF / PAGE_SIZE];
+
+	BUG_ON(dst_offset	& (block_bytes(c) - 1));
+	BUG_ON(len		& (block_bytes(c) - 1));
+	BUG_ON(len > WRITE_DATA_BUF);
+
+	bio_init(&op.wbio.bio, NULL, bv, ARRAY_SIZE(bv), 0);
+	bch2_bio_map(&op.wbio.bio, buf, len);
+
+	bch2_write_op_init(&op, c, bch2_opts_to_inode_opts(c->opts));
+	op.write_point	= writepoint_hashed(0);
+	op.nr_replicas	= 1;
+	op.subvol	= 1;
+	op.pos		= SPOS(dst_inode->bi_inum, dst_offset >> 9, U32_MAX);
+	op.flags |= BCH_WRITE_SYNC;
+
+	int ret = bch2_disk_reservation_get(c, &op.res, len >> 9,
+					    c->opts.data_replicas, 0);
+	if (ret)
+		die("error reserving space in new filesystem: %s", bch2_err_str(ret));
+
+	closure_call(&op.cl, bch2_write, NULL, NULL);
+
+	BUG_ON(!(op.flags & BCH_WRITE_DONE));
+	dst_inode->bi_sectors += len >> 9;
+
+	if (op.error)
+		die("write error: %s", bch2_err_str(op.error));
+}
+
+void copy_data(struct bch_fs *c,
+		      struct bch_inode_unpacked *dst_inode,
+		      int src_fd, u64 start, u64 end)
+{
+	while (start < end) {
+		unsigned len = min_t(u64, end - start, sizeof(buf));
+		unsigned pad = round_up(len, block_bytes(c)) - len;
+
+		xpread(src_fd, buf, len, start);
+		memset(buf + len, 0, pad);
+
+		write_data(c, dst_inode, start, buf, len + pad);
+		start += len;
+	}
+}
+
+static void link_data(struct bch_fs *c, struct bch_inode_unpacked *dst,
+		      u64 logical, u64 physical, u64 length)
+{
+	struct bch_dev *ca = c->devs[0];
+
+	BUG_ON(logical	& (block_bytes(c) - 1));
+	BUG_ON(physical & (block_bytes(c) - 1));
+	BUG_ON(length	& (block_bytes(c) - 1));
+
+	logical		>>= 9;
+	physical	>>= 9;
+	length		>>= 9;
+
+	BUG_ON(physical + length > bucket_to_sector(ca, ca->mi.nbuckets));
+
+	while (length) {
+		struct bkey_i_extent *e;
+		BKEY_PADDED_ONSTACK(k, BKEY_EXTENT_VAL_U64s_MAX) k;
+		u64 b = sector_to_bucket(ca, physical);
+		struct disk_reservation res;
+		unsigned sectors;
+		int ret;
+
+		sectors = min(ca->mi.bucket_size -
+			      (physical & (ca->mi.bucket_size - 1)),
+			      length);
+
+		e = bkey_extent_init(&k.k);
+		e->k.p.inode	= dst->bi_inum;
+		e->k.p.offset	= logical + sectors;
+		e->k.p.snapshot	= U32_MAX;
+		e->k.size	= sectors;
+		bch2_bkey_append_ptr(&e->k_i, (struct bch_extent_ptr) {
+					.offset = physical,
+					.dev = 0,
+					.gen = *bucket_gen(ca, b),
+				  });
+
+		ret = bch2_disk_reservation_get(c, &res, sectors, 1,
+						BCH_DISK_RESERVATION_NOFAIL);
+		if (ret)
+			die("error reserving space in new filesystem: %s",
+			    bch2_err_str(ret));
+
+		ret = bch2_btree_insert(c, BTREE_ID_extents, &e->k_i, &res, 0, 0);
+		if (ret)
+			die("btree insert error %s", bch2_err_str(ret));
+
+		bch2_disk_reservation_put(c, &res);
+
+		dst->bi_sectors	+= sectors;
+		logical		+= sectors;
+		physical	+= sectors;
+		length		-= sectors;
+	}
+}
+
+void copy_link(struct bch_fs *c, struct bch_inode_unpacked *dst,
+		      char *src)
+{
+	ssize_t i;
+	ssize_t ret = readlink(src, buf, sizeof(buf));
+	if (ret < 0)
+		die("readlink error: %m");
+
+	for (i = ret; i < round_up(ret, block_bytes(c)); i++)
+		buf[i] = 0;
+
+	write_data(c, dst, 0, buf, round_up(ret, block_bytes(c)));
+}
+
+static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
+		      int src_fd, u64 src_size,
+		      char *src_path, struct copy_fs_state *s)
+{
+	struct fiemap_iter iter;
+	struct fiemap_extent e;
+
+	fiemap_for_each(src_fd, iter, e)
+		if (e.fe_flags & FIEMAP_EXTENT_UNKNOWN) {
+			fsync(src_fd);
+			break;
+		}
+	fiemap_iter_exit(&iter);
+
+	fiemap_for_each(src_fd, iter, e) {
+		u64 src_max = roundup(src_size, block_bytes(c));
+
+		e.fe_length = min(e.fe_length, src_max - e.fe_logical);
+
+		if ((e.fe_logical	& (block_bytes(c) - 1)) ||
+		    (e.fe_length	& (block_bytes(c) - 1)))
+			die("Unaligned extent in %s - can't handle", src_path);
+
+		if (BCH_MIGRATE_copy == s->type || (e.fe_flags & (FIEMAP_EXTENT_UNKNOWN|
+				  FIEMAP_EXTENT_ENCODED|
+				  FIEMAP_EXTENT_NOT_ALIGNED|
+				  FIEMAP_EXTENT_DATA_INLINE))) {
+			copy_data(c, dst, src_fd, e.fe_logical,
+				  min(src_size - e.fe_logical,
+				      e.fe_length));
+			continue;
+		}
+
+		/*
+		 * if the data is below 1 MB, copy it so it doesn't conflict
+		 * with bcachefs's potentially larger superblock:
+		 */
+		if (e.fe_physical < 1 << 20) {
+			copy_data(c, dst, src_fd, e.fe_logical,
+				  min(src_size - e.fe_logical,
+				      e.fe_length));
+			continue;
+		}
+
+		if ((e.fe_physical	& (block_bytes(c) - 1)))
+			die("Unaligned extent in %s - can't handle", src_path);
+
+		range_add(&s->extents, e.fe_physical, e.fe_length);
+		link_data(c, dst, e.fe_logical, e.fe_physical, e.fe_length);
+	}
+	fiemap_iter_exit(&iter);
+}
+
+static void copy_dir(struct copy_fs_state *s,
+		     struct bch_fs *c,
+		     struct bch_inode_unpacked *dst,
+		     int src_fd, const char *src_path)
+{
+	DIR *dir = fdopendir(src_fd);
+	struct dirent *d;
+
+	while ((errno = 0), (d = readdir(dir))) {
+		struct bch_inode_unpacked inode;
+		int fd;
+
+		if (fchdir(src_fd))
+			die("chdir error: %m");
+
+		struct stat stat =
+			xfstatat(src_fd, d->d_name, AT_SYMLINK_NOFOLLOW);
+
+		if (!strcmp(d->d_name, ".") ||
+		    !strcmp(d->d_name, "..") ||
+		    !strcmp(d->d_name, "lost+found"))
+			continue;
+
+		if (BCH_MIGRATE_migrate == s->type && stat.st_ino == s->bcachefs_inum)
+			continue;
+
+		char *child_path = mprintf("%s/%s", src_path, d->d_name);
+
+		if (s->type == BCH_MIGRATE_migrate && stat.st_dev != s->dev)
+			die("%s does not have correct st_dev!", child_path);
+
+		u64 *dst_inum = S_ISREG(stat.st_mode)
+			? genradix_ptr_alloc(&s->hardlinks, stat.st_ino, GFP_KERNEL)
+			: NULL;
+
+		if (dst_inum && *dst_inum) {
+			create_link(c, dst, d->d_name, *dst_inum, S_IFREG);
+			goto next;
+		}
+
+		inode = create_file(c, dst, d->d_name,
+				    stat.st_uid, stat.st_gid,
+				    stat.st_mode, stat.st_rdev);
+
+		if (dst_inum)
+			*dst_inum = inode.bi_inum;
+
+		copy_times(c, &inode, &stat);
+		copy_xattrs(c, &inode, d->d_name);
+
+		/* copy xattrs */
+
+		switch (mode_to_type(stat.st_mode)) {
+		case DT_DIR:
+			fd = xopen(d->d_name, O_RDONLY|O_NOATIME);
+			copy_dir(s, c, &inode, fd, child_path);
+			close(fd);
+			break;
+		case DT_REG:
+			inode.bi_size = stat.st_size;
+
+			fd = xopen(d->d_name, O_RDONLY|O_NOATIME);
+			copy_file(c, &inode, fd, stat.st_size,
+				  child_path, s);
+			close(fd);
+			break;
+		case DT_LNK:
+			inode.bi_size = stat.st_size;
+
+			copy_link(c, &inode, d->d_name);
+			break;
+		case DT_FIFO:
+		case DT_CHR:
+		case DT_BLK:
+		case DT_SOCK:
+		case DT_WHT:
+			/* nothing else to copy for these: */
+			break;
+		default:
+			BUG();
+		}
+
+		update_inode(c, &inode);
+next:
+		free(child_path);
+	}
+
+	if (errno)
+		die("readdir error: %m");
+	closedir(dir);
+}
+
+static void reserve_old_fs_space(struct bch_fs *c,
+				 struct bch_inode_unpacked *root_inode,
+				 ranges *extents)
+{
+	struct bch_dev *ca = c->devs[0];
+	struct bch_inode_unpacked dst;
+	struct hole_iter iter;
+	struct range i;
+
+	dst = create_file(c, root_inode, "old_migrated_filesystem",
+			  0, 0, S_IFREG|0400, 0);
+	dst.bi_size = bucket_to_sector(ca, ca->mi.nbuckets) << 9;
+
+	ranges_sort_merge(extents);
+
+	for_each_hole(iter, *extents, bucket_to_sector(ca, ca->mi.nbuckets) << 9, i)
+		link_data(c, &dst, i.start, i.start, i.end - i.start);
+
+	update_inode(c, &dst);
+}
+
+void copy_fs(struct bch_fs *c, int src_fd, const char *src_path,
+		    struct copy_fs_state *s)
+{
+	syncfs(src_fd);
+
+	struct bch_inode_unpacked root_inode;
+	int ret = bch2_inode_find_by_inum(c, (subvol_inum) { 1, BCACHEFS_ROOT_INO },
+					  &root_inode);
+	if (ret)
+		die("error looking up root directory: %s", bch2_err_str(ret));
+
+	if (fchdir(src_fd))
+		die("chdir error: %m");
+
+	struct stat stat = xfstat(src_fd);
+	copy_times(c, &root_inode, &stat);
+	copy_xattrs(c, &root_inode, ".");
+
+
+	/* now, copy: */
+	copy_dir(s, c, &root_inode, src_fd, src_path);
+
+	if (BCH_MIGRATE_migrate == s->type)
+		reserve_old_fs_space(c, &root_inode, &s->extents);
+
+	update_inode(c, &root_inode);
+
+	if (BCH_MIGRATE_migrate == s->type)
+		darray_exit(&s->extents);
+
+	genradix_free(&s->hardlinks);
+}
diff --git a/c_src/posix_to_bcachefs.h b/c_src/posix_to_bcachefs.h
new file mode 100644
index 00000000..facb75ed
--- /dev/null
+++ b/c_src/posix_to_bcachefs.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _POSIX_TO_BCACHEFS_H
+#define _POSIX_TO_BCACHEFS_H
+
+/*
+ * This header exports the functionality needed for copying data from existing
+ * posix compliant filesystems to bcachefs. There are two use cases:
+ * 1. Creating a new bcachefs filesystem using `bcachefs format`, we can
+ *    specify a source directory tree which will be copied over the new
+ *    bcachefs filesytem.
+ * 2. Migrating an existing filesystem in place, with `bcachefs migrate`.
+ *    This will allocate space for the bcachefs metadata, but the actual data
+ *    represented by the extents will not be duplicated. The bcachefs metadata
+ *    will simply point to the existing extents.
+ *
+ * To avoid code duplication, `copy_fs` deals with both cases. See the function
+ * documentation for more details.
+ */
+
+#include "libbcachefs.h"
+
+enum bch_migrate_type {
+	BCH_MIGRATE_copy,
+	BCH_MIGRATE_migrate
+};
+
+/*
+ * The migrate action uses all the fields in this struct.
+ * The copy action only uses the `hardlinks` field. Since `hardlinks` is
+ * initialized with zeroes, an empty `copy_fs_state` struct can be passed.
+ */
+struct copy_fs_state {
+	u64			bcachefs_inum;
+	dev_t			dev;
+
+	GENRADIX(u64)		hardlinks;
+	ranges			extents;
+	enum bch_migrate_type	type;
+};
+
+/*
+ * The `copy_fs` function is used for both copying a directory tree to a new
+ * bcachefs filesystem and migrating an existing one, depending on the value
+ * from the `type` field in `copy_fs_state` struct.
+ *
+ * In case of copy, an empty `copy_fs_state` structure is passed to `copy_fs`
+ * (only the `hardlinks` field is used, and that is initialized with zeroes).
+ *
+ * In the migrate case, all the fields from `copy_fs_state` need to be
+ * initialized (`hardlinks` is initialized with zeroes).
+ */
+void copy_fs(struct bch_fs *c, int src_fd, const char *src_path,
+		    struct copy_fs_state *s);
+#endif /* _LIBBCACHE_H */
diff --git a/libbcachefs/bkey.h b/libbcachefs/bkey.h
index fcd43915..3dc4cf69 100644
--- a/libbcachefs/bkey.h
+++ b/libbcachefs/bkey.h
@@ -8,6 +8,7 @@
 #include "btree_types.h"
 #include "util.h"
 #include "vstructs.h"
+#include "bcachefs.h"
 
 enum bch_validate_flags {
 	BCH_VALIDATE_write		= (1U << 0),
diff --git a/libbcachefs/fs-common.h b/libbcachefs/fs-common.h
index dde23785..2064ef5b 100644
--- a/libbcachefs/fs-common.h
+++ b/libbcachefs/fs-common.h
@@ -2,6 +2,7 @@
 #ifndef _BCACHEFS_FS_COMMON_H
 #define _BCACHEFS_FS_COMMON_H
 
+#include "libbcachefs/dirent.h"
 struct posix_acl;
 
 #define BCH_CREATE_TMPFILE		(1U << 0)
diff --git a/libbcachefs/inode.h b/libbcachefs/inode.h
index 679f5f5e..b62111bf 100644
--- a/libbcachefs/inode.h
+++ b/libbcachefs/inode.h
@@ -5,6 +5,7 @@
 #include "bkey.h"
 #include "bkey_methods.h"
 #include "opts.h"
+#include "subvolume_types.h"
 
 enum bch_validate_flags;
 extern const char * const bch2_inode_opts[];
-- 
2.34.1

