Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE27F79FE;
	Sun, 10 Aug 2025 10:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754822837; cv=none; b=hHmq6zac12gT1CdeWu32CZja1sGz1uwBpwNT4xJYkz9Am0FxcN+Qb1thCSseb4cN8Y03dumwxR8P8+C2Cl2S204Ib5/cHX5OjTWo+OG6Z+IPB9EzKwlJty+dweDTEwVeTz2ZKCWNe+dLtPp2+Hc0hRaRJDGfoFb/Eafw6y1iySY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754822837; c=relaxed/simple;
	bh=nxaG1zwspR17PpSRctsHtA+r8+e7ahm88TtHx5G1y30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FM/cBvTN59xG3v+9Enflhgmr+91a0SxI3piDwGpaDjq7JumKFQJrM263ecXkx4grD3JaqmsHREDZ71gxJK5FTZ+8KKpFelVDc7WaJIAKjXjZWII+XZltLis/KUcTyf5T5+n1+HmWTwBD/N5/XluZvnUPYegAUOg8FZoKCzt8sKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSchYUs7; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSchYUs7"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b271f3ae786so2749510a12.3;
        Sun, 10 Aug 2025 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754822835; x=1755427635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aE0rp9G6z0AX5t6srN3jmjast9AHcG827GIfR2iMskE=;
        b=YSchYUs7S4V7IsgdTvG4VC4d986mNwse7L2uYAwlo8o+WmLK8EBf5Z4VF1RJ5leUMA
         tZL19os99ZnXEB6nxRla65PB6b/m96uAGnfb2hWv6wZ/Z7PSuF9liG84/DDqMFAI/VkR
         yrFRATiwKibIKeGEri1qLtOxcQSD8JG4p/t8b3CsMFnjeRAhqkk5mT2Y/cuysM1mNca8
         hMA+GBEhIzOHcfrm9+Q4FO3WxRYUyDH0y7Wa0sqtgl3BYmSUc0y/bP2gGO7BVZ7ziJfK
         6pq71oqndmYMq64hRZW0AoaZzXUrYXo2c8KevUMd/tUl68/df6F2p0uTz3gO4yG3gI0M
         Rkzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754822835; x=1755427635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aE0rp9G6z0AX5t6srN3jmjast9AHcG827GIfR2iMskE=;
        b=dau/B3FNag8MekoLApkMyAeGUhe08as0qvbP5N9EA6qXLTxlC1Sd5gQS2/U+h7W8OC
         2qEEp3yDB7MgfuTC+T3uLW3wA1Z3FxRkNfnD+g14RgfPPkQRZtelK+jqrRCYNiBl8MYa
         rAwnUXFMb1lkirr/flYAs3H8xW3dXWl1phlvYJB7oO9QMnDUPPyuNaO8Psc4B6xWE31C
         i9sUR/w5my0Ifqn4UGjmoiz99kLCXtzuEujpO8k6gB6nPC3mCZSZDozMSv4saMvpmasX
         MUjVGL3O5HELTuOrUEAv8FmF0Q9qAhH+BRBNPzw+86DHLMwxNtgYDDX4bxEIoGlsk+ZB
         2o8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUICt4fFoMKiB8xr7MD+ksXwm40NPzqvxZUGgFZFtkhpHFvkttuwYVtxLJHdvU4+mubKtnZg9XwzRdwJb7sxw==@vger.kernel.org, AJvYcCUNYlpMYFFahdni+4py08RDgDAzgD5y51F7QtrPD3F1xkLfUbOwQ1buMDOFF5lwUsYH09RKnNZxOYUziyBh@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0BvCbVOdObeFtyyHqi8CQK6Bj7iRrvIucbDmmCF0KUyttj9Yt
	ywewIk8HYG21erbAZ0O/LeN0wILdijW8eV+rxk7ujFVYkr4nDKPDhGPxcWZTqTSIplKEhg==
X-Gm-Gg: ASbGnctzrJB43ymqtncY02bA0TMKyF6OIGgEKpCJ++Ec5JqoOpLIRgGm5Jn3QrGLbF4
	Q2sWSayoOCJqpvwt/Gl1J0aK0cYBaQSPudIclEmj5NZp+IyhyH94dXRKZ/aF6c6dGwnjMvYUOt6
	rx2FVFCugiZ4v36DYU2WDeLluZ33LU2Qml2obeWC+RPbZZZ0LuZU4xGQBFF6cdPKvnhapl9qcpV
	ZgRHKV7kucr8uXbYd4e62gCjxVYRDYpcKYKc/XtB9mwzFOWIlhXi/2+9ilGOsV9EIOf6kv4W3VI
	WmKPEqLJQnN2kzea9A7JOjQwIZLLDJejysTUplGJLctVSwxzaEmGOl+PmI2gz83cbjyI2WBHK7A
	ZIiOi6p3+YzVnrczhmmqTbdy0gBn8CsURmvBr2cYwSKw=
X-Google-Smtp-Source: AGHT+IFfsYKCBdRC4wXmrwKLs5mBjgjgoUUK4akPCOJx0/1nLz3fwTx+LtyvZYi92z7Ecb8151LDBg==
X-Received: by 2002:a17:902:ec88:b0:240:981d:a4f5 with SMTP id d9443c01a7336-242c221dcf7mr140890085ad.42.1754822835003;
        Sun, 10 Aug 2025 03:47:15 -0700 (PDT)
Received: from kforge.gk.pfsense.com ([103.70.166.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2426dec66desm166431485ad.54.2025.08.10.03.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 03:47:14 -0700 (PDT)
From: Gopi Krishna Menon <krishnagopi487@gmail.com>
To: kent.overstreet@linux.dev
Cc: Gopi Krishna Menon <krishnagopi487@gmail.com>,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: [PATCH] docs: filesystems: bcachefs: Fix spelling mistake in idle_work page
Date: Sun, 10 Aug 2025 16:16:48 +0530
Message-ID: <20250810104654.90962-1-krishnagopi487@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Specifically, fix spelling mistake of "hierarchy"

Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>
---
 Documentation/filesystems/bcachefs/future/idle_work.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
index 59a332509dcd..f1202113dde0 100644
--- a/Documentation/filesystems/bcachefs/future/idle_work.rst
+++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
@@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want to be dribbling out
 background work while the system should be idle.
 
 The complicating factor is that there are a number of background tasks, which
-form a heirarchy (or a digraph, depending on how you divide it up) - one
+form a hierarchy (or a digraph, depending on how you divide it up) - one
 background task may generate work for another.
 
-Thus proper idle detection needs to model this heirarchy.
+Thus proper idle detection needs to model this hierarchy.
 
 - Foreground writes
 - Page cache writeback
@@ -51,7 +51,7 @@ IDLE REGIME
 When the system becomes idle, we should start flushing our pending work
 quicker so the system can go to sleep.
 
-Note that the definition of "idle" depends on where in the heirarchy a task
+Note that the definition of "idle" depends on where in the hierarchy a task
 is - a task should start flushing work more quickly when the task above it has
 stopped generating new work.
 
-- 
2.43.0

