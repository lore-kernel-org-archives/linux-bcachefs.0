Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15164E81E00
	for <linux-bcachefs@archiver.kernel.org>; Fri,  6 Oct 2023 14:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjJFOKZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 6 Oct 2023 10:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjJFOKY (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 6 Oct 2023 10:10:24 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79729E
        for <linux-bcachefs@vger.kernel.org>; Fri,  6 Oct 2023 07:10:22 -0700 (PDT)
X-ASG-Debug-ID: 1696601416-2392342037a6e10001-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b01.edpnet.be with ESMTP id KpNFLCIZe84BaSOl; Fri, 06 Oct 2023 16:10:17 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH ktest v2 0/9] introduce cross-CPU ktest options
Date:   Fri,  6 Oct 2023 15:54:23 +0200
X-ASG-Orig-Subj: [PATCH ktest v2 0/9] introduce cross-CPU ktest options
Message-ID: <20231006140943.41110-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1696601417
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2269
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

as version 1 was quite immature,
and the results for testers were not that huge,
I am presenting a second version of the patch:

This patch allows to run ktest on a number of different CPUs,
even if not binary compatible with the host.
This requires that Qemu static is correctly installed,
and qemu is bug-free (qemu issue #1917 for ppc64).

Architectures supported:
- ARMV7 (hard float only) (Little Endian)
- AARCH64 (Little Endian)
- PowerPC64 (Big endian)
- RISCV (64 bit only) (Little Endian)
- S390X (Big Endian)
- SPARC64 (Big Endian)
- X86 (Little Endian)
- X86_64 (Little Endian)

This patch allows KVM emulation for X86* hosts,
others are using the TCG emulator.

A number of workarounds have been added for packages,
Debian often has incomplete dependencies in sid.

On supported architectures,
the root_image is based on Trixie.

In future versions, I'll have to look at the cross-compile issue:
currently, when building bcachefs tools,
it is needed to compile both C and Rust, every time another arch is launched.
it should not be that hard.

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>

Janpieter Sollie (9):
  Increase cross-compile compatibility
  add XXHash testing
  ktest-bcachefs: run tests on emulated architectures
  ktest: upgrade to debian trixie channel
  enable ARMv7 support
  Enable rust support cross-arch
  Ktest: re-introduce foreign unsupported architectures
  fixup! modify default powerpc variables
  fix a number of issues with cross-architecture testing

 .gitignore                           |   1 +
 build-test-kernel                    |  51 ++++++------
 cross.conf                           |  24 ++++++
 lib/common.sh                        |  98 ++++++++++++----------
 lib/libktest.sh                      |  36 ++++++---
 lib/testrunner                       |   6 ++
 root_image                           | 116 +++++++++++++++++++++++----
 tests/bcachefs/bcachefs-test-libs.sh |   4 +
 tests/bcachefs/single_device.ktest   |   9 +++
 tests/kconfig.sh                     |  79 ++++++++++++++----
 tests/test-libs.sh                   |   4 +-
 11 files changed, 315 insertions(+), 113 deletions(-)
 create mode 100644 cross.conf

-- 
2.42.0

