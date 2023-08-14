Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55DEEB64DD
	for <linux-bcachefs@archiver.kernel.org>; Mon, 14 Aug 2023 01:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjHNBZT (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 21:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjHNBYr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 21:24:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E6A1B5
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-3178dd81ac4so3317547f8f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 18:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691976285; x=1692581085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJaRt0JvANdMtBw+KPrYjeNplrMT9dKdh8bNSiVZtZU=;
        b=hzeOOSPJB86ZrseGj/1eojer5P7gMaaVmD8PS7fpu33FYP/flGgBkH725xabGVSQOM
         8AJAMEbjYrrgYHFL+0d+iUJoq+g2TReG28Vp2fCP/oh33jjNtbpd4XvykwI5WuHbKIv5
         Na2gosX5Xz76YXfn80b8T5+XbSmuhuJitTRaE0TSBuBp1An+AvwRH/U5BnJsbeSYLT57
         GQj5GeS/8SX2QOxHAOiLfbmgoUDd0g/EH98la8DqE54tEV0CKf/5DQf1LuTLnGZmnDIe
         g9l7//AoohOLSUflEB7F5OHb0jKn+jEA3Bku/tvTBjNUMU9h0ONjc213/YmFSyeMmpEt
         vNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691976285; x=1692581085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJaRt0JvANdMtBw+KPrYjeNplrMT9dKdh8bNSiVZtZU=;
        b=jAUA5ka94AukP3qNfDkxaRrMj1nqM2IEOSGbP2d0Iob1WF4LNPjwqnyobo9iFvIqK2
         5cBMl65Q1/1XvHQxKr9uwyWMiP6ygKhe76XKxW9ylJFvPkbLqTq+Sk4oihWiY8CS4zfA
         4orZBdCyoQnvrVT5YJdXy/obExnvfCCwS/UhNIozqhTFBabfF9e54hZ1yd5Fxqd298Jk
         UGbCXwYOlqNHbpE5e5/c/Z6ehVbTeAc/wzo32xouxdqYTSl8I4KpOUDnVx/NxC4cZTA0
         P2fn+jf49x8UzG1mrjadAI0ivnUaUd9gRE+86kwA+E1UhhAQTAPvEaIF83Jd1E9YbQQ2
         B90g==
X-Gm-Message-State: AOJu0Yzqg/3+7M2ADl9xF2iDt2zLzvMy2yItVkbFhzxwQ1635nG30Hig
        eqo97HB8yPsq9UjtkTBrF0gMvtSNQ1KD14jq2uM=
X-Google-Smtp-Source: AGHT+IGKILguaA4KrHbl4/H854E6VkuiFm6eU6g88RUIqNDyrusmruINHGG4qJDaf3vkgSD+jWes2g==
X-Received: by 2002:a5d:4d8d:0:b0:319:6b6c:dd01 with SMTP id b13-20020a5d4d8d000000b003196b6cdd01mr3857818wru.17.1691976285375;
        Sun, 13 Aug 2023 18:24:45 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d4d42000000b00317ca89f6c5sm12802076wru.107.2023.08.13.18.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 18:24:45 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v4 2/3] bcachefs: Move dirent_val_u64s to dirent.c
Date:   Mon, 14 Aug 2023 02:24:26 +0100
Message-ID: <20230814012434.627641-3-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230814012434.627641-1-joshua@froggi.es>
References: <20230814012434.627641-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Not used anywhere else anymore, can become local to dirent.c now.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/dirent.c | 6 ++++++
 fs/bcachefs/dirent.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 85769d5c6b82..6bdcccabd732 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -13,6 +13,12 @@
 
 #include <linux/dcache.h>
 
+static inline unsigned dirent_val_u64s(unsigned len)
+{
+	return DIV_ROUND_UP(offsetof(struct bch_dirent, d_name) + len,
+			    sizeof(u64));
+}
+
 static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
 	unsigned bkey_u64s = bkey_val_u64s(d.k);
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index e9fa1df38232..56061ac93ad3 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -26,12 +26,6 @@ struct bch_inode_info;
 
 struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d);
 
-static inline unsigned dirent_val_u64s(unsigned len)
-{
-	return DIV_ROUND_UP(offsetof(struct bch_dirent, d_name) + len,
-			    sizeof(u64));
-}
-
 int bch2_dirent_read_target(struct btree_trans *, subvol_inum,
 			    struct bkey_s_c_dirent, subvol_inum *);
 
-- 
2.41.0

