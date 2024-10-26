Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FB1C3301
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 10:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729938425; cv=none; b=RukLC4QxG7i4jquZwTx+m7oy6Q7jBUz3GxHr8NmjVwQe5ujpF+9mp6+VubX0FUQcbLMsQ3w1TvpRAVVX6QsJvLtjyHEJlCpuDsE9G+lOFQvqJ0wv2BJoQmkOMB/jRmxB2RFa6zEDATnElOmiE9FTy15Pwso37Zh7ZhTKTSt2rkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729938425; c=relaxed/simple;
	bh=V+rwDCdH36r0nlyU5l3+NmpUjs3LKBdjT9RLLRzXjDc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O+vwE2VWq6GPR+Ris7r0Qi/LPg/Y6YJqbgiGofNiyHD5AVYWKZ4V3a+PdziMPhABrYiJ/ARQ7/r14Sb0+BpqoKXb1gCp8q41qw2AlV+ZHkXIdb7z2g7xZn2SZDH5txNW8zGRLMzt2H7RYRFLHgsaTc1BZg8boEqAD4RE31jEYCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XbG461lxBz1T96L;
	Sat, 26 Oct 2024 18:24:54 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id C8B941400DC;
	Sat, 26 Oct 2024 18:26:59 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 26 Oct 2024 18:26:59 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <kent.overstreet@linux.dev>, <cuigaosheng1@huawei.com>,
	<wangweiyang2@huawei.com>
CC: <linux-bcachefs@vger.kernel.org>
Subject: [PATCH -next] bcachefs: fix possible null-ptr-deref in __bch2_ec_stripe_head_get()
Date: Sat, 26 Oct 2024 18:26:58 +0800
Message-ID: <20241026102658.1184351-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200011.china.huawei.com (7.221.188.251)

The function ec_new_stripe_head_alloc() returns nullptr if kzalloc()
fails. It is crucial to verify its return value before dereferencing
it to avoid a potential nullptr dereference.

Fixes: 035d72f72c91 ("bcachefs: bch2_ec_stripe_head_get() now checks for change in rw devices")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 fs/bcachefs/ec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 25d20f73df60..b24089733467 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1859,6 +1859,10 @@ __bch2_ec_stripe_head_get(struct btree_trans *trans,
 		}
 
 	h = ec_new_stripe_head_alloc(c, disk_label, algo, redundancy, watermark);
+	if (!h) {
+		h = ERR_PTR(-ENOMEM);
+		goto err;
+	}
 found:
 	if (h->rw_devs_change_count != c->rw_devs_change_count)
 		ec_stripe_head_devs_update(c, h);
-- 
2.25.1

