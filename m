Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87ED4A03;
	Mon, 30 Sep 2024 00:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727656746; cv=none; b=Cm1eFzyekXxubk4vPsOGMR+DziaN8hyr/n2BA7rJFc9/GLH5+oel7rjGa7seaBtjxs31day2xCpkQa94NSrpVwhZz47FyiH0cX9iSku5QoSoYmBJYtL0AULCU3+o2sI0RN5cWr+QdRMzBiEOIV5d37p+fH1roM2YieTq7vdqJPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727656746; c=relaxed/simple;
	bh=HCtkeCyZu35xdj0Vp2vqTQ3vFnF/BRpdgDnwcEOfwM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rgCvHCzJ6r9KV+q1iegc7aas+iKFjtVHb+VUrPiPF6CwicLSzLnmtKeEZmCn9kOzS8lGa7myATHaYR6s6wGWjsnfF2K/c9QWLI2neoHf/ETP4KmleVvMg2iZ+9t+A64BVElMxccKYtPWFwSWy778MHheWYoOFulJuZI95mYIOl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GHNnMiPJ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHNnMiPJ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b6458ee37so12381925ad.1;
        Sun, 29 Sep 2024 17:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727656744; x=1728261544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=AC6q3cn/ZfdsrxB8Q4a4Ps0lEMfVIUKSK6OJM8TJvSE=;
        b=GHNnMiPJ/j56CdPcpI5mFYFgp1Ep538USbPFydSKxDH2sBfGbvMEl2iaUQr9RkguPH
         f3aRlycqZaFzSynOTtlDrresFYBnUo3gQsQNaGDxnjqGT9gj5O4CKIa3N/GADEUTP1Rq
         6GMLr3URqnYr0+sv5ONbTO2bYsU75m7KSgQ80Bp9y32Q/Eicv/lMn2a5MxuJ9RNDWbtl
         E2Ss5oy7nYb9+6hLP3LlcqKFVI/PWHKGp75GbEFQISMRxW+i0g5owNKH3v2BV+/o/V6J
         H4457wBXWCPBvs8ZTRb5giEIrQV7/UYaUgt3eVKTZMwXRgh++9Po6AzYOz6bcWmMS8iS
         DVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727656744; x=1728261544;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AC6q3cn/ZfdsrxB8Q4a4Ps0lEMfVIUKSK6OJM8TJvSE=;
        b=BuoH5r87wYTkJNcAdLQM3H8v+FyGsrQXPfJZvik1coN8sIfIVKZ1D4UuVgSUkaNPiM
         HH1aZcTCiUvxEKp5GkJabRC/biBh03fSZ981ZyTmlha+GY8nySfpRXzNwsiTDt7mOb1d
         4WJ3nq7Ip3NP0N98SW3TRyK2H8DzcE+4aJ3zAwVisn7BStJxlzBwD3AmH5ynTb7zCNqZ
         mOAqS4uDOkCZ/RCq6PDgUaLURYHyCfUHnxsSvoGgB3V7e0+qjCf0IP/xTa1gUGalPwAq
         oePIOuokD+nrZwKgZmot0DnaTfXNJIYSgke+lxCLFh0va0IPCacq74iOAcOpRIUyebsD
         fR2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWnOqDqicUZUne5i6Md+GQ9d0ek3r664RtJjjm53H+EFh0YwJywNBOcIl+NV5gRQr9uaqEpBzzyftKAw5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzT3R9mje9GHW838kSoZf5Oa8cT6Lg4WJszLpfyWT8Qbrfybqf
	+4lRxDZ9WeRX+YMBhdiTidEbGagE5gSpdch5yS+O98O35//hw3mqK393Xg==
X-Google-Smtp-Source: AGHT+IF0uTDFwNsitqmA7OTJe0SwlHDLkv2Dw+SdEfHjUa/jVlhqE3Cm0lqyjhKyd+Ylenqo644OGA==
X-Received: by 2002:a17:903:1ca:b0:20b:4d9b:e4fe with SMTP id d9443c01a7336-20b4d9beaa6mr129532975ad.45.1727656744136;
        Sun, 29 Sep 2024 17:39:04 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e51dfesm44639395ad.260.2024.09.29.17.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2024 17:39:03 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] bcachefs: rename version -> bversion for big endian builds
Date: Sun, 29 Sep 2024 17:39:02 -0700
Message-ID: <20240930003902.4127294-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Builds on big endian systems fail as follows.

fs/bcachefs/bkey.h: In function 'bch2_bkey_format_add_key':
fs/bcachefs/bkey.h:557:41: error:
	'const struct bkey' has no member named 'bversion'

The original commit only renamed the variable for little endian builds.
Rename it for big endian builds as well to fix the problem.

Fixes: cf49f8a8c277 ("bcachefs: rename version -> bversion")
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 fs/bcachefs/bcachefs_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 203ee627cab5..84832c2d4df9 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -223,7 +223,7 @@ struct bkey {
 #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
 	struct bpos	p;
 	__u32		size;		/* extent size, in sectors */
-	struct bversion	version;
+	struct bversion	bversion;
 
 	__u8		pad[1];
 #endif
-- 
2.45.2

