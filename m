Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE25FC4167D
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjJ3PLU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbjJ3PLS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:18 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04158DD
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:14 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae03410003-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id Ynd7bJ57XG2TcV4M; Mon, 30 Oct 2023 16:11:12 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 02/10] add XXHash testing
Date:   Mon, 30 Oct 2023 15:58:13 +0100
X-ASG-Orig-Subj: [PATCH v3 02/10] add XXHash testing
Message-ID: <20231030151046.29827-3-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678672
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 913
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=NO_REAL_NAME
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116086
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.00 NO_REAL_NAME           From: does not include a real name
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
index 7cc6c5b..b4ac875 100755
--- a/tests/bcachefs/single_device.ktest
+++ b/tests/bcachefs/single_device.ktest
@@ -679,6 +679,15 @@ test_crc64()
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

