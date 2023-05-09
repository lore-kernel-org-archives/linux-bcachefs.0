Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5ACC7EE2E
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 16:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbjEIQ7U (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 12:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbjEIQ6V (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:58:21 -0400
Received: from out-35.mta1.migadu.com (out-35.mta1.migadu.com [IPv6:2001:41d0:203:375::23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A74559F
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bOiJuZA7MMn1dUAKvZtsb+DsEd9kjQVDcRKBJgcodE=;
        b=P3hZFno74bG0D5MVwOiAtytjPyoMXAxWkMWmWGCfGM3DquFD0ALELeBdVg3CPwnj+gUHgK
        NJJNgmjsEoEC/xiuoLdUK+Ku0A3kOpGxgm/PyfDlH1n2Qe/3QX9XUJTlO8rHac+1xpTczX
        3qQ/rx1r/qiBVGrivA0TW/KTk46S0t0=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 19/32] closures: Add a missing include
Date:   Tue,  9 May 2023 12:56:44 -0400
Message-Id: <20230509165657.1735798-20-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Fixes building in userspace.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 lib/closure.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/closure.c b/lib/closure.c
index b38ded00b9..0855e698ce 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -9,6 +9,7 @@
 #include <linux/closure.h>
 #include <linux/debugfs.h>
 #include <linux/export.h>
+#include <linux/rcupdate.h>
 #include <linux/seq_file.h>
 #include <linux/sched/debug.h>
 
-- 
2.40.1

