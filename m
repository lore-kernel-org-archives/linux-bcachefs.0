Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCBEC4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 06:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjKCGeo (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjKCGeo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 02:34:44 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB7ED51
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Nov 2023 23:34:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-53e08e439c7so2944074a12.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 02 Nov 2023 23:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698993279; x=1699598079; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uIiPKuyQpg3FTiBPP755iaSmhIMJh4QWqX8Y/pUhBTY=;
        b=SXTi326Adw2oNGuKppUcwRIOV7ZMPpZ/Bw7GtpkY9VSlT6ovQbPIW5XzITzMHvjHz1
         ZYfdHoxYtEe9ro5Wm6qiGjZkqBzfq+bylKERbzpOZvzHXnxn2CsXGEoAwpics0dCeLMw
         VVyZsJooVYC28Tv094e/Dl4rysKObLs3BH2b+Y1GHPT164FnqEN8GrF8Z+24HV6ukcT+
         +nfc5QKq5kZ3MAO7tyTT06tog7M6H46oaijIyKjmLOgDEHz879o+TWM60USrOym61r8f
         6NRtF2mPhZLRTjjKgKM3axjNc31luPdzxc2+C8BZY77OQdbYag8HNvMIrMm3SSEAc/qw
         pMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698993279; x=1699598079;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uIiPKuyQpg3FTiBPP755iaSmhIMJh4QWqX8Y/pUhBTY=;
        b=rPrxrZ5c08QMUShwaHZWkj0M3C3LZmC5e5sseasxSohJ1c6jOXb6k+OwD/GhVXWXyV
         c924OKsbah9tg4NT+HuVGFP22yfv1M2IrwwinKYF+0rOwtq14YCsMfU3e1i7MLskngKa
         evtlYSaAYMOcx5LhnIh8oUCUwMJSnpLdDiT+egfap8YpXhslHjMoGLgIu48f6sCbMhQj
         aq3i4rXK7k2rlLoxNZUlaOQI8rQeJHo0BEv6dqZLuRR7FNQMFFkqgAW+dQzZSGTZ+uP6
         dUR0ao1P9nrYV8KrP4fLjOhH+WmedZeIICFemAdTT4nizbJdgNoL2ZyCWVdWJ+yAYPyI
         WjMw==
X-Gm-Message-State: AOJu0Ywl4hKIUgOcXwL+EfpQzg/yE98eQtR7zeGUOddVDHFtAPFLRity
        ycPlJnikDAc2J58W2i8ruS7XWw==
X-Google-Smtp-Source: AGHT+IENGjqyhHf1sID5jH2elSAvdnw8HI0e0SKRqezuCCB4uA4X5pXZs/7QKqwGueGs+zY2Voyl6Q==
X-Received: by 2002:a17:906:6686:b0:9ca:e7ce:8e60 with SMTP id z6-20020a170906668600b009cae7ce8e60mr5073987ejo.41.1698993279122;
        Thu, 02 Nov 2023 23:34:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b95787eb6dsm537427ejb.48.2023.11.02.23.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 23:34:38 -0700 (PDT)
Date:   Fri, 3 Nov 2023 09:34:33 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] bcachefs: add a missing tab to bch2_dev_exists()
Message-ID: <b5297f95-ee72-4160-8824-e62fd12f6aad@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This line needs to be indented another tab.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/bcachefs/sb-members.h | 2 +-
 1 file changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index 1583e80afcbf..10072088c299 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -190,7 +190,7 @@ static inline bool bch2_dev_exists(struct bch_sb *sb,
 				   unsigned dev)
 {
 	if (dev < sb->nr_devices) {
-	struct bch_member m = bch2_sb_member_get(sb, dev);
+		struct bch_member m = bch2_sb_member_get(sb, dev);
 		return bch2_member_exists(&m);
 	}
 	return false;
-- 
2.42.0

