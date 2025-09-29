Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D44B625
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 08:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759133481; cv=none; b=qhsbCcm/6W652Q8PtrCvJC4x7NRHC/rCgWsyM6cEruDhzm7CJREs4bNKELs5QHGDO592POh03VRVr8tN8FU+wv9R2MFkmmZnsgZxfgadEgM478yoejftnLLsSy1kFiDOLgAQKempH6JxopKCw0VeQQP+a17sq9dlb4MPxAVRj6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759133481; c=relaxed/simple;
	bh=7qZskoFTAcc896x7pDEMBjGUIu8+uo07rVe2jac6zeA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=up11JH74eyPRjviilaXbyK0fwILa/74TzgmlwxB0m+l9RqyXqX5CC59fA4UCfT6XtvIU0jtYx7guLyyndDfDkJau0lm29A871TeRvMxuqzE9Vsn3bG6Bk8IoJ77p1cZ0bgzgITnOCrq0s3tXDVhdiojJ2GfD3TCdnoT9pf5oCJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzZKGgDH; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzZKGgDH"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b5a631b9c82so769457a12.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 01:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759133479; x=1759738279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yEDTck6Ih0LB4S3mK316czhYt6Y/6Luy06LhdwUneVs=;
        b=AzZKGgDHuGV/Cb+jVE2NF5LSjqzUTXtIEtIY7oVEORk/9kP5vP9QyFB5pL+9rDD9wv
         UbT+rgDiq3EuF4lJBtVWQzS5f2cGcwz6J5Xc8+fPNYD94aAq8f2O07Hj6mq8HOlLR76D
         RxMU4sFbl2QAz1SH4whasE20WAEEBdeM070QH7afBJxovlh4cvbSNtFMqEgqP1bNNcFP
         aX9j509FGhQiOzUHebD77T7jaBeaNgNIqiS0Wb1udvUq+kxgxKjUXiXLWBslZBe0BJLV
         zKrlR9ymqklArDKfC/1dhki+9XDfOrWp6/bhWNjwDydNJZ8u24BrhKrhtgb7sZ56znTJ
         ZdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759133479; x=1759738279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yEDTck6Ih0LB4S3mK316czhYt6Y/6Luy06LhdwUneVs=;
        b=aQHQV65jpKLFhDC54AJxAwJAATE36lbpsvkdn/vAvenAE71rqN2o3htTZygy0UOVHx
         MUy4fM2OZLm966Cwjia4g26NZtWAQV0tf4NrCzYUBlhvBa9nlG3HwH7fjORt3/pfxxRC
         YjEodsVFtuLeg0GccCa40fcnppVrJLt3L91VRysdUyNBqUnPERVt2IsC1h9MetOO+DIM
         +Qixxb6TcHa8HiQNK3lAgHSn6+/TqgombX3jd09czMllTwW8hN2RXx/X9p7xGmHZIQMa
         59jLKs8jO69XAPm72MAIGSocC35tlGiO7RFGW+SCFlAx/qGAJzxRAndbOutqjFJLirwb
         CKRQ==
X-Gm-Message-State: AOJu0YyZb4AcxtRrDnc4+7QFzzifqekyMaeSmLP/l+ri27xX6mwfj9t8
	nufAT08JuSocdRIs6NjBZkVsb2JM9M+KK/I2YNrKetqr5+14YwMQ6Vzq
X-Gm-Gg: ASbGncuSMa0G8OT3bXbKcga/8J62cPuLvlMb6p8GkiFsbbaLjhEICpaha460shQbz4M
	hUgnvualtWeV87CNPYy9+wOM1GedmU3DXEgwaSoisydJ3cQAyH4cL7v761YduIqdvOQO4XkmXK/
	/G0XFHQ6b/y9RBPJZuXl04WcZIBip1javV+njViZlDAXABozj0EUK7BE/DALBtnJKUHfxJtrdml
	PyIBewYadHJ3xRndy75bg7tAbTRKCUceFIlzhIP4EjWyxsMkb6hqL1dHrCcVSdcea/BdQmIbip9
	x0KrlyKV3LuJcHPjU1aj4tOsf40G7VwGX7z63b29fQMyrpY46sDb/O3YfZ5UlKxfOewjRri/jkE
	Z/FBgtT+G53qR4QG/ztXxEmB+e+o3G2GDA/xh7/os8N6P4kDy
X-Google-Smtp-Source: AGHT+IFbFtY6P6MLHr6AhqQIs9qRghu4g1lEqPTOpJqtgwSKotPoJnpXi9md1fO+Rhd39mfDohF1Xw==
X-Received: by 2002:a17:903:234f:b0:276:76e1:2e87 with SMTP id d9443c01a7336-27ed4a4979amr154539365ad.44.1759133478813;
        Mon, 29 Sep 2025 01:11:18 -0700 (PDT)
Received: from localhost.localdomain ([111.92.125.119])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed68821f8sm120319765ad.73.2025.09.29.01.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 01:11:18 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>,
	syzbot+7fb23a5461e8c9d38a3e@syzkaller.appspotmail.com
Subject: [PATCH RFC] bcachefs: Fix KMSAN uninit-value in __bch2_read_endio
Date: Mon, 29 Sep 2025 13:41:10 +0530
Message-ID: <20250929081110.11618-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KMSAN reported a use of uninitialized memory in __bch2_read_endio():

  BUG: KMSAN: uninit-value in __bch2_read_endio+0xb2a/0x2240
  fs/bcachefs/io_read.c:832
  ...
  Uninit was stored to memory at:
  poly1305_core_emit+0x46a/0x480 lib/crypto/poly1305-donna64.c:183
  ...
  __bch2_checksum_bio+0x1048/0x1130 fs/bcachefs/checksum.c:237

The local `digest` buffer in __bch2_checksum_bio() was left
uninitialized before being passed into Poly1305 routines, which
caused KMSAN to flag it as an uninitialized read.

Fix this by explicitly zero-initializing `digest`.

Reported-by: syzbot+7fb23a5461e8c9d38a3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7fb23a5461e8c9d38a3e
Fixes: 1c6fdbd8f246 ("bcachefs: Initial commit")
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 fs/bcachefs/checksum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index a6795e73f0b9..433ded62c77a 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -216,7 +216,7 @@ static struct bch_csum __bch2_checksum_bio(struct bch_fs *c, unsigned type,
 	case BCH_CSUM_chacha20_poly1305_80:
 	case BCH_CSUM_chacha20_poly1305_128: {
 		struct poly1305_desc_ctx dctx;
-		u8 digest[POLY1305_DIGEST_SIZE];
+		u8 digest[POLY1305_DIGEST_SIZE] = { 0 };
 		struct bch_csum ret = { 0 };
 
 		bch2_poly1305_init(&dctx, c, nonce);
-- 
2.43.0

