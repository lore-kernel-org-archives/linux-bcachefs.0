Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A911BC433EF
	for <linux-bcachefs@archiver.kernel.org>; Sat, 23 Oct 2021 15:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B55560FE8
	for <linux-bcachefs@archiver.kernel.org>; Sat, 23 Oct 2021 15:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhJWPvq (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 23 Oct 2021 11:51:46 -0400
Received: from cdw.me.uk ([91.203.57.136]:57827 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhJWPvq (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 23 Oct 2021 11:51:46 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1meJGv-0000vx-67; Sat, 23 Oct 2021 16:49:25 +0100
Date:   Sat, 23 Oct 2021 16:49:25 +0100
From:   Chris Webb <chris@arachsys.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH v2] [bcachefs-tools] Use scrypt from libsodium
Message-ID: <20211023154925.GF11670@arachsys.com>
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

Notes:
    v1: Generated to apply against 3f7b0b0 (2021-10-05)
    v2: Updated to apply against f9f5778 (2021-10-21)

 .travis.yml                   |  1 -
 INSTALL                       |  7 +++----
 Makefile                      |  2 +-
 crypto.c                      | 21 +++++++++++----------
 debian/control                |  2 +-
 default.nix                   |  2 --
 packaging/bcachefs-tools.spec |  2 --
 7 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 947997b..e66f0c2 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -19,7 +19,6 @@ addons:
             - libblkid-dev
             - libkeyutils-dev
             - liblz4-dev
-            - libscrypt-dev
             - libsodium-dev
             - liburcu-dev
             - libzstd-dev
diff --git a/INSTALL b/INSTALL
index f1d3877..b4d60bf 100644
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
@@ -17,7 +16,7 @@ Dependencies:
 
 Debian (Bullseye or later) and Ubuntu (20.04 or later): you can install these with
     apt install -y pkg-config libaio-dev libblkid-dev libkeyutils-dev \
-        liblz4-dev libscrypt-dev libsodium-dev liburcu-dev libzstd-dev \
+        liblz4-dev libsodium-dev liburcu-dev libzstd-dev \
         uuid-dev zlib1g-dev valgrind libudev-dev git build-essential \
         python3 python3-docutils
 
@@ -25,10 +24,10 @@ Fedora: install the "Development tools" group along with:
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
index e4f6820..e94419f 100644
--- a/Makefile
+++ b/Makefile
@@ -73,7 +73,7 @@ endif
 
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
index f8752bb..091161d 100644
--- a/debian/control
+++ b/debian/control
@@ -4,7 +4,7 @@ Section: utils
 Priority: optional
 Standards-Version: 3.9.5
 Build-Depends: debhelper (>= 9), pkg-config, libaio-dev, libblkid-dev,
-	libkeyutils-dev, liblz4-dev, libscrypt-dev, libsodium-dev, liburcu-dev,
+	libkeyutils-dev, liblz4-dev, libsodium-dev, liburcu-dev,
 	libzstd-dev, uuid-dev, zlib1g-dev, python3, python3-docutils
 Homepage: https://bcachefs.org/
 
diff --git a/default.nix b/default.nix
index eee7300..48f2aa9 100644
--- a/default.nix
+++ b/default.nix
@@ -5,7 +5,6 @@
 , pkg-config
 , attr
 , libuuid
-, libscrypt
 , libsodium
 , keyutils
 
@@ -71,7 +70,6 @@ stdenv.mkDerivation {
 		keyutils # libkeyutils
 		lz4 # liblz4
 		
-		libscrypt
 		libsodium
 		liburcu
 		libuuid
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
