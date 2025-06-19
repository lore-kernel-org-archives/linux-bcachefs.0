Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE6B28B7DF
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750354403; cv=none; b=E6f8YkaJv2bitslX4V/D6Hb9vel+AtutjYGK+WgIo7NSBkebbdZfc1o+m+rRwDQPxbELQdGFPexPfxRqN4bqoRE46A6mLevJspshkspE3iUnR5vBLNnsrld7zLSkvnP5B2MQlgnxDpeMvi3sSBHHqYFokvzcOZ/b8wrBCZKpT84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750354403; c=relaxed/simple;
	bh=v/Ybzsbf7zULIkst16v/pf9eCDHQO7RaPON9sVH5Lro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l6glTw7akCPjKhZM/yqQix42prZdJHe3lkSp75CGokRKN2ehmOWRqn/xkHMSdWokOXtM/JJVOY44HgjeO1HTEdUHlxMDDYaty8A50zD/Riw3ZOsOzLL13TsiZnrcdY2njX6feO0CTxg9Vhw3b6D/dIXrq50ERwpbKSE4jwOkH6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZCtglBOg; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZCtglBOg"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso1062407b3a.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 10:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750354401; x=1750959201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Xm+V3y3No8fE1cUJryS7WMi/4bNdNjJ3dBF6P8TF0I=;
        b=ZCtglBOgoR/IOUeOiHsy8WlPqploNIN6+4/0KRcDSjNMXg65iv6lNWupY5dV3HqwGj
         1UnIuqlIsrkptLD8xqK6VfueP4ZC8ZW8XY9hCaFzDGMPWm3rnIYJNpl0YmLJF3jCvjdX
         oo21MBF0IZeJKC9PX1uAGsE2BJAhSEuDUiW+mB7fdXMe12y08YCRlkCS7vDNnn7qswC+
         7z1w8DCVm26FANNkBXLGmxn6rFIZsW4o7w0PG7TkF2qyJ+9SydpM3ZvB4yemNONO3X7g
         sRIudoSieW8Fa6WF13K73vO/inH8ZrCBZ43H8mekfziL7+VzaOsglstOYTlT7uC28Bv1
         N0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750354401; x=1750959201;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Xm+V3y3No8fE1cUJryS7WMi/4bNdNjJ3dBF6P8TF0I=;
        b=q2kdK9eSbJBvHhgDoiKW4PofhyEIWEkTF82PZVWXO/9m9ObS4fXriC4gpUHQ3+LUjK
         Whr0qKqNwDORUMIh/6uTUhmMKqZM8Uvhmy4nTcBB+NauaDcMGwKdXsYuJN20ShBAshq9
         g7fMs1cTgEj+pORYzZtm5KHp2Yn4ZKR9rYGhDiXhNg1lHxTuGfFYylN4z8UYTHn6+spu
         3lKiR2ulSHk4crqdqLMAddyTD4xROtt6SIcbDAhZc2NOTeaSD3EQjIHovtN928hekYyM
         9OK5PHgq6wBiBWmUxIa9I5UXPJQRUqca31LrN+LNyDotwOVfM8ALvEWQv55JCRBJyxzt
         2ACQ==
X-Gm-Message-State: AOJu0YzBG29oj6gEWqVqiyMSaZgk9otztX86HONSM9NzRPeRqIWWlfFh
	sYpqGYE8I/olcqPTShf4alDr23sBfZXMBsYacppel9HZjfMeOYUQ5Lvn
X-Gm-Gg: ASbGnctUobAZnbwtBUPQDZnENqtlz1fHPyhnriez+1LGqTFw70eXrVQZ6SC8S+acq/l
	OJKAK0sl8/PMcOlkTPNOaWiNDl9WTGJ2yGtuoz4KmRQqozPEkB7nIiTmmHeGAEcm2kd9/AHsPHv
	0YREZ9yL4er4+QZZU0Hb83eEN21ten2UH/RcK36jc45FHTVUC+nB1jLXA1+ERhZ7d+zc3RVoYC1
	HCk6A/sFS1FRZ/WM+3BAX4gToerdgT9oR4FEfXdWGqjxHuRtAcZ8ubo6GAhInFsUDlJE9pI/Zfz
	WeEPMhJ8VtFWYgUNyW8vBD+uP/VTE7ptP3j5pAHLQalBGIs=
X-Google-Smtp-Source: AGHT+IEcy5Lnffpkf2BV23l2QenXsrhvZmxWwKEePNHIi7TO37r83lP9PHC7ln/q+M58vITTTwHy7w==
X-Received: by 2002:a05:6a21:3941:b0:1ee:ef0b:7bf7 with SMTP id adf61e73a8af0-21fbd550dfcmr32302117637.19.1750354401174;
        Thu, 19 Jun 2025 10:33:21 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe169205dsm13308239a12.74.2025.06.19.10.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 10:33:20 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Don't memcpy more than needed
Date: Fri, 20 Jun 2025 01:33:17 +0800
Message-ID: <20250619173317.975223-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

buf->u64s is all we used.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index ee657b9f4b96..d9a17d523db1 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -566,7 +566,7 @@ void *__bch2_trans_subbuf_alloc(struct btree_trans *trans,
 	if (buf->u64s)
 		memcpy(n,
 		       btree_trans_subbuf_base(trans, buf),
-		       buf->size * sizeof(u64));
+		       buf->u64s * sizeof(u64));
 	buf->base = (u64 *) n - (u64 *) trans->mem;
 	buf->size = new_size;
 
-- 
2.48.1

