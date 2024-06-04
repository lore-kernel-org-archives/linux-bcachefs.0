Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72E6140399
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 07:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717487024; cv=none; b=K8K94J8xWuISgcXn7Ki5skPC790v6WwOsymRPGhGwa5Ncah4t+Ze1NKsadFVKgY17/4b5Hw3FaB0s5L2yVsBZFM9qZCKWq9dwRYXlEKmWFU+u4qO8/RJ0nTD1ADjMbPtEv/ZbhJ72WaGYYJOHPlUS1VfAQEQ8CGS0zaeXzVjhEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717487024; c=relaxed/simple;
	bh=qc3hXkSEF5z2jkRwKIsIEbQUTUH3IIR/EjL48rfPBCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ph0au1xl1sipQhleNo0YXriJ5RUInGNk3jdE4agjpM7PhAYZPS/yJRen+Qzhof7PCOWzBt0njrWifDO5Id6i5VkifQ22juWNCBfWEpTAgG3OjfXyTmxJ4cO9OqMyOurXCpx7FgClSRkaJ8yEkOVHpEm/XQJKsrNasCfQBwTD9y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QuAZZR0D; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuAZZR0D"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a4ea8058bso3074979a12.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Jun 2024 00:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717487020; x=1718091820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/Z4/3SXxfDRhaoMYIAuV9fKnTQmlIVycliV+P/hzP8=;
        b=QuAZZR0DWBD96GqzOyY+GF4g+KfwgExb3Mh0CdLlQnyNR1f5CclbTaD94uuyy2tz/z
         0TT6EespKw3JPoE4ROxAp0NK5tvam1lJem7nXsdaxETuD/naQIuIeteB76FaFe5yD60/
         S3dVWjvsSmExWhM4Ah+MiSFIQuHuV07TSFtY6Nf/8ZiELs5ngQOJpEuV2C6qOcjaO/pq
         yf61c7FMlVKCb/yw6v4Hj3cu7ib6VSlJxkakDPeWC0cXmSwN4lXBMJJK1dlEuSN5AYZA
         LCLtjYPJMIY0YxJQd0ZfUv0TbPf1WesVZzoHhOK0B8BHALqzSM39xpaEf9r+SOlLSfei
         xtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717487020; x=1718091820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O/Z4/3SXxfDRhaoMYIAuV9fKnTQmlIVycliV+P/hzP8=;
        b=JKEiMSNVtBMTvUVsAccDYHSiDV0s5qmlTiSANCFERYbfUkYWBlqhWSZUZoOcLYM6WT
         OInsRa+R9s+6il8+7orb0NQdOXprj/M6Tjo2pRwgh2k7S9pRU7F0w32kWmBY46sgLaIP
         Yg4VeawkqobH0yHTv136uO5Y237WGsFiyaSyfcqm/J2UPB49SjpyiGvtEXn28AN1XWmA
         LNXEXVed2UqvyQBf7lfhSP+PvVadSgFgV8e6BYLdo4+gf/aH7SMW4JjahT9KEb+N0Lu7
         f3T7yBQj1qWaz3gpDmTM4A6AFr4pjcO+MvbSayEjNJrAXDxg7ctusU48gVDS4nqU7TrX
         vpkA==
X-Gm-Message-State: AOJu0YwjfpychwEXTFXON3xeQ0e/l/1mil7Ph6eXR562rOSEJFLMtJPd
	Xt3vm9eOrQNd2+UKIRPSpTKdLXxYTrPaX8n9CZbqLp0wqP8Le01YG0WE4E41
X-Google-Smtp-Source: AGHT+IHK6mfSPWm85vJlogpx6ZoGyAKkkNzUEduZfypcU5NHrLPy2XkR/FoA1ngcSI5xMfnHfgkmdg==
X-Received: by 2002:a17:906:c2cf:b0:a68:e2f5:68b1 with SMTP id a640c23a62f3a-a68e2f56a80mr429542566b.49.1717487019959;
        Tue, 04 Jun 2024 00:43:39 -0700 (PDT)
Received: from localhost ([109.166.137.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a69089e774csm265247466b.8.2024.06.04.00.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 00:43:39 -0700 (PDT)
From: Ariel Miculas <ariel.miculas@gmail.com>
To: linux-bcachefs@vger.kernel.org
Cc: Ariel Miculas <ariel.miculas@gmail.com>
Subject: [PATCH 3/4] Fix incomplete file copy due to copy_data misuse
Date: Tue,  4 Jun 2024 10:43:24 +0300
Message-Id: <20240604074325.798349-3-ariel.miculas@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240604074325.798349-1-ariel.miculas@gmail.com>
References: <20240604074325.798349-1-ariel.miculas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The copy_data function takes a start and an end parameter as the range
of bytes to copy, but it was called with a start and a length parameter.
This resulted in incomplete file copies. Fix it by passing the end of
the range instead of the length.

Signed-off-by: Ariel Miculas <ariel.miculas@gmail.com>
---
 c_src/posix_to_bcachefs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/c_src/posix_to_bcachefs.c b/c_src/posix_to_bcachefs.c
index 63fab98f..52105be1 100644
--- a/c_src/posix_to_bcachefs.c
+++ b/c_src/posix_to_bcachefs.c
@@ -288,7 +288,7 @@ static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
 				  FIEMAP_EXTENT_NOT_ALIGNED|
 				  FIEMAP_EXTENT_DATA_INLINE))) {
 			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
+				  e.fe_logical + min(src_size - e.fe_logical,
 				      e.fe_length));
 			continue;
 		}
@@ -299,7 +299,7 @@ static void copy_file(struct bch_fs *c, struct bch_inode_unpacked *dst,
 		 */
 		if (e.fe_physical < 1 << 20) {
 			copy_data(c, dst, src_fd, e.fe_logical,
-				  min(src_size - e.fe_logical,
+				  e.fe_logical + min(src_size - e.fe_logical,
 				      e.fe_length));
 			continue;
 		}
-- 
2.34.1

