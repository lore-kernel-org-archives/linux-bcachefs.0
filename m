Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714281A3167
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Aug 2025 14:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403281; cv=none; b=AZPCrBdl6Yf71T/6ysFtBs7OIPa2THVqipSo/4gy9YZm7Jb430gXhG1snf/lDSG0GI8h8D4vMzSvIoFjB12W0RNIDXTJCnylw3RLG4CKPKeSksxdfCv0jCYEP9tn0/X+abr2NywKlC5ojBTni+qL7QRrkDGJDObfpu6Q2GqnNA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403281; c=relaxed/simple;
	bh=IweutBmh5gVBrZQfgcIbHkVGFazlak2/zkFVmT40JAw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BrQnq73Ugzx3+5feqbXR0CUwjYvKuq2L6b2woHeXEl2/sl0h+G+DfW64V6Cia5qoDjenfQYsIPwzWS1L/VWjDkzWqfM9Mq2mqB/+onkGEvSHq4E/tNJFm9Yo+fsIZ7liVINr1CBXbYcrS1EJJFC6osJ+W3BPgrMuHRchrMSQzu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxZQwPVR; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxZQwPVR"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76bdea88e12so3671373b3a.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Aug 2025 07:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403280; x=1755008080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ESjAI6efAFp+1+f6a80JCm0iqBFwXPJg5xMU31ihg0=;
        b=lxZQwPVRVcqzxq3+fVxywu6ztqKmq0zW+JzdGtE1uo+x84c3lWK5X80PQFuXnCpjVq
         KP089sHzAE84G7t/rHOTnlXoDMYAlV/rlibC/eJ7lFSC75aCnEndPCGqDXm/qub7ZKit
         Uj1Ii4HPJjFgvFpZ26xwMu/G9Fedq3M0BjsZJVRRt/5FlePrJqTTaPHtM6C13Z5KzzRI
         Orr7TNfhEkjWdCbjtkjNk9HK5kMiKF1G977mhhEGbu8i+c1wc84WxfAZBvRYLEmHZKUS
         MycwMO2+GMUWKkUX5tm1ydnXPPm6hzeYHF15HFAvEQ5fIlPcDvp9jsHrH1vGlIfc7Np6
         Mitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403280; x=1755008080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ESjAI6efAFp+1+f6a80JCm0iqBFwXPJg5xMU31ihg0=;
        b=Nhf6u2Z8LMWTkwnzhKzMUj+yQqyIh/+S7rEY4iGXLOUUi7Ln/ucgYEfI7Qhp7rE6BU
         m9zeeqapGppgNUL84/STWnWNngeOTfVJNuB3UCf/ozXcpTPYUmJsHE42J9YbX2WN8TsK
         Yem1XtIIOx7ISVUEguhFCcFoGNp27/Y2BdarvErCWTjXJvgr4V5tnahcgiLUVnPP51Ts
         1LZTYsiqG0nhSQXDU/yexB7dOzG8DMnBloF42M2xqXnc4phgLz7HF/IISzyYbe5Oa59b
         /RNRDH3/DnjLfK302bIlnttPQFMFwYe0kwoOopi8yVUH1K74wLnpn13IEMYegDFnQ2Dm
         YvJg==
X-Gm-Message-State: AOJu0YwSULhVtzF2iQBCsYEf1DwHDIzYEImxGn5x0ofgor3OvkaJ+Kws
	ClPtuNU9kWVCS8iLDErgb1J/SpucEtX7/cg6Hjw8nkykYW9PmszZr4m9
X-Gm-Gg: ASbGncuXGas3nbYY48AIgf24oaZvDVqMZZLWkXZngixnpJBTorS8gsaQpamJyR/MQHe
	U7Ycc9auwcLn1e9vDFkUebqQ+kf5vZIInfepG0AgNwGGLomBIEhAdYMPzuAhLzpAk5GEjXmeqaC
	/GKrku/4WAq1o4+XFSCfUEazSUWdYdo5c2e9wCwZyPvyNUHFguZ48GFj9Jj4vujAJ6SWr4KrjbS
	YDDQVP331MdHacCAP6g0fiYJ4oIMFLktRsa24k0Olj0uRcSM3W8gzVJZw2Uv6jjMyfMh7gJ4HDg
	uwTbSBI4SomeRKQrI7W+7Y08+pOazq0KuZKC9wlRopEsfeiIVUg5iYRY1tzdHY4Jot9nQGVK
X-Google-Smtp-Source: AGHT+IFSEsRw+9QlVYFWJIVyIq5qyj7C7t8/biTjcWvm/NcGhvE0vzox+CpXuOkt6zszMq03sbD+wA==
X-Received: by 2002:a05:6a00:3914:b0:76b:c9b9:a11b with SMTP id d2e1a72fcca58-76bec30dab3mr19331238b3a.3.1754403279642;
        Tue, 05 Aug 2025 07:14:39 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bd6aacc4fsm12055476b3a.118.2025.08.05.07.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:14:39 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix readahead involved deadlock
Date: Tue,  5 Aug 2025 22:14:35 +0800
Message-ID: <20250805141435.432418-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

readahead first lock the folio, then invokes aops->readahead, which
locks the two state lock to block subsequent direct I/O. However,
direct IO or bchfs_fpunch first lock the two state lock to block
subsequent buffered I/O, and then lock the folio to invalidate or
truncate it. Therefore, there is a deadlock:

thread1			thread2
lock folio		bch2_pagecache_block_get
bch2_pagecache_add_get 	lock folio

Reported-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index c5ed62a11f23..ed8329c6c00d 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -290,7 +290,8 @@ void bch2_readahead(struct readahead_control *ractl)
 	 * scheduling.
 	 */
 	blk_start_plug(&plug);
-	bch2_pagecache_add_get(inode);
+	if (!bch2_pagecache_add_tryget(inode))
+		goto out;
 
 	struct btree_trans *trans = bch2_trans_get(c);
 	while ((folio = readpage_iter_peek(&readpages_iter))) {
@@ -317,6 +318,7 @@ void bch2_readahead(struct readahead_control *ractl)
 	bch2_trans_put(trans);
 
 	bch2_pagecache_add_put(inode);
+out:
 	blk_finish_plug(&plug);
 	darray_exit(&readpages_iter.folios);
 }
-- 
2.49.0

