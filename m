Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0312C25B6E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 26 Oct 2023 19:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjJZTPH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 26 Oct 2023 15:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjJZTPC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 26 Oct 2023 15:15:02 -0400
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [IPv6:2001:41d0:203:375::af])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9C10E5
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Oct 2023 12:14:43 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698347681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ezODqgR79M9c97Dnl82my6sH9Y1AJRitRqSpCNpxuxI=;
        b=qpfSewWBMCR8C+H29cjdfeJbUCjBMD9UOc+Khsmni4aZlKrjAo2fVtlLeWCBLRe8a6GhHP
        FHJU4bOu0MrYBFwuYyvsnEQ2W7XklZjoYXrHQRk1DxQb646VJ1bUKC6Zv00N6Z4v2ifaS9
        34pQQPky3YBaw6w5Q3gQAI4CfFBH9I4=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] bcachefs: bch_sb_field_errors
Date:   Thu, 26 Oct 2023 15:14:31 -0400
Message-ID: <20231026191434.2976460-3-kent.overstreet@linux.dev>
In-Reply-To: <20231026191434.2976460-1-kent.overstreet@linux.dev>
References: <20231026191434.2976460-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Add a new superblock section to keep counts of errors seen since
filesystem creation: we'll be addingcounters for every distinct fsck
error.

The new superblock section has entries of the for [ id, count,
time_of_last_error ]; this is intended to let us see what errors are
occuring - and getting fixed - via show-super output.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/Makefile          |   1 +
 fs/bcachefs/bcachefs.h        |  14 ++-
 fs/bcachefs/bcachefs_format.h |  14 ++-
 fs/bcachefs/errcode.h         |   1 +
 fs/bcachefs/error.c           |  22 ++---
 fs/bcachefs/sb-errors.c       | 175 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/sb-errors.h       |  26 +++++
 fs/bcachefs/sb-errors_types.h |  16 ++++
 fs/bcachefs/sb-members.c      |   2 +-
 fs/bcachefs/sb-members.h      |   2 +-
 fs/bcachefs/super-io.c        |   3 +
 fs/bcachefs/super-io.h        |   5 +
 fs/bcachefs/super.c           |  12 ++-
 13 files changed, 270 insertions(+), 23 deletions(-)
 create mode 100644 fs/bcachefs/sb-errors.c
 create mode 100644 fs/bcachefs/sb-errors.h
 create mode 100644 fs/bcachefs/sb-errors_types.h

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index e8e49f96e360..3eccbcc646aa 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -69,6 +69,7 @@ bcachefs-y		:=	\
 	reflink.o		\
 	replicas.o		\
 	sb-clean.o		\
+	sb-errors.o		\
 	sb-members.o		\
 	siphash.o		\
 	six.o			\
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 0ae14a69dfde..9cb8684959ee 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -209,6 +209,7 @@
 #include "nocow_locking_types.h"
 #include "opts.h"
 #include "recovery_types.h"
+#include "sb-errors_types.h"
 #include "seqmutex.h"
 #include "util.h"
 
@@ -992,11 +993,6 @@ struct bch_fs {
 	struct bio_set		dio_read_bioset;
 	struct bio_set		nocow_flush_bioset;
 
-	/* ERRORS */
-	struct list_head	fsck_errors;
-	struct mutex		fsck_error_lock;
-	bool			fsck_alloc_err;
-
 	/* QUOTAS */
 	struct bch_memquota_type quotas[QTYP_NR];
 
@@ -1045,6 +1041,14 @@ struct bch_fs {
 	struct bch2_time_stats	times[BCH_TIME_STAT_NR];
 
 	struct btree_transaction_stats btree_transaction_stats[BCH_TRANSACTIONS_NR];
+
+	/* ERRORS */
+	struct list_head	fsck_error_msgs;
+	struct mutex		fsck_error_msgs_lock;
+	bool			fsck_alloc_msgs_err;
+
+	bch_sb_errors_cpu	fsck_error_counts;
+	struct mutex		fsck_error_counts_lock;
 };
 
 extern struct wait_queue_head bch2_read_only_wait;
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index c5340d7aa3fe..6f415e280636 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1218,7 +1218,8 @@ struct bch_sb_field {
 	x(journal_seq_blacklist, 8)		\
 	x(journal_v2,	9)			\
 	x(counters,	10)			\
-	x(members_v2,	11)
+	x(members_v2,	11)			\
+	x(errors,	12)
 
 enum bch_sb_field_type {
 #define x(f, nr)	BCH_SB_FIELD_##f = nr,
@@ -1619,6 +1620,17 @@ struct bch_sb_field_journal_seq_blacklist {
 	__u64			_data[];
 };
 
+struct bch_sb_field_errors {
+	struct bch_sb_field	field;
+	struct bch_sb_field_error_entry {
+		__le64		v;
+		__le64		last_error_time;
+	}			entries[];
+};
+
+LE64_BITMASK(BCH_SB_ERROR_ENTRY_ID,	struct bch_sb_field_error_entry, v,  0, 16);
+LE64_BITMASK(BCH_SB_ERROR_ENTRY_NR,	struct bch_sb_field_error_entry, v, 16, 64);
+
 /* Superblock: */
 
 /*
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 3e9f09cea6c7..2a11f32cf30a 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -213,6 +213,7 @@
 	x(BCH_ERR_invalid_sb,		invalid_sb_crypt)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_clean)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_quota)			\
+	x(BCH_ERR_invalid_sb,		invalid_sb_errors)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_opt_compression)		\
 	x(BCH_ERR_invalid,		invalid_bkey)				\
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 4dbfe31197bc..d759afc910fc 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -117,27 +117,27 @@ static struct fsck_err_state *fsck_err_get(struct bch_fs *c, const char *fmt)
 	if (test_bit(BCH_FS_FSCK_DONE, &c->flags))
 		return NULL;
 
-	list_for_each_entry(s, &c->fsck_errors, list)
+	list_for_each_entry(s, &c->fsck_error_msgs, list)
 		if (s->fmt == fmt) {
 			/*
 			 * move it to the head of the list: repeated fsck errors
 			 * are common
 			 */
-			list_move(&s->list, &c->fsck_errors);
+			list_move(&s->list, &c->fsck_error_msgs);
 			return s;
 		}
 
 	s = kzalloc(sizeof(*s), GFP_NOFS);
 	if (!s) {
-		if (!c->fsck_alloc_err)
+		if (!c->fsck_alloc_msgs_err)
 			bch_err(c, "kmalloc err, cannot ratelimit fsck errs");
-		c->fsck_alloc_err = true;
+		c->fsck_alloc_msgs_err = true;
 		return NULL;
 	}
 
 	INIT_LIST_HEAD(&s->list);
 	s->fmt = fmt;
-	list_add(&s->list, &c->fsck_errors);
+	list_add(&s->list, &c->fsck_error_msgs);
 	return s;
 }
 
@@ -153,7 +153,7 @@ int bch2_fsck_err(struct bch_fs *c, unsigned flags, const char *fmt, ...)
 	prt_vprintf(out, fmt, args);
 	va_end(args);
 
-	mutex_lock(&c->fsck_error_lock);
+	mutex_lock(&c->fsck_error_msgs_lock);
 	s = fsck_err_get(c, fmt);
 	if (s) {
 		/*
@@ -163,7 +163,7 @@ int bch2_fsck_err(struct bch_fs *c, unsigned flags, const char *fmt, ...)
 		 */
 		if (s->last_msg && !strcmp(buf.buf, s->last_msg)) {
 			ret = s->ret;
-			mutex_unlock(&c->fsck_error_lock);
+			mutex_unlock(&c->fsck_error_msgs_lock);
 			printbuf_exit(&buf);
 			return ret;
 		}
@@ -258,7 +258,7 @@ int bch2_fsck_err(struct bch_fs *c, unsigned flags, const char *fmt, ...)
 	if (s)
 		s->ret = ret;
 
-	mutex_unlock(&c->fsck_error_lock);
+	mutex_unlock(&c->fsck_error_msgs_lock);
 
 	printbuf_exit(&buf);
 
@@ -279,9 +279,9 @@ void bch2_flush_fsck_errs(struct bch_fs *c)
 {
 	struct fsck_err_state *s, *n;
 
-	mutex_lock(&c->fsck_error_lock);
+	mutex_lock(&c->fsck_error_msgs_lock);
 
-	list_for_each_entry_safe(s, n, &c->fsck_errors, list) {
+	list_for_each_entry_safe(s, n, &c->fsck_error_msgs, list) {
 		if (s->ratelimited && s->last_msg)
 			bch_err(c, "Saw %llu errors like:\n    %s", s->nr, s->last_msg);
 
@@ -290,5 +290,5 @@ void bch2_flush_fsck_errs(struct bch_fs *c)
 		kfree(s);
 	}
 
-	mutex_unlock(&c->fsck_error_lock);
+	mutex_unlock(&c->fsck_error_msgs_lock);
 }
diff --git a/fs/bcachefs/sb-errors.c b/fs/bcachefs/sb-errors.c
new file mode 100644
index 000000000000..3d66f15ae8f5
--- /dev/null
+++ b/fs/bcachefs/sb-errors.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "bcachefs.h"
+#include "sb-errors.h"
+#include "super-io.h"
+
+static const char * const bch2_sb_error_strs[] = {
+#define x(t, n, ...) [n] = #t,
+	BCH_SB_ERRS()
+	NULL
+};
+
+static void bch2_sb_error_id_to_text(struct printbuf *out, enum bch_sb_error_id id)
+{
+	if (id < BCH_SB_ERR_MAX)
+		prt_str(out, bch2_sb_error_strs[id]);
+	else
+		prt_printf(out, "(unknown error %u)", id);
+}
+
+static inline unsigned bch2_sb_field_errors_nr_entries(struct bch_sb_field_errors *e)
+{
+	return e
+		? (bch2_sb_field_bytes(&e->field) - sizeof(*e)) / sizeof(e->entries[0])
+		: 0;
+}
+
+static inline unsigned bch2_sb_field_errors_u64s(unsigned nr)
+{
+	return (sizeof(struct bch_sb_field_errors) +
+		sizeof(struct bch_sb_field_error_entry) * nr) / sizeof(u64);
+}
+
+static int bch2_sb_errors_validate(struct bch_sb *sb, struct bch_sb_field *f,
+				   struct printbuf *err)
+{
+	struct bch_sb_field_errors *e = field_to_type(f, errors);
+	unsigned i, nr = bch2_sb_field_errors_nr_entries(e);
+
+	for (i = 0; i < nr; i++) {
+		if (!BCH_SB_ERROR_ENTRY_NR(&e->entries[i])) {
+			prt_printf(err, "entry with count 0 (id ");
+			bch2_sb_error_id_to_text(err, BCH_SB_ERROR_ENTRY_ID(&e->entries[i]));
+			prt_printf(err, ")");
+			return -BCH_ERR_invalid_sb_errors;
+		}
+
+		if (i + 1 < nr &&
+		    BCH_SB_ERROR_ENTRY_ID(&e->entries[i]) >=
+		    BCH_SB_ERROR_ENTRY_ID(&e->entries[i + 1])) {
+			prt_printf(err, "entries out of order");
+			return -BCH_ERR_invalid_sb_errors;
+		}
+	}
+
+	return 0;
+}
+
+static void bch2_sb_errors_to_text(struct printbuf *out, struct bch_sb *sb,
+				   struct bch_sb_field *f)
+{
+	struct bch_sb_field_errors *e = field_to_type(f, errors);
+	unsigned i, nr = bch2_sb_field_errors_nr_entries(e);
+	u64 now = ktime_get_real_seconds();
+
+	if (out->nr_tabstops <= 1)
+		printbuf_tabstop_push(out, 16);
+
+	for (i = 0; i < nr; i++) {
+		bch2_sb_error_id_to_text(out, BCH_SB_ERROR_ENTRY_ID(&e->entries[i]));
+		prt_tab(out);
+		prt_u64(out, BCH_SB_ERROR_ENTRY_NR(&e->entries[i]));
+		prt_tab(out);
+		bch2_pr_time_units(out, (now - le64_to_cpu(e->entries[i].last_error_time)) *
+				   NSEC_PER_SEC);
+		prt_str(out, " ago");
+		prt_newline(out);
+	}
+}
+
+const struct bch_sb_field_ops bch_sb_field_ops_errors = {
+	.validate	= bch2_sb_errors_validate,
+	.to_text	= bch2_sb_errors_to_text,
+};
+
+void bch2_sb_error_count(struct bch_fs *c, enum bch_sb_error_id err)
+{
+	bch_sb_errors_cpu *e = &c->fsck_error_counts;
+	struct bch_sb_error_entry_cpu n = {
+		.id = err,
+		.nr = 1,
+		.last_error_time = ktime_get_real_seconds()
+	};
+	unsigned i;
+
+	mutex_lock(&c->fsck_error_counts_lock);
+	for (i = 0; i < e->nr; i++) {
+		if (err == e->data[i].id) {
+			e->data[i].nr++;
+			e->data[i].last_error_time = n.last_error_time;
+			goto out;
+		}
+		if (err < e->data[i].id)
+			break;
+	}
+
+	if (darray_make_room(e, 1))
+		goto out;
+
+	darray_insert_item(e, i, n);
+out:
+	mutex_unlock(&c->fsck_error_counts_lock);
+}
+
+void bch2_sb_errors_from_cpu(struct bch_fs *c)
+{
+	bch_sb_errors_cpu *src = &c->fsck_error_counts;
+	struct bch_sb_field_errors *dst =
+		bch2_sb_field_resize(&c->disk_sb, errors,
+				     bch2_sb_field_errors_u64s(src->nr));
+	unsigned i;
+
+	if (!dst)
+		return;
+
+	for (i = 0; i < src->nr; i++) {
+		SET_BCH_SB_ERROR_ENTRY_ID(&dst->entries[i], src->data[i].id);
+		SET_BCH_SB_ERROR_ENTRY_NR(&dst->entries[i], src->data[i].nr);
+		dst->entries[i].last_error_time = cpu_to_le64(src->data[i].last_error_time);
+	}
+}
+
+static int bch2_sb_errors_to_cpu(struct bch_fs *c)
+{
+	struct bch_sb_field_errors *src = bch2_sb_field_get(c->disk_sb.sb, errors);
+	bch_sb_errors_cpu *dst = &c->fsck_error_counts;
+	unsigned i, nr = bch2_sb_field_errors_nr_entries(src);
+	int ret;
+
+	if (!nr)
+		return 0;
+
+	mutex_lock(&c->fsck_error_counts_lock);
+	ret = darray_make_room(dst, nr);
+	if (ret)
+		goto err;
+
+	dst->nr = nr;
+
+	for (i = 0; i < nr; i++) {
+		dst->data[i].id = BCH_SB_ERROR_ENTRY_ID(&src->entries[i]);
+		dst->data[i].nr = BCH_SB_ERROR_ENTRY_NR(&src->entries[i]);
+		dst->data[i].last_error_time = le64_to_cpu(src->entries[i].last_error_time);
+	}
+err:
+	mutex_unlock(&c->fsck_error_counts_lock);
+
+	return ret;
+}
+
+void bch2_fs_sb_errors_exit(struct bch_fs *c)
+{
+	darray_exit(&c->fsck_error_counts);
+}
+
+void bch2_fs_sb_errors_init_early(struct bch_fs *c)
+{
+	mutex_init(&c->fsck_error_counts_lock);
+	darray_init(&c->fsck_error_counts);
+}
+
+int bch2_fs_sb_errors_init(struct bch_fs *c)
+{
+	return bch2_sb_errors_to_cpu(c);
+}
diff --git a/fs/bcachefs/sb-errors.h b/fs/bcachefs/sb-errors.h
new file mode 100644
index 000000000000..7f8172821240
--- /dev/null
+++ b/fs/bcachefs/sb-errors.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_SB_ERRORS_H
+#define _BCACHEFS_SB_ERRORS_H
+
+#include "sb-errors_types.h"
+
+#define BCH_SB_ERRS()
+
+enum bch_sb_error_id {
+#define x(t, n) BCH_FSCK_ERR_##t = n,
+	BCH_SB_ERRS()
+#undef x
+	BCH_SB_ERR_MAX
+};
+
+extern const struct bch_sb_field_ops bch_sb_field_ops_errors;
+
+void bch2_sb_error_count(struct bch_fs *, enum bch_sb_error_id);
+
+void bch2_sb_errors_from_cpu(struct bch_fs *);
+
+void bch2_fs_sb_errors_exit(struct bch_fs *);
+void bch2_fs_sb_errors_init_early(struct bch_fs *);
+int bch2_fs_sb_errors_init(struct bch_fs *);
+
+#endif /* _BCACHEFS_SB_ERRORS_H */
diff --git a/fs/bcachefs/sb-errors_types.h b/fs/bcachefs/sb-errors_types.h
new file mode 100644
index 000000000000..b1c099843a39
--- /dev/null
+++ b/fs/bcachefs/sb-errors_types.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_SB_ERRORS_TYPES_H
+#define _BCACHEFS_SB_ERRORS_TYPES_H
+
+#include "darray.h"
+
+struct bch_sb_error_entry_cpu {
+	u64			id:16,
+				nr:48;
+	u64			last_error_time;
+};
+
+typedef DARRAY(struct bch_sb_error_entry_cpu) bch_sb_errors_cpu;
+
+#endif /* _BCACHEFS_SB_ERRORS_TYPES_H */
+
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index def420684fa3..7df5b81cf410 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -84,7 +84,7 @@ static int sb_members_v2_resize_entries(struct bch_fs *c)
 	return 0;
 }
 
-int bch2_members_v2_init(struct bch_fs *c)
+int bch2_sb_members_v2_init(struct bch_fs *c)
 {
 	struct bch_sb_field_members_v1 *mi1;
 	struct bch_sb_field_members_v2 *mi2;
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index edbdfb896c14..f79e64557b42 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -4,7 +4,7 @@
 
 extern char * const bch2_member_error_strs[];
 
-int bch2_members_v2_init(struct bch_fs *c);
+int bch2_sb_members_v2_init(struct bch_fs *c);
 int bch2_sb_members_cpy_v2_v1(struct bch_sb_handle *disk_sb);
 struct bch_member *bch2_members_v2_get_mut(struct bch_sb *sb, int i);
 struct bch_member bch2_sb_member_get(struct bch_sb *sb, int i);
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 64e861b87535..83bdb4368289 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -13,6 +13,7 @@
 #include "replicas.h"
 #include "quota.h"
 #include "sb-clean.h"
+#include "sb-errors.h"
 #include "sb-members.h"
 #include "super-io.h"
 #include "super.h"
@@ -897,7 +898,9 @@ int bch2_write_super(struct bch_fs *c)
 	SET_BCH_SB_BIG_ENDIAN(c->disk_sb.sb, CPU_BIG_ENDIAN);
 
 	bch2_sb_counters_from_cpu(c);
+	bch2_sb_members_from_cpu(c);
 	bch2_sb_members_cpy_v2_v1(&c->disk_sb);
+	bch2_sb_errors_from_cpu(c);
 
 	for_each_online_member(ca, c, i)
 		bch2_sb_from_fs(c, ca);
diff --git a/fs/bcachefs/super-io.h b/fs/bcachefs/super-io.h
index 5d079dd12f95..f5abd102bff7 100644
--- a/fs/bcachefs/super-io.h
+++ b/fs/bcachefs/super-io.h
@@ -23,6 +23,11 @@ u64 bch2_upgrade_recovery_passes(struct bch_fs *c,
 				 unsigned,
 				 unsigned);
 
+static inline size_t bch2_sb_field_bytes(struct bch_sb_field *f)
+{
+	return le32_to_cpu(f->u64s) * sizeof(u64);
+}
+
 #define field_to_type(_f, _name)					\
 	container_of_or_null(_f, struct bch_sb_field_##_name, field)
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 7c129efa7cf0..ffe5558bbf03 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -49,6 +49,7 @@
 #include "recovery.h"
 #include "replicas.h"
 #include "sb-clean.h"
+#include "sb-errors.h"
 #include "sb-members.h"
 #include "snapshot.h"
 #include "subvolume.h"
@@ -400,7 +401,7 @@ static int __bch2_fs_read_write(struct bch_fs *c, bool early)
 
 	bch_info(c, "going read-write");
 
-	ret = bch2_members_v2_init(c);
+	ret = bch2_sb_members_v2_init(c);
 	if (ret)
 		goto err;
 
@@ -481,6 +482,7 @@ static void __bch2_fs_free(struct bch_fs *c)
 		bch2_time_stats_exit(&c->times[i]);
 
 	bch2_free_pending_node_rewrites(c);
+	bch2_fs_sb_errors_exit(c);
 	bch2_fs_counters_exit(c);
 	bch2_fs_snapshots_exit(c);
 	bch2_fs_quota_exit(c);
@@ -713,6 +715,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	bch2_fs_quota_init(c);
 	bch2_fs_ec_init_early(c);
 	bch2_fs_move_init(c);
+	bch2_fs_sb_errors_init_early(c);
 
 	INIT_LIST_HEAD(&c->list);
 
@@ -729,8 +732,8 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
 	INIT_LIST_HEAD(&c->journal_iters);
 
-	INIT_LIST_HEAD(&c->fsck_errors);
-	mutex_init(&c->fsck_error_lock);
+	INIT_LIST_HEAD(&c->fsck_error_msgs);
+	mutex_init(&c->fsck_error_msgs_lock);
 
 	seqcount_init(&c->gc_pos_lock);
 
@@ -840,6 +843,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	}
 
 	ret = bch2_fs_counters_init(c) ?:
+	    bch2_fs_sb_errors_init(c) ?:
 	    bch2_io_clock_init(&c->io_clock[READ]) ?:
 	    bch2_io_clock_init(&c->io_clock[WRITE]) ?:
 	    bch2_fs_journal_init(&c->journal) ?:
@@ -942,7 +946,7 @@ int bch2_fs_start(struct bch_fs *c)
 
 	mutex_lock(&c->sb_lock);
 
-	ret = bch2_members_v2_init(c);
+	ret = bch2_sb_members_v2_init(c);
 	if (ret) {
 		mutex_unlock(&c->sb_lock);
 		goto err;
-- 
2.42.0

