Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 158A7EEAA4E
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 14:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbjINO7A (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 14 Sep 2023 10:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240581AbjINO67 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 14 Sep 2023 10:58:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D95F1FC7
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 07:58:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-404773f2501so1063625e9.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Sep 2023 07:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694703534; x=1695308334; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FNIPC3eqRaM9UUjA9jC9vZgN57C88gn3jUcVe8mp0CA=;
        b=mz3R3Gexz/IDT6QMM7MKdRE4Q+CDlLB1G1dhYSnFNrTUYL3+cha/R29z6fJi+o8HPQ
         /zZuETj/h2g4Cx2TsPMgRPNFO/cXxPYdwF2kfj34RnQqRkF3ggr1RqAB0KSyPl3G9w63
         BdqXCuZI6oIoF2xqmssFZjXDxUn4cCnQBuM03WifwiVGhWipn3IQm2nZxwnEM2pDAkF1
         ++x3II57zzrAlUN/Yu2M4eQGFdhYL52eo46Rfnvolr8lEvAfGE9J+7iWlCkmVzL6/xBm
         li6Tr5vPGfQhe/q3AteXHwENUHXv2qJm3Z8Scg6LoJ+4qoMUp/PuPNF7+9SCkrGrutRp
         FtHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694703534; x=1695308334;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNIPC3eqRaM9UUjA9jC9vZgN57C88gn3jUcVe8mp0CA=;
        b=lje1o/R03SyrIEyeDGjSUQ0yxQO/gelpiZXmeLMz2iwD2OVfyN1oMc/pgwnCmBUOmM
         zHJEpuh1TUoOCDWADFFdIU+qfZMC7o1a3+8U/aZzMI989kyL/A6jXNbkOtPDpLxPqJxD
         xr7b66NbnnTpPwxtTQRfa1+zg+Al6K+WFfMdNhks3XKOqXF0gRVYzDFBwzMf6PPgIIQX
         zS845ANPamAtLCqZUTHtUHuDiWzzjh+/JRpQmc/iLW5C4/kVGUkif2mU1t8dqchZhUas
         5sx0SLU8UBSsy5BACY3AJiBJQIW2Uib7TeUvqqIu1VtIV9nESpx1LehRn2Wmnu3nPSPY
         Fxrw==
X-Gm-Message-State: AOJu0YxM+sFWM8Tv9MXXm0IXMiL6srpVUrGcx3Pa56el47yRbvGGqJHp
        I89PJRICGX+ziwOZHKaBY4NkRw==
X-Google-Smtp-Source: AGHT+IH/4ma7ACywAK2Zx4/cAg6qKiu7TqRpTwZ5KbxhrvecfyZ7P60C/q9X2Ek5ab315P082ZzRnA==
X-Received: by 2002:a05:600c:21ca:b0:401:5443:5598 with SMTP id x10-20020a05600c21ca00b0040154435598mr5034388wmj.25.1694703533813;
        Thu, 14 Sep 2023 07:58:53 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n4-20020a1c7204000000b00402f713c56esm2189167wmc.2.2023.09.14.07.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 07:58:53 -0700 (PDT)
Date:   Thu, 14 Sep 2023 17:58:48 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] bcachefs: chardev: fix NULL vs IS_ERR() checks
Message-ID: <043689fd-b686-429f-a4bb-602c37578370@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f3b0d3e-d20e-47fc-a3e5-4ad4c03d58b8@moroto.mountain>
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The strndup_user() function returns error pointers on error.  It never
returns NULL.  Fix the checks including the commented out code.

Fixes: e0750d947352 ("bcachefs: Initial commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/chardev.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index e5e9fddddfb5..5556bb2dc539 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -86,8 +86,8 @@ static long bch2_ioctl_assemble(struct bch_ioctl_assemble __user *user_arg)
 		devs[i] = strndup_user((const char __user *)(unsigned long)
 				       user_devs[i],
 				       PATH_MAX);
-		if (!devs[i]) {
-			ret = -ENOMEM;
+		if (IS_ERR(devs[i])) {
+			ret = PTR_ERR(devs[i]);
 			goto err;
 		}
 	}
@@ -117,8 +117,8 @@ static long bch2_ioctl_incremental(struct bch_ioctl_incremental __user *user_arg
 		return -EINVAL;
 
 	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
-	if (!path)
-		return -ENOMEM;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	err = bch2_fs_open_incremental(path);
 	kfree(path);
@@ -189,8 +189,8 @@ static long bch2_ioctl_disk_add(struct bch_fs *c, struct bch_ioctl_disk arg)
 		return -EINVAL;
 
 	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
-	if (!path)
-		return -ENOMEM;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	ret = bch2_dev_add(c, path);
 	kfree(path);
@@ -231,8 +231,8 @@ static long bch2_ioctl_disk_online(struct bch_fs *c, struct bch_ioctl_disk arg)
 		return -EINVAL;
 
 	path = strndup_user((const char __user *)(unsigned long) arg.dev, PATH_MAX);
-	if (!path)
-		return -ENOMEM;
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	ret = bch2_dev_online(c, path);
 	kfree(path);
-- 
2.39.2

