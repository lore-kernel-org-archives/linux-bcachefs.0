Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6363E8F66
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893872; cv=none; b=lnGsBBB6PxgI4VeqBwdbpvx9+15DuIEvpGqGV1HV5djAvQ0MPT9LONncBFv8Avd/Fd43CW8q7cFz/dzPz4GWb0EVSIgytD2u6dfOFHdlmPJJvjuarmGRub8hX7ltJYMHX6emaUqAWdnMS78/Csj9WBnXOdxd/L5yHYfI4QWHxFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893872; c=relaxed/simple;
	bh=SUEYVIkr66mnq/XtVDtb3xrm+Fbaqc69pzpJxx5+M4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ByBOdY4htbHfarZTgbLK4I4lPn5aI2MJAQdvbRW7wAAZF2oh2JQ3L7B9rmrnLtJOCXcnjWYgnWJIBVI6H5Yrfa+Gc5FP/SIGnmxvd03N2A9T3g2S8UvZxR6BQC2kFs7QMvsaDEX2Vn+OsQicEBQBGrT9S6/HM07Tywh2PQzv+AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=POwi8AwQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="POwi8AwQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rG3CZcIMBODcTuNDIcKi/2Lsqfi6S3B66iB488IWcdk=;
	b=POwi8AwQ22P96CMk7VDOlU+LTq05Dr3uJHfHUX4yUAamP3tHdOpzitKM3pDXzTG9vrTRQ8
	QuiH0uPGeUIXbAhLU0zFDPzLJ2iMZACrtMTVrb6d3O+oMhLNL566vybGy3QmLk4nXKcxhJ
	Eu+Dx93cWg4C2ZzEswbt4pD5oYfh/tM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/4] bcachefs: kill bch2_journal_entries_free()
Date: Sun, 17 Nov 2024 20:37:30 -0500
Message-ID: <20241118013733.2275244-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_journal_iter.c | 17 ++++++-----------
 fs/bcachefs/btree_journal_iter.h |  2 --
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index c44889ef9817..39898baa8854 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -527,16 +527,6 @@ void bch2_btree_and_journal_iter_init_node_iter(struct btree_trans *trans,
 
 /* sort and dedup all keys in the journal: */
 
-void bch2_journal_entries_free(struct bch_fs *c)
-{
-	struct journal_replay **i;
-	struct genradix_iter iter;
-
-	genradix_for_each(&c->journal_entries, iter, i)
-		kvfree(*i);
-	genradix_free(&c->journal_entries);
-}
-
 /*
  * When keys compare equal, oldest compares first:
  */
@@ -569,7 +559,12 @@ void bch2_journal_keys_put(struct bch_fs *c)
 	keys->data = NULL;
 	keys->nr = keys->gap = keys->size = 0;
 
-	bch2_journal_entries_free(c);
+	struct journal_replay **i;
+	struct genradix_iter iter;
+
+	genradix_for_each(&c->journal_entries, iter, i)
+		kvfree(*i);
+	genradix_free(&c->journal_entries);
 }
 
 static void __journal_keys_sort(struct journal_keys *keys)
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index fa8c4f82c9c7..5ddbb7571770 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -81,8 +81,6 @@ static inline void bch2_journal_keys_put_initial(struct bch_fs *c)
 	c->journal_keys.initial_ref_held = false;
 }
 
-void bch2_journal_entries_free(struct bch_fs *);
-
 int bch2_journal_keys_sort(struct bch_fs *);
 
 void bch2_shoot_down_journal_keys(struct bch_fs *, enum btree_id,
-- 
2.45.2

