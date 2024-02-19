Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55AF381B9
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708354224; cv=none; b=bTTdsmZqGKVZI2yaHSyLBDvW+Y9RBarX+6xvMTxybJkG5+ZuquAoHVl0P0XQtGWMQV4ZQxR8vEGqGzZYVyMBTVNF6KWqq2JPlkBgNl5FKcGhMuUKQkhMQXN+/CKdUN6DHo2BCNWmdb4IVIgV1pP+ioD2FqZndeD1fXd/D5iaqeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708354224; c=relaxed/simple;
	bh=Tn+P6Dq4x125q9G3LC5yE5GoNI1kLvuYrJQWhgVyBGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m96zAPlS14EF/XRlVZ+7exLo/GWDMRd9QcpT3gisk161mNIOLUVCHhKumrbDNdYWjRJ12ipEwVHLgIvG0jnvLAXMphTC2ncHk175vqfoZfK+P8cyB4YAZgNtPH7M9TqFyITPuJl0NVhDolzk4lvwK4sbceNHjw7EHICy9tp4lJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=iwvycXqn; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="iwvycXqn"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e4751b97eeso181288b3a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708354222; x=1708959022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrA2bJ3ekGJw7X2nX60fCVuGQfG/nmdxEizS01S7SRI=;
        b=iwvycXqntP7PRfXu7BFJYATVHYDqDLkHUthOrUuJrL8rHQvHjl9jq2zKkhVTxtgIy7
         +FbpSuENKQjLJSGQLPY26GpGztE2KeNIPDwalXunKIyg0Ikwix3Isuyy52H8N2+obMif
         vI/5CX1O8H3nC69Dxh9jkwPzW0DOB3fEmatGO6QVmo7uLLwShGhmKCuOAeoim/7Tx5Yy
         eqv8GkboCrxsMlzY+riSlK5K+KrVWoVXEkdV7lWmso8Qvzij5/cTTQTe/yxn/UT9y9kT
         t6kGBM1LFjJ4/HhaDf/xSleBgtcLYsHua5UvHQfnAGUrdRy/nGx4x9Fn1cBmUzoBVPmj
         jKXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708354222; x=1708959022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrA2bJ3ekGJw7X2nX60fCVuGQfG/nmdxEizS01S7SRI=;
        b=YoFfnsRJzxHVhwPhu0OubIWeSIQjzQ5hlZpnL/S3IWq/d9mceySdEkXr1n+M0Xwltb
         4dqTbWaFYg8J4afWdGwCvbr7BtB8SRkgcIC1dNn8CMOCOyMV8vT7Zhv6mnLLW3rUH4cc
         RZOG2c41Agl5oGVg/Ln7i245BoPfs9CGxQl8ssIey/+X6HH1r9e7LqJmrcUibzXtmvWG
         YaNKfdhPUWwMmeeldV+SNBZnkUBANnmR7dp8QeUbJwkerOHh5jzDnbhf/LhVPMfE7+BF
         MhzupcRIcwW0Of845rQE6jV6unLdorgMRhWM5HQj4Fp/Hws+LoK7H8Zh+WklERjMlTKI
         +WwQ==
X-Gm-Message-State: AOJu0YzKHXTrSdutTWHKjr4TNy3CghM4nj8oeGmNQ0Q2h1kiztiKdFKj
	nT+0KNIPSiYEdhaalFoS3vA9PPnJoo+A8AAYI02pEW3aaIuj1lVM0ZtvuZRxoo2TrSkQxT91E3b
	o
X-Google-Smtp-Source: AGHT+IF+UvL86JB79tntfr7Xd13q/PLROXIRMti8jbx9nKvsMPsbsusB8mtNrQJE09agWMCZQAyCwA==
X-Received: by 2002:a05:6a20:d49a:b0:1a0:56c9:60ab with SMTP id im26-20020a056a20d49a00b001a056c960abmr13700063pzb.44.1708354221813;
        Mon, 19 Feb 2024 06:50:21 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id e1-20020a63aa01000000b005c2420fb198sm4155101pgf.37.2024.02.19.06.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:50:21 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 3/3] bcachefs: add check for missing fragmentation in check_alloc_to_lru_ref()
Date: Tue, 20 Feb 2024 03:49:17 +1300
Message-ID: <20240219145008.915291-4-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219145008.915291-1-daniel@gluo.nz>
References: <20240219145008.915291-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to make sure we're not missing any fragmenation entries in the
LRU BTREE after repairing ALLOC BTREE

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/alloc_background.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 3bf2a2daad93..c0894680ac4c 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1566,6 +1566,32 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 
 	a = bch2_alloc_to_v4(alloc_k, &a_convert);
 
+	if (a->fragmentation_lru) {
+		lru_k = bch2_bkey_get_iter(trans, &lru_iter, BTREE_ID_lru,
+					   lru_pos(BCH_LRU_FRAGMENTATION_START,
+						   bucket_to_u64(alloc_k.k->p),
+						   a->fragmentation_lru), 0);
+		ret = bkey_err(lru_k);
+
+		if (ret)
+			return ret;
+
+		if (fsck_err_on(lru_k.k->type != KEY_TYPE_set, c,
+				alloc_key_to_missing_lru_entry,
+				"missing fragmentation_lru entry\n"
+				"  %s",
+				(printbuf_reset(&buf),
+				bch2_bkey_val_to_text(&buf, c, alloc_k), buf.buf))) {
+			ret = bch2_lru_set(trans,
+					BCH_LRU_FRAGMENTATION_START,
+					bucket_to_u64(alloc_k.k->p),
+					a->fragmentation_lru);
+			if (ret)
+				goto err;
+		}
+		bch2_trans_iter_exit(trans, &lru_iter);
+	}
+
 	if (a->data_type != BCH_DATA_cached)
 		return 0;
 
-- 
2.43.0

