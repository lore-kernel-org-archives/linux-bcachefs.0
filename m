Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386B4688;
	Wed, 17 Jul 2024 21:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253488; cv=none; b=TvzxO/2zcLUcmXqDSCLii+l8A83M4McCEmHC4drKbdWIyCjPJDnFA365PDV4KS3UeORNd5FFXOlzU0t7aN+hL2uOxessZjM2UVH/bM1JIMXbeRVwR8fyunVr9HWjl1rwGjZVJ+TjboYVfjZvJ31n9EO00hQ1mPpXUIOuHud+dbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253488; c=relaxed/simple;
	bh=t1V53QCwhbRn3QShw0mQ1JBZtpzSeIt6vRs9LgO1hWg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=baHfO1ykpOPMST0P8tIFW6CKQsvUUuUzTRw7sVhjNnlkpPT7PkFjFS91Oo0261MscBHciyePA9R/w/N+JhPC9N3T88JEnNJivl6sENzSYpLmL7Hxo99qLcAsjugxWyHww1eR3BXs3Z1DtsDJeZqBlCx3Zc4AyJ0SfAFvmwuwEuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciSYvCFj; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciSYvCFj"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-703d5b29e06so78113a34.2;
        Wed, 17 Jul 2024 14:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721253486; x=1721858286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nnEqwoB3WS9QaHQ5p8lQYakOrgNPRVSs6tvmioKoBEI=;
        b=ciSYvCFjwZPe3QqzqBmM9gcEdfAE9q5+BneBq1fyjKFEf3ZDxD2utfZb8kRe+2JVr8
         jVykGrEgdVsnk9kOCfpRLu8mde8CcZniOOVLte7FAA8IA+cQIKCO1TFj/w3zqvtVnyDf
         zrXP4OLVldcMUaiN80fnEyInl4Ytn+FVlRo0B23bxAmyvLZ2Dru1o3H6yG8k6ZF1Pt8W
         QNN+YpEYDeSejrcCF1FYVV0PJqhMOa+a6TPr6v38eKF9OYtrA9cZ7wvj9m4ZPo57CiKv
         1hrfvTOczufYuy0KgkbFBS85oYnIoaNBh0oM1Tw8QqsLiSdKJT0A5hOZ7jUTNlfxqCr6
         /9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721253486; x=1721858286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nnEqwoB3WS9QaHQ5p8lQYakOrgNPRVSs6tvmioKoBEI=;
        b=gWasdDd3668s/Hc1a1ygFGXXxzQPEZghiC+0uxqdw7P7OQgxU6SVPdddxlbtg5KxV+
         lFgg5CkDE4ESiEE0y3CGq6QqQaT/p1HEAS89qCDgYrwZPzOwIDSUh76Qhxb2+Jdqq6BH
         oDuFKv5uZeg6wkHFuKMeqt/MNR4yuPrqSduXPE8shkiwx+F3fL2p6BUAFAYEW9t5sZxR
         jqP9w6zNICD39suI5eNQENEsbXriTKv8f2ze27HqPo5umpKX4tbE6IjX/McNjtwQfvKV
         YJkr+txaCfe7Wdin2bsF/YGaVSJ0qJw8Ul5j+mn60aoQM/1E2dGEc0TThRY0SIiw64w3
         OahA==
X-Forwarded-Encrypted: i=1; AJvYcCWTTS3YT+46LAqOQndyblWDLeRUjfgGbjxLBjGbs0wlVY6lmBTz6jT1Cc4Y01XkDTCK3K+agCbSpRwLquSmo+ek7F1WXdS4dQtYPnnjadGyDdBgV9/j4ryrLqj4b09fEq3vlhBO1ci0cwaat1Q=
X-Gm-Message-State: AOJu0YyWBT/HWZOIJSI6oReLlNLyYV+nLEltgmKZ6SUThcPV2CVxClYH
	p2uyib2m+fCygmH3M7RhAI1fAyzKLPPJAASXaaKlo7YvkuOG9/iGqvpSmZ2R
X-Google-Smtp-Source: AGHT+IFWdMWNymVT4jheenQb/Whmm92cb8bKaK4UviYIS2VKafOOipKpmO1FXrO3fwDitv36EDGvWw==
X-Received: by 2002:a05:6830:90c:b0:708:b2c6:bb41 with SMTP id 46e09a7af769-708e3798bbemr3296980a34.2.1721253486345;
        Wed, 17 Jul 2024 14:58:06 -0700 (PDT)
Received: from localhost.localdomain (pc-66-166-104-200.cm.vtr.net. [200.104.166.66])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ecd1dbfsm8618812b3a.207.2024.07.17.14.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 14:58:03 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>
Subject: [PATCH] bcachefs: Fix general protection fault in bch2_checksum
Date: Wed, 17 Jul 2024 17:56:28 -0400
Message-Id: <20240717215627.1246537-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Checksum for types BCH_CSUM_chacha20_poly1305_80 and
BCH_CSUM_chacha20_poly1305_128 are only computed when c is not NULL
because they require the chacha20 cypher stored in c

Reported-by: syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/checksum.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 3bd3aba90d8f..77b29c73d7a0 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -220,10 +220,11 @@ struct bch_csum bch2_checksum(struct bch_fs *c, unsigned type,
 
 	case BCH_CSUM_chacha20_poly1305_80:
 	case BCH_CSUM_chacha20_poly1305_128: {
+		struct bch_csum ret = { 0 };
+		if (!c)
+			return ret;
 		SHASH_DESC_ON_STACK(desc, c->poly1305);
 		u8 digest[POLY1305_DIGEST_SIZE];
-		struct bch_csum ret = { 0 };
-
 		gen_poly_key(c, desc, nonce);
 
 		crypto_shash_update(desc, data, len);
-- 
2.34.1

