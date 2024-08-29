Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CFC1487F1
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946684; cv=none; b=nxgQB2jhN2dYAkZXnEuASv+euHwHpPqico07Gzx+QmecZcqqBnR71L4oOCFuuOFvQi8X8u8K0+6LPSZ+deDLedMYk4FODmRimTuMQs3TDhX73ZLa5hDI0nTOYvdUHvo9a7bixqcX5gk/CYpyzfdTVWgrTlw8a9OaS/r7+PtIaV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946684; c=relaxed/simple;
	bh=nDu/Qung/abakY0tFCNkQeANmw4UpVnF+Ix+JtUHdCY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJAosV6Qof/FRlZkWOxFtSlxGBEjPq+/jVOoBrA1ubmyoGSrmOG8NgsON838PWZzyPF8k00PBnGOsV5OKiJI2cQPLN+SFwyroqrFyn5DPFDJ4cr5CqtF1Sxa3pzkFvoDbvyMZzeHPlmTaM+wt5vVvkj85S4P1FyOOgs9wxtJw30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=yTb/OPZQ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="yTb/OPZQ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5bece5b572eso112955a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 08:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724946680; x=1725551480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wo6F4DAHD7vgQXQVkup216t7O3I64JdYrUKFA8taWwo=;
        b=yTb/OPZQx3azJrRxWbt+GZ5PVpR5qAMb2CcLctm+T79XWMm7v1DzzfddyLZq4CbupS
         qKuk5fHI3MQuTJwJ0+FM0HX4F3+MJAOQi7NEkqUoOhwBF0jacn7knLnUfzF/ntxWirS6
         fTTsj9ecgheV4Wrfm6Buqr7KZH8jK7NpVXybixz68jlyELHpWdWao6+kvGNguHpmsb/m
         M85KtiVHzugaY6ZmQmqICp3nv/Enl3M75lBw9pk2GebH05A10S3x1sOyJTjtE7OwtKBk
         nZwg9pCk+XODwjVYC/z9AB5jIORwbStI6HyCHAN1AMggyYvOD4tgr9j4cXP090J9At6/
         BWug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724946680; x=1725551480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wo6F4DAHD7vgQXQVkup216t7O3I64JdYrUKFA8taWwo=;
        b=UJ8uuZSk6VLJWPuurKbKqq7vI7gHqVo4X5ayItUG/8osx8SrU2C5H3Og8GboHgcgOx
         W5pcpjfLA2HoGvqPnGkKOGHSE5Q5RAzTTlVn3xXQ2+CprgIYG/zXziVumvOoHOq15VZ2
         7If8m4p8uvTEU3hrPKABphMsZQFR4tg4IepaP5g72HItnIwY265QseL4rW9gHmgf+rRV
         MEDMEdnnCeCG0+wgVZUa14SWAnNL6R86/cXo6t7tRXzipxSxMg/ciBibX5Cj0j8AxPW9
         +5DAmF3HYxUKHwD9zsgKFDzg+Plb4qHZ7BHPjdRAjfu51K61xLyyX4VUCjGt36/Nz2xb
         bnAA==
X-Gm-Message-State: AOJu0Yz6DrFIaGjRnGJNwfbPZ8F6CmjK05XWJC7/NCs33QdtQ0bW475X
	4g0oiHeny26vCKoB2Wop5UQSU+GRjjC1vbtM7H1lL2ZitrA1KcV+4+f5wSkPzxljdOEQEnE/YHK
	2C/w=
X-Google-Smtp-Source: AGHT+IG7mYT+8MRbo4XobdrNXyXcPtZnp88K8wVmpVeqCVOOISsvXievrKS52UYHHKj057dSJAGNLQ==
X-Received: by 2002:a05:6402:26d4:b0:5a2:7cfe:2371 with SMTP id 4fb4d7f45d1cf-5c21ed8e6b1mr1903574a12.3.1724946680192;
        Thu, 29 Aug 2024 08:51:20 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89892223dbsm92288866b.202.2024.08.29.08.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 08:51:19 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Remove duplicate included headers
Date: Thu, 29 Aug 2024 17:49:50 +0200
Message-ID: <20240829154949.109402-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header files dirent_format.h and disk_groups_format.h are included
twice. Remove the redundant includes and the following warnings reported
by make includecheck:

  disk_groups_format.h is included more than once
  dirent_format.h is included more than once

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/bcachefs_format.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 14ce726bf5a3..b97fd0f75831 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -499,8 +499,6 @@ struct bch_sb_field {
 #include "disk_groups_format.h"
 #include "extents_format.h"
 #include "ec_format.h"
-#include "dirent_format.h"
-#include "disk_groups_format.h"
 #include "inode_format.h"
 #include "journal_seq_blacklist_format.h"
 #include "logged_ops_format.h"
-- 
2.46.0

