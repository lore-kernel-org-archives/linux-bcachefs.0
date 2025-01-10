Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987BB21C9E4
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549389; cv=none; b=drUHeVQEEAn5SN24f/tbC8Avs+N5NZWrQz6Z4niNka9xsKVp0b8bpfdys4z9ata3vU0bjW+hrjSexBmF7rwwgFupgHOo7zPLAaxAcNYGSgRp6BijluWupa20HFGo1RPD3NQUGHtcrs74oJENhI17ygonLe3lb59JvBtm76iMGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549389; c=relaxed/simple;
	bh=dnXgaYMBEa9WeGLYtsaiT9m/A8FApAjbEuA2PQHJW6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyT/Jwzmf7peGP2wFWTJhGZwOIM51zVda3tQ+MNaAs+qjFOoClcWJZjcWyfjAZM34YigiQfVMV2n3HQTc1qNNp3YCQwMMlhR3W/BjIvRVqwHxYBnT3qER2RLMqQBIoSgZjCCM1oEt9FMikUr/sTG75hnvEYa2QAzUq0NBO7Glj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=GzEYpP95; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="GzEYpP95"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 154DC240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549386; bh=dnXgaYMBEa9WeGLYtsaiT9m/A8FApAjbEuA2PQHJW6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=GzEYpP951uVP2R+zQjFDqjutTsIkB/Bx/NManqLsbrw8eM0/G4Unau6ofFKYX7+BI
	 nJ/2rY7Bg0y1+Wl6FTcLwe3Hb+bfYmZ+hkhv4YMXHJxjGkm1OGNmvfpbwiYuAlggeZ
	 OdpIKTowDRy6oMAGoH4KGX2fpxj7UZtfiUEw8f4O8hUhrxhAT5vAj6MjrdhMYnpIc4
	 H0/kykTmtaM35+rFsQ5cXEgIV9wX5C0U4DRZqHlr5y5+flf6RgdR+I/dGIBTtUmyGE
	 O22EdU/iX8KmPDox2ulELTHhFLkcxiTaPxg6XPCiPNa+pGZ389QRsT5eY+uSb0GNeM
	 Yfo6nYMV6VJ2g==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0T4qbbz6tyK;
	Fri, 10 Jan 2025 23:49:45 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 4/9] feat(nix): replace fenix with rust-overlay
Date: Fri, 10 Jan 2025 22:49:07 +0000
Message-ID: <20250110224912.445491-5-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
 flake.nix  | 18 ++++++++++++------
 2 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/flake.lock b/flake.lock
index b38af96b..189ea88a 100644
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
-        "lastModified": 1736318091,
-        "narHash": "sha256-RkRHXZaMgOMGgkW2YmEqxxDDYRiGFbfr1JuaI0VrCKo=",
-        "owner": "nix-community",
-        "repo": "fenix",
-        "rev": "9e13860d50cbfd42e79101a516e1939c7723f093",
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
@@ -101,27 +80,30 @@
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
-        "lastModified": 1736266405,
-        "narHash": "sha256-V2FDSb8YjuquZduBRNp5niWYlWurja2yGN6Xzh5GPYk=",
-        "owner": "rust-lang",
-        "repo": "rust-analyzer",
-        "rev": "91fc0a239af4e56b84b1d3974ac0f34dcc99b895",
+        "lastModified": 1736438724,
+        "narHash": "sha256-m0CFbWVKtXsAr5OBgWNwR8Uam/jkPIjWgJkdH9DY46M=",
+        "owner": "oxalica",
+        "repo": "rust-overlay",
+        "rev": "15897cf5835bb95aa002b42c22dc61079c28f7c8",
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
index 9e09a621..f435edc6 100644
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
 
@@ -198,7 +202,9 @@
               nixfmt.enable = true;
               rustfmt.edition = rustfmtToml.edition;
               rustfmt.enable = true;
-              rustfmt.package = fenix.packages.${system}.default.rustfmt;
+              rustfmt.package =
+                (pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.rustfmt)).overrideAttrs
+                  { meta.mainProgram = "rustfmt"; };
             };
           };
         };
-- 
2.47.0

