Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D48467;
	Fri, 31 Jan 2025 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340455; cv=none; b=phN76cC+WaoMFCPOTPz9Z2DWxN+YpH/WOsxqlwPuZ90AgS29XhQAe24Xzn+g5tfnLTNlOHZBI8W3lopOsYrF74XZych7F849XQwotH/a4SdS1DpoFVq7x/ATxWAX7iqgr9jaQDzybNuilEFaFrhYIPdGBE1nf5IEiOPupWuhE00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340455; c=relaxed/simple;
	bh=kgUszXNuPV3P2dEQXPR7dcCCYPhIwE5WI4vBqCxuFbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVGpe8ei+jNwAdGwBMQnIyld9vq7hjkUrQXaKyI/HJv6fcSC00OMso96wHKN/liynEz4e3qSpu4R6h6rhpOx/Ffy/Fk+5Inc7Wy7Rc7prl/sw5N4xAW4i5ktm3JapWkzOP2Z3RKCtWm6sIj1k1x3aSvr1ymtYfFmNo5R6Pfny3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADxjwj/f; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADxjwj/f"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2165cb60719so41890885ad.0;
        Fri, 31 Jan 2025 08:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340454; x=1738945254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FVl+sJnuan5pQ1hwFbGyv6FG241l0l+oyyTc+hhZg08=;
        b=ADxjwj/fK2N3US56OwZUOoBQ4kavsGEQXsqIZRTDKx7Gkf9Iezben32ThmhoN7mdea
         97aJHazw7fg+BtJnoFDJZhWFgYlGy+bQM/bs6+9kJ8qgzvAXb/ojFuXvok+pBU7vpA//
         nId0qf95b08BZdjDy2jC0jSbRHpJG0xOjBJ2UUf8Hhg5nvZzSpY5rhqL+lsjuyknD7No
         1O+ssFDfwG4ju3ln62tZuJ61biospJxtioDS6lun9ceU52sw6RFMIqdtMKhNykdWiY8q
         r9RQ7wyJvfOsB7IUUU46/2yq+N52OuQANDdVA31blvA68OrVD2oo1fszY908LQ+C/xLw
         k8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340454; x=1738945254;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FVl+sJnuan5pQ1hwFbGyv6FG241l0l+oyyTc+hhZg08=;
        b=tzroR99iGgINVbhXZWmXX5h1iknRcslBM42I1XR/6lbHWVkDQcuIEFjWrbFPU/IwZY
         5cjQVNAPt3Pl31XxPfrwiYA6cF3n0gGt2YQggLH0O+ebffqFNjPsEKjE/g/rT1nDDD+r
         x2vRNIM2zUSkBT6bK+Ey6Wn8yMu0otWwYNAGBkNWs8zaBlQ9M/CkDrOW2vWjkMBD3kR/
         ZB9LM0s1MnYcGzffhBZe6sSDI5D9qFJXTM2WpDxiRYlSzT5fzfvecKtwCfVMikp5CxqR
         ooM3dczy20woGRUsc5niOlro2zSce10h5VbEvFe121fs3Q/SFVywx1PQuG3FHLDSOto2
         F6/g==
X-Forwarded-Encrypted: i=1; AJvYcCUmjaduZ0s/9qr7l9roXWDTut5iXbYVdDopWwy55WRibF4I6i1KM35jN9kbf+duy0UBHxeR4z8VzCr2QpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKI1ykQHVZ0CF+ltxTmJTSTj+O+NYV43ftKG1AeBXIWWiM6VTq
	iLTxnPrB8jg9JCygv5rYsrpdLa/guUsJnfLCCfStZik4X5O/7E+S
X-Gm-Gg: ASbGncuEwDwzmMSHfOH7Y2ISk4roBkndKUfiBkTzcGR41b31BUCyPkQMa6IFazhoB+N
	a/4KF3rAcxE/STkIcUh0ed5EOf8KffjI0b3+X9kN6enlakTcWjjE85yOPrznWLF0OU6smVElrgt
	noNjZkhiWq15gtYagSAqDrAr4v8Y07V0EqG4YExnWbTIeqzfX4Xdv1C5yUqjUJxixt6pJPz7M/U
	hcrZpisgvaQJKyQW+iYmZX65WK6mF7rjFMVrbbRME/I7h1h2OxHyaFGb5unOY/3CHvoEE4EKx4s
	N5xmYch5+GZ3Ee/9ZdvrQ6YPom3gwVuGzJCNnsnu
X-Google-Smtp-Source: AGHT+IHJOknGi5P2ZoKkfst72xmfzs5tqIejPQp8L5pIi2p64vBY4hS5CrI9s7HD6/Wak138Gxngdw==
X-Received: by 2002:a05:6a21:78c:b0:1ea:df1a:f8db with SMTP id adf61e73a8af0-1ed7a6236bdmr18845044637.37.1738340453645;
        Fri, 31 Jan 2025 08:20:53 -0800 (PST)
Received: from localhost.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec0477aa8sm3253678a12.49.2025.01.31.08.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:20:53 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH] bcachefs: fix incorrect pointer check in __bch2_subvolume_delete()
Date: Sat,  1 Feb 2025 01:20:31 +0900
Message-ID: <20250131162031.190424-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For some unknown reason, checks on struct bkey_s_c_snapshot and struct
bkey_s_c_snapshot_tree pointers are missing.

Therefore, I think it would be appropriate to fix the incorrect pointer checking
through this patch.

Fixes: 4bd06f07bcb5 ("bcachefs: Fixes for snapshot_tree.master_subvol")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 fs/bcachefs/subvolume.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index e3d0475232e5..b7b96283c316 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -428,7 +428,7 @@ static int __bch2_subvolume_delete(struct btree_trans *trans, u32 subvolid)
 		bch2_bkey_get_iter_typed(trans, &snapshot_iter,
 				BTREE_ID_snapshots, POS(0, snapid),
 				0, snapshot);
-	ret = bkey_err(subvol);
+	ret = bkey_err(snapshot);
 	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), trans->c,
 				"missing snapshot %u", snapid);
 	if (ret)
@@ -440,6 +440,11 @@ static int __bch2_subvolume_delete(struct btree_trans *trans, u32 subvolid)
 		bch2_bkey_get_iter_typed(trans, &snapshot_tree_iter,
 				BTREE_ID_snapshot_trees, POS(0, treeid),
 				0, snapshot_tree);
+	ret = bkey_err(snapshot_tree);
+	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), trans->c,
+				"missing snapshot tree %u", treeid);
+	if (ret)
+		goto err;
 
 	if (le32_to_cpu(snapshot_tree.v->master_subvol) == subvolid) {
 		struct bkey_i_snapshot_tree *snapshot_tree_mut =
--
