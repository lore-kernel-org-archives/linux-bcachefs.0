Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635991E7677;
	Mon, 21 Oct 2024 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729523452; cv=none; b=N7a+dNoTIFnpIVHWAI02S/vBG8vm5o5437Jd0C3JNdqpcqeRjNHaRvSNo+uId83AtrzPrGDpvAP+h6tNxeUJ7pSoo4bVcBcKKv7uCKVN79/FtNV+qyh+yjbSC833QT/yCXM8PmYIgNHJZj7NIaUZJtaozh41+cLCobJlqc1n0Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729523452; c=relaxed/simple;
	bh=QD7AxKLoZEP4E4LfscetL7prn5bCZbFOznQeWqU4LwU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gpWSvGLM2kttzFyeVY7Z0QczXUvQlrQGg/12fTNdI44nLcOlj1cqZVYK+Ve/AXYVSfxtfxGz7B795coJVc5SGot6du3p9JS5cIWg9VJePMLajmYlY/1uDDF/5cRF2etJhRW3zjku2fHMs0x/9CU8/KjdZCfIlLl8RzyhEOcxMD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdEEnDQk; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdEEnDQk"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7e9e38dd5f1so3426711a12.0;
        Mon, 21 Oct 2024 08:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729523448; x=1730128248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RdRN/obzgK7K5Ctq8X1iTFrBCGuTBWFn0VMlx5LGh0A=;
        b=jdEEnDQkdDseCy6K9OA+txB6AYBBzhV383kQyeaOn+qq3S++S9REqwzOYKmURPf0Sj
         Cq7hJTxO5Q2xpubbuu/sAuvbac/WN238eM7RWNQSElAT+5COib+1kLcF/IQX1AZ8bMqP
         83iN2HfJfqXiUILODXDzu6PcG5Dcl/JafBcesYPcOyNCgbZNOa0w1psHjKrE0jOuIB5s
         h4AWhRYiUEDngGqWODfKq07Hw6rTvBR35d+GKzdtBwFjENOU6SZTEo4+E8WWlt4zFIIO
         dDSCaFBs9BWmxY3Uf2OZZNL8q5IhVURiFGXZmCovn8KMbcJnpu48wyQMtOxOPndbwAsy
         J58Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729523448; x=1730128248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RdRN/obzgK7K5Ctq8X1iTFrBCGuTBWFn0VMlx5LGh0A=;
        b=FKvTrXoZZd1LIMqENguIHHMSauFUrBr8yiFuPXbvgZSgNIBGVnyUvTwf+DpUy8RLnf
         +tOAWKe1x+sNfC8Mu8gxRXDrqRMgwSf0w51psF+2u4Vg7ZsAv4r6yv/FoZOmkIjUhc5u
         ByM1RbCtKszHtKHQShFY1w3AlxKvgY+rpTLVWwt8QqOu1biCVODKVWxftuS5NB6QeqBM
         cpBEBE+J54LvJ4PQm32FJxeAB7/6jf1ANwtzVCASfwKLM78XXYl7y3Q5DUaDYjKTQ0Rf
         9h1txQ9sv1qJT/TDiYJRFvnsvcMegmmia8YRrBfdRAfVNkViu/rUcchoLKzoCgHybbZX
         RMYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8MZDAR3bWeuiUHfeShWmZos3Bs7OOrdveKtN6xYVxFpV+C/a3lKHVs+FhqfXSEkFA4+rXotn5BR0TMoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiIyROXc5GahPNiAlg/laKVmfGdq94i5nu9jxTm3seqyKKT+Vp
	ZdvptCRMcl/QG5LccHn8jxDix1yyHxCoznuelOePwmSprPhFJuL1
X-Google-Smtp-Source: AGHT+IFGFy8UNsxuG1pwYq5UQvbcrMWGxtPY/UqbUS5OlAQ0G51urwFqTX8239a4emVgytnzTC1mtA==
X-Received: by 2002:a05:6a21:3a94:b0:1d8:b11e:19b9 with SMTP id adf61e73a8af0-1d92c57df1dmr18577271637.47.1729523447079;
        Mon, 21 Oct 2024 08:10:47 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec1312d2dsm3002925b3a.9.2024.10.21.08.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 08:10:46 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev,
	mmpgouride@gmail.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH v2] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
Date: Tue, 22 Oct 2024 00:10:36 +0900
Message-Id: <20241021151036.34383-1-aha310510@gmail.com>
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
index f8e87c6721b1..91eb96b19a76 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
 static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
 					      struct bch_dev *ca)
 {
+	if (a.data_type > BCH_DATA_NR)
+		return 0;
+
 	if (!data_type_movable(a.data_type) ||
 	    !bch2_bucket_sectors_fragmented(ca, a))
 		return 0;
--
