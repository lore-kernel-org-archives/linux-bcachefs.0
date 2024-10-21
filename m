Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5FF1CA94;
	Mon, 21 Oct 2024 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729525446; cv=none; b=H1Npk+K7OUTqBavrUWqwOtSqWCqovpAauBnSVxrbq8jdg5jOz8MWSRA3NDcnvwaAMa44dJK6Vx6VijEn5HJBonaNZK41IAcIEMB4YaorHPYEB3H1y3Uybm3HbDpYVK0WHp9YYf7A92RjoHuYCDkOi9nTnLAAQ+gmg6KGbFRrEmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729525446; c=relaxed/simple;
	bh=vbrGJwF0X7LWfw5oTOIl1Lh0nwNEFSmG10PmE43TfXA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gNnS2nYJ+iFVt+AnKFQjM266QLe/OOnUqUaXYNQg3URYAwhxoItRixKMQcDwMnktgKTWz7spapfNWL8Dk/RIrimXlS9C4ncA2GLQ7zUNOA/bajrxG+xzH6CCLftHBFkrcC86HIoE+r+/trpqq8u+sXVqVfGRCnTaoJ1rxMr8aCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asIm99d2; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asIm99d2"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7ea9739647bso3122302a12.0;
        Mon, 21 Oct 2024 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729525444; x=1730130244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OVE1WGrL/9NzLuhOITHSOte3RD8moPEtSn2Ys4wkfX0=;
        b=asIm99d2wVQEw1LnzCAsUg0pG8RWkhdyXWG0WOX8/l1Wrxpp595BVWLpCSRIPocXx6
         T8WxQcMXwbb8EwYsiKDgn7vmd2YtLjN8WGY3UtBorolK3Yyiqk/QdzGKg9t3UgrFVlFG
         OKmj07uSYbvWhYA1Xo2V7AUAGZgbEp5QScYe1QKqjyW04XBAQOAAjMWVkg3XsXQMIzra
         /VIEFbRfH4XuHcmsy0VFuxNUgU/IrHNhYYtYtOu+NkZjo4gjExWkW3/4AUG9FbEAeDaD
         O/AINMzHQkPhbClHOMqImXoj2N94Vp/W4AqYoiOvjXNZoqZahCfBQdZ3/hUCldMXBvee
         R6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729525444; x=1730130244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVE1WGrL/9NzLuhOITHSOte3RD8moPEtSn2Ys4wkfX0=;
        b=Io64SqbvFKE4R4n9jZk9XHNqVH1JQ+IlERC4fdNqS3PxrQ0qfxIQfTPYYt+sRXxmnR
         IR5Vo6GvyoNmK83HviYfIaaeiOIyj1/lpT0RLsFSxa4u8bnGhslErSmu82rfpxhjvZfM
         WkoaWq/0EEcMm3mgG474ge3b88dtJBcDgGBWQU3FOS4rnPHFWVlWA6cmWoKDLRoZUUdk
         CP5FHyCrNhFGB87YSRKr34mYGG/A+c89NoDPjPmGnQLEsoN34gg0vRKgLOuTdaXm6uj1
         qRjmTIZPV20/xzR6jTDTk+noSDcqTz8S6ZOwpZdJ8iGtqcxTYIL8Pney+zaHXMDGCxPh
         dzyg==
X-Forwarded-Encrypted: i=1; AJvYcCXwOSlFxZN0/EIhti1juFNeohj7dEvGMsUhwRnVErjOyXkAQAIaqBYWwj9N8U5knH46KjYqLH8K5GOn2rk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIL+/mrWMzMbdRSJ/CtIoh1RQUXqR0E5KyEjttm5ayxN/HQEiY
	R+fAuSrcGSgWWciBa+j3vbpvHFSGZz4RIxD+hqLOvdHYq0EeQgH1JDWivLMV
X-Google-Smtp-Source: AGHT+IHB5DQL0Xhk6cImWutDTiDj+TCzt3sjyGe2rA/wPHxcUOmZX44q4r7WVMZ9xT2FQL91S3pVYQ==
X-Received: by 2002:a05:6300:4044:b0:1cf:27bf:8e03 with SMTP id adf61e73a8af0-1d92c50fb32mr16596328637.26.1729525443921;
        Mon, 21 Oct 2024 08:44:03 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec14159dfsm3031632b3a.197.2024.10.21.08.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 08:44:03 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev,
	mmpgouride@gmail.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v3] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Date: Tue, 22 Oct 2024 00:43:56 +0900
Message-Id: <20241021154356.38221-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
To fix this, we need to add validation on a.data_type in 
alloc_lru_idx_fragmentation().

Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/alloc_background.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index f8e87c6721b1..163a67b97a40 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
 static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
 					      struct bch_dev *ca)
 {
+	if (a.data_type >= BCH_DATA_NR)
+		return 0;
+
 	if (!data_type_movable(a.data_type) ||
 	    !bch2_bucket_sectors_fragmented(ca, a))
 		return 0;
--
