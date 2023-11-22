Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547E41BB;
	Tue, 21 Nov 2023 16:43:48 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vwu56KS_1700613825;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vwu56KS_1700613825)
          by smtp.aliyun-inc.com;
          Wed, 22 Nov 2023 08:43:46 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove unneeded semicolon
Date: Wed, 22 Nov 2023 08:43:44 +0800
Message-Id: <20231122004344.72783-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

./fs/bcachefs/btree_write_buffer.c:285:63-64: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7602
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/btree_write_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index dce61d3949f3..e01664f10a8e 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -282,7 +282,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 			struct btree_write_buffered_key *n = &wb->flushing.keys.data[i[1].idx];
 
 			skipped++;
-			n->journal_seq = min_t(u64, n->journal_seq, k->journal_seq);;
+			n->journal_seq = min_t(u64, n->journal_seq, k->journal_seq);
 			k->journal_seq = 0;
 			continue;
 		}
-- 
2.20.1.7.g153144c

