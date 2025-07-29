Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95A7FBA1;
	Tue, 29 Jul 2025 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753154; cv=none; b=RcZWRnw+L/7e+tpeDsX5QNi7fgoxFWBR72b0xDk9jrQ395hnv8ZBVEu7pLlxn1fy9/pXib9TZ7C7p7fkhZHC31R/oFYJSWYhFmrkTUYq7Z/2b7J2rbkAu6Kca4l3K7UHjbUSJQTfELo7VcanMtL2tjB09NmWYp27t9oOXnndYpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753154; c=relaxed/simple;
	bh=YerietG5fqamTEKIpWTDCkzpBEJHMsVaRP1qKczDb4I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZXr1RKmK+RIvQLV5/tYb88xwup9OFr82IY8gZUtt+naqKiGZv4JgwWBKivAiD+95OBTTMsoC2mA9MUdZG3VYgNYkN9+AN+dzpB5hFSdV9pESWxMFYGglqiqIHV0wkga/Nu6wxpLPgwrejGA6VoF5LpNwwkek/NmjWjqy7E6gtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-01 (Coremail) with SMTP id qwCowACn06c0Joho8RnRBw--.63454S2;
	Tue, 29 Jul 2025 09:39:00 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] bcachefs: Convert comma to semicolon
Date: Tue, 29 Jul 2025 09:36:41 +0800
Message-Id: <20250729013641.1229554-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACn06c0Joho8RnRBw--.63454S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4rCw4kuw4kuw1xGrW3ZFb_yoWDWrX_WF
	n5XFs7uF4Sqr12qr45urn0ga90g34Uur1xXa1Iya90kay7Ja17Wrnxur4xJ345tr40kr13
	KrZ8t3yFkF97CjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbs8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJV
	W0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43
	ZEXa7VUjFfO5UUUUU==
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace comma between expressions with semicolons.

Using a ',' in place of a ';' can have unintended side effects.
Although that is not the case here, it is seems best to use ';'
unless ',' is intended.

Found by inspection.
No functional change intended.
Compile tested only.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/bcachefs/btree_node_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 4b7b5ca74ba1..ca289d60aebe 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -193,7 +193,7 @@ static void try_read_btree_node(struct find_btree_nodes *f, struct bch_dev *ca,
 		 * any bset; read_done sorts down to a single set and picks the
 		 * max journal_seq
 		 */
-		n.journal_seq		= le64_to_cpu(bn->keys.journal_seq),
+		n.journal_seq		= le64_to_cpu(bn->keys.journal_seq);
 		n.sectors_written	= b->written;
 
 		guard(mutex)(&f->lock);
-- 
2.25.1

