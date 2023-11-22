Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3530198;
	Tue, 21 Nov 2023 18:26:41 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VwuNqXE_1700619988;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VwuNqXE_1700619988)
          by smtp.aliyun-inc.com;
          Wed, 22 Nov 2023 10:26:39 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] bcachefs: make __bch2_read_super static
Date: Wed, 22 Nov 2023 10:26:27 +0800
Message-Id: <20231122022627.53229-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The __bch2_read_super are not used outside the file super-io.c,
so the modification is defined as static.

fs/bcachefs/super-io.c:661:5: warning: no previous prototype for ‘__bch2_read_super’.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7604
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/bcachefs/super-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index f90fc7a4c26f..e78270e82fa8 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -658,7 +658,7 @@ static int read_one_super(struct bch_sb_handle *sb, u64 offset, struct printbuf
 	return 0;
 }
 
-int __bch2_read_super(const char *path, struct bch_opts *opts,
+static int __bch2_read_super(const char *path, struct bch_opts *opts,
 		    struct bch_sb_handle *sb, bool ignore_notbchfs_msg)
 {
 	u64 offset = opt_get(*opts, sb);
-- 
2.20.1.7.g153144c

