Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A33FBA7
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 15:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723305124; cv=none; b=RDjK85Qr11lAk/UTAt5agODflsdvS6r1XTpl/Gg6UYB+LxcOgCH2kLO8YPC14BzI/JLJcBe8fF6aQQF5qpKneFVW9GZ7vd1iyA0UonKx+2ja7W4+/XdxmjzZjvg41MreozKb1TaCvKVZfBUbVxQvbFHP8s4686n7NCa4i+AAppw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723305124; c=relaxed/simple;
	bh=5pxlxNJK5y64y2pZ9Qedxxx8eYGH7ev6nzxT5HNs6Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OUz+dsMAqVd0JIG6yftLQMc8y2SAiUkBCiNdtCLKJHjc+lDb8TANNIB+0C4aDdAGOLYlt9ITP+FCr9l4wo8Q6TcoH7My3SypaQH6s2sqaxFF+Sht9Bffb6qApFqYWx7MJIuBMbxuod9coBDQzHiGO6xIuo/qHLWWfkOkqbsL20E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Btw9A0y1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Btw9A0y1"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-70d2b921cdfso2729467b3a.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 Aug 2024 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723305123; x=1723909923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nyt8rH1ym7YYTuOvVE/uW70AQIZ9D/EJ59SmMGwfF2c=;
        b=Btw9A0y1w2KIrExPh5r227UT1Oy5QqZW2eyZ+E5HMQuR+yC12BMJT6ailEff9JH8Ka
         zhwCP3J+ITHClABD+KTMRPG00cWD/dQ1NNqIUiNzHCJtsdYtdlTScNLZRj6GbDFLTZOb
         WbnVRcAL7uh2ETjkdEoW7R6q3BuEV75uS8BzSV/WuCRTgMHiLy+5YnOfmamOQJUAcY7A
         rXcHp6cZxyXlpV7CRRy3sAmWCVTKLPC7oR2TIBUvyoATrbSy19m16twNlSMTU+36h7ME
         MoJSJt/wwzhy7gJ/bzMa/LYbWiQl9WvsELvi1uAsNwar2bWATSCqC2nn08fr3FnKlueP
         UFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723305123; x=1723909923;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nyt8rH1ym7YYTuOvVE/uW70AQIZ9D/EJ59SmMGwfF2c=;
        b=MFI4qE9D3ZS8khdYcqpQXzYvkONJ3DHLhG93oom5teVC0te3eMKc+ogCk152bMpt0K
         3vzsCMazQdDXGm1/Gbn0pDJ5/LOOZ1oup8K7uE0rnuw35JX2Q92sW8eLyyufh/xhPp6j
         2G/OL89HgAtw6/1dzTvg1SH5LXVr5ctYCElpSjININjHl5AwUFXKJaD+OkCvUJiQeoX7
         Y6CLVoXKK/EblKqsCP0SAAp+2T4MvLun2ZX57uwdAsVbgeu3EtApfFKuHpzVaHJsUJca
         5Ii9WicEEs2n2awRqsFCTJtlwj77ZbUH2UhmRLPlSJUALBnb3YPG7kXTJRqGjPgB67DE
         PF+w==
X-Gm-Message-State: AOJu0YwZylVt349XfE9j7kyz0ExZ4XkCtnTlE1bv9KFXbw/iK3/NG+9g
	PbUC9hwuh5VI7z8jAVBY1R1c9ihq9qTnBmYFOau0PHxye4kIuazGquLlg6Sj
X-Google-Smtp-Source: AGHT+IEsAYzs3PC2r5aXsuLOSWdgyCSITDjVw0bzpxHcTCv7n4wPLyhw/I6ZD0+BX5PGs6++Cnzj6g==
X-Received: by 2002:a05:6a21:920e:b0:1bd:27b9:b63f with SMTP id adf61e73a8af0-1c8a00e2f39mr6567725637.37.1723305122594;
        Sat, 10 Aug 2024 08:52:02 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5a437c2sm1385468b3a.112.2024.08.10.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 08:52:02 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH] bcachefs: Remove dead code in __build_ro_aux_tree
Date: Sat, 10 Aug 2024 23:51:40 +0800
Message-ID: <20240810155140.146460-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This logic is no longer useful since commit
3ce8b463e3e0 ("bcachefs: kill bset_tree->max_key"), so remove it.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/bset.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/bset.c b/fs/bcachefs/bset.c
index 575e1d0b6eeb..b95deeb83071 100644
--- a/fs/bcachefs/bset.c
+++ b/fs/bcachefs/bset.c
@@ -754,9 +754,6 @@ static noinline void __build_ro_aux_tree(struct btree *b, struct bset_tree *t)
 		EBUG_ON(tree_to_bkey(b, t, j) != k);
 	}
 
-	while (k != btree_bkey_last(b, t))
-		prev = k, k = bkey_p_next(k);
-
 	if (!bkey_pack_pos(bkey_to_packed(&min_key), b->data->min_key, b)) {
 		bkey_init(&min_key.k);
 		min_key.k.p = b->data->min_key;
-- 
2.45.2

