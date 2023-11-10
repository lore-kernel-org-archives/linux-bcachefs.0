Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89A938DCE
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="raCHQbMw"
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C663EB0B
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6PTDoOl6tPuo40eF69102Y9ey7E7VyYY/tkdSJ65F0Q=;
	b=raCHQbMw9OXU7Q1H1lvHV0o6gdRlr4Sp8wTEzOf24CQNl0pFLtVOx85QubEnbZJZoc0qzc
	3ycHYvr3P7iehQvfcETImyDdZeiwnixozoogu3fAkZwbXarCd0ocZvG76rULyN/pACRJo9
	F5VTdMDOCheGbzBGwrWDA5FruT8Twhs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/17] bcachefs: Go rw before journal replay
Date: Fri, 10 Nov 2023 11:31:43 -0500
Message-ID: <20231110163157.2736111-7-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This gets us slightly nicer log messages.

Also, this slightly clarifies synchronization of c->journal_keys; after
we go RW it's in use by multiple threads (so that the btree iterator
code can overlay keys from the journal); so it has to be prepped before
that point.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/recovery.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 8fe39a91beed..6eafff2557a4 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -148,9 +148,6 @@ static int bch2_journal_replay(struct bch_fs *c)
 	size_t i;
 	int ret;
 
-	move_gap(keys->d, keys->nr, keys->size, keys->gap, keys->nr);
-	keys->gap = keys->nr;
-
 	keys_sorted = kvmalloc_array(keys->nr, sizeof(*keys_sorted), GFP_KERNEL);
 	if (!keys_sorted)
 		return -BCH_ERR_ENOMEM_journal_replay;
@@ -177,7 +174,6 @@ static int bch2_journal_replay(struct bch_fs *c)
 		replay_now_at(j, k->journal_seq);
 
 		ret = bch2_trans_do(c, NULL, NULL,
-				    BTREE_INSERT_LAZY_RW|
 				    BTREE_INSERT_NOFAIL|
 				    (!k->allocated
 				     ? BTREE_INSERT_JOURNAL_REPLAY|BCH_WATERMARK_reclaim
@@ -491,7 +487,19 @@ static int bch2_check_allocations(struct bch_fs *c)
 
 static int bch2_set_may_go_rw(struct bch_fs *c)
 {
+	struct journal_keys *keys = &c->journal_keys;
+
+	/*
+	 * After we go RW, the journal keys buffer can't be modified (except for
+	 * setting journal_key->overwritten: it will be accessed by multiple
+	 * threads
+	 */
+	move_gap(keys->d, keys->nr, keys->size, keys->gap, keys->nr);
+	keys->gap = keys->nr;
+
 	set_bit(BCH_FS_MAY_GO_RW, &c->flags);
+	if (keys->nr)
+		return bch2_fs_read_write_early(c);
 	return 0;
 }
 
-- 
2.42.0

