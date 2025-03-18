Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229E01EF373
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742284207; cv=none; b=NI5CzinTQH2aHZlv6JBBRKKNjQ04x8VmiHiWEGe12ocxcVtlSbdfmIfwHfxK2zKkMyjk1qHNlxVkPY5go/4PKyJgpABkgPtFWtEZ568pmbbsnix48FrFVyDacwr8TNDt/K25mxqzbi9xq0FNm0SXfEwytVV2POqYcAKsWOVcuzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742284207; c=relaxed/simple;
	bh=67DEkYL7LlBkhHFPloTeqfRujtDRbGacrLywIiuoMcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ellasg5d3eeKnBBSaIBhVfOHeiaNOgLYDuzrlQXwJ6iADqMIR6lke/7aRcWdkWfBkKNpl7V59T0L++WxYV5aZKuB4IIdCK+Pm/h1K1w23ze08M+AepJChf9L3bAMa+v168KCO0wG/Te4VzAbQ2Dt2K965rFVNpm3mPSgx7Pt3WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Braj+JNH; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Braj+JNH"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22438c356c8so91345915ad.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742284205; x=1742889005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=COGtS4Iws3jFKkrzaC7LqliJ0sSELJlJ7bcp4EPf2aQ=;
        b=Braj+JNHfhC3Qb5uCxah5DLfDJT36fWIlYmtet27W2WjV3LrSoK1O/r3axzFLLHK7f
         F3lEm7JVPgYnsFybv2e98OlKqpLu8jftkZV4GzHsqk0N8II5PxgFmyUalJD8bhS2BAo+
         A2MVSJkx1o0JYVckOXwXwwn0rbNXah5Z1JIOOThOvklAU66dLDOO8ogvniT32ERHjnA0
         uev7w9a9wkzKD09LoS6t8N4kcjJW5y5w6ywYUrE9rCsl/VKgxs2V/CLBOvKNCghq0Rm4
         ihazBaHXWmJA7T3K8zwVHqFgL78rO55FJV0aSP+nGZnnXky71hDiOHgqLMNK1lUSm0jL
         L8VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742284205; x=1742889005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COGtS4Iws3jFKkrzaC7LqliJ0sSELJlJ7bcp4EPf2aQ=;
        b=DeplxtxhTS9m+L2EPXlWDADOXnx4371DZEN4gmzTqT5zkbRIjH64d+Dn9BYAbtQd+M
         06ESHG1x8SmUhe9EiV7ChNX7id51PAfzQMEa50pyWwMMkUhWEzjGepbnwZmWjlzYsujS
         aYhWBs1s/TaorCNbUEvwMIimu5SAoCTmeMW2XsIPFg553zngsBcWlp4YqP2I2LiY+c4R
         mDStlKb/0ep4H8DJzqhWavXVDL6BaItH3HBCDHlYT9S4Xx5p5ePlcOhHA1ETRyvwNw0d
         xH0l+KTj9x0Bt6JYJDB9j0U0jnR2VBoHj2H8i9sXmUVam+UpjmyYHy8UYMBJu7YHLZgR
         oYdA==
X-Gm-Message-State: AOJu0YzVSGisPWMV/hjJgi5s3ueq4hVm7FkAVUdy3WszCd/xYc2qWxOv
	SgZst0WhbnsPe/8xHYVSwhaZ11WFEOu9M0uiSxvNKfK52b70s9ayFp244g==
X-Gm-Gg: ASbGncsKm7nvR/43fbstfUE8Tf8moidb8dFlfSc+7EnTXp/VvBLwpU99okDo8rnhHbZ
	E7D92f0J4o7LdFTh3CmmxvA3bd42+PIDu7MsEEkQdSpOp0w06jwAMXA6H0lftdz37ptwWJYKh6G
	AGFN/qZ8YxuynOlFK6aPDldL/LPBNCA3GOwmgIAxclMpUfebZ0Snkqi/Z3s8LZJdb69aNMGvI17
	XDqAziXOMr12ojM7h7QdvR9fsz3/Df/IqSFoPYem/XRVLeSsYdCRn/KfLm3pYjfL4jaAm2KVB64
	FTi1UT6Eo3c0NVzC9RQ=
X-Google-Smtp-Source: AGHT+IE0ghAe2FOqu+vFuhyTaXYkJy7PUoCNI37qxgVwOPTrdn7caNh9CemGGeYUgYgschypg4oxKw==
X-Received: by 2002:a05:6a21:328a:b0:1f5:87a0:60ed with SMTP id adf61e73a8af0-1f5c126e0b7mr19926281637.19.1742284205293;
        Tue, 18 Mar 2025 00:50:05 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9c9e54sm6998418a12.9.2025.03.18.00.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 00:50:04 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 1/2] bcachefs: Add missing smp_rmb()
Date: Tue, 18 Mar 2025 15:50:00 +0800
Message-ID: <20250318075001.1976165-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The smp_rmb() guarantees that reads from reservations.counter
occur before accessing cur_entry_u64s. It's paired with the
atomic64_try_cmpxchg in journal_entry_open.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/journal.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index ab68c5c4d8d8..47828771f9c2 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -350,8 +350,10 @@ static inline int journal_res_get_fast(struct journal *j,
 
 		/*
 		 * Check if there is still room in the current journal
-		 * entry:
+		 * entry, smp_rmb() guarantees that reads from reservations.counter
+		 * occur before accessing cur_entry_u64s:
 		 */
+		smp_rmb();
 		if (new.cur_entry_offset + res->u64s > j->cur_entry_u64s)
 			return 0;
 
-- 
2.48.1

