Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4BBC4332F
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjJ3PLT (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbjJ3PLS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:18 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0570DB
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:14 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae03410001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id 6HAmoclyyO7aQ6C4; Mon, 30 Oct 2023 16:11:11 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org
Subject: bcachefs ktest cross-architecture emulation support
Date:   Mon, 30 Oct 2023 15:58:11 +0100
X-ASG-Orig-Subj: bcachefs ktest cross-architecture emulation support
Message-ID: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678671
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1081
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

Hi all,

As announced a few weeks ago, hereby the v3 of my cross-arch work.
This is a pretty complete release,
but requires a recent qemu version to work (tested broken with 8.1.0, working with 8.1.1

Changes since v2:
- bcachefs-tools C code is precompiled on the host.
- most devices have been put inside a pci bridge to improve compatibility
- move to virtio-scsi instead of virtio-blk to improve compatibility
- general bug-fixing on less used architectures

RISCV64 is not functional at the moment,
because it's not clear to me whether it stays in the debian ports or debian tree,
the patch uses trixie (upcoming release) to minimize the dependency problems,
and sid for unsupported architectures.

Supported architectures:
- ARMv7 hard-float
- AARCH64
- POWER8 (Big endian)
- S390X (Big Endian)
- SPARC64 (Big Endian)
- x86
- x86_64
- riscv64

All arches are confirmed booting, cross-compile works.
I tried compiling bcachefs-tools in the VM;
it effectively picked up precompiled code

I'm happy to hear your thoughts,

Janpieter Sollie


