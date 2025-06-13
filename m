Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1006E1E1A33
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826507; cv=none; b=chli+32C94hO2AaMvolCecmlx1fHQtmD9MacyS+j4XNJQ5IC9k8asiQ2DSmcAg+BEZfcDdsO8DwtzoIWqFVtzgETCgzQJL57eNXMYnnbgZrs5uo6ugyyO8qfRFn8+muPQQyLmONExik4ZBonNt2ooFaT6Lc/9CKE5k/U/TsPAcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826507; c=relaxed/simple;
	bh=LGE5Hrd/9/v8hWuf8jZmJQFMwaXaG7ijMKmUeifmx+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rfdNGxaVSxzKnV0EPNQ3lut5Gt6CioG7Vv0TVMIstgR9hSidfkD4zAoclHSs2VpcAl0mkC/4dX55pynkEyulW10F/CdTbptII7n22IZoyZXg/ouk8/UjWYZHmb8/qQr7E/0zpkXA55RITNL/4p/6/hYY2+MOJt9jYeTBfMQrt8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cf2biMea; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cf2biMea"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b0b2d0b2843so1787435a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 07:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749826505; x=1750431305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fkLjJYnIJxwLMp9vzbrPDn6nWGD3PIqzqWqZW2IIkvs=;
        b=Cf2biMea+omJLiBoY9+aAGSFe4BhvMPsoQX9vS0h8pBnVbkODU/t1SHOuSzhJ/Qm1n
         NzG+CvYWQiOV1Aw0zJnPFl+YLx+OAlA1PLIR29FOtSog/jso4LKZm6062hQeQZP0gpxz
         s273LddF+yAi5K4DHDO0osKQRXsrWkbSPhb1/LOoepHHbWDBYrUbg8zZUfM1EkYAcdxP
         vT3f/fTl1nrJqQ5fhDilqUFX0qqu9Hjr2Dh2uS+Wb86fS6dmVlrf0IxBcdaWeV71F7Po
         DNh0xQ9wutlSrPXqjAO8FcEJHd9fADyr9Bu7ePmlTAIK/5ALc+RawQgpNjrI6VxRBkiA
         X4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749826505; x=1750431305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkLjJYnIJxwLMp9vzbrPDn6nWGD3PIqzqWqZW2IIkvs=;
        b=Q+FgO+4ex4E7+FoiU47IssBHRGQ8I4GZx7CFzIj6RJuaCPzgzbqN3FwpOvipxrbyqy
         o0pFCHlVLMkDsC816Te41MTMlmd3QKNeL+pA49dDPEgoqtGl6YRyBvxSCTcmpjx7GTV2
         R5RZwuq0k/OEy0GbF4P99MUlMeutEAiTBv8fJJDct4vgt9lav9vOBbRA8APrCxEY9DzJ
         dLJAaEM972oKv1mgIrRn08P0u+it6uANMMlEiBYP16q2yraGIr4Hbc+0H8SiuguKT++7
         4Zpckk+I34uBBEPDn2P+0OtyOsvHkORQxEO7DzJqlRjMbZe44ztTYEWzPBT9oeL9hG1J
         mMWg==
X-Gm-Message-State: AOJu0Yxfm7nsxxiX+rVbVVfB8m4qtwzvawgiDRPt1KOi/wNgdytftwA7
	Gxdd2GwS9yKpxGdb+oatb+gzSK4nvtz+MptoZZ6OXb2mBNCSK498Gx3x
X-Gm-Gg: ASbGnctgZ/9RzQer/Oe13EuQM68VYwFizvciU46XS7mmEVaDqdBi8EOMtTx39Pe8fTQ
	UcwF0zkHOCIiJLL3IHr0gut2tCCPKx53de7cXwgR/BD4SN9GnkJ+01zVQxE0m+3W0ysMVSND3Lz
	vHFU35qXQfscsixvXKRYkUIZ13N9uOOXxQ057en1GjMzehcNdGqvg6QKrtahZSzRdSMx99EHNpf
	OBt9Mh2Hzh8EuaPhVa/KvUSXPpy1b3d/Y3VO3vHjRDDy2GAXpTfJkmSxwtub6FluzZQlhnGi2DG
	N5DKYLjZA4+ZKpfblXowQrj0MwS7dOCSBGGa
X-Google-Smtp-Source: AGHT+IFdyjAxLdrKzfaTQymyyyqIJJiOjPI3FaQ6BkZ4WF7MxptbODlXbJ9OUdtuqpybm6LQUp0duQ==
X-Received: by 2002:a05:6a21:32a0:b0:1f5:6abb:7cbb with SMTP id adf61e73a8af0-21faceface7mr4583469637.23.1749826505253;
        Fri, 13 Jun 2025 07:55:05 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe163a138sm1567051a12.1.2025.06.13.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 07:55:04 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+2887a13a5c387e616a68@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix alloc_req use after free
Date: Fri, 13 Jun 2025 22:54:59 +0800
Message-ID: <20250613145459.803003-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now the alloc_req is allocated from the bump allocator, if there is
reallocation, the memory of alloc_req would be frees, fix by delaying the
reallocation to transaction restart, it has to restart anyway.

Reported-by: syzbot+2887a13a5c387e616a68@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.c  | 48 +++++++++++++++++++++++++++------------
 fs/bcachefs/btree_types.h |  1 +
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index f6a33e34db93..566d6b5ec7db 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3159,25 +3159,32 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 		mutex_unlock(&s->lock);
 	}
 
-	if (trans->used_mempool) {
+	if (trans->used_mempool || new_bytes > BTREE_TRANS_MEM_MAX) {
 		EBUG_ON(trans->mem_bytes >= new_bytes);
 		return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
 	}
 
-	new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
+	if (old_bytes) {
+		trans->realloc_bytes_required = new_bytes;
+		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
+		return ERR_PTR(btree_trans_restart_ip(trans,
+					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
+	}
+
+	EBUG_ON(trans->mem);
+
+	new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
 	if (unlikely(!new_mem)) {
 		bch2_trans_unlock(trans);
 
-		new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
+		new_mem = kmalloc(new_bytes, GFP_KERNEL);
 		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
 			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
 			trans->used_mempool = true;
-			kfree(trans->mem);
 		}
 
-		if (!new_mem)
-			return ERR_PTR(-BCH_ERR_ENOMEM_trans_kmalloc);
+		EBUG_ON(!new_mem);
 
 		trans->mem = new_mem;
 		trans->mem_bytes = new_bytes;
@@ -3190,14 +3197,6 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
 	trans->mem = new_mem;
 	trans->mem_bytes = new_bytes;
 
-	if (old_bytes) {
-		trace_and_count(c, trans_restart_mem_realloced, trans, _RET_IP_, new_bytes);
-		return ERR_PTR(btree_trans_restart_ip(trans,
-					BCH_ERR_transaction_restart_mem_realloced, _RET_IP_));
-	}
-
-	bch2_trans_kmalloc_trace(trans, size, ip);
-
 	p = trans->mem + trans->mem_top;
 	trans->mem_top += size;
 	memset(p, 0, size);
@@ -3258,6 +3257,27 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 	trans->restart_count++;
 	trans->mem_top			= 0;
 
+	if (trans->restarted == BCH_ERR_transaction_restart_mem_realloced) {
+		EBUG_ON(!trans->mem || !trans->mem_bytes);
+		unsigned new_bytes = trans->realloc_bytes_required;
+		void *new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
+		if (unlikely(!new_mem)) {
+			bch2_trans_unlock(trans);
+			new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
+
+			EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
+
+			if (!new_mem) {
+				new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
+				new_bytes = BTREE_TRANS_MEM_MAX;
+				trans->used_mempool = true;
+				kfree(trans->mem);
+			}
+                }
+		trans->mem = new_mem;
+		trans->mem_bytes = new_bytes;
+	}
+
 	trans_for_each_path(trans, path, i) {
 		path->should_be_locked = false;
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 3aa4a602bd02..112170fd9c8f 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -497,6 +497,7 @@ struct btree_trans {
 	void			*mem;
 	unsigned		mem_top;
 	unsigned		mem_bytes;
+	unsigned		realloc_bytes_required;
 #ifdef CONFIG_BCACHEFS_TRANS_KMALLOC_TRACE
 	darray_trans_kmalloc_trace trans_kmalloc_trace;
 #endif
-- 
2.48.1

