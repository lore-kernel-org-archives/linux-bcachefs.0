Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3D2E3EB
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Nov 2024 03:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731036692; cv=none; b=r4IC5pi16/l2UAMywJ/8+tYdNOYx3mMg5M4H/j4emzWhwsi1unQ8rAICHD58qV5BZbS22BF6pcD19TuO6CtHGlZLpqPEcngcTU8ZmVDfXlsEGVEAoq1N7OqXxB/5Gt0S0fMbHnyhS2sFTt4tec+eyFCcMzG3atOBb9nOkpnH+wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731036692; c=relaxed/simple;
	bh=hoA2Lxh8zEaY0TNfux/uEcJwOiM8iKnptM+XWkE9MtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R3/Np68+PyIMIO4daA7lIGvR7sIfIHEIf3rSaaGQP+fVfsqXcMmK8MQNXbb+0U6QTqBk7Iw9QDAf59SbliM1OoVymIZkLSj5jh2nEZtDwt27BIxJD0lD1NIvvIDj1Zw0xNgBUidhM9GH8ho7tz+v90M0jUuH1WRvZFB+F9q3NYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r6MB2xrl; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r6MB2xrl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731036687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fHopErRg1LpOOrGzzoUrVkXKgeedHa/LDFFM7QwHr3E=;
	b=r6MB2xrleIheH6CDlnhpqQrcoeAMrnzPW3Vt0M/RGXByyhl6MDhNXnYhKm2k0Sq7mDftjF
	irzLUQ7ObQIvtpAlC6lAGjCQDhbZGgf9VvUyyd/zYOskSwWN0pHyNo0MokVB8D3lTtoaUz
	WWcHjHBGGceGg8i9K8RK/nwORAIDF60=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: bch2_btree_write_buffer_flush_going_ro()
Date: Thu,  7 Nov 2024 22:31:16 -0500
Message-ID: <20241108033116.1852601-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The write buffer needs to be specifically flushed when going RO: keys in
the journal that haven't yet been moved to the write buffer don't have a
journal pin yet.

This fixes numerous syzbot bugs, all with symptoms of still doing writes
after we've got RO.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_write_buffer.c | 30 +++++++++++++++++++++++++++---
 fs/bcachefs/btree_write_buffer.h |  1 +
 fs/bcachefs/super.c              |  1 +
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 3f56b584f8ec..1639c60dffa0 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -277,6 +277,10 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	bool accounting_replay_done = test_bit(BCH_FS_accounting_replay_done, &c->flags);
 	int ret = 0;
 
+	ret = bch2_journal_error(&c->journal);
+	if (ret)
+		return ret;
+
 	bch2_trans_unlock(trans);
 	bch2_trans_begin(trans);
 
@@ -491,7 +495,8 @@ static int fetch_wb_keys_from_journal(struct bch_fs *c, u64 seq)
 	return ret;
 }
 
-static int btree_write_buffer_flush_seq(struct btree_trans *trans, u64 seq)
+static int btree_write_buffer_flush_seq(struct btree_trans *trans, u64 seq,
+					bool *did_work)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
@@ -502,6 +507,8 @@ static int btree_write_buffer_flush_seq(struct btree_trans *trans, u64 seq)
 
 		fetch_from_journal_err = fetch_wb_keys_from_journal(c, seq);
 
+		*did_work |= wb->inc.keys.nr || wb->flushing.keys.nr;
+
 		/*
 		 * On memory allocation failure, bch2_btree_write_buffer_flush_locked()
 		 * is not guaranteed to empty wb->inc:
@@ -521,17 +528,34 @@ static int bch2_btree_write_buffer_journal_flush(struct journal *j,
 				struct journal_entry_pin *_pin, u64 seq)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	bool did_work = false;
 
-	return bch2_trans_run(c, btree_write_buffer_flush_seq(trans, seq));
+	return bch2_trans_run(c, btree_write_buffer_flush_seq(trans, seq, &did_work));
 }
 
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
+	bool did_work = false;
 
 	trace_and_count(c, write_buffer_flush_sync, trans, _RET_IP_);
 
-	return btree_write_buffer_flush_seq(trans, journal_cur_seq(&c->journal));
+	return btree_write_buffer_flush_seq(trans, journal_cur_seq(&c->journal), &did_work);
+}
+
+/*
+ * The write buffer requires flushing when going RO: keys in the journal for the
+ * write buffer don't have a journal pin yet
+ */
+bool bch2_btree_write_buffer_flush_going_ro(struct bch_fs *c)
+{
+	if (bch2_journal_error(&c->journal))
+		return false;
+
+	bool did_work = false;
+	bch2_trans_run(c, btree_write_buffer_flush_seq(trans,
+				journal_cur_seq(&c->journal), &did_work));
+	return did_work;
 }
 
 int bch2_btree_write_buffer_flush_nocheck_rw(struct btree_trans *trans)
diff --git a/fs/bcachefs/btree_write_buffer.h b/fs/bcachefs/btree_write_buffer.h
index 725e79654216..d535cea28bde 100644
--- a/fs/bcachefs/btree_write_buffer.h
+++ b/fs/bcachefs/btree_write_buffer.h
@@ -21,6 +21,7 @@ static inline bool bch2_btree_write_buffer_must_wait(struct bch_fs *c)
 
 struct btree_trans;
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *);
+bool bch2_btree_write_buffer_flush_going_ro(struct bch_fs *);
 int bch2_btree_write_buffer_flush_nocheck_rw(struct btree_trans *);
 int bch2_btree_write_buffer_tryflush(struct btree_trans *);
 
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 9b8a9e3781a4..37eee352fa21 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -272,6 +272,7 @@ static void __bch2_fs_read_only(struct bch_fs *c)
 		clean_passes++;
 
 		if (bch2_btree_interior_updates_flush(c) ||
+		    bch2_btree_write_buffer_flush_going_ro(c) ||
 		    bch2_journal_flush_all_pins(&c->journal) ||
 		    bch2_btree_flush_all_writes(c) ||
 		    seq != atomic64_read(&c->journal.seq)) {
-- 
2.45.2

