Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5814C001DE
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 17:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjHMRij (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 13:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjHMRih (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 13:38:37 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F401708
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:39 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-31768ce2e81so3314720f8f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 10:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691948318; x=1692553118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJaRt0JvANdMtBw+KPrYjeNplrMT9dKdh8bNSiVZtZU=;
        b=gBVUI0iAwMQmCvJZTgFt0CypdW7VObYezaejM/GDatq9xR4ZfWIqKKI1CIG27BOuKy
         R3cU1oKkyAAQJ2GFnidDEGP8vmhBhdyPbvsw5KshhQ3mPVTSiOY64mrf+s8dh0lOezZp
         tZYWkdx5QnQI8HRF86aGjPTvkS7o4Ms/ZYGu04dHnv7xNeYoVjXgnJoUIarUrIxP0AhE
         cj4TvqdSMQ1fcj499jkfFKiGIuPqxjuerFm/vEfljq4YDUuvw8OILj1pGNr5j2AJdj0T
         lQk74W2EFKZvyZzHRne4q2lvfqZ6cxAmA+D+dSBj6RFeIszALSnK+IpbEe/mXoLIxDcG
         S8ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691948318; x=1692553118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gJaRt0JvANdMtBw+KPrYjeNplrMT9dKdh8bNSiVZtZU=;
        b=UJYFSBZrL40v0CBIKRYbHvD22mrIM6sEBSTTqckHZoA6IpZFhJujICiknzxT2GXUxd
         laG3PoJU4HZy5NLlSMdhzrGXmBwpQ4WNUZBBZMTRhjlC4JIAkmzYmZRxO1/VncRh/5qB
         DbMzaP7cDkfyaGHWMlguFWF5xI0Y0IqEAKHf58QmxSFZz5v9iSM4ugZ3wvfGtFTlNZoV
         4FnsMsO0TWM7onTZsfMkr85dbqfxjwt0H7t9OX+3RdDj4sOGE/+ivfdcmzlZWv5o0VXS
         kExSTBeCqJ4kYgLE3sUU+/bmDSCZQsjta0SkhBHoGUvHdMWoD83YqXTqJ1++71neLqRn
         InoQ==
X-Gm-Message-State: AOJu0Ywp5gSjR1bKSDMaDB7NCZuDisX87vHVNzxlHaJc1xQzTrXoOpqA
        a9lI/3bIopzJko19dz5bb2tp/OKOlAMSqLAQKDo=
X-Google-Smtp-Source: AGHT+IEtPau+ClVbgYHxHm11xPa7wB9jqnZULDkRICXWfSv8PVvOJMpSHeEiRNu0NfPw04I3sGIG/g==
X-Received: by 2002:adf:e444:0:b0:318:7bc:e1b5 with SMTP id t4-20020adfe444000000b0031807bce1b5mr4869090wrm.32.1691948318227;
        Sun, 13 Aug 2023 10:38:38 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d5106000000b003141a3c4353sm11962115wrt.30.2023.08.13.10.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 10:38:37 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v3 2/3] bcachefs: Move dirent_val_u64s to dirent.c
Date:   Sun, 13 Aug 2023 18:38:26 +0100
Message-ID: <20230813173835.195840-3-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813173835.195840-1-joshua@froggi.es>
References: <20230813173835.195840-1-joshua@froggi.es>
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

