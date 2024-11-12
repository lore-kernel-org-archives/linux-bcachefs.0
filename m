Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E50B20B1E1
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 07:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397692; cv=none; b=PfjytlVe+E7KdSYUV/Ai7odwO9RTprqMvkp9rtZEmfiMr+yg3sLgUqWRB9q8n8+P8kvM6rAlbAPO/6ymyXIro25tAVMz22HE1Y5MrvBzcw4WV3u8uBFZWbk/f01xHPznp6pRuz7wvj850yqSIGeAMXzvwVIWJOlEn5i1y7wENVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397692; c=relaxed/simple;
	bh=QnrZEH7As3bH2USBH4YcLaR1ERB/FvHg+emWL4a4N0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cxG4DtsZs5pDdYaf8pQWLeLP00rjXLsVgN+AD18PE8c8jRrMa71QBx/qvL9Px+E3CjsaZncrI2JCxPNXKkxyhiBUCN6np8RI289AZUza2rCjxkgpe4S3HPTlgyGVI34RcgPKbFHgFAEtCZZa9WNW6/ozoh/1dZZNLWbdU2pzmmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XndlD5HGWz1SGGP;
	Tue, 12 Nov 2024 15:46:16 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E26B41A016C;
	Tue, 12 Nov 2024 15:48:05 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 12 Nov
 2024 15:48:05 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH v2 1/3] bcachefs: add printbuf_err helper
Date: Tue, 12 Nov 2024 15:47:43 +0800
Message-ID: <20241112074745.407848-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241112074745.407848-1-lihongbo22@huawei.com>
References: <20241112074745.407848-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)

This helper makes buffer allocation return standard error when
allocation failure.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/printbuf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/bcachefs/printbuf.h b/fs/bcachefs/printbuf.h
index 1d570387b77f..73da89c9e419 100644
--- a/fs/bcachefs/printbuf.h
+++ b/fs/bcachefs/printbuf.h
@@ -139,6 +139,11 @@ void bch2_prt_bitflags_vector(struct printbuf *, const char * const[],
 	.size	= _size,				\
 })
 
+static inline int printbuf_err(struct printbuf *out)
+{
+	return out->allocation_failure ? -ENOMEM : 0;
+}
+
 /*
  * Returns size remaining of output buffer:
  */
-- 
2.34.1

