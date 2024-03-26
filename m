Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0764F12838F
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Mar 2024 04:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425928; cv=none; b=dYndb4w0YWoSN7x4UZvE6VUb6k9UKIyPi/JEnomdWIK+b2kYTOr1IlUjsVutvQPrn6uvukr8Jo1wrK0UTIMWHRAQC/OKBsTB3emrcO98lDpN6MAzl1h8NWlsOS++Pyyo7eNskZDK6D09TAA46OEHu4usNfAN0hH8TkPTsmQo0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425928; c=relaxed/simple;
	bh=iiCrtTLiBFnJi+uyL3PPzwIHl9cQzLfLgSHaNWxwgiU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jOfAnnM6VALRKvSZ3dnGgonuwheRGnrnbA/OGFB3euZmmV/MFLsJxvvoGhR9pP+uMhFMNTkQttC5vJ7CIVXkU8sal3iwGdDF6tEEq1w2yHOeFK4EQQeqF7e+DCEqLwKPhHTe46ft9ldJARkr3cs3AMb5yiMbJFE/ghSAPZOO1TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4V3bjY1sVTz2BhgV;
	Tue, 26 Mar 2024 12:02:25 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id AD620140120;
	Tue, 26 Mar 2024 12:05:03 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 26 Mar
 2024 12:05:03 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: fix the count of nr_freed_pcpu after changing bc->freed_nonpcpu list
Date: Tue, 26 Mar 2024 12:04:56 +0800
Message-ID: <20240326040456.2587357-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

When allocating bkey_cached from bc->freed_pcpu list, it missed
decreasing the count of nr_freed_pcpu which would cause the mismatch
between the value of nr_freed_pcpu and the list items. This problem
also exists in moving new bkey_cached to bc->freed_pcpu list.
If these happened, the bug info may appear in
bch2_fs_btree_key_cache_exit by the follow code:

   BUG_ON(list_count_nodes(&bc->freed_pcpu) != bc->nr_freed_pcpu);
   BUG_ON(list_count_nodes(&bc->freed_nonpcpu) != bc->nr_freed_nonpcpu);

Fixes: c65c13f0eac6 ("bcachefs: Run btree key cache shrinker less aggressively")
Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/btree_key_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 581edcb0911b..e1031b9ba3f4 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -169,6 +169,7 @@ static void bkey_cached_move_to_freelist(struct btree_key_cache *bc,
 	} else {
 		mutex_lock(&bc->lock);
 		list_move_tail(&ck->list, &bc->freed_pcpu);
+		bc->nr_freed_pcpu++;
 		mutex_unlock(&bc->lock);
 	}
 }
@@ -245,6 +246,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path,
 		if (!list_empty(&bc->freed_pcpu)) {
 			ck = list_last_entry(&bc->freed_pcpu, struct bkey_cached, list);
 			list_del_init(&ck->list);
+			bc->nr_freed_pcpu--;
 		}
 		mutex_unlock(&bc->lock);
 	}
-- 
2.34.1

