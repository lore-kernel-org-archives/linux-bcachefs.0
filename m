Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859F3155398
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729375044; cv=none; b=ARm1NADzSiRGkhAXp5sEysBeORUW3SLYbwTTXY63SDfNIukwENCkVMsX1+IlTJLI34/r8owD+BQ/iB7GAIFqtc1ffuQWc19pWsLjWo2y5XTRlZSsnbqbcdPz5zALH7naQcN4q2I0Qn8gozpv42yprQ7oHuP6vYCdbLGzjYwQj68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729375044; c=relaxed/simple;
	bh=75jqBaTyb3jcW4H/71ihlsU34RTfR5hpsfIrlG2slgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xvn0y075Wx9pJNcjEi0I9RxUI1MJ8yiOQEmKR1+NbuOvJJ4XQ6uHFAdlwg2wCWJxf2V4LJ4aMYvIsvM3Jfl8YtZ5hIQBBzgJ3nQzM6LH4Q0d+ogmuswazH+emTljJdrEgNNpCqhKWD+k6ZTwJpV2NqryhBl2gp4wCif8/Cl4a20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G1NN51wA; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G1NN51wA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729375039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X+6BXTYcK7DlSsEWcwVoasjJ2sDw5efl7KsIrdAmvoI=;
	b=G1NN51wAHEtAi7d/IRBw4UaVmXfGU3lSlDJ5uCoaVOMiATGRuiPeODUEHZPkworySkCVKo
	eInNz+DHiF5JmUfKbDyxZRj1MQgrhW6m69+ntk3vwGgUXasa/xKLjwuPMHz7GL+6Vp6G9Z
	ZXYGxWxXMQnECPqWp9J5TnckrdfR9sY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Don't use wait_event_interruptible() in recovery
Date: Sat, 19 Oct 2024 17:57:11 -0400
Message-ID: <20241019215711.160174-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix a bug where mount was failing with -ERESTARTSYS:
https://github.com/koverstreet/bcachefs/issues/741

We only want the interruptible wait when called from fsync.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io.c   |  2 +-
 fs/bcachefs/journal.c | 10 ++++++----
 fs/bcachefs/journal.h |  2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 71d0fa387509..15d3f073b824 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -182,7 +182,7 @@ static int bch2_flush_inode(struct bch_fs *c,
 
 	struct bch_inode_unpacked u;
 	int ret = bch2_inode_find_by_inum(c, inode_inum(inode), &u) ?:
-		  bch2_journal_flush_seq(&c->journal, u.bi_journal_seq) ?:
+		  bch2_journal_flush_seq(&c->journal, u.bi_journal_seq, TASK_INTERRUPTIBLE) ?:
 		  bch2_inode_flush_nocow_writes(c, inode);
 	bch2_write_ref_put(c, BCH_WRITE_REF_fsync);
 	return ret;
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index dc099f06341f..2dc0d60c1745 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -758,7 +758,7 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 	return ret;
 }
 
-int bch2_journal_flush_seq(struct journal *j, u64 seq)
+int bch2_journal_flush_seq(struct journal *j, u64 seq, unsigned task_state)
 {
 	u64 start_time = local_clock();
 	int ret, ret2;
@@ -769,7 +769,9 @@ int bch2_journal_flush_seq(struct journal *j, u64 seq)
 	if (seq <= j->flushed_seq_ondisk)
 		return 0;
 
-	ret = wait_event_interruptible(j->wait, (ret2 = bch2_journal_flush_seq_async(j, seq, NULL)));
+	ret = wait_event_state(j->wait,
+			       (ret2 = bch2_journal_flush_seq_async(j, seq, NULL)),
+			       task_state);
 
 	if (!ret)
 		bch2_time_stats_update(j->flush_seq_time, start_time);
@@ -788,7 +790,7 @@ void bch2_journal_flush_async(struct journal *j, struct closure *parent)
 
 int bch2_journal_flush(struct journal *j)
 {
-	return bch2_journal_flush_seq(j, atomic64_read(&j->seq));
+	return bch2_journal_flush_seq(j, atomic64_read(&j->seq), TASK_UNINTERRUPTIBLE);
 }
 
 /*
@@ -851,7 +853,7 @@ int bch2_journal_meta(struct journal *j)
 
 	bch2_journal_res_put(j, &res);
 
-	return bch2_journal_flush_seq(j, res.seq);
+	return bch2_journal_flush_seq(j, res.seq, TASK_UNINTERRUPTIBLE);
 }
 
 /* block/unlock the journal: */
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 377a3750406e..2762be6f9814 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -401,7 +401,7 @@ void bch2_journal_entry_res_resize(struct journal *,
 int bch2_journal_flush_seq_async(struct journal *, u64, struct closure *);
 void bch2_journal_flush_async(struct journal *, struct closure *);
 
-int bch2_journal_flush_seq(struct journal *, u64);
+int bch2_journal_flush_seq(struct journal *, u64, unsigned);
 int bch2_journal_flush(struct journal *);
 bool bch2_journal_noflush_seq(struct journal *, u64);
 int bch2_journal_meta(struct journal *);
-- 
2.45.2

