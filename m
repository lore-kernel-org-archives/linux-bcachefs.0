Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA327BF99
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Aug 2025 13:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754660606; cv=none; b=c0z3+zkBD495Hn2795cZ3myIOZt5bcTXL/pwciGLEIcX73Bm5S1xnkXOGM/j37qdvafI7c3Sm9e95lwXefyKFwF82hR4voydYaFaeQiEqcqBxew0m7NbMGGXJ9mKhn7QDVO0oEaLxc9WiHXVx3TigaWSAFjqveGIT1nsQE+3yHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754660606; c=relaxed/simple;
	bh=+qPvdcSwQ49TY6NA4nsu+hSKDXY0JV6LJdT/AWHbMe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcqyEKup1dt4J7us60ctRaTUl8FfwiADHltUQRZLEi2x36KDVZKG0IMig9wQyizqNFrAWoMU1Mk9nIqRKwWySOYhOsGGyY5+Bp/sM6H6FiH36IjykwdXEFCKnVEKEFbzH5pD+nf7FsoWbyIBKEcle5jr3bF1jFQEdJgW1O32yfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UX73arX7; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UX73arX7"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-31f28d0495fso2901446a91.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 08 Aug 2025 06:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754660604; x=1755265404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAPbLq9xF19i2azsMhlZgZFylTj+FQxhv6J6CUz1mL4=;
        b=UX73arX7iltCQHzAMWM7HxZCgTvPfF4QJ3ZHRUpU7e8dVHm9CxRYDx/NFXgxC0ipHj
         rYI2/+UtC2Sr/TWn/foHaMyC1lX4AzWRHbhQfNPWOKPcUV/DApsybdlcQjzxcT9mrUBG
         PkpHTBynKYBo/EDOI+z8TtyyPQfQcnA+CcZE5lpVuHTXaHYGGwprj/fZuIDvIBmVUT25
         Etqd7mwYpUUSyKdHOjuX8vKXPhZcH945EA8WacfnZTEtWP4BOQmAza3prXzZF0KQ9gh6
         bfzT1/6eHpQ/4pECyvHVlGixAiajN4iDTRjU7wTKgjy3WUGOAvkD9cLTOav2MQ1to228
         THkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754660604; x=1755265404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAPbLq9xF19i2azsMhlZgZFylTj+FQxhv6J6CUz1mL4=;
        b=sfXBJO032++ztHkemddOgHuxJ4cNAnm/PAhdqaH/syeItUlF23QbFX/jEWlzSRFmpl
         jSYBHBlg8CY4XTPNaSuySYHZXuKiwCr1hoLjqw4saYzDtBs8LYn72xXkz+Xd2fcD9sdN
         /NFGmDyHVd+50o4AibvTTlJFfMtdhrPWZUr0Eki8M91pRiwIlPjyBbbhebmGrA8I+e1/
         HuffA03rOwd+lHy4JtH44X8VT/3Z16ZfL7ul9Ed3kXN6uyEbhxz4kpjIYN4C7JquGfUB
         qZGUcbP2ijc2E7cNvWSp/6NjlIffGPZTSgRvPmY3fz01z/Iv0ikhEyvLY4GbaR3PXcE0
         9tTw==
X-Gm-Message-State: AOJu0YysIv7YtwmPyhNJ2wkyvmVudPAuCMXYqVAdlkBI8xQn+j0585A9
	ANZnRYRuElrfL6MNbO/ko2b/KHk29XYq81uXr/LveaBV9oI/wtoIG/axCostcQ==
X-Gm-Gg: ASbGnctsgUGRzovYR/NKa4b/kNsNYJoqW9hmIS28ZueBJpQC+1zNJZLRfPgGC556pyo
	60AsKnQz5clLXDVZKJrSh41T+62YRjzHP+lEnxM1KEvlfIxUOVLzuXZG3WmVKhbqOgO7AkVO0QH
	ODY8YRCPXKjGKka/sypTQEke2bFYBgssZLNkEis6adMFXk5ybOfmVPc5OWcCRg1X6aD2900603T
	uhj5jgw3rFlD2I5NoqescAD+IL1OfRCLLsaOtel0+nMSO3B76Bx9c7Z09l1RjzFJm33u93y2E2p
	jhuAUAup+tG+94kZR6/tXLNxJY2KWgK+edCk8/BooXBHSt2UBoIW9PN0DaCUKd7psx04qKUx
X-Google-Smtp-Source: AGHT+IEbCe5pursIfJ1RrzfWaTZ+DyjWBq1KNbgtQK32BXiwCH6+LbwdEs8JUfqd8dPfkBZ1nvNKjQ==
X-Received: by 2002:a17:90b:5866:b0:311:e8cc:4253 with SMTP id 98e67ed59e1d1-321839c7079mr4023838a91.2.1754660603847;
        Fri, 08 Aug 2025 06:43:23 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32102ae8b5dsm11787139a91.3.2025.08.08.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 06:43:23 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/3] bcachefs: Use our own splice_read implementation
Date: Fri,  8 Aug 2025 21:43:11 +0800
Message-ID: <20250808134312.878432-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250808134312.878432-1-mmpgouride@gmail.com>
References: <20250808134312.878432-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

splice_read will read file data to the page cache, to prevent cache
coherency issure from happening, we need to lock ei_pagecache_lock
around it. Therefore, use our own splice_read implementation.

This also solves one deadlock issue, which locks the folio first when
bch2_readahead is invoked from splice_read path, but fail to lock
ei_pagecache_lock, which was already locked by the direct I/O path
or fallocate path, when the DIO path tries to invalidate the page cache,
a deadlock happens.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 0425238a83ee..6d8830345538 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1716,7 +1716,7 @@ static const struct file_operations bch_file_operations = {
 	.mmap		= bch2_mmap,
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fsync		= bch2_fsync,
-	.splice_read	= filemap_splice_read,
+	.splice_read	= bch2_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= bch2_fallocate_dispatch,
 	.unlocked_ioctl = bch2_fs_file_ioctl,
-- 
2.49.0

