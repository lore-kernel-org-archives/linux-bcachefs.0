Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729C1138
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:12 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b000a-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id lRwrQ5F3gdO0we0P; Sun, 19 Nov 2023 17:02:09 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v5 09/10] fixup!: - fix malfunctioning variables - provide sid fallback for missing architectures - make the extended installer default for sid
Date: Sun, 19 Nov 2023 16:48:16 +0100
X-ASG-Orig-Subj: [PATCH v5 09/10] fixup!: - fix malfunctioning variables - provide sid fallback for missing architectures - make the extended installer default for sid
Message-ID: <20231119160155.34496-10-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Start-Time: 1700409729
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 12162
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 build-test-kernel |  2 +-
 lib/common.sh     |  7 +++--
 lib/libktest.sh   | 10 +++----
 root_image        | 70 ++++++++++++++++++++++++++++-------------------
 tests/kconfig.sh  |  2 --
 5 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/build-test-kernel b/build-test-kernel
index a14efc8..91aeaba 100755
--- a/build-test-kernel
+++ b/build-test-kernel
@@ -107,7 +107,7 @@ ktest_kernel_source=$(readlink -e "$ktest_kernel_source")
 ktest_kernel_build="$ktest_out/kernel_build.$ktest_arch"
 mkdir -p "$ktest_kernel_build"
 
-if [[ ${CROSS_COMPILE+x} ]]; then
+if [[ -n ${CROSS_COMPILE} ]]; then
     checkdep "$ARCH_TRIPLE-gcc" "gcc-$ARCH_TRIPLE"
 fi
 
diff --git a/lib/common.sh b/lib/common.sh
index 6a9a912..0015c6f 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -187,9 +187,11 @@ parse_arch()
 
     if [[ $ktest_arch != $(uname -m) ]]; then
 	CROSS_COMPILE=1
+    else
+	CROSS_COMPILE=
     fi
-    #special case: x86_64 is able to run i386 code.  this isn't always the case for armv8 -> armv7 (cortex A35)
-    [[ $DEBIAN_ARCH == "i386" && "$(uname -m)" == "x86_64" ]] && unset CROSS_COMPILE
+    #special case: x86_64 is able to run i386 code. we can use KVM.
+    [[ $DEBIAN_ARCH == "i386" && "$(uname -m)" == "x86_64" ]] && CROSS_COMPILE=
     export DEBIAN_ARCH
     export MIRROR
     export ARCH_TRIPLE
@@ -199,6 +201,7 @@ parse_arch()
     export ktest_arch
     export BITS
     export RUST_TRIPLE
+    export CROSS_COMPILE
 }
 
 find_command() {
diff --git a/lib/libktest.sh b/lib/libktest.sh
index a0afe9a..9cb9aea 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -27,6 +27,7 @@ ktest_ssh_port=0
 ktest_networking=user
 ktest_dio=off
 ktest_nice=0
+ktest_arch=
 
 checkdep socat
 checkdep brotli
@@ -85,7 +86,7 @@ parse_ktest_arg()
 
 parse_args_post()
 {
-    [ -z ${ktest_arch:+x} ] && ktest_arch=$(uname -m)
+    [[ -z ${ktest_arch} ]] && ktest_arch=$(uname -m)
     parse_arch "$ktest_arch"
 
     ktest_out=$(readlink -f "$ktest_out")
@@ -286,7 +287,6 @@ start_vm()
     ln -s "$ktest_tmp" "$ktest_out/vm"
 
     local kernelargs=()
-
     case $ktest_storage_bus in
 	virtio-blk)
 	    ktest_root_dev="/dev/vda"
@@ -296,7 +296,7 @@ start_vm()
 	    ;;
     esac
 
-    kernelargs+=(root=$ktest_root_dev rw log_buf_len=8M)
+    kernelargs+=(root=$ktest_root_dev rw log_buf_len=8M rootwait)
     kernelargs+=(mitigations=off)
     kernelargs+=("ktest.dir=$ktest_dir")
     kernelargs+=(ktest.env=$(readlink -f "$ktest_out/vm/env"))
@@ -309,7 +309,7 @@ start_vm()
     local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
     local accel=kvm
     local cputype=host
-    [[ ${CROSS_COMPILE+x} ]] && accel=tcg && cputype=max
+    [[ -n ${CROSS_COMPILE} ]] && accel=tcg && cputype=max
     case $ktest_arch in
 	x86|x86_64)
 	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
@@ -339,7 +339,7 @@ start_vm()
     local memconfig="$ktest_mem,slots=8,maxmem=$maxmem"
 
     #do not be fancy on 32-bit hardware.  if it works, it's fine
-    [[ $BITS == 32 ]] &&  memconfig="3G" && ktest_cpus=$((min($ktest_cpus,4)))
+    [[ $BITS == 32 ]] &&  memconfig="3G" && ktest_cpus=$(($ktest_cpus > 4 ? 4 : $ktest_cpus))
 
     qemu_cmd+=(								\
 	-m		"$memconfig"					\
diff --git a/root_image b/root_image
index 6d20c43..9043551 100755
--- a/root_image
+++ b/root_image
@@ -23,7 +23,8 @@ checkdep mkfs.ext4 e2fsprogs
 checkdep curl 
 
 IMAGE_SIZE="10G"
-MIRROR=https://deb.debian.org/debian/
+#http is preferred over https here: on emulated CPUs, the encryption simply isn't worth it
+MIRROR=http://deb.debian.org/debian/
 
 usage()
 {
@@ -44,33 +45,43 @@ intervene()
 	local yn="N";
 	echo "Installing $2 failed: both binary install and $1";
 	echo "You can start a shell to check whether any dependency issues can be fixed"
-	echo "if you do, and exit the shell, it is assumed to be fixed and installing will continue"
-	read -p "Do you wish to start a shell to investigate? (y/N)" yn
+	echo "if you do (y), and exit the shell, it is assumed to be fixed and installing will continue"
+	echo "if you don't, we give up."
+        echo "you can also choose to skip package installation (s), though this is not recommended"
+	read -p "Do you wish to start a shell to investigate? (y/s/N)" yn
 	case $yn in
 		[Yy]* )
 			_chroot "$MNT" /tmpbuild/executer.sh /bin/bash;
 		;;
+		[sS]* )
+			return 0;
+		;;
 		* ) return 1;;
 	esac
 }
 
 install_fix_deps()
 {
-	trap 'echo "Could not install packages! please revert to the included torrent file to download a working root image"; umount $MNT/tmpbuild; umount_image; rm "$ktest_image"' EXIT
+	trap 'echo "Could not install packages! consider switching to a supported architecture"; umount_image; rm "$ktest_image"' EXIT
+	#debian has a separate dist for "experimental" / broken packages, in debian-ports it is called "unreleased".
+	experimental_dist="experimental" && [[ ${MIRROR} == *"debian-ports"* ]] && experimental_dist=unreleased;
+        SNAPSHOT_MIRROR="https://snapshot.debian.org/archive/debian" && [[ ${MIRROR} == *"debian-ports"* ]] && SNAPSHOT_MIRROR+="-ports";
 	#get necessary certificates / pgp keyrings to work with unofficial and outdated snapshots
 	_chroot "$MNT" apt-get -qq install debian-ports-archive-keyring ca-certificates
 	#disable unwanted checks - we know the snapshots are not valid
 	echo "Acquire::Check-Valid-Until false;" > $MNT/etc/apt/apt.conf.d/10-nocheckvalid
 	#create a sources.list with more options to work around missing packages
-	echo 'deb [trusted=yes] http://deb.debian.org/debian-ports unstable main non-free' > $MNT/etc/apt/sources.list
-	echo 'deb-src [trusted=yes] http://deb.debian.org/debian-ports unstable main non-free' >> $MNT/etc/apt/sources.list
-	echo 'deb [trusted=yes] http://deb.debian.org/debian-ports unreleased main non-free' >> $MNT/etc/apt/sources.list
-	echo 'deb-src [trusted=yes] http://deb.debian.org/debian-ports unreleased main non-free' >> $MNT/etc/apt/sources.list
+	echo "deb [trusted=yes] $MIRROR sid main contrib" > $MNT/etc/apt/sources.list
+	echo "deb-src [trusted=yes] $MIRROR sid main contrib" >> $MNT/etc/apt/sources.list
+	echo "deb [trusted=yes] $MIRROR ${experimental_dist} main contrib" >> $MNT/etc/apt/sources.list
+	echo "deb-src [trusted=yes] $MIRROR ${experimental_dist} main contrib" >> $MNT/etc/apt/sources.list
+        #add snapshots specified in cross.conf
 	for i in "${SID_SNAPSHOTS[@]}"; do
-	echo "deb [trusted=yes] https://snapshot.debian.org/archive/debian-ports/$i sid main" >> $MNT/etc/apt/sources.list
-	echo "deb-src [trusted=yes] https://snapshot.debian.org/archive/debian-ports/$i sid main" >> $MNT/etc/apt/sources.list
+	echo "deb [trusted=yes] ${SNAPSHOT_MIRROR}/$i sid main" >> $MNT/etc/apt/sources.list
+	echo "deb-src [trusted=yes] ${SNAPSHOT_MIRROR}/$i sid main" >> $MNT/etc/apt/sources.list
 	done
-	echo "deb-src http://deb.debian.org/debian unstable main contrib non-free" >> $MNT/etc/apt/sources.list
+        #when working with debian-ports, add the general sources as a last hope ... there *may* be a package compiling for this archwe need
+	[[ ${MIRROR} == *"debian-ports"* ]] && echo "deb-src [trusted=yes] http://deb.debian.org/debian sid main contrib" >> $MNT/etc/apt/sources.list
 	touch $MNT/etc/passwd
 	touch $MNT/etc/shadow
 	_chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
@@ -83,7 +94,7 @@ install_fix_deps()
 		_chroot "$MNT" apt-get -qq install --allow-unauthenticated --no-install-recommends $i && continue;
 		fi
 		#installing binary failed.  Try to install from source.  Do it in a tmpfs folder so the image doesn't get overwhelmed:
-		mkdir ${MNT}/tmpbuild;
+		[[ ! -d ${MNT}/tmpbuild ]] && mkdir ${MNT}/tmpbuild;
 		mount -t tmpfs none ${MNT}/tmpbuild;
 		echo '#!/bin/bash' > "$MNT"/tmpbuild/executer.sh
 		echo 'cd /tmpbuild/; $@' >> "$MNT"/tmpbuild/executer.sh
@@ -184,7 +195,7 @@ PACKAGES+=("linux-headers-generic")
 # DKMS needs to cross-compile the module,
 # against a different kernel on a different CPUarchitecture.
 # this has to cause errors
-[[ ${CROSS_COMPILE+x} ]] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
+[[ -z ${CROSS_COMPILE} ]] && PACKAGES+=(dkms zfsutils-linux zfs-dkms)
 
 # suspend testing:
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
@@ -289,16 +300,17 @@ ZZ
 
 update_packages()
 {
-    NO_RUSTUP=0
+    NO_RUSTUP=
     # systemd... !?
     mkdir -p "$MNT"/run/user/0
     cp /etc/resolv.conf "$MNT/etc/resolv.conf"
-
-    [[ $(curl -qq -I "https://static.rust-lang.org/rustup/${RUST_TRIPLE}/rustup-init" 2>/dev/null | grep "HTTP/2 200") == "" ]] && NO_RUSTUP=1
-    [ $NO_RUSTUP ] && PACKAGES+=(rustc rustc-dbgsym rustfmt rustfmt-dbgsym) #don't do rustup on unsupported architectures, just try from debian repositories
+    #don't do rustup on unsupported architectures, just try to install from debian repositories
+    [[ -z $(curl -qq -I "https://static.rust-lang.org/rustup/dist/${RUST_TRIPLE}/rustup-init" 2>/dev/null | grep "HTTP/2 200") ]] && NO_RUSTUP=1
+    [[ -n $NO_RUSTUP ]] && PACKAGES+=(rustc rustc-dbgsym rustfmt rustfmt-dbgsym)
 
     _chroot "$MNT" mount -t proc none /proc
-    if [[ $MIRROR == *"debian-ports"* ]]; then
+    _chroot "$MNT" mount -t devpts none /dev/pts
+    if [[ $MIRROR == *"debian-ports"* || $1 == "sid" ]]; then
 	install_fix_deps
     else
 	_chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
@@ -308,12 +320,12 @@ update_packages()
     fi
     rm -f "$MNT/var/cache/apt/archives/*.deb"
 
-    if [ ! $NO_RUSTUP ]; then
-    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
-    chmod 755 "$MNT"/tmp/rustup.sh
+    if [[ -z $NO_RUSTUP ]]; then
+	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
+	chmod 755 "$MNT"/tmp/rustup.sh
 
-    _chroot "$MNT" /tmp/rustup.sh --default-host $RUST_TRIPLE -y
-    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
+	_chroot "$MNT" /tmp/rustup.sh --default-host ${RUST_TRIPLE} -y
+	echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
     fi;
 }
 
@@ -349,7 +361,7 @@ cmd_update()
     cp "$ktest_image" "$ktest_image".new
     mount "$ktest_image".new "$MNT"
 
-    update_packages
+    update_packages none
     update_files
 
     umount_image
@@ -391,7 +403,7 @@ cmd_create()
     #fallback: if the architecture can't be found, try official sid:
     if [[ -z $(curl -qq -I "${MIRROR}/dists/${debian_release}/main/binary-${DEBIAN_ARCH}/Release" 2>/dev/null | grep "HTTP/2 200") ]]; then
 	echo "WARNING: $DEBIAN_ARCH $debian_release could not be found at ${MIRROR} (where it should be).  Falling back to standard sid"
-        MIRROR="https://deb.debian.org/debian/"
+        MIRROR="http://deb.debian.org/debian/"
 	debian_release=sid
     fi
 
@@ -404,12 +416,14 @@ cmd_create()
 	--components='main,contrib,non-free' \
 	$debian_release "$MNT" "$MIRROR"
 
-    statichelper=$(which qemu-${ktest_arch}) || statichelper=$(which qemu-${ktest_arch}-static)
-    [[ ${CROSS_COMPILE+x} ]] && cp ${statichelper} ${MNT}${statichelper}
+    if [[ -n ${CROSS_COMPILE} ]]; then
+       statichelper=$(which qemu-${ktest_arch}) || statichelper=$(which qemu-${ktest_arch}-static)
+       cp ${statichelper} ${MNT}${statichelper}
+    fi
 
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
-    update_packages
+    update_packages $debian_release
     update_files
 
     umount_image
diff --git a/tests/kconfig.sh b/tests/kconfig.sh
index 2bfc47c..1088311 100644
--- a/tests/kconfig.sh
+++ b/tests/kconfig.sh
@@ -4,8 +4,6 @@ have_kvmguest=0
 have_virtio=0
 have_suspend=0
 
-[ -z ${ktest_arch:+x} ] && ktest_arch=$(uname -m)
-
 case $ktest_arch in
     x86)
 	require-kernel-config SMP
-- 
2.42.1

