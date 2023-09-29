Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A50C8E71D21
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 12:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjI2MZD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjI2MZB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 08:25:01 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6A31A4
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 05:24:59 -0700 (PDT)
X-ASG-Debug-ID: 1695990296-214fdf08dd10a60003-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b02.edpnet.be with ESMTP id EBDHD0JX2GUwprsE; Fri, 29 Sep 2023 14:24:57 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH 2/7] add XXHash testing
Date:   Fri, 29 Sep 2023 14:20:49 +0200
X-ASG-Orig-Subj: [PATCH 2/7] add XXHash testing
Message-ID: <20230929122434.21776-3-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
References: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1695990296
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 913
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.114757
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

Since xxhash is a hidden feature,
considered broken, but working nonetherless,
it should be tested as well.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 tests/bcachefs/single_device.ktest | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tests/bcachefs/single_device.ktest b/tests/bcachefs/single_device.ktest
index e9e374f..21ad7c7 100755
--- a/tests/bcachefs/single_device.ktest
+++ b/tests/bcachefs/single_device.ktest
@@ -654,6 +654,15 @@ test_crc64()
 	${ktest_scratch_dev[0]}
 }
 
+test_xxhash()
+{
+    run_basic_fio_test                         \
+       --metadata_checksum=xxhash              \
+       --data_checksum=xxhash                  \
+       ${ktest_scratch_dev[0]}
+}
+
+
 test_crypto_locked_mnt()
 {
     echo foo|bcachefs format --encrypted ${ktest_scratch_dev[0]}
-- 
2.42.0

