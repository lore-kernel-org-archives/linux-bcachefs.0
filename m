Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28642C00528
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjGLVMi (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbjGLVMW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:12:22 -0400
Received: from out-4.mta1.migadu.com (out-4.mta1.migadu.com [IPv6:2001:41d0:203:375::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1279926B2
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:46 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bOiJuZA7MMn1dUAKvZtsb+DsEd9kjQVDcRKBJgcodE=;
        b=c/TQhQifd2bG9jqyz1yUnKFrIEOakPDHeeO1oK5IBJDq1VPONAP28akM3gIsyeIR854AJG
        3qqejI0s0GzfMz4gSD2rvZX7XdPyRuqTYK2mb2P6AXLbnKkGlBkVt+j3Mw8c6BWVgjkaNr
        PUN0XpbTfIjd+ambQYaCpGpRqSu5TDs=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 16/20] closures: Add a missing include
Date:   Wed, 12 Jul 2023 17:11:11 -0400
Message-Id: <20230712211115.2174650-17-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
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

