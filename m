Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149012C549
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728767218; cv=none; b=uKdR553jHhtL2hSFkcDm8KOa4F5jCOWbbU2MDxnRJyKddkdUVi0pxdkQkoU0pbhzOvkQ58ZuGt8RmDJMtySWq05mKHFXg3zF8OnK6x58RVdv8TIVYoz8MXOb8ICTjzc6Ky90QWhn06GCXB/K0FiftVJIwuCukzPFADmop7zhBl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728767218; c=relaxed/simple;
	bh=JsF3Z8ikzFPRW4UJT1LcYKkLhtaIByKK4oEof7WYiYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JNyZu2cgCwDsc9t2i87tyBnMnPI0NWqbPl9EqdX6pOMEhJ+HRgmmQiEU4Qm1t6r+S2zkgeJN4/Ab0bxHCZjT3S6v57G7dHVVKRkR8ss2J/Verb+/dRrgeTr3cR5UZIh/G2kDnYJ01m4l21mvaoNVmMLmSvC8vWngNXG/jlVx70E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UCfjEGhB; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UCfjEGhB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728767212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OrcA22SUR1/k8/9s78dnXfu4raEkjtdYphge2uWUkns=;
	b=UCfjEGhB5fZVIhypgrA3TSpA6HxKCUIAsOWMMWyqbuBIcjl2YbUBEAR4K2Vs3IpQeVvdEY
	ked+chXgsBNfF2qcPtLpnRpRBS0QKue/F1nNqCsLKK21f3P7BJKiTsLg9V3dqHee14u4QB
	/95HZkrh/wrp5kcHwu/A0CC2jQPJoGs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+19ad84d5133871207377@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: fix uaf in bch2_dio_write_done()
Date: Sat, 12 Oct 2024 17:06:43 -0400
Message-ID: <20241012210643.3913472-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reported-by: syzbot+19ad84d5133871207377@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-direct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index ee1c0325f313..6d3a05ae5da8 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -369,6 +369,7 @@ static noinline void bch2_dio_write_flush(struct dio_write *dio)
 
 static __always_inline long bch2_dio_write_done(struct dio_write *dio)
 {
+	struct bch_fs *c = dio->op.c;
 	struct kiocb *req = dio->req;
 	struct bch_inode_info *inode = dio->inode;
 	bool sync = dio->sync;
@@ -387,7 +388,7 @@ static __always_inline long bch2_dio_write_done(struct dio_write *dio)
 	ret = dio->op.error ?: ((long) dio->written << 9);
 	bio_put(&dio->op.wbio.bio);
 
-	bch2_write_ref_put(dio->op.c, BCH_WRITE_REF_dio_write);
+	bch2_write_ref_put(c, BCH_WRITE_REF_dio_write);
 
 	/* inode->i_dio_count is our ref on inode and thus bch_fs */
 	inode_dio_end(&inode->v);
-- 
2.45.2

