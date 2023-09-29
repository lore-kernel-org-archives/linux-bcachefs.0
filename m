Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975A0E71D20
	for <linux-bcachefs@archiver.kernel.org>; Fri, 29 Sep 2023 12:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbjI2MZE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 29 Sep 2023 08:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjI2MZC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 29 Sep 2023 08:25:02 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABB41B1
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Sep 2023 05:25:00 -0700 (PDT)
X-ASG-Debug-ID: 1695990296-214fdf08dd10a60004-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b02.edpnet.be with ESMTP id hpPKzpdkR2Ik3RhW; Fri, 29 Sep 2023 14:24:58 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH 3/7] ktest-bcachefs: run tests on emulated architectures
Date:   Fri, 29 Sep 2023 14:20:50 +0200
X-ASG-Orig-Subj: [PATCH 3/7] ktest-bcachefs: run tests on emulated architectures
Message-ID: <20230929122434.21776-4-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
References: <20230929122434.21776-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1695990297
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 5269
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

Allow the tests to run on a non-ABI-compatible cpu,
verify code when the architecture isn't physically available.
in the future, bcachefs-tools should be cross-compiled,
and the list of CPU types should be expanded

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel |  2 +-
 lib/common.sh     | 11 ++++++++---
 lib/libktest.sh   |  8 ++++++--
 lib/testrunner    | 10 +++++++++-
 root_image        |  8 +++++++-
 tests/kconfig.sh  |  2 ++
 6 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index 72990ba..9121fd1 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -107,7 +107,7 @@ ktest_kernel_source=$(readlink -e "$ktest_kernel_source")
 ktest_kernel_build="$ktest_out/kernel_build.$ktest_arch"
 mkdir -p "$ktest_kernel_build"
 
-if [[ -n $CROSS_COMPILE ]]; then
+if [[ -z ${CROSS_COMPILE:+x} ]]; then
     checkdep "$ARCH_TRIPLE-gcc" "gcc-$ARCH_TRIPLE"
 fi
 
diff --git a/lib/common.sh b/lib/common.sh
index 078f512..b94557d 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -80,9 +80,6 @@ join_by()
     echo "$*"
 }
 
-ktest_arch=$(uname -m)
-CROSS_COMPILE=""
-
 parse_arch()
 {
     case $1 in
@@ -191,6 +188,14 @@ parse_arch()
     if [[ $ktest_arch != $(uname -m) ]]; then
 	CROSS_COMPILE=1
     fi
+
+    export DEBIAN_ARCH
+    export MIRROR
+    export ARCH_TRIPLE
+    export KERNEL_ARCH
+    export QEMU_PACKAGE
+    export QEMU_BIN
+    export ktest_arch
 }
 
 find_command() {
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 9b4931d..8ead78b 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -85,6 +85,7 @@ parse_ktest_arg()
 
 parse_args_post()
 {
+    [ -z ${ktest_arch:+x} ] && ktest_arch=$(uname -m)
     parse_arch "$ktest_arch"
 
     ktest_out=$(readlink -f "$ktest_out")
@@ -306,12 +307,15 @@ start_vm()
     kernelargs+=("${ktest_kernel_append[@]}")
 
     local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
+    local accel=kvm
+    local cputype=host
+    [[ $(uname -m) == $ktest_arch ]] || accel=tcg && cputype=max
     case $ktest_arch in
 	x86|x86_64)
-	    qemu_cmd+=(-cpu host -machine type=q35,accel=kvm,nvdimm=on)
+	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
 	    ;;
 	aarch64)
-	    qemu_cmd+=(-cpu host -machine type=virt,gic-version=max,accel=kvm)
+	    qemu_cmd+=(-cpu $cputype -machine type=virt,gic-version=max,accel=$accel)
 	    ;;
 	mips)
 	    qemu_cmd+=(-cpu 24Kf -machine malta)
diff --git a/lib/testrunner b/lib/testrunner
index acbc45f..a8e8d17 100755
--- a/lib/testrunner
+++ b/lib/testrunner
@@ -20,6 +20,10 @@ ktest_out="/host/$ktest_out"
 ln -sf $ktest_dir /ktest
 ln -sf $ktest_out /ktest-out
 
+. /ktest/lib/common.sh
+
+parse_arch $(uname -m)
+
 # Some home directories are in weird places:
 mkdir -p $(dirname $home)
 ln -sf /host/$home $home
@@ -92,7 +96,11 @@ for i in "${ktest_make_install[@]}"; do
     if [[ -f configure && ! -f Makefile ]]; then
 	run_quiet "configure $(basename $i)" ./configure
     fi
-    run_quiet "building $(basename $i)" make -j $ktest_cpus
+    #this won't make me popular - compiling bcachefs tools with rust support on a emulated machine is too heavy to be useful, so omit it:
+    rustcompile="" && [[ "$(systemd-detect-virt)" == "qemu" ]] && rustcompile="NO_RUST=1"
+    #bcachefs tools sometimes seems to use compiled files from previous runs, even if other architecture, so clean out:
+    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean
+    run_quiet "building $(basename $i)" make $rustcompile -j $ktest_cpus
     run_quiet "installing $(basename $i)" make -j $ktest_cpus install
     popd > /dev/null
 done
diff --git a/root_image b/root_image
index 26c99fe..87add22 100755
--- a/root_image
+++ b/root_image
@@ -118,7 +118,12 @@ PACKAGES+=(cryptsetup)
 PACKAGES+=(multipath-tools sg3-utils srptools)
 
 # ZFS support
-PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
+PACKAGES+=("linux-headers-generic")
+# unless no other option when cross-compiling, ignore ZFS
+# DKMS needs to cross-compile the module,
+# against a different kernel on a different CPUarchitecture.
+# this has to cause errors
+[ $CROSS_COMPILE == 1 ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
 
 # suspend testing:
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
@@ -302,6 +307,7 @@ cmd_create()
 	--components='main,contrib,non-free,bullseye-backports' \
 	bullseye "$MNT" "$MIRROR"
 
+    [ ${CROSS_COMPILE} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
 
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index 68005fc..73e93db 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -4,6 +4,8 @@ have_kvmguest=0
 have_virtio=0
 have_suspend=0
 
+[ -z ${ktest_arch:+x} ] && ktest_arch=$(uname -m)
+
 case $ktest_arch in
     x86)
 	require-kernel-config SMP
-- 
2.42.0

