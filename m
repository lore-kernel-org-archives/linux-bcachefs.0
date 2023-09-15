Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69384EE645C
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbjIOM4i (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbjIOM4g (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:56:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74930173A
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:56:31 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-404732a0700so18390835e9.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782590; x=1695387390; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9HzwgQxURXEhBgax0SI1Nov+pOCmD49grPPYai+Yff4=;
        b=vqDT3LNFZ+PoJaTYM7s6zvlZPN/J/aQB6xzEMbfoMYtV8XSHL5BvxvzpeUOJuUusi8
         dQ22HcwAf0o0npMKSvMY/Ky1q8lrth81947e/GTAkNmNn38TS+502GJxdNRktGJvpjNn
         HQNiQpF5tn+Uz/wX8U8d+RMIr+TnLS5V5g/KIAhAok90yCjdC9W3HJdZlUJBMDQFc9Es
         mqOLK+G5dNb3DXGF7ufPKGRv/TyrXvH2kIWZ1YyM4AxzRjEtnulemETu3EJLgvhSYM4L
         /G5SSdM7SotktjyA7w6sz5S9HvJvHByBj/DipfdSdt4UQBuUuNtAT6SfSjBQ+s6aN9wA
         NCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782590; x=1695387390;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9HzwgQxURXEhBgax0SI1Nov+pOCmD49grPPYai+Yff4=;
        b=Y/f/1q96q0Lg6WFs1pz6JK1DmTD/TOv/DWdn5aS73zwAt10wDPX640pVUYuNR9kEyz
         B8UwFf0oEjHENdufAT5EgFZtciLdSAoOcYwV9lqjsXX6dkUJPZwXikNjhWVwm/ES8eoO
         GdSBVLNJOKJ9//jF4Yh2+wIWix6yWqdydOdW7vL9BS6Nlxrd0eWxW6HFnvNSMx/UC/xJ
         dWFdWgBvk+xcPHtmsbTYJLroPpzrPc1/220gKg82vnBluJjwioc/FYiscbCzPAQmGLTw
         kUK/kePHc96Vmw/jmfaJKu7HJdkjMR5ykd4Q8Pk30cDE8JxIZbXJJQZCEsR1b1NgRJLZ
         P2iw==
X-Gm-Message-State: AOJu0YwABAxfbVPUFuCORP06FyeYuOPDtGWrluCILA0V25XA6NUUs3Oq
        dK4k3a4Rkivk76Tj5oWLhUKKcQ==
X-Google-Smtp-Source: AGHT+IFjLdKfRUer7Colc/mE1z0xkc7+mCU5QIQZPplQ8GFpTqid5rALe1Qjnt9c4dJdjXZOkjMUyA==
X-Received: by 2002:a05:600c:2242:b0:401:b0f2:88c1 with SMTP id a2-20020a05600c224200b00401b0f288c1mr1670250wmm.29.1694782589845;
        Fri, 15 Sep 2023 05:56:29 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y6-20020a7bcd86000000b003fee6e170f9sm4563898wmj.45.2023.09.15.05.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:56:29 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:56:26 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] bcachefs: debug: Fix copy_to_user() error code in flush_buf()
Message-ID: <3036fd4e-5d22-44f2-9f51-6eb137452984@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The copy_to_user() function returns the number of bytes remaining to
be copied but we want to return -EFAULT to the user.

Fixes: e0750d947352 ("bcachefs: Initial commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index 404148bd348a..e65c0ab0c9ad 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -319,10 +319,9 @@ static ssize_t flush_buf(struct dump_iter *i)
 {
 	if (i->buf.pos) {
 		size_t bytes = min_t(size_t, i->buf.pos, i->size);
-		int err = copy_to_user(i->ubuf, i->buf.buf, bytes);
 
-		if (err)
-			return err;
+		if (copy_to_user(i->ubuf, i->buf.buf, bytes))
+			return -EFAULT;
 
 		i->ret	 += bytes;
 		i->ubuf	 += bytes;
-- 
2.39.2

