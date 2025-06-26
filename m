Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F48175A5
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Jun 2025 03:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750907091; cv=none; b=mJvDFMlHI/COCXD06Xi1pHdS+zVDlpzh+kXhKzMaT252IjhgTssqcGZHumrf1rqcOVaVtDUYjZZL1xD18cUMSEHYfuUDJcZlkGt/w2yK771e7IuXRwCGt+TWwRan0Azr+mIHJF0W8+5blBqABA5qzMOOtnb2kjL3BD6TNDtbGVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750907091; c=relaxed/simple;
	bh=a/RaF0bZ7vf0jAjmyF+jUw4IChCnaHop4gWxD+Kfre4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gD37xs1Oo7SC9+5yFXWtQNWC4+7oKP/mDnyqfE3CXjtiSDTBlKcy5H6qooYs7jTKEk7BHvgPkfv8FvwFcUFcr0OSAEnfuhlh8gN5zvollTCamCHVFk6NQsAExMVQfFRwuis4dPMwxQgQiog62QqxlJo3VEs52g3pYiIT3EgpouM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j4PuVynd; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j4PuVynd"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-74931666cbcso600457b3a.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Jun 2025 20:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750907090; x=1751511890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ro4pn15+zGrzhqYHLqFWrXtrvOKXBv/gNz9AH7cCRj0=;
        b=j4PuVyndKOjxvDsse8qLU722bEys00D4VQWTa5BRJUaKp/WbUq15gHmE/2lOkhr6Sx
         gdnevS+5KlllWL1IZCI7V6fwXxHrgtGjIjhCRo3WV/bjGzNsv/docagRcAdzQX6PDgr1
         NM7cgEDiiax/gyZzeFzUwDsLMZpOntuR68MLnamNFPD9KSTRCuQ4H6RA3Mx7RNIKcVbi
         LcNra7MUsPk8W9OE5UM+SRNOEQyUZIpCmJYFpaT5gOXe9faWoeN9rI6T5zOmdYVb3kav
         gm2XYAn3BLKJlWsNn4BxqJqYNpDAZ0S85bBQx+KMcnid+aZ4oGRK3Rm5O7N+k++yHb/e
         IKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750907090; x=1751511890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ro4pn15+zGrzhqYHLqFWrXtrvOKXBv/gNz9AH7cCRj0=;
        b=lapqfTRn7SshIivgJHgl99mxt47ZCOgHxNIHQ1ZauaEqU/QnLoS4OvXsb1J2SYf6xO
         UFis6UnWTL9kPO4ClMezAbduAyJi6RrMsO8M+j7E9b9ynckmTJTOaKpKhBVSMRDzjm5N
         A+1udxhlqCJvp+OV3EiW1lZ0q7vIHTLoKbsx4FG6lkBm6pUQ96MTnsO2SyRcwNlAxJqG
         YriAl1emdvLlyXraQXe6HcL1+Q9ZrDVfdJVBVtpLLsJs43xgBZQpsVRYlZcFGfaiDnIK
         szCe/FuP/SCRwtsp+zDzcKYfh8bEarOu3aNIhhZv6hfmS5ogUvt7GxrafxD7CVvCbGn2
         qaxQ==
X-Gm-Message-State: AOJu0YwqUATiB8RAvD2GcNYmqUu2DEMmmzGGv3lnhA236Ic3w1t6y8uZ
	qapgzIkEyJig5y4pGRB+RRa5WpQWcPyzJT8Hf4NYd3KfLB0SqmWjqauz
X-Gm-Gg: ASbGncvpqJxMR/SbZfwyWeNkrgcqpVCOTSXbZj27DGZoBNNZzVdOb3fa3RVD1Qsh/9I
	akCztfnPVj6q4OdMBQNtfUYJinn3yy44VrO3RxjJShZjvgwvXTNaQrSSlig1OQ0WSa+++DpSVxb
	bNLUzyasLXn6pQlTmaDO/8cNc/+rTm4wuViKfQ6UXCP4BRr5LCgaChpZGB9RPJOgnSBhHYQF1CY
	T0nVcIJ7vkjLsQdj5i4s5KsEpYng/ZtvUuOSFfDBqPcDL6FNDgPPmnQ2F3hPCJrzEl8b1zuTkER
	gz8Zc+Un1RwUUFvmBuEHqiXRYk2M6UHTEDxY
X-Google-Smtp-Source: AGHT+IGNJBghRQdEMKtbsIMyMn/Uuk2ns/lcaT4K5KXbMVNgnYv9FHFlBeTZwtFjx5ARJ1zMNVjJMw==
X-Received: by 2002:a05:6a00:1953:b0:748:de30:d01 with SMTP id d2e1a72fcca58-74ad4491066mr6696807b3a.10.1750907089607;
        Wed, 25 Jun 2025 20:04:49 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e08d1csm5806212b3a.13.2025.06.25.20.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 20:04:49 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] bcachefs: Shut up clang warning
Date: Thu, 26 Jun 2025 11:04:45 +0800
Message-ID: <20250626030445.1442111-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506261026.ZxtJ7yeV-lkp@intel.com/
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_iter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 8f037a798524..3d85627eedd1 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3333,6 +3333,8 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 		bool lock_dropped = false;
 		void *new_mem = allocate_dropping_locks_norelock(trans, lock_dropped,
 					krealloc(trans->mem, new_bytes, _gfp));
+		(void)lock_dropped;
+
 		if (!new_mem) {
 			new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
 			new_bytes = BTREE_TRANS_MEM_MAX;
-- 
2.48.1

