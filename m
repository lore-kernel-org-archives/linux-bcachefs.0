Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C78B1C1F22;
	Thu,  1 May 2025 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746125483; cv=none; b=ijevh4BHjqkJrGFuixpxMEBMcWMI9thlIgAb+HAdjYbB+dHiPuMqKNSGHLn131doJBBy1CPuYRtsOfGVpWZurL/ZqpDbR197c5EiQrTRN/CVmnHRMVZRg6Bj3QS+MqVknfmWYV87SIn82XFsCt5VvaL37++H5WJ0pGS6zESFFjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746125483; c=relaxed/simple;
	bh=6gRcyNHk64PumuShLJ8Il2hhUSHeclMY/gCaLXy+GAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kqimdC8ra+YvndhH69+Eu+YoW+Zhm+hEXVXnrCU6OFL8j0HQr9SlBCeQV+ZkjD4jSfn8TBx0TzGteDTV9I1K+T1PeL6XlNPslYkSXGJJ0Dwu9RvkDpmYyw0drkxkRRMx4YPcfq9/Iat4d5BKNu44H4sWON70WDKyBYQfwMdK1xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BEPf70gB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEPf70gB"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2295d78b433so13360685ad.2;
        Thu, 01 May 2025 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746125481; x=1746730281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMW6rmPqSBgdYgg7Z4ow8CJ0aB7pperm76bUX4QNeAA=;
        b=BEPf70gBkzaWtYbacyBDnYiYtWBHNNyYyPIGDCe2zb9JFQTFTL9phKQM8O8O3/4Z97
         IGwJ7DI2LFBhxbqsYncwucXvp/SgJPhB0adn5xM5riIbh/uO7lzlDLnRPPAz+lYhgkpI
         2VCH0wZ1pmMe3ywlmaSKcNHxx4VZF4tAe/u+69EiwTfiiNJIANz2ReWfeLkb4TJzYyTl
         yuuKGQGln9Ei3xRTUCJqu3auepVp/WIsbeABZ1clBQ+lYist+a241YcLZ5cbFdP+hnYh
         nIYd6MSQiMINcpECkRz0EgxEY+NcAL6R046tT47uXQjBfZNlABjFGrcvS2dG29M9mlI2
         F60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746125481; x=1746730281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZMW6rmPqSBgdYgg7Z4ow8CJ0aB7pperm76bUX4QNeAA=;
        b=NGdEBlA2+3i6i2TxOz8KMp018pNZGJeq6fb7hyWvjqxoa1ZQlcD9VCrDFVRypQANZ5
         HSn4E8BxEC/SFpoanMHyVWULg6wKnZQsHRcnI/kQJIZlGHXpaqyTXuQP56lAYUM++jJG
         lV5Lma5d58WflhlWv2K+Jmp2MIkIh+Qyuici1HNVB5fBFwR8rZDxA4ufbSqNB/9EJZdz
         OiNoobu2SAHQSRdKUGULNvc/SROzH9JNxGlXbB6d+bpWObEEwq0NtVpxOEFB8U37MnFQ
         jNs37Hp1LIV9Q6alPfIyWFZGbD7DCx/zy7zHnelP7yksnPL3c4cCXo3+5tDsCzVSUCtW
         bnMg==
X-Forwarded-Encrypted: i=1; AJvYcCVP5r3HtHuI7CL9J4FAosXKfA6RYCsukeZgXrog54s4zp6QhLgnyTiHu7LOwknOXunQzGFevN4uTNWwFBvTwbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUnnZJ82cvQgmkJHj6Qilv7m9x+SsKWyZuNmAe667ZFy7EUFrW
	+Xq0kLp8JAPtdOJvRtqz3faPZATyh/HGtvZA5IvzNGHXEPbozkK/
X-Gm-Gg: ASbGncvt668BiX2XrDvfqGK3u0h/Fyz7NWH0uwvUJpWJKuxmEN2iN6aLldBGslqTSM9
	v3TMqcxmRKLuFNIR/yairBAV+ZwEOgeY5XqEAnZWweFv45afXL6u4YO5cNGebpl0VfL6ic4hSOg
	/xVXu2DFYoT4D1w6N1l+nt2erEd2GK1TtEcxtMAl2yYf/nKqo4Sqb1lZcbivhXXaqAh7QJpOm0K
	VN5MZRYSjcKrXc1hXT32K4TSTHqVGJbsYbGwmST2m1GU/zH/K21+kdlvWXHxBIq4lk9Pd+Lprq1
	3GY4uJXIoIlLWYE=
X-Google-Smtp-Source: AGHT+IEDcSwQW/5D0bNAOG56F7JSnukAIG6jaCa7FEoXWf76ibJFZY+TL6p4tocZh+iX23wH4x1+jg==
X-Received: by 2002:a17:903:40c7:b0:224:1c95:451e with SMTP id d9443c01a7336-22e10382e8emr1596455ad.33.1746125480493;
        Thu, 01 May 2025 11:51:20 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bb0de14sm10253135ad.81.2025.05.01.11.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:51:20 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	thorsten.blum@toblux.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Add a comment to clarify the removal of __counted_by
Date: Fri,  2 May 2025 02:51:08 +0800
Message-ID: <20250501185108.203158-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/xattr_format.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
index e9f810539552..8fe0bb897038 100644
--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -13,6 +13,12 @@ struct bch_xattr {
 	__u8			x_type;
 	__u8			x_name_len;
 	__le16			x_val_len;
+	/*
+	 * Do not reintroduce __counted_by(x_name_len) here.
+	 * There is a value following x_name. __counted_by requires
+	 * that the flexible array member contains exactly the
+	 * amount of elements that are specified.
+	 */
 	__u8			x_name[];
 } __packed __aligned(8);
 
-- 
2.48.1

