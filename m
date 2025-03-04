Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C82BA38;
	Tue,  4 Mar 2025 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741061031; cv=none; b=rVbi6GXxYcCLSirnJm4zwoVZppva5VSZJ0RTeQrSJ1SCsnuVJi4gYnoPRxnsLXcMubpRJtn0BacHY/5L2OMSsP37E2tS2MzbFfgBDf6tzl6IHHQ2Jt1Z2xEK+vC4pWXlxjoaY0Wg2ZtlCRhdZ2nnnaSlkL3EL0GQuJRpHufkdeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741061031; c=relaxed/simple;
	bh=L+DcmApLOKfTDlb+sBGuWJsudO3OdyQhKhrYJdRIBcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r2SY5rW/rUBS1noPZEmtctdVb1NmJWXT6dbp+VQS3Z0oJdJZEQHPqliaL0PA38xNMUBJBTpu6VnapGST3CSka8Of7Px93p/xh5v/r/TLeqQGm4aBote0Zsd83chrVLgBlu3DW4TZU4QDBc3DA6kf9/Bx+U/MWneXa9beQLQP4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowAB3f2+Pe8ZnQL06Eg--.36838S2;
	Tue, 04 Mar 2025 12:03:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] bcachefs: Add error handling for bch2_folio()
Date: Tue,  4 Mar 2025 12:03:11 +0800
Message-ID: <20250304040311.2081-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAB3f2+Pe8ZnQL06Eg--.36838S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF1kAr4Uur1UArWkAw4xZwb_yoW3Wwb_W3
	WrJa1UWw4fKFyUtr17ZFW7ZrZ0v34Fyr4S9F48KF47ua4kt34ftws0yr1UZ3yI9rWrGa98
	KFyYvr95ArW7CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbwAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUywZ7UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAgLA2fGYfVh0gAAsK

Add error handling for the case where bch2_folio() returns NULL
in __bch2_folio_set(). Return immediately to prevent null pointer
dereference.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 fs/bcachefs/fs-io-pagecache.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index e072900e6a5b..1dc65fef3ff4 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -159,6 +159,9 @@ static void __bch2_folio_set(struct folio *folio,
 	struct bch_folio *s = bch2_folio(folio);
 	unsigned i, sectors = folio_sectors(folio);
 
+	if (!s)
+		return;
+
 	BUG_ON(pg_offset >= sectors);
 	BUG_ON(pg_offset + pg_len > sectors);
 
-- 
2.42.0.windows.2

