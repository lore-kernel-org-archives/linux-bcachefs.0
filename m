Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB2A137923
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759454; cv=none; b=Q3yni4OnpDN7z4DQm/sOWjw618Gj2HZ1BVWQ4a5R3T2RY1HjzeAYd7lQ5XuYnznTx2CFFhK+q6Ashxwsb32p5VPJAQNULsC57kbHnQrxZ6yBqk1I4Jx2haIIPKoC1D+Nnr0Y8SZ6T+3eSvXd4rP2deZvmWzJD7ba16V264tJIFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759454; c=relaxed/simple;
	bh=M8tpSruHhX26htI5hIGPrzmgyYMvOGETLYQfMGWWg6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewBqEphJVIJC547h/XbHCFY6g5XdTJIvncqBUMyrr36nq1bOaHNcupNCuGSRUDW0nNSSHI4F4Lz4Pl8IfbxoEeZaUPFUdL6gvuKda9LcEI+9k5ILpvG+LkhAAzBqMA6If1z6OXa9Qf3eUBUmsZIImGkQrLj5uuv1EKxGs2YnPww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=caOCv7ag; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="caOCv7ag"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id D8994240027
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759450; bh=Fz6ox2mz+l7Psbbc1yK0cvd8Uu81BLVwgkWf058KQVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=caOCv7agwoa5n2ckQXotR3sOkumRlSyhvET0yrX00/geX2BZqts3kJRWKPYVPiRI5
	 nmJXmCIoso1xON+1KI5ye9ed2mc+eHqx5Iq8driSWsqwHu2I0b5T5lmWCyQ3aD70Zo
	 4rwHHAqzkjJ0RPG6V1cmUk+TCUhZn+fk0oNAz7b+vLSK6E7d0wk/rk9PjAIh+EdTs+
	 kEYQ4Pfpxyr0RhZ9ZdNeQ1WrCO5vXIJf31zfWuBtOMXJ98BS8IzTGw37ZHsn1Vne1w
	 wYfzxsHP848337Rt0u0e0KeC51Nnw8WNny3m4wM56xWz7ldd6x9sRxgd7LzRf2X8+Y
	 N1+5Rr8Sdp9JQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn61sypz6tvh;
	Thu, 25 Sep 2025 02:17:30 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 4/7] refactor(nix): rm no longer needed build decls
Date: Thu, 25 Sep 2025 00:17:30 +0000
Message-ID: <20250925001718.174749-5-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is now handled by crane for cross builds on its own.
---
 flake.nix | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/flake.nix b/flake.nix
index 0d7ae0be..c2ee9fd6 100644
--- a/flake.nix
+++ b/flake.nix
@@ -85,7 +85,6 @@
               buildPackages,
               pkg-config,
               rustPlatform,
-              stdenv,
 
               # run time
               keyutils,
@@ -99,8 +98,6 @@
               zstd,
             }:
             let
-              inherit (stdenv) cc hostPlatform;
-
               craneLib = (crane.mkLib pkgs).overrideToolchain (
                 p: p.rust-bin.stable."${rustVersion}".minimal.override { extensions = [ "clippy" ]; }
               );
@@ -113,11 +110,6 @@
                 env = {
                   PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
                   PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";
-
-                  CARGO_BUILD_TARGET = hostPlatform.rust.rustcTargetSpec;
-                  "CARGO_TARGET_${hostPlatform.rust.cargoEnvVarTarget}_LINKER" = "${cc.targetPrefix}cc";
-                  HOST_CC = "${cc.nativePrefix}cc";
-                  TARGET_CC = "${cc.targetPrefix}cc";
                 };
 
                 makeFlags = [
@@ -128,10 +120,6 @@
 
                 dontStrip = true;
 
-                depsBuildBuild = [
-                  buildPackages.stdenv.cc
-                ];
-
                 nativeBuildInputs = [
                   pkg-config
                   rustPlatform.bindgenHook
-- 
2.51.0

