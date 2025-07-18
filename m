Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A6E17A2F5
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 18:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752862616; cv=none; b=HB/WgPY9BgNIYQWVHrTddo2AtnQn09atk9mQNjprF5d054gY1oMpIuW4rnrup4tK7KYWI9sdqZXl9pquqMCFxxZZFV1nGyjYPbXITvADIarCmSCmg127fzKJqX6sqwKV5qn6Slj11LUKCb4JQHZRVkAZwobaAnxHh5W7gnaNJro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752862616; c=relaxed/simple;
	bh=bXxcujjyeZ/tK1cViodkyoabmarszqp70wlxxwDykyo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JQwo5Z+ypkGC/9zhkjGNJkTEw6IRZe7oZyHnk7R3TVq7jdf3T/PBzTJ890UfTKLkxmis35vqVMtca1aQiTBzC3JEmLuwaQHLxstwPd3UFkrlKLnsiiLUzwA84S5KiLZjYrwjlRJIFZpR37SU+B33iPkDYwj85YfYcOp5jGLnhB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JaHtbQa8; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JaHtbQa8"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-75ab31c426dso328878b3a.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 11:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752862614; x=1753467414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ume53cEmkG7mmrxweQ62pw2qTC1KApDiDVve+Omg50=;
        b=JaHtbQa8aMo5Xai6ZZ8x2mwqdKt6ky3hz4KKfsuA/eWTkHneeDTCfgoNw8AloytPZ7
         0bGjNIVgcVjh9k4my2X2zodBt+njAHoADjBfTdB1CIxvS3D1+rPzqHaKZowGxuLJRek5
         GHmdjNYpd/IS7M5xHxV+Ry/eyXoiXSp6Uk2Ija/yZwiZcMezLyDkao9wpcbImxFMa3O+
         bdG5sqzvo2mhy7AxAIe8S9tGeuySxKQX3IG6yP2c3eIRLWaeLtqL+nmSjyfWPFLDc5te
         NebaoztJP70JP8NXVjzt9CeyltXO32cKV7iU4vEoVjEwTYvv/iV7pxs4JvYF95p5sGCY
         aTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752862614; x=1753467414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ume53cEmkG7mmrxweQ62pw2qTC1KApDiDVve+Omg50=;
        b=c67v0tJpHiYSL+D9J5jZZB5cfwcoCzINoJX/7j8RIPLgfjMtvLCm/HE3lN9SffuO9R
         gtmK90V5egwo9m77C7vVg69T+WT944Q2qckTPcGWqxNuFQh3UylD7c8VbOgMSINjjrYN
         6173+58ui8YBBpbT9VSkgvGHvlBvNZoxjImu+LpabtVsemuQwoIaypKntciRvhi1s88J
         1HslkElzpJExZSDB3jYX6wBf/Zc/chBGJiBjNPJhieCw7LIh+yVft4ZSmOfRyJUFja17
         56q/AMFTdTfQBw5DsWigH1MOyipL0U5xLsEv/2yLukxupnijzJffCqjbof1PesZLmX34
         wdFw==
X-Gm-Message-State: AOJu0YxsQsx3kVo0N9P3kuEsE3ewASnnhbNFr6XR6JUuhb+co8H8cxqT
	f6a1LZqr2qocPeyG44PHB8lEL0mo8Wsi3XHEAjH1AxPNmp8+PwP5p5rv
X-Gm-Gg: ASbGncsNxUMJUPRgLNBkkwuBW8zQhNstL72R0UmUkJQqV0O9rny7p0VZ/YAdHxjXM62
	YCMqxDTb9Wpdau24DbKcolqFMcQcK/YkDM8Kd5QAEn6iwQM81p8AetuEalX9on/QjYvtkVYA1Jz
	SczvwdAtiw+62xWbGse8M2WVf06z5amEgzxyUiNjrdF7jcaGORSzaILJU1Yp2H6vw43+9mW0ZUk
	4jKtsKwj/Hrv8/Be8fH2BTZDJqbYDkqgUoP6B+5eFKSL2BL6dcVc7TGo1pL/VVfvf5aQP3lMcPP
	YwraRHhh2XW7Sj2y1x+Rnx9DJwVsq5lc2vp65ejGhT5iyAgyoXFU/7JN8q18iXVkjuOtLlNv
X-Google-Smtp-Source: AGHT+IF14PoFCANWYvwj2AIws4U1ai5dr5gd+wwP8+FOfGjSFJdRbIg0h+eGtSNs/5OPw7WMNK3AFg==
X-Received: by 2002:a17:903:2292:b0:235:ea29:28da with SMTP id d9443c01a7336-23e2569c2b7mr190855175ad.17.1752862614314;
        Fri, 18 Jul 2025 11:16:54 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6ef21bsm16535945ad.197.2025.07.18.11.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:16:53 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Use user_backed_iter instead of iter_is_iovec
Date: Sat, 19 Jul 2025 02:16:35 +0800
Message-ID: <20250718181635.1502126-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ITER_UBUF is also one of the user backed iter, which is equivalent
of single-segment iovec. DIO handling should use user_backed_iter.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---

V2: imporve commit message


 fs/bcachefs/fs-io-direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 1f5154d9676b..6fdc477c81af 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -127,7 +127,7 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	 * the dirtying of requests that are internal from the kernel (i.e. from
 	 * loopback), because we'll deadlock on page_lock.
 	 */
-	dio->should_dirty = iter_is_iovec(iter);
+	dio->should_dirty = user_backed_iter(iter);
 
 	blk_start_plug(&plug);
 
-- 
2.48.1

