Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10036EEAA4E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 14:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbjINO7U (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 10:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbjINO7U (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 10:59:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C11FD4
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 07:59:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40476ce8b2fso1627055e9.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 07:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694703554; x=1695308354; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zA2J6iVhdPAiSJ9CdtA7b2Q6agWfFhfSXlVxICfJlO0=;
        b=Svr6CWkoSeUZkBoCV492hkpGx530jorW/SKUS/CA9ggrgeUm/MbALzjdFkOMOtmnbA
         fEaRpsJsuwnDTnxPhpBX2Yyx+qDfDduPFXWTY7EOptAj+MH6SYmizzXst3meX2NtU+N4
         EeAtFTKAeNWNlErBmGAKhsSpygNemvTysgFvoJJsro9FQdRQJMXWL4vwWMACIKdPen64
         NWBLACxuM2ASSpKo1njo/KUEn4otksQ5U9inCkhpi9IOhwRwRx7viUmzcUFQ4WMC8vR3
         Bi4NO2erGSRgoNgCnlgNhmuKNT/cRVW0qAXGS1+A2mWWBL8SfZSJ73y7rB8x6pUI5EAA
         Ou2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694703554; x=1695308354;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zA2J6iVhdPAiSJ9CdtA7b2Q6agWfFhfSXlVxICfJlO0=;
        b=NYPg6Wt/ZVtz2vAQ6m6b5rcTvMONhvmfRH6jPtvKNgBzck0TKJz0kNqBZcuGtmJ+Hn
         uiGuBA3O/P0FGd+BsE/EKrP0/sX7K30stFNh9Lg4jsZkuUiZa8si1P/5pkXs0/w12WrM
         QP+3J+UWfrc9H0sCtQjvPRTkXTkdBVjgMldmeYMblOpbwyhYK5qgC/+XZvrw9Mbt3INE
         Pc2XnPbxsEsCqq1yZ+ZQyHsiHFxugLIOF4QIXCdMvaiswWWhTHn24/gFRvSJigXL+2Zy
         zyiTQ/MkZZbmjFKr12l3BlW0NYzWokg7yW3TRdKYU+x9aVbdr90sVHMijsGqxqUuHr5b
         ffyQ==
X-Gm-Message-State: AOJu0Yya6om+h9uJZTEyGMa216s+Y69D5/n9T80+HAS7sHlogUCyEomx
        iALaDYFlApWuTYp5pF3d2GThvtYPk9+vkMwXKSk=
X-Google-Smtp-Source: AGHT+IHoN5F1p/rI3oMn5ZLq5s9qDbZBA5ChY9Yj+a83EyOTOtTKYs0ww33UmUl5r07uPAVLNIvnYA==
X-Received: by 2002:a05:600c:241:b0:400:ce4f:f184 with SMTP id 1-20020a05600c024100b00400ce4ff184mr4959596wmj.41.1694703554092;
        Thu, 14 Sep 2023 07:59:14 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s24-20020a7bc398000000b003feee8d8011sm5096816wmj.41.2023.09.14.07.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 07:59:13 -0700 (PDT)
Date:   Thu, 14 Sep 2023 17:59:10 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] bcachefs: chardev: fix an integer overflow (32 bit only)
Message-ID: <9ab0a914-3170-4728-92b2-09eebb0dbdbb@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f3b0d3e-d20e-47fc-a3e5-4ad4c03d58b8@moroto.mountain>
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 32 bit systems, "sizeof(*arg) + replica_entries_bytes" can have an
integer overflow leading to memory corruption.  Use size_add() to
prevent this.

Fixes: b44dd3797034 ("bcachefs: Redo filesystem usage ioctls")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/chardev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 5556bb2dc539..12dcf1f288dc 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -421,7 +421,7 @@ static long bch2_ioctl_fs_usage(struct bch_fs *c,
 	if (get_user(replica_entries_bytes, &user_arg->replica_entries_bytes))
 		return -EFAULT;
 
-	arg = kzalloc(sizeof(*arg) + replica_entries_bytes, GFP_KERNEL);
+	arg = kzalloc(size_add(sizeof(*arg), replica_entries_bytes), GFP_KERNEL);
 	if (!arg)
 		return -ENOMEM;
 
-- 
2.39.2

