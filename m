Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65EF381B9
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708354222; cv=none; b=D3Jcz+WQR5LgUzOMG+hLVlUA/6108XIUEBF69qDdctlEfmrlnCyHTJ1P4Zz7VCRsbnry8adrcLAm9RsKP89F4GwQQMgPC9+f/9crZA2axUBeC7WTjZKyOQkaTKx0g2J0xsEVn4vHsuaAZJGO6W1CrTCMYnjLJpx46YoTa07VoQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708354222; c=relaxed/simple;
	bh=kcBsqAy3BD/TDrAAOj8ovnHtGhF3Qlaun4i2674XGUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaJyGpwnT8ZiIJM9S2iGD5ik1IUKY7APuNBsJlJo/68FGlci7JsHRWKVTcOBiqv50QYS1V+eRdxGMp/0Vcnhq0wa+pSzjbTPCO238HAvAXkQvLh/rnejmvfZMlqMeYbSmdTCJOq84Hs7/xWGD37fD5Rjyl5cOM8HUG4PyER5eu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=lH0qRwjC; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="lH0qRwjC"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6e457fab0e2so560371b3a.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708354220; x=1708959020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/oEceRAk57b6w4Q8uf/WKiIB0C/fdshH3wFbcWbJIs=;
        b=lH0qRwjCUXRv8XFBF+1oH2XkMN93ETp55D/AYIovneBCf7pKzJiQ0YP3BtRUUfAycr
         z1OCsvPVcr+5WwuzAVmLf8DOZVd9oakAfwDnBvR447TI59o8jUaC+sbs+lYy/Y4SIQ1z
         I6QB7zfqKdmoIa5YUnjpBSrEL1wsXEwncgC/Hwvj3Rj/Pyh3QfxrCUjuJWuoMayPePUF
         DarVB7ZSRNWwVT71Gz74/RTNAO8keqnldZZY6yZVy1fXVgS+hhc2CfQzHVYCeoxHHa18
         hmX2Kfqg4niaG3I/wAvXbOc85kp1JeTwatMxADuGPTWI5s/YxsGD/rB87NMNA6vI06R2
         NH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708354220; x=1708959020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C/oEceRAk57b6w4Q8uf/WKiIB0C/fdshH3wFbcWbJIs=;
        b=Ucv07QTXH7D7kxPjRA6cCVqdgg62WCbR8xBN/jjfPm8k/Sm7bfjjcRD/KataSX7MjD
         Ndrr122G6MX/nilK44EnYkNfFZ1F4C+G8zqq0A1h1ysPAUmBqmr+avFP7al4tOrgkD23
         wNd8kQYHQYiDk0K1UoRcnZPuVJB14uakXsksvMOA50l4Oa7eFssnjnN5kmvQ11f1hsYu
         xn28WahFdOZGJ+scxFRVRGosY+FmcXjTOybBV63OBuC5IT0M/hXO6deV+TXPpVwHDggn
         kohmIj2bub8JxzSdWIecEnWcsAq6snQNucY/Mc9OdL3EcfTlYWljTITjltWVTEWCd+CX
         X39A==
X-Gm-Message-State: AOJu0Yz8Sdva/BlUVxLvkDbjRU2QkLaHjOGB2983gR8xIZWLfoEoOTCL
	oJvvf11Xtwju/puj0rFFm4TeXKghHoAQjf3m/u7c5Fs1sLrcGhFvNcZxF6QoL+C3oht0sHgx8j8
	L
X-Google-Smtp-Source: AGHT+IFcm5gw1c/MMIEElfUYbZtCO9Ctw0Ts9hwjYQF4/8uTeJvNiwBQyUifzhy2EFYCGIa1fYd/1Q==
X-Received: by 2002:a05:6a20:d492:b0:1a0:89af:ca2c with SMTP id im18-20020a056a20d49200b001a089afca2cmr11328803pzb.13.1708354219720;
        Mon, 19 Feb 2024 06:50:19 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id e1-20020a63aa01000000b005c2420fb198sm4155101pgf.37.2024.02.19.06.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:50:19 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 2/3] bcachefs: update fragmenation_lru in alloc_write_key()
Date: Tue, 20 Feb 2024 03:49:16 +1300
Message-ID: <20240219145008.915291-3-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219145008.915291-1-daniel@gluo.nz>
References: <20240219145008.915291-1-daniel@gluo.nz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The alloc trigger normally makes sure fragmentation_lru is correct, but
we don't run triggers here, so we have to manually construct it.

Signed-off-by: Daniel Hill <daniel@gluo.nz>
---
 fs/bcachefs/btree_gc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 6c52f116098f..43ada059b109 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1456,12 +1456,15 @@ static int bch2_alloc_write_key(struct btree_trans *trans,
 	a->v = new;
 
 	/*
-	 * The trigger normally makes sure this is set, but we're not running
+	 * The trigger normally makes sure these are set, but we're not running
 	 * triggers:
 	 */
 	if (a->v.data_type == BCH_DATA_cached && !a->v.io_time[READ])
 		a->v.io_time[READ] = max_t(u64, 1, atomic64_read(&c->io_clock[READ].now));
 
+	a->v.fragmentation_lru = alloc_lru_idx_fragmentation(a->v,
+						bch_dev_bkey_exists(c, a->k.p.inode));
+
 	ret = bch2_trans_update(trans, iter, &a->k_i, BTREE_TRIGGER_NORUN);
 fsck_err:
 	return ret;
-- 
2.43.0

