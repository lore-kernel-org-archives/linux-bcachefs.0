Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92832EE6457
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjIOMzw (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbjIOMzv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:55:51 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DB4173A
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:55:45 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-401da71b85eso22850635e9.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694782544; x=1695387344; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m7EqKPxcYmhqUUSygv21qZ32ZU2BZ3oQxs47F0gcyJg=;
        b=QPOSQVtkQ4WGiENEJdIkRA5ESI2hotgNjGg76vwqM8yjmNIjgXT6Rz/ZTm8pzKq5/q
         LYWEkvB3Cu/wl876W7dBzp/7p0kY0AaZYr7PIBVicum3JCHV8dPK0rxos00Mym5YFrk5
         aeWjQCiiI9+DJxZSCJ2RGdO0/9y3fGxuMl5OE27+N2yAnaygCXTKanG+hPTGx7w2bGqZ
         PFwYb9mSvIozJMg60Bd4XcZ4OlFdwlec53eMk89riR+q/Q5Bc+xSayE9H6FoqClJ36Lo
         WGRhazGk4+hVoKEDBUuRqEQ45hv14ogWcDLwt2ecXy3vSeQeGDkhwqPNtp1eGGGbyrES
         x/AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694782544; x=1695387344;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7EqKPxcYmhqUUSygv21qZ32ZU2BZ3oQxs47F0gcyJg=;
        b=mn+DZBEi2vlhoHcMUKfyMwqrgjrLZE27DtOOiPQ5kDHOQxlWa20oP8hlDMlhg56+QW
         9mmU8Fu+v3EIM4shNtMRAY53LEgOfqaAsx6qbXSLw+WfAMvhs/WX2RipJZmq1KDc0TbN
         4wrpcp5YNHlCpTnCtdFXpOMc8n9qnXO68alGQWGRyHGjkSsPlqwWnFv+FnF5Ji74WCXU
         A4wdxCpKCcXYBLPSO9v9ursGSvnCS1BvOgjps20tUVrufGyKGOrczLtwecHDks1zqfcU
         BaTy6cYykkU3iASy5WRqyKX967f0qNvtIrNqMz3w+IyCuF1iAcxxZkcsU06qyCDf5F/R
         mYqA==
X-Gm-Message-State: AOJu0YxEo55VTn4UPcMelXDn12IvfoUjhqCUFBa1+wUqc7YFIujD9Ahn
        Pb00AfTKe449L+hEgu+O7/duTg==
X-Google-Smtp-Source: AGHT+IEto7bO2ll96rxIxYH9bIhRuf0HO3ll8ym/KB6KqDjLJQEEz6UfL9AXbJCbFh2iCQTgp03viQ==
X-Received: by 2002:a1c:ed19:0:b0:403:bb04:2908 with SMTP id l25-20020a1ced19000000b00403bb042908mr1359308wmh.23.1694782543945;
        Fri, 15 Sep 2023 05:55:43 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r10-20020adfdc8a000000b0031aeca90e1fsm4408590wrj.70.2023.09.15.05.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 05:55:43 -0700 (PDT)
Date:   Fri, 15 Sep 2023 15:55:40 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] bcachefs: acl: Uninitialized variable in bch2_acl_chmod()
Message-ID: <ce3a4798-f467-4776-939b-b094c365cc5c@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The clean up code at the end of the function uses "acl" so it needs
to be initialized to NULL.

Fixes: 53306e096d91 ("bcachefs: Always check for transaction restarts")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/acl.c b/fs/bcachefs/acl.c
index 9653401957b3..6b1579e96dfe 100644
--- a/fs/bcachefs/acl.c
+++ b/fs/bcachefs/acl.c
@@ -417,7 +417,7 @@ int bch2_acl_chmod(struct btree_trans *trans, subvol_inum inum,
 	struct btree_iter iter;
 	struct bkey_s_c_xattr xattr;
 	struct bkey_i_xattr *new;
-	struct posix_acl *acl;
+	struct posix_acl *acl = NULL;
 	struct bkey_s_c k;
 	int ret;
 
-- 
2.39.2

