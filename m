Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD722DFA32
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 05:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695208; cv=none; b=I/f+14wlaDsmBYW3RDKJNbx7Ch1SrUpWszeUMmVICqMdVQPTXUx0Ay8EbQl+3BGP0naHw1UTF8fEASDKeReT2zOEJdrNs3xDhnzEqnLdjIvq7yC4KU2wZ8GHFZQG1wGFsXF4nVOxKvdvIjeA2DjjWnvH4VduLtIWgZcTQNAsRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695208; c=relaxed/simple;
	bh=7sThXsdWoIeQOmIQac4Mb56XaHYhtdlNotw+UbGt6FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAlEnqb9W7UAOi04J2CAiVvZTi1vVLsWjt6u0VbsknqGa5Sb11wSSA2mRduZFWk16u65S3TmGRBM/iPOglOtP+tWN1qLwkJzD9DD09bvW+cABDkMtiEgADuKiSuQ3rFk1+DvSRxa/f1n8N4Mz7+HwiwqHBRAkl9sCcwxi+qCivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H/mFGfTu; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/mFGfTu"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so5015500a91.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Apr 2025 22:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744695206; x=1745300006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rMZzC5BZIyonpUo1ibIldGYnFQZJsgNHd0vF9utQuo=;
        b=H/mFGfTuPMxaYQObhwknYVWELrKUUj9WidmhvC70Qn28yi4WPWbQum5HxkEUqGNmjF
         Ce0bDPo89i8IvFQrEXSOWv5VrcIHiYZo5gYuBPlkc7tWl8fdV+0ZJfNXxILrg5fgWFCL
         Z8yDtmdZ1SRgfGuF3K1YMTJRUT7GKhDLinRjzpb7S5rblvyHGSZm0PmpzoiTdkhAiwe1
         0hkww3iFq4Djva2mnGDNtzgOqNQgN+LkysaB1exq+X1s46sHUJCUPKKFy2qXptL8h+5/
         if0D/k3vk5k99v0KPPbLcTaKE+njn5EtT76ULTsPsCE6hOH9XfNtv1Ij7FTp6kFowZuu
         nsHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744695206; x=1745300006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1rMZzC5BZIyonpUo1ibIldGYnFQZJsgNHd0vF9utQuo=;
        b=FLOlwsJO4nZNhkyctQDzcmSi0UzJXBNb66M6uppZ7vN80ld+kYJxgRJA81MzQT6tPC
         5PM3lQFoAIKpgxnrEKWKXQXAJDZFWBSwNC2s/DrNAF/WVxqR05xXT9QaYpAzNFy3ugO5
         6rkqBu1PowqwMBUqtD/nnJ89oH4xXWMaf0VMy18rZ8dIe0f+egajtg8LU7HqoD870r6y
         R5dz7BsxJ/bOANDI+Dz7Ztruu7W/S1m1o9yNDVqHkWLdle+lIYEv07txjvnAEbLZv/Ry
         Cu3zhKK2sKp1lp58xXT4oeP6sGnS8mM7yy+l6a890YNQ8bz0ky5jmadxLR2gkBU+kk9p
         dsew==
X-Gm-Message-State: AOJu0YwumzxJZPAlGGhNC3VG3fjEFTI9NCkGo+YqSDS4u3DyEKGIiKYZ
	48TnF3ACf3dmxZfc9LeEH5J7uKeZEHKyR8aRkQMg5a3nlREbN6kq
X-Gm-Gg: ASbGnctK5DK4iAQhQk+nU33FpOiqoT+3xuCYlvnX5t90teA4rZXytq3MoZeNjeYd3ta
	vjB8/LlAioqtSM2VACqhlJwqrdD5L4PVb+3e8lJ2QZLLmHMptZxQmJeT6OumJzYCICM1UhkeGpp
	gdaMkUMsJ812jxLGZHt8nKYR/th2cntx/df/IMZAQ9lNhIJvFqEYFHI53dO8L+HrjG1eJ3ESMkP
	lKEhxhClwgdH/uoZdJT6JDNi6jTabhoQl5eKF9K2AU7YyPBXwvK0lnLtJwFCk5UcIhpSjAOG/2W
	LIW9y9RJ/RE1Ihk=
X-Google-Smtp-Source: AGHT+IF/rsNzAY2+uetpb0OQsNu42iDNzwl155gRt1gwRST23amdtUDBazDjd/xy8qJsi3Kk9z31kg==
X-Received: by 2002:a17:90a:d64e:b0:2ea:3f34:f18f with SMTP id 98e67ed59e1d1-30823646c64mr20460838a91.19.1744695206020;
        Mon, 14 Apr 2025 22:33:26 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-306dd171991sm13721876a91.37.2025.04.14.22.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 22:33:25 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 4/4] bcachefs: Simplify logic
Date: Tue, 15 Apr 2025 13:33:07 +0800
Message-ID: <20250415053307.81354-5-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415053307.81354-1-mmpgouride@gmail.com>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 14e3329baa43..afcd13092807 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1017,7 +1017,6 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 	bool used_mempool, blacklisted;
 	bool updated_range = b->key.k.type == KEY_TYPE_btree_ptr_v2 &&
 		BTREE_PTR_RANGE_UPDATED(&bkey_i_to_btree_ptr_v2(&b->key)->v);
-	unsigned u64s;
 	unsigned ptr_written = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
 	u64 max_journal_seq = 0;
 	struct printbuf buf = PRINTBUF;
@@ -1224,23 +1223,20 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 	sorted = btree_bounce_alloc(c, btree_buf_bytes(b), &used_mempool);
 	sorted->keys.u64s = 0;
 
-	set_btree_bset(b, b->set, &b->data->keys);
-
 	b->nr = bch2_key_sort_fix_overlapping(c, &sorted->keys, iter);
 	memset((uint8_t *)(sorted + 1) + b->nr.live_u64s * sizeof(u64), 0,
 			btree_buf_bytes(b) -
 			sizeof(struct btree_node) -
 			b->nr.live_u64s * sizeof(u64));
 
-	u64s = le16_to_cpu(sorted->keys.u64s);
+	b->data->keys.u64s = sorted->keys.u64s;
 	*sorted = *b->data;
-	sorted->keys.u64s = cpu_to_le16(u64s);
 	swap(sorted, b->data);
 	set_btree_bset(b, b->set, &b->data->keys);
 	b->nsets = 1;
 	b->data->keys.journal_seq = cpu_to_le64(max_journal_seq);
 
-	BUG_ON(b->nr.live_u64s != u64s);
+	BUG_ON(b->nr.live_u64s != le16_to_cpu(b->data->keys.u64s));
 
 	btree_bounce_free(c, btree_buf_bytes(b), used_mempool, sorted);
 
-- 
2.48.1

