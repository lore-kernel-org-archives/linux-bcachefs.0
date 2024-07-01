Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95902C80;
	Mon,  1 Jul 2024 03:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719804475; cv=none; b=psk7aJwsgL3odu639VT4E0UjI+Hp8R3sNBHRKc8ijiqP4zWzouTMgxtmBbfYuGqnqvP4CuBZUkQRd318wmTFf9BdN+kJd1S9dv+2T+6IYjT9jeK3cofN0ZqGR1AHZeGr7LBbIk5jfZ8d3fEZTncUDdC6zKmw43wGRv1a4v5Wt2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719804475; c=relaxed/simple;
	bh=U4YKk2/RIAdPOUFT4EWxpHc7mtWD4SYrc8cQnfrDx0s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iay9qy7x3VeM6xfieF9fL80t8WWlVUkhaQuRZTCSP2tYPnfU7XCPNlaWAA1aGcYhV/10aSN5wZyyBWIz+8dVgOCmQvSzocgl5n+OEIMoswNN2V5ZXSDc4gHvXkQUFeDBSZ7KozOehQtUvAHY0b+T9W4dPA13Dm62WU1I7mVe5no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-01 (Coremail) with SMTP id qwCowABXXsotIoJmNz_wAA--.1270S2;
	Mon, 01 Jul 2024 11:27:41 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] bcachefs: Remove unneeded semicolon
Date: Mon,  1 Jul 2024 11:27:36 +0800
Message-Id: <20240701032736.281451-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowABXXsotIoJmNz_wAA--.1270S2
X-Coremail-Antispam: 1UD129KBjvdXoWruFW5Gr1rXw1DXw1DXF4DCFg_yoWDJwc_ur
	n2yF1UJFWrZrnYvr17uw45Xr4093y7Z3W7KFy0kF9xGwsxJw13Zr97Xr1DAr4fXrZ8Gas3
	GrW3X3sxZryUCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbc8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r48
	MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
	0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
	W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
	cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUnpnQUUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Remove unneeded semicolon.
This is detected by coccinelle.

Fixes: 0d529663f04b ("bcachefs: Split brain detection")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/bcachefs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index bf7e998603f1..62dfaf60c131 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1116,12 +1116,12 @@ static int bch2_dev_in_fs(struct bch_sb_handle *fs,
 
 		prt_bdevname(&buf, fs->bdev);
 		prt_char(&buf, ' ');
-		bch2_prt_datetime(&buf, le64_to_cpu(fs->sb->write_time));;
+		bch2_prt_datetime(&buf, le64_to_cpu(fs->sb->write_time));
 		prt_newline(&buf);
 
 		prt_bdevname(&buf, sb->bdev);
 		prt_char(&buf, ' ');
-		bch2_prt_datetime(&buf, le64_to_cpu(sb->sb->write_time));;
+		bch2_prt_datetime(&buf, le64_to_cpu(sb->sb->write_time));
 		prt_newline(&buf);
 
 		if (!opts->no_splitbrain_check)
-- 
2.25.1

