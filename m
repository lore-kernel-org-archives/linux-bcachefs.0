Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46BC1CAAF
	for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 16:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282769; cv=none; b=D6yvcDaQJp53oqhtgT6KBefKTxxLfbEhzkUXqehJ5N2c+PrZatQFYx6Kw+sprgVJjc2Z5CFPi2+lr/DwEcPWrjxyDUhXSb0hU5t5qNqBoZkcgHbEJlFs0A4Xg09lU3kZGgsc9qoKCUWjZZybaHBrzE7heBZ5ny86iDAp+0teBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282769; c=relaxed/simple;
	bh=xFAiAjtWEexK1gEGsLIJ7MhM4M44o/9HttOFMno3hpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NA5tDyMgHN22kKT81L/JFEIl2h9VQ+dV2sgbSMgavaeX4hzmnFm7VGhhM76u4ysvIaAxCU2vxMlDyE8wlak27XHrQYEAt2ckVRv7mJ2s61fdKYwgpfabNlzzzUpUKu5htG6VW7Ycq/jwu91L9vrjhuOIrYlxyib0G6x1vL+CCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L+gmnOTl; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+gmnOTl"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71781f42f75so101426b3a.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Sep 2024 09:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727282767; x=1727887567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3zfNbX4TYss17N5DL+J+H7ni7GcGqyfuHMlPAjcUvBo=;
        b=L+gmnOTlwn6/1gNIz/9QYb7zA/RL5J5sYD7cDVeyZzy9AeYv/Z+ZjrVKxeMVZLr1wY
         DeSgxPaWrzPvrx9hl9ZWQxFPX2z9zxm427dHD5+B+9kLWAlCVCqonvwkn3HLCnYM/yKV
         C+eTz2mE/wX6b1hph+d5cPCYphBwj+4oRz1wydDI0xCAqb6nQr1BRskzaMFls/K/LzaO
         V4wwsquVGUFJpfRBkPXZrzTY1PgVXQV59VXu8ne1gdX78rF5Ir9wQjd+Vf7JxTqsgugk
         Hg25tbmrXuD4DGGOfvoMGRznirSOG99JruCzBxGkcLI7zJ9sjQl4e22MpdDOLlLMp1w4
         m6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727282767; x=1727887567;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3zfNbX4TYss17N5DL+J+H7ni7GcGqyfuHMlPAjcUvBo=;
        b=oRy9FUyY0yr1nM072kewCXkT3ODOhv54g1X4+qyN4I+KhGuS58EHcI3+MtCajLC9hQ
         O3GgcO1mSc2XtAdcNuRvCT1P+1CeWXlceFop4Pjs3hDFXccGwglOrKX8532R49BwvUgI
         wVjNjregoSPCmWZaF6LIdE5awHWpoZLXIepmirjVsurdjCi/vNIkmLmekppWfzIp/vOa
         AMs0VRBWi5NZhzFEHPGXchiC2xdg9kfapBmqUhNu9yFj+gBKwstTQfFce2eQz1fG/H31
         bYm+MJROFcECbHC0U9okn5plAkGvupmdITloM+aVhDoJWh6PLJJFJysgqRIDkbrC7Tmz
         Lfnw==
X-Gm-Message-State: AOJu0YwUDeDiEXko7KyiOeWDtz+tkwGZBveheWAGYUUp5r2aBTFCxAzI
	7/ChjKbTiZMur4L5MhiyoCzuNTENOr0iy8sCUdfndUVHlllz1c2C
X-Google-Smtp-Source: AGHT+IHFiUnWDmfl9bQGEoaWV5MT9Q0SPlK4Yb6yBbbpMn7iDWNcTNh1z2KaeOASemYKdFvmPyRQpQ==
X-Received: by 2002:a05:6a00:1903:b0:70d:2b95:d9c0 with SMTP id d2e1a72fcca58-71b0aae7a2bmr5079884b3a.14.1727282767060;
        Wed, 25 Sep 2024 09:46:07 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc97c29dsm2960001b3a.159.2024.09.25.09.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 09:46:06 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] Revert "bcachefs: Fix bch2_btree_node_upgrade()"
Date: Thu, 26 Sep 2024 00:46:02 +0800
Message-ID: <20240925164602.1179117-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 62448afee714354a26db8a0f3c644f58628f0792.

six_lock_tryupgrade fails only if there is an intent lock held,
it won't fail no matter how many read locks are held.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_locking.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index efe2a007b482..617478fd5351 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -512,7 +512,6 @@ bool bch2_btree_node_upgrade(struct btree_trans *trans,
 			     struct btree_path *path, unsigned level)
 {
 	struct btree *b = path->l[level].b;
-	struct six_lock_count count = bch2_btree_node_lock_counts(trans, path, &b->c, level);
 
 	if (!is_btree_node(path, level))
 		return false;
@@ -536,24 +535,11 @@ bool bch2_btree_node_upgrade(struct btree_trans *trans,
 	if (race_fault())
 		return false;
 
-	if (btree_node_locked(path, level)) {
-		bool ret;
-
-		six_lock_readers_add(&b->c.lock, -count.n[SIX_LOCK_read]);
-		ret = six_lock_tryupgrade(&b->c.lock);
-		six_lock_readers_add(&b->c.lock, count.n[SIX_LOCK_read]);
-
-		if (ret)
-			goto success;
-	} else {
-		if (six_relock_type(&b->c.lock, SIX_LOCK_intent, path->l[level].lock_seq))
-			goto success;
-	}
+	if (btree_node_locked(path, level)
+	    ? six_lock_tryupgrade(&b->c.lock)
+	    : six_relock_type(&b->c.lock, SIX_LOCK_intent, path->l[level].lock_seq))
+		goto success;
 
-	/*
-	 * Do we already have an intent lock via another path? If so, just bump
-	 * lock count:
-	 */
 	if (btree_node_lock_seq_matches(path, b, level) &&
 	    btree_node_lock_increment(trans, &b->c, level, BTREE_NODE_INTENT_LOCKED)) {
 		btree_node_unlock(trans, path, level);
-- 
2.45.2

