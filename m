Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DA3C8D1
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723308770; cv=none; b=ikAwYVsEJyUkTfAHV8R6siIVsaZ5971AN8/Vh/xfvI//TVIK+9QAxR/VasoUDsE7MV2GaqDHQYutnu4yYGKfbLGEMPmi/u5gC8s9hiVD9tSjIIdkfISSmlmTvSVkkPu9LhSiuRqkKy1XPw609V67eJsNHjRPBkjcCHIX5PmS6zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723308770; c=relaxed/simple;
	bh=4C/LNQfQMH6p1sqrCw1cOfkv3shWItkqoobd78nED/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Id+3yhf7FBdTFOWUMakTuDnjt9zKAf3qY9ENPDGNLKZ44MQLVjxm4IhjH9Cux+OVOkXm7RnI0NtZqWDNJBG3I7lrCtI2LE0reKXY5njyZpUu4Z5eTqK81rmZtDDZA1WnzikzOIetg85qxEBAkkO4BFTB/4xNcfXa3HqJux0SEiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHqWGuSK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHqWGuSK"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ff4568676eso29535265ad.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 09:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723308768; x=1723913568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ErUIh3lm0MwXRZw7FbZC6kfaIUj1CjyTJQRKEVTplQ0=;
        b=aHqWGuSKN6/9xAhPTr/TtWAKySTxKyePhZnNd3NEPeeJUAMzGn2aZZC4bAuN5pmokh
         CECevddvVevqFeKjgwLDMFO3/dpJYm0l1/z8JQUbsaRC3AnNhTeRf75vASG2kAy4cL4/
         rxM0/8F5DzXhV8B3mFr/tp2EA51HqHQpyxPxxgYv+b6Jngq4ZzbiygN7VqTFHerQPJVF
         mBeTOyBZ3HOykKZCG2zkxMGFWJnmDri3iAMmn+kf5PRX/xDtAHDZ3PrFTe3HK4xRFdcY
         HJwNOXLwc8Q1g2YsIvmj3hsA1fupEL36jzaVdl2NE5Bm+jfFA/TyYgwkk8LRqF0By0OP
         DITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723308768; x=1723913568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ErUIh3lm0MwXRZw7FbZC6kfaIUj1CjyTJQRKEVTplQ0=;
        b=phRav5Ixo4KRWeqCkdMWaC1oCXD8L0vNhmZsgxcxaHi0E2CSnQfkZqisN1Ug87LKHd
         TODH4UWvBOQY55ycgZjZ4Biz3YB69M9C6XsCWopxHBxuQk6EA/mE9EJCot/pn2QizsLb
         xesYFYLa8aio/K+5qHNNfAzgXSvhf6XsNUdcJqgLpOjOSYNamaO3cPuP8vrETU78HHDk
         53qSpttQlQkjUJpGBI+PPLrWPbaDcOljbLC1FWyn+BZ+H1ZzTHZJV74BdJAKgASThPIW
         2m/VDmVZHAq1EE1WkpOFkBHoA8sc7d4NXMgs2L+6uxBAUcwu0rjMMjm5dtbfJqYH2UPD
         PxSw==
X-Gm-Message-State: AOJu0YxQjR00jn107Hqm0Q2ny6d2/NxUwROOe/yjhXtw0VfC6/oKL4Ed
	L1M3DHlhuOJJbFkbJMGDCCi6+0c8vDJl5YkAOZaZAs6xQS5gIiPd
X-Google-Smtp-Source: AGHT+IEnbDSx87ohHNBEO3LHEhCpr0FdJEBpXM5EmYlrLABybSwDFhsTVxGmGyZn1pc6xx9lJSEwow==
X-Received: by 2002:a17:90b:190a:b0:2c2:df58:bb8c with SMTP id 98e67ed59e1d1-2d1e7fdb96amr6003061a91.18.1723308767930;
        Sat, 10 Aug 2024 09:52:47 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1fce6d083sm1825467a91.4.2024.08.10.09.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 09:52:47 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/2] bcachefs: Remove unused parameter of bkey_mantissa_bits_dropped
Date: Sun, 11 Aug 2024 00:52:25 +0800
Message-ID: <20240810165225.166154-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240810165225.166154-1-mmpgouride@gmail.com>
References: <20240810165225.166154-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The idx parameter of bkey_mantissa_bits_dropped is unused, remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index a2a87ed09f37..00a821f617a5 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -1094,8 +1094,7 @@ static inline void prefetch_four_cachelines(void *p)
 }
 
 static inline bool bkey_mantissa_bits_dropped(const struct btree *b,
-					      const struct bkey_float *f,
-					      unsigned idx)
+					      const struct bkey_float *f)
 {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	unsigned key_bits_start = b->format.key_u64s * 64 - b->nr_key_bits;
@@ -1131,7 +1130,7 @@ static struct bkey_packed *bset_search_tree(const struct btree *b,
 		l = f->mantissa;
 		r = bkey_mantissa(packed_search, f);
 
-		if (unlikely(l == r) && bkey_mantissa_bits_dropped(b, f, n))
+		if (unlikely(l == r) && bkey_mantissa_bits_dropped(b, f))
 			goto slowpath;
 
 		n = n * 2 + (l < r);
-- 
2.45.2

