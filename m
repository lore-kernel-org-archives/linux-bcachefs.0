Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF2F30E82B
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750363113; cv=none; b=MJuo1CuIurHlvgTUs7FdHd3EvMqsa/6olUj3sqjWoCczGfZ9TU8793DgRDLV/SN0ZcxI+SvJxfy90N7Pv3b1Vs62kEA0XcKtCzZLXt7Cnku5bo0L8fBhEM3Z+d414nunILZQwBeKUKzK/O6AOzBWj1Swt/3U1k0FePQp0qWzTZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750363113; c=relaxed/simple;
	bh=Tm5i+p3GeCIi6Hjrk3GQe0o3bymSiyUJENtZ89ohARE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=adLvyibDpNqS+8PDTJWgnwivO7Qov/iVqbGGTy+v05JU/vVwXYby8s6D4wQULzREMMfo7IqTHXCSYrfvC3mQlWV8VZUiVNe1Z9tZElsNPXJ6rb76q0IyKbQr725avnJjq6h4gAsMTGtOHsJqmTMILXdiJ7GH9TbQXOc9069r3fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d57y3B24; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d57y3B24"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-235f9e87f78so12111045ad.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 12:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750363111; x=1750967911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dV1geGXuaNfzgK1qMYvYFxKP7LCstxbTy8/aT4DtQnk=;
        b=d57y3B24mWkE9hrwzpUgN0jo137aUhHB10i2T+ERe3b1bdRMgu7T73v6OebsnNfTnO
         NnejsaMTtNKawex15JSrm5VOG8IX5fYIeKSWgyIxQ6JVWzfRcRuGnbUg2RkkQ/4dEqYM
         SU1kuQYb9pPJDHi6Ugv5/z4ik3BamsTvSmD2TjEHOFYW7gyMKHxz964IcYyXfbAhz6yK
         GhEWFOvR+9IZbvG4k7ktcPfkapR9hgNWrbkKtP00ANaD6UUMsDBRA8or0B2y/UmvZ0f0
         7DciAlRwRlnIfMzpefYMV1xisj5RwZCTcUploi4K/cHTH7hiujph8dwJHfX+3XRgHE0L
         sGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750363111; x=1750967911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dV1geGXuaNfzgK1qMYvYFxKP7LCstxbTy8/aT4DtQnk=;
        b=ZTEjoaDcQ9RgGSNloR8NSk2LkKJK4R//htiCaAfIAWOHHan/VvNI/DsdHs52k39TLz
         j3kR88996YIJYvXzzRdgOHsfsKO+CuhwUQgurZhnM+bq9agpFo7lkj7oTYV1gnDYb4S7
         4E/iKE2SDlFLccSzJOJqWLrUkPIqO94qg+yGGjFTE12Wb/nMtpHFRqobgB0qE2+ZThVy
         hNCy+s3Me2GPTgXJlF3BNmN/ZKC7CGP5c1nuVcdwu7nD5J8zfZHDXntxxxdh3qXHcnEi
         6r8WAGXVrqHjLwRCRVdnpQWD7rGdVIjZh4W7HEHs0eMrZoi17chVbg4lO3dqEwNdxrV4
         Cw/w==
X-Gm-Message-State: AOJu0YwcdsJJviGippzLIJeXu2znyT/Uj4xprJgP5QRyj4OK8z1Enb10
	zm1q1iADtMwKsv+ltTEIy7jXZ5q6GniJXMOClSUjGld2FQC3MWWgEAuU
X-Gm-Gg: ASbGncuVDNpQNI2ILniuiXKGbUSnNtxCVksnOxL2xWKQX0F7fjlgTlcLSbteKnzrRFS
	lYYCdqRCzgjGoMbdv4uLvS6inkt0oSny2bDCPNHXjrm5ZXwcFb4Zvd78H/epMx5VQK7f7ciRbxT
	bj9y7pC72EPyLB9kf5eCNr3b8Kl2j+2WCDes3hKCKX2igPbZQWEnz6zJQLScmA2Q+EqJcZiHVt8
	cWxWbWu8wvjIJKDYSJI5CYVAHhe3FzBiw4yvoXWYhP4+OfdtaC5LU/9Q1W2ta+vBnwj+8QbWVKd
	SzCY3yutRFxASI3nyoDfL/LxdZhnkYDMd2NF
X-Google-Smtp-Source: AGHT+IGGBQB0hFhyDFX6hx+g0jpdmqMrRRcUJb8s9D9Zhz3pbXJxxcqPcM8a23HUcmOg3y2uDN96kg==
X-Received: by 2002:a17:903:320b:b0:234:8eeb:d809 with SMTP id d9443c01a7336-237d9b42e77mr1124425ad.43.1750363110853;
        Thu, 19 Jun 2025 12:58:30 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d860a8b4sm1470375ad.90.2025.06.19.12.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:58:30 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Refactor trans->mem allocation
Date: Fri, 20 Jun 2025 03:58:26 +0800
Message-ID: <20250619195826.983765-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.c | 65 ++++++++++++++++++++--------------------
 fs/bcachefs/btree_iter.h | 14 +++++++++
 2 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 352f9cd2634f..0168c4023c74 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3238,32 +3238,30 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 	}
 
 	EBUG_ON(trans->mem);
+	EBUG_ON(trans->mem_bytes);
+	EBUG_ON(trans->mem_top);
+	EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
+	
+	bool lock_dropped = false;
+	new_mem = allocate_dropping_locks_norelock(trans, lock_dropped, kmalloc(new_bytes, _gfp));
+	if (!new_mem) {
+		new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
+		new_bytes = BTREE_TRANS_MEM_MAX;
+		trans->used_mempool = true;
+	}
 
-	new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
-	if (unlikely(!new_mem)) {
-		bch2_trans_unlock(trans);
-
-		new_mem = kmalloc(new_bytes, GFP_KERNEL);
-		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
-			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
-			new_bytes = BTREE_TRANS_MEM_MAX;
-			trans->used_mempool = true;
-		}
-
-		EBUG_ON(!new_mem);
+	EBUG_ON(!new_mem);
 
-		trans->mem = new_mem;
-		trans->mem_bytes = new_bytes;
+	trans->mem = new_mem;
+	trans->mem_bytes = new_bytes;
 
+	if (unlikely(lock_dropped)) {
 		ret = bch2_trans_relock(trans);
 		if (ret)
 			return ERR_PTR(ret);
 	}
 
-	trans->mem = new_mem;
-	trans->mem_bytes = new_bytes;
-
-	p = trans->mem + trans->mem_top;
+	p = trans->mem;
 	trans->mem_top += size;
 	memset(p, 0, size);
 	return p;
@@ -3324,22 +3322,23 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 	trans->mem_top			= 0;
 
 	if (trans->restarted == BCH_ERR_transaction_restart_mem_realloced) {
-		EBUG_ON(!trans->mem || !trans->mem_bytes);
 		unsigned new_bytes = trans->realloc_bytes_required;
-		void *new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
-		if (unlikely(!new_mem)) {
-			bch2_trans_unlock(trans);
-			new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
-
-			EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
-
-			if (!new_mem) {
-				new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
-				new_bytes = BTREE_TRANS_MEM_MAX;
-				trans->used_mempool = true;
-				kfree(trans->mem);
-			}
-                }
+		EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
+		EBUG_ON(!trans->mem);
+		EBUG_ON(!trans->mem_bytes);
+
+		bool lock_dropped = false;
+		void *new_mem = allocate_dropping_locks_norelock(trans, lock_dropped,
+					krealloc(trans->mem, new_bytes, _gfp));
+		if (!new_mem) {
+			new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
+			new_bytes = BTREE_TRANS_MEM_MAX;
+			trans->used_mempool = true;
+			kfree(trans->mem);
+		}
+
+		EBUG_ON(!new_mem);
+
 		trans->mem = new_mem;
 		trans->mem_bytes = new_bytes;
 	}
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 09dd3e52622e..cc2c6bb6b6a8 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -963,6 +963,20 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_trans *,
 	_p;								\
 })
 
+#define allocate_dropping_locks_norelock(_trans, _lock_dropped, _do)	\
+({									\
+	gfp_t _gfp = GFP_NOWAIT|__GFP_NOWARN;				\
+	typeof(_do) _p = _do;						\
+	_lock_dropped = false;						\
+	if (unlikely(!_p)) {						\
+		bch2_trans_unlock(_trans);				\
+		_lock_dropped = true;					\
+		_gfp = GFP_KERNEL;					\
+		_p = _do;						\
+	}								\
+	_p;								\
+})
+
 struct btree_trans *__bch2_trans_get(struct bch_fs *, unsigned);
 void bch2_trans_put(struct btree_trans *);
 
-- 
2.48.1

