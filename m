Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21D013FF9;
	Tue, 16 Jul 2024 04:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721102631; cv=none; b=psMkCFFwMcgYkymjSQzpDClXETl3cvVQDiQ/CEXtzel3I5tXv4YRVXrXlSEyqDpXHzaqhG+BIHuJgE9OnOEjxObMNRva7ffojna7tcEZAtfl1nEd0RJbaDIgLPxE+1oqXQ7Ee8sBFAUdnKYgkprScCde2HDSYXkqbrSNb4UjLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721102631; c=relaxed/simple;
	bh=rgKIkcoiwfdnol1szttuDCQ2hA8ot8inCQwACEmLXyk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tfz4g6hQZQqXC7G1acXg4H84JCRpiaNO9uFej0Tkn7oMaaotCT6RBNqzX+mPEIfD6I8IkghawF3t8KSDXpEElfVsRMTHNOCa/kr71GLtQUUP32PSyJwvLLD3VPAQo2jJav3CwFv5etlM7EOFrm1/vSTH/EI31u7wvbey7PwIDj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowAD3_1sY8ZVmn+77FQ--.19522S2;
	Tue, 16 Jul 2024 12:03:36 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ni <nichen@iscas.ac.cn>
Subject: [PATCH] bcachefs: Convert comma to semicolon
Date: Tue, 16 Jul 2024 12:03:02 +0800
Message-Id: <20240716040302.684034-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAD3_1sY8ZVmn+77FQ--.19522S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4UZrWkWFWrZFykWF4UArb_yoWDXwb_WF
	Z2qF43Kan3trsY93yDuFn3urW2g3409r12g392vFyrGa47JFW3Xr93WrZ3Xr18J3ykG34a
	qry2qryYyr98ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
	0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
	Gryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU0WlkUUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

Replace a comma between expression statements by a semicolon.

Fixes: 79032b078173 ("bcachefs: Improved topology repair checks")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
---
 fs/bcachefs/btree_update_interior.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 31ee50184be2..51b43d75ddb6 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -96,7 +96,7 @@ int bch2_btree_node_check_topology(struct btree_trans *trans, struct btree *b)
 			bch2_topology_error(c);
 
 			printbuf_reset(&buf);
-			prt_str(&buf, "end of prev node doesn't match start of next node\n"),
+			prt_str(&buf, "end of prev node doesn't match start of next node\n");
 			prt_printf(&buf, "  in btree %s level %u node ",
 				   bch2_btree_id_str(b->c.btree_id), b->c.level);
 			bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&b->key));
-- 
2.25.1

