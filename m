Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8D013635C
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574872; cv=none; b=lFrClvF5b+HLGxWH7fcmV6dvZfoJR0VGtZs634eS3HNhdYpj/fysoL+SK3UCQGJalohVh5WxGyT/lVwj9TQZQS+JCElkNVaDB4APc4Te/m5KERd6ZL7RsJdABbSK2gi4b7WsH5Cvq1WsVljegvwAP6Yr2qK4AvCjiKHwdaV9rcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574872; c=relaxed/simple;
	bh=+1oPYaQYnSp14ldrIfjainaJhoyi2LdlClwyaIuAslc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5TPIoNY9EX2elDeW/FmFdKmuN2lrfKPdiYXVgnLMBEE+KclB910ti2MBFl/+XYbIOEqwpVyKQ5RX4HbxaBGwEcfJCvBejngo2q/4oKiCZ9dkcF+GCRsyOez05xKNmGbdqICAhOjX1BkvJvFxj5JnAYwrAdtDvq3zsKEPNBNnoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=O/8yCFNh; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="O/8yCFNh"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 31C74240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574868; bh=+1oPYaQYnSp14ldrIfjainaJhoyi2LdlClwyaIuAslc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=O/8yCFNh8UzUZrSkSSqci5Ogd0Am7lwfbROjdyeoSo3QzlPbZXC8Zv1cp8daqgrfh
	 54epbRHGKp4hmvZLuUvgvOqisOmma2XetwHWWQEW0jJGTR5jMHlYKfojSKQDQZFULB
	 jg+LHBljKYk0qcZxDBnQtNIjNzdkLzyagclsWF8135QX9OmKvxVqUzMrcbqT78UFjQ
	 cm76107I6cdOS6RHA7+pFc4mjsXzU5kENHvIpjBdXXrm8BWY9mfz8MevNMJdr+iTtR
	 2pDs4jnA0XhueQMW+fH68FuGg72jwN/G9VBLdReCVk/7bm1qH4O5YPG+m5g57HVPxc
	 Qkj7b0OCdxoWg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M372Z6z9rxM;
	Fri, 21 Mar 2025 17:34:23 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 04/10] feat(nix): replace fenix with rust-overlay
Date: Fri, 21 Mar 2025 16:33:58 +0000
Message-ID: <20250321163404.353334-5-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We're going to use rust-overlay for setting up an MSRV build.
---
 flake.lock | 46 ++++++++++++++--------------------------------
 flake.nix  | 16 ++++++++++------
 2 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/flake.lock b/flake.lock
index d8a0ace7..c8ea8d15 100644
--- a/flake.lock
+++ b/flake.lock
@@ -15,27 +15,6 @@
         "type": "github"
       }
     },
-    "fenix": {
-      "inputs": {
-        "nixpkgs": [
-          "nixpkgs"
-        ],
-        "rust-analyzer-src": "rust-analyzer-src"
-      },
-      "locked": {
-        "lastModified": 1742452566,
-        "narHash": "sha256-sVuLDQ2UIWfXUBbctzrZrXM2X05YjX08K7XHMztt36E=",
-        "owner": "nix-community",
-        "repo": "fenix",
-        "rev": "7d9ba794daf5e8cc7ee728859bc688d8e26d5f06",
-        "type": "github"
-      },
-      "original": {
-        "owner": "nix-community",
-        "repo": "fenix",
-        "type": "github"
-      }
-    },
     "flake-compat": {
       "flake": false,
       "locked": {
@@ -104,27 +83,30 @@
     "root": {
       "inputs": {
         "crane": "crane",
-        "fenix": "fenix",
         "flake-compat": "flake-compat",
         "flake-parts": "flake-parts",
         "nixpkgs": "nixpkgs",
+        "rust-overlay": "rust-overlay",
         "treefmt-nix": "treefmt-nix"
       }
     },
-    "rust-analyzer-src": {
-      "flake": false,
+    "rust-overlay": {
+      "inputs": {
+        "nixpkgs": [
+          "nixpkgs"
+        ]
+      },
       "locked": {
-        "lastModified": 1742296961,
-        "narHash": "sha256-gCpvEQOrugHWLimD1wTFOJHagnSEP6VYBDspq96Idu0=",
-        "owner": "rust-lang",
-        "repo": "rust-analyzer",
-        "rev": "15d87419f1a123d8f888d608129c3ce3ff8f13d4",
+        "lastModified": 1742524367,
+        "narHash": "sha256-KzTwk/5ETJavJZYV1DEWdCx05M4duFCxCpRbQSKWpng=",
+        "owner": "oxalica",
+        "repo": "rust-overlay",
+        "rev": "70bf752d176b2ce07417e346d85486acea9040ef",
         "type": "github"
       },
       "original": {
-        "owner": "rust-lang",
-        "ref": "nightly",
-        "repo": "rust-analyzer",
+        "owner": "oxalica",
+        "repo": "rust-overlay",
         "type": "github"
       }
     },
diff --git a/flake.nix b/flake.nix
index 9e09a621..5f93f522 100644
--- a/flake.nix
+++ b/flake.nix
@@ -13,8 +13,8 @@
 
     crane.url = "github:ipetkov/crane";
 
-    fenix = {
-      url = "github:nix-community/fenix";
+    rust-overlay = {
+      url = "github:oxalica/rust-overlay";
       inputs.nixpkgs.follows = "nixpkgs";
     };
 
@@ -30,9 +30,9 @@
       nixpkgs,
       flake-parts,
       treefmt-nix,
-      fenix,
       crane,
-      ...
+      rust-overlay,
+      flake-compat,
     }:
     let
       systems = nixpkgs.lib.filter (s: nixpkgs.lib.hasSuffix "-linux" s) nixpkgs.lib.systems.flakeExposed;
@@ -47,7 +47,6 @@
           self',
           config,
           lib,
-          pkgs,
           system,
           ...
         }:
@@ -56,6 +55,11 @@
           inherit (lib.lists) findFirst;
           inherit (lib.strings) hasPrefix removePrefix substring;
 
+          pkgs = import nixpkgs {
+            inherit system;
+            overlays = [ (import rust-overlay) ];
+          };
+
           cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
           rustfmtToml = builtins.fromTOML (builtins.readFile ./rustfmt.toml);
 
@@ -198,7 +202,7 @@
               nixfmt.enable = true;
               rustfmt.edition = rustfmtToml.edition;
               rustfmt.enable = true;
-              rustfmt.package = fenix.packages.${system}.default.rustfmt;
+              rustfmt.package = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.rustfmt);
             };
           };
         };
-- 
2.48.1

