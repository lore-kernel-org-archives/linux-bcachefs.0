Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189CE1A2C11
	for <linux-bcachefs@vger.kernel.org>; Thu,  9 May 2024 18:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715279870; cv=none; b=Dlfpx/srQbQiF/qSqGfrbEu3v0fcpp1oDLj5nxdrpQdhIiC1WkYxi7vDd2062mPsv6DjHg9bQ+qyQUSFkGICpa6exGHPFvIEniIFqAoI4Q6t7G1G5MB9sgE8MNaj8iFt8rgNCQcNjbt1kRgj6GInf7VquFmhsROYNji4r5dbgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715279870; c=relaxed/simple;
	bh=CzUXWnDEw3uoO8ZGL19oPbLFeAphyVjEg05TeGFaZ8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=spl70gh+lN5/R6HaGFSuVtQtQQK6PK7YYGtSnVushqg6NT1yVkrzp0UrgZ9nhf30HPew5XfhwKUH/suJUfVVEnAiQ+SMRgOg7jeikiYOE2heiMoXhpbv78bf+P8lIunSY0+ZxU1JKxcqM/QTSEtpZ7kD+4KVGsNj8Y6jDjrzwvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f+VxYRrA; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+VxYRrA"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7e18348733fso47765939f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 May 2024 11:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715279868; x=1715884668; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BzH5ZCdz3o9Lj9CpGP/bvOrexySD/NWPGPOHwPJrfbE=;
        b=f+VxYRrA1Qv6+sjXg41SQJHXKWxWAoWeLNWlQI0dC8jY+3kO+G6EF8UxhJO24j9oz3
         iTemEoZHu4TdJ/H1Rg5lH9zTy9JLRYqhc9G6waWAWtn9JOOJdQ7Q2Md3xEQzRpaE4+cN
         0UnHIO5kib1SY2ZcBtf0+p08puBnysGvgVQRy1EwELzQHtewZDtlAVwWmXnOJ9F7DKBg
         Vtpu6YiNJMdLwZRDFoIp9YAYiBU+dPOBRTS/eASBQNHnG+9+2vMA4SGuqJTHWd/EN1Po
         KkAmlRJKwixtcbPAxkqXdLnPdo54Dzvw10bdiRzbrraITNzEw8cxa7CeRtt+8Ch7Ql/S
         tGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715279868; x=1715884668;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BzH5ZCdz3o9Lj9CpGP/bvOrexySD/NWPGPOHwPJrfbE=;
        b=IU44+9KW7mcmniFYWaB5kj0m064e7/iscQBQSL5enVaAr4oQ0+l9AKekLLgARgh5Fm
         +tzM0XR85BX+HDk04+ZZ4ZsChHrQizcrAvtHTVA4FiPE6Co3g6gQ/vLALjNZ6vxUH+dh
         YO9i6A6eqBuZa3peCXnq9+yFv2gzAhXx4ezj49Ck0Dwpm2E84qG4zdZT/Ox/jMfrYWNd
         l4W/sBJ2+8mzQDCcDb6TbwaLVrMfK2ThQ71oahjEa2SQaYYXhSOeM4D1x95xZEgBLksi
         UM9l54l+SohuUbPcUc646i8tufxCqBmuRi2nUBiKJlYgTOcJEFNLhQmKHfdJkeyV63lf
         zYkw==
X-Forwarded-Encrypted: i=1; AJvYcCXopfrkl7Vubma1ueszhqdRcfPsIOP2hAQw8paZvbcv8nD+s27SX8zV6x7x4qelZp27d/5+9CeCZNvxFpnJoILtLzkHuonuo7GW42avwxY=
X-Gm-Message-State: AOJu0YyUjYd43jGWnGT6RgswsUYtGfNvtoM1exzC2vHHNRWrspc0CgCr
	FTQzIp8gNRn3QD2n73gJ3NpXTLpHEWtjaS78Yi/CDi58HKWaKPti8zApJA==
X-Google-Smtp-Source: AGHT+IGwn5Yck71a4d0/VsQg6gOIZlUMhXiLeqaapqvvkdjlHaqOWFYFylJWAptlQeZZ7nfmgSqHdg==
X-Received: by 2002:a05:6602:25cb:b0:7e1:83be:6897 with SMTP id ca18e2360f4ac-7e1b51a5d0emr63747439f.3.1715279867006;
        Thu, 09 May 2024 11:37:47 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376dc80asm493733173.135.2024.05.09.11.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 11:37:46 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH] bcachefs: add no_invalid_checks flag
Date: Thu,  9 May 2024 12:37:24 -0600
Message-ID: <20240509183724.29171-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting this flag on a filesystem results in validity checks being
skipped when writing bkeys. This flag will be used by tooling that
deliberately injects corruption into a filesystem in order to exercise
fsck. It shouldn't be set outside of testing/debugging code.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 fs/bcachefs/bcachefs.h     | 3 ++-
 fs/bcachefs/bkey_methods.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index ab2dc2c70da2..bc0ea2c4efef 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -637,7 +637,8 @@ struct bch_dev {
 	x(error)			\
 	x(topology_error)		\
 	x(errors_fixed)			\
-	x(errors_not_fixed)
+	x(errors_not_fixed)		\
+	x(no_invalid_checks)
 
 enum bch_fs_flags {
 #define x(n)		BCH_FS_##n,
diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
index f692f9d8f00d..c2c3dae52186 100644
--- a/fs/bcachefs/bkey_methods.c
+++ b/fs/bcachefs/bkey_methods.c
@@ -126,6 +126,9 @@ int bch2_bkey_val_invalid(struct bch_fs *c, struct bkey_s_c k,
 			  enum bch_validate_flags flags,
 			  struct printbuf *err)
 {
+	if (test_bit(BCH_FS_no_invalid_checks, &c->flags))
+		return 0;
+
 	const struct bkey_ops *ops = bch2_bkey_type_ops(k.k->type);
 	int ret = 0;
 
@@ -162,6 +165,9 @@ int __bch2_bkey_invalid(struct bch_fs *c, struct bkey_s_c k,
 			enum bch_validate_flags flags,
 			struct printbuf *err)
 {
+	if (test_bit(BCH_FS_no_invalid_checks, &c->flags))
+		return 0;
+
 	int ret = 0;
 
 	bkey_fsck_err_on(k.k->u64s < BKEY_U64s, c, err,
-- 
2.44.0

