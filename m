Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EA919AD86
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 10:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744453257; cv=none; b=tSgJlpzU5rcKJZ0Tq+giERnOs4hANITBN9iBvezYwPaoHwXtqHKTlCZOILssSXtIH/NRW8iVuQEnQFtbzmFEzfi/u5uNK+4ViDE/cITwuN1Q+vM2jshTnJpLqFp3MVoOhOaqQW27YBqFsjJ+OY/EV+Zs1vor1S0q4mc0vKT1O5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744453257; c=relaxed/simple;
	bh=TiVUR9/wWAUtJv8jZpgIKcuqXizZ/3hxExgNWrER5m4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CZxf0ipNQ1sLYh8eduwiOi1huzDDFFAPphsNwCq+qQtO+B1sGN5VWptNngYnsEKXcW2HWcl5mnV+QLkJg3zuAv2Ktte1qCdoux4lqA9xFOwftl3dW9/mqd7FeUBve/4uLgX8Lilm77NaDyk1F3jBvPV+kRaUj4ct4+qnTUKIl5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KfRG9fUC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfRG9fUC"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-739be717eddso2177742b3a.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 03:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744453255; x=1745058055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gNYH4SZzHbZTF2ZrBaRDVyvEy1BtBa6/VZk8hi+ByJY=;
        b=KfRG9fUCbwwNgYnFFznYxEuoc9+8mPMqbaqFCkBlq4mrXtxLP7zchTjvLYxTSV05OA
         7BBFBvlBMyIOh0jngy/U7kT0xKJPVVZSeaIKdOPuAvHYUyskpzT7zKieJRSAkNThykpW
         lowt5EcbbHybkN/s5UjGybB6Qk7YwxtWgQa/EILM2s6UrXhepPyOS+4bKZu9hdrIyX2T
         XujUtpyyl6QTgMo6qKjy/egzECtQi4dSqIAcjUpyZbf0QL/94aOfVUFQywSVTVcwAKs0
         qKmUlDgz8k/TRAUH41aWFRStg1GU28MiS8cbR+usNDFnc/Ie2oIEWiS36VVCeSpLkzHK
         8sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744453255; x=1745058055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gNYH4SZzHbZTF2ZrBaRDVyvEy1BtBa6/VZk8hi+ByJY=;
        b=vLdqngB0Zg56w66wQzVuLcJvrL3p5mtBY72gti+EgJbUkh6KQuJ3GAsBj+r+lgageM
         6L3G+g8MMPbiQTi8gqWwlHO9S18E366+OhKw56gpf4aCtYIRTnng2ut3mqsPM4ArIsjk
         9fkbwZUvPPNOaafQisz6puuoM9shUshGGqiOWNpbZbLKR67M0quTbA+hMuec9AmL4zeD
         E5SOGomkHT44VSfuG3d+s6dckztNmn//1YiTlyUKtRLqBpvie1xDwvbBh4ezh5LNeD7d
         YBDxxF+pwHIO8isU2V+vzripUIkdcEeL14YCMtrtB8QJAUzWGvBZMeBHJCzcPAFvcGv+
         vxaA==
X-Gm-Message-State: AOJu0Yx+xENWgdlPjuWQkYG3sIGe/wcRQTES9qMygB2qeug5RGc/2RT+
	aoiIrmVQ6dhrySsnRUFkh0xIo/bAwjwkxAXKpMEimV8yNmZuEh+q
X-Gm-Gg: ASbGncvTIqeaYo9l7li5y6ds5kVfluj8l10eOfFvFD30FcE4/XRuajKm8HNt1LMG3wC
	MyOger0ROHYfRO1vcglaBtlykflkIV2ZL+wzg79qkm4RZuV21g/Jd5dz+gLIbTsas9aVQ0LK6/2
	orMI6ST82gx0Xx0dpuEz6gfRhghvkg5Xsdo4wseXERq2FhaT+MuNZTZhpOYmCUOQ7KNvmzEM2AU
	EuVbdm3ahsTxv8EajTRNrRlEg737DPLN/4ksYNxrYYfRjQr4vXkjt4BajYa3vhqW6xa/zvk+fI9
	ttYW4WV+bkC/rEA=
X-Google-Smtp-Source: AGHT+IEz40sv9ZeAMSvcqXREHnjklXyJNPWhpmc2uyKnElRI1UhrNyQSEHyq4zfVjxtJBF4PlgTZbg==
X-Received: by 2002:a05:6a00:1414:b0:736:51a6:78b1 with SMTP id d2e1a72fcca58-73bd1202fbbmr7201376b3a.11.1744453254558;
        Sat, 12 Apr 2025 03:20:54 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd22f0fb7sm3180463b3a.109.2025.04.12.03.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 03:20:53 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Add missing error handling
Date: Sat, 12 Apr 2025 18:20:49 +0800
Message-ID: <20250412102049.19199-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/recovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index d2b07f602da9..606d684e6f23 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1125,7 +1125,10 @@ int bch2_fs_initialize(struct bch_fs *c)
 	 * journal_res_get() will crash if called before this has
 	 * set up the journal.pin FIFO and journal.cur pointer:
 	 */
-	bch2_fs_journal_start(&c->journal, 1);
+	ret = bch2_fs_journal_start(&c->journal, 1);
+	if (ret)
+		goto err;
+
 	set_bit(BCH_FS_accounting_replay_done, &c->flags);
 	bch2_journal_set_replay_done(&c->journal);
 
-- 
2.48.1

