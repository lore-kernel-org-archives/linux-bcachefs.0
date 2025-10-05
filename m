Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15A1A95E
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 Oct 2025 04:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759639165; cv=none; b=njU2QBjH1VvanZMSFGeXsJYKdidb+LYDIkHcZ19P4jokpDoL4bFIKhKBL+uR1/JjFrkF22+pZhP3RIOpszalvFyGh+JxIKhkBhKlbB4IiuisTtgZXflU/CBy6gbBwoMa2wC+Vsscq01+jsbI0UQpbZ4ScN7CZA46sRbNOlBugPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759639165; c=relaxed/simple;
	bh=XH2xXUswwjYui6iwKQscZaPoZe7ppMJZ6Sgoi/ykVGI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JMRQ1Q+Cg5iR1jVUtBsmvL+WiT0TVNtnbveWUQbvx8Edhw2kKmPToZVFXrglFmmwhvTqLZUgXGJo4Z2Ko+0+W77QztqJSuXjAt1ZL1mFPKw60y+oeybsw25y/I4kbx8CO4niTy1fnLhRwv3TYsZH2gEaLBEVEVf3b07QZfhpnsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in; spf=none smtp.mailfrom=ee.vjti.ac.in; dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b=Zoq7tnkY; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b="Zoq7tnkY"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32eb45ab7a0so4011287a91.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 Oct 2025 21:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1759639163; x=1760243963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Apb38vvwB4yx6ZuSTdH5FloXnDPkndq4ehFPRMxQ1PA=;
        b=Zoq7tnkYdhztbb8x4zsdNzsS1v4Pi1UmMtbx9tCYMB4ZHr003/gXfaWB9OKxjyZCx1
         TrEnfYeAambmGtUS1uF0z6ukFCO8jTKhpITZpsnqwuAMtlqByTT1rd5In9gKoQbuHiUI
         jKvx/G4XOXwJe3In3Dr/wQdrFzoUAYIb3E0Ns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759639163; x=1760243963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Apb38vvwB4yx6ZuSTdH5FloXnDPkndq4ehFPRMxQ1PA=;
        b=IYn+JCBtkoA2ZSkmmTtzy249HhUHTjgW5Se2Is/ZFJGVPK48hVEPtM8mFvP+kULMa2
         8uitUVgtNE5a2zjAEsYxkI1gWmKoceif5eFuTP/cxYPrhB1oQHha8UCOLwlC4uokHLdc
         GvT5S9GgGnihxxlnZ7sqpZsB9XXVgLDJBlFvE/cmICgYcyxqt21qIQCY834bdpUSIro3
         hvYRWiUxGjFkVu2bSSxc26GEWyOFqDUZ4ojbeBIZ7xJNDQLPSPXh8w2wtsufTFzJz014
         NW2MVlJDQ0lLNAyLoYLpWvjxPPpNKCdmGM7M5DdyML4VchoaI/U5ybWUsSD88wvttAJl
         2xpw==
X-Gm-Message-State: AOJu0YwrsH27b+gRP9L6PDZI8Nc001kYFSwY63g8gjItXgK0kZw5/A9d
	eHhkAGm1V4kUXP+EDGfcHT9h06aF1+1FiXxpsNSWwLhpLzP73DHrggwMNO31kpLuxGfwLrmrZyC
	OJemEhUw=
X-Gm-Gg: ASbGncuG8Hbq9KbUsiNKZcONcdqX6MPjXcfkmgVKVrWunAkvA5zW6FPe8JiCYIbA51J
	qW5rVb33md2jr8wNgtUoBgl5ULJWnerbhVGE2hlLVCTGKcVwTUWjJ3WD/LsSLfYtHOER4BBWC8L
	yWjAl7kMiJk7F49HTGEgl7q+YM/vOspcv1MnUxUy7YMWtk9njLeI6QlCsXwuFozYW/MrNfc2W5Y
	FbDy1BhChM8Df1KNANX2BV53dDNF/KN0+PLA4qdw0qMNAZRibMVQLKhHATcihkqFxVQmtUMjWfT
	tYPfllFuxF1kOdve+hixE2ctBzZthTR6nDH3WjVOSeU7vdhbKYBIsYJ82jPv2cyYPtxEuppkrXl
	UgWMe7C/L4GLYDyuIhHOC4Kd/ePI04SeVdOdjAoObnOBltM0mtiAFRhVdIV0TEfyKUVbm36GlKX
	GT9J2E5bz4kkJmJgOuA1M=
X-Google-Smtp-Source: AGHT+IGifsrczbdDKYNtv1noTEjGaiFZdC0gFOLKpD4Gx2VS5pRYTYCIpxROzAXFy+ub6zSL+d/53w==
X-Received: by 2002:a17:902:e801:b0:269:ba8b:8476 with SMTP id d9443c01a7336-28e9a6a20efmr107869995ad.56.1759639163061;
        Sat, 04 Oct 2025 21:39:23 -0700 (PDT)
Received: from ranegod-HP-ENVY-x360-Convertible-13-bd0xxx.. ([2409:40c0:105f:3153:f16e:6b07:4a58:8dc0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1d574csm93059645ad.108.2025.10.04.21.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 21:39:22 -0700 (PDT)
From: ssrane_b23@ee.vjti.ac.in
X-Google-Original-From: ssranevjti@gmail.com
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs:fix use-after-free in __bch2_bkey_fsck_err
Date: Sun,  5 Oct 2025 10:09:10 +0530
Message-Id: <20251005043910.32975-1-ssranevjti@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>

When mounting a corrupted bcachefs filesystem, KASAN detects a
use-after-free in the error reporting path. This occurs due to a race
between error reporting and key deletion during fsck.

The sequence of events:

1. extent_ptr_validate() detects an invalid extent pointer with a
   corrupt disk offset
2. It calls __bch2_bkey_fsck_err() to report the error
3. The fsck logic decides to delete the corrupt key
4. Meanwhile, __bch2_bkey_fsck_err() calls bch2_bkey_val_to_text()
5. This traverses the extent entries via bch2_extent_ptr_to_text()
6. sector_to_bucket_and_offset() is called with the corrupt offset
7. Memory access occurs on data being concurrently freed

The crash happens in bch2_extent_ptr_to_text() when it attempts to
validate bucket boundaries using already-freed extent pointer data.

Replace bch2_bkey_val_to_text() with bch2_bpos_to_text() to print
only the key position (inode, offset, snapshot) instead of traversing
potentially corrupt or freed extent metadata. The position is part of
the key header and remains safe to read even as the extent data is
being freed. The specific validation error is still printed in the
subsequent lines, providing sufficient context for debugging.

Tested successfully locally using syzbot provided reproducer

Reported-by: syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?id=564efbe31172fe908429
Fixes: d97de0d017cd ("bcachefs: Make bkey_fsck_err() a wrapper around fsck_err()")
Signed-off-by: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>
---
 fs/bcachefs/error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 267e73d9d7e6..b0bf08915aa2 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -688,7 +688,7 @@ int __bch2_bkey_fsck_err(struct bch_fs *c,
 	bch2_btree_id_to_text(&buf, from.btree);
 	prt_printf(&buf, " level=%u: ", from.level);
 
-	bch2_bkey_val_to_text(&buf, c, k);
+	bch2_bpos_to_text(&buf, k.k->p);
 	prt_newline(&buf);
 
 	va_list args;
-- 
2.34.1

