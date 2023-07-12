Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BB9C001DE
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjGLVMl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjGLVMN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:12:13 -0400
Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [IPv6:2001:41d0:203:375::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460CD2683
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:43 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVeF8qdGbozu++IPDLbjjHcaqfjIh8LSWsUSOXCTfos=;
        b=cFBdAGUI4WGMYMyD5ZIqi8uqVLBiG1mhILt6dhQGiDtMmZIkSGIQUNFuRXz7VCGPsTQo9i
        GiA97XdTwfpkUum+3/ob7kbFuByK5hcAYoa7mn92dBwTlmmZRx+M5jNOVzMyh9KbyABupa
        b/+9fgWVxkmn3yYqJWHmv3UutkzawsM=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 13/20] MAINTAINERS: Add entry for closures
Date:   Wed, 12 Jul 2023 17:11:08 -0400
Message-Id: <20230712211115.2174650-14-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
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
Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 35e1959464..314b55ecd1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5064,6 +5064,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 F:	Documentation/devicetree/bindings/timer/
 F:	drivers/clocksource/
 
+CLOSURES
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

