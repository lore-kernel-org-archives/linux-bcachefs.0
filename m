Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E8A1DFD9F;
	Wed, 29 Jan 2025 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171073; cv=none; b=EXYh0oBvbtLvlUqNP0VAaXMAYIraD8a3JPytxjYBUOAlbiSUay2PhMjtFFBVUfotJigtuunERhGFy2po4oqqXhjOFVdlxAGaz4w746/psHnXZDtsHSl+/0N7PFpD+/EoPTsIAwjYmZBLn08LrWghh7VV4Mkf9VhAj/qYyDrBClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171073; c=relaxed/simple;
	bh=Kb9504XGcrhZALjT/JOZ3AgKPjiRLNh49A9yuWItZgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H8W4NhpxQd4bKttKxqQ/JoEXpXoJYsIZPbFtign0Z1MheOT3Ot9rRH00j5PZZUNylkUL04sIBDLP0Sc33our1+p0BxJGWVTwY9dPvRU2JI/puYOS21ppdJZyyfXufAQyZzIqTLzj93HPw5SWdKZmgi03Gyg0GKxkSMHUR8DZf44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IDgot2Ae; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDgot2Ae"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2164b1f05caso125924805ad.3;
        Wed, 29 Jan 2025 09:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738171071; x=1738775871; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ysALLT3zs/nDSBQMpX6MEeoJXz2QHGsX70BfbdmO4I=;
        b=IDgot2AedT+Svoygv8BpSK32EBb5k6KwLIikdBYKzsczzw2BiAonq+PHAKLeMrH/NR
         uNbgvBf+cOn0lHaORU5T2AmHLabs4oKItHfzev2OYMyyMsp2okM5TclHTK9j6CCr44tj
         XCrWN2KE0AI82XDSV8seRAR73R/EMKvyGA55yRomvggc9TTSWcwf2ZmjNPs48782CWt1
         AkHGW99ls90dx4U1dODXJTiWRElWfJxNcBgsnES0AcSAyatOp4MfnjKU2cZG4gK3KhON
         UJ2ErCANJ4Ymk43V+fLzt5bXtGNkI8Pcw6/KwGRWd167mthQap+4ycNuYI5Lhf41V2JT
         hYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171071; x=1738775871;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ysALLT3zs/nDSBQMpX6MEeoJXz2QHGsX70BfbdmO4I=;
        b=EH8WHOMSfOC9GjLOTgeoMOx45SUneNcNLpkzdodcMCM/Amrkos4W7CmEG5epyCWta5
         beb2dWK2VoHSmlncVuCcF79YYnsZXSAfntKHMbRUfu12Xr0Vli8jCyJTH27s0h8E5MoF
         eqcXKYGx1MtL4vLKf4bAq2XGz8LzROzVOJnfXCBKvDeDlw16lVtiKxRBLD0X0mCDjoDy
         DXIbqbfc8ZnzdlE2v0i1Zndq0iiFFikjL68SfgOD4kCQx4A3y8XcVcgFEt9ehD/lFe3h
         qG6BkpdetzIhsFVVObhgGQJupw8aOzRBh+uc/MEA0ByHwUD/zNmFWJsE142GV1zvpfkb
         LhLg==
X-Forwarded-Encrypted: i=1; AJvYcCW0loVt+TsDpUPNpIZ3fGKDhSi9LmavEBuCDITwyhEx+Glt17EL8dxZKUbkdUsUC0utrj+SWyCEytGQUO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVRUJ44nKsQN58lp1eH1KiCnSi5p8/kvhIwkCwEBr+oojl7k6V
	NPuYLv2ikYW7/+8XZMzbaubk2NIH48f4M86/13XNasriTsAF/WOP
X-Gm-Gg: ASbGnctTQkMSNlE3MCfGo1bc0c7MynblFDXtpY4fLGYSbzD83OVLYYcSh9rt6tU+dbY
	y+6s1u60OhbEriO1LiiWMggIwBLHMfQaUaadhEwvS3bjsdxP0MrWTJ4llx6wtbOjVTGsfHJ7yYK
	pDHhRzkE2pzQhzUx9ItCoodbo+3273ZnR2sukX297TO0MIdDhporJ4KFP1vSD4VyzGcEiLmWRnc
	Sqmt2d2qkFJWtlwVR31+yN8iu15xAjVuG5CifOE50whz5cu4xwBvi0mbYItGGwS7lAKNGVT0jD5
	7/eQwmybkFj74P4o61yoTzFq94p06T4yf4VDhJgu
X-Google-Smtp-Source: AGHT+IFuc4q+7u8v3i1XrM6jynk7QfEvVu80FDt6AICDqlBo88aeLH58X1OizrPW3eZoS0reAoxG2A==
X-Received: by 2002:a17:903:120a:b0:215:9894:5670 with SMTP id d9443c01a7336-21dd7c57b6fmr54776765ad.16.1738171071353;
        Wed, 29 Jan 2025 09:17:51 -0800 (PST)
Received: from localhost.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424e832sm103324805ad.252.2025.01.29.09.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 09:17:51 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH] bcachefs: fix deadlock in journal_entry_open()
Date: Thu, 30 Jan 2025 02:17:44 +0900
Message-ID: <20250129171744.132477-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the previous commit b3d82c2f2761, code was added to prevent journal sequence
overflow. Among them, the code added to journal_entry_open() uses the
bch2_fs_fatal_err_on() function to handle errors.

However, __journal_res_get() , which calls journal_entry_open() , calls
journal_entry_open() while holding journal->lock , but bch2_fs_fatal_err_on()
internally tries to acquire journal->lock , which results in a deadlock.

Therefore, we need to use bch_err() instead of bch2_fs_fatal_err_on() to
prevent deadlock.

Fixes: b3d82c2f2761 ("bcachefs: Guard against journal seq overflow")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/journal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..38ba5ab785c3 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -382,9 +382,10 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
-	if (bch2_fs_fatal_err_on(journal_cur_seq(j) >= JOURNAL_SEQ_MAX,
-				 c, "cannot start: journal seq overflow"))
+	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
+		bch_err(c, "cannot start: journal seq overflow");
 		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+	}
 
 	BUG_ON(!j->cur_entry_sectors);
 
--
