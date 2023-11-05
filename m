Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDE7C4167D
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 20:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjKEU5D (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 15:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjKEU5C (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 15:57:02 -0500
Received: from gimli.kloenk.de (gimli.kloenk.de [IPv6:2a01:4f8:c012:b874::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1483FA
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 12:56:59 -0800 (PST)
From:   Finn Behrens <me@kloenk.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.de; s=mail;
        t=1699217344; bh=aeWg45IJ09bOSmCLImaO41V+7+25D9N7gEME9V96JEI=;
        h=From:To:Cc:Subject:Date;
        b=u9MkVqsdFJ7Xj9xn93eRW1fL7tXKYNr5NwRgAzcwaIm5m+AyCqvkZXHFpAoVwKY8k
         zqkplwg0DnmKfwyb7VE/+pjP9uZnvo1k1kDWKZ/hvT2CwoM9bjAa8nquKPh4abV8FB
         z38yJrNqekK/KFeKut0IlkQIoGhkFFTld5fACPk4=
To:     linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev
Cc:     dev@leona.is, Finn Behrens <me@kloenk.de>
Subject: [PATCH 1/2] nix: fix build add overlay and formatter to flake
Date:   Sun,  5 Nov 2023 21:48:53 +0100
Message-ID: <20231105204854.244570-1-me@kloenk.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Co-authored-by: Leona Maroni <dev@leona.is>
Signed-off-by: Leona Maroni <dev@leona.is>
Signed-off-by: Finn Behrens <me@kloenk.de>
---
 build.nix   | 34 +++++++++-------------------------
 default.nix | 16 ++++++----------
 flake.lock  | 18 +++++++++---------
 flake.nix   | 17 +++++++++++++----
 4 files changed, 37 insertions(+), 48 deletions(-)

diff --git a/build.nix b/build.nix
index 5cf07de..e05dad4 100644
--- a/build.nix
+++ b/build.nix
@@ -1,28 +1,10 @@
-{ lib
-, stdenv
-, pkg-config
-, attr
-, libuuid
-, libsodium
-, keyutils
-, liburcu
-, zlib
-, libaio
-, udev
-, zstd
-, lz4
-, nix-gitignore
-, rustPlatform
-, rustc
-, cargo
- }:
-
+{ lib, stdenv, pkg-config, attr, libuuid, libsodium, keyutils, liburcu, zlib
+, libaio, udev, zstd, lz4, nix-gitignore, rustPlatform, rustc, cargo, }:
 let
-  src = nix-gitignore.gitignoreSource [] ./. ;
+  src = nix-gitignore.gitignoreSource [ ] ./.;
 
   commit = lib.strings.substring 0 7 (builtins.readFile ./.bcachefs_revision);
   version = "git-${commit}";
-
 in stdenv.mkDerivation {
   inherit src version;
 
@@ -61,12 +43,14 @@ in stdenv.mkDerivation {
     };
   };
 
-  makeFlags = [
-    "PREFIX=${placeholder "out"}"
-    "VERSION=${commit}"
-  ];
+  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" "VERSION=${commit}" ];
 
   dontStrip = true;
   checkPhase = "./bcachefs version";
   doCheck = true;
+
+  meta = {
+    mainProgram = "bcachefs";
+    license = lib.licenses.gpl2Only;
+  };
 }
diff --git a/default.nix b/default.nix
index 2cccff2..80aeb43 100644
--- a/default.nix
+++ b/default.nix
@@ -1,10 +1,6 @@
-(import
-  (
-    let lock = builtins.fromJSON (builtins.readFile ./flake.lock); in
-    fetchTarball {
-      url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
-      sha256 = lock.nodes.flake-compat.locked.narHash;
-    }
-  )
-  { src = ./.; }
-).defaultNix
+(import (let lock = builtins.fromJSON (builtins.readFile ./flake.lock);
+in fetchTarball {
+  url =
+    "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
+  sha256 = lock.nodes.flake-compat.locked.narHash;
+}) { src = ./.; }).defaultNix
diff --git a/flake.lock b/flake.lock
index 899f297..413959e 100644
--- a/flake.lock
+++ b/flake.lock
@@ -3,11 +3,11 @@
     "flake-compat": {
       "flake": false,
       "locked": {
-        "lastModified": 1673956053,
-        "narHash": "sha256-4gtG9iQuiKITOjNQQeQIpoIB6b16fm+504Ch3sNKLd8=",
+        "lastModified": 1696426674,
+        "narHash": "sha256-kvjfFW7WAETZlt09AgDn1MrtKzP7t90Vf7vypd3OL1U=",
         "owner": "edolstra",
         "repo": "flake-compat",
-        "rev": "35bb57c0c8d8b62bbfd284272c928ceb64ddbde9",
+        "rev": "0f9255e01c2351cc7d116c072cb317785dd33b33",
         "type": "github"
       },
       "original": {
@@ -18,11 +18,11 @@
     },
     "nixpkgs": {
       "locked": {
-        "lastModified": 1686592866,
-        "narHash": "sha256-riGg89eWhXJcPNrQGcSwTEEm7CGxWC06oSX44hajeMw=",
+        "lastModified": 1698924604,
+        "narHash": "sha256-GCFbkl2tj8fEZBZCw3Tc0AkGo0v+YrQlohhEGJ/X4s0=",
         "owner": "nixos",
         "repo": "nixpkgs",
-        "rev": "0eeebd64de89e4163f4d3cf34ffe925a5cf67a05",
+        "rev": "fa804edfb7869c9fb230e174182a8a1a7e512c40",
         "type": "github"
       },
       "original": {
@@ -59,11 +59,11 @@
         "systems": "systems"
       },
       "locked": {
-        "lastModified": 1685518550,
-        "narHash": "sha256-o2d0KcvaXzTrPRIo0kOLV0/QXHhDQ5DTi+OxcjO8xqY=",
+        "lastModified": 1694529238,
+        "narHash": "sha256-zsNZZGTGnMOf9YpHKJqMSsa0dXbfmxeoJ7xHlrt+xmY=",
         "owner": "numtide",
         "repo": "flake-utils",
-        "rev": "a1720a10a6cfe8234c0e93907ffe81be440f4cef",
+        "rev": "ff7b65b44d01cf9ba6a71320833626af21126384",
         "type": "github"
       },
       "original": {
diff --git a/flake.nix b/flake.nix
index 0f8e90d..bdaa4bf 100644
--- a/flake.nix
+++ b/flake.nix
@@ -10,13 +10,22 @@
   };
 
   outputs = { self, nixpkgs, utils, ... }:
-    utils.lib.eachDefaultSystem (system:
+    {
+      overlays.default = final: prev: {
+        bcachefs = final.callPackage ./build.nix { };
+      };
+    } // utils.lib.eachDefaultSystem (system:
       let
-        pkgs = nixpkgs.legacyPackages.${system};
-        bcachefs = pkgs.callPackage ./build.nix {};
+        pkgs = import nixpkgs {
+          inherit system;
+          overlays = [ self.overlays.default ];
+        };
       in {
         packages = {
-          default = bcachefs;
+          inherit (pkgs) bcachefs;
+          default = pkgs.bcachefs;
         };
+
+        formatter = pkgs.nixfmt;
       });
 }
-- 
2.42.0

