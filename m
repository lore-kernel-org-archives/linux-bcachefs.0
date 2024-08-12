Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628816EB5D
	for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 10:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723457597; cv=none; b=pa4ZlERYJ/qjRZYcxH/TDB9y2/MIG2iKo/9JJ4BrEehIOJ5D6pmNHzzn6/21jQRi5dvCCegYbd214HYvTmbKb0PjlJJnLEX8yBiSH+pStpoQd2FW3cM7mdchskHsGP8Z8t6Vax+34IDmBSC5UZ+O5rcI7MOj6Slxt3NqRgFoO+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723457597; c=relaxed/simple;
	bh=xOtqCV2sJgVZnMdHZDcHsrK20y4+hpDydPGgSuQVlPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2j3dRgDpS+/nDLE6dy/WWkiTumQ+pMzavVV3u2T9EXOgEzyuwRz44R8BbEzNMd7LLDkuYdIpjRFGllE1YhQZmByIVOd18iR5zegJstC1w0EfQfTrjoxGLCijaVZHLIS2ZqxaPYIa8T+pRonPzYaRA0oc9Fq53WZtyJdqQINoZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qi2NiUe/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qi2NiUe/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fc569440e1so37957855ad.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Aug 2024 03:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723457595; x=1724062395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTRaKOJnjlY8dSWuXQXJGBff8VMpRwslBZGCg8rYFk8=;
        b=Qi2NiUe/H5wBgW0ibGeWPPQVBwDMDB8Jwq9KlQ3u38OInVm3flQ/PnjQ/lHabbiVll
         eZUYi5oa3X89qNMduOg9NyvULE1dWzE/Uh1DC8u1ZePxGC3Xu8j8r0EnZ3dfKtf1XW74
         SbbPd764Bd4euJkyWkwfdh8N615CBAs8vYJ6O1TcoKTO3aIDxfA4nDKRp5+XlG9Vfjpx
         kUSahdVS1THpkziZJz1cw6CExMQcQV5IvCVBCJNlbNjq3ZkDim25dw/JpqDeagms6OZz
         5eD5GTVAcg0geuzEmDBSr7FXATYNiOWN5Y2zHWur+7DKzRxd+rRiOrpuRDpMDPfS09WK
         KiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723457595; x=1724062395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UTRaKOJnjlY8dSWuXQXJGBff8VMpRwslBZGCg8rYFk8=;
        b=ic8GJRievcO3EnDrP4b88n5NbNrU6tvyyOl5rlQcroF53epGAT527i2veaQB19FBI7
         UhzPCHbYoT/v7ydBHxOTER6rV+FIqZzP9R3APU6mrwDbFqnSZBGRTLFDx9/wQsryrp+Z
         b66HSjJoozft9EZ5Vehspoy7bC84jnDBJry/8nRTqZedPVwcPzFFGxZS9/LUcTjcPxsX
         FK588nF8KySyWkI1sv92ueKIo2GtpuHBmuIIaX8xwr0vjHbYMDSqxuXoX0hAkY/hlAs4
         8vDOilj4R2tGj/nq1/K4dM0B/pQoIp38XtpZmdIzjEqX+KOxKVYQSisC9BHMp2SUFuoj
         Kqcg==
X-Gm-Message-State: AOJu0Yy91FAtvaZdlhD1BKUfkoSHl0nuDw1soOMj3S3zezEMfofhgArS
	pnZ0o9o/bqk1bdOezslTJhPnAUT4BPKPPYUJyQZh85tFZnZ0lA/KZqdl40FQ
X-Google-Smtp-Source: AGHT+IE1biAupbZ1aXc1hDVj1tyqH3Pm8XWGL9rJKEBn/q2EudVITZI7aQ3qH/KVmrrqe2tREbotRA==
X-Received: by 2002:a17:902:cece:b0:1fa:a03e:349a with SMTP id d9443c01a7336-200ae5f277dmr77403905ad.52.1723457595126;
        Mon, 12 Aug 2024 03:13:15 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb7ee994sm34763635ad.8.2024.08.12.03.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 03:13:14 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Minimize the search range used to calculate the mantissa
Date: Mon, 12 Aug 2024 18:13:05 +0800
Message-ID: <20240812101306.347179-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240812101306.347179-1-mmpgouride@gmail.com>
References: <20240812101306.347179-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the search key's mantissa is larger than the node i's, we know that
the search key is larger than the first key of the cacheline corresponding
to node i, so that when we are calculating the mantissa of right side
nodes of node i, the left side of the search range can be the first key
of node i. Once the search range is minimized, the mantissa we are
calculating can have more useful bits, thus reduce the slow path
comparison. Besides, we can now remove all the prev array stuff.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 00a821f617a5..43b40f6b8c0a 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -616,7 +616,7 @@ static __always_inline void make_bfloat(struct btree *b, struct bset_tree *t,
 	struct bkey_packed *m = tree_to_bkey(b, t, j);
 	struct bkey_packed *l = is_power_of_2(j)
 		? min_key
-		: tree_to_prev_bkey(b, t, j >> ffs(j));
+		: tree_to_bkey(b, t, j >> ffs(j));
 	struct bkey_packed *r = is_power_of_2(j + 1)
 		? max_key
 		: tree_to_bkey(b, t, j >> (ffz(j) + 1));
-- 
2.45.2

