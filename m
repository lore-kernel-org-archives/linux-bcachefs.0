Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A82D29D3
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749754951; cv=none; b=HLNH6nPmMtpB3vX5508VGamkeOP/u5bEAeLkdIGvD6qOu0wqo72V5/y/AbGLMjJND1Y9D6+H7UBoQjBRWRTw1gcNnlEsVD5kFgDNL2mArGmrs/D5lZZdRVUD9XZo2bYd2UlO94kNMjc0+8/H4wvaoyvsoMDjvw3/+uWjPsyBTDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749754951; c=relaxed/simple;
	bh=i23awVWM2dPStF/qnoHpSeDSlPK7unBY9p3XBqyb2QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dziJcoCDoB3Y9AxHeWa++FKhqhXVYFYHkzglStAnJ6BgG0HDMTB7MQYGjZTkN+QY08oFZPbrZyOLOlJOAkQlhmrD5a49WsH0SqKLX68fBXYCdmN8RdjSOYenIQEFpqJ3m7sBCqDyU12BY8Ilnky+63amfb3RiwadFG9VlrQaSgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hReYnypO; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hReYnypO"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7485bcb8b7cso1268312b3a.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749754949; x=1750359749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Spd/L3xng2W4UWXV6uZFlJOZTbCXmm+/6fg3Wxvo/Q0=;
        b=hReYnypOext2M0sEb+GO6j5Pp0SQVMrezhqVBkcRQYqkS7gIpu7Tb5b2HV/qg2Qonc
         iAREdhzs+qSityKaq24xe3vvgWIt+XfHNfZvCdgCJzDZy5UsgpA7O3k0T5BvYg0hXIc3
         AcmVBG4Cq66yffE37fF3V22XF/7MFqiuWMPMS1XM/RCdNfqSSnlRTtsUgn0tI7DnCUm1
         g8Nxs/Dsff1hyCFYsNB81oblXzW3Gaq5AFlJlkZQJhdTZHNexvmSDWkLdoilbT61nojS
         /0+6F+S7sJKWaXNTqq1uNJkOkwK4Uv0y4TNdNpqMG4TmFOU+rumR88P3frVmUWutFrzf
         Fi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749754949; x=1750359749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Spd/L3xng2W4UWXV6uZFlJOZTbCXmm+/6fg3Wxvo/Q0=;
        b=Fj+raMf/lDBYZf1O0KIPs32c0WAhMAdklaNEg3kx9AuOyu2h5GTDD+y+FtCi7vgnvc
         CLcsR9XKadQWKzOYKeSVdpTB6GTaJmXsaOQxqWKPfe51JhMhbUzbnk3axtnKenEY2oMg
         ewX/9g7NWyK/obmcdLi8/Xgm1yXJHsMu/9gN0Y7M7kfYJV8t8dBHufswfAEegZ1FpN9D
         awf1GidEkWRHDJIPiyUVXO/KHLBWzZ1hr+ad+GexWBt4kzHpE/vGMB4vUfm3z8rta/u5
         mCiDiQzvSp/dXgJiLcm2RS3topiadfyQ73rE6CRXphWHyDrmYR3Q1Cyfw+uK9W6Zw6kM
         X29g==
X-Gm-Message-State: AOJu0Yw1Zve8Sd6HbsOSlC9gVuC4AB62OYD8N6MOGDuIjsro3A0IYsg+
	d5TrD9otHevWzVnVcP0tBSQf9B1e+N5FZBDrnUGyma+xjt8NZ+t/ZAwGPkLRyg==
X-Gm-Gg: ASbGncv8SP4r2iutQ0AXKYIF9fEMluhnkmSNFwPVsV0FxjGyuylCEvbhUOzKyVKn0JP
	tZj+1RooQaJhVKbg7BoKyEL5xiz9rlObSYs3GX9Cj1I0jTnbicjmh7+X1rGePp+2jkvEN6nnb+P
	uZeiNDlMp5XJBHg0yNziIfPj6beptU5n1ioIpAc+zK6/zxjfx2mBDTB/rIU8N7NR/YtstqRArfz
	SqhFP76Iv0zPAKuM3hEJ3WM2L0cp+4Xg7/5l+LMnJFkCU0yJblk3s/LW/3oDwmMOFVrPpZ+rQl2
	8ka725UCC9tvjOszNJE9l+CLCGBqzG0qXOLO
X-Google-Smtp-Source: AGHT+IEWK6lr27n5c+uXE7yAVMK6GjWiivyChC/IoekO0zjRUoor9LtPxo/fZTEedwsY9hYtmbc3Cg==
X-Received: by 2002:a05:6a00:2307:b0:742:a91d:b2f5 with SMTP id d2e1a72fcca58-7488f6facebmr495572b3a.13.1749754948916;
        Thu, 12 Jun 2025 12:02:28 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d0d9bsm56893b3a.157.2025.06.12.12.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 12:02:28 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Add missing EBUG_ON
Date: Fri, 13 Jun 2025 03:01:58 +0800
Message-ID: <20250612190159.331909-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just like the EBUG_ON in bch2_journal_add_entry().

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_trans_commit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index d9710801e3ee..55952143f0d3 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -757,6 +757,8 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 				  btree_trans_journal_entries_start(trans),
 				  trans->journal_entries.u64s);
 
+		EBUG_ON(trans->journal_res.u64s < trans->journal_entries.u64s);
+
 		trans->journal_res.offset	+= trans->journal_entries.u64s;
 		trans->journal_res.u64s		-= trans->journal_entries.u64s;
 
-- 
2.48.1

