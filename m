Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89521CFE6
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 16:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741366716; cv=none; b=CJdgf3PGr8TsY98yFUePFCRKolvyJASjIPRH9TwhmYzkG8q3utMUMTXMvyxUYsDUZ/YIiPyQQJu1J7nTJSsEbv+hggvouUpmafTYeK7IMqkSocQ/44JTUZ8YQV5JCTglK3evHFu6EsaINaDyQSV686uIoUJciNanKs22cjauBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741366716; c=relaxed/simple;
	bh=QTC7UiFvfB84Lguolal7VKlCr62MkRWXpqVGwM5+8oI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qmMuNUqDB48UgmmSVfuY7H+nrHIi9lWzVv2tKYa3yIPDQ6WQ1a3TjkWRPc5i5wFpqgQI9E6WxueMwyCnr8IU+WN8yGysdYYLHflvJ+xUlsiJeEpfK+oOf03XWfxw6MJ3QsWR6W8IlyA5flMZFtpZE+5F2JRPrUohOyBVcmZqOco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0hPqRbm; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0hPqRbm"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2235908a30aso11886455ad.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Mar 2025 08:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741366714; x=1741971514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bNenN4JYc3LKq+try+U1yhcWkpRqnYDThPVkI5YQHAc=;
        b=h0hPqRbm6GYpv+r0JmazhFgecp6BRR8dp7ZgDNeyki+tjS1S5g56T/nEuzcprl9jkp
         1aRiesBjgyvVX5ZId8GuYoL0NlDx3srPCNVTKbWh4LQ/79EKT8+qfEKJAQa1J54TrfOY
         D+B2ffLyNMbAlE8VRKanijub+Qv9lABDmVUYqT/7IZBQWqCUK1gHfbCDQ8JzF1X/da1e
         946iRFKrcC2oBqIeHA3GtYj/q08ppj9qcu1Xvv4xQGbmvrE5Nx33XhgDmE5NmIls0sc/
         U6pcALI8fDcns9854M1uTi861HaaLXsXRIU0AWC7nMx3Mmrw+FJOtaLbODIh7u3yPZ/Z
         ll7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741366714; x=1741971514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bNenN4JYc3LKq+try+U1yhcWkpRqnYDThPVkI5YQHAc=;
        b=Wfy/TXfDHkNARDuMUjWpoS4ZCF1p2uSmbpKuQuCwBNklOCvNao0PH3twpHLBMHGWvO
         NBnjRU9yszsKKnQ4DGMihNxS/Q9s2Uz2OFvQtEgZgGO8U34coIeJ1TkgAqnt9md2S75r
         w7KdcaZk5jS6Ec0ePIQDCPgKNBFyTjpA8qolN6NVKzndooDo7CAwNnwQSxiQLDhEbARJ
         3rBYPWzGY2pY+kdNP0bRVy92V+YjkJnmM+UWhP2YY6FEa5okFFUjsjiaNBThSIKtHBBr
         Foq99oXgo/T+6e8t/rnB1LQNGAmMWXr9B3HB1p7I8Ol6YvjO8LFEvwMPECDexoHXpVQF
         pFiw==
X-Gm-Message-State: AOJu0Yzb1/lpzi1pMumZHHimmSnYn2w09GGDIw3QsVS8Y4fGunUwtNb6
	rINi1L73mvl9L4iWJ0kyP1ZpAkxg/9mmYhPcR2/eCda/2fzpsuL9
X-Gm-Gg: ASbGncvNEqMUFb2n70vLy0nrC1eYcgek2kBZxzVHzhRP85zH82wmoC4q3Qn0q4p6pCO
	JhoAGFsEAg7PYsGCJoWhNlyZfxcZMDU8Pb4o3Lc2eftnQ/lZbpXOnHT2Da3gBswnE2sHRNh3JA4
	Ch94W/yAFcSqXKRFk7O2+HPdtn1rS/HBCF2+Fs2/Jm57bEuRSoGWedZkq6aXJXd/d4st8tPpQ4O
	E+mza8zD1pPDj1t+uK5d2opBtAfOSpSNQamQDgHT9ZuqooZnizlSn1kUzoNuXO+zNdxzQ5/sHQJ
	rWXDT/r2z1R6XIA0ryw=
X-Google-Smtp-Source: AGHT+IEZOJvGmpqDqaSf7LKQmvfe6JX+t/bBmW9sjDDCcTLJvi6+06/LZHEjcNuZdOAverPogan1Fg==
X-Received: by 2002:a05:6a20:6a0c:b0:1ee:68e3:ff45 with SMTP id adf61e73a8af0-1f544c92aa5mr9176797637.35.1741366712591;
        Fri, 07 Mar 2025 08:58:32 -0800 (PST)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736984f81b3sm3456903b3a.118.2025.03.07.08.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 08:58:31 -0800 (PST)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix b->written overflow
Date: Sat,  8 Mar 2025 00:58:27 +0800
Message-ID: <20250307165827.1775663-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When bset past end of btree node, we should not add sectors to
b->written, which will overflow b->written.

Reported-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
Tested-by: syzbot+3cb3d9e8c3f197754825@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 80a0094be356..18413b4f22a3 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1187,7 +1187,7 @@ int bch2_btree_node_read_done(struct bch_fs *c, struct bch_dev *ca,
 			     le64_to_cpu(i->journal_seq),
 			     b->written, b->written + sectors, ptr_written);
 
-		b->written += sectors;
+		b->written = min(b->written + sectors, btree_sectors(c));
 
 		if (blacklisted && !first)
 			continue;
-- 
2.48.1

