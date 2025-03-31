Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8D3223313
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743431727; cv=none; b=NNu3ZmarisriHEjHvYREuru/Uen+4lCG4qq7ZrVqnin4Mkrd93h+h/a+NDSz3VG7HJDu3XxjFapabjzIn681rKRtUdmw7AkimNFn1xWAaoB6y5W4D7cNPBAV0jddk9kt7Os1dxFpZiTqn2jN5KpeIk6un60PNS1tt2HXLBandNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743431727; c=relaxed/simple;
	bh=HjHT29Z/5oeaCzxvGA1ybc/NkIoFLP/CdoBkmXmYARQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXeqMXT+EhH87tO/sb2HchQTXC8Z8qLd2aP5zmWXQXRw2x6MJ/52nqudqH566QyyhDVCPmJ6Uq0+a3Gl7o67n4pjEAMDkqlQbaK9M+EeBfzz6qUUIHC3rRvCPT7OFOJ6T4uBSj4F3zU+2zyxiyP01U8uMaJJdQiW/CAVluvdMmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=p/Jb8cFD; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="p/Jb8cFD"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 29542240028
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:35:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1743431718; bh=HjHT29Z/5oeaCzxvGA1ybc/NkIoFLP/CdoBkmXmYARQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:From;
	b=p/Jb8cFDlNSz0nSNEvtZaJjAJTevECOXP6bxGMKHzjzSJr3ydwnhmsBVIQ4F4FkKf
	 iATvdEQ7195J+KXv2hogmtlfCJfi27XzPrvW48NSaAaN/Dv7G4HvO0DJtIp0NTNKbj
	 GiWKjDUa34XEV01sKbBRnyQnJ7o6nqgEYOtqntjS0Biusf9ZI1HVfVEp1RPDwiSK71
	 4SxO0Ak4WzGqggL4r58zOY8IEyaWhWsI3edUIPqBRVXQSfJKArR24JTweV1WKOXoJ8
	 pNxR5iY2of1pFp4HwX5xrtKpGEhHboFN2YPVkN7Xgu+yaA85ibYE767KbZjXyuXhTH
	 4WRqHwwLL1t7Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZRDF13v6xz9rxD;
	Mon, 31 Mar 2025 16:35:17 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 1/5] chore(nix): structure github CI nix flake checks
Date: Mon, 31 Mar 2025 14:35:05 +0000
Message-ID: <20250331143509.157528-2-tmuehlbacher@posteo.net>
In-Reply-To: <20250331143509.157528-1-tmuehlbacher@posteo.net>
References: <20250331143509.157528-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Makes it way easier to identify CI failures for people who try to use
github for contributions.

Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
---
 .github/workflows/nix-flake.yml | 41 +++++++++------
 flake.lock                      | 21 ++++++++
 flake.nix                       | 89 ++++++++++++++++++++-------------
 3 files changed, 100 insertions(+), 51 deletions(-)

diff --git a/.github/workflows/nix-flake.yml b/.github/workflows/nix-flake.yml
index 4dfb6453..91d9b27e 100644
--- a/.github/workflows/nix-flake.yml
+++ b/.github/workflows/nix-flake.yml
@@ -1,22 +1,31 @@
-name: "Nix-Tests"
+name: Nix Flake actions
+
 on:
   pull_request:
   push:
+
 jobs:
-  nix-flake-check:
+  nix-matrix:
     runs-on: ubuntu-latest
+    outputs:
+      matrix: ${{ steps.set-matrix.outputs.matrix }}
     steps:
-    - uses: actions/checkout@v4
-    - uses: cachix/install-nix-action@v27
-      with:
-        extra_nix_config: |
-          experimental-features = nix-command flakes
-          access-tokens = github.com=${{ secrets.GITHUB_TOKEN }}
-    - uses: cachix/cachix-action@v15
-      with:
-        name: bcachefs-tools
-        # If you chose API tokens for write access OR if you have a private cache
-        authToken: '${{ secrets.CACHIX_AUTH_TOKEN }}'
-    - run: nix flake show
-    - run: nix flake check --print-build-logs
-    - run: nix build --print-build-logs
+      - uses: actions/checkout@v4
+      - uses: cachix/install-nix-action@v30
+      - id: set-matrix
+        name: Generate Nix Matrix
+        run: |
+          set -Eeu
+          matrix="$(nix eval --json '.#githubActions.matrix')"
+          echo "matrix=$matrix" >> "$GITHUB_OUTPUT"
+
+  nix-build:
+    name: ${{ matrix.name }} (${{ matrix.system }})
+    needs: nix-matrix
+    runs-on: ${{ matrix.os }}
+    strategy:
+      matrix: ${{fromJSON(needs.nix-matrix.outputs.matrix)}}
+    steps:
+      - uses: actions/checkout@v4
+      - uses: cachix/install-nix-action@v30
+      - run: nix build -L '.#${{ matrix.attr }}'
diff --git a/flake.lock b/flake.lock
index c8ea8d15..0a9b2b85 100644
--- a/flake.lock
+++ b/flake.lock
@@ -49,6 +49,26 @@
         "type": "github"
       }
     },
+    "nix-github-actions": {
+      "inputs": {
+        "nixpkgs": [
+          "nixpkgs"
+        ]
+      },
+      "locked": {
+        "lastModified": 1737420293,
+        "narHash": "sha256-F1G5ifvqTpJq7fdkT34e/Jy9VCyzd5XfJ9TO8fHhJWE=",
+        "owner": "nix-community",
+        "repo": "nix-github-actions",
+        "rev": "f4158fa080ef4503c8f4c820967d946c2af31ec9",
+        "type": "github"
+      },
+      "original": {
+        "owner": "nix-community",
+        "repo": "nix-github-actions",
+        "type": "github"
+      }
+    },
     "nixpkgs": {
       "locked": {
         "lastModified": 1742422364,
@@ -85,6 +105,7 @@
         "crane": "crane",
         "flake-compat": "flake-compat",
         "flake-parts": "flake-parts",
+        "nix-github-actions": "nix-github-actions",
         "nixpkgs": "nixpkgs",
         "rust-overlay": "rust-overlay",
         "treefmt-nix": "treefmt-nix"
diff --git a/flake.nix b/flake.nix
index 1200a3b9..79ebfb94 100644
--- a/flake.nix
+++ b/flake.nix
@@ -22,6 +22,11 @@
       url = "github:edolstra/flake-compat";
       flake = false;
     };
+
+    nix-github-actions = {
+      url = "github:nix-community/nix-github-actions";
+      inputs.nixpkgs.follows = "nixpkgs";
+    };
   };
 
   outputs =
@@ -33,6 +38,7 @@
       crane,
       rust-overlay,
       flake-compat,
+      nix-github-actions,
     }:
     let
       systems = nixpkgs.lib.filter (s: nixpkgs.lib.hasSuffix "-linux" s) nixpkgs.lib.systems.flakeExposed;
@@ -40,6 +46,13 @@
     flake-parts.lib.mkFlake { inherit inputs; } {
       imports = [ inputs.treefmt-nix.flakeModule ];
 
+      flake = {
+        githubActions = nix-github-actions.lib.mkGithubMatrix {
+          # github actions supports fewer architectures
+          checks = nixpkgs.lib.getAttrs [ "aarch64-linux" "x86_64-linux" ] self.checks;
+        };
+      };
+
       inherit systems;
 
       perSystem =
@@ -225,49 +238,55 @@
               default = config.packages.${name};
             };
 
-          checks.cargo-clippy = common.craneLib.cargoClippy (
-            common.args
-            // {
-              inherit (common) cargoArtifacts;
-              cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
-            }
-          );
-
-          # we have to build our own `craneLib.cargoTest`
-          checks.cargo-test = common.craneLib.mkCargoDerivation (
-            common.args
-            // {
-              inherit (common) cargoArtifacts;
-              doCheck = true;
-
-              enableParallelChecking = true;
-
-              pnameSuffix = "-test";
-              buildPhaseCargoCommand = "";
-              checkPhaseCargoCommand = ''
-                make ''${enableParallelChecking:+-j''${NIX_BUILD_CORES}} $makeFlags libbcachefs.a
-                cargo test --profile release -- --nocapture
-              '';
-            }
-          );
+          checks = {
+            inherit (config.packages)
+              bcachefs-tools
+              bcachefs-tools-fuse
+              bcachefs-tools-fuse-i686-linux
+              ;
 
-          # cargo clippy with the current minimum supported rust version
-          # according to Cargo.toml
-          checks.msrv =
-            let
-              rustVersion = cargoToml.package.rust-version;
-              common = pkgs.callPackage mkCommon { inherit crane rustVersion; };
-            in
-            common.craneLib.cargoClippy (
+            cargo-clippy = common.craneLib.cargoClippy (
               common.args
               // {
-                pname = "msrv";
                 inherit (common) cargoArtifacts;
                 cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
               }
             );
 
-          checks."32-bit" = config.packages."${cargoToml.package.name}-i686-linux";
+            # we have to build our own `craneLib.cargoTest`
+            cargo-test = common.craneLib.mkCargoDerivation (
+              common.args
+              // {
+                inherit (common) cargoArtifacts;
+                doCheck = true;
+
+                enableParallelChecking = true;
+
+                pnameSuffix = "-test";
+                buildPhaseCargoCommand = "";
+                checkPhaseCargoCommand = ''
+                  make ''${enableParallelChecking:+-j''${NIX_BUILD_CORES}} $makeFlags libbcachefs.a
+                  cargo test --profile release -- --nocapture
+                '';
+              }
+            );
+
+            # cargo clippy with the current minimum supported rust version
+            # according to Cargo.toml
+            msrv =
+              let
+                rustVersion = cargoToml.package.rust-version;
+                common = pkgs.callPackage mkCommon { inherit crane rustVersion; };
+              in
+              common.craneLib.cargoClippy (
+                common.args
+                // {
+                  pname = "msrv";
+                  inherit (common) cargoArtifacts;
+                  cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
+                }
+              );
+          };
 
           devShells.default = pkgs.mkShell {
             inputsFrom = [
-- 
2.48.1

