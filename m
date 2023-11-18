Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EBCD60
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:45:26 -0800 (PST)
X-ASG-Debug-ID: 1700336721-24639c7fb84da540005-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b03.edpnet.be with ESMTP id 3t0dGtAIPj9GIs5P; Sat, 18 Nov 2023 20:45:23 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v4 04/10] enable ARMv7 support
Date: Sat, 18 Nov 2023 20:38:43 +0100
X-ASG-Orig-Subj: [PATCH v4 04/10] enable ARMv7 support
Message-ID: <20231118194453.41324-5-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
References: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
Reply-To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1700336723
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 6857
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.75
X-Barracuda-Spam-Status: No, SCORE=0.75 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=BSF_RULE_7580E
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116931
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.75 BSF_RULE_7580E         Custom Rule 7580E

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

Ktest has now been expanded with cross-binary armv7 (hard float).
this should allow some testing on more legacy armv7 hardware,
which may still be present in NAS devices.
However, due to the nature of the ecosystem, a limit is in place:
- 3GB ram for 32 bit systems
- 4 CPUs for 32 bit systems
I think if you need more, you'd better think of going 64-bit.
These constraints allow the ARM emulator to run smoothly.

Signed-off-by:  jpsollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel | 19 +++++++++++--------
 cross.conf        |  2 +-
 lib/common.sh     | 11 +++++++++++
 lib/libktest.sh   | 11 ++++++++---
 tests/kconfig.sh  | 25 ++++++++++++++++++++++---
 5 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index b7dd70c..0d7bdda 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -139,7 +139,7 @@ new_config()
     local config_tool="$ktest_kernel_source/scripts/config"
 
     if [[ ! -f $kconfig ]]; then
-	do_make allnoconfig
+	do_make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-" allnoconfig
 
 	# Really undefine everything:
 	sed -i -e 's/\(CONFIG_.*\)=.*/# \1 is not set/' "$kconfig"
@@ -186,17 +186,17 @@ build_kernel()
 	mv "$kconfig" "$kconfig".bak
     fi
 
+    MAKEARGS+=("LOCALVERSION=-ktest" ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-")
+
     new_config
 
     log_verbose "kernel_config_require: ${ktest_kernel_config_require[@]}"
 
-    MAKEARGS+=("LOCALVERSION=-ktest" ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-")
-
     for opt in "${ktest_kernel_config_require[@]}"; do
 	[[ -n $opt ]] && kernel_opt set "$opt"
     done
 
-    do_make olddefconfig
+    do_make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-" olddefconfig
 
     for opt in "${ktest_kernel_config_require[@]}"; do
 	[[ -n $opt ]] && kernel_opt check "$opt"
@@ -209,10 +209,10 @@ build_kernel()
 
     case $KERNEL_ARCH in
 	mips)
-	    do_make -k vmlinuz
+	    do_make $MAKEARGS -k vmlinuz
 	    ;;
 	*)
-	    do_make -k
+	    do_make $MAKEARGS -k
 	    ;;
     esac
 
@@ -222,6 +222,9 @@ build_kernel()
 	x86*)
 	    install -m0644 "$BOOT/bzImage"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
+	arm)
+	    install -m0644 "$BOOT/zImage"	"$ktest_kernel_binary/vmlinuz"
+	    ;;
 	aarch64)
 	    install -m0644 "$BOOT/Image"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
@@ -281,13 +284,13 @@ cmd_boot()
 cmd_oldconfig()
 {
     new_config
-    do_make oldconfig
+    do_make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-" oldconfig
 }
 
 cmd_config()
 {
     new_config
-    do_make nconfig
+    do_make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-" nconfig
 }
 
 cmd_faddr2line()
diff --git a/cross.conf b/cross.conf
index 2896885..d98219e 100644
--- a/cross.conf
+++ b/cross.conf
@@ -5,4 +5,4 @@
 ARCH_TRIPLE_X86=x86-linux-gnu
 ARCH_TRIPLE_X86_64=x86_64-linux-gnu
 ARCH_TRIPLE_ARM64=aarch64-linux-gnu
-
+ARCH_TRIPLE_ARMV7=arm-linux-gnueabihf
diff --git a/lib/common.sh b/lib/common.sh
index 353bb36..5e24169 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -116,6 +116,17 @@ parse_arch()
 	    QEMU_PACKAGE=qemu-system-arm
 	    QEMU_BIN=qemu-system-aarch64
 	    ;;
+	armhf|armv7|armv7l|arm)
+	    ktest_arch=arm
+	    DEBIAN_ARCH=armhf
+	    ARCH_TRIPLE=${ARCH_TRIPLE_ARMV7}
+
+	    KERNEL_ARCH=arm
+	    BITS=32
+
+	    QEMU_PACKAGE=qemu-system-arm
+	    QEMU_BIN=qemu-system-arm
+	    ;;
 	mips)
 	    DEBIAN_ARCH=mips
 	    ARCH_TRIPLE=mips-linux-gnu
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 0b2704b..3307b76 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -223,7 +223,7 @@ ktest_kgdb()
 
 ktest_mon()
 {
-    exec socat UNIX-CONNECT:"$ktest_out/vm/on" STDIO
+    exec socat UNIX-CONNECT:"$ktest_out/vm/mon" STDIO
     exec nc "$ktest_out/vm/mon"
 }
 
@@ -314,7 +314,7 @@ start_vm()
 	x86|x86_64)
 	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
 	    ;;
-	aarch64)
+	aarch64|arm)
 	    qemu_cmd+=(-cpu $cputype -machine type=virt,gic-version=max,accel=$accel)
 	    ;;
 	mips)
@@ -327,9 +327,12 @@ start_vm()
     esac
 
     local maxmem=$(awk '/MemTotal/ {printf "%dG\n", $2/1024/1024}' /proc/meminfo 2>/dev/null) || maxmem="1T"
+    local memconfig="$ktest_mem,slots=8,maxmem=$maxmem"
+
+    [ $BITS == 32 ] &&  memconfig="3G" && ktest_cpus=4 #do not be fancy on 32-bit hardware.  if it works, it's fine
 
     qemu_cmd+=(								\
-	-m		"$ktest_mem,slots=8,maxmem=$maxmem"		\
+	-m		"$memconfig"					\
 	-smp		"$ktest_cpus"					\
 	-kernel		"$ktest_kernel_binary/vmlinuz"			\
 	-append		"$(join_by " " ${kernelargs[@]})"		\
@@ -343,6 +346,8 @@ start_vm()
 	-virtfs		local,path=/,mount_tag=host,security_model=none,multidevs=remap	\
     )
 
+
+
     if [[ -f $ktest_kernel_binary/initramfs ]]; then
 	qemu_cmd+=(-initrd 	"$ktest_kernel_binary/initramfs")
     fi
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index 73e93db..5f032aa 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -12,6 +12,7 @@ case $ktest_arch in
 	require-kernel-config MCORE2	# optimize for core2
 	require-kernel-config IO_DELAY_0XED
 	require-kernel-config 64BIT=n
+	require-kernel-config COMPAT_32BIT_TIME
 	require-kernel-config ACPI	# way slower without it, do not know why
 	require-kernel-config UNWINDER_FRAME_POINTER
 	require-kernel-config HARDLOCKUP_DETECTOR
@@ -38,13 +39,33 @@ case $ktest_arch in
 	have_virtio=1
 	have_suspend=1
 
+	require-kernel-append console=hvc0
+	;;
+    arm)
+	require-kernel-config ARCH_VIRT
+	require-kernel-config SMP
+	require-kernel-config VFP
+	require-kernel-config NEON
+	require-kernel-config ARM_LPAE
+	require-kernel-config MMU
+	require-kernel-config HAVE_PCI
+	require-kernel-config PCI_HOST_GENERIC
+	require-kernel-config ARM_AMBA
+	require-kernel-config COMPAT_32BIT_TIME
+	require-kernel-config RTC_DRV_PL031
+
+	have_virtio=1
+
 	require-kernel-append console=hvc0
 	;;
     aarch64)
 	require-kernel-config PCI_HOST_GENERIC
 	require-kernel-config RTC_DRV_PL031
+	require-kernel-config COMPAT_32BIT_TIME
+	require-kernel-config IOMMU_SUPPORT
 
 	have_virtio=1
+	have_kvmguest=1
 
 	require-kernel-append console=hvc0
 	;;
@@ -70,7 +91,7 @@ case $ktest_arch in
 	require-kernel-append console=hvc0
 	;;
     *)
-	echo "Kernel architecture not supported by kconfig.sh"
+	echo "Kernel architecture $ktest_arch not supported by kconfig.sh"
 	exit 1
 	;;
 esac
@@ -95,8 +116,6 @@ require-kernel-config BINFMT_SCRIPT
 
 require-kernel-config COMPACTION	# virtfs doesn't do well without it
 
-require-kernel-config PROC_KCORE	# XXX Needed?
-
 require-kernel-config TTY
 require-kernel-config VT
 
-- 
2.42.1

