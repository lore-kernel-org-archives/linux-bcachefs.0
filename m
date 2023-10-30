Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F94C41535
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjJ3PLU (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbjJ3PLS (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:18 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E75DF
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:14 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae03410002-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id vHwKWRGD8XIwoe6g; Mon, 30 Oct 2023 16:11:12 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 01/10] Increase cross-compile compatibility
Date:   Mon, 30 Oct 2023 15:58:12 +0100
X-ASG-Orig-Subj: [PATCH v3 01/10] Increase cross-compile compatibility
Message-ID: <20231030151046.29827-2-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
Reply-To: janpieter.sollie@kabelmail.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Start-Time: 1698678671
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3137
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

Some user distros do not use standard triplets, but instead, the triplet has another name.
Move the triplet name into a gitignored config file,
and fix a few trivial error messages breaking a cross-compile build:
- use headers-generic instead of headers-$arch
- if ulimit isn't set, don't do it.

Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
---
 .gitignore      |  1 +
 cross.conf      |  8 ++++++++
 lib/common.sh   | 10 +++++++---
 lib/libktest.sh |  2 +-
 root_image      |  2 +-
 5 files changed, 18 insertions(+), 5 deletions(-)
 create mode 100644 cross.conf

diff --git a/.gitignore b/.gitignore
index d82a2a5..0e86b51 100644
--- a/.gitignore
+++ b/.gitignore
@@ -4,6 +4,7 @@ cscope*
 tags
 ktest-out
 *.tags
+cross.conf
 
 lib/lwip-connect
 lib/supervisor
diff --git a/cross.conf b/cross.conf
new file mode 100644
index 0000000..2896885
--- /dev/null
+++ b/cross.conf
@@ -0,0 +1,8 @@
+# this file specifies target triplets for cross-compiling
+# whenever these need to be changed (some distributions prefer ARCHITECTURE-VENDOR-OS-LIBC), 
+# change the triplet here
+
+ARCH_TRIPLE_X86=x86-linux-gnu
+ARCH_TRIPLE_X86_64=x86_64-linux-gnu
+ARCH_TRIPLE_ARM64=aarch64-linux-gnu
+
diff --git a/lib/common.sh b/lib/common.sh
index 7786091..078f512 100644
--- a/lib/common.sh
+++ b/lib/common.sh
@@ -3,6 +3,10 @@ set -o nounset
 set -o errtrace
 set -o pipefail
 
+[[ -v ktest_dir ]] || ktest_dir=$(dirname ${BASH_SOURCE})/..
+
+. "$ktest_dir/cross.conf"
+
 trap 'echo "Error $? at $BASH_SOURCE $LINENO from: $BASH_COMMAND, exiting"' ERR
 
 ktest_tmp=${ktest_tmp:-""}
@@ -85,7 +89,7 @@ parse_arch()
 	x86|i386)
 	    ktest_arch=x86
 	    DEBIAN_ARCH=i386
-	    ARCH_TRIPLE=x86-linux-gnu
+	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
 
 	    KERNEL_ARCH=x86
 	    BITS=32
@@ -96,7 +100,7 @@ parse_arch()
 	x86_64|amd64)
 	    ktest_arch=x86_64
 	    DEBIAN_ARCH=amd64
-	    ARCH_TRIPLE=x86_64-linux-gnu
+	    ARCH_TRIPLE=${ARCH_TRIPLE_X86_64}
 
 	    KERNEL_ARCH=x86
 	    BITS=64
@@ -107,7 +111,7 @@ parse_arch()
 	aarch64|arm64)
 	    ktest_arch=aarch64
 	    DEBIAN_ARCH=arm64
-	    ARCH_TRIPLE=aarch64-linux-gnu
+	    ARCH_TRIPLE=${ARCH_TRIPLE_ARM64}
 
 	    KERNEL_ARCH=arm64
 	    BITS=64
diff --git a/lib/libktest.sh b/lib/libktest.sh
index 95d4b77..9b4931d 100644
--- a/lib/libktest.sh
+++ b/lib/libktest.sh
@@ -438,7 +438,7 @@ start_vm()
 	qemu_pmem mem-path="$file",size=$size
     done
 
-    ulimit -n 65535
+    [ "$(ulimit)" == "unlimited" ] || ulimit -n 65535
     qemu_cmd+=("${ktest_qemu_append[@]}")
 
     set +o errexit
diff --git a/root_image b/root_image
index ece986a..26c99fe 100755
--- a/root_image
+++ b/root_image
@@ -118,7 +118,7 @@ PACKAGES+=(cryptsetup)
 PACKAGES+=(multipath-tools sg3-utils srptools)
 
 # ZFS support
-PACKAGES+=("linux-headers-$DEBIAN_ARCH" dkms zfsutils-linux zfs-dkms)
+PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
 
 # suspend testing:
 # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
-- 
2.42.0

