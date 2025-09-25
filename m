Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B1713C9C4
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758759452; cv=none; b=JqCiQ7cMOLWyclr7WM/Fvo/xB5a36Mq/Pd5qcuEmW06iVCPW8Kgg7kH1aDI3x2SIMikd3AGy3RTIG8jPb/QqWrdMZ6zlxr88+O128/5GvriZxJv/MkQIrKRDLzdZJvs95+CgEvpX2sSXERfkQhPO1w9tKelL+G3jMQzBbFznbyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758759452; c=relaxed/simple;
	bh=Ka4j1FeONTC1gAtWUBGYmZsTgRQ6yV1r5GXyCwZQcgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1IneSeUaHp1cPAIJDljf6pItkJNmeGCkjNrjV64vTiGOU+Lc+Xk1IzN13vwUjDlAw3M2MdpbKjLfgkOzqWo+kHrtNzS9b7RQLfutnvg+mIXZuXCNPbdaA9IDdvB2T9CYr5C/awVbrTop4UoPXZ7zKV4zWV2PlZ6QyizQnym8J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=P2Xs32uS; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="P2Xs32uS"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 72554240101
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 02:17:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.net; s=2017;
	t=1758759448; bh=FBJ9rcQY0QOnNHnGamop3jnfHXAEsRF6S9LwH1qZaWE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=P2Xs32uSuqxOcAubv54cj3sGpDLrI7dRPZ5pU4oxcTUhgvp4uIHC/eJnyGtiE9Tte
	 UntwSNQZPAMbWJjV/J1TyFGHBhpu82+7fyQqkyKTXA6YSh1n6K2UwPUu86Ko5zqkw1
	 czsYTCI1rfy7V3py83IiQqv9NHIvEnZOFy7kO4jIPwnOHVl8T7hfrQ/vs9sILlf8K5
	 NNhIE+aKF/RSOiUmr4ORP2qjcrXT/Au00EM3yMjt1bZFAXczyn4s3j/AEU8SCHcd+0
	 Innlgvq8J9JXZDOQ8/Rv7asuANDIY7kMmurISFG+2xt0ZopI7+QYymUQf7iLL9tKmT
	 JRdNW6zYK6c6Q==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4cXDn373cBz6tvh;
	Thu, 25 Sep 2025 02:17:27 +0200 (CEST)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 1/7] refactor(nix): rm now unused imports
Date: Thu, 25 Sep 2025 00:17:28 +0000
Message-ID: <20250925001718.174749-2-tmuehlbacher@posteo.net>
In-Reply-To: <20250925001718.174749-1-tmuehlbacher@posteo.net>
References: <20250925001718.174749-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 flake.nix | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/flake.nix b/flake.nix
index 98ef62a9..d0811bf5 100644
--- a/flake.nix
+++ b/flake.nix
@@ -64,10 +64,6 @@
           ...
         }:
         let
-          inherit (builtins) readFile split;
-          inherit (lib.lists) findFirst;
-          inherit (lib.strings) hasPrefix removePrefix substring;
-
           pkgs = import nixpkgs {
             inherit system;
             overlays = [ (import rust-overlay) ];
@@ -76,7 +72,7 @@
           cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
           rustfmtToml = builtins.fromTOML (builtins.readFile ./rustfmt.toml);
 
-          rev = self.shortRev or self.dirtyShortRev or (substring 0 8 self.lastModifiedDate);
+          rev = self.shortRev or self.dirtyShortRev or (lib.substring 0 8 self.lastModifiedDate);
           version = "${cargoToml.package.version}+${rev}";
 
           mkCommon =
-- 
2.51.0

