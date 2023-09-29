Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7520E71D22
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 12:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjI2MZD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjI2MZB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 08:25:01 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1F71AC
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 05:24:58 -0700 (PDT)
X-ASG-Debug-ID: 1695990296-214fdf08dd10a60001-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b02.edpnet.be with ESMTP id JpqrKJ93PeR4ICSE; Fri, 29 Sep 2023 14:24:56 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH 0/7] Refresh foreign architecture emulation
Date:   Fri, 29 Sep 2023 14:20:47 +0200
X-ASG-Orig-Subj: [PATCH 0/7] Refresh foreign architecture emulation
Message-ID: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1695990296
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1284
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

Current revision allows tests to be emulated on the host,
or on binary-compatible hosts at best (eg: i386 on amd64).
These patches allow testing on a few extra setups,
to make sure bcachefs code can be tested on all those arches,
without necessarly buying one to run the tests

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>

Janpieter Sollie (7):
  Increase cross-compile compatibility
  add XXHash testing
  ktest-bcachefs: run tests on emulated architectures
  ktest: upgrade to debian trixie channel
  enable ARMv7 support
  Enable rust support cross-arch
  Ktest: re-introduce foreign unsupported architectures

 .gitignore                         |  1 +
 build-test-kernel                  | 36 ++++++------
 cross.conf                         | 11 ++++
 lib/common.sh                      | 90 +++++++++++++++---------------
 lib/libktest.sh                    | 33 +++++++----
 lib/testrunner                     |  8 ++-
 root_image                         | 52 +++++++++++++----
 tests/bcachefs/single_device.ktest |  9 +++
 tests/kconfig.sh                   | 53 +++++++++++++-----
 tests/test-libs.sh                 |  4 +-
 10 files changed, 195 insertions(+), 102 deletions(-)
 create mode 100644 cross.conf

-- 
2.42.0

