Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52133E1;
	Wed, 30 Oct 2024 07:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730274509; cv=none; b=UB1u8gJmuUj9lnKlxOICeOwSSrUSdQ60RgCBSFYr9XgR2nZRkehLCvTLjutyo7BU/o0kj2LRSIksHsHGy724Oa1g0TBEmpAiC/GTHtJVqhyKHsB6xD4ej1BRj+I2R2VVKcFtf3BXI4/O7N9iCXU6oWl8ZBd0S17uXWQOCtiEx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730274509; c=relaxed/simple;
	bh=zgrcuii+dONmnswhpmdyAbLbKY9uQiQTHA6oWpE7Jjw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u6HstFd2TZsG1Vm0Mhbx2CVd/m2sZc6W0J4RYwMIU/OeqLbvV7NtM0+bJ0U0nmoWcjiDPt5offm929vM/SzA03vz3GWbdXU3IK4sFEHRbLsDkdu6vc9hXGhVDfxqrQVxekaR2uHTHPqWo3UmBMBNr79SHmE8BTtTMZ+om8frHdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4cca717a969311efa216b1d71e6e1362-20241030
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:9435e48c-8425-4318-b54a-c94f18876a44,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-INFO: VERSION:1.1.38,REQID:9435e48c-8425-4318-b54a-c94f18876a44,IP:0,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:20
X-CID-META: VersionHash:82c5f88,CLOUDID:ce7a18d0f740f08b99df7193f23c9d9a,BulkI
	D:241030154809TXDADSN4,BulkQuantity:0,Recheck:0,SF:19|66|841|38|17|102,TC:
	nil,Content:0,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 4cca717a969311efa216b1d71e6e1362-20241030
X-User: xiaopei01@kylinos.cn
Received: from xiaopei-pc.. [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1246014829; Wed, 30 Oct 2024 15:48:06 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: xiaopeitux@foxmail.com,
	Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] bcachefs: add check NULL return of bio_kmalloc in journal_read_bucket
Date: Wed, 30 Oct 2024 15:48:01 +0800
Message-Id: <62a857230cd1bf17105fb7d3858b3c22098573d3.1730274320.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bio_kmalloc may return NULL, will cause NULL pointer dereference.
Add check NULL return for bio_kmalloc in journal_read_bucket.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: ac10a9611d87 ("bcachefs: Some fixes for building in userspace")
---
 fs/bcachefs/errcode.h    | 1 +
 fs/bcachefs/journal_io.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index f2736e830007..ae75cb0a842c 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -83,6 +83,7 @@
 	x(ENOMEM,			ENOMEM_fs_other_alloc)			\
 	x(ENOMEM,			ENOMEM_dev_alloc)			\
 	x(ENOMEM,			ENOMEM_disk_accounting)			\
+	x(ENOMEM,                       ENOMEM_journal_read_bucket)             \
 	x(ENOSPC,			ENOSPC_disk_reservation)		\
 	x(ENOSPC,			ENOSPC_bucket_alloc)			\
 	x(ENOSPC,			ENOSPC_disk_label_add)			\
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index fcb68f111079..667a2bb9e20b 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1014,6 +1014,8 @@ static int journal_read_bucket(struct bch_dev *ca,
 			nr_bvecs = buf_pages(buf->data, sectors_read << 9);
 
 			bio = bio_kmalloc(nr_bvecs, GFP_KERNEL);
+			if (!bio)
+				return -BCH_ERR_ENOMEM_journal_read_bucket;
 			bio_init(bio, ca->disk_sb.bdev, bio->bi_inline_vecs, nr_bvecs, REQ_OP_READ);
 
 			bio->bi_iter.bi_sector = offset;
-- 
2.34.1

