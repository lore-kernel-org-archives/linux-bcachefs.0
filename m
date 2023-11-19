Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75FA129
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 08:02:11 -0800 (PST)
X-ASG-Debug-ID: 1700409726-214fdf696263e1b0006-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id 0dM6c7A8EZmzeGN4; Sun, 19 Nov 2023 17:02:08 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org
Cc: Janpieter Sollie <janpieter.sollie@kabelmail.de>,
	jpsollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v5 05/10] Enable rust support cross-arch
Date: Sun, 19 Nov 2023 16:48:12 +0100
X-ASG-Orig-Subj: [PATCH v5 05/10] Enable rust support cross-arch
Message-ID: <20231119160155.34496-6-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Scan-Msg-Size: 1802
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116969
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Make the rust compiler instsallable via rustup even though it's not in the vm yet.
This avoids rust compile errors on emulated CPUs,
rustup installs for host cpu kernel architecture instead of VM architecture.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 lib/common.sh | 4 ++++
 root_image    | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/common.sh b/lib/common.sh
index 5e24169..7aadfaa 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -87,6 +87,7 @@ parse_arch()
 	    ktest_arch=x86
 	    DEBIAN_ARCH=i386
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
+	    RUST_TRIPLE=i686-unknown-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=32
@@ -98,6 +99,7 @@ parse_arch()
 	    ktest_arch=x86_64
 	    DEBIAN_ARCH=amd64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_X86_64}
+	    RUST_TRIPLE=x86_64-unknown-linux-gnu
 
 	    KERNEL_ARCH=x86
 	    BITS=64
@@ -109,6 +111,7 @@ parse_arch()
 	    ktest_arch=aarch64
 	    DEBIAN_ARCH=arm64
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARM64}
+	    RUST_TRIPLE=aarch64-unknown-linux-gnu
 
 	    KERNEL_ARCH=arm64
 	    BITS=64
@@ -120,6 +123,7 @@ parse_arch()
 	    ktest_arch=arm
 	    DEBIAN_ARCH=armhf
 	    ARCH_TRIPLE=${ARCH_TRIPLE_ARMV7}
+	    RUST_TRIPLE=armv7-unknown-linux-gnueabihf
 
 	    KERNEL_ARCH=arm
 	    BITS=32
diff --git a/root_image b/root_image
index 19eebae..4416132 100755
--- a/root_image
+++ b/root_image
@@ -241,7 +241,7 @@ update_packages()
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
     chmod 755 "$MNT"/tmp/rustup.sh
 
-    _chroot "$MNT" /tmp/rustup.sh -y
+    _chroot "$MNT" /tmp/rustup.sh --default-host $RUST_TRIPLE -y
     echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
 }
 
-- 
2.42.1

