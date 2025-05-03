Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26272269CE0
	for <linux-bcachefs@vger.kernel.org>; Sat,  3 May 2025 20:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746302629; cv=none; b=EW8fGP34knG1P52dqDEU2xPqTvtd3k3QMkha92xqio8W1ADeOliuCNi815EGfJO1OmAAPZp42MuwivoGCMlrb8M4uG5mtpAMm9AnIJceHSn/ZFq4RyKEBz9mu5tmXkl1FW4oTw/JH0I9M5tvloSb5pD+T3U1eucpt4WHMl2H2Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746302629; c=relaxed/simple;
	bh=blftWWxlZLYiL8GCqS6qFfyMkukgupeD15WpeBwDwEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EhdMiMAu4Z1AeE35jloGLHjRzW26JgsgDXsYEVYSK+YKh+ySRiwies2QE4P0XXKqhHz6Ad+xDMEOU+hR/ZlfEZXPmWhfZzne6zqqfRXpv95yDDiRHKU1EC2RnAAPpavkbAXJw6Ypnyrq3tLg93fT1pUHnSRrfiGSw/fnCwU7CBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BiWYK6Hn; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiWYK6Hn"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so2986818b3a.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 03 May 2025 13:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746302627; x=1746907427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y/aF6VgVDPi7PAA3gsvRqLyRMrrqOIj7Zh3Rlk90GHw=;
        b=BiWYK6HnL75xMd4Z6LbbQDNDqi3Lj8rovO42bwLX53Zn5D9MsBVy3u5PxaHe/OUQhz
         qm51Jp4SV2IPJDnBVG6iD8CpfRe33cnkS6vvvEBG8p4VuFEv4hOUhbhKhv4UTmz1kdlQ
         sNNQkEv587pTdM6aPtkTdZcI416NVPhEGUTQM1iTTKxqUiccOvdg9h+tgYdM3yZz/JrO
         j+kEbIpqPa7pd8LGMmMHJ9anmgTUVeMWtNPj/D+PiIF8L2z6V0sGhzCZCjZoG8GcV5lY
         Yc2eqUt9HL8WwUymXOzSKWk/8AXi1TPQLqsPQvViIx4TzR4/sU6tOIcWPYZFi+gVagmX
         Xiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746302627; x=1746907427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/aF6VgVDPi7PAA3gsvRqLyRMrrqOIj7Zh3Rlk90GHw=;
        b=k+MVeCPhlCXTs8lFX71gdYgeSWmnJeMSuGw4a24mR/KaW5Xkck5ABg9evB+S4vDTU5
         d+sbD7CZmx4JkzcDpq/I0OwiXgsElkI7jEsxmtNlOHzQ9/+5s/ZDFfTvOcaIOHqi7eki
         OQBCtHn+uTN4jOlo2bUCx3+G53XQne/rBaMMjhD6gKi1QSClSZwitDcPaGl2dTqY5zuy
         HeZXK15PaCR6VZLU5fd8kP76V3FD2G/Fck+acX44tz2zxUGjNzKSjVEa+ECYHpBLNUmT
         +4cHRLm12Sk0LfPAm0fGSgPeT8qsVKQ5tYglglDGNG+6gqWenO0Q++k9F0FM85MyTPVL
         u1KA==
X-Gm-Message-State: AOJu0Yy4UyOrVmXu+q+vJhzqnokbqT45+//CNVy7ArlZa0cpKpsByF87
	AXeBhlwQWy9ocdtqfOG9rC2SdJnT2W9OU8ULlJg2eXne2XcYApVFEbVlAg==
X-Gm-Gg: ASbGnctc0DJJCVgj0sVlaP7JbHnNNUCC1wI86DieJn7qMn3kyUppLGVouF1zkeTsbh4
	GbyQdV0iNleR1Nrn5F8PuCoAyUZdbuCgmkY6mnST2u7TlO53u3Z7kMQrsvafZo8WiHnF6jk2MCf
	kQZxDBv8IFEL3fJLGHo5S/gy9cPiatrhasoflK1UNoyt/UfPekoiFx/xae8BHAWscduuwVWN3tD
	DCKtQhAKXnremvbAB08C4D5VhBawshaDhqZKWaTQ/P2p+hCs6elougNsvn3pKeUUzVwMuu57MJw
	wcrQFDGjNPBKzo8=
X-Google-Smtp-Source: AGHT+IEvFMZwnvK8NQmTDX20C1SFA280BIJAu5OUjdHFc0aP4TNl+qhUhvBCHODqOrZY7o04HMcNuw==
X-Received: by 2002:a05:6a20:748e:b0:1f5:5aac:f345 with SMTP id adf61e73a8af0-20e07c0c00fmr5949361637.36.1746302627146;
        Sat, 03 May 2025 13:03:47 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c3da9dsm2815907a12.50.2025.05.03.13.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 13:03:46 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Fix inconsistent req->ec
Date: Sun,  4 May 2025 04:03:42 +0800
Message-ID: <20250503200342.251303-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is req->ec = erasure_code above.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/alloc_foreground.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index a0f92daa44cf..c17c5733526d 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -1255,6 +1255,9 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 	if (unlikely(ret))
 		return ret;
 
+	if (!IS_ENABLED(CONFIG_BCACHEFS_ERASURE_CODING))
+		erasure_code = false;
+
 	req->nr_replicas	= nr_replicas;
 	req->target		= target;
 	req->ec			= erasure_code;
@@ -1262,9 +1265,6 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 	req->flags		= flags;
 	req->devs_have		= devs_have;
 
-	if (!IS_ENABLED(CONFIG_BCACHEFS_ERASURE_CODING))
-		erasure_code = false;
-
 	BUG_ON(!nr_replicas || !nr_replicas_required);
 retry:
 	req->ptrs.nr		= 0;
-- 
2.48.1

