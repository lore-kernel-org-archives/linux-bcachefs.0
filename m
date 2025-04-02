Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E9A367;
	Wed,  2 Apr 2025 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743601570; cv=none; b=FKiWrv+xkpE7q3Qe9dMPrWg1o6xV78mQMBSw1iMedPfLiq7Gotm3Lwvxj3s2xALYa+WbLKvSmI85+7ONU6hkcuPmFsqxgC+XzAHsowsjNE0gL+2fwoNi/h3s/o9UBQQE+9UXYY2gmXZriPbOQTiXXGj1b7LcJ0tmbDVr+9GD1Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743601570; c=relaxed/simple;
	bh=Q6TsAsf1PmVEMK/9Ux+9Xz91SJre9b2vU9MLqiHjI30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jJvvcKBA9P+6j7nchL9IkXck+MPBruhPiIZs4UFLTwzKxxZil9ma4po1f4QTIlm6jtrxs4r2h0Kw8hZOXJkjpBuOMWMm/9pethXK7b7DhYHC7Mrn4R5CYijeJvaEPzYF6n9Q1CkUM62o9/vBAqgxJ4vTllfdG1xzJ2TWNua6hUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowAD3mziYP+1nplkwBQ--.19456S2;
	Wed, 02 Apr 2025 21:46:02 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] bcachefs: Add error handling for zlib_deflateInit2()
Date: Wed,  2 Apr 2025 21:45:44 +0800
Message-ID: <20250402134544.3550-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAD3mziYP+1nplkwBQ--.19456S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GF4fCry8ZF4xtr47Aw47urg_yoWkAFc_KF
	s7XanF9ws5tF4j9r1DGrWvqrW29rWxCr47ZwsFqr9Iy34Yyw4fXrZ5K34kGr4UXry0k3W3
	W3srCry7JFy7ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjO6pDUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBg0AA2ftA5qZkAACsQ

In attempt_compress(), the return value of zlib_deflateInit2() needs to be
checked. A proper implementation can be found in  pstore_compress().

Add an error check and return 0 immediately if the initialzation fails.

Fixes: 986e9842fb68 ("bcachefs: Compression levels")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/bcachefs/compress.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index f99ff1819597..5af37c40cef0 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -365,13 +365,14 @@ static int attempt_compress(struct bch_fs *c,
 		};
 
 		zlib_set_workspace(&strm, workspace);
-		zlib_deflateInit2(&strm,
+		if (zlib_deflateInit2(&strm,
 				  compression.level
 				  ? clamp_t(unsigned, compression.level,
 					    Z_BEST_SPEED, Z_BEST_COMPRESSION)
 				  : Z_DEFAULT_COMPRESSION,
 				  Z_DEFLATED, -MAX_WBITS, DEF_MEM_LEVEL,
-				  Z_DEFAULT_STRATEGY);
+				  Z_DEFAULT_STRATEGY) != Z_OK)
+			return 0;
 
 		if (zlib_deflate(&strm, Z_FINISH) != Z_STREAM_END)
 			return 0;
-- 
2.42.0.windows.2

