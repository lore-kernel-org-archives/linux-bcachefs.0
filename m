Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C22239594
	for <linux-bcachefs@vger.kernel.org>; Sat, 27 Sep 2025 08:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758961515; cv=none; b=T2k46WzoSQIyjvPbRjO5lncvO0T93CakTBhb1taZRTOqS/JWnbyEn8chZYiRiv2NftPmIGEuSa/8EBLq85F1REiXQxl4A1Jc1ucx4d1+bjHiI0773lL2VhtJzcLxGn4U6D6sbSAy61EQ/RuOOdOkVd75W7hn0H0GMw9AmHMiU5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758961515; c=relaxed/simple;
	bh=p5vz5xhbT7dt6WixoUghQiRDJb+PLQ3a3K+iSodMKOc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YPLCMaPm4C/m3Xm42Gsz2BEz8guqO3D8CLiP6H6bQEqtlcI1+9+V5+kRTmIqyhlwKzEm6FRzsO90znUAdqvwm2ETKcSKtOl+pNREZIxDsV1dwiGU04lv91Hty7Gw0Ew7eL12paUm7Xhz+z8A7e1kHcxV55unyCGYKb2zqsMd1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQbsl/LN; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQbsl/LN"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b5516ee0b0bso2184295a12.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 27 Sep 2025 01:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758961514; x=1759566314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DcS53qL3vygg89yIrHdWsxucuF37fzAauEVoENx9lyI=;
        b=RQbsl/LNxsReAM+SpVeiN28krhPr8B5qRyd4bRKJAUuXkzb4E2mWUeL5yLk1VqtBGe
         nxuO82bFjkLHlR1pZUIKx2qGg3wqC7Pgi+UM9WAfzmtqTdr4aOfXEy0neELO0WQhyE3X
         RrVK/ft8wsYZDzSGoXqaiZOimHM9JWa3P3iRobOJ2yyLNa24i+y9Lhk8VYyTDYsUupIG
         Sh3jsEMTBcMzQAkxfWKi6yWcyMHbsLsBS8anK+b66H/LPQgrzJlSMRHaOFMSoEazMyyV
         xqDVik7V3wB2/wq4xXyg1FpZHYq4aGPL5Xxbs7RLBaPb7jXsrkwU7gv0/KY72EM8vBFs
         epCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758961514; x=1759566314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DcS53qL3vygg89yIrHdWsxucuF37fzAauEVoENx9lyI=;
        b=aDWoWSFVOunY2yKpr0xAyOWCK36jagot/FaQYnv2fcza/vJglaZRvEQxOhcp9GCoq9
         l+wB0U2ON4ee1KfNBY7UH1OJTqlpI/LIMjli5wOQfFfU0p+8eSagPQmq8wr94FCm98IN
         RTmit6+gJIKP8E8AW5iE89T2xxT9P3NaUm9QneKRAUpIY58+VFhaOuYm5bxfrnducPBt
         ywXmnBEJdjZGKfi46+AOPS8l+n9DX4YkPXhrs042O67Wh4B/+BY1tT8k7+3lbi3rJc7w
         VWkdjTr66jcKrxdz1zUB/w1m2aIVr7DAF0PO6ZZek4f7HnLv2owaYAiUVr1FzGR0Jn09
         9Yow==
X-Gm-Message-State: AOJu0YxhJfhJ5r/iflBCH1pydbt67GmZUDhBFbNoztBKUuuBsZw41eeK
	kPROybteIwu4gMxvwp3smWU2Iql1xhAnZX8Nf8tl4N78fZ7dpPmfy9Ls
X-Gm-Gg: ASbGncvVDTfAKYfMsodOOAZibq+FF1BW5TS0BZdk8JBdz/xKIVrFKSOg2F+dCBGT+Hi
	Jd7w3FWPN3kneHg3b2Laxbo0rFmGkZvzY6Ec1AZIZJiXzXAcLHMy+9hADtqtfigsCwzvmccyw1e
	fZqOx10fG7OmTZ3helwldua+F/3K7a+7jRDn8xBbEczTYAa5D5f3fEgk08JeLUwihObTr6gPrVG
	dpcshN7pWMcgYcXujsAhpqG/AfuAQTFVKGj9m7wgDus1oCv6KE56bBSzswJiA/2unMQxRYCkDMN
	MeHkKlwHOYlkDOXwZsU1FRVoq9Af5qhD0QxPiLjKtO4cDt4jEnmmpFK9V08qVFk3t+1gBsebKnJ
	98Dul3MZXsLXkkdzkB4nJWXU9DToxVgm3c1Jc4a2EgbneZY/bItJBAriVt42aSdo1lcxaQk1Lq5
	YolHcKDozUYeQbWSq5oDcVg0MQ
X-Google-Smtp-Source: AGHT+IECY6O9JpWVGyRWOnkVuWa9I4Cr7WOizR6qimQpbLIm+0WrHLfoZYMvAzc26KJNd3aVTvVaOg==
X-Received: by 2002:a17:903:19cb:b0:267:cdb8:c683 with SMTP id d9443c01a7336-27ed4a0e96bmr114981805ad.27.1758961513691;
        Sat, 27 Sep 2025 01:25:13 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:3094:6bb3:b65d:f7d0:cab4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6700cb6sm73743805ad.34.2025.09.27.01.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 01:25:13 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] bcachefs: Fix deadlocks between fallocate and readahead
Date: Sat, 27 Sep 2025 13:55:03 +0530
Message-ID: <20250927082503.40951-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


There are ABBA deadlocks between fallocate and readahead operations
at two locations in __bchfs_fallocate():

Thread 1 (fallocate):
  bch2_fallocate_dispatch
    inode_lock(&inode->v)
    bch2_pagecache_block_get(inode)  // Acquires two_state_lock
      __bchfs_fallocate
        bch2_clamp_data_hole (or bch2_mark_pagecache_reserved)
          bch2_seek_pagecache_hole
            __filemap_get_folio
              folio_lock()  // BLOCKS - Thread 2 holds it

Thread 2 (readahead via copy_file_range):
  bch2_readahead
    folio_lock()  // Holds page lock
    __bch2_two_state_lock(&pagecache_lock)  // BLOCKS - Thread 1 holds it

The issue is that drop_locks_do() only releases btree transaction locks,
but Thread 2 is blocked waiting for the two_state_lock (pagecache_block)
held by bch2_pagecache_block_get().

Fix by explicitly releasing and re-acquiring the pagecache_block lock
around both blocking operations (bch2_clamp_data_hole and
bch2_mark_pagecache_reserved), following the same pattern used in
bch2_page_fault(). Force a transaction restart after lock release to
ensure consistency.

Reported-by: syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com
Tested-by: syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=cb91f22d8a581fc19edf
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 fs/bcachefs/fs-io.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index a233f45875e9..66a60e5f03fc 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -694,13 +694,19 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 						 &hole_start,
 						 &hole_end,
 						 opts.data_replicas, true)) {
+				/* Release pagecache_block to prevent deadlock with readahead */
+				bch2_pagecache_block_put(inode);
 				ret = drop_locks_do(trans,
 					(bch2_clamp_data_hole(&inode->v,
 							      &hole_start,
 							      &hole_end,
 							      opts.data_replicas, false), 0));
+				bch2_pagecache_block_get(inode);
 				if (ret)
 					goto bkey_err;
+				/* Force transaction restart to revalidate state */
+				ret = -BCH_ERR_transaction_restart;
+				goto bkey_err;
 			}
 			bch2_btree_iter_set_pos(trans, &iter, POS(iter.pos.inode, hole_start));
 
@@ -730,11 +736,17 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 
 		if (bch2_mark_pagecache_reserved(inode, &hole_start,
 						 iter.pos.offset, true)) {
+			/* Release pagecache_block to prevent deadlock */
+			bch2_pagecache_block_put(inode);
+
 			ret = drop_locks_do(trans,
 				bch2_mark_pagecache_reserved(inode, &hole_start,
 							     iter.pos.offset, false));
+			bch2_pagecache_block_get(inode);
 			if (ret)
 				goto bkey_err;
+			ret = -BCH_ERR_transaction_restart;
+			goto bkey_err;
 		}
 bkey_err:
 		bch2_quota_reservation_put(c, inode, &quota_res);
-- 
2.43.0

