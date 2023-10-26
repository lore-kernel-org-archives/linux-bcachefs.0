Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1E5C25B6B
	for <linux-bcachefs@archiver.kernel.org>; Thu, 26 Oct 2023 19:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjJZTPG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 26 Oct 2023 15:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbjJZTPB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 26 Oct 2023 15:15:01 -0400
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E7A10F5
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Oct 2023 12:14:42 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698347680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VztqNwWdyTd40Ep+Y/JtNYo3A339fFLDjGrfKX62Hps=;
        b=kJV1OgwjTaqdbTmXMGVADx/y9N0dr1RcCnVigRaX+bRQj3eMmkhhq9Y6TSQNUUKPrlBe8V
        0hbqhE89Q1FgLJQrPdnsEpzYcIy46bgrlJsltGrOPixe34NVjKdHIKUmthgG+k8YO+Zqgm
        5QckzHaeKetJiKW9XabBtsf3l91pzqI=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: Add IO error counts to bch_member
Date:   Thu, 26 Oct 2023 15:14:30 -0400
Message-ID: <20231026191434.2976460-2-kent.overstreet@linux.dev>
In-Reply-To: <20231026191434.2976460-1-kent.overstreet@linux.dev>
References: <20231026191434.2976460-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

We now track IO errors per device since filesystem creation.

IO error counts can be viewed in sysfs, or with the 'bcachefs
show-super' command.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |  2 ++
 fs/bcachefs/bcachefs_format.h | 13 +++++++
 fs/bcachefs/btree_io.c        |  6 ++--
 fs/bcachefs/ec.c              |  6 +++-
 fs/bcachefs/error.c           |  3 +-
 fs/bcachefs/error.h           | 10 +++---
 fs/bcachefs/io_read.c         |  4 +--
 fs/bcachefs/io_write.c        |  2 +-
 fs/bcachefs/journal_io.c      |  5 +--
 fs/bcachefs/opts.c            |  5 ---
 fs/bcachefs/opts.h            |  1 -
 fs/bcachefs/sb-members.c      | 68 ++++++++++++++++++++++++++---------
 fs/bcachefs/sb-members.h      | 39 +++++++++++++++++++-
 fs/bcachefs/super-io.c        |  9 +++--
 fs/bcachefs/super-io.h        | 35 ------------------
 fs/bcachefs/super.c           |  5 +++
 fs/bcachefs/sysfs.c           | 27 +++++++++++---
 17 files changed, 160 insertions(+), 80 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 68f0ff03c28a..0ae14a69dfde 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -502,6 +502,8 @@ struct bch_dev {
 	 * Committed by bch2_write_super() -> bch_fs_mi_update()
 	 */
 	struct bch_member_cpu	mi;
+	atomic64_t		errors[BCH_MEMBER_ERROR_NR];
+
 	__uuid_t		uuid;
 	char			name[BDEVNAME_SIZE];
 
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index e04999c57892..c5340d7aa3fe 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1268,6 +1268,18 @@ enum bch_iops_measurement {
 	BCH_IOPS_NR
 };
 
+#define BCH_MEMBER_ERROR_TYPES()		\
+	x(read,		0)			\
+	x(write,	1)			\
+	x(checksum,	2)
+
+enum bch_member_error_type {
+#define x(t, n) BCH_MEMBER_ERROR_##t = n,
+	BCH_MEMBER_ERROR_TYPES()
+#undef x
+	BCH_MEMBER_ERROR_NR
+};
+
 struct bch_member {
 	__uuid_t		uuid;
 	__le64			nbuckets;	/* device size */
@@ -1278,6 +1290,7 @@ struct bch_member {
 
 	__le64			flags;
 	__le32			iops[4];
+	__le64			errors[BCH_MEMBER_ERROR_NR];
 };
 
 #define BCH_MEMBER_V1_BYTES	56
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 7bf3ee25bc32..dba78b5d92af 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1168,7 +1168,8 @@ static void btree_node_read_work(struct work_struct *work)
 start:
 		printbuf_reset(&buf);
 		bch2_btree_pos_to_text(&buf, c, b);
-		bch2_dev_io_err_on(bio->bi_status, ca, "btree read error %s for %s",
+		bch2_dev_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_read,
+				   "btree read error %s for %s",
 				   bch2_blk_status_to_str(bio->bi_status), buf.buf);
 		if (rb->have_ioref)
 			percpu_ref_put(&ca->io_ref);
@@ -1749,7 +1750,8 @@ static void btree_node_write_endio(struct bio *bio)
 	if (wbio->have_ioref)
 		bch2_latency_acct(ca, wbio->submit_time, WRITE);
 
-	if (bch2_dev_io_err_on(bio->bi_status, ca, "btree write error: %s",
+	if (bch2_dev_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_write,
+			       "btree write error: %s",
 			       bch2_blk_status_to_str(bio->bi_status)) ||
 	    bch2_meta_write_fault("btree")) {
 		spin_lock_irqsave(&c->btree_write_error_lock, flags);
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 8646856e4539..c9795cd98192 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -373,7 +373,11 @@ static void ec_block_endio(struct bio *bio)
 	struct bch_dev *ca = ec_bio->ca;
 	struct closure *cl = bio->bi_private;
 
-	if (bch2_dev_io_err_on(bio->bi_status, ca, "erasure coding %s error: %s",
+	if (bch2_dev_io_err_on(bio->bi_status, ca,
+			       bio_data_dir(bio)
+			       ? BCH_MEMBER_ERROR_write
+			       : BCH_MEMBER_ERROR_read,
+			       "erasure coding %s error: %s",
 			       bio_data_dir(bio) ? "write" : "read",
 			       bch2_blk_status_to_str(bio->bi_status)))
 		clear_bit(ec_bio->idx, ec_bio->buf->valid);
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 2a5af8872613..4dbfe31197bc 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -56,8 +56,9 @@ void bch2_io_error_work(struct work_struct *work)
 	up_write(&c->state_lock);
 }
 
-void bch2_io_error(struct bch_dev *ca)
+void bch2_io_error(struct bch_dev *ca, enum bch_member_error_type type)
 {
+	atomic64_inc(&ca->errors[type]);
 	//queue_work(system_long_wq, &ca->io_error_work);
 }
 
diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
index 7ce9540052e5..958b2bed4f39 100644
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -179,26 +179,26 @@ do {									\
 void bch2_io_error_work(struct work_struct *);
 
 /* Does the error handling without logging a message */
-void bch2_io_error(struct bch_dev *);
+void bch2_io_error(struct bch_dev *, enum bch_member_error_type);
 
-#define bch2_dev_io_err_on(cond, ca, ...)				\
+#define bch2_dev_io_err_on(cond, ca, _type, ...)			\
 ({									\
 	bool _ret = (cond);						\
 									\
 	if (_ret) {							\
 		bch_err_dev_ratelimited(ca, __VA_ARGS__);		\
-		bch2_io_error(ca);					\
+		bch2_io_error(ca, _type);				\
 	}								\
 	_ret;								\
 })
 
-#define bch2_dev_inum_io_err_on(cond, ca, ...)				\
+#define bch2_dev_inum_io_err_on(cond, ca, _type, ...)			\
 ({									\
 	bool _ret = (cond);						\
 									\
 	if (_ret) {							\
 		bch_err_inum_offset_ratelimited(ca, __VA_ARGS__);	\
-		bch2_io_error(ca);					\
+		bch2_io_error(ca, _type);				\
 	}								\
 	_ret;								\
 })
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 443c3ea65527..ae36fc485f5f 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -643,7 +643,7 @@ static void __bch2_read_endio(struct work_struct *work)
 		"data checksum error: expected %0llx:%0llx got %0llx:%0llx (type %s)",
 		rbio->pick.crc.csum.hi, rbio->pick.crc.csum.lo,
 		csum.hi, csum.lo, bch2_csum_types[crc.csum_type]);
-	bch2_io_error(ca);
+	bch2_io_error(ca, BCH_MEMBER_ERROR_checksum);
 	bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
 	goto out;
 decompression_err:
@@ -677,7 +677,7 @@ static void bch2_read_endio(struct bio *bio)
 	if (!rbio->split)
 		rbio->bio.bi_end_io = rbio->end_io;
 
-	if (bch2_dev_inum_io_err_on(bio->bi_status, ca,
+	if (bch2_dev_inum_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_read,
 				    rbio->read_pos.inode,
 				    rbio->read_pos.offset,
 				    "data read error: %s",
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 6d9c777213e3..613f38436640 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -637,7 +637,7 @@ static void bch2_write_endio(struct bio *bio)
 	struct bch_fs *c		= wbio->c;
 	struct bch_dev *ca		= bch_dev_bkey_exists(c, wbio->dev);
 
-	if (bch2_dev_inum_io_err_on(bio->bi_status, ca,
+	if (bch2_dev_inum_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_write,
 				    op->pos.inode,
 				    wbio->inode_offset << 9,
 				    "data write error: %s",
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index b29ece313e44..39f4d3276953 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -900,7 +900,7 @@ static int journal_read_bucket(struct bch_dev *ca,
 			ret = submit_bio_wait(bio);
 			kfree(bio);
 
-			if (bch2_dev_io_err_on(ret, ca,
+			if (bch2_dev_io_err_on(ret, ca, BCH_MEMBER_ERROR_read,
 					       "journal read error: sector %llu",
 					       offset) ||
 			    bch2_meta_read_fault("journal")) {
@@ -1581,7 +1581,8 @@ static void journal_write_endio(struct bio *bio)
 	struct journal_buf *w = journal_last_unwritten_buf(j);
 	unsigned long flags;
 
-	if (bch2_dev_io_err_on(bio->bi_status, ca, "error writing journal entry %llu: %s",
+	if (bch2_dev_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_write,
+			       "error writing journal entry %llu: %s",
 			       le64_to_cpu(w->data->seq),
 			       bch2_blk_status_to_str(bio->bi_status)) ||
 	    bch2_meta_write_fault("journal")) {
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index b7722b623697..4ad5880664b0 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -12,11 +12,6 @@
 
 #define x(t, n, ...) [n] = #t,
 
-const char * const bch2_iops_measurements[] = {
-	BCH_IOPS_MEASUREMENTS()
-	NULL
-};
-
 const char * const bch2_error_actions[] = {
 	BCH_ERROR_ACTIONS()
 	NULL
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 2307cdd2a23c..8526f177450a 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -10,7 +10,6 @@
 
 struct bch_fs;
 
-extern const char * const bch2_iops_measurements[];
 extern const char * const bch2_error_actions[];
 extern const char * const bch2_fsck_fix_opts[];
 extern const char * const bch2_version_upgrade_opts[];
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 168b032a82d3..def420684fa3 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -7,6 +7,18 @@
 #include "sb-members.h"
 #include "super-io.h"
 
+#define x(t, n, ...) [n] = #t,
+static const char * const bch2_iops_measurements[] = {
+	BCH_IOPS_MEASUREMENTS()
+	NULL
+};
+
+char * const bch2_member_error_strs[] = {
+	BCH_MEMBER_ERROR_TYPES()
+	NULL
+};
+#undef x
+
 /* Code for bch_sb_field_members_v1: */
 
 static struct bch_member *members_v2_get_mut(struct bch_sb_field_members_v2 *mi, int i)
@@ -92,7 +104,7 @@ int bch2_members_v2_init(struct bch_fs *c)
 	return sb_members_v2_resize_entries(c);
 }
 
-int bch_members_cpy_v2_v1(struct bch_sb_handle *disk_sb)
+int bch2_sb_members_cpy_v2_v1(struct bch_sb_handle *disk_sb)
 {
 	struct bch_sb_field_members_v1 *mi1;
 	struct bch_sb_field_members_v2 *mi2;
@@ -156,7 +168,6 @@ static void member_to_text(struct printbuf *out,
 	u64 bucket_size = le16_to_cpu(m.bucket_size);
 	u64 device_size = le64_to_cpu(m.nbuckets) * bucket_size;
 
-
 	prt_printf(out, "Device:");
 	prt_tab(out);
 	prt_printf(out, "%u", i);
@@ -164,6 +175,21 @@ static void member_to_text(struct printbuf *out,
 
 	printbuf_indent_add(out, 2);
 
+	prt_printf(out, "Label:");
+	prt_tab(out);
+	if (BCH_MEMBER_GROUP(&m)) {
+		unsigned idx = BCH_MEMBER_GROUP(&m) - 1;
+
+		if (idx < disk_groups_nr(gi))
+			prt_printf(out, "%s (%u)",
+				   gi->entries[idx].label, idx);
+		else
+			prt_printf(out, "(bad disk labels section)");
+	} else {
+		prt_printf(out, "(none)");
+	}
+	prt_newline(out);
+
 	prt_printf(out, "UUID:");
 	prt_tab(out);
 	pr_uuid(out, m.uuid.b);
@@ -174,6 +200,13 @@ static void member_to_text(struct printbuf *out,
 	prt_units_u64(out, device_size << 9);
 	prt_newline(out);
 
+	for (unsigned i = 0; i < BCH_MEMBER_ERROR_NR; i++) {
+		prt_printf(out, "%s errors:", bch2_member_error_strs[i]);
+		prt_tab(out);
+		prt_u64(out, le64_to_cpu(m.errors[i]));
+		prt_newline(out);
+	}
+
 	for (unsigned i = 0; i < BCH_IOPS_NR; i++) {
 		prt_printf(out, "%s iops:", bch2_iops_measurements[i]);
 		prt_tab(out);
@@ -212,21 +245,6 @@ static void member_to_text(struct printbuf *out,
 		   : "unknown");
 	prt_newline(out);
 
-	prt_printf(out, "Label:");
-	prt_tab(out);
-	if (BCH_MEMBER_GROUP(&m)) {
-		unsigned idx = BCH_MEMBER_GROUP(&m) - 1;
-
-		if (idx < disk_groups_nr(gi))
-			prt_printf(out, "%s (%u)",
-				   gi->entries[idx].label, idx);
-		else
-			prt_printf(out, "(bad disk labels section)");
-	} else {
-		prt_printf(out, "(none)");
-	}
-	prt_newline(out);
-
 	prt_printf(out, "Data allowed:");
 	prt_tab(out);
 	if (BCH_MEMBER_DATA_ALLOWED(&m))
@@ -337,3 +355,19 @@ const struct bch_sb_field_ops bch_sb_field_ops_members_v2 = {
 	.validate	= bch2_sb_members_v2_validate,
 	.to_text	= bch2_sb_members_v2_to_text,
 };
+
+void bch2_sb_members_from_cpu(struct bch_fs *c)
+{
+	struct bch_sb_field_members_v2 *mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
+	struct bch_dev *ca;
+	unsigned i, e;
+
+	rcu_read_lock();
+	for_each_member_device_rcu(ca, c, i, NULL) {
+		struct bch_member *m = members_v2_get_mut(mi, i);
+
+		for (e = 0; e < BCH_MEMBER_ERROR_NR; e++)
+			m->errors[e] = cpu_to_le64(atomic64_read(&ca->errors[e]));
+	}
+	rcu_read_unlock();
+}
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index 430f3457bfd4..edbdfb896c14 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -2,8 +2,10 @@
 #ifndef _BCACHEFS_SB_MEMBERS_H
 #define _BCACHEFS_SB_MEMBERS_H
 
+extern char * const bch2_member_error_strs[];
+
 int bch2_members_v2_init(struct bch_fs *c);
-int bch_members_cpy_v2_v1(struct bch_sb_handle *disk_sb);
+int bch2_sb_members_cpy_v2_v1(struct bch_sb_handle *disk_sb);
 struct bch_member *bch2_members_v2_get_mut(struct bch_sb *sb, int i);
 struct bch_member bch2_sb_member_get(struct bch_sb *sb, int i);
 
@@ -179,4 +181,39 @@ static inline struct bch_devs_mask bch2_online_devs(struct bch_fs *c)
 extern const struct bch_sb_field_ops bch_sb_field_ops_members_v1;
 extern const struct bch_sb_field_ops bch_sb_field_ops_members_v2;
 
+static inline bool bch2_member_exists(struct bch_member *m)
+{
+	return !bch2_is_zero(&m->uuid, sizeof(m->uuid));
+}
+
+static inline bool bch2_dev_exists(struct bch_sb *sb,
+				   unsigned dev)
+{
+	if (dev < sb->nr_devices) {
+	struct bch_member m = bch2_sb_member_get(sb, dev);
+		return bch2_member_exists(&m);
+	}
+	return false;
+}
+
+static inline struct bch_member_cpu bch2_mi_to_cpu(struct bch_member *mi)
+{
+	return (struct bch_member_cpu) {
+		.nbuckets	= le64_to_cpu(mi->nbuckets),
+		.first_bucket	= le16_to_cpu(mi->first_bucket),
+		.bucket_size	= le16_to_cpu(mi->bucket_size),
+		.group		= BCH_MEMBER_GROUP(mi),
+		.state		= BCH_MEMBER_STATE(mi),
+		.discard	= BCH_MEMBER_DISCARD(mi),
+		.data_allowed	= BCH_MEMBER_DATA_ALLOWED(mi),
+		.durability	= BCH_MEMBER_DURABILITY(mi)
+			? BCH_MEMBER_DURABILITY(mi) - 1
+			: 1,
+		.freespace_initialized = BCH_MEMBER_FREESPACE_INITIALIZED(mi),
+		.valid		= bch2_member_exists(mi),
+	};
+}
+
+void bch2_sb_members_from_cpu(struct bch_fs *);
+
 #endif /* _BCACHEFS_SB_MEMBERS_H */
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 332d41e1c0a3..64e861b87535 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -805,7 +805,12 @@ static void write_super_endio(struct bio *bio)
 
 	/* XXX: return errors directly */
 
-	if (bch2_dev_io_err_on(bio->bi_status, ca, "superblock write error: %s",
+	if (bch2_dev_io_err_on(bio->bi_status, ca,
+			       bio_data_dir(bio)
+			       ? BCH_MEMBER_ERROR_write
+			       : BCH_MEMBER_ERROR_read,
+			       "superblock %s error: %s",
+			       bio_data_dir(bio) ? "write" : "read",
 			       bch2_blk_status_to_str(bio->bi_status)))
 		ca->sb_write_error = 1;
 
@@ -892,7 +897,7 @@ int bch2_write_super(struct bch_fs *c)
 	SET_BCH_SB_BIG_ENDIAN(c->disk_sb.sb, CPU_BIG_ENDIAN);
 
 	bch2_sb_counters_from_cpu(c);
-	bch_members_cpy_v2_v1(&c->disk_sb);
+	bch2_sb_members_cpy_v2_v1(&c->disk_sb);
 
 	for_each_online_member(ca, c, i)
 		bch2_sb_from_fs(c, ca);
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index b0d8584f475f..5d079dd12f95 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -78,41 +78,6 @@ static inline void bch2_check_set_feature(struct bch_fs *c, unsigned feat)
 		__bch2_check_set_feature(c, feat);
 }
 
-/* BCH_SB_FIELD_members_v1: */
-
-static inline bool bch2_member_exists(struct bch_member *m)
-{
-	return !bch2_is_zero(&m->uuid, sizeof(m->uuid));
-}
-
-static inline bool bch2_dev_exists(struct bch_sb *sb,
-				   unsigned dev)
-{
-	if (dev < sb->nr_devices) {
-	struct bch_member m = bch2_sb_member_get(sb, dev);
-		return bch2_member_exists(&m);
-	}
-	return false;
-}
-
-static inline struct bch_member_cpu bch2_mi_to_cpu(struct bch_member *mi)
-{
-	return (struct bch_member_cpu) {
-		.nbuckets	= le64_to_cpu(mi->nbuckets),
-		.first_bucket	= le16_to_cpu(mi->first_bucket),
-		.bucket_size	= le16_to_cpu(mi->bucket_size),
-		.group		= BCH_MEMBER_GROUP(mi),
-		.state		= BCH_MEMBER_STATE(mi),
-		.discard	= BCH_MEMBER_DISCARD(mi),
-		.data_allowed	= BCH_MEMBER_DATA_ALLOWED(mi),
-		.durability	= BCH_MEMBER_DURABILITY(mi)
-			? BCH_MEMBER_DURABILITY(mi) - 1
-			: 1,
-		.freespace_initialized = BCH_MEMBER_FREESPACE_INITIALIZED(mi),
-		.valid		= bch2_member_exists(mi),
-	};
-}
-
 void bch2_sb_maybe_downgrade(struct bch_fs *);
 void bch2_sb_upgrade(struct bch_fs *, unsigned);
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index ce59018b27ac..7c129efa7cf0 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1131,6 +1131,7 @@ static struct bch_dev *__bch2_dev_alloc(struct bch_fs *c,
 					struct bch_member *member)
 {
 	struct bch_dev *ca;
+	unsigned i;
 
 	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 	if (!ca)
@@ -1148,6 +1149,10 @@ static struct bch_dev *__bch2_dev_alloc(struct bch_fs *c,
 	bch2_time_stats_init(&ca->io_latency[WRITE]);
 
 	ca->mi = bch2_mi_to_cpu(member);
+
+	for (i = 0; i < ARRAY_SIZE(member->errors); i++)
+		atomic64_set(&ca->errors[i], le64_to_cpu(member->errors[i]));
+
 	ca->uuid = member->uuid;
 
 	ca->nr_btree_reserve = DIV_ROUND_UP(BTREE_NODE_RESERVE,
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index db2727e5cc5f..59de78e5fbb6 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -149,7 +149,8 @@ read_attribute(bucket_size);
 read_attribute(first_bucket);
 read_attribute(nbuckets);
 rw_attribute(durability);
-read_attribute(iodone);
+read_attribute(io_done);
+read_attribute(io_errors);
 
 read_attribute(io_latency_read);
 read_attribute(io_latency_write);
@@ -880,7 +881,7 @@ static const char * const bch2_rw[] = {
 	NULL
 };
 
-static void dev_iodone_to_text(struct printbuf *out, struct bch_dev *ca)
+static void dev_io_done_to_text(struct printbuf *out, struct bch_dev *ca)
 {
 	int rw, i;
 
@@ -894,6 +895,18 @@ static void dev_iodone_to_text(struct printbuf *out, struct bch_dev *ca)
 	}
 }
 
+static void dev_io_errors_to_text(struct printbuf *out, struct bch_dev *ca)
+{
+	printbuf_tabstop_push(out, 12);
+
+	for (unsigned i = 0; i < BCH_MEMBER_ERROR_NR; i++) {
+		prt_printf(out, "%s:", bch2_member_error_strs[i]);
+		prt_tab(out);
+		prt_u64(out, atomic64_read(&ca->errors[i]));
+		prt_newline(out);
+	}
+}
+
 SHOW(bch2_dev)
 {
 	struct bch_dev *ca = container_of(kobj, struct bch_dev, kobj);
@@ -923,8 +936,11 @@ SHOW(bch2_dev)
 		prt_char(out, '\n');
 	}
 
-	if (attr == &sysfs_iodone)
-		dev_iodone_to_text(out, ca);
+	if (attr == &sysfs_io_done)
+		dev_io_done_to_text(out, ca);
+
+	if (attr == &sysfs_io_errors)
+		dev_io_errors_to_text(out, ca);
 
 	sysfs_print(io_latency_read,		atomic64_read(&ca->cur_latency[READ]));
 	sysfs_print(io_latency_write,		atomic64_read(&ca->cur_latency[WRITE]));
@@ -1008,7 +1024,8 @@ struct attribute *bch2_dev_files[] = {
 	&sysfs_label,
 
 	&sysfs_has_data,
-	&sysfs_iodone,
+	&sysfs_io_done,
+	&sysfs_io_errors,
 
 	&sysfs_io_latency_read,
 	&sysfs_io_latency_write,
-- 
2.42.0

