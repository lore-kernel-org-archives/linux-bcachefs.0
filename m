Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C61FCD13
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737969170; cv=none; b=eO3W8XRUe/Es/BVtjAmd35+UodzfL35iqx3Wd15qoJzVEkyzpKCH6c41wE7kEgTQBTbagv+6fbzyz/lkD/nJ4bav//zAn1NE+V5FLN486b7HFAtKtjg3LTxcFmSNd3GHx22H0M19NvMQ0WwHatMCPJSP/lJihIIbI0cvyqyepps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737969170; c=relaxed/simple;
	bh=2sxYjLdoKh8Z/wWzyX2cCUQjaTeeF7MuRVHqqujaqkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iw0biG3vw7lSCPZHB1gleaJlB91tj0uciI2LWOiXhs6aeHulZiK/Nf22Zfty6o9vQKoD04J2oidfshiRX7XvzgAViR2kVNthFsoS3r+Lc6FlLC/C3lKYIz5oU/e4ZAp/Fr5uriu7weeGCDc/ZJhafutbjiCus9QcGemWp4Emc7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lDdlLLd2; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lDdlLLd2"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2f44353649aso5462134a91.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 01:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737969168; x=1738573968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=blJzl+SYqydu/EPL4zE3c0PbNWIXsERXIXUdLUWUeP0=;
        b=lDdlLLd2EBficCAP24+W74K6pMuxvo770bGR1JxRDy/8r4Hx+3aEc8XKO227Eh/SnF
         KP5zrKFtkk8hYi46IQu2+0XzlFm+22/e4mOUVvEuN1EmPfe1QRXfUZ58NeUMpILqjwXC
         ZVcM5by9f9jceelDk4Ktxwr6h0W7ZUvWpvjkcnqXiVcb7macTeQV/91ze1rjS6iIEqkW
         4WhcnBvuJKPcw34QiAZwZc88q8QTHuirpXl+2WrA3+bMHfA1m8g/OU9NbsucQmtcH7Oj
         dHTFfQnOvIisxjzzYWjj5Qn4FKVwHTrktkfB/UZh9YkkORNiEuVC1JgtUHh223ntUGf4
         UQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737969168; x=1738573968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=blJzl+SYqydu/EPL4zE3c0PbNWIXsERXIXUdLUWUeP0=;
        b=WPDG/gfXYdAu2g/70eKfVCmmiM/BzPthmZcY69mBJ9AMszeCHZ0gD7lShStxLCYdna
         TcNIioPanAjlt4IAtP/xCkLXJugkCP5nO1MJcYw4OX8JaggWtHkG434Hp81GGjWaSOBt
         dqMCR+q/d2pD+KcimR+Z/YImVNio3CEKXfxlSys8hQWVcEicfupUfg4y26lvgKFZAcOT
         cTYE21cHKGSMSSQsfB6d3CLFkEK9guzmhffWwqHser3JlifeoZIRGpmitTBCMjVR7oLm
         oe0bieDjZ5tJlyAzvCqd7ThlJrMWVQnQiZVb6364LCGWlddCB3rwLNukKqXUljDoPK+M
         GriQ==
X-Gm-Message-State: AOJu0YyPPMYkTnaEBi3z3GA8zHZFnvKUTdfHjHT5bwGxsRwnfA2IMtN4
	A+nn2GmytJ1a3hC28aSC0l8dpctivek0c0SG0lvTcS/YcIAxRXIQ
X-Gm-Gg: ASbGnctCMuDm5ZzvxtB80tWVKQWAy2MXupPwgLHqdC/6GvJN488QjPVrbX4BphJIleh
	o5WaZqXoy4krpiU7P61lbSdsX5iB6VmbFPxxJqNUV5pAtv/oVz/ApSiSRPoQJsc9tdOtK/Ql5Vo
	Dfb0dz5VKqdTLMQRlNNQ6+QEOSJWNbwVSfCGr+f0btD8EDPNiENEFi4bGpEwonJFe9hmRs1bpjj
	KKop4689b+cXpfDMnX8dsMt6/9HwxrRxREDWC8xnpunAiaTteH/x/w=
X-Google-Smtp-Source: AGHT+IFxYxRsUZEd8QmcjZvOGcETa9n5gao4rSa/0hbZh3rikVgrN+f8MlLJD8wNeDrxR6YYU4fo+g==
X-Received: by 2002:a17:90a:c883:b0:2ee:d824:b559 with SMTP id 98e67ed59e1d1-2f782d35addmr58395539a91.28.1737969168454;
        Mon, 27 Jan 2025 01:12:48 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffb1c2b3sm6593403a91.48.2025.01.27.01.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 01:12:47 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix subtraction underflow
Date: Mon, 27 Jan 2025 17:12:41 +0800
Message-ID: <20250127091241.470892-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ancestor is less than IS_ANCESTOR_BITMAP, we would get an incorrect
result.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/snapshot.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index c54091a28909..ede0b480e7d4 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -146,8 +146,9 @@ bool __bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
 		goto out;
 	}
 
-	while (id && id < ancestor - IS_ANCESTOR_BITMAP)
-		id = get_ancestor_below(t, id, ancestor);
+	if (likely(ancestor >= IS_ANCESTOR_BITMAP))
+		while (id && id < ancestor - IS_ANCESTOR_BITMAP)
+			id = get_ancestor_below(t, id, ancestor);
 
 	ret = id && id < ancestor
 		? test_ancestor_bitmap(t, id, ancestor)
-- 
2.47.0

