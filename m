Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3325E71D25
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 12:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjI2MZG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjI2MZE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 08:25:04 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F301AA
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 05:25:02 -0700 (PDT)
X-ASG-Debug-ID: 1695990296-214fdf08dd10a60007-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b02.edpnet.be with ESMTP id 4so1d33yNaxbgzka; Fri, 29 Sep 2023 14:24:59 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH 6/7] Enable rust support cross-arch
Date:   Fri, 29 Sep 2023 14:20:53 +0200
X-ASG-Orig-Subj: [PATCH 6/7] Enable rust support cross-arch
Message-ID: <20230929122434.21776-7-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
References: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1695990299
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3743
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

Make the rust compiler instsallable via rustup even though it's not in the vm yet.
This avoids rust compile errors on emulated CPUs,
rustup installs for host cpu kernel architecture instead of VM architecture.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 lib/common.sh    | 4 ++++
 lib/testrunner   | 4 +---
 root_image       | 2 +-
 tests/kconfig.sh | 3 +--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/lib/common.sh b/lib/common.sh
index d9012aa..8ed82ea 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -87,6 +87,7 @@ parse_arch()
 	    ktest_arch=x86
 	    DEBIAN_ARCH=i386
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
+	    RUST_TRIPLE=i686-unknown-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=32
@@ -98,6 +99,7 @@ parse_arch()
 	    ktest_arch=x86_64
 	    DEBIAN_ARCH=amd64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86_64}
+	    RUST_TRIPLE=x86_64-unknown-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=64
@@ -109,6 +111,7 @@ parse_arch()
 	    ktest_arch=aarch64
 	    DEBIAN_ARCH=arm64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARM64}
+	    RUST_TRIPLE=aarch64-unknown-linux-gnu
 
 	    KERNEL_ARCH=arm64
 	    BITS=64
@@ -120,6 +123,7 @@ parse_arch()
 	    ktest_arch=arm
 	    DEBIAN_ARCH=armhf
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARMV7}
+	    RUST_TRIPLE=armv7-unknown-linux-gnueabihf
 
 	    KERNEL_ARCH=arm
 	    BITS=32
diff --git a/lib/testrunner b/lib/testrunner
index a8e8d17..d677d3b 100755
--- a/lib/testrunner
+++ b/lib/testrunner
@@ -96,10 +96,8 @@ for i in "${ktest_make_install[@]}"; do
     if [[ -f configure && ! -f Makefile ]]; then
 	run_quiet "configure $(basename $i)" ./configure
     fi
-    #this won't make me popular - compiling bcachefs tools with rust support on a emulated machine is too heavy to be useful, so omit it:
-    rustcompile="" && [[ "$(systemd-detect-virt)" == "qemu" ]] && rustcompile="NO_RUST=1"
     #bcachefs tools sometimes seems to use compiled files from previous runs, even if other architecture, so clean out:
-    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean
+    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean & rm -rf "rust-src/targets/*"
     run_quiet "building $(basename $i)" make $rustcompile -j $ktest_cpus
     run_quiet "installing $(basename $i)" make -j $ktest_cpus install
     popd > /dev/null
diff --git a/root_image b/root_image
index 5d9c767..adc34cd 100755
--- a/root_image
+++ b/root_image
@@ -240,7 +240,7 @@ update_packages()
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
     chmod 755 "$MNT"/tmp/rustup.sh
 
-    _chroot "$MNT" /tmp/rustup.sh -y
+    _chroot "$MNT" /tmp/rustup.sh --default-host $RUST_TRIPLE -y
     echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
 }
 
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index b259515..2c4f8ea 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -55,7 +55,6 @@ case $ktest_arch in
 	require-kernel-config RTC_DRV_PL031
 
 	have_virtio=1
-	have_kvmguest=1
 
 	require-kernel-append console=hvc0
 	;;
@@ -63,9 +62,9 @@ case $ktest_arch in
 	require-kernel-config PCI_HOST_GENERIC
 	require-kernel-config RTC_DRV_PL031
 	require-kernel-config COMPAT_32BIT_TIME
+	require-kernel-config IOMMU_SUPPORT
 
 	have_virtio=1
-	have_kvmguest=1
 
 	require-kernel-append console=hvc0
 	;;
-- 
2.42.0

