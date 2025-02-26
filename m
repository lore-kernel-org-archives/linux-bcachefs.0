Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0749258CED
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Feb 2025 09:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740562411; cv=none; b=tHlhhcX6rRduonGM+t9m3hMOxUZUmShurrIGoWd/cUH63frYslTdQAmFWBsQBTf4QAcWQ4nHgd4sfJ6rdsJFr/BM2VTBEn4W1Yc3Rd/GM8o16cHHDerZUsrty2XT2Pu6yo15G36ze0v+arfbAWlNpO52pjCTY0SbvPPtJEsAPjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740562411; c=relaxed/simple;
	bh=sh2R4WMXo3XEtalwBjI+FhbSBDhirZKHnABV/kwn0Us=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=af7AGZxwA2t02k5dKyt6StZ1yrr2aqYwF2S3qpgxC1yohFjLT3Fa6xhsP5qVy/nuv9/oWKQNbEA78zJWg/donr6OgLWMtARjNbmrE2UWbmBaHlG3SqSuQqhOvSmWyRlKgUNHghq4uq/UTfgLyn4eqZ5ySIs6KEvzwbvAn2HmLK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqgFUEQZ; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqgFUEQZ"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6fd2587d059so4149727b3.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Feb 2025 01:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740562409; x=1741167209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a4jkcOiCCeoz2WhPDv7BR93cuSwy0xjKcL/eGqO8S98=;
        b=eqgFUEQZogGQqFmKgSLDtUWLpS0ncmWAVlLSbvCzwspBwjj0qgAboLlSrGbArDckdY
         GczKrGFoR2Cr6APuxDH1PXXWwsbI1PJUBBLFv8I//2yP7o0QzpAbVdTap5SDUYerrT4P
         qE8aJMJLTV3Q4QHeFwNUTjQDtrVc9SMCsp3tLFcaMHwkP/hP5JaRNCWSrlNRQj40zfv4
         oqLNXVEc9NpV4dM5yyevkHfi2Q59MTTHnb/aMqdnB26/AYxu9y5F4CaJr6EQN1zgQIAz
         2BV+/7offEPp7LUgH9gyTnU6ggG6lm5cFLtV6JGwsXu+FIqd4UM8L3ZMy6qHz/w9MLgd
         w+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740562409; x=1741167209;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a4jkcOiCCeoz2WhPDv7BR93cuSwy0xjKcL/eGqO8S98=;
        b=spLM4xLijAwEYqMeSibZmh5zby9scCyPcc2uIiONip6kfsyT3Ldgni8yaEF7S6mmwh
         RiVE5+b5bO/aBQe0I8ik35okJoWP4812PfxtnPttK95Q05w0A05GkYvx8oEavzq1/MwF
         j9cGBNAYalEQYap54Zh6LZf3fO8iPJlSEjDRAa/qLY/2eqaULHdJLfPQnXdpBmhIlmCm
         hq4zRzpgcEc4TxweZ0637QeyX2LTZT7qbVM1cDOFJeNP5vYuz4Nza0dUdKu6GmeeYTMt
         ti9RSo+IBj020RxyDQBx+8YzY1EoS7gsT3FTEDhOypvC8Z87PSMaSHg5UMVT/dnJL6Of
         oLCQ==
X-Gm-Message-State: AOJu0YyisurgoHNgTFFgSt6Q/84s903gTskcjQZMhaYIouw7lzeoWH+B
	OpDLvSbRIf9Ei+79RGYZXTjds901iLmKqzxe39IJErYDozD9fTNGkIVIdP1w
X-Gm-Gg: ASbGncsla9Cu+TL05whiV0RS4u2cpdgp4JI2o4EkmhzB7xcspy/Ede5t1M8lzetgHpT
	qTtcaL964JKKDBz+VqKjroiOpztjpSXKlpQXRbW5LCe788y+JsXjMNj6IkARK2jCvFNqhqoCBoe
	Nhc4FSvzbFSDZA1kGlReTfZGNK6EKJq6Op2lgsiT6oUNusqnNmS+jMHZYqRF6MKmmhmhwZ6yYIM
	CFOVLlIE7V6V7TRHmpfILEF0zkKoyRz5/gYB7jlQqX1j/yXES1HYJ/TvEG8b+Ptmp5Dgvjw74gw
X-Google-Smtp-Source: AGHT+IGMDwBk/HdJ19LeB+1GIJiPliKvAbzWDb3fNNyx2/lvOPrtK7KC2etf+PGIBiyjdTWFEP3PXA==
X-Received: by 2002:a05:690c:6c0d:b0:6e9:e097:718c with SMTP id 00721157ae682-6fd21dcaa9bmr29694677b3.6.1740562408801;
        Wed, 26 Feb 2025 01:33:28 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd117dd279sm8917967b3.74.2025.02.26.01.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 01:33:28 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Subject: [PATCH v2] bcachefs: Fix deadlock
Date: Wed, 26 Feb 2025 17:33:22 +0800
Message-ID: <20250226093323.1243266-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This fixes two deadlocks:

1.pcpu_alloc_mutex involved one as pointed by syzbot[1]
2.recursion deadlock.

The root cause is that we hold the bc lock during alloc_percpu, fix it
by following the pattern used by __btree_node_mem_alloc().

[1] https://lore.kernel.org/all/66f97d9a.050a0220.6bad9.001d.GAE@google.com/T/

Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_cache.c     | 9 +++++----
 fs/bcachefs/btree_key_cache.c | 2 +-
 fs/bcachefs/btree_locking.c   | 5 +++--
 fs/bcachefs/btree_locking.h   | 2 +-
 fs/bcachefs/six.c             | 5 +++--
 fs/bcachefs/six.h             | 7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index ca755e8d1a37..1ec1f90e0eb3 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -203,7 +203,7 @@ struct btree *__bch2_btree_node_mem_alloc(struct bch_fs *c)
 		return NULL;
 	}
 
-	bch2_btree_lock_init(&b->c, 0);
+	bch2_btree_lock_init(&b->c, 0, GFP_KERNEL);
 
 	__bch2_btree_node_to_freelist(bc, b);
 	return b;
@@ -795,17 +795,18 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
 		}
 
 	b = __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
-	if (!b) {
+	if (b) {
+		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0, GFP_NOWAIT);
+	} else {
 		mutex_unlock(&bc->lock);
 		bch2_trans_unlock(trans);
 		b = __btree_node_mem_alloc(c, GFP_KERNEL);
 		if (!b)
 			goto err;
+		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0, GFP_KERNEL);
 		mutex_lock(&bc->lock);
 	}
 
-	bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
-
 	BUG_ON(!six_trylock_intent(&b->c.lock));
 	BUG_ON(!six_trylock_write(&b->c.lock));
 
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 1821f40c161a..edce59433375 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -156,7 +156,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path, unsigned k
 	}
 
 	if (ck) {
-		bch2_btree_lock_init(&ck->c, pcpu_readers ? SIX_LOCK_INIT_PCPU : 0);
+		bch2_btree_lock_init(&ck->c, pcpu_readers ? SIX_LOCK_INIT_PCPU : 0, GFP_KERNEL);
 		ck->c.cached = true;
 		goto lock;
 	}
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 10b805a60f52..caef65adeae4 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -7,9 +7,10 @@
 static struct lock_class_key bch2_btree_node_lock_key;
 
 void bch2_btree_lock_init(struct btree_bkey_cached_common *b,
-			  enum six_lock_init_flags flags)
+			  enum six_lock_init_flags flags,
+			  gfp_t gfp)
 {
-	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags);
+	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags, gfp);
 	lockdep_set_notrack_class(&b->lock);
 }
 
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index b54ef48eb8cc..b33ab7af8440 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -13,7 +13,7 @@
 #include "btree_iter.h"
 #include "six.h"
 
-void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags);
+void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags, gfp_t gfp);
 
 void bch2_trans_unlock_noassert(struct btree_trans *);
 void bch2_trans_unlock_write(struct btree_trans *);
diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 7e7c66a1e1a6..7c403427fbdb 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -850,7 +850,8 @@ void six_lock_exit(struct six_lock *lock)
 EXPORT_SYMBOL_GPL(six_lock_exit);
 
 void __six_lock_init(struct six_lock *lock, const char *name,
-		     struct lock_class_key *key, enum six_lock_init_flags flags)
+		     struct lock_class_key *key, enum six_lock_init_flags flags,
+		     gfp_t gfp)
 {
 	atomic_set(&lock->state, 0);
 	raw_spin_lock_init(&lock->wait_lock);
@@ -873,7 +874,7 @@ void __six_lock_init(struct six_lock *lock, const char *name,
 		 * failure if they wish by checking lock->readers, but generally
 		 * will not want to treat it as an error.
 		 */
-		lock->readers = alloc_percpu(unsigned);
+		lock->readers = alloc_percpu_gfp(unsigned, gfp);
 	}
 #endif
 }
diff --git a/fs/bcachefs/six.h b/fs/bcachefs/six.h
index c142e06b7a3a..59b851cf8bac 100644
--- a/fs/bcachefs/six.h
+++ b/fs/bcachefs/six.h
@@ -164,18 +164,19 @@ enum six_lock_init_flags {
 };
 
 void __six_lock_init(struct six_lock *lock, const char *name,
-		     struct lock_class_key *key, enum six_lock_init_flags flags);
+		     struct lock_class_key *key, enum six_lock_init_flags flags,
+		     gfp_t gfp);
 
 /**
  * six_lock_init - initialize a six lock
  * @lock:	lock to initialize
  * @flags:	optional flags, i.e. SIX_LOCK_INIT_PCPU
  */
-#define six_lock_init(lock, flags)					\
+#define six_lock_init(lock, flags, gfp)					\
 do {									\
 	static struct lock_class_key __key;				\
 									\
-	__six_lock_init((lock), #lock, &__key, flags);			\
+	__six_lock_init((lock), #lock, &__key, flags, gfp);			\
 } while (0)
 
 /**
-- 
2.48.1

