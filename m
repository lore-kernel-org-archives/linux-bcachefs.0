Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425D2A2;
	Mon, 20 Nov 2023 17:05:20 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VwqVgP7_1700528717;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VwqVgP7_1700528717)
          by smtp.aliyun-inc.com;
          Tue, 21 Nov 2023 09:05:18 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: kent.overstreet@linux.dev,
	bfoster@redhat.com
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: clean up one inconsistent indenting
Date: Tue, 21 Nov 2023 09:05:15 +0800
Message-Id: <20231121010515.89897-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs/bcachefs/journal_io.c:1843 bch2_journal_write_pick_flush() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7585
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/journal_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index b061d77b2430..85f780796ac6 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1839,7 +1839,7 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
 	    (!w->must_flush &&
 	     (jiffies - j->last_flush_write) < msecs_to_jiffies(c->opts.journal_flush_delay) &&
 	     test_bit(JOURNAL_MAY_SKIP_FLUSH, &j->flags))) {
-		     w->noflush = true;
+		w->noflush = true;
 		SET_JSET_NO_FLUSH(w->data, true);
 		w->data->last_seq	= 0;
 		w->last_seq		= 0;
-- 
2.20.1.7.g153144c

