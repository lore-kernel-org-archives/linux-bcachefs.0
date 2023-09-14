Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF0EEDE99C
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 09:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbjINJFb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbjINJFa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 05:05:30 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A2CC7;
        Thu, 14 Sep 2023 02:05:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vs215Tz_1694682300;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Vs215Tz_1694682300)
          by smtp.aliyun-inc.com;
          Thu, 14 Sep 2023 17:05:23 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kent.overstreet@linux.dev
Cc:     bfoster@redhat.com, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 9/9] bcachefs: Modify mismatched function name
Date:   Thu, 14 Sep 2023 17:04:49 +0800
Message-Id: <20230914090457.32325-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

No functional modification involved.

fs/bcachefs/alloc_foreground.c:514: warning: expecting prototype for bch_bucket_alloc(). Prototype was for bch2_bucket_alloc_trans() instead.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=6584
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/bcachefs/alloc_foreground.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index e02749ddc362..10a7979707ef 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -502,7 +502,7 @@ static struct open_bucket *bch2_bucket_alloc_freelist(struct btree_trans *trans,
 }
 
 /**
- * bch_bucket_alloc - allocate a single bucket from a specific device
+ * bch2_bucket_alloc_trans - allocate a single bucket from a specific device
  *
  * Returns index of bucket on success, 0 on failure
  */
-- 
2.20.1.7.g153144c

