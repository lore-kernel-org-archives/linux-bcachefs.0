Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F14EC7EE2F
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234645AbjEIRAK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbjEIQ7U (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:59:20 -0400
Received: from out-41.mta1.migadu.com (out-41.mta1.migadu.com [IPv6:2001:41d0:203:375::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021856A4D
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NRkDg8/QDL78Ozn75JlJivS7ptmCxyI7V8VfiBBetMw=;
        b=v9vcpKP2I5oVsGiASi9Z0yhNlg6/OYU386b+4kL3mJUwu9isTUH1JIw2lUNkRwA5UwTzmh
        dP5UkDVzix9yn6X3BvFL/2jYJQDuPcJHnH652qQP87dseSaZP2loDaloabniLSAIIVOiqr
        mJsb3JdfLSw+HpSncpkM+6GoKL/zt0E=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Christopher James Halse Rogers <raof@ubuntu.com>
Subject: [PATCH 30/32] lib: Export errname
Date:   Tue,  9 May 2023 12:56:55 -0400
Message-Id: <20230509165657.1735798-31-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The bcachefs module now wants this and it seems sensible.

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

