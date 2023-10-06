Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73DEBE81E01
	for <linux-bcachefs@archiver.kernel.org>; Fri,  6 Oct 2023 14:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjJFOK0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 6 Oct 2023 10:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjJFOKZ (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 6 Oct 2023 10:10:25 -0400
Received: from relay-b01.edpnet.be (relay-b01.edpnet.be [212.71.1.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A7FA6
        for <linux-bcachefs@vger.kernel.org>; Fri,  6 Oct 2023 07:10:22 -0700 (PDT)
X-ASG-Debug-ID: 1696601416-2392342037a6e10005-qsCQDO
Received: from linuxserver.costadelsollie.local (212.71.9.157.dyn.edpnet.net [212.71.9.157]) by relay-b01.edpnet.be with ESMTP id 3QuF29yRSYzGWCbG; Fri, 06 Oct 2023 16:10:19 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Apparent-Source-IP: 212.71.9.157
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     kent.overstreet@linux.dev, bfoster@redhat.com
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH ktest v2 4/9] ktest: upgrade to debian trixie channel
Date:   Fri,  6 Oct 2023 15:54:27 +0200
X-ASG-Orig-Subj: [PATCH ktest v2 4/9] ktest: upgrade to debian trixie channel
Message-ID: <20231006140943.41110-5-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231006140943.41110-1-janpieter.sollie@kabelmail.de>
References: <20231006140943.41110-1-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 212.71.9.157.dyn.edpnet.net[212.71.9.157]
X-Barracuda-Start-Time: 1696601419
X-Barracuda-URL: https://212.71.1.221:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 5374
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

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

Due to bcachefs being mainlined soon (hopefully),
it's worth considering a more recent update channel,
which may include bcachefs features in the future.

Necessary adjustments have been made for the packages,
but kernel requirements may still need some extra tweaks

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel  |  8 +++-----
 lib/common.sh      |  8 +++++---
 lib/libktest.sh    |  2 +-
 root_image         | 15 ++++++++-------
 tests/test-libs.sh |  4 ++--
 5 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index 9121fd1..38cfd25 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -121,10 +121,8 @@ run_ktest()
 
 do_make()
 {
-    if [[ -n $CROSS_COMPILE ]]; then
-	export ARCH="$KERNEL_ARCH"
-	export CROSS_COMPILE="$ARCH_TRIPLE-"
-    fi
+	local ARCH="$KERNEL_ARCH"
+	local CROSS_COMPILE="$ARCH_TRIPLE-"
 
     make --jobs="$ktest_njobs"			\
 	--directory="$ktest_kernel_source"    	\
@@ -192,7 +190,7 @@ build_kernel()
 
     log_verbose "kernel_config_require: ${ktest_kernel_config_require[@]}"
 
-    MAKEARGS+=("LOCALVERSION=-ktest")
+    MAKEARGS+=("LOCALVERSION=-ktest" ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-")
 
     for opt in "${ktest_kernel_config_require[@]}"; do
 	[[ -n $opt ]] && kernel_opt set "$opt"
diff --git a/lib/common.sh b/lib/common.sh
index b94557d..8629e9f 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -83,7 +83,7 @@ join_by()
 parse_arch()
 {
     case $1 in
-	x86|i386)
+	x86|i386|i686)
 	    ktest_arch=x86
 	    DEBIAN_ARCH=i386
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
@@ -92,7 +92,7 @@ parse_arch()
 	    BITS=32
 
 	    QEMU_PACKAGE=qemu-system-x86
-	    QEMU_BIN=qemu-system-x86_64
+	    QEMU_BIN=qemu-system-i386
 	    ;;
 	x86_64|amd64)
 	    ktest_arch=x86_64
@@ -188,7 +188,8 @@ parse_arch()
     if [[ $ktest_arch != $(uname -m) ]]; then
 	CROSS_COMPILE=1
     fi
-
+    #special case: x86_64 is able to run i386 code.  this isn't always the case for armv8 -> armv7 (cortex A35)
+    [[ $DEBIAN_ARCH == "i386" ]] && [[ "$(uname -m)" == "x86_64" ]] && CROSS_COMPILE=0
     export DEBIAN_ARCH
     export MIRROR
     export ARCH_TRIPLE
@@ -196,6 +197,7 @@ parse_arch()
     export QEMU_PACKAGE
     export QEMU_BIN
     export ktest_arch
+    export BITS
 }
 
 find_command() {
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 8ead78b..9e8f4db 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -309,7 +309,7 @@ start_vm()
     local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
     local accel=kvm
     local cputype=host
-    [[ $(uname -m) == $ktest_arch ]] || accel=tcg && cputype=max
+    [[ "${CROSS_COMPILE:-0}" == "1" ]] && accel=tcg && cputype=max
     case $ktest_arch in
 	x86|x86_64)
 	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
diff --git a/root_image b/root_image
index 87add22..5d9c767 100755
--- a/root_image
+++ b/root_image
@@ -45,6 +45,7 @@ if [[ $# = 0 ]]; then
 fi
 
 ktest_image=""
+ktest_arch="$(uname -m)"
 CMD="cmd_$1"
 shift
 
@@ -100,7 +101,7 @@ PACKAGES+=(libudev-dev libldap2-dev)
 PACKAGES+=(acct bsdextrautils xfsprogs xfslibs-dev quota libcap2-bin)
 PACKAGES+=(libattr1-dev libaio-dev libgdbm-dev libacl1-dev gettext)
 PACKAGES+=(libssl-dev libgdbm-dev libgdbm-compat-dev liburing-dev)
-PACKAGES+=(duperemove thin-provisioning-tools fsverity)
+PACKAGES+=(duperemove fsverity)
 
 # xfsprogs:
 PACKAGES+=(libinih-dev)
@@ -123,10 +124,9 @@ PACKAGES+=("linux-headers-generic")
 # DKMS needs to cross-compile the module,
 # against a different kernel on a different CPUarchitecture.
 # this has to cause errors
-[ $CROSS_COMPILE == 1 ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
+[ -z ${CROSS_COMPILE:-0} ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
+
 
-# suspend testing:
-# [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
 
 EXCLUDE=(dmidecode nano rsyslog logrotate cron		\
     iptables nfacct					\
@@ -241,6 +241,7 @@ update_packages()
     chmod 755 "$MNT"/tmp/rustup.sh
 
     _chroot "$MNT" /tmp/rustup.sh -y
+    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
 }
 
 trim_image()
@@ -304,10 +305,10 @@ cmd_create()
 	--arch="$DEBIAN_ARCH"				\
 	--exclude=$(join_by , "${EXCLUDE[@]}")		\
 	--foreign					\
-	--components='main,contrib,non-free,bullseye-backports' \
-	bullseye "$MNT" "$MIRROR"
+	--components='main,contrib,non-free' \
+	trixie "$MNT" "$MIRROR"
 
-    [ ${CROSS_COMPILE} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
+    [ ${CROSS_COMPILE:-0} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
 
diff --git a/tests/test-libs.sh b/tests/test-libs.sh
index 8545911..2986f56 100644
--- a/tests/test-libs.sh
+++ b/tests/test-libs.sh
@@ -7,9 +7,9 @@
 . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/prelude.sh
 . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/kconfig.sh
 
-config-mem 4G
+config-mem 8G
 
-(($ktest_cpus > 16)) && ktest_cpus=16
+(($ktest_cpus > 8)) && ktest_cpus=8
 
 # Usage:
 # setup_tracing tracepoint_glob
-- 
2.42.0

