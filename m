Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE582AD00
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754326893; cv=none; b=YkrMTsuJmNxbbmaxHGaEiBKZSrFR7JXW9AposfUbL2qPnmGe3e5k2ByHAlkc5GYQlTZYZQNaADIzYj5oC7C3K3Ulp9BFd0mcin0aM5Bg9cSISYN5HG1voeIDJCHN8Ym/Wh9fIOW3FsyHGtFTsNm8s9STuTMd+qWI1kaSdDGthDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754326893; c=relaxed/simple;
	bh=W/XPW2OwMy8Tt+jmZsnFbEo0hBPECHmN5j7UydI9Boo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMO22GhcERK8J3bnvdVo+dVlDza/WxqQAfDNN2+uH12mGxQPaANhTtTozTrCkbwYMp98liJSh2xtd75unD5BWel2cHvjejb1OdhG+dEnFFlF3stkXJuOquZ9USHduAPpS2ZlwmQucDrWzzORQCZlEIXr6OL9I5M+a9AOvjPT3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bOj4PecY; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bOj4PecY"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76bd2b11f80so3759656b3a.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 10:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754326892; x=1754931692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xGerJqR8r4XxafL6FfgS/g0H7nTCye4O6WJyI7yFdpE=;
        b=bOj4PecYjRdDW3Qf0TlBBZjRWsHSw1TnuEOBrLAD223f5SbFDeiwodK6nt8TwsV8rG
         EiyLMDCK0hDNd6MamydSVGAPZzxct2NDoSSpM76j1CbR/Cmbk9ukDP/8LVBpHlW/+9ke
         Zk4jNE9dypv2s7t+jkCATl8NBI5GtT1kZFY0yEfny0LrAf+YZTAEERibd0tCfBqpol9j
         +2j7vtw0SKgdw5oso2nBl4yG9Xt0IOa+ANxofZ+D/5e7DBRQ9N7jNMwMtI9mjG5kDU2P
         r9yFhZ/RzKe9UIL6sRii3PY9OwHpOPAu3du/utAL3SDUpW5HMc+1VXkyrn0dj6qYSe9J
         InYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754326892; x=1754931692;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xGerJqR8r4XxafL6FfgS/g0H7nTCye4O6WJyI7yFdpE=;
        b=KkW1Z3cGO82NkD+/aMiTlS7r4d8D0rKsz9DoOL5ofuSd5Gvmz1IJmRomhbKig0GtV8
         jpCqK7ZS5E+zXWMLxfF4V/14zvGs+YGrYFmbc9JWK8XBrkhPiQYGkAS9tS4hY2dKH/D/
         vDM/nxhFq4dgMvSOfGfFVdsmfaHiooVENqft1BJjbgM8daOv7CmKItRPymBN4SH4qGZD
         jvteB4q63WBs6ZQ/Co+YOx0m2KTZ8XFNBfBsYn+A+bIGYSCf6AvHZ/916y4NO+pssw5D
         XvEkK1dyG+bgyqBapL58c9ZNqL6aha9OeFMTHOjupWJJcmKQOllVkdi0dkcOOOT862oO
         AyIA==
X-Gm-Message-State: AOJu0Ywg+ftUiYfoTbnMac+ohn3Y8uZ+ZX7hL3nSWs4vtCNhxQV/brb5
	JvqRWAg9XVTu5sDmppI9dmiaQ/rAiieLP5rmi8WVrY5KVgFQXaZEMhHn
X-Gm-Gg: ASbGncvKaezvbGEqbwniP0W0+hnz/Cac++zEz3OsRKouPTUFF/FYWrQ328JxI5itRK/
	SHfLRZopMWjo7H+yKPaYz+3j99HZFG+GTMMb0RF7npaN52R5iMCQf2cRWjyvqju3/ODFcFL0+sg
	99PrkCYruJAlQNcOQwu1RLbAdhDxxrDSrvQgmb+YPzwNA5IoM6SaA3wwgOFPywqNP5N4y4IJCve
	n+Hdz4sG7JX/nYk6/kNX9B1VNPs6bBINCwIoQDxatoe6D29Iwd0vN8QxbB0jNZVJgzw9ouqOzlv
	6rgXO9wstPmv9JYrLy37wrPeSl/gz2QRpN7FEft/WkPlagOLDiwQTdC+E9BtiGg7cUlwkG820lO
	DdQW4ARM=
X-Google-Smtp-Source: AGHT+IGlLy1DM2WmwJFtP3oOq5g9XjQ9TWvyYg7vilytAv7twUh+7YawBkKK+gpTO0sJH41DbGqHcA==
X-Received: by 2002:a17:902:f684:b0:240:3ca6:184c with SMTP id d9443c01a7336-2428152f00emr27117615ad.48.1754326891491;
        Mon, 04 Aug 2025 10:01:31 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2426dec66desm32887475ad.54.2025.08.04.10.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 10:01:31 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Add missing else statement
Date: Tue,  5 Aug 2025 01:01:27 +0800
Message-ID: <20250804170127.255678-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The if condition was broken, ret was always assigned to BCH_ERR_fsck_delete_bkey

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/error.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/error.h b/fs/bcachefs/error.h
index 0c3c3a24fc6f..213814787dd6 100644
--- a/fs/bcachefs/error.h
+++ b/fs/bcachefs/error.h
@@ -173,7 +173,8 @@ do {									\
 	if (!bch2_err_matches(_ret, BCH_ERR_fsck_fix) &&		\
 	    !bch2_err_matches(_ret, BCH_ERR_fsck_ignore))		\
 		ret = _ret;						\
-	ret = bch_err_throw(c, fsck_delete_bkey);			\
+	else								\
+		ret = bch_err_throw(c, fsck_delete_bkey);		\
 	goto fsck_err;							\
 } while (0)
 
-- 
2.49.0

