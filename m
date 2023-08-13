Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C29C001DB
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjHMP4k (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjHMP42 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:56:28 -0400
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5893C3D
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:55:55 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-31427ddd3fbso3181672f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691942037; x=1692546837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HjnOjxtNn26bVAkpF7vD6W2rBDvQxvqWE+8UzHQLKWY=;
        b=M2EOycUBWgoUtdS2UqzQKG+lkaS/P0E3ZzAokS7qcBDJKYfxgHUxwPqCcYvsvjl4IZ
         qFGgoYvxs745R0imPm1xb0doU+csaPQhipeQMnKtZgFRR4OTPHYG9y0Yk+TzTsy8dBHt
         G32TaLRy5avl/yaZIJqFYnTfuHLXl5oMi4hqTld1MkIUt95/Oc/YFdm0/pvuieQmfue2
         zyn0lizp1ZDc3tg1b/0/oyl3hWCHRmDzyQeSiF5C6Lbrzvct06yuGFYyKon0lTXJ1vp4
         K0AAg0zyt1ntfweaM0lEk1GH3BS4mLMTNWKrXj6PouEYHSIloqCz9rR21j4JS3HWmvug
         RJQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691942037; x=1692546837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjnOjxtNn26bVAkpF7vD6W2rBDvQxvqWE+8UzHQLKWY=;
        b=joYE9oPT9Nt4wZSbjoCBPvrxyJtyjS/UuttYF75fVI9q7jP8nHeugoanmtVH3ACLjG
         1HBms5MDeqPxoyDFU8icF92q/hJqVZcs8wOnIoTsEUetpeA80Emodkr2gq5cXcbRh1Rf
         s/NAfidXHstaZJ+U8fA5yq1PyA48xHWaWFZvyQ0777/PzcuULH5sXOQahmogEHK5jFHJ
         zyE8rAohF+1sGC4qOQTKeamvUSaVmtAcK+U506M/xFfaGAobdmCf5ScQoa7OUjfVI2J3
         rN6V5Ip/BCJY1CJH7FOV6ZXu7vP1QzkjDI5kisMazlkMhmmKMocPW/ChQr0vuo4FG//9
         gPTw==
X-Gm-Message-State: AOJu0YybzSvft2ncjGUFwRf4VJGXeYNAMncYG/CMxOkfPAH3/r5Q4weB
        MNNZHLbHpSl3G4A/IeBYIUERLZqJUrRSRgNAk1A=
X-Google-Smtp-Source: AGHT+IElLJp2XaeA3x6ZiAAm77JhSODFpogM91r60XhX4lDnSHOSa7WheQ6UyuUzYQqsx4cC+afXnQ==
X-Received: by 2002:a5d:6b4c:0:b0:317:5f13:5c2f with SMTP id x12-20020a5d6b4c000000b003175f135c2fmr4522181wrw.0.1691942037158;
        Sun, 13 Aug 2023 08:53:57 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id 5-20020a05600c028500b003fe1ca92151sm11535097wmk.26.2023.08.13.08.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 08:53:56 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v2 rebase] bcachefs: Lower BCH_NAME_MAX to 512
Date:   Sun, 13 Aug 2023 16:53:45 +0100
Message-ID: <20230813155354.119364-1-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

To ensure we aren't shooting ourselves in the foot after merge for
potentially doing future revisions for dirent or for storing multiple
names for casefolding, limit this to 512 for now.

Previously this define was linked to the max size a d_name in
bch_dirent could be.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/bcachefs_format.h | 4 +---
 fs/bcachefs/dirent.c          | 6 +++++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 5ec218ee3569..23bae622309c 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -916,9 +916,7 @@ struct bch_dirent {
 #define DT_SUBVOL	16
 #define BCH_DT_MAX	17
 
-#define BCH_NAME_MAX	((unsigned) (U8_MAX * sizeof(__u64) -		\
-			 sizeof(struct bkey) -				\
-			 offsetof(struct bch_dirent, d_name)))
+#define BCH_NAME_MAX	512
 
 /* Xattrs */
 
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 6f9eb88c7dba..a7559ab03802 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -115,7 +115,11 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (d_name.len > BCH_NAME_MAX) {
+	/*
+	 * Check new keys don't exceed the max length
+	 * (older keys may be larger.)
+	 */
+	if ((flags & BKEY_INVALID_COMMIT) && d_name.len > BCH_NAME_MAX) {
 		prt_printf(err, "dirent name too big (%u > %u)",
 		       d_name.len, BCH_NAME_MAX);
 		return -BCH_ERR_invalid_bkey;
-- 
2.41.0

