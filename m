Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDD6156F42
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507913; cv=none; b=COchnaTxjupddkVEkxQm4w8HZ1waqUvkLOX8JqyAmSbCQO/TyLL8CwTs5IWbXZd1zJxFe0oTGD7m4OxLPJ3qGgx5+BsEbY90Hoy6ohCy2iUMMsez/6pUAxbd/4psTxuDrlwUw0xqXP7kRwcgCxc1AqEFyGe2GUI2ODozyJg3OTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507913; c=relaxed/simple;
	bh=P1qjlgra+xKuf75uKY++0mLXCHBirUzdlkoC/xqdFlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=co4DExF2cxPzxydm0XDeaF4u//IAcYPmB/7Mt4M3WHz9gkndOjP9FGDysjMvBq/Cw4YhIynC72p/gJw+Zib7GkSWwTsyzUpEJdTcfhmS6miees97ebhAPcQdZpKMnaQbKpDWRMGuTuoY+lhX2spmwJqVkspSy9PvRahsDngz14Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=a9ThtCyY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="a9ThtCyY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4281da2cdaeso4579825e9.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 06:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724507909; x=1725112709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VRYjLQs0r26czWvaNx2T4sLxT7Rxn58hBdTuSAcDUEE=;
        b=a9ThtCyYkCv+Ath02d6XsiNSHQdeSZ8JcuH14czfAYVO05Dxj4IMNLRfx+8ZMsGnyB
         ddyaz/OG10wxpTGsqOnOh6pdi+TWZENkXqfSKcv2vVA8wjUwAhcYAUDE6fKTSaYMfuRG
         BXxhJFH+vkddEDkhk4+91nWBhmtIcD9UKfXs0TgvPt+hkpAoQvqsP+y7pDLrUzjQ8yI1
         vnFm6GArUUv436DIOdSzMog0shAwQq2CvF04c5VhLpCzQtN2sXnY/oSuWHdf7+FrB2lU
         JXa1S0/i82hWRwYMILo7+3Nw06Ab1OARkyLIRm9E5fzQP2PtLVxxtyx/gXAwoxFcd/zn
         Whbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724507909; x=1725112709;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VRYjLQs0r26czWvaNx2T4sLxT7Rxn58hBdTuSAcDUEE=;
        b=V36z2kWz6ohMwaeEmAXCypcW5oVSTlfFfeGa2h2+6DoqW8tn3RoL2qVascew/Pcp1O
         tCZ3n1nNWpXgGdbtlxSOfKnA3KuJecmSj5mxXwlNPpT59e/hh0hKNA5FLZWn9w4FvuTA
         XMci32Iw/0hwnKyiVOUYH+BjBEt+hidTOxId2QEhPZuDVJB3T1MLhVfwoz2K4XTk+pG8
         ySlVj2fJGpNIRI05nPISP/W/L0L9/5V11lAib4+Jnqdr5w2LYJ9Y8sDdvW84scmecuyI
         7IZzUEBGF7LQYbbEwWRhb9XLpGOorBJLUU3g0qlnqIoF9lov33vjjknuAuoi/y/P5wKm
         FrhA==
X-Gm-Message-State: AOJu0YzOfK7GZxFCvPqqiFZ+deU8lQTXmsp7D/dSZiS0qzsnSMdI3RAG
	1bvWrJjfXW1sbRHegoOm0HBK1dXeGV6zcsbwOI12iyM08thTbqcT83/rdtUawZU=
X-Google-Smtp-Source: AGHT+IHrCGLci+4IDEpg/zrkzk9St5ONWrFr4kGJ5L2dzDRmvf2ZTLHku/dUdt5itzrehd3Jbt/Azg==
X-Received: by 2002:a05:6000:402a:b0:367:95e3:e4c6 with SMTP id ffacd0b85a97d-373118310a2mr1933615f8f.1.1724507908944;
        Sat, 24 Aug 2024 06:58:28 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f48a5ffsm407956166b.177.2024.08.24.06.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 06:58:28 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] bcachefs: Annotate struct bch_xattr with __counted_by()
Date: Sat, 24 Aug 2024 15:57:41 +0200
Message-ID: <20240824135740.1971-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __counted_by compiler attribute to the flexible array member
x_name to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
CONFIG_FORTIFY_SOURCE.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/bcachefs/xattr_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
index e9f810539552..c7916011ef34 100644
--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -13,7 +13,7 @@ struct bch_xattr {
 	__u8			x_type;
 	__u8			x_name_len;
 	__le16			x_val_len;
-	__u8			x_name[];
+	__u8			x_name[] __counted_by(x_name_len);
 } __packed __aligned(8);
 
 #endif /* _BCACHEFS_XATTR_FORMAT_H */
-- 
2.46.0

