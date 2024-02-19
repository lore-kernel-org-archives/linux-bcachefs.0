Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0E82EB10
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708354218; cv=none; b=ef2XuWHpqi7hLG2vu71aXe23Nl0D0OFBwrt8Q7T+ug5aSxpwmVi6BkCe7XbjnosDI/jxGD3065Uqco0iRy4LMmRCoH1x4/x6AYBXnDzJ3em0GIZvHLiv+cdy3Fz/DXc0KaUAdadw9gef/KDhc5TSuoVxVp/SjmmfmsSysQBkVzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708354218; c=relaxed/simple;
	bh=Usx0jf2h7oZCbE4pMXPdh+3thSd+1+VMQYLGwBYAKcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bk529aYfWoZEam2YEH2nHDSRjUXhmCT4A4FhVHmEohRj5RF3bRbvT23GqwScVFozqEMt8HqvkMDKHWbQmzj5dNK+/emu3KOwXEdVyT1dimZ57454yckji1/3P71klvyjDYLZTaj+ptBMNifcQQt/lWn3TBKoKDdu0w0sb93SL1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz; spf=pass smtp.mailfrom=gluo.nz; dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b=W5L9AuVw; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gluo.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gluo.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gluo-nz.20230601.gappssmtp.com header.i=@gluo-nz.20230601.gappssmtp.com header.b="W5L9AuVw"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e1040455b5so1971220b3a.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Feb 2024 06:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gluo-nz.20230601.gappssmtp.com; s=20230601; t=1708354216; x=1708959016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kg6zpRpWZoKBsoGbbh2ezz4VKvOLmIRGdnKZk4yYNtE=;
        b=W5L9AuVw2cGhOsITpg7MKEU2ceCwyUG90Ug6tHqA19G5gphadezQeA4hj7kaZUdj8n
         FMclEvy25QpwNccmxF5yfMf8hnW3X2BAL8dhVVWkjp2PA2t3YU1jflriW76gbaoWqGaN
         TxO+65rfAibO62kP/nKAas8JmN7ZwqSNkMrz3XCOtvFTWwgfxce6q/i3nApQeBBbCC7j
         qyHlzkxvS16CFSD4iEiEpuPst0sTQAfC7XPfKIByuJzH1VXOuTvJR+apM+M4tnHLWqEO
         lHcmY7imeGXgtPUmiSqpXwqS83NB7QTMYG+rAhzj4l20tum1lpm5BgCnzY7Xvg9K/S7h
         qGPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708354216; x=1708959016;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kg6zpRpWZoKBsoGbbh2ezz4VKvOLmIRGdnKZk4yYNtE=;
        b=ugHbmAyjCMxNxfL2tICI8szh6dlLIz3ki2URsVungCWpBscienuyxZtKLk0GPkbbf/
         4FAza5J67E2owC/9mndWirLEcI6j8N7pRxL7pcraaxEEK0wFfb91AEWax2/eesPIjXeL
         9xgXt8pWM17y2FeQYSCi8zH/Dj3taH1iv6InELdAcnTG09bj+LIIFS9C+QvqoeIxoieq
         IDB5Tg1Mbifk5nqJJjjugaAGYsMIlu1Z9aVXmPHXCcl8E6MKCrkeSc6pDiRe/TKaND9/
         fRVapH9sYYdgsfGwXTjt4WjNhzagz3kx1QZvPwQrF2Xuc8PXJhkDn/VViqUBtnE4sWbL
         G1QQ==
X-Gm-Message-State: AOJu0YxPHN8Qffi+3j4/r4EscA0tUjI3J2ThM0KhxoSa8b1iMET0Cr2C
	wa6w5CTGzprk3+5+xzsWkr9N5g0oDxsq4Dr+csrUQsIGWKRnDVOOLy5XCAD1iCKYRpBQ0MJxkYN
	6
X-Google-Smtp-Source: AGHT+IFhToEJxgZmSndrzjogzBkKVlfit6GTd3W+TowCQI5Nl4xYX10ScYzoCmt2Cq8Mhy0TW1kMzA==
X-Received: by 2002:a05:6a21:3a82:b0:1a0:855e:3b1f with SMTP id zv2-20020a056a213a8200b001a0855e3b1fmr8414928pzb.17.1708354215711;
        Mon, 19 Feb 2024 06:50:15 -0800 (PST)
Received: from Purple-Sunrise.. (125-239-189-189-fibre.sparkbb.co.nz. [125.239.189.189])
        by smtp.gmail.com with ESMTPSA id e1-20020a63aa01000000b005c2420fb198sm4155101pgf.37.2024.02.19.06.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Feb 2024 06:50:15 -0800 (PST)
From: Daniel Hill <daniel@gluo.nz>
To: linux-bcachefs@vger.kernel.org
Cc: Daniel Hill <daniel@gluo.nz>
Subject: [PATCH 0/3] fragmention_lru validation and repair code
Date: Tue, 20 Feb 2024 03:49:14 +1300
Message-ID: <20240219145008.915291-1-daniel@gluo.nz>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Spotted bogus looking alloc entries that were also being incorrectly repaired.

Turns out bcachefs has no validation or repair code in the fragmentation portion
of the LRU btree.

I don't know how your perfectly rational mind missed some basic repair code Kent.

copygc_get_buckets() was taking a full 60s to finish, Not sure if this is the
issue, but it's a good start.

Now can you review this code like I asked you to on Tuesday? Mr "I look at your
code when you ask me to" Kent?

Daniel Hill (3):
  bcachefs: alloc_v4_invalid() now checks fragmenation for consistency
  bcachefs: update fragmenation_lru in alloc_write_key()
  bcachefs: add check for missing fragmentation in
    check_alloc_to_lru_ref()

 fs/bcachefs/alloc_background.c | 44 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/btree_gc.c         |  5 +++-
 fs/bcachefs/sb-errors_types.h  |  3 ++-
 3 files changed, 50 insertions(+), 2 deletions(-)

-- 
2.43.0

