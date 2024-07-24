Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ED0D520;
	Wed, 24 Jul 2024 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783384; cv=none; b=S+Z22M+gzeq9Dk1KGbIG+s0Yf4xpojVxFdVbkzPmHVr6JStjihxOdyZ1wNToLLm4IkTlsTWILwIJ88EHe4JcHFjV0Pk9MbUyifAQzv7p9K7XdaB/cMSHhM2i4WUmeNDngySUAcu3RfcWgVnBGqr+Dpuqu0G523sLDn5Br61NpEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783384; c=relaxed/simple;
	bh=P2ntP1z6uoOdPcioy1TYTfRWIH9IvmVmM6qCfNdvKOI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HB4ITdOYYdGek3L5ICAsq/ledB6lfFgjTlYqLpXfCxnAQ/R3FLP33fwNICUhAIEGWXp+Q0pwx1m2AIVYU2LIlty01hPgEs1VM2Z8vDPWPiCds+b+nX9Y6iZh9mP3sfs6V9UUNJ7BK89i2EvSHo8wv8nKcXIxiyYAPkaThVeBDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hw5uEVUL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hw5uEVUL"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c9e37bdd6fso3603541a91.3;
        Tue, 23 Jul 2024 18:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721783382; x=1722388182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DEnb1Rd6+nPGp0Qdwh5GBJadzoocNyT63TaycwfKsf4=;
        b=Hw5uEVUL0/FVde/b++U2yxVQ01rWnakE/8H8R2FB4KgTy47J2/Ezg/ItV59IFKHoXJ
         gEVvFo7OrAnF9095heBKlCBoKOWThjuGE1tC5vy/GZvxVZ7DSJxGLmDFoP6Ylij4uyQV
         VsEXWZyfYz4XhT/kgqeadtYbmELJb6tf1J9v6XwRD7lwXdQAMShiVQuR5dPJqrqiJv4x
         ho9R9uI/QJ/ssw6neRutjt9kMBY/AjuNTsvJNWJc8MrnglUBOwJk/kPT25UAGpLUdwtc
         n7O3UCI1DrRNaMXQN2F0gdKIA9+pSSD4WbXTWWuvdpiaTMY4qmPC4nPIrFFJ7Rca/ydI
         qwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783382; x=1722388182;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DEnb1Rd6+nPGp0Qdwh5GBJadzoocNyT63TaycwfKsf4=;
        b=rc8+9y5qhNnLiRpG/GPStk7gS+OfIbyR4oeSUIa7CdhajDrUzlAfBi09un3rbVpI0x
         oXa/urkPjPlax7qcpEOWz/ZHLDutp1pCYjaH9Od3aIFWvYObzwpIiIKb4z5pd6ZlMcF8
         tMBM85Z2nIPRnc7tyuQZ6l3gm4LKtIO30Ole/KIHz3TueydaSGsigsWjbWYSkI8xBteJ
         vvqi/I8NVqh3OLe5Hu9uQFRd7xuFaRrs0je28Prx2uhwl17aYd/qQ2VyEuPloYGdaNNz
         DvOSX17lteLxAN+Wvd9H7PjiQLfbQLOIYiMRiE3eZ2EY/jHXdhdHgu8tHQd9QNuldjzf
         G1Dw==
X-Forwarded-Encrypted: i=1; AJvYcCV0Y8Gnj2a6QM6ohg5thu+beD8866L/rwqhW7gOJQrN55eufxZlQy1E7OJEMdDh4gDb6ixcKXyjcSLntmCiitODfICkN2Pw8HD0/LRfNkU0AwSOmyMVrtAzGooL/5YSND0sGlaG5vnwcTfifzI=
X-Gm-Message-State: AOJu0YyZOPlB3cdQKLkOfUfBClmyBLjFc/HZ5xxR/PLMN+NNvX2QRcB+
	mb/guW7I/C4mFb1fSR33jZkDFyInc3DgqvqrdEU+QPPE63N+cktp
X-Google-Smtp-Source: AGHT+IE0pOKgD59p7pIwdGnInCrZKBsuHYIYUN/6DRHaLsILdRqXCj9sTsKm8wWuousYKS0DU00tew==
X-Received: by 2002:a17:90b:314a:b0:2c9:7fba:d88b with SMTP id 98e67ed59e1d1-2cd2740ff1cmr10793886a91.14.1721783382547;
        Tue, 23 Jul 2024 18:09:42 -0700 (PDT)
Received: from localhost.localdomain ([190.196.134.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cdb73ddb7dsm270665a91.24.2024.07.23.18.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 18:09:41 -0700 (PDT)
From: Camila Alvarez <cam.alvarez.i@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com,
	Camila Alvarez <cam.alvarez.i@gmail.com>
Subject: [PATCH] bcachefs: WARNING in bch2_trans_srcu_unlock
Date: Tue, 23 Jul 2024 21:08:00 -0400
Message-Id: <20240724010759.1631178-1-cam.alvarez.i@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bch2_extent_fallocate should not return -BCH_ERR_transaction_restart_nested when there are no buckets available.
Returning -BCH_ERR_transaction_restart_nested causes the sector allocation to retry even if there's no space available.

Reported-by: syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
---
 fs/bcachefs/io_misc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 82f9170dab3f..b5b92ef030df 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -90,8 +90,6 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 				opts.data_replicas,
 				opts.data_replicas,
 				BCH_WATERMARK_normal, 0, &cl, &wp);
-		if (bch2_err_matches(ret, BCH_ERR_operation_blocked))
-			ret = -BCH_ERR_transaction_restart_nested;
 		if (ret)
 			goto err;
 
-- 
2.34.1

