Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD84C0018A
	for <linux-bcachefs@archiver.kernel.org>; Mon, 30 Oct 2023 15:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjJ3PLY (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 30 Oct 2023 11:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbjJ3PLW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 30 Oct 2023 11:11:22 -0400
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A30DB
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Oct 2023 08:11:18 -0700 (PDT)
X-ASG-Debug-ID: 1698678671-214fdf23ae0341000a-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.166.214.adsl.dyn.edpnet.net [213.219.166.214]) by relay-b02.edpnet.be with ESMTP id 5dYi2mdjlEtwb2vI; Mon, 30 Oct 2023 16:11:15 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.166.214.adsl.dyn.edpnet.net[213.219.166.214]
X-Barracuda-Apparent-Source-IP: 213.219.166.214
From:   janpieter.sollie@kabelmail.de
To:     kent.overstreet@linux.dev
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: [PATCH v3 09/10] Fall back to sid rustc if rustup isn't available
Date:   Mon, 30 Oct 2023 15:58:20 +0100
X-ASG-Orig-Subj: [PATCH v3 09/10] Fall back to sid rustc if rustup isn't available
Message-ID: <20231030151046.29827-10-janpieter.sollie@kabelmail.de>
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
X-Barracuda-Scan-Msg-Size: 3356
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

Rustup only has a limited number of architectures,
when the root_image we are creating isn't supported,
try to install the debian rustc compiler.
this will be older, but >95% of time, it should be ok.

Signed-off-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
---
 root_image | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/root_image b/root_image
index 620ff05..0ad9ef9 100755
--- a/root_image
+++ b/root_image
@@ -89,8 +89,11 @@ install_fix_deps()
 		echo 'cd /tmpbuild/; $@' >> "$MNT"/tmpbuild/executer.sh
 		chmod ago+x "$MNT"/tmpbuild/executer.sh
 		_chroot "$MNT" /tmpbuild/executer.sh apt-get -qq build-dep --allow-unauthenticated --no-install-recommends $i || intervene install-deps $i;
-		_chroot "$MNT" /tmpbuild/executer.sh apt-get -qq -b source --allow-unauthenticated $i || intervene build $i;
-		[ -f "${MNT}/tmpbuild/${i}*.deb" ] && _chroot "$MNT" apt-get -qq install /tmpbuild/${i}*.deb;
+		#in case the intervention also installed it, continue:
+		if [[ $(_chroot "$MNT" dpkg -l | grep "^ii  $i") == "" ]]; then
+			_chroot "$MNT" /tmpbuild/executer.sh apt-get -qq -b source --allow-unauthenticated $i || intervene build $i;
+			[ -f "${MNT}/tmpbuild/${i}*.deb" ] && _chroot "$MNT" apt-get -qq install /tmpbuild/${i}*.deb;
+		fi
 		umount ${MNT}/tmpbuild;
 		rmdir ${MNT}/tmpbuild;
 	done
@@ -285,25 +288,32 @@ ZZ
 
 update_packages()
 {
+    NO_RUSTUP=0
     # systemd... !?
     mkdir -p "$MNT"/run/user/0
     cp /etc/resolv.conf "$MNT/etc/resolv.conf"
+
+    [[ $(curl -qq -I "https://static.rust-lang.org/rustup/${RUST_TRIPLE}/rustup-init" 2>/dev/null | grep "HTTP/2 200") == "" ]] && NO_RUSTUP=1
+    [ $NO_RUSTUP ] && PACKAGES+=(rustc rustc-dbgsym rustfmt rustfmt-dbgsym) #don't do rustup on unsupported architectures, just try from debian repositories
+
     _chroot "$MNT" mount -t proc none /proc
     if [[ $MIRROR == *"debian-ports"* ]]; then
 	install_fix_deps
     else
-    _chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
-    _chroot "$MNT" apt-get -qq --allow-unauthenticated upgrade
-    _chroot "$MNT" apt-get -qq install -f
-    _chroot "$MNT" apt-get -qq install -m --allow-unauthenticated --no-install-recommends "${PACKAGES[@]}"
+	_chroot "$MNT" apt-get -qq --allow-unauthenticated --allow-insecure-repositories update --fix-missing
+    	_chroot "$MNT" apt-get -qq --allow-unauthenticated upgrade
+    	_chroot "$MNT" apt-get -qq install -f
+    	_chroot "$MNT" apt-get -qq install -m --allow-unauthenticated --no-install-recommends "${PACKAGES[@]}"
     fi
     rm -f "$MNT/var/cache/apt/archives/*.deb"
 
+    if [ ! $NO_RUSTUP ]; then
     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > "$MNT"/tmp/rustup.sh
     chmod 755 "$MNT"/tmp/rustup.sh
 
     _chroot "$MNT" /tmp/rustup.sh --default-host $RUST_TRIPLE -y
     echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
+    fi;
 }
 
 trim_image()
@@ -352,7 +362,6 @@ cmd_create()
 	echo "$ktest_image already exists"
 	exit 1
     fi
-    set -o xtrace
     (cd "$ktest_dir"; git submodule update --init debootstrap)
 
     MNT=$(mktemp --tmpdir -d $(basename "$0")-XXXXXXXXXX)
-- 
2.42.0

