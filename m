Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A79DC001B0
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjGLVMi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjGLVMB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:12:01 -0400
Received: from out-9.mta1.migadu.com (out-9.mta1.migadu.com [IPv6:2001:41d0:203:375::9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86292121
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:40 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FgPTsx8pxcoWZIr644eHDkqshUBzFFLPFWwXDp/ZtBk=;
        b=MaadSe8HAdi5l+GroqZDTiy6Zc9HYZcts9hC2RyMeG8K2XIJm69E1XG5u6QYQa+hjTLtHP
        e24oHmWBgTXlsCfT77PoeFe276ZwnbrDfympEOTD60FMh5VFXOsxQtMVjae4CxTiW9/zv2
        Tw9k+sD22DrofRML8nSy90QSwb5I7v4=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Christopher James Halse Rogers <raof@ubuntu.com>
Subject: [PATCH 10/20] lib: Export errname
Date:   Wed, 12 Jul 2023 17:11:05 -0400
Message-Id: <20230712211115.2174650-11-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

errname() returns the name of an errcode; this functionality is
otherwise only available for error pointers via %pE - bcachefs uses this
for better error messages.

Signed-off-by: Christopher James Halse Rogers <raof@ubuntu.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 lib/errname.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/errname.c b/lib/errname.c
index 67739b174a..dd1b998552 100644
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -228,3 +228,4 @@ const char *errname(int err)
 
 	return err > 0 ? name + 1 : name;
 }
+EXPORT_SYMBOL(errname);
-- 
2.40.1

