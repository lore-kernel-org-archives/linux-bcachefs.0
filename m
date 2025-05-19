Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8234A2AC17
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747655470; cv=none; b=EyJQr1dTGeZKUVv7a5KvHVmnoGHPvCV3+nINVbLGhPxsEhtAFFmGDo3LYOu6d2/P4wXyWtojfs3P+2m8Rx5eli/MqsQE9wWenp/00QIa1BbE74rw1kzpHPtZi2ibFupWCZFs/EUeut/GSEW87wqVO3ip/oKWk2JkTNI1x7LLuCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747655470; c=relaxed/simple;
	bh=DrDVaxppVvkCoypZaJpscG68819kIsuU7HG7hcX2KEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJs9abJ7znCq7YeH9Vn2UcvZxIb0A6LtAL9O7MxUZNNOF3AFmuraE4C1SxgMOZFXHzrOTuAIXun5hhMSRbP+ldgC0y2kKlQDp2xfkF7HoSMock4p21xdbU5y3EJNqmiuRDgNLosDx4c1SkszzGWL3zwnq380bukIqDU1ALNoDds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JijDLRub; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JijDLRub"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c2ed0fe1so1612333b3a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 04:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747655469; x=1748260269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rMT6rri9fx3u4ZhYJQfPegcSaIssIml0mHVBNIIQVuc=;
        b=JijDLRubN4NZLkLHXd1fhBSe59ZoxmP/XQFwPFfAMiuokUtuSqnFD0UsfNXfvjmf3j
         QmftJR5QTF6o+t/jgAyXXILkAnTBcwTEKD7Q5WcAGUcxOOYiAJl6D5OFuOCumDzI9toK
         +JBTuvHKI9XVluYDGq2Koczt8PbL7MM9GNvIeKKUKKiVJL5fzxiEgwcLqbO3NituL6Gk
         Ro40i/3+M8+m6E0SMJxivHrMJVM7T8mHnTiFtLdfDlU4fEwEB5iIig+QT7ll/pMdx0Dl
         KAXgvgI2U36p6L4XU2dzZfahfUAC1/JVucM/pXdbsa683ZjWLe1g55c+zBjtoMselUq2
         P3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747655469; x=1748260269;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMT6rri9fx3u4ZhYJQfPegcSaIssIml0mHVBNIIQVuc=;
        b=Oq0R4HqwPgtdu7XAJxv9cQLlETga5JQ9K6L4nEIEjwVWCk4HeLid8EvT0euz5zem1q
         44NJczUiMdeJ8ITxCusXgftIMkZQYrZiTIVQluZU+bzmx8XzSZGCaHAPD1cM32B2yFvC
         65vICHr8B7rz4nvOzhfnmue9tIFcrtqxhpN/nyWolu7Cc9nue+ro7X5ZK9gDthKRou4Z
         L+aWp4ogSjm1D084u9psx5Ix7Tp6ez2qxXDlM1kKSh3/bwmeX63BvTnDfbsZt7paEZKc
         79eKnkVqqVY9tineZtl0Ju+AlFCRYP84twZfZPTUqyI7kpxsNmJ5krf+gVkVlFZkZyZV
         L69w==
X-Gm-Message-State: AOJu0YxVruwxhiYqKU0x/AGUxj5XT/Mkx/nvW/H4jgmvAN1SFrGXcVCV
	K1py4r8oPqLo5NlsWQvG4ezP4jwsKXO3DokoVmaHWsGxW2AabCTHw0A3
X-Gm-Gg: ASbGncs5o+zpGGU3ogZQWCzC2SpjfEqckp4k75TmrkONHJzqwUDx5dGecGJJISLW6Ac
	1KvUbtoaxNwhzQYAO7yxV0E2aAhXZE+yOTaQrjvst6k8FXxpuYNuVVYctQIPw3nML9YcREo/qDS
	yp1hRQhxtO+7eafEAyh0IX8SbfmjASKEzyCf3D4QsboP3Yw1Ebj/j7+MOYC0zKvophf7pORjzws
	q4tm9gdUAaUGym+d0sA2M5jcQogvatPngOd8k1b/NVc1zv40SbrkLtJfyO6sbMFBd6vfDCwbUIn
	hzj7wiQMHnNRJELcC5RJFHcnew==
X-Google-Smtp-Source: AGHT+IGxt+AI0btkDtE2L6OTzJ/YLRJy8KaY+mr5XbaPOJW/c7Ihku2csBHQQ35I0pB5JDd6wAoCgw==
X-Received: by 2002:a05:6a21:a341:b0:1f5:6f95:2544 with SMTP id adf61e73a8af0-216219b25a5mr17982053637.33.1747655468610;
        Mon, 19 May 2025 04:51:08 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e7d591857sm6429382a91.48.2025.05.19.04.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 04:51:08 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Remove duplicate call to bch2_trans_begin()
Date: Mon, 19 May 2025 19:51:04 +0800
Message-ID: <20250519115104.449188-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is one in for_each_btree_key_max().

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/movinggc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 7cb0b3d347b4..e7a2a13554d7 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -154,8 +154,6 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 	if (bch2_fs_fatal_err_on(ret, c, "%s: from bch2_btree_write_buffer_tryflush()", bch2_err_str(ret)))
 		return ret;
 
-	bch2_trans_begin(trans);
-
 	ret = for_each_btree_key_max(trans, iter, BTREE_ID_lru,
 				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, 0, 0),
 				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, U64_MAX, LRU_TIME_MAX),
-- 
2.48.1

