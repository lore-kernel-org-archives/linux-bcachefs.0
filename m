Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE461459EA
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 04:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734062610; cv=none; b=DDBpwUsXEUB0RYu6xli6BAphNNMXd2trrEfoGMxXmTdjCBCbbmvXITE4h5XDdrw7XVafBnER1rSeZHhEBsjuuFx+zytlVL+5e2J17M8nxVWrexYjkVtuuezjv4n2wLZarzsjt7BNHJGAXAQ2uD+P+3zAUGQ5EeTDc4EIOaxYeco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734062610; c=relaxed/simple;
	bh=QnrZEH7As3bH2USBH4YcLaR1ERB/FvHg+emWL4a4N0I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBnGvz2rJcT4mjVdPoBIeD1n+Nt/F8YIwdwPzAEmUKIKHJASj3M4McZCnZPeXKuYkUHrRuKXpEiSRS/SrIuGjZ7dS0munXqT9UQceXctpwU49KxO/TtTqar2N2Tod5HCgNzLWwLeBH2xsbmP9FXY/sxr8SLxjf2cVRYXbQNqmMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Y8bGL0P5dzyNFJ;
	Fri, 13 Dec 2024 12:00:26 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id EA297140155;
	Fri, 13 Dec 2024 12:03:19 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemo500009.china.huawei.com
 (7.202.194.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 13 Dec
 2024 12:03:19 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lihongbo22@huawei.com>, <linux-bcachefs@vger.kernel.org>
Subject: [PATCH v3 1/3] bcachefs: add printbuf_err helper
Date: Fri, 13 Dec 2024 12:03:26 +0800
Message-ID: <20241213040328.2921159-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213040328.2921159-1-lihongbo22@huawei.com>
References: <20241213040328.2921159-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemo500009.china.huawei.com (7.202.194.199)

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

