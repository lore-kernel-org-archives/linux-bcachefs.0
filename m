Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5642459C6
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 19:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750792234; cv=none; b=h8LQolgv1bR+buRuZfModep7QfD4ZwseGmwYvg+nXIawX/fn6clxbN1zglg+a510aBY5nN0udl1MpBTQBrjmeIhQXnjnPufcQYQ4vXoFdw3TsUlwtG45nBuOSkHUygmVUOLtScyCM+q97AuEFCgOFQO6C7T2A5MuO17lRm/Sdm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750792234; c=relaxed/simple;
	bh=N7byZkID1P9Jn+P4Hz/ZYXwhizfYPw1nnMbT9Xrgn6A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=akCvTuabbaVT3neoeo0U50XCP8/CStuSPReQ0WgE24FEjuwL4Ds4HPXIU+wYkBNfl0avoWQUwFzfGrnPWglo6D8izIh3xgrIw4TvjeZ3NNadaDULpPBNB5mVQfQQicEZpp1qhhZtc2yBndPkznPOLOhsBC6iziXfzsgzuBNqa3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZyxmJvFL; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZyxmJvFL"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748d982e97cso4917025b3a.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 12:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750792232; x=1751397032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HdaMmM7kvanr85IUorZ4UqZ5xHEz5AP/b1720sdGFsE=;
        b=ZyxmJvFLdE4xMtQ/2FrIn74j7yVNCWuUeYartlD8VcoOZN5rYwHGBJAxYETIXEBHHn
         8rpCLV1b9SbYHvlQSySBY02W6Sjthe96/9QaxX4AgznywxVndwTIYxo4eYygmaH+q1ME
         zlD24geHLQgjP3LjZfuFTNxSIvpdqtzWFFDO6v4ChvraR4dgPWmWHrmhOAMow74WsVye
         FAY8TMceZ+gAsyXXvNUnHqjPaqgqfoFIrniT/DlilALmGKHiG9L2+kKu7S1CpRJIq4ry
         oVR4HZx1gNhk6HmMss5ORloZwKsj5ZzzzCeeFBgc4EsCrup5Bx5R7tusibO5dZ6j4/Qr
         /Tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750792232; x=1751397032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HdaMmM7kvanr85IUorZ4UqZ5xHEz5AP/b1720sdGFsE=;
        b=bbGcLpdO8E+8z3b3o2xDmUxGR/aoD8t1QhMutMENQiBslsX/4PacblgUM8sVXOR6nP
         4WMdzQ5UoYiLthLQmoD0ZEDd7I/CgtXFmOeq+Vj4yimIGQ1X7g4HOgNT6F9CvoNMOhwi
         4EYwxjHOaG5VXH6KkhndHcsiSWvCIvn5hGDdtX0i+8gQX53lkX9HeRF/Zx4qLh1ZB53F
         QhjyUBjMGgLonL0q+2jgCgv9O38ve/wDGm6EBtiNb6rEOv7um5dhGgbdQ9Ey2CfcLKFe
         QbfjIcuAm9z33O6tqAdZJhE0c3coWhXNVLHgTryCFEKSmstfUzkMcuEIWvXQuO82y1Xh
         Lu1g==
X-Gm-Message-State: AOJu0YwcV6SD6AlmrJAmFA+hAeZzZusbAcVvPPFxAn6kP9nQvg0j5+D8
	H/o2wrm6cL+Q1QY6mnHzthRMtyJ18i9c8PAZuW3yGkeSTJO/enMXtjHt
X-Gm-Gg: ASbGncv9yM7R5pPPZ9WwUb5Uzr8VBsfekGBzXE3vx+3Qj6His0ZSKoCjxbwPlfg771k
	t4uw53neCp2F1NrGwd+qLfSN5tcmvaP+/GjDwWZli5D0yC/T93NP0++Q/v/BXBpDdb2z0TvPAcZ
	cqoxrfuYlsdCfAqFZ3CDWoVVRFtOguZJYAGUPMA9WFL+VX0mF4kMbn2eCrWm9dUnbM8t62yao98
	v48D4M6aWyzagRppOAunAqMyTuFVlnc2mkEpcsqlBvfw1IYmrtXDxDX3ny3zKG7wcPkiTNmpAMp
	xxVSshrl7Ep70tTY72KDMN8RUa7NPsnqxg3K
X-Google-Smtp-Source: AGHT+IHxL7zc73UuWPli8uI/k+wXTxe8CuFG35PQv0z58J2kc0LaSrjSCfnhYz+CrBGnD9yjjuDKhQ==
X-Received: by 2002:a05:6a20:9189:b0:1f5:709d:e0c6 with SMTP id adf61e73a8af0-2207f351ebbmr131243637.42.1750792231812;
        Tue, 24 Jun 2025 12:10:31 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8850081sm2618855b3a.108.2025.06.24.12.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 12:10:31 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+d540192e763531d307ff@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Don't unlock the trans if ret doesn't match BCH_ERR_operation_blocked
Date: Wed, 25 Jun 2025 03:10:27 +0800
Message-ID: <20250624191027.1157638-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+d540192e763531d307ff@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_update_interior.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 7bf1bd6a6e92..553059b33bfd 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -1287,10 +1287,11 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 
 		do {
 			ret = bch2_btree_reserve_get(trans, as, nr_nodes, target, flags, &cl);
-
+			if (!bch2_err_matches(ret, BCH_ERR_operation_blocked))
+				break;
 			bch2_trans_unlock(trans);
 			bch2_wait_on_allocator(c, &cl);
-		} while (bch2_err_matches(ret, BCH_ERR_operation_blocked));
+		} while (1);
 	}
 
 	if (ret) {
-- 
2.48.1

