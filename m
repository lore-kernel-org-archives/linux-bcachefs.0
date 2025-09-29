Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2721F280024
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137029; cv=none; b=CsbzlWBMzORYmelxMm6fEw0bNlRoUrnWnM9r6JOH+3p12e+x2ll+62NRmN2zTn+VNtQufKkx+gglklS0xix01u0+cARluO6O2m6VT078KiSiW5HxNNZyVY1Bzdg6OljwSB3zLjyRb8SurnG8ABy5hwvF92nLsRSkLTeJ7pPgap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137029; c=relaxed/simple;
	bh=znmLt5OfomzaGPDrSDsHdUSQfq4aMbq0Q7xNVKrUKFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kpLXVWtRE2dBjy10rTVl9gNV7NCeAO+uor3I4WmD5JUgdIDh9cXK/gkIYZJiRDsZAofz0QDDwm3gMy+Y7JnDbQ10/7YfxcdDGGRe0TlXxZVQTUzOr2bhGVRamaNcVgS/bMTCl/cjs+Pow0PXN2+jHeFFaRo6XzQA0vzK3kxnDmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9GjvHgE; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9GjvHgE"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so66740005ad.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 02:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759137027; x=1759741827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lj4WWsaRXLilwfaGRGcs2JcLn8T7vU8abZJFdf46IYY=;
        b=h9GjvHgEnJNOz6zFe4s1MknNq185piy4E4JUtA7HzxKht/rUPUiGcD2xqxIJe/WvmH
         j4sYKy1LJJd5+5JNBFwdqXc7PWsCClRAGVgynB7fF7XMrDSYIpD0wSbgambvRmEou+iI
         2vxDJHJvzeW2zO2dm4LUjtABHlRZRXY0w0sitpL5Uo6zbLeITbZokOEUISRX2HktNrtU
         6hFmdVbHqhWUpUIoqdqtdd2/CfBL/aDkleQsJtNj+tOaEz1dsXOwufX589RMyDJnYA/u
         gHrOeQYHD76Mj8b0t8PA9dRF8z3xrANrhcVBbU2nbeoXMxGbmqMD1klgdFWzfcHa8vzJ
         UoyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137027; x=1759741827;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lj4WWsaRXLilwfaGRGcs2JcLn8T7vU8abZJFdf46IYY=;
        b=hY1hGqi1mOQGy08GhQUEvoUTKUIRRGcX9p73nGk3pwdApldCA7rlukyG/j2sAbIy23
         QY0u2ltWotpNVu1+gv5iS+jThhrAyWRWwGSWMd69jA4ALQ9uTy07Kl5xJnozhgtozYmS
         AUlVy5gMVnHSYIAh9Sj94EY7k0/pc8tE/K7Lwn9LHyu0PCy0A8krKRLA3WCLmENamET6
         oEAUDTHhli+lcU7O9FMisE2g7V+hrDKLTqJf+ByMHqKRfCQASy9vTZJIgp9cTKqWv5X5
         fjDPp36WV2jn0MMirlBEtwFYAwK6M8gcwQhkZNaSC+H2W8vZIanxh5YGSGrPwPVTI7/O
         X8RQ==
X-Gm-Message-State: AOJu0YzOg5/C8Kv8KosCX84sDEj7zPICgqpuTct8obbW8jHVxTmkSF+K
	d6jJc6PP4e2EhWcUcXpKhhkOrBnBNODc5nGGsm9Z7d78fN3nFz2Fl0U+
X-Gm-Gg: ASbGncsZpy8/e+wAupbcZqP8xBCS5RfJsvjIo2fQPaD+AVHFqt/btYAJhrJufoLfNjh
	lSzgtN7KSnMCrSVB10pmLHp5tdBF3kyLRXDaGwsd4787y4Pe9Q34sxN14tijFcw9gMKM2ZOwTww
	ThJh7ZYXD1ueb/x/iaXRkNlIJmPaXQYop2CZUhxIsdxhVYr84sIGuyvTMm1RJlkz6vQGH3Y6JyO
	p1ErdBqMeOTQSj+/C3dELwymwqEwRFuo2LAkO+UFHAiQzEEntTDwLIrOAFGaNEQqz7D5zsJJ59N
	DVpwGIypMT0MBr6862OZqlTPxnRcUWM/9M6IGIQPwQePujvPZvY9RHbpWexHGNBnMJMA2GCwEjk
	xW4r6NsXb2UxCmt6R7YLJDG7hdRqaFC8799xws404f/LK6siugt7+t5zfjIr6BOgNSalq3zbUMQ
	oFI07THknNnHiJ7A==
X-Google-Smtp-Source: AGHT+IFQIlqwwlBzXubHVrRdsRMnA5V+YUkZjEI9lMxoHXiUXcNO/5V5bqXJWDQLGg8sqFpsyeZnqw==
X-Received: by 2002:a17:902:f54e:b0:266:272b:7277 with SMTP id d9443c01a7336-27ed4a6723bmr208637375ad.59.1759137027244;
        Mon, 29 Sep 2025 02:10:27 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:b352:f8fe:e89c:72bd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cf6e7sm124929985ad.2.2025.09.29.02.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 02:10:26 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re:  [PATCH] bcachefs: Fix deadlocks between fallocate and readahead
Date: Mon, 29 Sep 2025 14:40:22 +0530
Message-ID: <20250929091022.340341-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


I found that bchfs_fallocate() only evicts pagecache when FALLOC_FL_ZERO_RANGE is set:

if (mode & FALLOC_FL_ZERO_RANGE) {
    truncate_pagecache_range(&inode->v, offset, end - 1);
}

The hole detection code already skips ZERO_RANGE:

if (!(mode & FALLOC_FL_ZERO_RANGE)) {
    bch2_clamp_data_hole(...);  // Only runs for basic fallocate
}

The syzbot reproducer uses mode=0 (basic fallocate), which doesn't evict pages but does run hole detection and hits the deadlock.

The fix should be to remove pagecache_block_get() from bch2_fallocate_dispatch() and add it only where pages are actually evicted:

In bchfs_fallocate():
if (mode & FALLOC_FL_ZERO_RANGE) {
    bch2_pagecache_block_get(inode);
    truncate_pagecache_range(...);
    // Do allocation work
    bch2_pagecache_block_put(inode);
}

Similarly add it to bchfs_fpunch() and bchfs_fcollapse_finsert() around their page eviction calls.

This way basic fallocate never holds the lock, avoiding the deadlock. Does this approach look right?
