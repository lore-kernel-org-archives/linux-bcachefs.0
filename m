Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D332F43
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575253; cv=none; b=PtK8jsNp1KF/XIan2zzcBBOoDAuxJJS4V+fEEkTTgQfg6IBB7Ij3AJbPQYKe6jhk6ryfuLHZDlcI8VSRWtMO4vITFRy7NOgnyLkVLvUy5G7HtKtjcOll7Yuwl9O5GftIfIsqilwB8bUFhR4WaLQLrWSLTNKttF+UxLmyHaLIswc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575253; c=relaxed/simple;
	bh=bxzHypquEKFd2Pumle2Xv0kxfJCVxQ5VbIZ4xbrYJas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOjFMYgtkqavU6TNMGf0blYZrCc+Wg9pQ25OlbyLvhCmtJ36bA3OAzbQwsWNMAihN8DfKzZ3wPR25L9mXJSQaptqEhXQX+ZmFQWScTR/MKX85AclRLRwfPgMSLmXc5gm53QlTNkSsg+v4yXsVhfZkdwJ2cWyqrMgQppXFGGT0gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=bQxesPJx; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="bQxesPJx"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 40B81240032
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574868; bh=bxzHypquEKFd2Pumle2Xv0kxfJCVxQ5VbIZ4xbrYJas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=bQxesPJxWTY/0fjoFZHyxAn5RJv6OwmGMR6QwgPAog/mFyyCu86dHStQtMWcC37Lq
	 Mc/uIrjAnhTU5BxsDt48kfK5HViPZtDchZsTvFOVr8XQHLhZQtGp8u11anb6EriBEh
	 v+hPf7QqCU6dqy579p8CCSxypnR89h+fTl3aFon/2yP29+PaygtrcUTtTd6pGtJS+t
	 D4t+ThCu7DaVflGGQomqDvyL/pozX9ml+P05MP/2a1BSOvhM8l0MRc4a/Vb9A2npTO
	 VSfNVID866Te4ahTaXgNYRcwKulGwEFNLvt0ZSH4c+eb96M7MrZWnayjBDiEawyM07
	 fcEivkUQiC9Wg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M526fzz9rxK;
	Fri, 21 Mar 2025 17:34:25 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 07/10] feat(nix): enable cross compilation
Date: Fri, 21 Mar 2025 16:34:01 +0000
Message-ID: <20250321163404.353334-8-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
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
 flake.nix | 250 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 166 insertions(+), 84 deletions(-)

diff --git a/flake.nix b/flake.nix
index 5f93f522..ce6f4084 100644
--- a/flake.nix
+++ b/flake.nix
@@ -63,104 +63,183 @@
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
+              packagesForSystem =
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
+                  packageFuse = package.overrideAttrs (
+                    final: prev: {
+                      makeFlags = prev.makeFlags ++ [ "BCACHEFS_FUSE=1" ];
+                      buildInputs = prev.buildInputs ++ [ pkgs'.fuse3 ];
+                    }
+                  );
+                in
+                [
+                  (lib.nameValuePair "${name}-${crossSystem}" package)
+                  (lib.nameValuePair "${name}-fuse-${crossSystem}" packageFuse)
+                ];
+            in
+            lib.listToAttrs (lib.flatten (map packagesForSystem systems));
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
@@ -188,9 +267,12 @@
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
2.48.1

