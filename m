Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2791519A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Feb 2025 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740478184; cv=none; b=mvwxN4QrKYXqNF+aco17SHGIOjqcKi0v93f3e2LV+nS6oFVa5zbAWzOZlU/Lstgc1IRoP+LxqQI+3c+f+b9jQoWeG8+OLBmsxjokdiYoiAf8IYog//r1hMfgacKXxODZmBBGwvKHyP0CAuNAHUQ4zlp5vAUO8ukIyvot0jln0x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740478184; c=relaxed/simple;
	bh=2hdZvwvB/v7rFgRITkH9bnlZ9+Zu+0ryhooJm/QZwYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LVkGrYKpxY4VQes011gnXjpqi80OsdqxTdL2+fMtpL2P5qhjbqeKHzCyva7ppWXtL6a74sPw/wlcWR41/Fmnh6DK3JM3uN3vNfmNxUk9To4yT2wKaN3KAiA5c1UwUts65b1ilnPLZvpU3FXr6pR1TgQSdpJYSFe2JGtCypFMPNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hnZofhhr; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hnZofhhr"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6fb6c36ba25so47086027b3.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Feb 2025 02:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740478181; x=1741082981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4dEULhXu3tqrT9hcHJhm+GE/iEkjmRlKH6o7kEW1Ws0=;
        b=hnZofhhrAbeVjMp4Qr6X8wq5cNJQmLCB14v6oBypOsyOaENcRtgBQvByp7KX/mtrj3
         USE4PH2l/FCiKwTGSnyScqM0wt8OBSZc4uZEo4GYVelJ2J0Rvrv+CXT1js4PMCe8xYss
         Qx1ZZuEyXi8FGLtzF62Z+mYZENwlWp5JmYGVAnqdJ9cGeI0dpeJAu4xp7bpV92d8yDgR
         1KQ8YCHZ2IE921MD/YI7oso9VFhw/co9hDRtkK6gtBVKcoIPhDi3uKLsP83r2Dg9vHg6
         pXzuP20nEmyq7KSGNmv3bz86jCnjErzetpwly7NySepzdbCeLOtU/ih4oNACQKlrPnaH
         vgEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740478181; x=1741082981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4dEULhXu3tqrT9hcHJhm+GE/iEkjmRlKH6o7kEW1Ws0=;
        b=E9HNFf9VCfHY5rHs4Rw27m/ZF+jL9IwC0xLvdnd0ETZueqajLENffPgu9Qn0WbCT8+
         ZIhwglOzr0Xw0MZ4zDIg1mfImI7cY44E0BQRQWetiQLBMNxJUGLp9muaVNwCn4TbshkW
         oEzxn58EaGcL7+OTtqEzcwy3UVtU71hug2Cy+x9tUdG752xegkjy1Oq2mPk08IRpoDSn
         gNp+owwtq749bDakYWqOiP2oL8Sd3Zj2PHBtbgZkBuX41Zn5Kt4978Y30NDQTFX5V7ZD
         jI1b8c2s2fFzLes3ZOlNpmN5UVnf0UhtYhsKOnnsRa6w7PGRbMVEsU9UtxGE3Z0bjZYq
         9KMg==
X-Gm-Message-State: AOJu0Yw7M+1pcoFUsKCgBGHtzSW1NChyC2vR1I33bqYB8y90ZwpgWbIr
	zTy/QddWSJr6JGfnSx/ORnesWuIIshsSoy018uE2ZFYL2msTZTKZlrVrAirB
X-Gm-Gg: ASbGncs/gFyjvMrZPc1v8hu5hwPpld8Wb1IyTerW5wGRFdaE2dcphorqDUGsBoXyoyK
	kA+zXZ1b2eI1OSndQrsenZjJ3uh1zxvG3GBObL+5Wwmke3iGHpFj1NNFPH6+u01/BKpgEhN8kkM
	iNr1iGslridEol6jAXgWHLco9FDtGQXKDA7OQMwN2xGPuC/Gi+l2B1XC50ypHfNZBK2K7D68pm9
	NglmIzlzPENVDvS3D6nZ0gG8UWWI2/oJbepnRyLBgkJPhVwSVihtgqHEHh8/ez/Mb1Ey/CH0fT1
X-Google-Smtp-Source: AGHT+IFdSSc1c425d1KkYKogN/qQQcOjhwBEKB+/sJ3g8GLywZIYBT1sJpq2Y91cN4IqcOFEJ/n9Hw==
X-Received: by 2002:a05:690c:338a:b0:6f9:b027:1bfc with SMTP id 00721157ae682-6fbb78e2474mr189213397b3.3.1740478180988;
        Tue, 25 Feb 2025 02:09:40 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6fd117dd926sm3427587b3.89.2025.02.25.02.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 02:09:40 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix deadlock
Date: Tue, 25 Feb 2025 18:09:35 +0800
Message-ID: <20250225100936.1222701-1-mmpgouride@gmail.com>
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

syzbot test: https://lore.kernel.org/all/66f97d9a.050a0220.6bad9.001d.GAE@google.com/T/#m92500622db70f4e4974576c390a51697e9e46314

 fs/bcachefs/btree_cache.c | 7 ++++---
 fs/bcachefs/six.c         | 8 +++++++-
 fs/bcachefs/six.h         | 1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index ca755e8d1a37..87be42fc889c 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -795,17 +795,18 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
 		}
 
 	b = __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
-	if (!b) {
+	if (b) {
+		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU|SIX_LOCK_INIT_NOWAIT : 0);
+	} else {
 		mutex_unlock(&bc->lock);
 		bch2_trans_unlock(trans);
 		b = __btree_node_mem_alloc(c, GFP_KERNEL);
 		if (!b)
 			goto err;
+		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
 		mutex_lock(&bc->lock);
 	}
 
-	bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
-
 	BUG_ON(!six_trylock_intent(&b->c.lock));
 	BUG_ON(!six_trylock_write(&b->c.lock));
 
diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
index 7e7c66a1e1a6..81c832061331 100644
--- a/fs/bcachefs/six.c
+++ b/fs/bcachefs/six.c
@@ -865,6 +865,9 @@ void __six_lock_init(struct six_lock *lock, const char *name,
 	 * userspace:
 	 */
 #ifdef __KERNEL__
+	EBUG_ON(!(flags & SIX_LOCK_INIT_PCPU) &&
+		(flags & SIX_LOCK_INIT_NOWAIT));
+
 	if (flags & SIX_LOCK_INIT_PCPU) {
 		/*
 		 * We don't return an error here on memory allocation failure
@@ -873,7 +876,10 @@ void __six_lock_init(struct six_lock *lock, const char *name,
 		 * failure if they wish by checking lock->readers, but generally
 		 * will not want to treat it as an error.
 		 */
-		lock->readers = alloc_percpu(unsigned);
+		if (flags & SIX_LOCK_INIT_NOWAIT)
+			lock->readers = alloc_percpu_gfp(unsigned, GFP_NOWAIT);
+		else
+			lock->readers = alloc_percpu(unsigned);
 	}
 #endif
 }
diff --git a/fs/bcachefs/six.h b/fs/bcachefs/six.h
index c142e06b7a3a..d188f699339f 100644
--- a/fs/bcachefs/six.h
+++ b/fs/bcachefs/six.h
@@ -161,6 +161,7 @@ void six_lock_exit(struct six_lock *lock);
 
 enum six_lock_init_flags {
 	SIX_LOCK_INIT_PCPU	= 1U << 0,
+	SIX_LOCK_INIT_NOWAIT	= 1U << 1,
 };
 
 void __six_lock_init(struct six_lock *lock, const char *name,
-- 
2.48.1

