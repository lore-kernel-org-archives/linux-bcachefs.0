Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31A510F5
	for <linux-bcachefs@vger.kernel.org>; Wed, 15 Nov 2023 03:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500FEA7;
	Tue, 14 Nov 2023 19:13:44 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VwRJmGm_1700018010;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VwRJmGm_1700018010)
          by smtp.aliyun-inc.com;
          Wed, 15 Nov 2023 11:13:41 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] bcachefs: Remove the unused variable journal_flags
Date: Wed, 15 Nov 2023 11:13:29 +0800
Message-Id: <20231115031329.31138-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Variable journal_flags is not effectively used, so delete it.

fs/bcachefs/btree_update_interior.c:1057:11: warning: variable 'journal_flags' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7559
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/bcachefs/btree_update_interior.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 9affcb22d9cb..18e5a75142e9 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -1054,7 +1054,6 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 	unsigned nr_nodes[2] = { 0, 0 };
 	unsigned update_level = level;
 	enum bch_watermark watermark = flags & BCH_WATERMARK_MASK;
-	unsigned journal_flags = 0;
 	int ret = 0;
 	u32 restart_count = trans->restart_count;
 
@@ -1068,10 +1067,6 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 	flags &= ~BCH_WATERMARK_MASK;
 	flags |= watermark;
 
-	if (flags & BCH_TRANS_COMMIT_journal_reclaim)
-		journal_flags |= JOURNAL_RES_GET_NONBLOCK;
-	journal_flags |= watermark;
-
 	while (1) {
 		nr_nodes[!!update_level] += 1 + split;
 		update_level++;
-- 
2.20.1.7.g153144c

