Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187351FBE87
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Apr 2025 07:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962738; cv=none; b=i4VMtTAIrv0Z0po4TR6SkJkDCe80233VVMn2YPCqvE/fMS8XyEConQwXIAYR7147VyifVUP50P5YGZlmBcuOfhuel4XfUnmUYxNaG54DJdAJuK7fCSLQwJSKCj+D4HiLg3arTJO1SZkrArUm9h9LUdPBFm67rBZTwF7nolNWkPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962738; c=relaxed/simple;
	bh=VsBYf4nRSkeKqa2Jf78YoFmIFuvwfUYAKU1jrJGNHEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fqqC7Rry4v81hrn00DG+IOA5TbH83869z1cBAMQ7DU1q7zzdgn++Krs0COQ/VZDXGfXQrRb3Tb+AA1wCC7UcGuY9EAeI5H0szU2WHhUh6xO6B5sC2DvmHAmCnAi+yErUS7lliJU9XchnSGCqRC5VSSZv+I8t1XQPvMYgkBr2cQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m3Te3yd1; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3Te3yd1"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736a72220edso1585014b3a.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 18 Apr 2025 00:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744962735; x=1745567535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5DD9XkcmcVsPpXpD0oRd2nLaPpgebzqhZHfhqFAOT0k=;
        b=m3Te3yd14g6/YMO6L9YqFBD4R0YMB9rdDgNRGQLveVt1v5gOE1VRExnfXo5tsN2KxO
         Gfy+XByulN5twBQXHFzxKQz7vYiSs39qJCGpf+GNo3o+VSS2b0GvmpOugWUvVMVpiDLQ
         vsXCZmXTTHSjKOXXalrtO+iLbA2jtyKRuuQNLMXGd09Kpbm/2IHBssCH9p1Za7aADdgU
         GlvQucDK1HXDduEtMZb23nuC8QxtYp0XA1vbL0RAoeGqXQLPolxK6hrZDT7jCgK5w4J2
         B1bJ7g6otEiLPNiXBHgIoiwg5DX6bJh8ZudG87eEufOwwKbcCxkl6TcaxS6gSNVotxwx
         4hQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744962735; x=1745567535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5DD9XkcmcVsPpXpD0oRd2nLaPpgebzqhZHfhqFAOT0k=;
        b=FhZP6E93p37JHtZgOhtxwx0r6h8j2p+VFDCgJZZGAjPD4maEaU/F4qLlcYvGA4tSm7
         ECu1TNNlOI18gEspa7lL/4+f2eO/5zWQk87ju0qEEobPoCaAVPTf7T9WxMUjGH5IR+yb
         LVgqozoQwgm/m4q34nP0Fx+3yXd3I8wAy3BV00bKgVdZXgO1s0MDXAjLhmtpI2lby/0o
         /Alm1kgGkf0VnTWScHntWC5UtQD1a8bTraYtykGL1HX83GYtLzMk3JU416VvB644559j
         iaAk6J+df3BnlW3+fLbbzcTEd1ipmXWJTEzGsmA6CvyDLAGQqssppQiaWA2CxPGdgKGR
         UOaw==
X-Gm-Message-State: AOJu0Yzn8WbG4fkgG06cVILznNNHnXHQxnoymTjClJtu8yTq5C4iTeau
	HRQTf1Io4b6+tIKFMGRccIIWXNZiUy9wH5GoFyHtz7ZB77mrx2mc
X-Gm-Gg: ASbGnctmqnsJu3kGmhBjBqTtA04DaZMKFewApJylyTxrJa1XOmb+6GJy64/2oxv2TA1
	hF7TYj5F78zfEUrJd6WK8iFMieVAinkFJ6YiK4paCz30LSCeG7asulJYfR5ATL6nRpUBoBL/87W
	B6Lh4b2zmz6497i3CBXA0+8SvaDtJfu0qiwCKoHL51BP/gsquCKWdY5u9JWOqNBOCEs/dvT1FiN
	wofCxgw2Yoafgv+AwO6xa7+4vWY6CEWh5l1uLBI48jJwtpDs9ctsquWxl0gmG10A4F7zSPcVMGX
	s0K9u3TVR9/anGU=
X-Google-Smtp-Source: AGHT+IGdnea1W2ZhXOI3WvVgnEeb0TtxTiAxpILkEb7p1621UxuazYa+WN75pVyMUyQngdiKhOgckQ==
X-Received: by 2002:a05:6a00:1495:b0:736:6d4d:ffa6 with SMTP id d2e1a72fcca58-73dc15a0817mr2272665b3a.15.1744962735242;
        Fri, 18 Apr 2025 00:52:15 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8bf802sm1101547b3a.13.2025.04.18.00.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 00:52:14 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Kill dead code
Date: Fri, 18 Apr 2025 15:52:10 +0800
Message-ID: <20250418075210.174321-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/journal_reclaim.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 5d1547aa118a..59d8c9fa9b07 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -624,8 +624,6 @@ static u64 journal_seq_to_flush(struct journal *j)
 		/* Try to keep the journal at most half full: */
 		nr_buckets = ja->nr / 2;
 
-		nr_buckets = min(nr_buckets, ja->nr);
-
 		bucket_to_flush = (ja->cur_idx + nr_buckets) % ja->nr;
 		seq_to_flush = max(seq_to_flush,
 				   ja->bucket_seq[bucket_to_flush]);
-- 
2.48.1

