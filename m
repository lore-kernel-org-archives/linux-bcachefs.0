Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9F11C2334
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Aug 2025 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754328781; cv=none; b=J0wmYFwLU1ExEnYAInqACtkf5CcFtqn8qctZAvru2K0FR4EVymGT2yV+QvCIZ61IxyniLEqNhzuMyj1sCDO0oDq+3DYooZYdckf3th8YP10q3rnSaadB/ziS4CHiWk/TgmhYZphPefdgXJDn4b0FSB4+wa79oxnBluRoBvEQt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754328781; c=relaxed/simple;
	bh=Q4lf86qzKPt3Ioq+wDZ8R8s05JqeA+vcAZ8t8aWa1EU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VTp80N1gYm9B5Dioh1C0X6SnJ0lSgdsG59wfSdrTEkIqMsE/0jP7nDrr1aWUsiLYaHCSUki9ttlciV1lWhlXqOsxYJEoTJYG1+XUX5Jc1NE6ksydeCdbyM4W6TabDD1oaXgNVcyNC7s+Z9IAyBBBpfdGAvPRGJK1bym4hAxe+RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tk7N8LcA; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tk7N8LcA"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31ecd40352fso3949200a91.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 04 Aug 2025 10:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754328779; x=1754933579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+mYI0KtxCxaDwyPrRAMr9mZSI+EgmJIHTQNYeyigG1U=;
        b=Tk7N8LcASxQO8W0iVoWk/adECBkBKOS0leQwrxWEka5oKC/rOtz9YeTENv6OuZi48Z
         BalY8qHg+fNwezYCgShy+8ATLy8RHfYE0oXOfLeocoggYzMpPFLm2Y9M9eKJsUo83bj5
         cEcsGzJGXCXHrBdzXtf+AFBiBWFu5HNHEznR28u1OmzO4Bz4PdRmY1bID+nglliRsC9c
         +bB+ogAjUQkuaHPsYDc4MeYGTLS992ElR99aPDPV/j90orhyYmYdE971JzZxVKb6a+YG
         SQ6TNmaXGoDa6a4PZaqXe1extRWaTC4n3OZSx5vEi6dI1OskMsXKHzFYQF5c/6wxOJ5W
         6fqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754328779; x=1754933579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mYI0KtxCxaDwyPrRAMr9mZSI+EgmJIHTQNYeyigG1U=;
        b=f2IskC/r4NBmsE23XFevNw6JQJmW6fjya+uQs3BY7ktfWIqjv0t2FlsTItUyDCG437
         WUMwAQ7hMSpFfV7EV6pcl0PkuqFr5BUbq/1CwHk92ScEyd6fEqHYuGY8Brkguf9wJQS2
         4PU6nBsNAwzFS13kxu1zKYjyXEYCBxgaz/iYXOTva2WyfZwzei8RqAzea5qDO+J0xxdE
         CaVBfWKaT2hDdwjHK0/QNoCav6Yxpub6y+ns77VRh4QhrYeykTC6SJSjDl4avrMR1l35
         A3O//x9kgMoC6w5A48e+OkIyLp2sloA+DBsotzlA8iVE3RBY5iJ2QuYG0IX4pg476/x8
         BJhw==
X-Gm-Message-State: AOJu0YxU8U0/nqLJjNC0WImoS8+LbJwkEUlhpYce9wtzOrtBCbw6eczy
	1KDCb22YAd7sRC93V9Y8WwY8PEwrcEEbqVUjRvyAgg1js5C9jSP02mrz
X-Gm-Gg: ASbGncuHodmI6XBvYvdETaUFmoxx5jrxd6/Wj0ODkwa7h5dY9uSm18BzO/8dHn6sFSF
	9ni9JmgdmKoQAfoQhowhZnhai0l0wkVOF4Ie8FmG4uMAoooEFRc13o/VK5I0bJVXgdxq134dgKk
	x+mqX49DqNpEVN+dfpjkbO9BcPV4gVYcl9y3onm9WZUW7BMtu+nRSA8qKxORxk500BkfGx7X+VL
	Tw9Au1hJjFwKvNjWZyki+H6Yj/NnL3TxabsbVEjCdI5P6yomax1aHH4DJdFvioHfqMUFN9gGjv0
	BIZxnKkXUxPlOVvTGyEoCv0smnc+0Nr8+Fm3OVcjElcYSD7h/hrCWW1uSXwrfQSJ3UGIsegX
X-Google-Smtp-Source: AGHT+IH/PAhkjGyvk1cYqOoYWPeGwMRvSjFI486FASwsiZSPIqug8XxdSBrvaWo3hn0X7KrYXXQRUw==
X-Received: by 2002:a17:90b:4a01:b0:313:5d2f:54f8 with SMTP id 98e67ed59e1d1-321162e51f8mr16928586a91.33.1754328778769;
        Mon, 04 Aug 2025 10:32:58 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63f0cc41sm14687628a91.32.2025.08.04.10.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 10:32:58 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>,
	syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Don't lock inode around page_symlink
Date: Tue,  5 Aug 2025 01:32:54 +0800
Message-ID: <20250804173254.261930-1-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new inode is not visible before __bch2_link successfully return,
no need to lock it.

Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/fs-io-buffered.c | 1 -
 fs/bcachefs/fs.c             | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 0005569ecace..c5ed62a11f23 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -759,7 +759,6 @@ int bch2_write_end(struct file *file, struct address_space *mapping,
 	struct bch2_folio_reservation *res = fsdata;
 	unsigned offset = pos - folio_pos(folio);
 
-	lockdep_assert_held(&inode->v.i_rwsem);
 	BUG_ON(offset + copied > folio_size(folio));
 
 	if (unlikely(copied < len && !folio_test_uptodate(folio))) {
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index b5e3090f1cb8..66e32cc66841 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -865,9 +865,7 @@ static int bch2_symlink(struct mnt_idmap *idmap,
 	if (IS_ERR(inode))
 		return bch2_err_class(PTR_ERR(inode));
 
-	inode_lock(&inode->v);
 	ret = page_symlink(&inode->v, symname, strlen(symname) + 1);
-	inode_unlock(&inode->v);
 
 	if (unlikely(ret))
 		goto err;
-- 
2.49.0

