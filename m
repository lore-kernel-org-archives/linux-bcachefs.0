Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2E233FE
	for <linux-bcachefs@vger.kernel.org>; Sun, 30 Jun 2024 05:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719724250; cv=none; b=BFLGoabf0WBvma3Vs8io6ylepNk3r0CzQSlRvYPDSpQkgO30XGEkskk3YX1hEC34XpwVPrf0rOgWZPNAXCszhIWtBsccgrJ+1C/CLOPkDyxhuHCTObdCiNLsnVgfwTL9WMGF1hXu2Oq5sjEEm73C7EYf1GQ5g423nmLlv0NjGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719724250; c=relaxed/simple;
	bh=APznGUgYsRThb6+4qKwTVD/XcKIOxyFQcp+sHQXNTM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CMrADwlFOZkxg0Hht4VWWZ/cU/dttFfWJX3q3zogpD160CUwhiYT1jXWWcE13q2ZTd/XtuR7ijPngy0eJXWidZ66+Goq8roTK1Sa7DmgUCfq/lWSRh5zRLUDkBpE/D3ifFV5S32anQQJrAQsNbuqdBwbuSLa3jxJ/PDkAOjcqNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sfnQob2k; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sfnQob2k"
X-Envelope-To: linux-kernel@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719724244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ARRcOdKPAtRj/LcHeZVJZ9MMAM+Nz+wFvMcLsWwfcXo=;
	b=sfnQob2kK16ixhik7PyuyQ029R0sm95hRKXSduT72A54hxWr/p0hgvB7AWLVcJ8VxrE+qU
	oGPsI2RuOHlISXEYNvnkeUtgIdpCXteMAy5vRIj15QIfUvZ6CqXBeRSQkdVCfE7V+WtCUZ
	DQzUcIbaaGHRYsYCX1n4mTFUVySjHV0=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: kent.overstreet@linux.dev
X-Envelope-To: peterz@infradead.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: will@kernel.org
X-Envelope-To: longman@redhat.com
X-Envelope-To: boqun.feng@gmail.com
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH] lockdep: lockdep_set_notrack_class()
Date: Sun, 30 Jun 2024 01:10:37 -0400
Message-ID: <20240630051037.2785156-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a new helper to disable lockdep tracking entirely for a given class.

This is needed for bcachefs, which takes too many btree node locks for
lockdep to track. Instead, we have a single lockdep_map for "btree_trans
has any btree nodes locked", which makes more since given that we have
centralized lock management and a cycle detector.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_locking.c   | 2 +-
 include/linux/lockdep.h       | 4 ++++
 include/linux/lockdep_types.h | 1 +
 kernel/locking/lockdep.c      | 9 ++++++++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 79057cde4c41..16834a6b4c3d 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -10,7 +10,7 @@ void bch2_btree_lock_init(struct btree_bkey_cached_common *b,
 			  enum six_lock_init_flags flags)
 {
 	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags);
-	lockdep_set_novalidate_class(&b->lock);
+	lockdep_set_notrack_class(&b->lock);
 }
 
 #ifdef CONFIG_LOCKDEP
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 08b0d1d9d78b..b76f1bcd2f7f 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -181,6 +181,9 @@ static inline void lockdep_init_map(struct lockdep_map *lock, const char *name,
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
 
+#define lockdep_set_notrack_class(lock) \
+	lockdep_set_class_and_name(lock, &__lockdep_no_track__, #lock)
+
 /*
  * Compare locking classes
  */
@@ -338,6 +341,7 @@ static inline void lockdep_set_selftest_task(struct task_struct *task)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
 
 #define lockdep_set_novalidate_class(lock) do { } while (0)
+#define lockdep_set_notrack_class(lock) do { } while (0)
 
 /*
  * We don't define lockdep_match_class() and lockdep_match_key() for !LOCKDEP
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index 70d30d40ea4a..9f361d3ab9d9 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -80,6 +80,7 @@ struct lock_class_key {
 };
 
 extern struct lock_class_key __lockdep_no_validate__;
+extern struct lock_class_key __lockdep_no_track__;
 
 struct lock_trace;
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 151bd3de5936..b6bb9fcd992a 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4918,6 +4918,9 @@ EXPORT_SYMBOL_GPL(lockdep_init_map_type);
 struct lock_class_key __lockdep_no_validate__;
 EXPORT_SYMBOL_GPL(__lockdep_no_validate__);
 
+struct lock_class_key __lockdep_no_track__;
+EXPORT_SYMBOL_GPL(__lockdep_no_track__);
+
 #ifdef CONFIG_PROVE_LOCKING
 void lockdep_set_lock_cmp_fn(struct lockdep_map *lock, lock_cmp_fn cmp_fn,
 			     lock_print_fn print_fn)
@@ -5002,6 +5005,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (unlikely(!debug_locks))
 		return 0;
 
+	if (unlikely(lock->key == &__lockdep_no_track__))
+		return 0;
+
 	if (!prove_locking || lock->key == &__lockdep_no_validate__)
 		check = 0;
 
@@ -5764,7 +5770,8 @@ void lock_release(struct lockdep_map *lock, unsigned long ip)
 
 	trace_lock_release(lock, ip);
 
-	if (unlikely(!lockdep_enabled()))
+	if (unlikely(!lockdep_enabled() ||
+		     lock->key == &__lockdep_no_track__))
 		return;
 
 	raw_local_irq_save(flags);
-- 
2.45.2

