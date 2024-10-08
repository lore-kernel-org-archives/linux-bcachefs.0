Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337BB1E0E08
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Oct 2024 16:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728406755; cv=none; b=b/fEz6xVNd7yxCPnRFuqPejxIXYgP5iMFqoL1/FbWD4I/2HA0q2/dCR1LopJe7f++62Eo7NTW7AUiDWp4ZHmZHlgAeZKU+HxwVyLGgCeSh+2GWPh8fyWisXk/DEAQJfM7fl5YA2tp4c9BVd9nHBH+sznhIvHoEVSivwz7Cw4b6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728406755; c=relaxed/simple;
	bh=pdurSyv86lub9Kdja562BvsRLqMcuElze1VuynRK+ws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WaVFsYyJlPU344pt113A5Os3pV1d/vZjbmYHoQe/XR9JSIxCf3CS9ekQZ8rDY/7rukDm7ExsLKuld5W0b0oR67V8v0BsbEt4C11p7cPqJYNCbVJg+INM2BV6aCmBviP9TIPO4E7atHMF/jUEF86sikucbfJI/1QDVPLX84vX3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZT2vnQMX; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZT2vnQMX"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7db1f13b14aso4643172a12.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Oct 2024 09:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728406753; x=1729011553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gE4sX7pQ6RPkZrbPn375ahzprw7KHjYSz+RUN3ABGtw=;
        b=ZT2vnQMXlGTcLa2zC0d2wBdCkSemdnMxji7ThjYS9m916Db380/SMfebHvuakvAUVq
         K74EXz8UBFSNZRmWIw9Ji7NwLLtX58/84aweqHJlYZv8bQkIAj6TfPBHSSN0pDF39MV+
         Ufcr+6Uz6eivA+IYi56q9DU+fpM3J3cGIYjJ9d84/ULPPaLvt2Bd2x05Q66UzFHOmCNW
         sQqb9Dhmrhfz+ktP4pGW2ZjLl8fWZ1T++73T8nvyz7Dsd8DV4kcCgZWW5aXxfBSXvS2d
         cmHUua8RCNaqmSFdVL3QKPoYg17Uk4xoZVSw6b0VShYP16uaolkp+rfwjHL29hPsFVAl
         iKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728406753; x=1729011553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gE4sX7pQ6RPkZrbPn375ahzprw7KHjYSz+RUN3ABGtw=;
        b=WAfXHjl4C+t8D49F/qzYUjyoL4ORi+ozSHZu0KwCHV7dxHMC+EdIGgq6ZOsEX+cU84
         SeWTjnFMdopL3Z/1ULCFRvKOVMV/Bo6DG4wrsYqb3WB+yvLmhCEqhl9u4c/zFLe/NpHw
         YiBbcQZ9oHZiyeljczNAFvsxX/EtMscXmfHG2BZpjQAgnYbGRBAdOHsZ1LVAgk+Cx4E1
         0ToDKY3mIG4fuA/2lvd2NfmPQ1VE0+CdeFufpka/MRgSPV6F74YteO/WpgIimC1bTGpM
         7IHsnb0F3hhvpEufzS/i/AmYjQokG4AyDenAvbTs8HyESlj34Yv7T8TCqDRKC425DsRi
         T4mA==
X-Gm-Message-State: AOJu0YwAzHCDFXSOdrL5RGNewgbLc3QgQAtMWo8yhBTU0QT0WGr06B32
	yKfndZvQVAyADFolCyWFW+f21mXgVT0zWMbM/dc8VXvKjz6DffhfnkohK5bh
X-Google-Smtp-Source: AGHT+IHLG7RbnFI/wQiUcXWH5KXkjKeGMpAE6GogoePTxFpgdAxhQycg0ghVw4sdxGPY7RlmLeMSpA==
X-Received: by 2002:a05:6a20:c91b:b0:1cf:5578:9cba with SMTP id adf61e73a8af0-1d6dfa35f35mr22391458637.11.1728406753389;
        Tue, 08 Oct 2024 09:59:13 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f6830081sm7008441a12.41.2024.10.08.09.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2024 09:59:12 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Release transaction before wake up
Date: Wed,  9 Oct 2024 00:59:08 +0800
Message-ID: <20241008165908.1731084-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We will get this if we wake up first:

Kernel panic - not syncing: btree_node_write_done leaked btree_trans

since there are still transactions waiting for cycle detectors after
BTREE_NODE_write_in_flight is cleared.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index cb48a9477514..ad8089019ed5 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1834,10 +1834,11 @@ static void btree_node_write_done(struct bch_fs *c, struct btree *b)
 	struct btree_trans *trans = bch2_trans_get(c);
 
 	btree_node_lock_nopath_nofail(trans, &b->c, SIX_LOCK_read);
-	__btree_node_write_done(c, b);
-	six_unlock_read(&b->c.lock);
 
+	/* we don't need transaction context anymore after we got the lock. */
 	bch2_trans_put(trans);
+	__btree_node_write_done(c, b);
+	six_unlock_read(&b->c.lock);
 }
 
 static void btree_node_write_work(struct work_struct *work)
-- 
2.45.2

