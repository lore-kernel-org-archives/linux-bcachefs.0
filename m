Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DBB12CD89
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Oct 2024 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728720000; cv=none; b=dVQRLhlaJfh4O7w2jGUZSatBeHot7e1EFMhObsn+B27QXrbDFtOpyXBN27JJIZA280PXkzsJji2+S13+WrbDjRJUdrpxsSWUzgQ333bMeNo8+HRbM0adKTGFHQVe0JsftJXw2VsSXK35585cZ1MZ8I2B6Fn2TNqY99tNCBcwNg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728720000; c=relaxed/simple;
	bh=hidQtmxS29xCEyKsKyT8KsHCYfjKw1GXkB60losP1cs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=frpUPRTei8AhGkqjlNIekycavnvCaNpqoZWLJdqfdVIpu/wDUKmV8hqJKKZiwhJU5vhCMJU65jRsPGZG85PisxfgAphfE2s6oVjZb4wCT2Bat0hpSDTuRSwgrmQ7Fjg+PrtzJBv5y9AwTbJ6GphJn7Rp6RGIJuNfEd0d8v0DXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wHBHpmYN; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wHBHpmYN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728719997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d4M9lxcrAKYCq8myB8vTjyEkmRlgVaVn4DCARZsfUBs=;
	b=wHBHpmYNDFPMJlUQnw0xdILSVFI+5Fwnfsy19hc0L6Tv57dwVgfYDZpgnH20l1+N21gEeL
	gZ7CDOjS3J3AR/2hlpSG5yT+1Bl8F1Ngw3aZASOe7Lcr/csvOYM/FUJ24vK0GCaJ9NuWL3
	vNvQ8vdsvsqmFSptpbJfh6qqB11y2tw=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Simplify code in bch2_dev_alloc()
Date: Sat, 12 Oct 2024 15:59:02 +0800
Message-Id: <20241012075902.1320946-1-youling.tang@linux.dev>
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
 fs/bcachefs/super.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 843431e58cf5..a0e01443008b 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1352,23 +1352,20 @@ static int bch2_dev_alloc(struct bch_fs *c, unsigned dev_idx)
 {
 	struct bch_member member = bch2_sb_member_get(c->disk_sb.sb, dev_idx);
 	struct bch_dev *ca = NULL;
-	int ret = 0;
 
-	if (bch2_fs_init_fault("dev_alloc"))
-		goto err;
+	if (bch2_fs_init_fault("dev_alloc")) {
+		bch_err(c, "dev_alloc fault injected");
+		return -EFAULT;
+	}
 
 	ca = __bch2_dev_alloc(c, &member);
 	if (!ca)
-		goto err;
+		return -BCH_ERR_ENOMEM_dev_alloc;
 
 	ca->fs = c;
 
 	bch2_dev_attach(c, ca, dev_idx);
-	return ret;
-err:
-	if (ca)
-		bch2_dev_free(ca);
-	return -BCH_ERR_ENOMEM_dev_alloc;
+	return 0;
 }
 
 static int __bch2_dev_attach_bdev(struct bch_dev *ca, struct bch_sb_handle *sb)
-- 
2.34.1

