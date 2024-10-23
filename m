Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E50F4436E;
	Wed, 23 Oct 2024 16:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700038; cv=none; b=bsi7apFGeYQAKKoUSOE50Vdgbpir7kFi+hORuDpopCGDi47i9/TUphwp6cZ1T0dC9bgFlWgOBpTi3rkrV3DjW6W+XVxl/FZGz68oKyqTFg9Juvse59sJpO0hf3Vf5IVJd5rrH4MYByTUr6ssZXmLmDJiJWL8T89G77yD2QpK734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700038; c=relaxed/simple;
	bh=CL7sCdE7ewO/6d351xSsq+763zeIyUF2g7jG8PEGmbY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jlMJjJ21ZWjlxAdnSsvBhlo2zvwuy6eD/IL7GtxyMAnxdxR0zZ7PFo9fnbBF0ujR4Mf6so9SQ8LFl1HmZrQKDLGm6MjmArldhq2BDpjZAp8a9UkuQ+a/Dp/HSvzmZ1Vs2gd8IBXQSZCUvf8IvlcS2FVKaUk4gYIRzHzBARTVVJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q4NgYBZm; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q4NgYBZm"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cdbe608b3so58200805ad.1;
        Wed, 23 Oct 2024 09:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729700037; x=1730304837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uYAAaPtb6WNliyibXG8cFxadgLCekfpRo2kqYV+8SvE=;
        b=Q4NgYBZmJ8KdMt7Mk6NbmIaljhvSar82RuP9Tn3z7cwocepJykJfYVIXJS6hwqCgu8
         tg3Oass3tyJzk9vcyHyq+GU40BaCHbH16yv6nJDT8EePf1VEkcztHsij5eidPK4oyBVV
         jJfkxOnRgcQelltzkrAe0kpv1i8Jw85YAL8AxMs58MX0vj7QWWxqQ7bnvf/GoeFcGsN3
         T0FvnEHQ8/b1N805wFAeNy5xTSFOy+M3P0Uop68uYQBMLoQ2RD/pace8ry/zEk5oUjft
         BobjEBFixFoxRbUb9vqncAkl8CYAyY7bByWG2AgVKgbFcHCxU8tnBC0JolHAvJRdvB96
         ioxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700037; x=1730304837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYAAaPtb6WNliyibXG8cFxadgLCekfpRo2kqYV+8SvE=;
        b=TIiD0gb/ojh2TD56xpXLQ9bLDtJn5JKFCh0rvh4KbDzyB5cee0Voy+irwC9fuifEyg
         bHjFJaMe+nwU2Q2jStGIh4e5ICWDMx0H9VIaT0tYk2CZUd1u3Qw4xm+X9p5ijDnWlGqj
         ciT8ih/M7/vZvyomqd0O6jxJclfG+OiuC2kyCJhdQInGOWTvGMBshHK7elPub/D93h4o
         GCUWk0BqDbyWWJiHNOUVKZaxZBK3Gu+KPF9U53loxOua+8M2EPHp/cl0iQp0oDX7H2fH
         uDHaHJqF85WpWbWHXjVdwtYtAJhvkbfyTuCE7MTTBSwM9/AypB20hBEYmQuS7vYQwsWA
         k2VQ==
X-Forwarded-Encrypted: i=1; AJvYcCXADH49O5RJ3BQi9MkCkTMw0uLu6gDa6ciS89V3aShv5PQjkjqZWPA+mTWjBuPIaycblUR8gGFHvGtx7yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr965P1LOaRbq6jh5kfdABRA9ybJNjjv4VdNyY5b5ZmoEtmjBR
	21cnuPvsRW1tub0O4gtnoBcx8d/KwUglsCR22oyRDcbs5qZa1M+i
X-Google-Smtp-Source: AGHT+IHcDOJpucL8EySRnOr+rbagp34rKf+qRB2Ni/+8/zYSELzuPCbqQ0BbNKjPTwUl1OKi1aqAOg==
X-Received: by 2002:a17:902:f542:b0:20c:b9ca:c12d with SMTP id d9443c01a7336-20fa9e99ademr35748815ad.38.1729700036783;
        Wed, 23 Oct 2024 09:13:56 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef08c4asm59348535ad.80.2024.10.23.09.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:13:56 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH] bcachefs: fix null-ptr-deref in have_stripes()
Date: Thu, 24 Oct 2024 01:13:45 +0900
Message-Id: <20241023161345.80029-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer dereference
occurs, so you need to add code to check the variable.

Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Fixes: ("bcachefs: metadata version bucket_stripe_sectors")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/sb-downgrade.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index ae715ff658e8..8767c33c2b51 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -143,6 +143,9 @@ UPGRADE_TABLE()
 
 static int have_stripes(struct bch_fs *c)
 {
+	if (IS_ERR_OR_NULL(c->btree_roots_known[BTREE_ID_stripes].b))
+		return 0;
+
 	return !btree_node_fake(c->btree_roots_known[BTREE_ID_stripes].b);
 }
 
--
