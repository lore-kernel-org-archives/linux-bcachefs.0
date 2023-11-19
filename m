Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD58133
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:11 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b0008-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id BPmkbrH6oCWmaauo; Sun, 19 Nov 2023 17:02:08 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v5 07/10] fix a number of issues with cross-architecture testing
Date: Sun, 19 Nov 2023 16:48:14 +0100
X-ASG-Orig-Subj: [PATCH v5 07/10] fix a number of issues with cross-architecture testing
Message-ID: <20231119160155.34496-8-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Start-Time: 1700409728
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 13578
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

This commit fixes a _LOT_ of issues with the previous commits,
but at least there's one supported big endian architecture now,
which is capable of booting and running ktests: s390x

For unsupported architectures, a number of root_create features:
- enabled snapshot lookups for debian archives,
  in case of missing dependencies, it may still be in there
- enabled possibility to build the package from source,
  this is painful
- enabled the possibility during root_create to intervene,
  this is only available on unsupported architectures.

So far, it seems the qemu E6500 emulator for powerPC isn't stable,
and rustup doesn't know about sparc / sparc64,
so both are currently broken.

Re-organised the cross.conf file as the first one was a bit messy.

Signed-Off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel                    | 19 +++-----
 cross.conf                           | 17 ++++++-
 lib/common.sh                        | 11 +++++
 lib/libktest.sh                      | 10 ++--
 root_image                           | 73 +++++++++++++++++++++++++---
 tests/bcachefs/bcachefs-test-libs.sh |  4 ++
 tests/kconfig.sh                     | 28 +++++++++--
 7 files changed, 137 insertions(+), 25 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index 9970e31..a14efc8 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -205,14 +205,7 @@ build_kernel()
 	mv "$kconfig".bak "$kconfig"
     fi
 
-    case $KERNEL_ARCH in
-	mips)
-	    do_make $MAKEARGS -k vmlinuz
-	    ;;
-	*)
-	    do_make $MAKEARGS -k
-	    ;;
-    esac
+    do_make $MAKEARGS -k
 
     local BOOT=$ktest_kernel_build/arch/$KERNEL_ARCH/boot
 
@@ -226,12 +219,16 @@ build_kernel()
 	aarch64)
 	    install -m0644 "$BOOT/Image"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
-	mips)
-	    install -m0644 "$BOOT/vmlinux.strip"	"$ktest_kernel_binary/vmlinuz"
+	ppc64)
+	    install -m0644 "$BOOT/zImage"	"$ktest_kernel_binary/vmlinuz"
 	    ;;
-	default)
+	*)
 	    if [ -f "$BOOT/Image" ]; then
 		 install -m0644 "$BOOT/Image"	"$ktest_kernel_binary/vmlinuz"
+	    elif [ -f "$BOOT/zImage" ]; then
+		 install -m0644 "$BOOT/zImage"	"$ktest_kernel_binary/vmlinuz"
+	    elif [ -f "$BOOT/bzImage" ]; then
+		 install -m0644 "$BOOT/bzImage"	"$ktest_kernel_binary/vmlinuz"
 	    else
 		echo "Don't know how to install kernel"
 	    	exit 1
diff --git a/cross.conf b/cross.conf
index a78bffd..952d434 100644
--- a/cross.conf
+++ b/cross.conf
@@ -2,10 +2,23 @@
 # whenever these need to be changed (some distributions prefer ARCHITECTURE-VENDOR-OS-LIBC), 
 # change the triplet here
 
+#32 bit architectures
 ARCH_TRIPLE_X86=x86-linux-gnu
+ARCH_TRIPLE_ARMV7=arm-linux-gnueabihf
+
+#64 bit architectures
 ARCH_TRIPLE_X86_64=x86_64-linux-gnu
 ARCH_TRIPLE_ARM64=aarch64-linux-gnu
-ARCH_TRIPLE_ARMV7=arm-linux-gnueabihf
-ARCH_TRIPLE_PPC64=powerpc64-linux-gnu
+ARCH_TRIPLE_S390X=s390x-linux-gnu
+
+#currently unsupported (but maintained) debian architectures
+ARCH_TRIPLE_PPC64=powerpc-linux-gnu
 ARCH_TRIPLE_SPARC64=sparc64-linux-gnu
 ARCH_TRIPLE_RISCV64=riscv64-linux-gnu
+
+#here you can specify up snapshots which are used to fix sid dependencies:
+#debian SID is updated frequently, having a lot of broken packages due to dependencies
+#view https://snapshot.debian.org/archive/debian-ports/ for a list
+#as always: the older, the more dangerous ...
+
+SID_SNAPSHOTS=("20220501T101242Z")
diff --git a/lib/common.sh b/lib/common.sh
index 8758683..6a9a912 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -131,6 +131,17 @@ parse_arch()
 	    QEMU_PACKAGE=qemu-system-arm
 	    QEMU_BIN=qemu-system-arm
 	    ;;
+	s390x)
+	    DEBIAN_ARCH=s390x
+	    ARCH_TRIPLE=${ARCH_TRIPLE_S390X}
+	    RUST_TRIPLE=s390x-unknown-linux-gnu
+
+	    KERNEL_ARCH=s390
+	    BITS=64
+
+	    QEMU_PACKAGE=qemu-system-s390x
+	    QEMU_BIN=qemu-system-s390x
+	    ;;
 	riscv64)
 	    DEBIAN_ARCH=riscv64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_RISCV64}
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 98d5742..a0afe9a 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -318,13 +318,17 @@ start_vm()
 	    qemu_cmd+=(-cpu $cputype -machine type=virt,gic-version=max,accel=$accel)
 	    ;;
 	ppc64)
-	    qemu_cmd+=(-cpu power9)
+	    qemu_cmd+=(-machine ppce500 -cpu e6500 -accel tcg)
+	    ;;
+	s390x)
+	    qemu_cmd+=(-cpu max -machine s390-ccw-virtio -accel tcg)
 	    ;;
 	sparc64)
-	    qemu_cmd+=(-cpu default)
+	    qemu_cmd+=(-machine sun4u -accel tcg)
+	    ktest_cpus=1; #sparc64 currently supports only 1 cpu
 	    ;;
 	riscv64)
-	    qemu_cmd+=(-cpu any)
+	    qemu_cmd+=(-machine virt -cpu rv64 -accel tcg)
 	    ;;
     esac
 
diff --git a/root_image b/root_image
index bc257d2..4a0217c 100755
--- a/root_image
+++ b/root_image
@@ -34,11 +34,68 @@ usage()
     echo
     echo "options:"
     echo "  -h			Display this help and exit"
-    echo "  -a <arch>		Architecture for vm image (x86_64,armhf,i386,aarch64,sparc64,ppc64,riscv64)"
+    echo "  -a <arch>		Architecture for vm (x86_64,armhf,i386,aarch64,sparc64,s390x,ppc64,riscv64)"
     echo "  -m <mirror>		Debian mirror"
     echo '  -i <image>		Image to create/update, defaults to /var/lib/ktest/root.$arch'
 }
 
+intervene()
+{
+	local yn="N";
+	echo "Installing $2 failed: both binary install and $1";
+	echo "You can start a shell to check whether any dependency issues can be fixed"
+	echo "if you do, and exit the shell, it is assumed to be fixed and installing will continue"
+	read -p "Do you wish to start a shell to investigate? (y/N)" yn
+	case $yn in
+		[Yy]* )
+			_chroot "$MNT" /tmpbuild/executer.sh /bin/bash;
+		;;
+		* ) return 1;;
+	esac
+}
+
+install_fix_deps()
+{
+	trap 'echo "Could not install packages! please revert to the included torrent file to download a working root image"; umount $MNT/tmpbuild; umount_image; rm "$ktest_image"' EXIT
+	#get necessary certificates / pgp keyrings to work with unofficial and outdated snapshots
+	_chroot "$MNT" apt-get -qq install debian-ports-archive-keyring ca-certificates
+	#disable unwanted checks - we know the snapshots are not valid
+	echo "Acquire::Check-Valid-Until false;" > $MNT/etc/apt/apt.conf.d/10-nocheckvalid
+	#create a sources.list with more options to work around missing packages
+	echo 'deb [trusted=yes] http://deb.debian.org/debian-ports unstable main non-free' > $MNT/etc/apt/sources.list
+	echo 'deb-src [trusted=yes] http://deb.debian.org/debian-ports unstable main non-free' >> $MNT/etc/apt/sources.list
+	echo 'deb [trusted=yes] http://deb.debian.org/debian-ports unreleased main non-free' >> $MNT/etc/apt/sources.list
+	echo 'deb-src [trusted=yes] http://deb.debian.org/debian-ports unreleased main non-free' >> $MNT/etc/apt/sources.list
+	for i in "${SID_SNAPSHOTS[@]}"; do
+	echo "deb [trusted=yes] https://snapshot.debian.org/archive/debian-ports/$i sid main" >> $MNT/etc/apt/sources.list
+	echo "deb-src [trusted=yes] https://snapshot.debian.org/archive/debian-ports/$i sid main" >> $MNT/etc/apt/sources.list
+	done
+	echo "deb-src http://deb.debian.org/debian unstable main contrib non-free" >> $MNT/etc/apt/sources.list
+	touch $MNT/etc/passwd
+	touch $MNT/etc/shadow
+	_chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
+	_chroot "$MNT" apt-get -qq --allow-unauthenticated upgrade
+	_chroot "$MNT" apt-get -qq install -f
+	_chroot "$MNT" apt-get -qq install build-essential
+	#if we can install them all at once, do so, otherwise, try one by one
+	_chroot "$MNT" apt-get -qq install -m --allow-unauthenticated --no-install-recommends "${PACKAGES[@]}" || for i in "${PACKAGES[@]}"; do
+		if [[ ! $(_chroot "$MNT" apt-cache show $i | grep Version) == "" ]]; then
+		_chroot "$MNT" apt-get -qq install --allow-unauthenticated --no-install-recommends $i && continue;
+		fi
+		#installing binary failed.  Try to install from source.  Do it in a tmpfs folder so the image doesn't get overwhelmed:
+		mkdir ${MNT}/tmpbuild;
+		mount -t tmpfs none ${MNT}/tmpbuild;
+		echo '#!/bin/bash' > "$MNT"/tmpbuild/executer.sh
+		echo 'cd /tmpbuild/; $@' >> "$MNT"/tmpbuild/executer.sh
+		chmod ago+x "$MNT"/tmpbuild/executer.sh
+		_chroot "$MNT" /tmpbuild/executer.sh apt-get -qq build-dep --allow-unauthenticated --no-install-recommends $i || intervene install-deps $i;
+		_chroot "$MNT" /tmpbuild/executer.sh apt-get -qq -b source --allow-unauthenticated $i || intervene build $i;
+		[ -f "${MNT}/tmpbuild/${i}*.deb" ] && _chroot "$MNT" apt-get -qq install /tmpbuild/${i}*.deb;
+		umount ${MNT}/tmpbuild;
+		rmdir ${MNT}/tmpbuild;
+	done
+}
+
 if [[ $# = 0 ]]; then
     usage
     exit 1
@@ -130,7 +187,7 @@ PACKAGES+=("linux-headers-generic")
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
 
 EXCLUDE=(dmidecode nano rsyslog logrotate cron		\
-    iptables nfacct					\
+    iptables nfacct vim-tiny				\
     debconf-i18n info gnupg libpam-systemd)
 
 SYSTEMD_MASK=(dev-hvc0.device				\
@@ -233,11 +290,14 @@ update_packages()
     mkdir -p "$MNT"/run/user/0
     cp /etc/resolv.conf "$MNT/etc/resolv.conf"
     _chroot "$MNT" mount -t proc none /proc
-    [[ $MIRROR == *"debian-ports"* ]] && _chroot "$MNT" apt-get -qq install debian-ports-archive-keyring
+    if [[ $MIRROR == *"debian-ports"* ]]; then
+	install_fix_deps
+    else
     _chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
     _chroot "$MNT" apt-get -qq --allow-unauthenticated upgrade
     _chroot "$MNT" apt-get -qq install -f
     _chroot "$MNT" apt-get -qq install -m --allow-unauthenticated --no-install-recommends "${PACKAGES[@]}"
+    fi
     rm -f "$MNT/var/cache/apt/archives/*.deb"
 
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
@@ -293,11 +353,11 @@ cmd_create()
 	echo "$ktest_image already exists"
 	exit 1
     fi
-
+    set -o xtrace
     (cd "$ktest_dir"; git submodule update --init debootstrap)
 
     MNT=$(mktemp --tmpdir -d $(basename "$0")-XXXXXXXXXX)
-    trap 'umount_image; rm "$ktest_image"' EXIT
+    trap '/bin/bash; umount_image; rm "$ktest_image"' EXIT
 
     fallocate -l "$IMAGE_SIZE" "$ktest_image"
     mkfs.ext4 -F "$ktest_image"
@@ -336,7 +396,8 @@ cmd_create()
 	$debian_release "$MNT" "$MIRROR"
 
     statichelper=$(which qemu-${ktest_arch}) || statichelper=$(which qemu-${ktest_arch}-static)
-    [ ${CROSS_COMPILE:-0} == 1 ] && cp $statichelper ${MNT}$statichelper
+    [[ ${CROSS_COMPILE+x} ]] && cp ${statichelper} ${MNT}${statichelper}
+
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
     update_packages
diff --git a/tests/bcachefs/bcachefs-test-libs.sh b/tests/bcachefs/bcachefs-test-libs.sh
index 05996b1..90c36b6 100644
--- a/tests/bcachefs/bcachefs-test-libs.sh
+++ b/tests/bcachefs/bcachefs-test-libs.sh
@@ -28,8 +28,12 @@ else
     require-kernel-config BCACHEFS_NO_LATENCY_ACCT=y
 fi
 
+if [[ ! $ktest_arch == ppc64 ]]; then
+
 require-kernel-config TRANSPARENT_HUGEPAGE
 
+fi
+
 if [[ $ktest_arch = x86_64 ]]; then
     require-kernel-config CRYPTO_CRC32C_INTEL
     require-kernel-config CRYPTO_POLY1305_X86_64
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index 9a30094..2bfc47c 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -69,8 +69,14 @@ case $ktest_arch in
 
 	require-kernel-append console=hvc0
 	;;
+
     ppc64)
 	require-kernel-config PPC64
+	require-kernel-config PPC_BOOK3E_64
+	require-kernel-config PPC_QEMU_E500
+	require-kernel-config E6500_CPU
+	require-kernel-config SMP
+	require-kernel-config KVM_GUEST
 
 	have_virtio=1
 
@@ -79,7 +85,6 @@ case $ktest_arch in
     sparc64)
 	require-kernel-config 64BIT
 	require-kernel-config SMP
-	require-kernel-config VIRTIO_MENU
 	require-kernel-config PCI
 
 	have_virtio=1
@@ -93,6 +98,17 @@ case $ktest_arch in
 
 	have_virtio=1
 
+	require-kernel-append console=hvc0
+	;;
+    s390x)
+	require-kernel-config S390_GUEST
+	require-kernel-config MARCH_Z13
+	require-kernel-config CMM
+	require-kernel-config PCI
+	require-kernel-config DCSSBLK
+
+	have_virtio=1
+
 	require-kernel-append console=hvc0
 	;;
     *)
@@ -183,13 +199,15 @@ require-kernel-config PCI
 require-kernel-config HW_RANDOM
 
 # Clock:
+if [[ ! $ktest_arch == *"s390"* ]]; then
 require-kernel-config RTC_CLASS
 require-kernel-config RTC_HCTOSYS
-
+fi
 # Console:
+if [[ ! $ktest_arch == *"s390"* ]]; then
 require-kernel-config SERIAL_8250	# XXX can probably drop
 require-kernel-config SERIAL_8250_CONSOLE
-
+fi
 # Block devices:
 require-kernel-config SCSI
 require-kernel-config SCSI_LOWLEVEL	# what's this for?
@@ -230,8 +248,10 @@ require-kernel-config 9P_FS
 #fi
 
 # KGDB:
+if [[ ! $ktest_arch == *"s390"* ]]; then
 require-kernel-config KGDB
 require-kernel-config KGDB_SERIAL_CONSOLE
+fi
 require-kernel-config VMAP_STACK=n
 require-kernel-config RANDOMIZE_BASE=n
 require-kernel-config RANDOMIZE_MEMORY=n
@@ -254,7 +274,9 @@ require-kernel-config FUNCTION_TRACER
 #require-kernel-config ENABLE_DEFAULT_TRACERS
 
 require-kernel-config PANIC_ON_OOPS
+if [[ ! $ktest_arch == *"s390"* ]]; then
 require-kernel-config SOFTLOCKUP_DETECTOR
+fi
 require-kernel-config DETECT_HUNG_TASK
 #require-kernel-config DEFAULT_HUNG_TASK_TIMEOUT=30
 require-kernel-config WQ_WATCHDOG
-- 
2.42.1

