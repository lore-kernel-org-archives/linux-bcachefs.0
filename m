Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D7CC433F5
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Oct 2021 12:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388A761053
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Oct 2021 12:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhJGNAj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 7 Oct 2021 09:00:39 -0400
Received: from cdw.me.uk ([91.203.57.136]:55553 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhJGNAi (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 7 Oct 2021 09:00:38 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mYSyx-0000rI-FM
        for linux-bcachefs@vger.kernel.org; Thu, 07 Oct 2021 13:58:43 +0100
Date:   Thu, 7 Oct 2021 13:58:43 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] [bcachefs-tools] Use scrypt from libsodium
Message-ID: <20211007125843.GA2191@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs-tools has both libscrypt and libsodium as build dependencies,
but libsodium already includes the same scrypt implementation as libscrypt,
originally written by Colin Percival.

Use the libsodium copy, dropping the extra libscrypt dependency.

Explicitly adopt the default scrypt N, r and p values from libscrypt to
avoid unintended changes in the default work parameters for bcachefs.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 .travis.yml                   |  1 -
 INSTALL                       |  7 +++----
 Makefile                      |  2 +-
 crypto.c                      | 21 +++++++++++----------
 debian/control                |  2 +-
 default.nix                   |  2 +-
 packaging/bcachefs-tools.spec |  2 --
 7 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 3b90b73..399d5bc 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -18,7 +18,6 @@ addons:
             - libblkid-dev
             - libkeyutils-dev
             - liblz4-dev
-            - libscrypt-dev
             - libsodium-dev
             - liburcu-dev
             - libzstd-dev
diff --git a/INSTALL b/INSTALL
index 85c09a2..c9ff28a 100644
--- a/INSTALL
+++ b/INSTALL
@@ -6,7 +6,6 @@ Dependencies:
  * libblkid
  * libkeyutils
  * liblz4
- * libscrypt
  * libsodium
  * liburcu
  * libuuid
@@ -17,17 +16,17 @@ Dependencies:
 
 Debian (Bullseye or later) and Ubuntu (20.04 or later): you can install these with
     apt install -y pkg-config libaio-dev libblkid-dev libkeyutils-dev \
-        liblz4-dev libscrypt-dev libsodium-dev liburcu-dev libzstd-dev \
+        liblz4-dev libsodium-dev liburcu-dev libzstd-dev \
         uuid-dev zlib1g-dev valgrind libudev-dev
 
 Fedora: install the "Development tools" group along with:
     dnf install -y libaio-devel libsodium-devel \
         libblkid-devel libzstd-devel zlib-devel userspace-rcu-devel \
         lz4-devel libuuid-devel valgrind-devel keyutils-libs-devel \
-        libscrypt-devel findutils
+        findutils
 
 Arch: install bcachefs-tools-git from the AUR.
-Or to build from source, install libscrypt from the AUR along with,
+Or to build from source, install build dependencies with
     pacman -S base-devel libaio keyutils libsodium liburcu zstd valgrind
 
 Then, just make && make install
diff --git a/Makefile b/Makefile
index 23e0508..e9d701e 100644
--- a/Makefile
+++ b/Makefile
@@ -50,7 +50,7 @@ endif
 CFLAGS+=$(PKGCONFIG_CFLAGS)
 LDLIBS+=$(PKGCONFIG_LDLIBS)
 
-LDLIBS+=-lm -lpthread -lrt -lscrypt -lkeyutils -laio -ldl
+LDLIBS+=-lm -lpthread -lrt -lkeyutils -laio -ldl
 LDLIBS+=$(EXTRA_LDLIBS)
 
 ifeq ($(PREFIX),/usr)
diff --git a/crypto.c b/crypto.c
index 7f7fbd5..43753a3 100644
--- a/crypto.c
+++ b/crypto.c
@@ -12,7 +12,7 @@
 
 #include <keyutils.h>
 #include <linux/random.h>
-#include <libscrypt.h>
+#include <sodium/crypto_pwhash_scryptsalsa208sha256.h>
 #include <uuid/uuid.h>
 
 #include "libbcachefs/checksum.h"
@@ -84,12 +84,13 @@ struct bch_key derive_passphrase(struct bch_sb_field_crypt *crypt,
 
 	switch (BCH_CRYPT_KDF_TYPE(crypt)) {
 	case BCH_KDF_SCRYPT:
-		ret = libscrypt_scrypt((void *) passphrase, strlen(passphrase),
-				       salt, sizeof(salt),
-				       1ULL << BCH_KDF_SCRYPT_N(crypt),
-				       1ULL << BCH_KDF_SCRYPT_R(crypt),
-				       1ULL << BCH_KDF_SCRYPT_P(crypt),
-				       (void *) &key, sizeof(key));
+		ret = crypto_pwhash_scryptsalsa208sha256_ll(
+			(void *) passphrase, strlen(passphrase),
+			salt, sizeof(salt),
+			1ULL << BCH_KDF_SCRYPT_N(crypt),
+			1ULL << BCH_KDF_SCRYPT_R(crypt),
+			1ULL << BCH_KDF_SCRYPT_P(crypt),
+			(void *) &key, sizeof(key));
 		if (ret)
 			die("scrypt error: %i", ret);
 		break;
@@ -170,9 +171,9 @@ void bch_sb_crypt_init(struct bch_sb *sb,
 	if (passphrase) {
 
 		SET_BCH_CRYPT_KDF_TYPE(crypt, BCH_KDF_SCRYPT);
-		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(SCRYPT_N));
-		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(SCRYPT_r));
-		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(SCRYPT_p));
+		SET_BCH_KDF_SCRYPT_N(crypt, ilog2(16384));
+		SET_BCH_KDF_SCRYPT_R(crypt, ilog2(8));
+		SET_BCH_KDF_SCRYPT_P(crypt, ilog2(16));
 
 		struct bch_key passphrase_key = derive_passphrase(crypt, passphrase);
 
diff --git a/debian/control b/debian/control
index 2120504..0f766c2 100644
--- a/debian/control
+++ b/debian/control
@@ -4,7 +4,7 @@ Section: utils
 Priority: optional
 Standards-Version: 3.9.5
 Build-Depends: debhelper (>= 9), pkg-config, libaio-dev, libblkid-dev,
-	libkeyutils-dev, liblz4-dev, libscrypt-dev, libsodium-dev, liburcu-dev,
+	libkeyutils-dev, liblz4-dev, libsodium-dev, liburcu-dev,
 	libzstd-dev, uuid-dev, zlib1g-dev
 Homepage: https://bcachefs.org/
 
diff --git a/default.nix b/default.nix
index f19ff10..a53667d 100644
--- a/default.nix
+++ b/default.nix
@@ -12,7 +12,7 @@ stdenv.mkDerivation rec {
   nativeBuildInputs = [ git pkgconfig ];
   buildInputs =
     [ liburcu libuuid libaio zlib attr keyutils
-      libsodium libscrypt
+      libsodium
     ];
 
   enableParallelBuilding = true;
diff --git a/packaging/bcachefs-tools.spec b/packaging/bcachefs-tools.spec
index 4946cef..00d0fbb 100644
--- a/packaging/bcachefs-tools.spec
+++ b/packaging/bcachefs-tools.spec
@@ -15,7 +15,6 @@ BuildRequires:  keyutils-libs-devel
 BuildRequires:  libaio-devel
 BuildRequires:  libattr-devel
 BuildRequires:  libblkid-devel
-BuildRequires:  libscrypt-devel
 BuildRequires:  libsodium-devel
 BuildRequires:  libtool-ltdl-devel
 BuildRequires:  libuuid-devel
@@ -32,7 +31,6 @@ Requires:   keyutils-libs
 Requires:   libaio
 Requires:   libattr
 Requires:   libblkid
-Requires:   libscrypt
 Requires:   libsodium
 Requires:   libtool-ltdl
 Requires:   libuuid
