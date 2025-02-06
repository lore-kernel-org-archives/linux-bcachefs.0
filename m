Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2878529CE7
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805356; cv=none; b=hxu/MNm5taDXB1HTs8HCa3xNi3QXTDZrDBE493xbcHmN4yURLnG89gBUo7SAUoNclN3S/C1bAiLBtSgOwmcpXs6Ddi/Aa6nvip7tBvbKBonz0Igk7+TCXvo/E1xndWcwsp5UoI/Uu9qGX+S/bKBVeom6iNMTGTuMCBDgBhGm23I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805356; c=relaxed/simple;
	bh=YAumLubuGfNaftRjUkLchcflJcsO4K7Q8GE94xiDpF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfOdGExAXSVwKiRCAS0sIv3nWGxXZOKrTDQOSLxHslurq6oTCaNUBbGLB3CFTg2oSw5dwQ8OtvtLSneiE95ULKdsuD5EhzxeajVkKPPlSAbQgv6OPch1Hmz2deRlvcu7v6i5L3dY1O+JSYidgdEMLnyTSEUJGjTNjAr3Z24ckRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c/q5v3xZ; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c/q5v3xZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acwpO8SKaNryKQJopRhHUlk9GGelzotjNK58LG9+U5Y=;
	b=c/q5v3xZn/gSVITypz1Lxe8yeyqw3d6JteUPK4OZouFl8k31ogg5AVZ0fONZ88t6aqtl9v
	cTIVA5hStFGncq4QDiNnBOPjveJzbDMKLxr5GJzQdOy21mvOdUN/KRqX9YgvW1xRaftzr5
	8Dfc3CnVI7IUUADFlQ7uzOFX9yPOjHY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: Kill journal_res_state.unwritten_idx
Date: Wed,  5 Feb 2025 20:28:46 -0500
Message-ID: <20250206012852.1658754-2-kent.overstreet@linux.dev>
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

Dead code

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       |  3 +--
 fs/bcachefs/journal_io.c    | 13 +------------
 fs/bcachefs/journal_types.h |  7 +++----
 3 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 24c294d4634e..da64a73704ff 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1382,8 +1382,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	set_bit(JOURNAL_running, &j->flags);
 	j->last_flush_write = jiffies;
 
-	j->reservations.idx = j->reservations.unwritten_idx = journal_cur_seq(j);
-	j->reservations.unwritten_idx++;
+	j->reservations.idx = journal_cur_seq(j);
 
 	c->last_bucket_seq_cleanup = journal_cur_seq(j);
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 11c39e0c34f4..f2ff28e6697c 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1611,7 +1611,6 @@ static CLOSURE_CALLBACK(journal_write_done)
 	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct bch_replicas_padded replicas;
-	union journal_res_state old, new;
 	u64 seq = le64_to_cpu(w->data->seq);
 	int err = 0;
 
@@ -1671,16 +1670,6 @@ static CLOSURE_CALLBACK(journal_write_done)
 		if (j->watermark != BCH_WATERMARK_stripe)
 			journal_reclaim_kick(&c->journal);
 
-		old.v = atomic64_read(&j->reservations.counter);
-		do {
-			new.v = old.v;
-			BUG_ON(journal_state_count(new, new.unwritten_idx));
-			BUG_ON(new.unwritten_idx != (seq & JOURNAL_BUF_MASK));
-
-			new.unwritten_idx++;
-		} while (!atomic64_try_cmpxchg(&j->reservations.counter,
-					       &old.v, new.v));
-
 		closure_wake_up(&w->wait);
 		completed = true;
 	}
@@ -1695,7 +1684,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 	}
 
 	if (journal_last_unwritten_seq(j) == journal_cur_seq(j) &&
-		   new.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL) {
+	    j->reservations.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL) {
 		struct journal_buf *buf = journal_cur_buf(j);
 		long delta = buf->expires - jiffies;
 
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index a198a81d7478..e38a3d93b17d 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -95,9 +95,8 @@ union journal_res_state {
 	};
 
 	struct {
-		u64		cur_entry_offset:20,
+		u64		cur_entry_offset:22,
 				idx:2,
-				unwritten_idx:2,
 				buf0_count:10,
 				buf1_count:10,
 				buf2_count:10,
@@ -107,13 +106,13 @@ union journal_res_state {
 
 /* bytes: */
 #define JOURNAL_ENTRY_SIZE_MIN		(64U << 10) /* 64k */
-#define JOURNAL_ENTRY_SIZE_MAX		(4U  << 20) /* 4M */
+#define JOURNAL_ENTRY_SIZE_MAX		(4U  << 22) /* 16M */
 
 /*
  * We stash some journal state as sentinal values in cur_entry_offset:
  * note - cur_entry_offset is in units of u64s
  */
-#define JOURNAL_ENTRY_OFFSET_MAX	((1U << 20) - 1)
+#define JOURNAL_ENTRY_OFFSET_MAX	((1U << 22) - 1)
 
 #define JOURNAL_ENTRY_BLOCKED_VAL	(JOURNAL_ENTRY_OFFSET_MAX - 2)
 #define JOURNAL_ENTRY_CLOSED_VAL	(JOURNAL_ENTRY_OFFSET_MAX - 1)
-- 
2.45.2

