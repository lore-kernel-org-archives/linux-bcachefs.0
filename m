Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC6E26ADD;
	Thu,  1 May 2025 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746124917; cv=none; b=kw+QCDcZPixlrZH/0XFiBKYZLdEH1BzFeXAvYsiXsTqqa7S8AE9O0vYluHXNMd6mM4jqcehwTcboEDl5S5xA8xpJyrmDlq73AOBK9ACuUYBSR7jGD6tsw6UEB8FaQAZt6LEi7Phrrv6yS9H/E1IpqxDSZcHasCmeaFDqXYf9uvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746124917; c=relaxed/simple;
	bh=yShrmIa0hm4spkQmkFrPo0/Kk8dwsSmvCHWYMqRO/GM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YK5DcY9AWqXAV2JhPuN/8UZr1Ts+py/Ts4O6jD/m9qxY0PHAXUnLtJHgbCqLRq7Uhuu8FETr8gnqDyMiuMtG/Ps4FIqwRLdIMy9agmXEVQJwJE10PKYuDnI5IB9mythNzagt750Bjo4pi95VN/+JwhwwSDfnBFiTUralBHcsgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFqYWLgS; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFqYWLgS"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af9925bbeb7so979803a12.3;
        Thu, 01 May 2025 11:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746124915; x=1746729715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YhQT6dssDvXvtx3Tc+MsbRadwrkfsYHAfHw5r3hKG2I=;
        b=FFqYWLgSfOgB0Pmzm1u+avYlZBS/Bnb3KdskD4ksRokdiZM3i0ZV/pXVvMzs7g3zB9
         ZnR+VB6DEfZcFNHY46iCA6ill+LAa64jiOOUF0mIOB1VYeWb2BJCKuUneb8RmD8Zvf61
         YPtSQG0e2u/RsEz0NXQzD9P433wusOy4q1aaSTqY8oVmAgWmaSdHoW2d2gVzCPCtLzyQ
         VshtH9C0oYMUaS/i6ho5RP2airDgB+EvcQnG8N212j2R89Yw/6BsQJaBYlXDR8MGPq1f
         ZD60Kte0VVdhdVd0g24iwNzonK/VagDOkvcW6/hHSwsILR6cbBLhOpKo5xBNXBdKshAy
         02ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746124915; x=1746729715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YhQT6dssDvXvtx3Tc+MsbRadwrkfsYHAfHw5r3hKG2I=;
        b=ZN3S2xK9rjcHF8PQsMAR8uuiQFqXqtVk2b16PZhlqmMBXoS+Uw0K1IEcsJITh3z7Ev
         ozsSRVnwzCIpRUAkJa5sH3HUzg/MBubhlL8305fcvxPXwEEMyB3lb6OtaWNMDJn6Yp5E
         0E1XDIigsqmv8woBQo/3HsFiu5U3OkTaxpQ5+h/7v3HgEl7j+VY304zzgktQHA3i9Dhc
         2HSf9dtU0gvaRAXzDQd7l4xduMt8OoW3WO51xzXn8ZaSNpxyJW36w1X4cXkw93htHH7H
         rn3JjLH+bauhZR82wjXPhZ0rr8Z1K3XlGzvnS8mfuP7yQtoQpV8ziKAKZ034g2HuEY/g
         6lJg==
X-Forwarded-Encrypted: i=1; AJvYcCU/4hX+VD1G5Q7X71tcPYzQtFOdr1NIaGi6KQS6GShAv/hLsCDyrhTxVYicEGh/1+J3YXeYkatdKWB3kru2Q7Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFmvdfyY+P0kaWOybpHmVFAxvB2B1+TfPGY8cbrN+g0wGU10GE
	RKIAvP/Q1geCdgOaOtykbciCW2p7XRuuFVd8F5okVmJsy8ZOINDSQYjIvw==
X-Gm-Gg: ASbGncvq9aNUIUCZGpKtCvHeeyyIq5p6oDDRTCSB+noS0QzOegv4r0sgIJJo//uGoSA
	NhTQIQDpysTJr5yv4vwzt6YJ8ISiaFoSLUJP0RNJlOe19dVBbrifuDc8K01ETzxolv0SGF5LbLy
	UyE1M5kcsLdcMJJRMPRGqInirC9T+JLVQvOWa9l+nQTqOJbQL/ZEuIzAQVkyM9/5cI2+Fw85Mv2
	HUmbHbacSyCUWNAUepxAd4sXmvd4xOXJ9PAyjT0GQUJQ3hJDThhjcW59A+rHCugGpU5H2a5fVKJ
	2AlnDHrM0eb6ngc=
X-Google-Smtp-Source: AGHT+IGTlS1o7cSVp0+NIb/lhgi5mNKQpabZD2ouBQky20YAwQp9hQAV5+WaA2iE+4cr/KiChEMmPQ==
X-Received: by 2002:a05:6a20:12cd:b0:20a:4698:9d3 with SMTP id adf61e73a8af0-20cde56a5b2mr57919637.8.1746124915346;
        Thu, 01 May 2025 11:41:55 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404ef1933dsm1183487b3a.68.2025.05.01.11.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 11:41:54 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	thorsten.blum@toblux.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] Revert "bcachefs: Annotate struct bch_xattr with __counted_by()"
Date: Fri,  2 May 2025 02:41:50 +0800
Message-ID: <20250501184150.200319-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 86e92eeeb23741a072fe7532db663250ff2e726a.

After the x_name, there is a value. According to the disscussion[1],
__counted_by assumes that the flexible array member contains exactly
the amount of elements that are specified. Now there are users came across
buffer overflow caused by the __counted_by here[2], so revert that.

[1] https://lore.kernel.org/lkml/Zv8VDKWN1GzLRT-_@archlinux/T/#m0ce9541c5070146320efd4f928cc1ff8de69e9b2
[2] https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/xattr_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/xattr_format.h b/fs/bcachefs/xattr_format.h
index c7916011ef34..e9f810539552 100644
--- a/fs/bcachefs/xattr_format.h
+++ b/fs/bcachefs/xattr_format.h
@@ -13,7 +13,7 @@ struct bch_xattr {
 	__u8			x_type;
 	__u8			x_name_len;
 	__le16			x_val_len;
-	__u8			x_name[] __counted_by(x_name_len);
+	__u8			x_name[];
 } __packed __aligned(8);
 
 #endif /* _BCACHEFS_XATTR_FORMAT_H */
-- 
2.48.1

