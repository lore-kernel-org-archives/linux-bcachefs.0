Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E009C77B75
	for <linux-bcachefs@archiver.kernel.org>; Wed, 17 May 2023 06:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjEQGT3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 17 May 2023 02:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbjEQGT1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 17 May 2023 02:19:27 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CB2D77
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 23:19:17 -0700 (PDT)
X-ASG-Debug-ID: 1684304353-15c434461823adb00001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b01.edpnet.be with ESMTP id VnEcjap7N7P6z1EA; Wed, 17 May 2023 08:19:13 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     linux-bcachefs@vger.kernel.org
Cc:     Janpieter Sollie <janpieter.sollie@edpnet.be>,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH] Improve CFLAGS for faster release, and more agressive debugging
Date:   Wed, 17 May 2023 08:15:30 +0200
X-ASG-Orig-Subj: [PATCH] Improve CFLAGS for faster release, and more agressive debugging
Message-Id: <20230517061529.902-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1684304353
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1201
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.108879
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

We've got several complaints about bcachefs being memory hungry and slow these days.
It's not a good idea to start optimizing when debugging,
but as we've a "make debug" target, I propose:
- we turn on O2 for regular targets
- we build a debug build with address sanitizer
- we turn off 02 for debug builds, instead switching to -0g
According to GCC manual, the last O flag is the one that counts,
so having O2 and Og won't be a problem
we still keep basic -g on release builds for a while,
but set -ggdb on debug builds for more accurate debug options

Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3fc52cf..460fb9f 100644
--- a/Makefile
+++ b/Makefile
@@ -85,7 +85,7 @@ endif
 all: bcachefs
 
 .PHONY: debug
-debug: CFLAGS+=-Werror -DCONFIG_BCACHEFS_DEBUG=y -DCONFIG_VALGRIND=y
+debug: CFLAGS+=-Werror -DCONFIG_BCACHEFS_DEBUG=y -DCONFIG_VALGRIND=y -Og -ggdb -fsanitize=address -fno-omit-frame-pointer -static-libstdc++ -static-libasan -lrt
 debug: bcachefs
 
 .PHONY: tests
-- 
2.40.1

