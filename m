Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBD6C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjHMPeb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHMPea (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:34:30 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959A3E0
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:34:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3fe2fb9b4d7so31976985e9.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691940871; x=1692545671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G/xrXPRETftwpLS4lN8HkOt+/j+ZZrmrsx8kxw7+sDc=;
        b=fzgI9MH5ENSyhBi2SuLbuIg8+u4rhCs1WYIVLSynZoHXlB9+qeYIODiXVC5hA12/Gr
         0zQxKyTnXYOsKylxYLZCOWDZvxF94oqAZFi4JsfOMtAnPdqqs3+L6TBTIfOgGSTf0XCB
         2NTfeuwPTob3XN2+kMloIdTaidId9+KvhcdNp1Ol6LG1IwTH0O6pj7TAts3rw1wwZ2/+
         EIxlVU3X7DrSAulV+2fzx7v5yNDya9nFdSw4osm+B6CvccqqcaKmIfL1mDs+iMU92zS+
         D+U0qs5uyHao5ltfTXt2eDjZtmyLny9hml3oavr5kDoL//eDAn/KogGg/PGx9Skw1PfB
         8f6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691940871; x=1692545671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/xrXPRETftwpLS4lN8HkOt+/j+ZZrmrsx8kxw7+sDc=;
        b=QLTmPbkLSZkZYqSUWwoy1xxB2HwfDquK8pUbfrlU8tDL0OigHy+eGr+fDVBGuxzDAZ
         YERcixBTilhvYmJ6qcWi24Ejx3/79iXSsu1KsowCQj74qzBXE9HePc5G7xL6HA35jpRN
         wve4jjG8aihunOsvATyUNTc84381O4maA3CPcl5rWshJdcc0qWNwOKa5p8ZV+eVgqvPH
         ZWOrpaxre4q6Rn3FYw12CANVjK4rzQMVMQpeSxEDX/Zli7LDd2RsejdFsWcQmGdromsc
         zM2TqtwaFhgtDem3swYeG9dSeLIbeCx+4+O3RYgFACccvlkKpPWUYyGfracHVOirB2c7
         KEXw==
X-Gm-Message-State: AOJu0Yx9hvMoGCQ+ZKo/oRwH/ase9XIA+jpidO4lq8+h02CGVMfYHBSK
        SU02RayOQtKfdjcvb93HXV+XD2uHbdGKSgB0ogk=
X-Google-Smtp-Source: AGHT+IEHg/hblI4WHQRAFxQoq07wv2m/vnWQeNF7CLnXH8XvET+PMmPLp1IB9lhXK+3FQuFtAVWdHQ==
X-Received: by 2002:a7b:c5c5:0:b0:3fe:603e:7fd2 with SMTP id n5-20020a7bc5c5000000b003fe603e7fd2mr5325718wmk.0.1691940871023;
        Sun, 13 Aug 2023 08:34:31 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id k5-20020a7bc405000000b003fbdbd0a7desm14450177wmi.27.2023.08.13.08.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 08:34:30 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v2] bcachefs: Lower BCH_NAME_MAX to 512
Date:   Sun, 13 Aug 2023 16:34:22 +0100
Message-ID: <20230813153427.106834-1-joshua@froggi.es>
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
index 065ea59ee9fa..a1d2a6d881cb 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -103,7 +103,11 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (len > BCH_NAME_MAX) {
+	/*
+	 * Check new keys don't exceed the max length
+	 * (older keys may be larger.)
+	 */
+	if ((flags & BKEY_INVALID_COMMIT) && len > BCH_NAME_MAX) {
 		prt_printf(err, "dirent name too big (%u > %u)",
 		       len, BCH_NAME_MAX);
 		return -BCH_ERR_invalid_bkey;
-- 
2.41.0

