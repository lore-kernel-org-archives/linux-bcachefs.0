Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DDA27E1B1
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283694; cv=none; b=jTFH9LkxEWwUNs2IvYh1xJ/pVd5aVFuPwk9M/6pPyjgGADoEgkKEMcjLTdDyvMX5gf10yhVjBq4cDj4Wq6TkHhV1UsMo1j4kMBw2IL3Xw2f2Duxu7sMyl/eoiTtd1K6pmP1mMEfQFX05IvW2IIAyb7c2SzS1tVy7aZuA4d/kXy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283694; c=relaxed/simple;
	bh=KIxBfLcUWWAHSl5fE4Y9e8e/DqrzSRjAaQAyJWdRJc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcrIcsec10zx/aAydn6KzJvXIyGblgHzobu/P74dmXQQOHSbU9684KljKv8MCd0J+IZSQBltiXSPmm8naVJGFQrXdrlFzgOy6Um2dsK+5tPAQ1F/HXwXjukZ8zrXfncs6WjHgJ2S9WdqthzoekHsGuRgOw73l+q6DxeuRZBTZN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/RBu/hk; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/RBu/hk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dgcdfP1te8GBYHEh0j3x9G8yjA/vV0REMvl1KYIxKog=;
	b=o/RBu/hkbrJs1P8YUytaOZtxogJhstdtP5rZOeJZbi3bazVTFWjdfj3gJsFJjeVoceyJo1
	m6TTtitq9Jpqx6KJ+XTqS/CPc5oNIpSdkI9h0/Ci7hd7t675qoPchf2N6IHFuJFr7EHTgu
	6o0+uuRcMF267HSqUE9vwBAqmYxJxNo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/37] bcachefs: pass last_seq into fs_journal_start()
Date: Wed, 18 Jun 2025 17:54:01 -0400
Message-ID: <20250618215431.738317-11-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Prep work for journal rewind, where the seq we're replaying from may be
different than the last journal entry's last_seq.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c  | 18 ++++++------------
 fs/bcachefs/journal.h  |  2 +-
 fs/bcachefs/recovery.c |  4 ++--
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index dda802a656cf..df71af0013ba 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1474,14 +1474,13 @@ void bch2_fs_journal_stop(struct journal *j)
 		clear_bit(JOURNAL_running, &j->flags);
 }
 
-int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
+int bch2_fs_journal_start(struct journal *j, u64 last_seq, u64 cur_seq)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct journal_entry_pin_list *p;
 	struct journal_replay *i, **_i;
 	struct genradix_iter iter;
 	bool had_entries = false;
-	u64 last_seq = cur_seq, nr, seq;
 
 	/*
 	 *
@@ -1495,17 +1494,11 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 		return -EINVAL;
 	}
 
-	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
-		i = *_i;
-
-		if (journal_replay_ignore(i))
-			continue;
+	/* Clean filesystem? */
+	if (!last_seq)
+		last_seq = cur_seq;
 
-		last_seq = le64_to_cpu(i->j.last_seq);
-		break;
-	}
-
-	nr = cur_seq - last_seq;
+	u64 nr = cur_seq - last_seq;
 
 	/*
 	 * Extra fudge factor, in case we crashed when the journal pin fifo was
@@ -1532,6 +1525,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	j->pin.back		= cur_seq;
 	atomic64_set(&j->seq, cur_seq - 1);
 
+	u64 seq;
 	fifo_for_each_entry_ptr(p, &j->pin, seq)
 		journal_pin_list_init(p, 1);
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 83734fe4331f..977907038d98 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -453,7 +453,7 @@ int bch2_fs_journal_alloc(struct bch_fs *);
 void bch2_dev_journal_stop(struct journal *, struct bch_dev *);
 
 void bch2_fs_journal_stop(struct journal *);
-int bch2_fs_journal_start(struct journal *, u64);
+int bch2_fs_journal_start(struct journal *, u64, u64);
 void bch2_journal_set_replay_done(struct journal *);
 
 void bch2_dev_journal_exit(struct bch_dev *);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 0b21fa6ff062..6aef8b101820 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -965,7 +965,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 
 	ret =   bch2_journal_log_msg(c, "starting journal at entry %llu, replaying %llu-%llu",
 				     journal_seq, last_seq, blacklist_seq - 1) ?:
-		bch2_fs_journal_start(&c->journal, journal_seq);
+		bch2_fs_journal_start(&c->journal, last_seq, journal_seq);
 	if (ret)
 		goto err;
 
@@ -1181,7 +1181,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	 * journal_res_get() will crash if called before this has
 	 * set up the journal.pin FIFO and journal.cur pointer:
 	 */
-	ret = bch2_fs_journal_start(&c->journal, 1);
+	ret = bch2_fs_journal_start(&c->journal, 1, 1);
 	if (ret)
 		goto err;
 
-- 
2.50.0

