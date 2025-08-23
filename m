Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650AE134CB
	for <linux-bcachefs@vger.kernel.org>; Sat, 23 Aug 2025 18:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755974501; cv=none; b=P535xxAJD7ZJnCnI8b/FQZpBxYDHxABxVGkmX7uIbe2cqazhzORYrBTYO3yV4LbfXqjGeOtav/Y1xsPrauZ+Gs/zoxUSbkJBoGaYGjt/CQlW2pq8ry1q+ccsSSMGlXdBVHfuQqoAS2gODmwwvF3WBujW1sMlwWwxa0lAN7jrFu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755974501; c=relaxed/simple;
	bh=cIsNhJljikm44M6CwSrLxp4CA24AUGjeyll1iSOZTDU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Els9lpgRcj4Ay+yEtmpefjd4VYSsnnieuLTzlNSBLHC5l+ZZiY/SO0yF3IA5JNnO8xnV6sZwZ3x5JrV1wlVGIiIrGjA9U0Ly2FslsPeCl/VTwl4ZhhuAHbk/sNBYZzToM5SjSumQRvkMV6AyQhBPvtuzRDEie4yFWBfiIMqVKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIe/7wH3; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIe/7wH3"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b47475cf8ecso2242838a12.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 23 Aug 2025 11:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755974498; x=1756579298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XrzGQOfmPlJY3agjJKueg+y/YlL/pw26L6RW8Zpdf/8=;
        b=YIe/7wH3BeQzWrARruVdT/l6uzfioIaTuMEYRICd41eiUTuJRdG8IGpImy/NFiz+lm
         olxntPKGqWsP7WpQLvVBVSLZVzOdHOfgGXAFiKNLn+piQKIzGMXXwNaFLXK74AMNVfcd
         80hmE3Ozd4PwvY+BtlzpVL13MyWDwS+rpj02W1luenIgikjU/Dm05zjHLNdec5pWdzq8
         BAR4ApRY18MhtJhIKyjFSS2/WIhRDxF2TiL9yn0O2zYLjK2uNxySVxyw/xHhf5z4k1VF
         ncfOikqThQ5BIzHnAGE3AAexbI/eYfM2kYweZbuzUDvzylaNiZRtxYhE21YbP6BNPhuG
         3yUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755974498; x=1756579298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XrzGQOfmPlJY3agjJKueg+y/YlL/pw26L6RW8Zpdf/8=;
        b=CXAteNed9V7H/LrsFTh7AZk2fvbbZ1aoZgb5xUQDhCPY0W2FBoJMqU8/M/p+7HOErR
         O1eKAAPQ35XrlG8R2jjfxo0wjahCJssLwtJH5NNGR+MMeAqyCgw4ywC48BdHcTiYULpA
         riUSZUQYFx3j5mDczmqjD6+JXt4wSYyiX7OrUDCHo1wt0UXfPJN8Nrq63W8Kxp/9QD7s
         ikiSl6yYHuqOv6tMBsDZE7nlXvjsC7UWjRJe+LxZ6VBYWfqETFgEgdo46S6mBGb2Weps
         zd6RxPCiwW5gzsXxdrFR3VUaLkQt4bsceN4b9pz2RGsT/O50Y9HqMJ0xlJ038ZxiSDXQ
         0Ikg==
X-Gm-Message-State: AOJu0YzS+52G9vc85WRMDmKIOH6l9Z0mex8l58v2IkdwglVOgvV3aj1A
	ovKnL1y5ot7/InOnwxpccxs4yRKVv0BolYHJ+DN7rzkAHFqhR+MBcSR4
X-Gm-Gg: ASbGnctlz2XGsp9cZ7zyHcmSuii6k01TVU1m+xG1BZEAx/jUOJ+ZDlEt1LoDkZcVZiI
	dA5n8r+Mw8U7NLxeqad1buhnyUAmW7cZRpg31NcAHVFLvKp0nuosUHW9lqdnPLOC6JOrewfIq8o
	o7NJKmvf1Vu21ESjJWSlUP0e4Q7ds6Su9I4UdXsMJ+axoV7sZvFMu9xS7YFaRKsiqFOcmPtINi9
	X3GCLskFOvggh6Ho3gEMpVSIhjO6If9w6Tz1F7ewQu0Dc5D7M9S4rmnKsFt+d6yVARmlbLrQl2I
	QPIlPaJmotL2PXUz4vU5DIqdYTSxtbmeHi3BFklRT8MFybO5UzGMKkEQnk2HpETllsSUmAGLU8x
	ccR6n2uw=
X-Google-Smtp-Source: AGHT+IE9tmaPe7bTY0kG8cBqtOeCmH/btCAu4GzjwrE4v/msY9NbMP4LrnCNpqwod/A8WgzOp+WYEQ==
X-Received: by 2002:a17:903:2289:b0:240:a222:230c with SMTP id d9443c01a7336-2462eddceedmr109917535ad.12.1755974497564;
        Sat, 23 Aug 2025 11:41:37 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668864a5asm27257185ad.84.2025.08.23.11.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Aug 2025 11:41:37 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Kill duplicate error code
Date: Sun, 24 Aug 2025 02:41:32 +0800
Message-ID: <20250823184132.235684-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btree_node_read_error is duplicate of btree_node_read_err, which impacts
repair path if misused.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c         | 2 +-
 fs/bcachefs/errcode.h          | 1 -
 fs/bcachefs/sb-errors_format.h | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 2e3dd9bacac5..3d594c4ae9d8 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1902,7 +1902,7 @@ static int __bch2_btree_root_read(struct btree_trans *trans, enum btree_id id,
 		scoped_guard(mutex, &c->btree_cache.lock)
 			bch2_btree_node_hash_remove(&c->btree_cache, b);
 
-		ret = bch_err_throw(c, btree_node_read_error);
+		ret = bch_err_throw(c, btree_node_read_err);
 		goto err;
 	}
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index adc1f9315eab..7106d72fca80 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -295,7 +295,6 @@
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_cached)		\
 	x(EIO,				sb_not_downgraded)			\
 	x(EIO,				btree_node_write_all_failed)		\
-	x(EIO,				btree_node_read_error)			\
 	x(EIO,				btree_need_topology_repair)		\
 	x(EIO,				bucket_ref_update)			\
 	x(EIO,				trigger_alloc)				\
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index aa0ea1ec9f10..483358588abc 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -73,7 +73,7 @@ enum bch_fsck_flags {
 	x(btree_root_read_error,				 59,	FSCK_AUTOFIX)	\
 	x(btree_root_bad_min_key,				 60,	0)		\
 	x(btree_root_bad_max_key,				 61,	0)		\
-	x(btree_node_read_error,				 62,	FSCK_AUTOFIX)	\
+	x(btree_node_read_err,				 	 62,	FSCK_AUTOFIX)	\
 	x(btree_node_topology_bad_min_key,			 63,	FSCK_AUTOFIX)	\
 	x(btree_node_topology_bad_max_key,			 64,	FSCK_AUTOFIX)	\
 	x(btree_node_topology_bad_root_min_key,			 323,	FSCK_AUTOFIX)	\
-- 
2.49.0

