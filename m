Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596D8C00142
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjJ3PL0 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbjJ3PLX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:23 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA61EDD
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:18 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae0341000b-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id 9B8COxJJuRcbhlgC; Mon, 30 Oct 2023 16:11:16 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>,
        jpsollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 10/10] Introduce partial cross-compile of bcachefs-tools
Date:   Mon, 30 Oct 2023 15:58:21 +0100
X-ASG-Orig-Subj: [PATCH v3 10/10] Introduce partial cross-compile of bcachefs-tools
Message-ID: <20231030151046.29827-11-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678675
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 11463
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

From: Janpieter Sollie <janpieter.sollie@kabelmail.de>

When running ktest, the qemu vm needs to cross-compile bcachefs-tools.
this can be pretty slow, especially on emulated architectures.
to work around this, use the host compiler in advance.
This pre-compiles the C files into object files,
which will then be re-used on the target VM.

This feature needs fuse2fs FUSE binary to mount the ktest root image:
mounting non-root is not possible, but headers need to be included.

If the requirements aren't met, the VM needs to do everything.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel |  3 ++
 lib/common.sh     | 14 ++++++++-
 lib/libktest.sh   | 75 ++++++++++++++++++++++++++++++++++++++---------
 lib/testrunner    |  3 +-
 tests/prelude.sh  |  6 ++--
 5 files changed, 82 insertions(+), 19 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index 5df635d..ea2cafb 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -224,6 +224,9 @@ build_kernel()
 	ppc64)
 	    install -m0644 "$BOOT/zImage"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
+	sparc64)
+	    install -m0644 "$BOOT/image"	"$ktest_kernel_binary/vmlinuz"
+	    ;;
 	*)
 	    if [ -f "$BOOT/Image" ]; then
 		 install -m0644 "$BOOT/Image"	"$ktest_kernel_binary/vmlinuz"
diff --git a/lib/common.sh b/lib/common.sh
index 4f285b1..ac88713 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -88,6 +88,7 @@ parse_arch()
 	    DEBIAN_ARCH=i386
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
 	    RUST_TRIPLE=i686-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=i386-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=32
@@ -100,6 +101,7 @@ parse_arch()
 	    DEBIAN_ARCH=amd64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86_64}
 	    RUST_TRIPLE=x86_64-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=x86_64-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=64
@@ -112,6 +114,7 @@ parse_arch()
 	    DEBIAN_ARCH=arm64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARM64}
 	    RUST_TRIPLE=aarch64-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=aarch64-linux-gnu
 
 	    KERNEL_ARCH=arm64
 	    BITS=64
@@ -124,6 +127,7 @@ parse_arch()
 	    DEBIAN_ARCH=armhf
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARMV7}
 	    RUST_TRIPLE=armv7-unknown-linux-gnueabihf
+	    DEBIAN_INCLUDE_HEADERS=arm-linux-gnueabihf
 
 	    KERNEL_ARCH=arm
 	    BITS=32
@@ -135,6 +139,7 @@ parse_arch()
 	    DEBIAN_ARCH=s390x
 	    ARCH_TRIPLE=${ARCH_TRIPLE_S390X}
 	    RUST_TRIPLE=s390x-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=s390x-linux-gnu
 
 	    KERNEL_ARCH=s390
 	    BITS=64
@@ -143,10 +148,15 @@ parse_arch()
 	    QEMU_BIN=qemu-system-s390x
 	    ;;
 	riscv64)
+	    ktest_arch=riscv64
 	    DEBIAN_ARCH=riscv64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_RISCV64}
+#TODO: risc-v is being promoted out of "unsupported backports and moved into main debian architectures.
+#it is currently not yet supported in trixie, but it might still be - or might not - we don't know.
+#it IS impossible to use the current mirror, but maybe another solution comes up when riscv64's support status is clear.
 	    MIRROR=http://deb.debian.org/debian-ports
 	    RUST_TRIPLE=riscv64gc-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=riscv64gc-linux-gnu
 
 	    KERNEL_ARCH=riscv
 	    BITS=64
@@ -155,10 +165,12 @@ parse_arch()
 	    QEMU_BIN=qemu-system-riscv64
 	    ;;
 	sparc64)
+            ktest_arch=sparc64
 	    DEBIAN_ARCH=sparc64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_SPARC64}
 	    MIRROR=http://deb.debian.org/debian-ports
 	    RUST_TRIPLE=sparc64-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=sparc64-linux-gnu
 
 	    KERNEL_ARCH=sparc
 	    BITS=64
@@ -170,9 +182,9 @@ parse_arch()
 	    ktest_arch=ppc64
 	    DEBIAN_ARCH=ppc64
 	    MIRROR=http://deb.debian.org/debian-ports
-
 	    ARCH_TRIPLE=${ARCH_TRIPLE_PPC64}
 	    RUST_TRIPLE=powerpc64-unknown-linux-gnu
+	    DEBIAN_INCLUDE_HEADERS=powerpc64-linux-gnu
 
 	    KERNEL_ARCH=powerpc
 	    BITS=64
diff --git a/lib/libktest.sh b/lib/libktest.sh
index b2c3b04..d4c0826 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -258,10 +258,42 @@ get_unused_port()
 	| shuf | head -n1
 }
 
+#cross compiling bcachefs is a delicate operation,
+#so run it in a separate shell
+#for now, we're only building libbcachefs.a,
+#which compiles 90% of the C code.
+#if the operation completes successfully, a .crossarch is made indicating the cross compile has been completed.
+#at the next invocation, if .crossarch is still what it should be, there's no need to recompile again.
+
+try_construct_cross_bcachefs()
+(
+     cd ${ktest_dir}/tests/bcachefs/bcachefs-tools/
+     make clean
+     rm -rf rust-src/target/release
+     rootpath=${ktest_out}/vm/cross-user
+     make CC=${ARCH_TRIPLE}-gcc EXTRA_CFLAGS="-I/${rootpath}/usr/include/ -I/${rootpath}/usr/include/${DEBIAN_INCLUDE_HEADERS}/ -ffile-prefix-map=${rootpath}=/" -j $ktest_cpus libbcachefs.a && echo ${ktest_arch} > .crossarch
+     find -name "*.d" -exec sed -i "s/${rootpath//\//\\\/}/\//g" {} \;
+)
+
+# try to mount the root image via fuse,
+# this way the debian target headers can be included instead of the host OS
+# if anything fails, target will need to fall back to target qemu compile,
+# which is a lot slower, obviously
+
+premake_cross_bcachefs()
+{
+     [ "$(cat $ktest_dir/tests/bcachefs/bcachefs-tools/.crossarch)" == "$ktest_arch" ] && return 0;
+     which fuse2fs > /dev/null 2>&1 || return -1;
+     mkdir $ktest_out/vm/cross-user || return -2;
+     fuse2fs -o ro $ktest_root_image $ktest_out/vm/cross-user || return -3;
+     try_construct_cross_bcachefs
+     umount $ktest_out/vm/cross-user;
+     return 0;
+}
+
 start_vm()
 {
     log_verbose "ktest_arch=$ktest_arch"
-
     checkdep $QEMU_BIN $QEMU_PACKAGE
     check_root_image_exists
 
@@ -306,52 +338,68 @@ start_vm()
 
     kernelargs+=("${ktest_kernel_append[@]}")
 
-    local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
-    local accel=kvm
-    local cputype=host
-    [[ "${CROSS_COMPILE:-0}" == "1" ]] && accel=tcg && cputype=max
+    local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic);
+    local accel=kvm;
+    local cputype=host;
+    if [[ "${CROSS_COMPILE:-0}" == "1" ]]; then
+	accel=tcg;
+	cputype=max;
+        premake_cross_bcachefs
+        local err=$?
+        [ $err != 0 ] && echo "Error precompiling $err. compiling native in qemu if needed";
+    fi
+    local pciBus="";
     case $ktest_arch in
 	x86|x86_64)
 	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
+	    qemu_network_driver="virtio-net-pci"
 	    ;;
 	aarch64|arm)
 	    qemu_cmd+=(-cpu $cputype -machine type=virt,gic-version=max,accel=$accel)
+	    qemu_network_driver="virtio-net-pci"
 	    ;;
 	ppc64)
 	    qemu_cmd+=(-machine ppce500 -cpu e6500 -accel tcg)
+	    qemu_network_driver="virtio-net-pci"
 	    ;;
 	s390x)
 	    qemu_cmd+=(-cpu max -machine s390-ccw-virtio -accel tcg)
+	    qemu_network_driver="virtio"
 	    ;;
 	sparc64)
 	    qemu_cmd+=(-machine sun4u -accel tcg)
 	    ktest_cpus=1; #sparc64 currently supports only 1 cpu
+            pciBus=",bus=pciB"
+	    qemu_network_driver="virtio-net-pci"
 	    ;;
 	riscv64)
 	    qemu_cmd+=(-machine virt -cpu rv64 -accel tcg)
+	    qemu_network_driver="virtio-net-pci"
 	    ;;
     esac
 
     local maxmem=$(awk '/MemTotal/ {printf "%dG\n", $2/1024/1024}' /proc/meminfo 2>/dev/null) || maxmem="1T"
     local memconfig="$ktest_mem,slots=8,maxmem=$maxmem"
 
-    [ $BITS == 32 ] &&  memconfig="3G" && ktest_cpus=4 #do not be fancy on 32-bit hardware.  if it works, it's fine
+    [ $BITS == 32 ] &&  memconfig="3G" && ktest_cpus=$((min($ktest_cpus,4))) #do not be fancy on 32-bit hardware.  if it works, it's fine
 
     qemu_cmd+=(								\
 	-m		"$memconfig"					\
 	-smp		"$ktest_cpus"					\
 	-kernel		"$ktest_kernel_binary/vmlinuz"			\
 	-append		"$(join_by " " ${kernelargs[@]})"		\
-	-device		virtio-serial					\
+	-device		pci-bridge,chassis_nr=2,addr=2,id=vfiob$pciBus	\
+	-device		virtio-serial-pci,bus=vfiob,addr=1			\
 	-chardev	stdio,id=console				\
 	-device		virtconsole,chardev=console			\
+	-device		virtio-rng-pci,bus=vfiob,addr=3			\
 	-serial		"unix:$ktest_out/vm/kgdb,server,nowait"		\
 	-monitor	"unix:$ktest_out/vm/mon,server,nowait"		\
 	-gdb		"unix:$ktest_out/vm/gdb,server,nowait"		\
-	-device		virtio-rng-pci					\
-	-virtfs		local,path=/,mount_tag=host,security_model=none,multidevs=remap	\
+	-fsdev		local,path=/,security_model=none,id=host_dev,multidevs=remap \
+	-device		virtio-9p-pci,bus=vfiob,addr=4,fsdev=host_dev,mount_tag=host \
     )
-
+#	-virtfs		local,path=/,mount_tag=host,security_model=none,multidevs=remap	\
 
 
     if [[ -f $ktest_kernel_binary/initramfs ]]; then
@@ -362,9 +410,8 @@ start_vm()
 	user)
 	    ktest_ssh_port=$(get_unused_port)
 	    echo $ktest_ssh_port > "$ktest_out/vm/ssh_port"
-
 	    qemu_cmd+=( \
-		-nic    user,model=virtio,hostfwd=tcp:127.0.0.1:$ktest_ssh_port-:22	\
+		-nic    user,model=${qemu_network_driver},hostfwd=tcp:127.0.0.1:$ktest_ssh_port-:22	\
 	    )
 	    ;;
 	vde)
@@ -393,7 +440,7 @@ start_vm()
 	virtio-blk)
 	    ;;
 	*)
-	    qemu_cmd+=(-device $ktest_storage_bus,id=hba)
+	    qemu_cmd+=(-device $ktest_storage_bus$pciBus,id=hba)
 	    ;;
     esac
 
@@ -407,7 +454,7 @@ start_vm()
 		qemu_cmd+=(-device ide-hd,bus=hba.$disknr,drive=disk$disknr)
 		;;
 	    virtio-blk)
-		qemu_cmd+=(-device virtio-blk-pci,drive=disk$disknr)
+		qemu_cmd+=(-device virtio-blk-pci$pciBus,drive=disk$disknr)
 		;;
 	    *)
 		qemu_cmd+=(-device scsi-hd,bus=hba.0,drive=disk$disknr)
diff --git a/lib/testrunner b/lib/testrunner
index b3ca3fb..40fa46b 100755
--- a/lib/testrunner
+++ b/lib/testrunner
@@ -97,9 +97,10 @@ for i in "${ktest_make_install[@]}"; do
 	run_quiet "configure $(basename $i)" ./configure
     fi
     #bcachefs tools sometimes seems to use compiled files from previous runs, even if other architecture, so clean out:
-    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean & rm -rf "rust-src/targets/*"
+    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f libbcachefs.a | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean & rm -rf "rust-src/targets/*"
     run_quiet "building $(basename $i)" make -j $ktest_cpus
     run_quiet "installing $(basename $i)" make -j $ktest_cpus install
+    [ "bcachefs-tools" == "$(basename $i)" ] && echo $ktest_arch > .precompiled
     popd > /dev/null
 done
 
diff --git a/tests/prelude.sh b/tests/prelude.sh
index fd7eb5c..a88aa03 100644
--- a/tests/prelude.sh
+++ b/tests/prelude.sh
@@ -14,9 +14,9 @@ if [[ ! -v ktest_verbose ]]; then
     ktest_kernel_make_append=()
 
     # virtio-scsi-pci semes to be buggy: reading the superblock on the root
-    # filesystem randomly returns zeroes
-    #ktest_storage_bus=virtio-scsi-pci
-    ktest_storage_bus=virtio-blk
+    # filesystem randomly returns zeroes.  nonetherless, it's the most supported architecture (for now)
+    ktest_storage_bus=virtio-scsi-pci
+    #ktest_storage_bus=virtio-blk
     ktest_images=()
 
     ktest_scratch_dev=()
-- 
2.42.0

