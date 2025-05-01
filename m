Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE59F22FAC3;
	Thu,  1 May 2025 20:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746129700; cv=none; b=JIbGIqz+UAf9eXKkXFv+yY5/6HnvrqRiTWCUVyGCKhUZeKjTXdjqbn9OMx5AaFx5FkwqSthHTEGbabR0Ti9SKdryurf/W/oBxe+sZ4nR2VVSTUsyTL/C+aHCFfmtcqSO43N0XRz2YPvlGbD/hTO2rnahWR1D7BIC0WLYUPnBcYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746129700; c=relaxed/simple;
	bh=x3YycQWQyv8BCKwvYMiSm4HxiTbXQulpCjaqLWfQTV8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fjId3VjZBmm86h5X4w/gWnC4u89hQbouXFpYnsGgpt8aNAY9NhloNCXzzVxYY7+IdLn66clTqfS80I2BVO0mx+x0fIgo/yvxqA5v0CDqQcjs+pJ8MHdYvCi6YvpGw946JewN4rHMISRnDm9n3vesyxuFVuW3RZBxgAksQHnmXM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2hLeNnY; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2hLeNnY"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3014678689aso1180809a91.0;
        Thu, 01 May 2025 13:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746129698; x=1746734498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiVIR5FxtHGcAgaYf/KieeUEqu06YrV5F7oOS6efuU8=;
        b=K2hLeNnYqZyexMMsR/JnR2DjUitKEDRsPENUTXi4rg1KYTAhNcFajlraTOYzN/3W0+
         gy5QCuQc+VnmZhZqyCwugqZkE0WyVI/s2JTdpMbOi/zETu622ruCfXGDSO2/pnDhHU/R
         3B/u3p7G/p4FVRa0KnQcZ4iDeL/7UMO0cfNWF+763PvHzz3vA8UMY2zzBPSrJQkEVtPQ
         lJMamVMzb2dqXkLeeqeAz1XSiTLihKfXGfSOyS2yb4HejjxIkDRdtXGQA0HsIGSPzS+3
         Fyp/ZQpkFLMmdU+Qgy0TPkr3q4Hd4Cp5hXT37/L/YClBGR2RlQRme+lkLHWAUM8Cgq/R
         itwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746129698; x=1746734498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZiVIR5FxtHGcAgaYf/KieeUEqu06YrV5F7oOS6efuU8=;
        b=ce77LHFd9HlC6edcnrWxgtcoi3ElO31WZRdMEOTUj6QXJiK3/ciI3gK+l/iKKTymZk
         ONQyPuL4JTXQZAyYzWm/TM1hQxgmWZjjIbhpw65HhQWwuCPAnVN9+sDk1jqYeJcbISfB
         bbGfNBWMl7NtmJwKJfLmHHeiOAyqel0laRrcYt3d08esYtR58fUbPvRFI8D65PenJ8vw
         dxCwFJn98fli55Yr0pZ974K9RBfSd2dAJT450Ir+Y5BqODbjCun9hKGylQHTWSfw1Kcn
         pvp7Dg5h1OVCeATW2kJyKHX4JnthXVqBlH8q7Qw2i9zwePJfhs5sxpMVms8ptjahMpBP
         5b6g==
X-Forwarded-Encrypted: i=1; AJvYcCWA0S7QjhiMz3MMkhJIqRM9P3fmmIARaIXGRKZTFPGtel8ZhRjFwX/9vm+D6WcLZbdyGhBIlMBEIzHaeWfqtYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjYEF3QEX+ZMioKwprxWXcuNhKYRZ/C7GnVGa9DZl17zawjD6B
	0eqb9du4V2X7JlBzOqZttlMZRDaiaVU1zT4u00cj42QnKppATPer
X-Gm-Gg: ASbGncsEB4n8oir/lZigIrFKbTjJancDtTtq9GtwX7tx/U5IXOJqP/uh41TtgLW1ujm
	EQ0Qz7QQGXyBBrJ+ja7TVTIR3/fxI9SxgnGsDP+q+9KoGfai727eu0MPWovOg3UWt5GVCJBd+Wz
	mM48zgnHeDPPeG5byFDQVyz/k53o+sXQqQO411Sk9EOQMnLjfIA3goxlKEYWTexYo14BbDrDvgm
	14KZRXqiI6UGXU8PBfzc0ucyo8yKkdrtzjGBVACy0M7yirX5kH1OetuJa7DFiSdqQMstz9TcRKx
	NnOjob6kO+qY+LE=
X-Google-Smtp-Source: AGHT+IEDzioqerRGBgAfc8+IQ82FeVvLtCL6cROOuB8G9hlj9w5Um0Fj5p9o77ssGurYbjUCLGiZPg==
X-Received: by 2002:a17:90b:2641:b0:2ee:f80c:6889 with SMTP id 98e67ed59e1d1-30a4e68887cmr655473a91.33.1746129697969;
        Thu, 01 May 2025 13:01:37 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e108fb70csm209785ad.123.2025.05.01.13.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:01:37 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	thorsten.blum@toblux.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Remove incorrect __counted_by annotation
Date: Fri,  2 May 2025 04:01:31 +0800
Message-ID: <20250501200132.216859-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This actually reverts 86e92eeeb237 ("bcachefs: Annotate struct bch_xattr
with __counted_by()").

After the x_name, there is a value. According to the disscussion[1],
__counted_by assumes that the flexible array member contains exactly
the amount of elements that are specified. Now there are users came across
a false positive detection of an out of bounds write caused by
the __counted_by here[2], so revert that.

[1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
[2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/xattr_format.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
index c7916011ef34..67426e33d04e 100644
--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -13,7 +13,13 @@ struct bch_xattr {
 	__u8			x_type;
 	__u8			x_name_len;
 	__le16			x_val_len;
-	__u8			x_name[] __counted_by(x_name_len);
+	/*
+	 * x_name contains the name and value counted by
+	 * x_name_len + x_val_len. The introduction of
+	 * __counted_by(x_name_len) caused a false positive
+	 * detection of an out of bounds write.
+	 */
+	__u8			x_name[];
 } __packed __aligned(8);
 
 #endif /* _BCACHEFS_XATTR_FORMAT_H */
-- 
2.48.1

