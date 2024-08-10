Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC6BC8D1
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723308765; cv=none; b=Vf9HtMmPIiDsyUoE9QODJBeXkmYPD2UdvER7d86QiHWpY+VLBfIOGzn1H3hFvbXUoLGc488TctppmJ3l/pedcevLEjJiaDA2wlJWXumghWmnO6uYAV3cydq7FCyDavWpJlEnYWqFK0p8WqoW8e4MRrh8vgOtHJ6wPzyTin/m3wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723308765; c=relaxed/simple;
	bh=33VznvxvMMq/rDJSMyoZl/UWEC4Fjn70lLQuTVZAMM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=antDeB9D6iCjIwvBdNaXt0thdoOHAUHOhgAprGmcYPfNSGpIInMmSZmsMiHKTVeR9aiNbX+uba/abhPFQVEjMgMB3x95lzl635ya2ntAP3RMeHcuSOaCS0HHUYe/zGFcg7ncvLmbSs1/wNtn3jwscWzzIVp7CLIl1Q+4oxlVcWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3mFbXsK; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3mFbXsK"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7106cf5771bso2567397b3a.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 09:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723308763; x=1723913563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+3regXh8TqlWoxK1RSGvNQJs0SrCTpfqn61BYoUwDc=;
        b=Q3mFbXsK5vI9jyfP0EKobKJ09qzizkchGF5IewOj6FByq08bUgvCqJprUMAr7HTuRn
         DphNSP3/1q9jej7t/3rP2nQTlHKq1SQn/i7J591nKxh1N4NtBOjLWa4VlkFx0KHuRQe3
         9gWnmZIJ/pV6DuAyKcI7pn5nZL2ksUUvUP68CeVpCfIQqt4HZ2TZOG+hw0qjfYLP7dID
         lJknp8XVNwNexEoC1g9CyGYAYo0a+f+dpWiHHKjI5oVxO70F9mPzq/u4rDATUZUnQ4SR
         rxJfy971J0ZEXDmmHVXOc/+KOjSLd9vyHmJiM0dqbY0FqQcI+sibLvaThevUSuTKjZd8
         qTfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723308763; x=1723913563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+3regXh8TqlWoxK1RSGvNQJs0SrCTpfqn61BYoUwDc=;
        b=BQzZEzpF5epgcSmiBoeSrigQMcat2G8GiMNbiGkXq4UYBy78jfHmuE0alny2wJKWkK
         4J/eX8KTISJvmcRDu+ZHlIcxhxoLyNDsUhcbiCatjfNI9K9pq3U6nGsfXuhBjDhTRujf
         fohGDGyKD+oKOci2bYM5cNjn3hAketAix6dfylSIeNuf4qNTJXBBz2FTzl6OeVWfFRMO
         VGzAp2mekxXUHW8ejI72eyvUBF3NfAz5yMZPHFQxpIrouqWQ46szhPiBkYjbshZ9f9QL
         WKuuOyaZIwY5EBtSQFy8OVP6mQo4pI1zeJu2jx4Kpect/SMpcVtr1HkQtmPYuSzIg/Fb
         bcaA==
X-Gm-Message-State: AOJu0YwnkNiFlf4nshtKBKGJgExgT49EKFM5q6Gri/7VNuDK1WcychvO
	8UzSxQyjmkZSoQioDPIvR/0ofLCahNR4uhbwsyXZ/XNcnBjBDeKU
X-Google-Smtp-Source: AGHT+IG5XVdtLSrbZdEnFES55LKI3Kfz4JPMTJNc2rqz5MCYfql+3RBlE29c6gBDIkh24QGp/sJRsQ==
X-Received: by 2002:a05:6a00:180c:b0:70d:2fb5:f996 with SMTP id d2e1a72fcca58-710dc666edemr5828563b3a.11.1723308763192;
        Sat, 10 Aug 2024 09:52:43 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58a97b5sm1433774b3a.76.2024.08.10.09.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 09:52:42 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Remove unused parameter of bkey_mantissa
Date: Sun, 11 Aug 2024 00:52:24 +0800
Message-ID: <20240810165225.166154-2-mmpgouride@gmail.com>
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

The idx parameter of bkey_mantissa became unused since commit
b904a7991802 ("bcachefs: Go back to 16 bit mantissa bkey floats"),
so remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index e7c44f35f0c5..a2a87ed09f37 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -585,8 +585,7 @@ static unsigned rw_aux_tree_bsearch(struct btree *b,
 }
 
 static inline unsigned bkey_mantissa(const struct bkey_packed *k,
-				     const struct bkey_float *f,
-				     unsigned idx)
+				     const struct bkey_float *f)
 {
 	u64 v;
 
@@ -668,7 +667,7 @@ static __always_inline void make_bfloat(struct btree *b, struct bset_tree *t,
 	EBUG_ON(shift < 0 || shift >= BFLOAT_FAILED);
 
 	f->exponent = shift;
-	mantissa = bkey_mantissa(m, f, j);
+	mantissa = bkey_mantissa(m, f);
 
 	/*
 	 * If we've got garbage bits, set them to all 1s - it's legal for the
@@ -1130,7 +1129,7 @@ static struct bkey_packed *bset_search_tree(const struct btree *b,
 			goto slowpath;
 
 		l = f->mantissa;
-		r = bkey_mantissa(packed_search, f, n);
+		r = bkey_mantissa(packed_search, f);
 
 		if (unlikely(l == r) && bkey_mantissa_bits_dropped(b, f, n))
 			goto slowpath;
-- 
2.45.2

