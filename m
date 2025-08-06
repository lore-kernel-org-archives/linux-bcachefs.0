Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE5B1DAC95
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 06:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754461569; cv=none; b=mJPQF0XPDGikgrJ234Teb2F+the6j+4g5loM14Ne1zp/VfwuhVXN9tNP4F+LSXet+JpHIfv3zdCYTJP574brTK6FlqiELPRT/gL+MojGMRxs8a1cIRSE6YiVWVycplgH1WvMfhBk5K/T8oW+CK3fbE83jLiYk3uwcjedBX90Krc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754461569; c=relaxed/simple;
	bh=VXo9b3cWgCZAuSuSe0LdGP7qKqP2WicOK9+CvRZVVYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwY89RS+p0F1sGSaOssFaqcvJ8qFPiGHQiTADJ9Gd9onzmqSsJ7n+ftyHguzM1Lod6rkIwvTmobMXSnwCqx2jJbpEnRIOlPCeQ/P2l+nTRLQXdnlRfTEHRWuQWk58QDShWxbOcVwiLJRXs/oq2e4H6w3HAgpjtIgEXoIH+8ciA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NdbPmMCb; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NdbPmMCb"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b34a6d0c9a3so6423304a12.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Aug 2025 23:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754461566; x=1755066366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8FZts/d0bRWr1ttxABTxamh/wB/YRropo5ezOu5v00=;
        b=NdbPmMCbMvsWkuVMUZVLfGZKtLU/Ilh1ueILXqaDLPAtuBdf5+Z5TIVnx1TzxZDD2d
         HsCakOd55H/E8Vm/GZtQJpYHwoYDDUTUYrwCMcgjf2njQYj3ARzeB0m6iYp7lPVdno/I
         IvtdvgblmE7dZYqDQzKfz63onMaSQPtJzif0+hNkLJEZB47eqrMquE33UjvwhGc4QfNq
         M3LTHE3iHq4bDmHvhftF8AomybMeVHSINH4hVWvl3izxrlqGJWWzvHIeSoXVPaIMXuXC
         riI9oBNkPtagWVgWL1BQW+2edN8rNWsM3ng12pVtkmAkjP3Daak7R8PejF9b9ePbnT2I
         cSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754461566; x=1755066366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x8FZts/d0bRWr1ttxABTxamh/wB/YRropo5ezOu5v00=;
        b=f178yDycJzIxzjqjBgwZbgroz7LwQjjMFiyRPN13JWCVx392l1uCuYeHJtRtwsPAZ5
         2n1H2c4WNvDv08AuFU8X+TXzyCo3pmXFcj8QwVszyVMBx2F382Ri17eODLFHIsBcehFG
         EjPLIDltVsq/sYWTJ62my61uMOyWTZRhajl9Vk1z0V2iqfk5Qg+zLj5X0v97zYtqmhNl
         7PtqZze7pztyvlD6IZzVZtiLsBpV25XE/mixia4praCMGOlQYmIupRwLpc9rIbx4i+zy
         nvgdbgxMqN+aznXKVF8qYJh9VK/4zynLYAvG/cwLLF54K5zW2NvfEmqEeRLZP21KZYE3
         oA6Q==
X-Gm-Message-State: AOJu0YyQdiBSFsI8qzC45YG6AECkkk1Vcv9nTzvcdDLvMY+FfptO8lt+
	W70HquE2RiJiTHHyphbJHjKkWF4Hukz3fDGBGUYw9u1B1OcJkbWUdrZ3qo5beg==
X-Gm-Gg: ASbGnct4QAzECZxXZS8zlfH3igT8o4jUWQMeQXV39nYufGUvaZGNWhOVKsoQY3WohwO
	4vcwBCzkcOLG7OqTYUuPDxSb4e9KDzc/iDX7SgK29GsryN7t6/tn6bzDzYfai/CbxXkTPoTAubZ
	vItkDUeGdn9SWNA4pmjhjiP++8suLWH+Ha3rzdLOwypeclvzm09gvJBZ/2famvu1geVyb5cz+GJ
	2AVlNfa9+/zikYqHhnqka0VWvOarl2QPKA2xunT0MLAfTfnBHFpz15SfieBGy+aJ9yQ4GQ5beT4
	S47HS5/zacWTZzk+jm7vGTYKegexBiTxRJMxi1+LFNb/MGUPYBFkQP4JNY2m5PwzKMXl7SBZ9BP
	Xn6AW5ic=
X-Google-Smtp-Source: AGHT+IGBC2ljfHPf4e6qkveQ1v8EXdxt4RSo8iPD7OOOH3b98AB3Aa15uHQo7TVx4mNx/OhN72xWZg==
X-Received: by 2002:a17:903:144b:b0:240:bf59:26ae with SMTP id d9443c01a7336-2429f4ad858mr24921585ad.36.1754461566265;
        Tue, 05 Aug 2025 23:26:06 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef67aesm150127595ad.6.2025.08.05.23.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 23:26:05 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] bcachefs: Fix readahead involved deadlock
Date: Wed,  6 Aug 2025 14:25:56 +0800
Message-ID: <20250806062557.458303-2-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250806062557.458303-1-mmpgouride@gmail.com>
References: <20250806062557.458303-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

readahead first lock the folio, then invokes aops->readahead, which
locks the two state lock to block subsequent direct I/O. However,
direct IO or bchfs_fpunch first lock the two state lock to block
subsequent buffered I/O, and then lock the folio to invalidate or
truncate it. Therefore, there is a deadlock:

thread1			thread2
lock folio		bch2_pagecache_block_get
bch2_pagecache_add_get 	lock folio

Reported-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index c5ed62a11f23..9f6f9f0f21ff 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -64,6 +64,17 @@ static int readpages_iter_init(struct readpages_iter *iter,
 	return 0;
 }
 
+static void readpages_iter_exit(struct readpages_iter *iter,
+			        struct readahead_control *ractl)
+{
+	darray_for_each_reverse(iter->folios, folio) {
+		bch2_folio_release(*folio);
+		ractl->_nr_pages += folio_nr_pages(*folio);
+		ractl->_index -= folio_nr_pages(*folio);
+		folio_get(*folio);
+	}
+}
+
 static inline struct folio *readpage_iter_peek(struct readpages_iter *iter)
 {
 	if (iter->idx >= iter->folios.nr)
@@ -290,7 +301,10 @@ void bch2_readahead(struct readahead_control *ractl)
 	 * scheduling.
 	 */
 	blk_start_plug(&plug);
-	bch2_pagecache_add_get(inode);
+	if (!bch2_pagecache_add_tryget(inode)) {
+		readpages_iter_exit(&readpages_iter, ractl);
+		goto out;
+	}
 
 	struct btree_trans *trans = bch2_trans_get(c);
 	while ((folio = readpage_iter_peek(&readpages_iter))) {
@@ -317,6 +331,7 @@ void bch2_readahead(struct readahead_control *ractl)
 	bch2_trans_put(trans);
 
 	bch2_pagecache_add_put(inode);
+out:
 	blk_finish_plug(&plug);
 	darray_exit(&readpages_iter.folios);
 }
-- 
2.49.0

