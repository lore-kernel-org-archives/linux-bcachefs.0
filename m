Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9357C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 17:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbjEIRAp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbjEIQ74 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:59:56 -0400
Received: from out-48.mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E7F6E87
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4evz1kbIC6hOLTFQMkHcxrXWiRo0lENP+eBhEpndpY8=;
        b=CBbntMb8JDhq2x3mCt4kaM+tJCcmDi4cB1kDlSpHxpH4RtVg8j9fjfe//o4jNosLeoF/eg
        s9Et5lUNFROInJTonZjVn6nHQVp+osd7shzlDUCaeEGaRpXw+XicD8gVRAkZd6DLr6LXhH
        lspVH1eipCUD5E57d10siAXsjDd7OtQ=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 24/32] MAINTAINERS: Add entry for generic-radix-tree
Date:   Tue,  9 May 2023 12:56:49 -0400
Message-Id: <20230509165657.1735798-25-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
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
index 5d76169140..c550f5909e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8615,6 +8615,13 @@ F:	Documentation/devicetree/bindings/power/power?domain*
 F:	drivers/base/power/domain*.c
 F:	include/linux/pm_domain.h
 
+GENERIC RADIX TREE:
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

