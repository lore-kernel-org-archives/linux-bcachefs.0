Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA203C77B7C
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 16:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbjEIQ7I (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 12:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjEIQ6I (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:58:08 -0400
Received: from out-34.mta1.migadu.com (out-34.mta1.migadu.com [IPv6:2001:41d0:203:375::22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2255E5FCD
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rlmUvmP3OR+Hibyanmij5y/VCV+BtfYfFPsujlXOgZk=;
        b=HPQouljORsYWMK0E4MhzXx/8vB1JXRSqLRVKT23bU2e/im6dY2x9v6Z1F83/XFwP17gfS+
        ETcOT56ZndtSR3AY+GLFyRQh2yGDW28ezO/09Xyg/OJePy6LCUe4npizReqKJsSHtW0R8P
        N0EM5wRPR17QAcgYwdjw5L9ZsBUVlqU=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 16/32] MAINTAINERS: Add entry for closures
Date:   Tue,  9 May 2023 12:56:41 -0400
Message-Id: <20230509165657.1735798-17-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

closures, from bcache, are async widgets with a variety of uses.
bcachefs also uses them, so they're being moved to lib/; mark them as
maintained.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Coly Li <colyli@suse.de>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3fc37de3d6..5d76169140 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5044,6 +5044,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 F:	Documentation/devicetree/bindings/timer/
 F:	drivers/clocksource/
 
+CLOSURES:
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+L:	linux-bcachefs@vger.kernel.org
+S:	Supported
+C:	irc://irc.oftc.net/bcache
+F:	include/linux/closure.h
+F:	lib/closure.c
+
 CMPC ACPI DRIVER
 M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
 M:	Daniel Oliveira Nascimento <don@syst.com.br>
-- 
2.40.1

