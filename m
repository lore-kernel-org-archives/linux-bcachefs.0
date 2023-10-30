Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B028BC4167B
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbjJ3PLZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbjJ3PLW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:22 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86621C9
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:18 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae03410008-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id og6tOlDlJvQ3jwHj; Mon, 30 Oct 2023 16:11:14 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 07/10] Ktest: re-introduce foreign unsupported architectures
Date:   Mon, 30 Oct 2023 15:58:18 +0100
X-ASG-Orig-Subj: [PATCH v3 07/10] Ktest: re-introduce foreign unsupported architectures
Message-ID: <20231030151046.29827-8-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678674
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 8986
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

Whereas MIPS and MIPS64 are abandoned my manufacturer,
SPARC and POWER seem to be still alive,
and upcoming RISCV also deserves some attention,
so add those to the list of supported architectures.

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel |  9 +++++---
 cross.conf        |  3 +++
 lib/common.sh     | 59 ++++++++++++++---------------------------------
 lib/libktest.sh   | 12 ++++++----
 root_image        | 37 ++++++++++++++++++++++-------
 tests/kconfig.sh  | 27 +++++++++++++---------
 6 files changed, 78 insertions(+), 69 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index ea0d56e..4e3c646 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -230,11 +230,14 @@ build_kernel()
 	    ;;
 	mips)
 	    install -m0644 "$BOOT/vmlinux.strip"	"$ktest_kernel_binary/vmlinuz"
-	    #install -m0644 "$ktest_kernel_build/vmlinux"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
 	default)
-	    echo "Don't know how to install kernel"
-	    exit 1
+	    if [ -f "$BOOT/Image" ]; then
+		 install -m0644 "$BOOT/Image"	"$ktest_kernel_binary/vmlinuz"
+	    else
+		echo "Don't know how to install kernel"
+	    	exit 1
+	    fi
 	    ;;
     esac
 
diff --git a/cross.conf b/cross.conf
index d98219e..a78bffd 100644
--- a/cross.conf
+++ b/cross.conf
@@ -6,3 +6,6 @@ ARCH_TRIPLE_X86=x86-linux-gnu
 ARCH_TRIPLE_X86_64=x86_64-linux-gnu
 ARCH_TRIPLE_ARM64=aarch64-linux-gnu
 ARCH_TRIPLE_ARMV7=arm-linux-gnueabihf
+ARCH_TRIPLE_PPC64=powerpc64-linux-gnu
+ARCH_TRIPLE_SPARC64=sparc64-linux-gnu
+ARCH_TRIPLE_RISCV64=riscv64-linux-gnu
diff --git a/lib/common.sh b/lib/common.sh
index 8ed82ea..2085bd6 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -131,39 +131,23 @@ parse_arch()
 	    QEMU_PACKAGE=qemu-system-arm
 	    QEMU_BIN=qemu-system-arm
 	    ;;
-	mips)
-	    DEBIAN_ARCH=mips
-	    ARCH_TRIPLE=mips-linux-gnu
-
-	    KERNEL_ARCH=mips
-	    BITS=32
-
-	    QEMU_PACKAGE=qemu-system-mips
-	    QEMU_BIN=qemu-system-mips
-	    ;;
-	mips64)
-	    DEBIAN_ARCH=mips
-	    ARCH_TRIPLE=mips-linux-gnu
+	riscv64)
+	    DEBIAN_ARCH=riscv64
+	    ARCH_TRIPLE=${ARCH_TRIPLE_RISCV64}
+	    MIRROR=http://deb.debian.org/debian-ports
+	    RUST_TRIPLE=riscv64gc-unknown-linux-gnu
 
-	    KERNEL_ARCH=mips
+	    KERNEL_ARCH=riscv
 	    BITS=64
 
-	    QEMU_PACKAGE=qemu-system-mips
-	    QEMU_BIN=qemu-system-mips64
-	    ;;
-	sparc)
-	    DEBIAN_ARCH=sparc
-	    ARCH_TRIPLE=sparc64-linux-gnu
-
-	    KERNEL_ARCH=sparc
-	    BITS=32
-
-	    QEMU_PACKAGE=qemu-system-sparc
-	    QEMU_BIN=qemu-system-sparc
+	    QEMU_PACKAGE=qemu-system-riscv
+	    QEMU_BIN=qemu-system-riscv64
 	    ;;
 	sparc64)
-	    DEBIAN_ARCH=sparc
-	    ARCH_TRIPLE=sparc64-linux-gnu
+	    DEBIAN_ARCH=sparc64
+	    ARCH_TRIPLE=${ARCH_TRIPLE_SPARC64}
+	    MIRROR=http://deb.debian.org/debian-ports
+	    RUST_TRIPLE=sparc64-unknown-linux-gnu
 
 	    KERNEL_ARCH=sparc
 	    BITS=64
@@ -171,23 +155,13 @@ parse_arch()
 	    QEMU_PACKAGE=qemu-system-sparc
 	    QEMU_BIN=qemu-system-sparc64
 	    ;;
-	ppc|powerpc)
-	    DEBIAN_ARCH=powerpc
-	    MIRROR=http://deb.debian.org/debian-ports
-
-	    ARCH_TRIPLE=powerpc-linux-gnu
-
-	    KERNEL_ARCH=powerpc
-	    BITS=32
-
-	    QEMU_PACKAGE=qemu-system-ppc
-	    QEMU_BIN=qemu-system-ppc
-	    ;;
-	ppc64)
+	ppc64|powerpc)
+	    ktest_arch=ppc64
 	    DEBIAN_ARCH=ppc64
 	    MIRROR=http://deb.debian.org/debian-ports
 
-	    ARCH_TRIPLE=powerpc-linux-gnu
+	    ARCH_TRIPLE=${ARCH_TRIPLE_PPC64}
+	    RUST_TRIPLE=powerpc64-unknown-linux-gnu
 
 	    KERNEL_ARCH=powerpc
 	    BITS=64
@@ -213,6 +187,7 @@ parse_arch()
     export QEMU_BIN
     export ktest_arch
     export BITS
+    export RUST_TRIPLE
 }
 
 find_command() {
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 689f42f..edbbec0 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -317,12 +317,14 @@ start_vm()
 	aarch64|arm)
 	    qemu_cmd+=(-cpu $cputype -machine type=virt,gic-version=max,accel=$accel)
 	    ;;
-	mips)
-	    qemu_cmd+=(-cpu 24Kf -machine malta)
-	    ktest_cpus=1
+	ppc64)
+	    qemu_cmd+=(-cpu power9)
 	    ;;
-	mips64)
-	    qemu_cmd+=(-cpu MIPS64R2-generic -machine malta)
+	sparc64)
+	    qemu_cmd+=(-cpu default)
+	    ;;
+	riscv64)
+	    qemu_cmd+=(-cpu any)
 	    ;;
     esac
 
diff --git a/root_image b/root_image
index adc34cd..8777d82 100755
--- a/root_image
+++ b/root_image
@@ -34,7 +34,7 @@ usage()
     echo
     echo "options:"
     echo "  -h			Display this help and exit"
-    echo "  -a <arch>		Architecture for vm image"
+    echo "  -a <arch>		Architecture for vm image (x86_64,armhf,i386,aarch64,sparc64,ppc64,riscv64)"
     echo "  -m <mirror>		Debian mirror"
     echo '  -i <image>		Image to create/update, defaults to /var/lib/ktest/root.$arch'
 }
@@ -124,7 +124,7 @@ PACKAGES+=("linux-headers-generic")
 # DKMS needs to cross-compile the module,
 # against a different kernel on a different CPUarchitecture.
 # this has to cause errors
-[ -z ${CROSS_COMPILE:-0} ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
+#[ -z ${CROSS_COMPILE:-0} ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
 
 
 
@@ -232,9 +232,11 @@ update_packages()
     mkdir -p "$MNT"/run/user/0
     cp /etc/resolv.conf "$MNT/etc/resolv.conf"
     _chroot "$MNT" mount -t proc none /proc
-    _chroot "$MNT" apt-get -qq update
-    _chroot "$MNT" apt-get -qq upgrade
-    _chroot "$MNT" apt-get -qq install --no-install-recommends "${PACKAGES[@]}"
+    [[ $MIRROR == *"debian-ports"* ]] && _chroot "$MNT" apt-get -qq install debian-ports-archive-keyring
+    _chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
+    _chroot "$MNT" apt-get -qq --allow-unauthenticated upgrade
+    _chroot "$MNT" apt-get -qq install -f
+    _chroot "$MNT" apt-get -qq install -m --allow-unauthenticated --no-install-recommends "${PACKAGES[@]}"
     rm -f "$MNT/var/cache/apt/archives/*.deb"
 
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
@@ -300,18 +302,37 @@ cmd_create()
     mkfs.ext4 -F "$ktest_image"
     mount "$ktest_image" "$MNT"
 
+   local debian_release="trixie" #general release
+   local keyring=""
+
+    if [[ $MIRROR == *"debian-ports"* ]]; then
+	debian_release="sid" #unofficial ports don't have named releases
+        wget https://www.ports.debian.org/archive_$(date +%Y).key
+	gpg --import archive_$(date +%Y).key
+	rm archive_$(date +%Y).key
+	echo "WARNING: $ktest_arch is unsupported, using SID release for packages"
+	echo "*******************************************************************"
+	echo "PLEASE NOTE: this often has dependency problems between packages, "
+	echo "and can prevent the install due to a dependency conflict "
+	echo "If so, contact the debian maintainer for this architecture to fix it:"
+	echo "${ktest_arch} : ${DEBIAN_ARCH}@buildd.debian.org"
+	echo "*******************************************************************"
+	echo ""
+    fi
+
     DEBOOTSTRAP_DIR=$ktest_dir/debootstrap $debootstrap	\
 	--no-check-gpg					\
 	--arch="$DEBIAN_ARCH"				\
 	--exclude=$(join_by , "${EXCLUDE[@]}")		\
+	$keyring					\
 	--foreign					\
 	--components='main,contrib,non-free' \
-	trixie "$MNT" "$MIRROR"
+	$debian_release "$MNT" "$MIRROR"
 
-    [ ${CROSS_COMPILE:-0} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
+    statichelper=$(which qemu-${ktest_arch}) || statichelper=$(which qemu-${ktest_arch}-static)
+    [ ${CROSS_COMPILE:-0} == 1 ] && cp $statichelper ${MNT}$statichelper
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
-
     update_packages
     update_files
 
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index 2c4f8ea..7607e26 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -68,24 +68,29 @@ case $ktest_arch in
 
 	require-kernel-append console=hvc0
 	;;
-    powerpc)
-	require-kernel-config ADVANCED_OPTIONS
+    ppc64)
+	require-kernel-config PPC64
+
+	have_virtio=1
+
+	require-kernel-append console=hvc0
+	;;
+    sparc64)
+	require-kernel-config 64BIT
+	require-kernel-config SMP
+	require-kernel-config VIRTIO_MENU
+	require-kernel-config PCI
 
-	have_kvmguest=1
 	have_virtio=1
-	have_suspend=1
 
 	require-kernel-append console=hvc0
 	;;
-    mips)
-	require-kernel-config MIPS_MALTA
-	require-kernel-config CPU_MIPS${BITS}_R2
-	require-kernel-config CPU_BIG_ENDIAN=y
-	require-kernel-config CPU_LITTLE_ENDIAN=n
-	require-kernel-config 32BIT
+    riscv64)
+	require-kernel-config SOC_VIRT
+	require-kernel-config VIRTIO_MENU
+	require-kernel-config PCI
 
 	have_virtio=1
-	ktest_storage_bus=piix4-ide
 
 	require-kernel-append console=hvc0
 	;;
-- 
2.42.0

