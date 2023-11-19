Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3334D115
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:09 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b0003-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id KhGrPWn1q19UBGtt; Sun, 19 Nov 2023 17:02:07 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	jpsollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v5 02/10] Run bcachefs tests on emulated architectures
Date: Sun, 19 Nov 2023 16:48:09 +0100
X-ASG-Orig-Subj: [PATCH v5 02/10] Run bcachefs tests on emulated architectures
Message-ID: <20231119160155.34496-3-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231119160155.34496-1-janpieter.sollie@kabelmail.de>
References: <20231119160155.34496-1-janpieter.sollie@kabelmail.de>
Reply-To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1700409726
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 5884
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Allow the tests to run on a non-ABI-compatible cpu,
verify code when the architecture isn't physically available.
in the future, bcachefs-tools should be cross-compiled,
and the list of CPU types should be expanded

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel                    |  8 ++------
 lib/common.sh                        | 11 ++++++++---
 lib/libktest.sh                      |  8 ++++++--
 lib/testrunner                       |  4 ++++
 root_image                           |  8 +++++++-
 tests/bcachefs/bcachefs-test-libs.sh |  8 ++++++++
 tests/kconfig.sh                     |  2 ++
 7 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index 72990ba..057b66e 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -107,7 +107,7 @@ ktest_kernel_source=$(readlink -e "$ktest_kernel_source")
 ktest_kernel_build="$ktest_out/kernel_build.$ktest_arch"
 mkdir -p "$ktest_kernel_build"
 
-if [[ -n $CROSS_COMPILE ]]; then
+if [[ ${CROSS_COMPILE+x} ]]; then
     checkdep "$ARCH_TRIPLE-gcc" "gcc-$ARCH_TRIPLE"
 fi
 
@@ -121,10 +121,6 @@ run_ktest()
 
 do_make()
 {
-    if [[ -n $CROSS_COMPILE ]]; then
-	export ARCH="$KERNEL_ARCH"
-	export CROSS_COMPILE="$ARCH_TRIPLE-"
-    fi
 
     make --jobs="$ktest_njobs"			\
 	--directory="$ktest_kernel_source"    	\
@@ -192,7 +188,7 @@ build_kernel()
 
     log_verbose "kernel_config_require: ${ktest_kernel_config_require[@]}"
 
-    MAKEARGS+=("LOCALVERSION=-ktest")
+    MAKEARGS+=("LOCALVERSION=-ktest" ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-")
 
     for opt in "${ktest_kernel_config_require[@]}"; do
 	[[ -n $opt ]] && kernel_opt set "$opt"
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
index acbc45f..4eb73f2 100755
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
diff --git a/root_image b/root_image
index 26c99fe..a881714 100755
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
+[[ -n $CROSS_COMPILE ] && PACKAGES+=(dkms zfsutils-linux zfs-dkms)
 
 # suspend testing:
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
@@ -302,6 +307,7 @@ cmd_create()
 	--components='main,contrib,non-free,bullseye-backports' \
 	bullseye "$MNT" "$MIRROR"
 
+    [[ -n ${CROSS_COMPILE} ]] || cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
 
diff --git a/tests/bcachefs/bcachefs-test-libs.sh b/tests/bcachefs/bcachefs-test-libs.sh
index 7167856..05996b1 100644
--- a/tests/bcachefs/bcachefs-test-libs.sh
+++ b/tests/bcachefs/bcachefs-test-libs.sh
@@ -5,8 +5,16 @@
 #
 
 . $(dirname $(readlink -e "${BASH_SOURCE[0]}"))/../test-libs.sh
+bch_loc=$(dirname $(readlink -e "${BASH_SOURCE[0]}"))/bcachefs-tools
 
 require-git http://evilpiepirate.org/git/bcachefs-tools.git
+if [[ ! -f "${bch_loc}/.last_arch_for_compile" || "$(cat ${bch_loc}/.last_arch_for_compile)" != $ktest_arch ]]; then
+	make -C ${bch_loc} clean >/dev/null 2>&1;
+	rm -rf "${bch_loc}/rust-src/target/*";
+	find ${bch_loc} -name "*.o" -exec rm {} \;
+	find ${bch_loc} -name "*.a" -exec rm {} \;
+	echo $ktest_arch > ${bch_loc}/.last_arch_for_compile
+fi
 require-make bcachefs-tools
 
 require-kernel-config BCACHEFS_FS
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
2.42.1

