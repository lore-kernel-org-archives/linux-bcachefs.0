Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD9CD515
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 11:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729423280; cv=none; b=Ralqwxo/Jb19Q/OSs22ki+PS2yeIb27v4g8d5AcAgcu+qAqjWeF9IUJ4S1tUyqr1IiIqPCBckFs4E8qTbukLMMr1ZNaDzHftK+zja8BVbtWcylW6+PLgoCTFln7K5BxVOMAWEk+2uRMc77leaKw+2/iLEOuVSTPyq8RRMvmuyCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729423280; c=relaxed/simple;
	bh=uyuBjAjZ0sxvvzxhUBFI4y6tyi92YEmGG0VriZlQLPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p7dS8TeAmrduGxF8QbXktzIrQhlbZQ4zqAQSxw5hKn2bpahxEEeaqXAgcO4kmnGYHLZeuz0pV/b0fiTezptcbfssBv2vTh22WWg5IBRsusIpc/xAyBp8vjB9UjRaxthjEewdxtG4v2z/nC2pg00hL0OBUeqFp+wYSpcsNfYxgjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kFvZmpFE; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kFvZmpFE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729423273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rpC4QRPnAGJa+dqvOlD/KYtzd/kQ+bx31mYC0wNOAso=;
	b=kFvZmpFEY4NjhmLT6xEx2yRWmgMNmfJZ9bFy+Td9HETx/17c0pojTibsMcEejXTyzgiqpi
	5kG27XWQuP1Bq4+Y4UFxo3iT9IzotKjn4OVqXDoOp+oy5rtLNahSSSByZYrSthYB2ecR0j
	Sa2sWbV2Fkdz7RKLUqg6OZaAs1rwW/U=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcachefs: Use str_write_read() helper in ec_block_endio()
Date: Sun, 20 Oct 2024 13:20:46 +0200
Message-ID: <20241020112046.52890-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the helper function str_write_read().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/bcachefs/ec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index e410cfe37b1a..26b1664adb4d 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -26,6 +26,7 @@
 #include "util.h"
 
 #include <linux/sort.h>
+#include <linux/string_choices.h>
 
 #ifdef __KERNEL__
 
@@ -732,7 +733,7 @@ static void ec_block_endio(struct bio *bio)
 			       ? BCH_MEMBER_ERROR_write
 			       : BCH_MEMBER_ERROR_read,
 			       "erasure coding %s error: %s",
-			       bio_data_dir(bio) ? "write" : "read",
+			       str_write_read(bio_data_dir(bio)),
 			       bch2_blk_status_to_str(bio->bi_status)))
 		clear_bit(ec_bio->idx, ec_bio->buf->valid);
 
-- 
2.47.0

