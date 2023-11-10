Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDAF38DC8
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qnVVw228"
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120893EB07
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qmj2/L1dt1O+Apow+Mlp42iJs5sRTS/46iZqEOalorw=;
	b=qnVVw228OzGPwURGx4QH04sU4UhW8KthY+QC2EEMPnfY29/JslFq+Kj1M/Y+uEqoGRmi62
	s1Er910zzcOGbtFuzfIK3RqztFMM0n1pcP1lSibNJufXQiqjTn2vDBtCpM/IeT3d6uN3y1
	rtq0Ecm43xVlBt7mMvf7uUYjGf0jH7Y=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/17] bcachefs: BTREE_INSERT_JOURNAL_REPLAY now "don't init trans->journal_res"
Date: Fri, 10 Nov 2023 11:31:41 -0500
Message-ID: <20231110163157.2736111-5-kent.overstreet@linux.dev>
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

This slightly changes how trans->journal_res works, in preparation for
changing the btree write buffer flush path to use it.

Now, BTREE_INSERT_JOURNAL_REPLAY means "don't take a journal
reservation; trans->journal_res.seq already refers to the journal
sequence number to pin".

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 19 +++++++++++++++----
 fs/bcachefs/recovery.c           |  2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 3152f6abf73f..ec90a06a6cf9 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -677,8 +677,6 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 
 		if (unlikely(trans->journal_transaction_names))
 			journal_transaction_name(trans);
-	} else {
-		trans->journal_res.seq = c->journal.replay_journal_seq;
 	}
 
 	/*
@@ -897,7 +895,8 @@ static inline int do_bch2_trans_commit(struct btree_trans *trans, unsigned flags
 	 * Drop journal reservation after dropping write locks, since dropping
 	 * the journal reservation may kick off a journal write:
 	 */
-	bch2_journal_res_put(&c->journal, &trans->journal_res);
+	if (likely(!(flags & BTREE_INSERT_JOURNAL_REPLAY)))
+		bch2_journal_res_put(&c->journal, &trans->journal_res);
 
 	return ret;
 }
@@ -1140,7 +1139,8 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 	}
 retry:
 	bch2_trans_verify_not_in_restart(trans);
-	memset(&trans->journal_res, 0, sizeof(trans->journal_res));
+	if (likely(!(flags & BTREE_INSERT_JOURNAL_REPLAY)))
+		memset(&trans->journal_res, 0, sizeof(trans->journal_res));
 
 	ret = do_bch2_trans_commit(trans, flags, &i, _RET_IP_);
 
@@ -1165,5 +1165,16 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 	if (ret)
 		goto out;
 
+	/*
+	 * We might have done another transaction commit in the error path -
+	 * i.e. btree write buffer flush - which will have made use of
+	 * trans->journal_res, but with BTREE_INSERT_JOURNAL_REPLAY that is how
+	 * the journal sequence number to pin is passed in - so we must restart:
+	 */
+	if (flags & BTREE_INSERT_JOURNAL_REPLAY) {
+		ret = -BCH_ERR_transaction_restart_nested;
+		goto out;
+	}
+
 	goto retry;
 }
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 9c30500ce920..8fe39a91beed 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -98,6 +98,8 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 	unsigned update_flags = BTREE_TRIGGER_NORUN;
 	int ret;
 
+	trans->journal_res.seq = k->journal_seq;
+
 	/*
 	 * BTREE_UPDATE_KEY_CACHE_RECLAIM disables key cache lookup/update to
 	 * keep the key cache coherent with the underlying btree. Nothing
-- 
2.42.0

