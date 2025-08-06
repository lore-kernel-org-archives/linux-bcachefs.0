Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EA1244666
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754482826; cv=none; b=ZLxu3JWTB40lxbe2pnkN8aERXms07PcWyEROuXRov9C9JLJRHjGqtg6xp69Pw3GsG9fUZgesoVn7zO7p90TteyX+6SebAhym70CVQh/nbkyyOFZsTyi/KKYFBAIuh1W/TyxVp38EhyZ4togn8PWTgMBdF40OXs8nKbFat2AsHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754482826; c=relaxed/simple;
	bh=xlaQyDjDI9lYTaIe6ySzoJMPOvto5JwYxtN47pKzH2s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NE1msWs1ftI/wWMEeN2OoXt/7nEpqslEtf5iq3WJdTudhI+ClXSp6Sa8aLQonWQUrIpkSIKlIvA/qIqHbsOmGRUKOzLYrpBUgGJteDQffQ4O4G7xgth729METQ+1oo1S1nqODdaWGkg0biZK80JwisO9G93pA/dA1kAwSzXOGig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CdLzlrHd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CdLzlrHd"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76b8d289f73so4839782b3a.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Aug 2025 05:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754482825; x=1755087625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j0cX2S3yVSp710Toj2Hy60+7B0ynKVV8AeoAoklO2nw=;
        b=CdLzlrHdRS/IP8xhm5V+faqkEPor6JNAQxR4sfcuhrAu1hDc2+wDgmXYB6hxoBXncf
         i9wuFlZlbqc76b3WHXKApdhd4vEqDAxBtx1GzHF3AigkosmP7xa8y/LcH2bQNFPXffZB
         0jwg6NFL/K+XkX9Psd+C8OW/Mc4KdljkWLfJsV6L8ykKgWR6s+VdWqIgAmZdWdieetv9
         kUKRM7dnTCkT9eZrOLSMUTyfdWEgW1s+qs4VHNzeTi33KOU1QOQnN+f1YrxFvPaiv6bS
         vF3akoLV5herJ6A72HBPJcqY67M9eeMYQBI5DZD9kOB2HcDvkNEuNuduVtUhieFDirny
         2YLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754482825; x=1755087625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0cX2S3yVSp710Toj2Hy60+7B0ynKVV8AeoAoklO2nw=;
        b=qarTgU0Et0AFu9Veej78B+QJZQUir+I4CMrrP8h5e1cZwGe7m37TrekPxEdYuB7crP
         pfLms+DCup407tJSM6TuDtb6s2mfplC5ergJao/rkVLl8oGlFIQlF2wpEMnaiZ/1z1NG
         07f+iko5HrabvzuZiZYtOrNnl5G//E5uWSrUXqKL0YJ5HHrkxTk+TpU4/GgZCgoPQFxg
         T+sKq/+MbX5n9JDAnL6qNowD/VFR5cStb4k9s5s+DusEAQ7jkdm/WTh9DksrMQdsmfcP
         MUgi7fnxowoiYnAd6+igmhuzR+vYf4nh7I7Ukbx7i9S5oIGIdCCbVeHpcqBzUgYM5GFq
         oowg==
X-Gm-Message-State: AOJu0YzfM9yC2SuLjPSfdheAAxa7Ur4yfP0svoY98IhlDIpTcVKdidJU
	xPlAY+1kPeRVYlr/2tQNvAgxxJ18Ddr46yY/guhEs/ik0miIeBN5aiBn
X-Gm-Gg: ASbGncsDTn5VEMFGanduwqFTZz4FpXd8m1NRSG4MfGotBT75B4FLAbNX83Epn6Sl/nJ
	J4ETdsNYs9KrDVTA6yUXJ+2VOd016IoxTg0a1q7/cCbOriG97InujQozLaAuFgVOrVpnp4+YS7O
	TicaRULJAH1i8sKiuxcQHgIQ7AvUhpysoPLso1jKzd+ABf360CJpylk2alivUtq/Qx7U1N9I7mv
	e3MaWF6wM1ghQRvlioHaxXIQOLp2B2p+hNKb2HR0IVIzughc8iKUmVnVn6Xa5d8+JcA1HFmPQmN
	6yPsagbT/wgeLt4HaDgiYvq46N2/YysPnHQHdRF6UMLaQtnjF1KqqiTY/r/RNv8NCJ8oITRp
X-Google-Smtp-Source: AGHT+IGX5ZW6rwr1r/0w32zHTl1if0/fO5/tDYELQgh/AUEknmaeqLbYzKOqUgbKKoUQLtZ2zOwiPg==
X-Received: by 2002:a05:6a21:9997:b0:23d:3513:935c with SMTP id adf61e73a8af0-2403137c84dmr3723957637.6.1754482824659;
        Wed, 06 Aug 2025 05:20:24 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4289c5e123sm841489a12.3.2025.08.06.05.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 05:20:24 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev,
	dan.carpenter@linaro.org
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix possible pointer dereference
Date: Wed,  6 Aug 2025 20:20:18 +0800
Message-ID: <20250806122018.552250-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

c hasn't been set yet here.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 09b9c72bd4b7 ("bcachefs: bch_err_throw()")
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index b0019488f586..5992ca040bf6 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -2369,7 +2369,7 @@ struct bch_fs *bch2_fs_open(darray_const_str *devices,
 	}
 
 	if (opts->nochanges && !opts->read_only) {
-		ret = bch_err_throw(c, erofs_nochanges);
+		ret = -BCH_ERR_erofs_nochanges;
 		goto err_print;
 	}
 
-- 
2.49.0

