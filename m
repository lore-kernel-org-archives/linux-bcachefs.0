Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38488F6C
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 23:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749857119; cv=none; b=aGVc5FRr/9iwhrkSvkk+WwCtQFU+pKdUmEHeUX5Q9i6hXS0LWZQGgTpjGA5CMhL5nPa+EEIKYTc6zw2YtMJsyUCrCt9PYKPpWlzdQHIUKH6FFMoPueyc1guklfeFrZWrZ12RaqJ4kZpcR+jzGwof3+5TebDFAjBM6WL4AnuhsD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749857119; c=relaxed/simple;
	bh=z8vZOHS9yE5PPvEKRxUwqjSbMmQvemDTFhXTRpuLtb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uPyc0hjoVhR5LDDCWKDwIQaP6/qFgZ/k7RER8Fak0rO0BLnk1wKWu4GBgl+i7rGvrM5oU9Ql/tbSmMfxa1b28tghrXHMd1kCyI0r4crqV7DP/kN3Pv+m6kTqVyRA5UbNBmll3sSunthoXSiUc9GY1Qdrm2gmpSF1z85RTcqNr0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XIowz9hn; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XIowz9hn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749857114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zNfIEjY1w4duqnZ869t2ZTbmSf5nhQLydywyBzLm2fU=;
	b=XIowz9hnSEjI93EHN5QC8l86F5R9GTDW5ETgkeA+gHwHltwxtHFTZGmW7sljjKxkvjj6Kj
	Y/5/7byCdq92Grg4yHNP5Wi7z9hjkn83612E3MLia4p5CUJYysTOdD85RPMl2JYY80834f
	bXVv9O545HJJWyeCWatc9+qbWptsVeY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: opts.journal_rewind
Date: Fri, 13 Jun 2025 19:25:10 -0400
Message-ID: <20250613232510.3815892-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a mount option for rewinding the journal, bringing the entire
filesystem to where it was at a previous point in time.

This is for extreme disaster recovery scenarios - it's not intended as
an undelete operation.

The option takes a journal sequence number; the desired sequence number
can be determined with 'bcachefs list_journal'

Caveats:

- The 'journal_transaction_names' option must have been enabled (it's on
  by default). The option controls emitting of extra debug info in the
  journal, so we can see what individual transactions were doing;
  It also enables journalling of keys being overwritten, which is what
  we rely on here.

- A full fsck run will be automatically triggered since alloc info will
  be inconsistent. Only leaf node updates to non-alloc btrees are
  rewound, since rewinding interior btree updates isn't possible or
  desirable.

- We can't do anything about data that was deleted and overwritten.

  Lots of metadata updates after the point in time we're rewinding to
  shouldn't cause a problem, since we segragate data and metadata
  allocations (this is in order to make repair by btree node scan
  practical on larger filesystems; there's a small 64-bit per device
  bitmap in the superblock of device ranges with btree nodes, and we try
  to keep this small).

  However, having discards enabled will cause problems, since buckets
  are discarded as soon as they become empty (this is why we don't
  implement fstrim: we don't need it).

  Hopefully, this feature will be a one-off thing that's never used
  again: this was implemented for recovering from the "vfs i_nlink 0 ->
  subvol deletion" bug, and that bug was unusually disastrous and
  additional safeguards have since been implemented.

  But if it does turn out that we need this more in the future, I'll
  have to implement an option so that empty buckets aren't discarded
  immediately - lagging by perhaps 1% of device capacity.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_journal_iter.c       | 65 +++++++++++++++++---------
 fs/bcachefs/btree_journal_iter_types.h |  5 +-
 fs/bcachefs/journal_io.c               | 21 +++++++--
 fs/bcachefs/opts.h                     |  5 ++
 fs/bcachefs/recovery.c                 |  5 ++
 5 files changed, 74 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index de996c848e43..8f94c3bd039c 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -641,10 +641,11 @@ static int journal_sort_key_cmp(const void *_l, const void *_r)
 {
 	const struct journal_key *l = _l;
 	const struct journal_key *r = _r;
+	int rewind = l->rewind && r->rewind ? -1 : 1;
 
 	return  journal_key_cmp(l, r) ?:
-		cmp_int(l->journal_seq, r->journal_seq) ?:
-		cmp_int(l->journal_offset, r->journal_offset);
+		((cmp_int(l->journal_seq, r->journal_seq) ?:
+		  cmp_int(l->journal_offset, r->journal_offset)) * rewind);
 }
 
 void bch2_journal_keys_put(struct bch_fs *c)
@@ -712,37 +713,59 @@ int bch2_journal_keys_sort(struct bch_fs *c)
 	struct journal_replay *i, **_i;
 	struct journal_keys *keys = &c->journal_keys;
 	size_t nr_read = 0;
+	u64 nr_entries = 0, nr_non_ignored = 0;
+
+	u64 rewind_seq = c->opts.journal_rewind ?: U64_MAX;
 
 	genradix_for_each(&c->journal_entries, iter, _i) {
 		i = *_i;
 
+		nr_entries += i != NULL;
+
 		if (journal_replay_ignore(i))
 			continue;
 
+		nr_non_ignored++;
+
 		cond_resched();
 
-		for_each_jset_key(k, entry, &i->j) {
-			struct journal_key n = (struct journal_key) {
-				.btree_id	= entry->btree_id,
-				.level		= entry->level,
-				.k		= k,
-				.journal_seq	= le64_to_cpu(i->j.seq),
-				.journal_offset	= k->_data - i->j._data,
-			};
-
-			if (darray_push(keys, n)) {
-				__journal_keys_sort(keys);
-
-				if (keys->nr * 8 > keys->size * 7) {
-					bch_err(c, "Too many journal keys for slowpath; have %zu compacted, buf size %zu, processed %zu keys at seq %llu",
-						keys->nr, keys->size, nr_read, le64_to_cpu(i->j.seq));
-					return bch_err_throw(c, ENOMEM_journal_keys_sort);
+		vstruct_for_each(&i->j, entry) {
+			bool rewind = !entry->level &&
+				!btree_id_is_alloc(entry->btree_id) &&
+				le64_to_cpu(i->j.seq) >= rewind_seq;
+
+			if (entry->type != (rewind
+					    ? BCH_JSET_ENTRY_overwrite
+					    : BCH_JSET_ENTRY_btree_keys))
+				continue;
+
+			if (!rewind && le64_to_cpu(i->j.seq) < c->journal_replay_seq_start)
+				continue;
+
+			jset_entry_for_each_key(entry, k) {
+				struct journal_key n = (struct journal_key) {
+					.btree_id	= entry->btree_id,
+					.level		= entry->level,
+					.rewind		= rewind,
+					.k		= k,
+					.journal_seq	= le64_to_cpu(i->j.seq),
+					.journal_offset	= k->_data - i->j._data,
+				};
+
+				if (darray_push(keys, n)) {
+					__journal_keys_sort(keys);
+
+					if (keys->nr * 8 > keys->size * 7) {
+						bch_err(c, "Too many journal keys for slowpath; have %zu compacted, buf size %zu, processed %zu keys at seq %llu",
+							keys->nr, keys->size, nr_read, le64_to_cpu(i->j.seq));
+						return bch_err_throw(c, ENOMEM_journal_keys_sort);
+					}
+
+					BUG_ON(darray_push(keys, n));
 				}
 
-				BUG_ON(darray_push(keys, n));
+				nr_read++;
 			}
-
-			nr_read++;
 		}
 	}
 
diff --git a/fs/bcachefs/btree_journal_iter_types.h b/fs/bcachefs/btree_journal_iter_types.h
index 8b773823704f..86aacb254fb2 100644
--- a/fs/bcachefs/btree_journal_iter_types.h
+++ b/fs/bcachefs/btree_journal_iter_types.h
@@ -11,8 +11,9 @@ struct journal_key {
 	u32			journal_offset;
 	enum btree_id		btree_id:8;
 	unsigned		level:8;
-	bool			allocated;
-	bool			overwritten;
+	bool			allocated:1;
+	bool			overwritten:1;
+	bool			rewind:1;
 	struct journal_key_range_overwritten __rcu *
 				overwritten_range;
 	struct bkey_i		*k;
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 0b15d71a8d2d..afbf12e8f0c5 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -160,6 +160,9 @@ static int journal_entry_add(struct bch_fs *c, struct bch_dev *ca,
 	struct printbuf buf = PRINTBUF;
 	int ret = JOURNAL_ENTRY_ADD_OK;
 
+	if (last_seq && c->opts.journal_rewind)
+		last_seq = min(last_seq, c->opts.journal_rewind);
+
 	if (!c->journal.oldest_seq_found_ondisk ||
 	    le64_to_cpu(j->seq) < c->journal.oldest_seq_found_ondisk)
 		c->journal.oldest_seq_found_ondisk = le64_to_cpu(j->seq);
@@ -1430,11 +1433,21 @@ int bch2_journal_read(struct bch_fs *c,
 	printbuf_reset(&buf);
 	prt_printf(&buf, "journal read done, replaying entries %llu-%llu",
 		   *last_seq, *blacklist_seq - 1);
+
+	/*
+	 * Drop blacklisted entries and entries older than last_seq (or start of
+	 * journal rewind:
+	 */
+	u64 drop_before = *last_seq;
+	if (c->opts.journal_rewind) {
+		drop_before = min(drop_before, c->opts.journal_rewind);
+		prt_printf(&buf, " (rewinding from %llu)", c->opts.journal_rewind);
+	}
+
+	*last_seq = drop_before;
 	if (*start_seq != *blacklist_seq)
 		prt_printf(&buf, " (unflushed %llu-%llu)", *blacklist_seq, *start_seq - 1);
 	bch_info(c, "%s", buf.buf);
-
-	/* Drop blacklisted entries and entries older than last_seq: */
 	genradix_for_each(&c->journal_entries, radix_iter, _i) {
 		i = *_i;
 
@@ -1442,7 +1455,7 @@ int bch2_journal_read(struct bch_fs *c,
 			continue;
 
 		seq = le64_to_cpu(i->j.seq);
-		if (seq < *last_seq) {
+		if (seq < drop_before) {
 			journal_replay_free(c, i, false);
 			continue;
 		}
@@ -1455,7 +1468,7 @@ int bch2_journal_read(struct bch_fs *c,
 		}
 	}
 
-	ret = bch2_journal_check_for_missing(c, *last_seq, *blacklist_seq - 1);
+	ret = bch2_journal_check_for_missing(c, drop_before, *blacklist_seq - 1);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 2a02606254b3..b0a76bd6d6f5 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -379,6 +379,11 @@ enum fsck_err_opts {
 	  OPT_BOOL(),							\
 	  BCH2_NO_SB_OPT,		false,				\
 	  NULL,		"Exit recovery immediately prior to journal replay")\
+	x(journal_rewind,		u64,				\
+	  OPT_FS|OPT_MOUNT,						\
+	  OPT_UINT(0, U64_MAX),						\
+	  BCH2_NO_SB_OPT,		0,				\
+	  NULL,		"Rewind journal")				\
 	x(recovery_passes,		u64,				\
 	  OPT_FS|OPT_MOUNT,						\
 	  OPT_BITFIELD(bch2_recovery_passes),				\
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 820249e9c5ea..37f2cc1ec2f8 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -757,6 +757,11 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (c->opts.nochanges)
 		c->opts.read_only = true;
 
+	if (c->opts.journal_rewind) {
+		bch_info(c, "rewinding journal, fsck required");
+		c->opts.fsck = true;
+	}
+
 	mutex_lock(&c->sb_lock);
 	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 	bool write_sb = false;
-- 
2.49.0

