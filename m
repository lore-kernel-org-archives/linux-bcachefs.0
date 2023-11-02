Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED4FC4167B
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 00:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbjKBAgO (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 20:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjKBAgN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 20:36:13 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F99124;
        Wed,  1 Nov 2023 17:36:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VvTiKF3_1698885362;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VvTiKF3_1698885362)
          by smtp.aliyun-inc.com;
          Thu, 02 Nov 2023 08:36:03 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] bcachefs: Remove unneeded semicolon
Date:   Thu,  2 Nov 2023 08:36:00 +0800
Message-Id: <20231102003600.94657-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

./fs/bcachefs/reflink.c:112:32-33: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7114
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/bcachefs/reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index eb31df605c2e..958d9ea718b0 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -109,7 +109,7 @@ static inline void check_indirect_extent_deleting(struct bkey_i *new, unsigned *
 	if ((*flags & BTREE_TRIGGER_INSERT) && !*bkey_refcount(new)) {
 		new->k.type = KEY_TYPE_deleted;
 		new->k.size = 0;
-		set_bkey_val_u64s(&new->k, 0);;
+		set_bkey_val_u64s(&new->k, 0);
 		*flags &= ~BTREE_TRIGGER_INSERT;
 	}
 }
-- 
2.20.1.7.g153144c

