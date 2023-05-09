Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30144C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjEIRA4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbjEIRAC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 13:00:02 -0400
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD006EAC
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:55 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W3IMW7979m4jEebRkm8ameWmv+95K3nEqS903wmmHh0=;
        b=rePqwIEQtfDZ7Lr1PZGsbFUi63Nh5oKibQRVDY7ErwYGzoTrCqeYvKqOCoZlO888YVeiOy
        A8lw/mTSAfWfN8ZSaPlBg2oZ8cefaiEUcoyOCcUyxFtzdFyxYu2f2khlg2LltB/a6SIRiV
        Kb36uSeA1vkHxSqaSroCgGgH2A7sRek=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 26/32] lib/generic-radix-tree.c: Add a missing include
Date:   Tue,  9 May 2023 12:56:51 -0400
Message-Id: <20230509165657.1735798-27-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

We now need linux/limits.h for SIZE_MAX.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/generic-radix-tree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
index 63080822dc..f6cd0f909d 100644
--- a/include/linux/generic-radix-tree.h
+++ b/include/linux/generic-radix-tree.h
@@ -38,6 +38,7 @@
 
 #include <asm/page.h>
 #include <linux/bug.h>
+#include <linux/limits.h>
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/types.h>
-- 
2.40.1

