Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647FEC4167D
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjJ3PLX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbjJ3PLV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:21 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DDAB3
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:18 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae03410007-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id ABs7xHcl5uQS5IDS; Mon, 30 Oct 2023 16:11:14 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 06/10] Enable rust support cross-arch
Date:   Mon, 30 Oct 2023 15:58:17 +0100
X-ASG-Orig-Subj: [PATCH v3 06/10] Enable rust support cross-arch
Message-ID: <20231030151046.29827-7-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678673
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3814
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

Make the rust compiler instsallable via rustup even though it's not in the vm yet.
This avoids rust compile errors on emulated CPUs,
rustup installs for host cpu kernel architecture instead of VM architecture.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 lib/common.sh    | 4 ++++
 lib/testrunner   | 6 ++----
 root_image       | 2 +-
 tests/kconfig.sh | 3 +--
 4 files changed, 8 insertions(+), 7 deletions(-)

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
index a8e8d17..b3ca3fb 100755
--- a/lib/testrunner
+++ b/lib/testrunner
@@ -96,11 +96,9 @@ for i in "${ktest_make_install[@]}"; do
     if [[ -f configure && ! -f Makefile ]]; then
 	run_quiet "configure $(basename $i)" ./configure
     fi
-    #this won't make me popular - compiling bcachefs tools with rust support on a emulated machine is too heavy to be useful, so omit it:
-    rustcompile="" && [[ "$(systemd-detect-virt)" == "qemu" ]] && rustcompile="NO_RUST=1"
     #bcachefs tools sometimes seems to use compiled files from previous runs, even if other architecture, so clean out:
-    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean
-    run_quiet "building $(basename $i)" make $rustcompile -j $ktest_cpus
+    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean & rm -rf "rust-src/targets/*"
+    run_quiet "building $(basename $i)" make -j $ktest_cpus
     run_quiet "installing $(basename $i)" make -j $ktest_cpus install
     popd > /dev/null
 done
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

