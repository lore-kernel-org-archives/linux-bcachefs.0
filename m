Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4512383A5
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805359; cv=none; b=rjDKudktqJdEiEJCHOt1WomU0RsGC/Oky0dcLjA9imriJq/QiPP90LgoppODurPcRuriC0G5qCpdZNS+fAZ9kI+XgJFthxp6lJemrAG4+V9MslmK4UOlXGxNkTq1sKhWMza0DENSCywfheMyxJNYbE4pznVxb5nHMFVPvQMoxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805359; c=relaxed/simple;
	bh=m4rMq7wJxLDeaBihV874/Gzwbd8liqXLuQg0kHzihwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EClKO4U1AZmyUYqyXpL+isfc9hCVm/ei1ucptkZTZ/P4VikjE9CgE+A8Sk+AYbebDAqFPEuI5GaP1ERZxgf/OLmMwSOiK/NnoH7prEfMrbEVF6vKMKBzPUgFiFjHsDqBGSAUwAME+U/2q9+B3uoVrTSXDmZXPQplODDE5cSKNRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UdvMbaNn; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UdvMbaNn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Kdw/zsnfEBuwVw8h0YnYWRpQtouWFk5oLfIUZpUsdk=;
	b=UdvMbaNnDZuG07zJPdft0NW8rzu1vBN9oxMz2kyVLiUOyAixctIehu28Pu4V1unGCupCpY
	uFO0Y6RrTzWbIYsLz+GiO3wjsGX6liAczClypXiocoKgH4mFevFWqQ79WRxc/zm+3EsFE6
	5k9kXKqsuUvkYrN/nzYtua1hIgP6sYw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/5] bcachefs: Kill journal_res.idx
Date: Wed,  5 Feb 2025 20:28:47 -0500
Message-ID: <20250206012852.1658754-3-kent.overstreet@linux.dev>
In-Reply-To: <20250206012852.1658754-1-kent.overstreet@linux.dev>
References: <20250206012852.1658754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

More dead code.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       |  2 +-
 fs/bcachefs/journal.h       | 11 ++++++-----
 fs/bcachefs/journal_types.h |  1 -
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index da64a73704ff..20b748f61b21 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -306,7 +306,7 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val, bool t
 
 	bch2_journal_space_available(j);
 
-	__bch2_journal_buf_put(j, old.idx, le64_to_cpu(buf->data->seq));
+	__bch2_journal_buf_put(j, le64_to_cpu(buf->data->seq));
 }
 
 void bch2_journal_halt(struct journal *j)
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 107f7f901cd9..1e5fcfe3624a 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -193,7 +193,7 @@ bch2_journal_add_entry_noreservation(struct journal_buf *buf, size_t u64s)
 static inline struct jset_entry *
 journal_res_entry(struct journal *j, struct journal_res *res)
 {
-	return vstruct_idx(j->buf[res->idx].data, res->offset);
+	return vstruct_idx(j->buf[res->seq & JOURNAL_BUF_MASK].data, res->offset);
 }
 
 static inline unsigned journal_entry_init(struct jset_entry *entry, unsigned type,
@@ -267,8 +267,9 @@ bool bch2_journal_entry_close(struct journal *);
 void bch2_journal_do_writes(struct journal *);
 void bch2_journal_buf_put_final(struct journal *, u64);
 
-static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
+static inline void __bch2_journal_buf_put(struct journal *j, u64 seq)
 {
+	unsigned idx = seq & JOURNAL_BUF_MASK;
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
@@ -276,8 +277,9 @@ static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 s
 		bch2_journal_buf_put_final(j, seq);
 }
 
-static inline void bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
+static inline void bch2_journal_buf_put(struct journal *j, u64 seq)
 {
+	unsigned idx = seq & JOURNAL_BUF_MASK;
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
@@ -306,7 +308,7 @@ static inline void bch2_journal_res_put(struct journal *j,
 				       BCH_JSET_ENTRY_btree_keys,
 				       0, 0, 0);
 
-	bch2_journal_buf_put(j, res->idx, res->seq);
+	bch2_journal_buf_put(j, res->seq);
 
 	res->ref = 0;
 }
@@ -361,7 +363,6 @@ static inline int journal_res_get_fast(struct journal *j,
 				       &old.v, new.v));
 
 	res->ref	= true;
-	res->idx	= old.idx;
 	res->offset	= old.cur_entry_offset;
 	res->seq	= le64_to_cpu(j->buf[old.idx].data->seq);
 	return 1;
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index e38a3d93b17d..6a098c7e3f2e 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -79,7 +79,6 @@ struct journal_entry_pin {
 
 struct journal_res {
 	bool			ref;
-	u8			idx;
 	u16			u64s;
 	u32			offset;
 	u64			seq;
-- 
2.45.2

