Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCA1D75
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 11:45:30 -0800 (PST)
X-ASG-Debug-ID: 1700336721-24639c7fb84da54000a-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b03.edpnet.be with ESMTP id G7G66F6nQIAefgcA; Sat, 18 Nov 2023 20:45:25 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v4 09/10] fixup! fix a few malfunctioning variables
Date: Sat, 18 Nov 2023 20:38:48 +0100
X-ASG-Orig-Subj: [PATCH v4 09/10] fixup! fix a few malfunctioning variables
Message-ID: <20231118194453.41324-10-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Start-Time: 1700336724
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 2533
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116931
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 lib/libktest.sh |  3 +--
 root_image      | 15 +++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/lib/libktest.sh b/lib/libktest.sh
index d5844f6..bf93a3a 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -286,7 +286,6 @@ start_vm()
     ln -s "$ktest_tmp" "$ktest_out/vm"
 
     local kernelargs=()
-
     case $ktest_storage_bus in
 	virtio-blk)
 	    ktest_root_dev="/dev/vda"
@@ -296,7 +295,7 @@ start_vm()
 	    ;;
     esac
 
-    kernelargs+=(root=$ktest_root_dev rw log_buf_len=8M)
+    kernelargs+=(root=$ktest_root_dev rw log_buf_len=8M rootwait)
     kernelargs+=(mitigations=off)
     kernelargs+=("ktest.dir=$ktest_dir")
     kernelargs+=(ktest.env=$(readlink -f "$ktest_out/vm/env"))
diff --git a/root_image b/root_image
index e5a5c55..bc965d6 100755
--- a/root_image
+++ b/root_image
@@ -293,9 +293,8 @@ update_packages()
     # systemd... !?
     mkdir -p "$MNT"/run/user/0
     cp /etc/resolv.conf "$MNT/etc/resolv.conf"
-
-    [[ $(curl -qq -I "https://static.rust-lang.org/rustup/${RUST_TRIPLE}/rustup-init" 2>/dev/null | grep "HTTP/2 200") == "" ]] && NO_RUSTUP=1
-    [ $NO_RUSTUP ] && PACKAGES+=(rustc rustc-dbgsym rustfmt rustfmt-dbgsym) #don't do rustup on unsupported architectures, just try from debian repositories
+    [[ $(curl -qq -I "https://static.rust-lang.org/rustup/dist/${RUST_TRIPLE}/rustup-init" 2>/dev/null | grep "HTTP/2 200") == "" ]] && NO_RUSTUP=1
+    [ $NO_RUSTUP == "1" ] && PACKAGES+=(rustc rustc-dbgsym rustfmt rustfmt-dbgsym) #don't do rustup on unsupported architectures, just try from debian repositories
 
     _chroot "$MNT" mount -t proc none /proc
     if [[ $MIRROR == *"debian-ports"* ]]; then
@@ -308,12 +307,12 @@ update_packages()
     fi
     rm -f "$MNT/var/cache/apt/archives/*.deb"
 
-    if [ ! $NO_RUSTUP ]; then
-    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
-    chmod 755 "$MNT"/tmp/rustup.sh
+    if [ $NO_RUSTUP == "0" ]; then
+	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
+	chmod 755 "$MNT"/tmp/rustup.sh
 
-    _chroot "$MNT" /tmp/rustup.sh --default-host $RUST_TRIPLE -y
-    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
+	_chroot "$MNT" /tmp/rustup.sh --default-host ${RUST_TRIPLE} -y
+	echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
     fi;
 }
 
-- 
2.42.1

