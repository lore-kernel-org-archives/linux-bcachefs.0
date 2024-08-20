Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3C620B28;
	Tue, 20 Aug 2024 01:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724116802; cv=none; b=IsIUw7c5yg0MoFjkFOL3v5g8EO3R6LNMEpI1bmOI9tS2Mf+2su7NDWuqRnYK0qo+kHV4ihU+QXLWtpsR0ZQIR918VUcAvqKsBP8hX099UU/w1hBU6iXwb2u4ciDqYCm8YJcDkK4N+6mwmvxsrkvXbeVcCskgS0htnaWU6WP8Nl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724116802; c=relaxed/simple;
	bh=6X9CzpXb9qOaMMS9TlDooD7JnjCYCgjuuiRwyFhWWPU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EPh4YJ2KvfAn2uPlsomptCBAe8lpFGyMX1RkFSpalN1qd3+LT/d1vRmuKQl0f9Pg2VdKOWEFOUBux5YkGvAO8HREMgvuapIUkwRKeCNoQg9+ETNhb7Zyw36jq4W2opi4G9EcrD4Rl7MMN5tQiCmt+EqBf7o2zU/P3bwF8sMJtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wns2N4sF7z1j6m6;
	Tue, 20 Aug 2024 09:14:52 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id ADCC51400D6;
	Tue, 20 Aug 2024 09:19:51 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 20 Aug
 2024 09:19:51 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <kent.overstreet@linux.dev>
CC: <lizetao1@huawei.com>, <linux-bcachefs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH -next 2/2] bcachefs: Remove redundant check before free in bch2_ioctl_disk_add()
Date: Tue, 20 Aug 2024 09:27:18 +0800
Message-ID: <20240820012718.4121485-2-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820012718.4121485-1-lizetao1@huawei.com>
References: <20240820012718.4121485-1-lizetao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd500012.china.huawei.com (7.221.188.25)

Since the variable path has been checked after strndup_user() and
will not be reassigned during use, so it does not need to be checked
again before free.

No functional change intended.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 fs/bcachefs/chardev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index c315421bee85..ea84aaa7a143 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -320,8 +320,7 @@ static long bch2_ioctl_disk_add(struct bch_fs *c, struct bch_ioctl_disk arg)
 		return PTR_ERR(path);
 
 	ret = bch2_dev_add(c, path);
-	if (!IS_ERR(path))
-		kfree(path);
+	kfree(path);
 
 	return ret;
 }
-- 
2.34.1

