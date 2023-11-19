Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA40126
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:09 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b0004-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id OL0C4CdmtaGqRnug; Sun, 19 Nov 2023 17:02:07 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	jpsollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v5 03/10] ktest: upgrade to debian trixie channel
Date: Sun, 19 Nov 2023 16:48:10 +0100
X-ASG-Orig-Subj: [PATCH v5 03/10] ktest: upgrade to debian trixie channel
Message-ID: <20231119160155.34496-4-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Start-Time: 1700409727
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 6139
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Due to bcachefs being mainlined,
it's worth considering a more recent update channel,
which may include bcachefs features in the future.

Necessary adjustments have been made for the packages,
but kernel requirements may still need some extra tweaks

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>

ktest: enable debian sid fallback

RISC-V is currently moving from debian-ports to debian,
in order to protect from unreleased architectures etc,
a fallback scenario is needed:
in case preconfigured settings do not work,
apply a default sid fallback

Signed-Off-By: jpsollie <janpieter.sollie@edpnet.be>
---
 lib/common.sh   |  8 +++++---
 lib/libktest.sh |  9 ++++++++-
 root_image      | 35 ++++++++++++++++++++++++++++++-----
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/lib/common.sh b/lib/common.sh
index b94557d..353bb36 100644
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
+    [[ $DEBIAN_ARCH == "i386" && "$(uname -m)" == "x86_64" ]] && unset CROSS_COMPILE
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
index 8ead78b..d5cf4e2 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -309,7 +309,7 @@ start_vm()
     local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
     local accel=kvm
     local cputype=host
-    [[ $(uname -m) == $ktest_arch ]] || accel=tcg && cputype=max
+    [[ ${CROSS_COMPILE+x} ]] && accel=tcg && cputype=max
     case $ktest_arch in
 	x86|x86_64)
 	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
@@ -326,7 +326,14 @@ start_vm()
 	    ;;
     esac
 
+    #we assign 4GB of ram, but for gcc jobs on target, >512MiB / GCC job is recommended
+    (( $ktest_cpus > 8 )) && ktest_mem=8G
+
     local maxmem=$(awk '/MemTotal/ {printf "%dG\n", $2/1024/1024}' /proc/meminfo 2>/dev/null) || maxmem="1T"
+    local memconfig="$ktest_mem,slots=8,maxmem=$maxmem"
+
+    #do not be fancy on 32-bit hardware.  if it works, it's fine
+    [[ $BITS == 32 ]] &&  memconfig="3G" && ktest_cpus=$((min($ktest_cpus,4)))
 
     qemu_cmd+=(								\
 	-m		"$ktest_mem,slots=8,maxmem=$maxmem"		\
diff --git a/root_image b/root_image
index a881714..19eebae 100755
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
@@ -123,7 +124,7 @@ PACKAGES+=("linux-headers-generic")
 # DKMS needs to cross-compile the module,
 # against a different kernel on a different CPUarchitecture.
 # this has to cause errors
-[[ -n $CROSS_COMPILE ] && PACKAGES+=(dkms zfsutils-linux zfs-dkms)
+[[ ${CROSS_COMPILE+x} ]] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
 
 # suspend testing:
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
@@ -241,6 +242,7 @@ update_packages()
     chmod 755 "$MNT"/tmp/rustup.sh
 
     _chroot "$MNT" /tmp/rustup.sh -y
+    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
 }
 
 trim_image()
@@ -299,15 +301,38 @@ cmd_create()
     mkfs.ext4 -F "$ktest_image"
     mount "$ktest_image" "$MNT"
 
+   local debian_release="trixie" #general release
+   local keyring=""
+
+    if [[ $MIRROR == *"debian-ports"* ]]; then
+	debian_release="sid" #unofficial ports don't have named releases
+	echo ""
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
+    #fallback: if the architecture can't be found, try official sid:
+    if [[ -z $(curl -qq -I "${MIRROR}/dists/${debian_release}/main/binary-${DEBIAN_ARCH}/Release" 2>/dev/null | grep "HTTP/2 200") ]]; then
+	echo "WARNING: $DEBIAN_ARCH $debian_release could not be found at ${MIRROR} (where it should be).  Falling back to standard sid"
+        MIRROR="https://deb.debian.org/debian/"
+	debian_release=sid
+    fi
+
     DEBOOTSTRAP_DIR=$ktest_dir/debootstrap $debootstrap	\
 	--no-check-gpg					\
 	--arch="$DEBIAN_ARCH"				\
 	--exclude=$(join_by , "${EXCLUDE[@]}")		\
 	--foreign					\
-	--components='main,contrib,non-free,bullseye-backports' \
-	bullseye "$MNT" "$MIRROR"
+	--components='main,contrib,non-free' \
+	trixie "$MNT" "$MIRROR"
 
-    [[ -n ${CROSS_COMPILE} ]] || cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
+    [[ ${CROSS_COMPILE+x} ]] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
     _chroot "$MNT" /debootstrap/debootstrap --second-stage
     _chroot "$MNT" dpkg --configure -a
 
-- 
2.42.1

