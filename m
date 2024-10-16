Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716E213C807
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Oct 2024 01:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729043394; cv=none; b=hCzDfbMOhihyyLUjBtND+0qgkozy+5kWL/MTW9eP8cnPY5GglgBYqg7606MBLVg/PaggiUkHBH5Sa25LsIusttV+PXhcEjZ8Iz4NgrRsoZMxhlDdFPUlNjRh1upQXkQzjht8sFZAGHCDQFQasDBIFula63cCIOzeBPVZmz/jhIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729043394; c=relaxed/simple;
	bh=NFb6RJhRH4vw1qiChy9leEqNuV7Ff/PVP10REtocUdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HnLCXVXmV1DMgPFCryHxiLSXKccdaHXPiqoBco0yMjd2+nU18QVVednIp55zJaSuJzKSsL3kruXwrr8I9oqxDy+IQIVBlv6fkG/zHeJaTBquifl54940mUBz0jHHeu7GRKeGpRC8G02FB0cFq2mmfbfx0x+efZSbnCpG7bwDaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mPK5pccp; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mPK5pccp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729043389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IwuLPiGuUxaZ9zj8hRINT/yuq5YbITHYzmysJbjNlYY=;
	b=mPK5pccppxnM6l1fgR5Cx4RvOYO2Cv/YKJuPA2qA78lgrXme8fM0gsxpeuXKXqlwgFmCYb
	vwZSL8BILr/jQc/4JwtbIyeoLgMz2SGUtXgNBjKAlQBR776tB13zWoFZSsvWM6RbdX40Y2
	ACdPcOkFo1OgmR4tPClx3kSTp0VO9Ys=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH v2] bcachefs: Simplify code in bch2_dev_alloc()
Date: Wed, 16 Oct 2024 09:49:11 +0800
Message-Id: <20241016014911.1555607-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

- Remove unnecessary variable 'ret'.
- Remove unnecessary bch2_dev_free() operations.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
v2: Keep the 'goto err' style.

 fs/bcachefs/super.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 843431e58cf5..872e3d144fc4 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1352,7 +1352,6 @@ static int bch2_dev_alloc(struct bch_fs *c, unsigned dev_idx)
 {
 	struct bch_member member = bch2_sb_member_get(c->disk_sb.sb, dev_idx);
 	struct bch_dev *ca = NULL;
-	int ret = 0;
 
 	if (bch2_fs_init_fault("dev_alloc"))
 		goto err;
@@ -1364,10 +1363,8 @@ static int bch2_dev_alloc(struct bch_fs *c, unsigned dev_idx)
 	ca->fs = c;
 
 	bch2_dev_attach(c, ca, dev_idx);
-	return ret;
+	return 0;
 err:
-	if (ca)
-		bch2_dev_free(ca);
 	return -BCH_ERR_ENOMEM_dev_alloc;
 }
 
-- 
2.34.1

