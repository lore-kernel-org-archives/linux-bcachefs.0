Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0921D010
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549391; cv=none; b=kqrduvPDJd6IX6EQPNUnHG606pH7511JvVnrJFOdA1qwI2KhPV03PAB9KkSJhtbme6IaIu1j5wbxCASx5nQpL32aPE1EPfIVUrnT/AVf5GQ9HYERumQNYYOFTXDCVxwxVGV7yC2HVlek3+AdayTIl64h7/dOsSOnKBkJkOlVCZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549391; c=relaxed/simple;
	bh=7/bImNLxnIz7tQKK/FA8v9deqM/yv34n8/crNL6qBxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNY/CPu8CqQlA0+3pMysSsZxxv+Clbkpsrh0EHQBxHr03vQazELf+Sf5Zlymi8kf07Y2Eej50kaLqnoPIpOg8mFWLbpF4KhCo86vwxEeXFX1mjxfa6j3GxcD6hDdGSQEQFhWp6a0QQzkLYK93ErwRhcECtVzZEvxNmuXEPO8eWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=ciyWCx5L; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="ciyWCx5L"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 275F6240027
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549387; bh=7/bImNLxnIz7tQKK/FA8v9deqM/yv34n8/crNL6qBxs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=ciyWCx5LUI46xiveEgc56HUhYQv0AoUAsFafFJynMGV2p9fG/vd+lIJgbpIdeK0sZ
	 ixe35xRxIHlIrI9mUIz93u3jFJnTycYjOwuM5hUAKs+yU+UY5Ft3SvB3N/V13j61iF
	 j2GCCOaV8NUjtbvv25k9cPERIfUASE4I8pxoEFUUD07NQbkQYCrs6jA03Q3LWF5mKJ
	 3mgvoDJ/RcAyJjK7dtBJol7hjyrhPdS8Ce6eGHzUVINLq8EYkedMvbiUgGm7SKSzNv
	 HY86AtfYg6wRXY51Fvu3xCYrAipNI5LWql3kQzerv5NBvaTyMcg6kv7PNyFZ3S+YsQ
	 uqS9abUoUxwqA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0V52kSz6tvd;
	Fri, 10 Jan 2025 23:49:46 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 7/9] feat(nix): enable cross compilation
Date: Fri, 10 Jan 2025 22:49:10 +0000
Message-ID: <20250110224912.445491-8-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds packages for every member of systems from any of the systems. Since
rust-overlay is more or less basically like rustup, we get to just have
all of those targets without having to build quite as much of the
toolchain.
---
 flake.nix | 257 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 173 insertions(+), 84 deletions(-)

diff --git a/flake.nix b/flake.nix
index f435edc6..4f568b40 100644
--- a/flake.nix
+++ b/flake.nix
@@ -63,104 +63,190 @@
           cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
           rustfmtToml = builtins.fromTOML (builtins.readFile ./rustfmt.toml);
 
-          craneLib = crane.mkLib pkgs;
-
           rev = self.shortRev or self.dirtyShortRev or (substring 0 8 self.lastModifiedDate);
           makefileVersion = removePrefix "VERSION=" (
             findFirst (line: hasPrefix "VERSION=" line) "VERSION=0.0.0" (split "\n" (readFile ./Makefile))
           );
           version = "${makefileVersion}+${rev}";
 
-          commonArgs = {
-            inherit version;
-            src = self;
-
-            env = {
-              PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
-              PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";
+          mkCommon =
+            {
+              crane,
+              pkgs,
+              rustVersion ? "latest",
+
+              # build time
+              buildPackages,
+              pkg-config,
+              rustPlatform,
+              stdenv,
+
+              # run time
+              attr,
+              keyutils,
+              libaio,
+              libsodium,
+              liburcu,
+              libuuid,
+              lz4,
+              udev,
+              zlib,
+              zstd,
+            }:
+            let
+              inherit (stdenv) cc hostPlatform;
+
+              craneLib = (crane.mkLib pkgs).overrideToolchain (
+                p: p.rust-bin.stable."${rustVersion}".minimal.override { extensions = [ "clippy" ]; }
+              );
+
+              args = {
+                inherit version;
+                src = self;
+                strictDeps = true;
+
+                env = {
+                  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
+                  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";
+
+                  CARGO_BUILD_TARGET = hostPlatform.rust.rustcTargetSpec;
+                  "CARGO_TARGET_${hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${cc.targetPrefix}cc";
+                  HOST_CC = "${cc.nativePrefix}cc";
+                  TARGET_CC = "${cc.targetPrefix}cc";
+                };
+
+                makeFlags = [
+                  "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
+                  "PREFIX=${placeholder "out"}"
+                  "VERSION=${version}"
+                ];
+
+                dontStrip = true;
+
+                depsBuildBuild = [
+                  buildPackages.stdenv.cc
+                ];
+
+                nativeBuildInputs = [
+                  pkg-config
+                  rustPlatform.bindgenHook
+                ];
+
+                buildInputs = [
+                  attr
+                  keyutils
+                  libaio
+                  libsodium
+                  liburcu
+                  libuuid
+                  lz4
+                  udev
+                  zlib
+                  zstd
+                ];
+
+                meta = {
+                  description = "Userspace tools for bcachefs";
+                  license = lib.licenses.gpl2Only;
+                  mainProgram = "bcachefs";
+                };
+              };
+
+              cargoArtifacts = craneLib.buildDepsOnly args;
+            in
+            {
+              inherit args cargoArtifacts craneLib;
             };
-
-            makeFlags = [
-              "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
-              "PREFIX=${placeholder "out"}"
-              "VERSION=${version}"
-            ];
-
-            dontStrip = true;
-
-            nativeBuildInputs = with pkgs; [
-              pkg-config
-              rustPlatform.bindgenHook
-            ];
-
-            buildInputs = with pkgs; [
-              attr
-              keyutils
-              libaio
-              libsodium
-              liburcu
-              libuuid
-              lz4
-              udev
-              zlib
-              zstd
-            ];
-
-            meta = {
-              description = "Userspace tools for bcachefs";
-              license = lib.licenses.gpl2Only;
-              mainProgram = "bcachefs";
-            };
-          };
-
-          cargoArtifacts = craneLib.buildDepsOnly (commonArgs // { pname = cargoToml.package.name; });
+          common = pkgs.callPackage mkCommon { inherit crane; };
+
+          mkPackage =
+            { common, name }:
+            common.craneLib.buildPackage (
+              common.args
+              // {
+                inherit (common) cargoArtifacts;
+                pname = name;
+
+                enableParallelBuilding = true;
+                buildPhaseCargoCommand = ''
+                  make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags
+                '';
+                doNotPostBuildInstallCargoBinaries = true;
+                installPhaseCommand = ''
+                  make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags install
+                '';
+
+                doInstallCheck = true;
+                installCheckPhase = ''
+                  runHook preInstallCheck
+
+                  test "$($out/bin/bcachefs version)" = "${version}"
+
+                  runHook postInstallCheck
+                '';
+              }
+            );
+
+          mkPackages =
+            name: systems:
+            let
+              inherit (lib) flatten listToAttrs map;
+
+              genPackageList =
+                crossSystem:
+                let
+                  localSystem = system;
+                  pkgs' = import nixpkgs {
+                    inherit crossSystem localSystem;
+                    overlays = [ (import rust-overlay) ];
+                  };
+
+                  common = pkgs'.callPackage mkCommon { inherit crane; };
+                  package = pkgs'.callPackage mkPackage { inherit common name; };
+                in
+                [
+                  {
+                    name = "${name}-${crossSystem}";
+                    value = package;
+                  }
+                  {
+                    name = "${name}-fuse-${crossSystem}";
+                    value = package.overrideAttrs (
+                      final: prev: {
+                        makeFlags = prev.makeFlags ++ [ "BCACHEFS_FUSE=1" ];
+                        buildInputs = prev.buildInputs ++ [ pkgs'.fuse3 ];
+                      }
+                    );
+                  }
+                ];
+            in
+            listToAttrs (flatten (map genPackageList systems));
         in
         {
-          packages.default = config.packages.bcachefs-tools;
-          packages.bcachefs-tools = craneLib.buildPackage (
-            commonArgs
+          packages =
+            let
+              inherit (cargoToml.package) name;
+            in
+            (mkPackages name systems)
             // {
-              inherit cargoArtifacts;
-
-              enableParallelBuilding = true;
-              buildPhaseCargoCommand = ''
-                make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags
-              '';
-              installPhaseCommand = ''
-                make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags install
-              '';
-
-              doInstallCheck = true;
-              installCheckPhase = ''
-                runHook preInstallCheck
-
-                test "$($out/bin/bcachefs version)" = "${version}"
-
-                runHook postInstallCheck
-              '';
-            }
-          );
-
-          packages.bcachefs-tools-fuse = config.packages.bcachefs-tools.overrideAttrs (
-            final: prev: {
-              makeFlags = prev.makeFlags ++ [ "BCACHEFS_FUSE=1" ];
-              buildInputs = prev.buildInputs ++ [ pkgs.fuse3 ];
-            }
-          );
+              ${name} = config.packages."${name}-${system}";
+              "${name}-fuse" = config.packages."${name}-fuse-${system}";
+              default = config.packages.${name};
+            };
 
-          checks.cargo-clippy = craneLib.cargoClippy (
-            commonArgs
+          checks.cargo-clippy = common.craneLib.cargoClippy (
+            common.args
             // {
-              inherit cargoArtifacts;
-              cargoClippyExtraArgs = "--all-targets -- --deny warnings";
+              inherit (common) cargoArtifacts;
+              cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
             }
           );
 
           # we have to build our own `craneLib.cargoTest`
-          checks.cargo-test = craneLib.mkCargoDerivation (
-            commonArgs
+          checks.cargo-test = common.craneLib.mkCargoDerivation (
+            common.args
             // {
-              inherit cargoArtifacts;
+              inherit (common) cargoArtifacts;
               doCheck = true;
 
               enableParallelChecking = true;
@@ -188,9 +274,12 @@
               cargo-audit
               cargo-outdated
               clang-tools
-              clippy
-              rust-analyzer
-              rustc
+              (rust-bin.stable.latest.minimal.override {
+                extensions = [
+                  "rust-analyzer"
+                  "rust-src"
+                ];
+              })
             ];
           };
 
-- 
2.47.0

