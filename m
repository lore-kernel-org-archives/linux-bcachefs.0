Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCA1BA4B;
	Fri, 29 Nov 2024 06:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732862319; cv=none; b=ut8bmtzIZCrfCMMOsk7Cl5RuiaWhvPdqlz7tAhn3ln7FbwLOS/tdSZiYbIT9/nE6n717D5qTOykRSjqnwsfr8bGBWsqVtAcCRPx0ChIxvFm1h0zyyXGJ/QMlEnH2fTDacQ74C7UitANaFOMSxwXmX4r9tLtOa36wlYr2b7QT3t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732862319; c=relaxed/simple;
	bh=MMy8zuYaHfqc6MSJxstPlEkrkcaYa6q0NFCR50Ep+ro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iQ0fcZI3dcCeFUt+HsQ7CKmPBMPfMlyfu1gppWCwxeoYhUXxk9a8NOnUMdT1VPMexcc+HA55Lq6amG5gJ9ey/T+1L5BB+GFLBaB8FAKt4hWkDPWVW4DZ64P88zKq3A0+WsRc38v5dxn1N1+Mo8RU7IYDFPey9zQd1I1uRWVWyH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KQjEduJn; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KQjEduJn"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1732862309; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Un6Fs6jJoOLtd8RJ9PjCJ5MWsMneFpC7aGCo9uBzt7o=;
	b=KQjEduJnnLXNAT3n7GeekKanmsK9iLLc/MHrpLjgll8qSzHfjx3o8Sn4dnSQZqZPUsocSKfS7XYcy9rvNQFAOfDiFbhrMfjnOCv+stq2cbh/i46JXLGh3y6QTXY3wVaQpfyjJUyjZuUgkAVwe46RZvZSMrpzVCPaB2XFuDvu25I=
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0WKSwsSl_1732862308 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 Nov 2024 14:38:29 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcache: Add missing parameter description to bch2_bucket_alloc_trans()
Date: Fri, 29 Nov 2024 14:38:27 +0800
Message-Id: <20241129063827.90340-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function bch2_bucket_alloc_trans() lacked a description for the
nowait parameter in its documentation comment block. This patch adds the
missing description to ensure all parameters are properly documented.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=12179
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/alloc_foreground.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 4d1ff7f1f302..2f1ea718cc33 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -505,6 +505,7 @@ static noinline void trace_bucket_alloc2(struct bch_fs *c, struct bch_dev *ca,
  * @watermark:	how important is this allocation?
  * @data_type:	BCH_DATA_journal, btree, user...
  * @cl:		if not NULL, closure to be used to wait if buckets not available
+ * @nowait:	if true, do not wait for buckets to become available
  * @usage:	for secondarily also returning the current device usage
  *
  * Returns:	an open_bucket on success, or an ERR_PTR() on failure.
-- 
2.32.0.3.g01195cf9f

