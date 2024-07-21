Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE73B2EB1D
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 12:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721565874; cv=none; b=FUF+flk8RUOy4plwTVCGw9OIT7hyjSX7XdA2v1HOXK0b9DwHkBCidcKghCOhqFs1l49Nx3OB4TADxZsf2+E+VHnMfH+cRtLw8QnnJVgWTjOlvsth9pb2Fr0pGfCFjdcwCp+6i//QPPBWjlhoDyZVU1/6GBjPpwwQPRG3kNntd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721565874; c=relaxed/simple;
	bh=/tFFU1Gphf143LMpvwr0otBXlJ00WjbRJ7fpmxARQ8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b+W7E01SjXiveZdmC5YoSZtYcanc6V82ZBZIGL4QdJcQg1fI29sxwDQsQp6UuZf97xw1va58ySFNA1CYq74hrMJREHi1uqJVRDFS6VK4cS+jPgmB2jTv4ht1BMRqG/VH7SpgICDK72lP0ptvbFuZTs7fJrbs0+B8IQBjDeyN1h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7145NO6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7145NO6"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fd9e70b592so148215ad.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jul 2024 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721565871; x=1722170671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bYzDxCFUFMqRJFIh8zY3k87eDlMKl4v1Bq5SH2Zxdzk=;
        b=J7145NO6m6v+tTyk4PnIWYXjx5d+79//VMWT3wEI1kBUW5g4qBi4rVHITI+DcnQDCG
         zydlnz5cSBmgne0FeazUQ2DiWEdHVAl+KOK4u6dq5lO7dDlfHN/EprHd/gtKriJdfUG2
         sPhNxQR0KK3Q9uYsTeqy1bg419vHYpfEigcZNajraXjzZmUgDJuJ1lpfwe9I229ll358
         e7SJABPjx2PVSkbRvpgJtJm7Gar4x23tB+Rt/aeip8BB0cP7sCPR2uiE5K420aC1As2U
         oPWoFGyDX1b/YdxA71+WSKH5f/0x5Y/h5e2YvA6/oU407rp05ns7mztLFNPwq4vxHIKX
         9ukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721565871; x=1722170671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bYzDxCFUFMqRJFIh8zY3k87eDlMKl4v1Bq5SH2Zxdzk=;
        b=FjMtyEXgbWzGGFlcwlCnpeK+cSRIklgII/FQd5low64Wp6P1U5kZkisRjBCb8u8u3R
         hvFzxYyToJYT6QOUEO6r+1zbTxuMlbMwn/aGQKf7UMaKVsSGLlOKSKVpvYKymbN73QZ4
         MAYGs3vupErugchkm+ExgGiqGJFM5KPm6KVUWyW4fFM8mmcftnQfvgcOtZ29evLecZLe
         kjNPaeMMWEe90IatjmMAfcxVr5+G6M1o+W23YRYf19LdoVTNuQkO38Lq12SqzG7Ch+iA
         cL/odAUjgbvOTmQKbL0jXr2t6zlkFVK30qYkM9RmGYPPVeva+XEzfkcevLjoGUErLVxb
         xhbA==
X-Gm-Message-State: AOJu0YwOuNOfrqL83BsKk6mCbADZjF8+N7cEtuo3kiWNen3m2utN8TqX
	IqzitYfHIElLZz6/iaGswMdAH67+TgFRKu0vSRcgxJ5zSZ2QfKPeNjN2XPxr58E=
X-Google-Smtp-Source: AGHT+IGLTvhu9Y64+5DYeFH0Qtn9z3QidIQVILZPHumpw2bgH2HIOtAkUA3fTq81PQQhUbeLyr2b/g==
X-Received: by 2002:a17:903:2281:b0:1fb:4a57:7cba with SMTP id d9443c01a7336-1fd74574b32mr26797435ad.34.1721565871026;
        Sun, 21 Jul 2024 05:44:31 -0700 (PDT)
Received: from localhost ([60.206.64.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f479f00sm35686535ad.274.2024.07.21.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jul 2024 05:44:30 -0700 (PDT)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH 2/4] bcachefs: fix macro definition allocate_dropping_locks_errcode
Date: Sun, 21 Jul 2024 08:44:24 -0400
Message-Id: <20240721124426.248332-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macro allocate_dropping_locks_errocode accepts a parameter _trans,
but it was not used, rather the variable trans was directly used,
which may be a local variable inside a function that calls the macros.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 fs/bcachefs/btree_iter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index c7725865309c..489004173d28 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -847,7 +847,7 @@ __bch2_btree_iter_peek_and_restart(struct btree_trans *trans,
 									\
 	if (bch2_err_matches(_ret, ENOMEM)) {				\
 		_gfp = GFP_KERNEL;					\
-		_ret = drop_locks_do(trans, _do);			\
+		_ret = drop_locks_do(_trans, _do);			\
 	}								\
 	_ret;								\
 })
-- 
2.39.2

