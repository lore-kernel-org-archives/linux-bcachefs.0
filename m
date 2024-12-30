Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECEA19A298
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594987; cv=none; b=ZZk/qszpytpI/E5Ltug1pcYpd0WbaDmum4wJ7jlpo6tFEW0GFa+yuKGbvs5HCgn8m/vDnHXjLeueeuj0ERrDtzIsU7i4d/7D+Caga5A9JHKHuXx7/6XLhplIkRq7zuEa0m/twijBiWOkOu5p/ZesTc34H6SVEoYMri9/WQizpqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594987; c=relaxed/simple;
	bh=wyZbFTBNzoRg+8kBZ5EaOS5AgrGpWZiZUhdFfd7N6CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs+PugRg+9MLkeEqv6Q6fkoiY505ufoZBXYdA5zzSLH/3O7B46q62++Me7JmTfmw+7IPwxMUlYn45e4opQOBhs+XhHa9eUrCTX+5UzixOutYlIgCrqSMskLJ39TqRhZAj8dvXUOOd+QmnAbfiEgr/G1oLX5Kjw6O0dqgKmNf+aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DF/YPOcY; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DF/YPOcY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8cxSKTM0RnjMCvbtdKoOraYJDy1xrvCpL7CaGkjD7Pw=;
	b=DF/YPOcYS++8wz4DsH9tMOmHRm8ns8PwMBhVA5EE/HJdUGSS+qjEvoyW5HYcAHMWLMeXiP
	GgpIY2v28qbORDz7Ohf95DF09zNrDUdLLB/gaGhU9RS6hkxPbnwmSOO9suWUJwUDsykDgG
	u20CXoeFp219KAxxTqrV3hkE8R4Ls8o=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/11] bcachefs: bch2_btree_node_scrub()
Date: Mon, 30 Dec 2024 16:42:47 -0500
Message-ID: <20241230214249.242966-9-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a function for scrubbing btree nodes - reading them in, and kicking
off a rewrite if there's an error.

The btree_node_read_done() checks have to be duplicated because we're
not using a pointer to a struct btree - the btree node might already be
in cache, and we need to check a specific replica, which might not be
the one we previously read from.

This will be used in the next patch implementing high-level scrub.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |   3 +-
 fs/bcachefs/btree_io.c | 185 +++++++++++++++++++++++++++++++++++++++++
 fs/bcachefs/btree_io.h |   3 +
 fs/bcachefs/errcode.h  |   1 +
 4 files changed, 191 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 161cf2f05d2a..13acfbf3852a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -687,7 +687,8 @@ struct btree_trans_buf {
 	x(gc_gens)							\
 	x(snapshot_delete_pagecache)					\
 	x(sysfs)							\
-	x(btree_write_buffer)
+	x(btree_write_buffer)						\
+	x(btree_node_scrub)
 
 enum bch_write_ref {
 #define x(n) BCH_WRITE_REF_##n,
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 73f75e38da7f..13ab827ddab5 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "bcachefs.h"
+#include "bkey_buf.h"
 #include "bkey_methods.h"
 #include "bkey_sort.h"
 #include "btree_cache.h"
@@ -1811,6 +1812,190 @@ int bch2_btree_root_read(struct bch_fs *c, enum btree_id id,
 	return bch2_trans_run(c, __bch2_btree_root_read(trans, id, k, level));
 }
 
+struct btree_node_scrub {
+	struct bch_fs		*c;
+	struct bch_dev		*ca;
+	void			*buf;
+	bool			used_mempool;
+	unsigned		written;
+
+	enum btree_id		btree;
+	unsigned		level;
+	struct bkey_buf		key;
+	__le64			seq;
+
+	struct work_struct	work;
+	struct bio		bio;
+};
+
+static bool btree_node_scrub_check(struct bch_fs *c, struct btree_node *data, unsigned ptr_written,
+				   struct printbuf *err)
+{
+	unsigned written = 0;
+
+	if (le64_to_cpu(data->magic) != bset_magic(c)) {
+		prt_printf(err, "bad magic: want %llx, got %llx",
+			   bset_magic(c), le64_to_cpu(data->magic));
+		return false;
+	}
+
+	while (written < (ptr_written ?: btree_sectors(c))) {
+		struct btree_node_entry *bne;
+		struct bset *i;
+		bool first = !written;
+
+		if (first) {
+			bne = NULL;
+			i = &data->keys;
+		} else {
+			bne = (void *) data + (written << 9);
+			i = &bne->keys;
+
+			if (!ptr_written && i->seq != data->keys.seq)
+				break;
+		}
+
+		struct nonce nonce = btree_nonce(i, written << 9);
+		bool good_csum_type = bch2_checksum_type_valid(c, BSET_CSUM_TYPE(i));
+
+		if (first) {
+			if (good_csum_type) {
+				struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, data);
+				if (bch2_crc_cmp(data->csum, csum)) {
+					bch2_csum_err_msg(err, BSET_CSUM_TYPE(i), data->csum, csum);
+					return false;
+				}
+			}
+
+			written += vstruct_sectors(data, c->block_bits);
+		} else {
+			if (good_csum_type) {
+				struct bch_csum csum = csum_vstruct(c, BSET_CSUM_TYPE(i), nonce, bne);
+				if (bch2_crc_cmp(bne->csum, csum)) {
+					bch2_csum_err_msg(err, BSET_CSUM_TYPE(i), bne->csum, csum);
+					return false;
+				}
+			}
+
+			written += vstruct_sectors(bne, c->block_bits);
+		}
+	}
+
+	return true;
+}
+
+static void btree_node_scrub_work(struct work_struct *work)
+{
+	struct btree_node_scrub *scrub = container_of(work, struct btree_node_scrub, work);
+	struct bch_fs *c = scrub->c;
+	struct printbuf err = PRINTBUF;
+
+	__bch2_btree_pos_to_text(&err, c, scrub->btree, scrub->level,
+				 bkey_i_to_s_c(scrub->key.k));
+	prt_newline(&err);
+
+	if (!btree_node_scrub_check(c, scrub->buf, scrub->written, &err)) {
+		struct btree_trans *trans = bch2_trans_get(c);
+
+		struct btree_iter iter;
+		bch2_trans_node_iter_init(trans, &iter, scrub->btree,
+					  scrub->key.k->k.p, 0, scrub->level - 1, 0);
+
+		struct btree *b;
+		int ret = lockrestart_do(trans, PTR_ERR_OR_ZERO(b = bch2_btree_iter_peek_node(&iter)));
+		if (ret)
+			goto err;
+
+		if (bkey_i_to_btree_ptr_v2(&b->key)->v.seq == scrub->seq) {
+			bch_err(c, "error validating btree node during scrub on %s at btree %s",
+				scrub->ca->name, err.buf);
+
+			ret = bch2_btree_node_rewrite(trans, &iter, b, 0);
+		}
+err:
+		bch2_trans_iter_exit(trans, &iter);
+		bch2_trans_begin(trans);
+		bch2_trans_put(trans);
+	}
+
+	printbuf_exit(&err);
+	bch2_bkey_buf_exit(&scrub->key, c);;
+	btree_bounce_free(c, c->opts.btree_node_size, scrub->used_mempool, scrub->buf);
+	percpu_ref_put(&scrub->ca->io_ref);
+	kfree(scrub);
+	bch2_write_ref_put(c, BCH_WRITE_REF_btree_node_scrub);
+}
+
+static void btree_node_scrub_endio(struct bio *bio)
+{
+	struct btree_node_scrub *scrub = container_of(bio, struct btree_node_scrub, bio);
+
+	queue_work(scrub->c->btree_read_complete_wq, &scrub->work);
+}
+
+int bch2_btree_node_scrub(struct btree_trans *trans,
+			  enum btree_id btree, unsigned level,
+			  struct bkey_s_c k, unsigned dev)
+{
+	if (k.k->type != KEY_TYPE_btree_ptr_v2)
+		return 0;
+
+	struct bch_fs *c = trans->c;
+
+	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_node_scrub))
+		return -BCH_ERR_erofs_no_writes;
+
+	struct extent_ptr_decoded pick;
+	int ret = bch2_bkey_pick_read_device(c, k, NULL, &pick, dev);
+	if (ret <= 0)
+		goto err;
+
+	struct bch_dev *ca = bch2_dev_get_ioref(c, pick.ptr.dev, READ);
+	if (!ca) {
+		ret = -BCH_ERR_device_offline;
+		goto err;
+	}
+
+	bool used_mempool = false;
+	void *buf = btree_bounce_alloc(c, c->opts.btree_node_size, &used_mempool);
+
+	unsigned vecs = buf_pages(buf, c->opts.btree_node_size);
+
+	struct btree_node_scrub *scrub =
+		kzalloc(sizeof(*scrub) + sizeof(struct bio_vec) * vecs, GFP_KERNEL);
+	if (!scrub) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	scrub->c		= c;
+	scrub->ca		= ca;
+	scrub->buf		= buf;
+	scrub->used_mempool	= used_mempool;
+	scrub->written		= btree_ptr_sectors_written(k);
+
+	scrub->btree		= btree;
+	scrub->level		= level;
+	bch2_bkey_buf_init(&scrub->key);
+	bch2_bkey_buf_reassemble(&scrub->key, c, k);
+	scrub->seq		= bkey_s_c_to_btree_ptr_v2(k).v->seq;
+
+	INIT_WORK(&scrub->work, btree_node_scrub_work);
+
+	bio_init(&scrub->bio, ca->disk_sb.bdev, scrub->bio.bi_inline_vecs, vecs, REQ_OP_READ);
+	bch2_bio_map(&scrub->bio, scrub->buf, c->opts.btree_node_size);
+	scrub->bio.bi_iter.bi_sector	= pick.ptr.offset;
+	scrub->bio.bi_end_io		= btree_node_scrub_endio;
+	submit_bio(&scrub->bio);
+	return 0;
+err_free:
+	btree_bounce_free(c, c->opts.btree_node_size, used_mempool, buf);
+	percpu_ref_put(&ca->io_ref);
+err:
+	bch2_write_ref_put(c, BCH_WRITE_REF_btree_node_scrub);
+	return ret;
+}
+
 static void bch2_btree_complete_write(struct bch_fs *c, struct btree *b,
 				      struct btree_write *w)
 {
diff --git a/fs/bcachefs/btree_io.h b/fs/bcachefs/btree_io.h
index 6f9e4a6dacf7..75ead3815d67 100644
--- a/fs/bcachefs/btree_io.h
+++ b/fs/bcachefs/btree_io.h
@@ -132,6 +132,9 @@ void bch2_btree_node_read(struct btree_trans *, struct btree *, bool);
 int bch2_btree_root_read(struct bch_fs *, enum btree_id,
 			 const struct bkey_i *, unsigned);
 
+int bch2_btree_node_scrub(struct btree_trans *, enum btree_id, unsigned,
+			  struct bkey_s_c, unsigned);
+
 bool bch2_btree_post_write_cleanup(struct bch_fs *, struct btree *);
 
 enum btree_write_flags {
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 4590cd0c7c90..cae4fc3e8572 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -269,6 +269,7 @@
 	x(EIO,				invalidate_stripe_to_dev)		\
 	x(EIO,				no_encryption_key)			\
 	x(EIO,				insufficient_journal_devices)		\
+	x(EIO,				device_offline)				\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_fixable)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_want_retry)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_must_retry)		\
-- 
2.45.2

