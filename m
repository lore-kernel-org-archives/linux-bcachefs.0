Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F063FEB64DA
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjGLVOB (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjGLVNc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:13:32 -0400
Received: from out-28.mta1.migadu.com (out-28.mta1.migadu.com [IPv6:2001:41d0:203:375::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662BD30CF
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:12:03 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ef7q3qIWjRvFLnHBOoY21BNEfjo+XFx+9y6P/VZtvw4=;
        b=V+35GQt8y784/HUrNLb+TB6rbsdoyPMrMAfoSNh0ZOhpmrxTYEcTvHj5o3xPH5LnWTcVDY
        hIHKXccpoOUyGbM1zqOWQp0wmJMNkCFfumVBDtCdiWlukpF7eXYU4l7zS1QZduJsBejmX4
        mVjzI2i8jgcaXSz6bB46LCa/wossSq8=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 17/20] MAINTAINERS: Add entry for generic-radix-tree
Date:   Wed, 12 Jul 2023 17:11:12 -0400
Message-Id: <20230712211115.2174650-18-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

lib/generic-radix-tree.c is a simple radix tree that supports storing
arbitrary types. Add a maintainers entry for it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 314b55ecd1..c3fd29247b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8670,6 +8670,13 @@ F:	Documentation/devicetree/bindings/power/power?domain*
 F:	drivers/base/power/domain*.c
 F:	include/linux/pm_domain.h
 
+GENERIC RADIX TREE
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Supported
+C:	irc://irc.oftc.net/bcache
+F:	include/linux/generic-radix-tree.h
+F:	lib/generic-radix-tree.c
+
 GENERIC RESISTIVE TOUCHSCREEN ADC DRIVER
 M:	Eugen Hristev <eugen.hristev@microchip.com>
 L:	linux-input@vger.kernel.org
-- 
2.40.1

