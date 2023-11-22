Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PSpl6a2Z"
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256383
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 15:51:24 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700697082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y3qE5L5il8oDBhTKLnVCOy7OUHgjPevBShUas5ZH1Uk=;
	b=PSpl6a2Zn3bHbuRpI4sK9uJeQj6AFlJEZASfU5Qpttm5GrpJ+f55ILGueeFwrtwhqK5LNP
	DGzHzzi8BQZ64w2qUHAIGtWTvMKY0buy182Q4yhvJQE9lW6iu5dj1znEJcev2Ve3xWbxJ4
	GhMoEm1YIGi13AzGERbtWk0X7yg9qgA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	peterz@infradead.org
Cc: boqun.feng@gmail.com,
	longman@redhat.com,
	will@kernel.org,
	mingo@redhat.com,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/6] locking/lockdep: lockdep_set_no_check_recursion()
Date: Wed, 22 Nov 2023 18:51:09 -0500
Message-ID: <20231122235113.180132-3-kent.overstreet@linux.dev>
In-Reply-To: <20231122235113.180132-1-kent.overstreet@linux.dev>
References: <20231122235113.180132-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This adds a method to tell lockdep not to check lock ordering within a
lock class - but to still check lock ordering w.r.t. other lock types.

This is for bcachefs, where for btree node locks we have our own
deadlock avoidance strategy w.r.t. other btree node locks (cycle
detection), but we still want lockdep to check lock ordering w.r.t.
other lock types.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/lockdep.h       |  6 ++++++
 include/linux/lockdep_types.h |  2 +-
 kernel/locking/lockdep.c      | 26 ++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index fc86557d2a21..1bc7eb7cb548 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -700,4 +700,10 @@ lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 }
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void lockdep_set_no_check_recursion(struct lockdep_map *map);
+#else
+static inline void lockdep_set_no_check_recursion(struct lockdep_map *map) {}
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index 2ebc323d345a..aa6bddac2a64 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -137,7 +137,7 @@ struct lock_class {
 	u8				wait_type_inner;
 	u8				wait_type_outer;
 	u8				lock_type;
-	/* u8				hole; */
+	u8				no_check_recursion;
 
 #ifdef CONFIG_LOCK_STAT
 	unsigned long			contention_point[LOCKSTAT_POINTS];
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 38924d90da85..50a0a1ea960a 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3048,6 +3048,9 @@ check_deadlock(struct task_struct *curr, struct held_lock *next)
 
 		class = hlock_class(prev);
 
+		if (class->no_check_recursion)
+			continue;
+
 		if (class->cmp_fn &&
 		    class->cmp_fn(prev->instance, next->instance) < 0)
 			continue;
@@ -3113,6 +3116,10 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 		return 2;
 	}
 
+	if (hlock_class(prev) == hlock_class(next) &&
+	    hlock_class(prev)->no_check_recursion)
+		return 2;
+
 	if (prev->class_idx == next->class_idx) {
 		struct lock_class *class = hlock_class(prev);
 
@@ -6732,3 +6739,22 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void lockdep_set_no_check_recursion(struct lockdep_map *lock)
+{
+	struct lock_class *class = lock->class_cache[0];
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	lockdep_recursion_inc();
+
+	if (!class)
+		class = register_lock_class(lock, 0, 0);
+	if (class)
+		class->no_check_recursion = true;
+	lockdep_recursion_finish();
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lockdep_set_no_check_recursion);
+#endif
-- 
2.42.0

