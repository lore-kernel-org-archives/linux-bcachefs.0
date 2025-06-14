Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389A72D9EC1
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749909312; cv=none; b=rxbLIwFQ8IxP9Cztih+THrPFiTGqpFzDF0brOB9Z2do7zvTr8FvNWVALPiaZTbYtSonHEIy1tL2ubaq6/92pyYGlNdWfj6dOPPCyCmF7+yZOEUZj9GB8iumsOqhXg9hiby9UhciPMVv1Ngj3HLHo2a7xSSHd0d4mcywSMi359wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749909312; c=relaxed/simple;
	bh=FDFPY220KDm7WhsXZNA0WoRHIctrtIpi18hcetjfun8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ej4uq6gAzpvzuXT16NJmYfN/BbrA46c5b/kvUn9hZjt8B7iYgnHeXdMX+o550hzNdgIAMyZQ+O3aOcXXROx8XrzZGvrcYmDIx0RnX0Nmq1HSgb3igI2pFX4QuMbV6UmdkV/rntLMgI7B46/ILqWD3O2PKxoHgTnEnliy44t66RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GP3oWEsR; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GP3oWEsR"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2fc93728b2so2501966a12.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 06:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749909309; x=1750514109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1OBX0rFV0uyIajOeXGO87AygQprGQJFx/WNnj8B3bdQ=;
        b=GP3oWEsRPJoRVrc37Uj+nINOE85t+AuHGrRB1/cGZf8flMI4N2j0BmT8aOV1nsWBYV
         HCfcnee37JtC386M5Pf9rzZOoHRwHDjq2/nOq1n6QQCPllzdMGOFwiSsX+lMnnVsX53z
         qBWyJ0dun33seDnQD/GW52/hVXMaSPDluo67hYwQWNc+oxyyb23DM914bT2OKM/zZ4lP
         ILKXxMZVMjftR+dSCmP5xNHjyOyeDCFT16nAOiZJ/j/jhyVFj04NVDW3SguwnHmqsnGZ
         y5ffCXlnz+Svo4qNsoW12OUKnJrEhK7Jbihv7XWKoTNxTSRpGRrhvCn9sdLRjpSxbH/L
         4Log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749909309; x=1750514109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1OBX0rFV0uyIajOeXGO87AygQprGQJFx/WNnj8B3bdQ=;
        b=PX6xd6gHdBFEgN+F4nnEon4oNKh/68ULfXldk4qoyHgFV/eRgi7U3Ilgp+aNRLswtJ
         nlL5gJ4ChLog5Nf8HVup2y+iklojljHMcBQuZXe0eH2cdDn2IifQawN8N5+HchK1m0+S
         4BJLo5Zg92eIilSQjNh9NR+eQt8YsKW1GuLXHAmMoYU96gmigSbrCpnKB7sA1QGd83O9
         lzkHfES0dnjW6UaTiUK7ZpsYXQulaI0+0I1kxHkZ9gWrhbEURNkTjAWFFlk1jdCmtoz2
         He/osjGGuBRLufakliFjVtfE1MNBscK9WpuoyU7QF8sTdit+sMOVVGCm/sNd9oKgYcwT
         nyyw==
X-Gm-Message-State: AOJu0YzAzOsoPB0qn5bPpVyy4lM7VfLDSNfj1RCHXNCaCvzBown+0C0H
	vXNG/I6jN5fD8X1uGmRv8SQMVmgosnmKPy77wU/MvUhPXK1ltKIQaLkU
X-Gm-Gg: ASbGncu7slZNA5WnPVc8zSqjdG6dC7Eh9MAT/ZRwbS7paUAnnUsQSQPh+GRx4Itaawr
	3OAUoRR+m47hiDVkyqNe3KZDtfAWicRrodqCNtRqUjFXFhs430rer9FmUM0WwzlcacXjQajpNd0
	8eOKczbfsBDwbeZeQ386GTb7hz3mcZNIbHaLYdhoCs8jTblNQyE86tvBM/9wdOeNOrev278jO9v
	pym4mMgZuTdfMaoC4Ite5GMj71eZlN2Qc/hnAShHb921BUW0MZZJqTm8GxOx1slGeoA70TLFpcu
	EFnkJ1PQhxf8K09TkT3ADA7dMCOZWCnXw+CA
X-Google-Smtp-Source: AGHT+IH/tS1ZXww9Fh77RK06zaufNHwiAFW2i8+bRI8nyQJX0PkoImZzGym6oOKG3nU4+GpHIChmSg==
X-Received: by 2002:a17:90a:e7c3:b0:313:27cc:69cd with SMTP id 98e67ed59e1d1-313f1c015e8mr5717708a91.12.1749909309433;
        Sat, 14 Jun 2025 06:55:09 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88bff1sm30634025ad.23.2025.06.14.06.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 06:55:08 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix pool->alloc NULL pointer dereference
Date: Sat, 14 Jun 2025 21:55:05 +0800
Message-ID: <20250614135505.406931-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btree_interior_update_pool has not been initialized before the
filesystem becomes read-write, thus mempool_alloc in bch2_btree_update_start
will trigger pool->alloc NULL pointer dereference in mempool_alloc_noprof

Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/chardev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index fde3c2380e28..ec8d0719a543 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -378,6 +378,9 @@ static long bch2_ioctl_data(struct bch_fs *c,
 	struct bch_data_ctx *ctx;
 	int ret;
 
+	if (!test_bit(BCH_FS_rw, &c->flags))
+		return -EINVAL;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-- 
2.48.1

