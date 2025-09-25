Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3761D14885D
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759455; cv=none; b=amKai0lsmz17iOTLuBPOdwpiIx6WJQzihUpow2BuD3afcF/dqJJe4CvFqmFjpQ3fng5FKoCKf4UlE8CvjrlXU9i2weC/uKZjkmO+zY/pVPxRlYknEhOUZ3JmlGrOPxRJaYFWVkTZfKhfq0iYrl0Som06Wrf18O9SJvQaol/pNgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759455; c=relaxed/simple;
	bh=XfvTbkdeW0R0Qzh/NfQFdqvKhEEdEqDqg7QsoiTHATA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMjWD8F2bOJPVe8TxwefibnuXkLJovcCOdXrjU6MyrOK0NDy+5m7YHwXE/XhJCh6DMJpPotl/W5u4qO5BDGhNVhETknbajG95Cl3vZb/dQyPOyEkv/SY6t+9T8MHp3BH27RTIwEwRc+JMGMotw41Fkct1aHUSBeuwO1n1yu4UAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=VIK8cBUM; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="VIK8cBUM"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 7E3F4240028
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759451; bh=osW3+/q8zCGnRWOT6suV8yw7sIiev+DeJZ6EbNFxahU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=VIK8cBUMPI1eO6hectd91UWaaqXQZyRoa5UJ2IcBD38gktH6i4sephKxciLoCWswQ
	 HhWSafDFtmXMD/zayEHi7QZ94kd97RtRYl8P/hf5fqX4GDRqbwmdgA5bzP/eztzH/P
	 Jr8hj6XKyRIBIKz5512P4ESiiq5Bf36sAq8aiNGIrVaKNT3yFrlkFbyh05RxqMGY/p
	 gT92EBt+oy0VH6septrL0hBsIJxhI744mT/lT5koDV0G7XA3LQK5BhoWjIydpdu/4Z
	 YrJkaNRuyHLIkaN40cBhbK/I7MjjSwkRgRwGnz/0gqIuE8IDNbtr8Mni8XSIXsUwAy
	 Eiwq2W4f5BMaw==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn674Nqz6twH;
	Thu, 25 Sep 2025 02:17:30 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 5/7] refactor(nix): move out build into separate file
Date: Thu, 25 Sep 2025 00:17:31 +0000
Message-ID: <20250925001718.174749-6-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

flake.nix is getting too big and this makes it easier to understand what
is going on with e.g. callPackage.
---
 crane-build.nix | 139 +++++++++++++++++++++++++++++++++++
 flake.nix       | 189 ++++++------------------------------------------
 2 files changed, 163 insertions(+), 165 deletions(-)
 create mode 100644 crane-build.nix

diff --git a/crane-build.nix b/crane-build.nix
new file mode 100644
index 00000000..9b764ec9
--- /dev/null
+++ b/crane-build.nix
@@ -0,0 +1,139 @@
+{
+  lib,
+  pkgs,
+
+  # build time
+  pkg-config,
+  rustPlatform,
+
+  # run time
+  fuse3,
+  keyutils,
+  libaio,
+  libsodium,
+  liburcu,
+  libuuid,
+  lz4,
+  udev,
+  zlib,
+  zstd,
+
+  crane,
+  rustVersion ? "latest",
+  version,
+}:
+let
+  craneLib = (crane.mkLib pkgs).overrideToolchain (
+    p: p.rust-bin.stable."${rustVersion}".minimal.override { extensions = [ "clippy" ]; }
+  );
+
+  args = {
+    inherit version;
+    src = ./.;
+    strictDeps = true;
+
+    env = {
+      PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
+      PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";
+    };
+
+    makeFlags = [
+      "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
+      "PREFIX=${placeholder "out"}"
+      "VERSION=${version}"
+    ];
+
+    dontStrip = true;
+
+    nativeBuildInputs = [
+      pkg-config
+      rustPlatform.bindgenHook
+    ];
+
+    buildInputs = [
+      keyutils
+      libaio
+      libsodium
+      liburcu
+      libuuid
+      lz4
+      udev
+      zlib
+      zstd
+    ];
+  };
+
+  cargoArtifacts = craneLib.buildDepsOnly args;
+
+  package = craneLib.buildPackage (
+    args
+    // {
+      inherit cargoArtifacts;
+
+      enableParallelBuilding = true;
+      buildPhaseCargoCommand = ''
+        make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags
+      '';
+      doNotPostBuildInstallCargoBinaries = true;
+      installPhaseCommand = ''
+        make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags install
+      '';
+
+      doInstallCheck = true;
+      installCheckPhase = ''
+        runHook preInstallCheck
+
+        test "$($out/bin/bcachefs version)" = "${version}"
+
+        runHook postInstallCheck
+      '';
+
+      meta = {
+        description = "Userspace tools for bcachefs";
+        license = lib.licenses.gpl2Only;
+        mainProgram = "bcachefs";
+      };
+    }
+  );
+
+  packageFuse = package.overrideAttrs (
+    final: prev: {
+      makeFlags = prev.makeFlags ++ [ "BCACHEFS_FUSE=1" ];
+      buildInputs = prev.buildInputs ++ [ fuse3 ];
+    }
+  );
+
+  cargo-clippy = craneLib.cargoClippy (
+    args
+    // {
+      inherit cargoArtifacts;
+      cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
+    }
+  );
+
+  # we have to build our own `craneLib.cargoTest`
+  cargo-test = craneLib.mkCargoDerivation (
+    args
+    // {
+      inherit cargoArtifacts;
+      doCheck = true;
+
+      enableParallelChecking = true;
+
+      pnameSuffix = "-test";
+      buildPhaseCargoCommand = "";
+      checkPhaseCargoCommand = ''
+        make ''${enableParallelChecking:+-j''${NIX_BUILD_CORES}} $makeFlags libbcachefs.a
+        cargo test --profile release -- --nocapture
+      '';
+    }
+  );
+in
+{
+  inherit
+    cargo-clippy
+    cargo-test
+    package
+    packageFuse
+    ;
+}
diff --git a/flake.nix b/flake.nix
index c2ee9fd6..8b38ba19 100644
--- a/flake.nix
+++ b/flake.nix
@@ -74,113 +74,9 @@
 
           rev = self.shortRev or self.dirtyShortRev or (lib.substring 0 8 self.lastModifiedDate);
           version = "${cargoToml.package.version}+${rev}";
-
-          mkCommon =
-            {
-              crane,
-              pkgs,
-              rustVersion ? "latest",
-
-              # build time
-              buildPackages,
-              pkg-config,
-              rustPlatform,
-
-              # run time
-              keyutils,
-              libaio,
-              libsodium,
-              liburcu,
-              libuuid,
-              lz4,
-              udev,
-              zlib,
-              zstd,
-            }:
-            let
-              craneLib = (crane.mkLib pkgs).overrideToolchain (
-                p: p.rust-bin.stable."${rustVersion}".minimal.override { extensions = [ "clippy" ]; }
-              );
-
-              args = {
-                inherit version;
-                src = self;
-                strictDeps = true;
-
-                env = {
-                  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
-                  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";
-                };
-
-                makeFlags = [
-                  "INITRAMFS_DIR=${placeholder "out"}/etc/initramfs-tools"
-                  "PREFIX=${placeholder "out"}"
-                  "VERSION=${version}"
-                ];
-
-                dontStrip = true;
-
-                nativeBuildInputs = [
-                  pkg-config
-                  rustPlatform.bindgenHook
-                ];
-
-                buildInputs = [
-                  keyutils
-                  libaio
-                  libsodium
-                  liburcu
-                  libuuid
-                  lz4
-                  udev
-                  zlib
-                  zstd
-                ];
-
-                meta = {
-                  description = "Userspace tools for bcachefs";
-                  license = lib.licenses.gpl2Only;
-                  mainProgram = "bcachefs";
-                };
-              };
-
-              cargoArtifacts = craneLib.buildDepsOnly args;
-            in
-            {
-              inherit args cargoArtifacts craneLib;
-            };
-          common = pkgs.callPackage mkCommon { inherit crane; };
-
-          mkPackage =
-            { common, name }:
-            common.craneLib.buildPackage (
-              common.args
-              // {
-                inherit (common) cargoArtifacts;
-                pname = name;
-
-                enableParallelBuilding = true;
-                buildPhaseCargoCommand = ''
-                  make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags
-                '';
-                doNotPostBuildInstallCargoBinaries = true;
-                installPhaseCommand = ''
-                  make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}} $makeFlags install
-                '';
-
-                doInstallCheck = true;
-                installCheckPhase = ''
-                  runHook preInstallCheck
-
-                  test "$($out/bin/bcachefs version)" = "${version}"
-
-                  runHook postInstallCheck
-                '';
-              }
-            );
-
-          mkPackages =
-            name: systems:
+        in
+        {
+          packages =
             let
               packagesForSystem =
                 crossSystem:
@@ -190,90 +86,53 @@
                     inherit crossSystem localSystem;
                     overlays = [ (import rust-overlay) ];
                   };
+                  withCrossName =
+                    set: lib.mapAttrs' (name: value: lib.nameValuePair "${name}-${crossSystem}" value) set;
 
-                  common = pkgs'.callPackage mkCommon { inherit crane; };
-                  package = pkgs'.callPackage mkPackage { inherit common name; };
-                  packageFuse = package.overrideAttrs (
-                    final: prev: {
-                      makeFlags = prev.makeFlags ++ [ "BCACHEFS_FUSE=1" ];
-                      buildInputs = prev.buildInputs ++ [ pkgs'.fuse3 ];
-                    }
-                  );
+                  craneBuild = pkgs'.callPackage ./crane-build.nix { inherit crane version; };
+                  crossPackages = {
+                    "bcachefs-tools" = craneBuild.package;
+                    "bcachefs-tools-fuse" = craneBuild.packageFuse;
+                  };
                 in
-                [
-                  (lib.nameValuePair "${name}-${crossSystem}" package)
-                  (lib.nameValuePair "${name}-fuse-${crossSystem}" packageFuse)
-                ];
+                (withCrossName crossPackages) // lib.optionalAttrs (crossSystem == localSystem) crossPackages;
+              packages = lib.mergeAttrsList (map packagesForSystem systems);
             in
-            lib.listToAttrs (lib.flatten (map packagesForSystem systems));
-        in
-        {
-          packages =
-            let
-              inherit (cargoToml.package) name;
-            in
-            (mkPackages name systems)
+            packages
             // {
-              ${name} = config.packages."${name}-${system}";
-              "${name}-fuse" = config.packages."${name}-fuse-${system}";
-              default = config.packages.${name};
+              default = self'.packages.${cargoToml.package.name};
             };
 
           checks = {
-            inherit (config.packages)
+            inherit (self'.packages)
               bcachefs-tools
               bcachefs-tools-aarch64-linux
               bcachefs-tools-fuse
               bcachefs-tools-fuse-i686-linux
               ;
-
-            #cargo-clippy = common.craneLib.cargoClippy (
-            #  common.args
-            #  // {
-            #    inherit (common) cargoArtifacts;
-            #    cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
-            #  }
-            #);
-
-            # we have to build our own `craneLib.cargoTest`
-            cargo-test = common.craneLib.mkCargoDerivation (
-              common.args
-              // {
-                inherit (common) cargoArtifacts;
-                doCheck = true;
-
-                enableParallelChecking = true;
-
-                pnameSuffix = "-test";
-                buildPhaseCargoCommand = "";
-                checkPhaseCargoCommand = ''
-                  make ''${enableParallelChecking:+-j''${NIX_BUILD_CORES}} $makeFlags libbcachefs.a
-                  cargo test --profile release -- --nocapture
-                '';
-              }
-            );
+            inherit (pkgs.callPackage ./crane-build.nix { inherit crane version; })
+              # cargo-clippy
+              cargo-test
+              ;
 
             # cargo clippy with the current minimum supported rust version
             # according to Cargo.toml
             msrv =
               let
                 rustVersion = cargoToml.package.rust-version;
-                common = pkgs.callPackage mkCommon { inherit crane rustVersion; };
+                craneBuild = pkgs.callPackage ./crane-build.nix { inherit crane rustVersion version; };
               in
-              common.craneLib.cargoClippy (
-                common.args
-                // {
-                  pname = "msrv";
-                  inherit (common) cargoArtifacts;
-                  cargoClippyExtraArgs = "--all-targets --all-features";
+              craneBuild.cargo-test.overrideAttrs (
+                final: prev: {
+                  pname = "${prev.pname}-msrv";
                 }
               );
           };
 
           devShells.default = pkgs.mkShell {
             inputsFrom = [
-              config.packages.default
               config.treefmt.build.devShell
+              self'.packages.default
             ];
 
             # here go packages that aren't required for builds but are used for
-- 
2.51.0

