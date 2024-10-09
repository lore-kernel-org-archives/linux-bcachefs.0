Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317D1E493C
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518083; cv=none; b=cC6HS7uVcd/nAU+kSYoKWtyoIS/vSenoTrTsWoB+ZjszeEY/65m2rNvxdGtmMJn7/r8JBQpkr8Aqj/r1dLT5JXRbRNtDhY6ZU3pc5SwHhN5yOxMNUGTLb1/beQkz0zl0tx04LB4ddWAKg0PdcsvUGn6ftYeyV7ujf3hz/G+TsYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518083; c=relaxed/simple;
	bh=l2Xvu3/JDLOv91zB4zXmu3zjwUdRRPdMw7zdrVNV90o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IEOAiUYrjPU7xdvK24QIl8TLDEBARhFK+tGlWlPna0f0L4ucyN7kjndqMlzvEuVOMZfHkrcJ/XWWHqv6HgxGZKxmLzuVLfv1JOEwMJYYM+D8oL5uDf1wWKE0IRQOE283h7K7sm3s7YDRYjNPQUXKxkO0B1A85zODkN2V1TEl9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hiku7mUn; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hiku7mUn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728518078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3fHqoe2Qa6hIj43D6ndPVcxxc8TymzqkxZhnaV6kTlc=;
	b=Hiku7mUnZZko5Lu8XQmIFKdY8s3j1NAuMBDlHxbowKds79v3SoaIPMtH8K468tBcvq8UpZ
	Vk31DhTTAu05Ki7DYfJGS9doFaAraJIFlCY4v3x7i+otNVIS1jiuyQpioiEMha/TbHalnv
	LCrjKDFy7x8UHoSOjc6232ffz6KlKeM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Disk accounting device validation fixes
Date: Wed,  9 Oct 2024 19:54:15 -0400
Message-ID: <20241009235415.2249794-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

- Fix failure to validate that accounting replicas entries point to
  valid devices: this wasn't a real bug since they'd be cleaned up by
  GC, but is still something we should know about

- Fix failure to validate that dev_data_type entries point to valid
  devices: this does fix a real bug, since bch2_accounting_read() would
  then try to copy the counters to that device and pop an inconsistent
  error when the device didn't exist

- Remove accounting entries that are zeroed or invalid: if we're not
  validating them we need to get rid of them: they might not exist in
  the superblock, so we need the to trigger the superblock mark path
  when they're readded.

  This fixes the replication.ktest rereplicate test, which was failing
  with "superblock not marked for replicas..."

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/disk_accounting.c  | 149 +++++++++++++++++++++++++--------
 fs/bcachefs/errcode.h          |   3 +-
 fs/bcachefs/sb-errors_format.h |   3 +-
 3 files changed, 118 insertions(+), 37 deletions(-)

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 9f3133e3e7e5..e309fb78529b 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -242,6 +242,14 @@ void bch2_accounting_swab(struct bkey_s k)
 		*p = swab64(*p);
 }
 
+static inline void __accounting_to_replicas(struct bch_replicas_entry_v1 *r,
+					    struct disk_accounting_pos acc)
+{
+	unsafe_memcpy(r, &acc.replicas,
+		      replicas_entry_bytes(&acc.replicas),
+		      "variable length struct");
+}
+
 static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struct bpos p)
 {
 	struct disk_accounting_pos acc_k;
@@ -249,9 +257,7 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc
 
 	switch (acc_k.type) {
 	case BCH_DISK_ACCOUNTING_replicas:
-		unsafe_memcpy(r, &acc_k.replicas,
-			      replicas_entry_bytes(&acc_k.replicas),
-			      "variable length struct");
+		__accounting_to_replicas(r, acc_k);
 		return true;
 	default:
 		return false;
@@ -608,6 +614,81 @@ static int accounting_read_key(struct btree_trans *trans, struct bkey_s_c k)
 	return ret;
 }
 
+static int bch2_disk_accounting_validate_late(struct btree_trans *trans,
+					      struct disk_accounting_pos acc,
+					      u64 *v, unsigned nr)
+{
+	struct bch_fs *c = trans->c;
+	struct printbuf buf = PRINTBUF;
+	int ret = 0, invalid_dev = -1;
+
+	switch (acc.type) {
+	case BCH_DISK_ACCOUNTING_replicas: {
+		struct bch_replicas_padded r;
+		__accounting_to_replicas(&r.e, acc);
+
+		for (unsigned i = 0; i < r.e.nr_devs; i++)
+			if (r.e.devs[i] != BCH_SB_MEMBER_INVALID &&
+			    !bch2_dev_exists(c, r.e.devs[i])) {
+				invalid_dev = r.e.devs[i];
+				goto invalid_device;
+			}
+
+		/*
+		 * All replicas entry checks except for invalid device are done
+		 * in bch2_accounting_validate
+		 */
+		BUG_ON(bch2_replicas_entry_validate(&r.e, c, &buf));
+
+		if (fsck_err_on(!bch2_replicas_marked_locked(c, &r.e),
+				trans, accounting_replicas_not_marked,
+				"accounting not marked in superblock replicas\n  %s",
+				(printbuf_reset(&buf),
+				 bch2_accounting_key_to_text(&buf, &acc),
+				 buf.buf))) {
+			/*
+			 * We're not RW yet and still single threaded, dropping
+			 * and retaking lock is ok:
+			 */
+			percpu_up_write(&c->mark_lock);
+			ret = bch2_mark_replicas(c, &r.e);
+			if (ret)
+				goto fsck_err;
+			percpu_down_write(&c->mark_lock);
+		}
+		break;
+	}
+
+	case BCH_DISK_ACCOUNTING_dev_data_type:
+		if (!bch2_dev_exists(c, acc.dev_data_type.dev)) {
+			invalid_dev = acc.dev_data_type.dev;
+			goto invalid_device;
+		}
+		break;
+	}
+
+fsck_err:
+	printbuf_exit(&buf);
+	return ret;
+invalid_device:
+	if (fsck_err(trans, accounting_to_invalid_device,
+		     "accounting entry points to invalid device %i\n  %s",
+		     invalid_dev,
+		     (printbuf_reset(&buf),
+		      bch2_accounting_key_to_text(&buf, &acc),
+		      buf.buf))) {
+		for (unsigned i = 0; i < nr; i++)
+			v[i] = -v[i];
+
+		ret = commit_do(trans, NULL, NULL, 0,
+				bch2_disk_accounting_mod(trans, &acc, v, nr, false)) ?:
+			-BCH_ERR_remove_disk_accounting_entry;
+	} else {
+		ret = -BCH_ERR_remove_disk_accounting_entry;
+	}
+	goto fsck_err;
+}
+
 /*
  * At startup time, initialize the in memory accounting from the btree (and
  * journal)
@@ -666,44 +747,42 @@ int bch2_accounting_read(struct bch_fs *c)
 	}
 	keys->gap = keys->nr = dst - keys->data;
 
-	percpu_down_read(&c->mark_lock);
-	for (unsigned i = 0; i < acc->k.nr; i++) {
-		u64 v[BCH_ACCOUNTING_MAX_COUNTERS];
-		bch2_accounting_mem_read_counters(acc, i, v, ARRAY_SIZE(v), false);
+	percpu_down_write(&c->mark_lock);
+	unsigned i = 0;
+	while (i < acc->k.nr) {
+		unsigned idx = inorder_to_eytzinger0(i, acc->k.nr);
 
-		if (bch2_is_zero(v, sizeof(v[0]) * acc->k.data[i].nr_counters))
-			continue;
+		struct disk_accounting_pos acc_k;
+		bpos_to_disk_accounting_pos(&acc_k, acc->k.data[idx].pos);
 
-		struct bch_replicas_padded r;
-		if (!accounting_to_replicas(&r.e, acc->k.data[i].pos))
-			continue;
+		u64 v[BCH_ACCOUNTING_MAX_COUNTERS];
+		bch2_accounting_mem_read_counters(acc, idx, v, ARRAY_SIZE(v), false);
 
 		/*
-		 * If the replicas entry is invalid it'll get cleaned up by
-		 * check_allocations:
+		 * If the entry counters are zeroed, it should be treated as
+		 * nonexistent - it might point to an invalid device.
+		 *
+		 * Remove it, so that if it's re-added it gets re-marked in the
+		 * superblock:
 		 */
-		if (bch2_replicas_entry_validate(&r.e, c, &buf))
+		ret = bch2_is_zero(v, sizeof(v[0]) * acc->k.data[idx].nr_counters)
+			? -BCH_ERR_remove_disk_accounting_entry
+			: bch2_disk_accounting_validate_late(trans, acc_k,
+							v, acc->k.data[idx].nr_counters);
+
+		if (ret == -BCH_ERR_remove_disk_accounting_entry) {
+			free_percpu(acc->k.data[idx].v[0]);
+			free_percpu(acc->k.data[idx].v[1]);
+			darray_remove_item(&acc->k, &acc->k.data[idx]);
+			eytzinger0_sort(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
+					accounting_pos_cmp, NULL);
+			ret = 0;
 			continue;
-
-		struct disk_accounting_pos k;
-		bpos_to_disk_accounting_pos(&k, acc->k.data[i].pos);
-
-		if (fsck_err_on(!bch2_replicas_marked_locked(c, &r.e),
-				trans, accounting_replicas_not_marked,
-				"accounting not marked in superblock replicas\n  %s",
-				(printbuf_reset(&buf),
-				 bch2_accounting_key_to_text(&buf, &k),
-				 buf.buf))) {
-			/*
-			 * We're not RW yet and still single threaded, dropping
-			 * and retaking lock is ok:
-			 */
-			percpu_up_read(&c->mark_lock);
-			ret = bch2_mark_replicas(c, &r.e);
-			if (ret)
-				goto fsck_err;
-			percpu_down_read(&c->mark_lock);
 		}
+
+		if (ret)
+			goto fsck_err;
+		i++;
 	}
 
 	preempt_disable();
@@ -742,7 +821,7 @@ int bch2_accounting_read(struct bch_fs *c)
 	}
 	preempt_enable();
 fsck_err:
-	percpu_up_read(&c->mark_lock);
+	percpu_up_write(&c->mark_lock);
 err:
 	printbuf_exit(&buf);
 	bch2_trans_put(trans);
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 60b7875adada..649263516ab1 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -268,7 +268,8 @@
 	x(BCH_ERR_nopromote,		nopromote_no_writes)			\
 	x(BCH_ERR_nopromote,		nopromote_enomem)			\
 	x(0,				invalid_snapshot_node)			\
-	x(0,				option_needs_open_fs)
+	x(0,				option_needs_open_fs)			\
+	x(0,				remove_disk_accounting_entry)
 
 enum bch_errcode {
 	BCH_ERR_START		= 2048,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 4cdddf15d752..62ad25f91b78 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -291,6 +291,7 @@ enum bch_fsck_flags {
 	x(alloc_key_stripe_sectors_wrong,			271,	FSCK_AUTOFIX)	\
 	x(accounting_mismatch,					272,	FSCK_AUTOFIX)	\
 	x(accounting_replicas_not_marked,			273,	0)		\
+	x(accounting_to_invalid_device,				289,	0)		\
 	x(invalid_btree_id,					274,	0)		\
 	x(alloc_key_io_time_bad,				275,	0)		\
 	x(alloc_key_fragmentation_lru_wrong,			276,	FSCK_AUTOFIX)	\
@@ -300,7 +301,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							289,	0)
+	x(MAX,							290,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

