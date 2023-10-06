Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EEEE81E05
	for <linux-bcachefs@archiver.kernel.org>; Fri,  6 Oct 2023 14:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjJFOK3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 6 Oct 2023 10:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjJFOK2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 6 Oct 2023 10:10:28 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68B1AC
        for <linux-bcachefs@vger.kernel.org>; Fri,  6 Oct 2023 07:10:25 -0700 (PDT)
X-ASG-Debug-ID: 1696601416-2392342037a6e10009-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b01.edpnet.be with ESMTP id oMwNozGaji79AndO; Fri, 06 Oct 2023 16:10:20 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH ktest v2 8/9] fixup! modify default powerpc variables
Date:   Fri,  6 Oct 2023 15:54:31 +0200
X-ASG-Orig-Subj: [PATCH ktest v2 8/9] fixup! modify default powerpc variables
Message-ID: <20231006140943.41110-9-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006140943.41110-1-janpieter.sollie@kabelmail.de>
References: <20231006140943.41110-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1696601420
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 576
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.115056
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 cross.conf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cross.conf b/cross.conf
index fdbca3d..a78bffd 100644
--- a/cross.conf
+++ b/cross.conf
@@ -6,6 +6,6 @@ ARCH_TRIPLE_X86=x86-linux-gnu
 ARCH_TRIPLE_X86_64=x86_64-linux-gnu
 ARCH_TRIPLE_ARM64=aarch64-linux-gnu
 ARCH_TRIPLE_ARMV7=arm-linux-gnueabihf
-ARCH_TRIPLE_PPC64=ppc64-linux-gnu
+ARCH_TRIPLE_PPC64=powerpc64-linux-gnu
 ARCH_TRIPLE_SPARC64=sparc64-linux-gnu
 ARCH_TRIPLE_RISCV64=riscv64-linux-gnu
-- 
2.42.0

