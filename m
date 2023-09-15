Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BB2EE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbjIOMzf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbjIOMze (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:55:34 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353DE1FE0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:55:29 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-404539209ffso19468435e9.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782527; x=1695387327; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7Zk0Gm209+6RrjbQIUExPCmrAt7uj3y+xSnarg23mk=;
        b=lGL/RO0XpI6Pa6It9mcMLn/5M7Zg0oxLsu+3rnYX/yCsAophBvL4sc3f2W3CRIECPO
         3skGOoR+y7geHiEi4MhOn98aZKcNIgCAWiluvj23Bj5oPHA5U+eRoM5a0fF9518GkXpM
         CvUdJ1pmpEBkyr0zFqBa9oR62nRw1O+3DMN8qzNel7jLzvR44nBBSwj+WDWWlJW29vhJ
         z+qQNXvAc5XY1tC3vJhlNedVt/dCYz/m0ZgO3PYY/QsNZJOkCXc9vsH4YWcvrnxJ1Bis
         Ley4z42qgRkiZMoGb6b92KHZCSsE7KOeu9ZMwaDNmVa7wKZMKVBTqLfOPvaiXA2FRzmp
         pCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782527; x=1695387327;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7Zk0Gm209+6RrjbQIUExPCmrAt7uj3y+xSnarg23mk=;
        b=EX6dXv2dtTKPQ0hJc2F+NSNwVohJf3X+gy3ckb+93/txyneuDS5GyHAkl3yaNaFNj4
         j+VWuiaTauj/iG25K+cH28Jogb9+l6lAB5IrmW8n8xbNH0pITSwLYMWNOSCvj5vKi1LJ
         Th79DuqCSmxjMtApnfcvlTN/b5RiFECKU9z5o2zVFtEGagQZ+FFoLsRZbtzu6x7uCHGb
         YQweuNNC86/dKzWCPKde4Bu+1u14VsigxCLSxPiZMUu4i8AuDPS7SRxfGMA0Ps9Buet7
         5wj8cmQeOn9MACDAPTWVSbZF7plfoFZHyIknhicHUktRfzoTRPxPU+wLb6muPMwydeyq
         foWA==
X-Gm-Message-State: AOJu0YwJPtMEfrkgHITY62WNvDVo4qKUNZpyynNwSChCm3padAqqbrEh
        SdkcfVs0X+/s6KlqwKfWWyVSpakn3Q0EIeOjyxU=
X-Google-Smtp-Source: AGHT+IG/tN7gjJvVGYKIy2itP3CefBo8PdIZcNB8sjtzmU6IpMAA16WeDTYKtiiqelAJ01erpHd1wg==
X-Received: by 2002:a05:600c:225a:b0:401:2ee0:7558 with SMTP id a26-20020a05600c225a00b004012ee07558mr1320284wmm.32.1694782527457;
        Fri, 15 Sep 2023 05:55:27 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b003fef5e76f2csm3225732wmq.0.2023.09.15.05.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:55:26 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:55:23 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] bcachefs:  fs-ioctl: Fix copy_to_user() error code
Message-ID: <90f0388a-ea0d-47d3-bbbd-efb38fd96d2c@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The copy_to_user() function returns the number of bytes that it wasn't
able to copy but we want to return -EFAULT to the user.

Fixes: e0750d947352 ("bcachefs: Initial commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/fs-ioctl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
index 141bcced031e..0679b2f79fd6 100644
--- a/fs/bcachefs/fs-ioctl.c
+++ b/fs/bcachefs/fs-ioctl.c
@@ -122,7 +122,10 @@ static int bch2_ioc_fsgetxattr(struct bch_inode_info *inode,
 
 	fa.fsx_projid = inode->ei_qid.q[QTYP_PRJ];
 
-	return copy_to_user(arg, &fa, sizeof(fa));
+	if (copy_to_user(arg, &fa, sizeof(fa)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int fssetxattr_inode_update_fn(struct btree_trans *trans,
-- 
2.39.2

