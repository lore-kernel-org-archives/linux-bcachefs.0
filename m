Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0630481C4
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 13:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749820803; cv=none; b=qzYvpObfIYpmt2em3cIRKsHhZmoAAsg6O30TJBrQwrJ2ljAEOOmwAjWGF6WRlVgiPKhy6NF7g2UKLXZhntY/0gSyGgvE8qP8asIqNELsQjHhCZ5+9tumYaeOMaxpsV213tzkjKPYawitVgnstYg+KODC48rNjsWiOJNpLV2aY6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749820803; c=relaxed/simple;
	bh=JmW+LxiX/e0M+Up7fN500MsXLy2oLFyIndDP/pL5S3E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FHhrAS8cIWy6up8r6YhgSLQ9CONN0B3nQbs49oVkCDr9x7Lu/V7FZKTR4eyvPOib4rJeQChsB1WLSRz5M3nQmKMb7zCllCZW5ofivO8AiI3FJ3TYgtkLefHsyvWBEZ5jkzRbe1WR7EDNX57BWIskRC3J0+nqHO8iKOAn6hnFsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G+rRM1BY; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+rRM1BY"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74865da80c4so1347792b3a.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 06:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749820801; x=1750425601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOybD3d40SulgegsS27ptrq+3aX3/JtjTGmgcxXtvPw=;
        b=G+rRM1BY1Mp7l840nRQGRgeo10zEN7D6HZ+Ef4FAYm+WLdZwOgQT8n9GluNP203WOv
         zFmEZPVLZkCYzYL/LvQA5mFyZGK8Wx7oGyg4FiC8g//+1sA7vN2uXkH31AraYJ+pM1WW
         v9xXJ2DxZWsZqrJaSNCUcPkVUUiAlIVH0oVmT5AgmzXDhz4l9VnY6EOfdYlbVbt2ODFV
         FF7QBcU/GVQKedQmGcUWkpqdGWpFHPVsRNzjjpPhRNbp4wmjObUd6ZtWJEJtXJ8Ledif
         tjn5gC+Kp660GaS6+tb4P/YoH+ZeNx/60Ndeey9++vpi0xbJSV9qPobVlcpNQilfCHCd
         c8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749820801; x=1750425601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZOybD3d40SulgegsS27ptrq+3aX3/JtjTGmgcxXtvPw=;
        b=eMfs2tIEPcZyhQYmcHwC6T6nEYH3exWSFn1M2IbNkcIHmVRQ/P6tIjYVxYLxgvEaBl
         CGyyXV8Dj9rIlaTAFYYp9dLARMsQc3ez5H+Y9IrmRr0x8YRuhGCP2JJaVqcS7bP9vTuy
         XmHrb80Im9NBvo/MZPwPZBJ/DVyKLfoEr3IHyoyiOl5jsgCn8MHAQhWvdD66PqAEr+mn
         AinKr+nl3gY7dcYBSPWcfz9tOhmUGm6bqFMSFJOT+y8eSm52OZI7iqk2Br7TBMXYdLE6
         DzsktOPAfZp8MQuJumqYOmUVKkWq5HWKDzy9cjgcgjk1x05ZcapFp5yFZlYTKIMolHOr
         kP8w==
X-Gm-Message-State: AOJu0YzZdoqvLBitOY9wcBqGhQnwxhtGsuhHl5CwrimikXyEuKAAz8UC
	Yk/WCj1S1C58qPE47B5sZ5fOcLe6+fHYISpw0HVD7HgHyF9+odN+XcpejNLAXg==
X-Gm-Gg: ASbGncu1pzhZd7dcFc2k1aKMTWqcbyA0ZYEyIDCFIIfvIO6QSc90SUVhfFcuejVIRbY
	EVT0tnuAdY3DdSVGX/hXQPrbJnq+4moPtkWMjz+10gvrTUpc5fkILo+uyQMGjToa5jGX8E9ZElv
	67q1P5DbIogbJqbiR4EXj5I612Yo8IJZFKp1fvYTJKhsFz5Gl1LbsjDm25odRwo15FroZ4Ghos8
	IaidDO3TeMorTDDcRjW45ezorfB4oQ3Hv0xKaKNUD+vdetZG1dl+qdb4oDblgsKAzaQHmU1sQ1V
	o2Jk+ICLvxAL4MX/AM6BIzK35L5IaQB7JSmu
X-Google-Smtp-Source: AGHT+IG6NCkMfbDVKE4G918GkOzVrIK7EMXr4fBym02rABhwYu2WJS6Zrrxex47RpXErfetP1WKpgw==
X-Received: by 2002:a05:6a00:66cb:b0:748:3a1a:ba72 with SMTP id d2e1a72fcca58-7488f7df54emr4194527b3a.20.1749820800931;
        Fri, 13 Jun 2025 06:20:00 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7488fff68b7sm1514361b3a.7.2025.06.13.06.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 06:20:00 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	lihongbo22@huawei.com,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Don't allocate new memory when mempool is exhausted
Date: Fri, 13 Jun 2025 21:19:50 +0800
Message-ID: <20250613131950.799233-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocating new memory when mempool is exhausted is too complicated, just
return ENOMEM is fine. memcpy is not needed, since there might be
pointers point to the old memory, that's the bug.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index b78403376c07..f6a33e34db93 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3160,28 +3160,8 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 	}
 
 	if (trans->used_mempool) {
-		if (trans->mem_bytes >= new_bytes)
-			goto out_change_top;
-
-		/* No more space from mempool item, need malloc new one */
-		new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
-		if (unlikely(!new_mem)) {
-			bch2_trans_unlock(trans);
-
-			new_mem = kmalloc(new_bytes, GFP_KERNEL);
-			if (!new_mem)
-				return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
-
-			ret = bch2_trans_relock(trans);
-			if (ret) {
-				kfree(new_mem);
-				return ERR_PTR(ret);
-			}
-		}
-		memcpy(new_mem, trans->mem, trans->mem_top);
-		trans->used_mempool = false;
-		mempool_free(trans->mem, &c->btree_trans_mem_pool);
-		goto out_new_mem;
+		EBUG_ON(trans->mem_bytes >= new_bytes);
+		return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
 	}
 
 	new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
@@ -3192,7 +3172,6 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
 			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
-			memcpy(new_mem, trans->mem, trans->mem_top);
 			trans->used_mempool = true;
 			kfree(trans->mem);
 		}
@@ -3207,7 +3186,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		if (ret)
 			return ERR_PTR(ret);
 	}
-out_new_mem:
+
 	trans->mem = new_mem;
 	trans->mem_bytes = new_bytes;
 
@@ -3216,7 +3195,7 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		return ERR_PTR(btree_trans_restart_ip(trans,
 					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
 	}
-out_change_top:
+
 	bch2_trans_kmalloc_trace(trans, size, ip);
 
 	p = trans->mem + trans->mem_top;
-- 
2.48.1

