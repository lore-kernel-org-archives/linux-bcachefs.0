Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.de header.i=@kloenk.de header.b="CM0Iw1R6"
Received: from gimli.kloenk.de (gimli.kloenk.de [IPv6:2a01:4f8:c012:b874::])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D5011A
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Nov 2023 13:13:47 -0800 (PST)
From: Finn Behrens <me@kloenk.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.de; s=mail;
	t=1700428423; bh=AnfjLSCGs2L/NBT92Qhnnrr0ZZoaZvI4P9qjL7HoFp0=;
	h=From:To:Cc:Subject:Date;
	b=CM0Iw1R6+rWt+UfYt7P9lhEoPXwNk0DaRdqwGLy4nBcuv7X8A0TFOCr3Qz2kCz63r
	 dcNOjOk66wGrMcyOcGrlHb63/+hET6Z7gqsOZGQkWK/dW0lS4CCM7XY+KsC/tYKH7J
	 IyU91Q1nuqglU8tnEQebe9AGHVqCJwjnbooXMNZg=
To: linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev
Cc: Finn Behrens <me@kloenk.de>
Subject: [PATH TOOLS] nix: add bcachefs-fuse package
Date: Sun, 19 Nov 2023 22:13:14 +0100
Message-ID: <20231119211314.301361-1-me@kloenk.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a fuseSupport argument and bcachefs-fuse as flake output with fuse enabled.

Signed-off-by: Finn Behrens <me@kloenk.de>
---
 build.nix | 7 +++++--
 flake.nix | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/build.nix b/build.nix
index e05dad4..831c7e9 100644
--- a/build.nix
+++ b/build.nix
@@ -1,5 +1,6 @@
 { lib, stdenv, pkg-config, attr, libuuid, libsodium, keyutils, liburcu, zlib
-, libaio, udev, zstd, lz4, nix-gitignore, rustPlatform, rustc, cargo, }:
+, libaio, udev, zstd, lz4, nix-gitignore, rustPlatform, rustc, cargo, fuse3
+, fuseSupport ? false, }:
 let
   src = nix-gitignore.gitignoreSource [ ] ./.;
 
@@ -30,7 +31,9 @@ in stdenv.mkDerivation {
     zlib # zlib1g
     attr
     udev
-  ];
+  ] ++ lib.optional fuseSupport fuse3;
+
+  BCACHEFS_FUSE = if fuseSupport then "1" else "";
 
   cargoRoot = "rust-src";
   # when git-based crates are updated, run:
diff --git a/flake.nix b/flake.nix
index c4185e7..b8f9ce5 100644
--- a/flake.nix
+++ b/flake.nix
@@ -23,6 +23,7 @@
       in {
         packages = {
           inherit (pkgs) bcachefs;
+          bcachefs-fuse = pkgs.bcachefs.override { fuseSupport = true; };
           default = pkgs.bcachefs;
         };
 
-- 
2.42.0

