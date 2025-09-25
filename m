Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE0914B08A
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759456; cv=none; b=UkVe1r7FJ7ehHb6g3dvkVS8lx1BFtJQvQUJIvund+qziBZjdn/kb1oiO3+EOR4kBJB9FSb3VwdvKrCxo1ZgK7A+z8HIhAHHD5jDGURhU6i54rOSYIWKu6mXzrXFiRsesDl3Ri7BQaS/abTqRYfdjeyFiE1b1kVvYwbzMvxmSrXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759456; c=relaxed/simple;
	bh=3w08++B/lb7WTvUULKFkN7Eo8ilSsoz2xi829DAiNes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8b65bDx2alX2KgcpR9YY/nhUwYw1g5fN5P7K5Tflnyjgd5r3qoTaCM1efamrUGlQsB12sx8Xk2NeLCzsISxxQcUx3a9da4+t6rFheAbJGAKlAom2w+TpnHz+XIXS1ulIa5k4/v4jqXLjCqTaCYcjRC+/rssskv2AtYMvaONsws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=V0MAAl9C; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="V0MAAl9C"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id DE15D240028
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759452; bh=eV0XJV/lq+WzXhbOrOSuNfGVzN2kgo9Raw6eJAvjPYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=V0MAAl9Cx3ObXq6EAillz4HLxL3pNS6tXuLWQM6afiiw8Zwmrcy2LF5XEMubjVtfs
	 YrCEQwu21dQBkpmsvuMnZApdB2Tcjkbu7cSBuSe3qWgVg7OyYyjM4148t1eqmjazXf
	 +s9Lfy+bcYxD9NHYkgSW7IwomjVZKlxWNTvW7d7gU6ZJf1L3zhhktRx7BortUZiboh
	 K0B7a0uGv1k/AZbtad7RlwZHMtrwQtsvcggrl5O8kSFwZQAVgq/9lqWpAOp79FKCxx
	 2GZgwLFgowYFDtD9Tcb8m+9vm2VW1DazarsSifnchhw0texag2RZheMIJ/LgRPEIGf
	 x3JqlsHiZUe/A==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn82x8Gz6tvh;
	Thu, 25 Sep 2025 02:17:32 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 7/7] feat(nix): add mkosi to devshell
Date: Thu, 25 Sep 2025 00:17:32 +0000
Message-ID: <20250925001718.174749-8-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This way to get an mkosi that works for building Debian stuff from
nixpkgs is a bit cursed but it mostly works.
---
 flake.nix | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/flake.nix b/flake.nix
index 8b38ba19..23e14946 100644
--- a/flake.nix
+++ b/flake.nix
@@ -74,6 +74,39 @@
 
           rev = self.shortRev or self.dirtyShortRev or (lib.substring 0 8 self.lastModifiedDate);
           version = "${cargoToml.package.version}+${rev}";
+
+          # this is somewhat insane
+          mkosiFhs =
+            let
+              keyringDeb = pkgs.fetchurl {
+                url = "https://deb.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2025.1_all.deb";
+                hash = "sha256-nqd3jkQxRMpJBmhzeoqyLdPnSLuZ6AXiLsBVq+s8f6w=";
+              };
+              debian-archive-keyring =
+                pkgs.runCommandNoCCLocal "debian-archive-keyring"
+                  {
+                    nativeBuildInputs = with pkgs; [ binutils ];
+                  }
+                  ''
+                    ar vx ${keyringDeb}
+                    mkdir "$out"
+                    tar -xf data.tar.xz --transform "s|/usr||" -C "$out"
+                  '';
+            in
+            pkgs.buildFHSEnv {
+              name = "mkosi";
+              runScript = "mkosi";
+              targetPkgs =
+                pkgs: with pkgs; [
+                  apt
+                  debian-archive-keyring
+                  dpkg
+                  e2fsprogs
+                  gnupg
+                  jq
+                  mkosi
+                ];
+            };
         in
         {
           packages =
@@ -143,6 +176,7 @@
               cargo-audit
               cargo-outdated
               clang-tools
+              mkosiFhs
               (rust-bin.stable.latest.minimal.override {
                 extensions = [
                   "rust-analyzer"
-- 
2.51.0

