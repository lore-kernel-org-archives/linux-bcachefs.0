Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12689227E99
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574876; cv=none; b=nFyIiVRYbh3wxCQDsPlhMna7Bz1oDH1oyAC0M3ZAG1yulUwGi/Qt0wWoVLgYe3B/wX/dRN61moRNf7N+oLddqFkzLzqDaCruSGKruOgzDLSm4PPe7hXHufCo7hPOWtdnM0pSZ8lqefCg2Tg8f1+D26SeWxMUJaWvsKA4h8GkuhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574876; c=relaxed/simple;
	bh=kgq+zoyY9b6SYE38tP0wAFn96+JJe1wi6dY6QkzN5O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpBBEvQKnSa60MwotW8+jCrCyFgnhjNUxMuPeAbYhmeMtwMPOhbxOqAAX7dmy0ma/RME0v6P5ErelM9w5ds+X4P5Ncqq9v4Ijt7ZGD/unFzddCHESP74Z+I2AJyUS80nALQL1UJ0BA0PKURmU7hRHd9D/JN9qZhbgGku/H3WCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=rGnqxCaX; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="rGnqxCaX"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 4221124010A
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574868; bh=kgq+zoyY9b6SYE38tP0wAFn96+JJe1wi6dY6QkzN5O8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=rGnqxCaXwBtA8tAgoPR9XudT0Bk2RSOy2WGc50risIiPUk2B0I98Z4UUaPgCohXUg
	 DvcPSZUBg3fYdcI8E1+LcG59O5gSnD6VaZu6VbH15q4qwExcmlJt7cLOgP7V26l08n
	 Sn3hGTjRDDhzTCtIu4Iqmb1TzYkOKSPm0/Zn1CG51cUEGSHTNhRJ0rIWgrMdTODHNK
	 ZV0Y3lG1mJjFy2saPxlYgX0GdJ1a3MNwd86qq9Sj3PZfca5+AMRNvWk8CQ3z50IqB0
	 s5goBxgaqzksG8pIkyhrvSiISp97e4Bc9nmqogoGg3NK1vpeR8C/xKDZJcQRD7qht4
	 9/jTIY6QBJgMA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M55B6wz9rxh;
	Fri, 21 Mar 2025 17:34:25 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 08/10] feat(nix): add an MSRV build to CI
Date: Fri, 21 Mar 2025 16:34:02 +0000
Message-ID: <20250321163404.353334-9-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Having a build that uses the actual version of Rust specified in
Cargo.toml should allow us to catch issues with breaking MSRV compat
more easily.
---
 Cargo.toml |  2 +-
 flake.nix  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Cargo.toml b/Cargo.toml
index d1a92ab7..54b6ec35 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -3,7 +3,7 @@ name = "bcachefs-tools"
 version = "1.25.0"
 authors = ["Yuxuan Shui <yshuiv7@gmail.com>", "Kayla Firestack <dev@kaylafire.me>", "Kent Overstreet <kent.overstreet@linux.dev>" ]
 edition = "2021"
-rust-version = "1.77"
+rust-version = "1.77.0"
 
 [[bin]]
 name = "bcachefs"
diff --git a/flake.nix b/flake.nix
index ce6f4084..c8225203 100644
--- a/flake.nix
+++ b/flake.nix
@@ -253,6 +253,22 @@
             }
           );
 
+          # cargo clippy with the current minimum supported rust version
+          # according to Cargo.toml
+          checks.msrv =
+            let
+              rustVersion = cargoToml.package.rust-version;
+              common = pkgs.callPackage mkCommon { inherit crane rustVersion; };
+            in
+            common.craneLib.cargoClippy (
+              common.args
+              // {
+                pname = "msrv";
+                inherit (common) cargoArtifacts;
+                cargoClippyExtraArgs = "--all-targets --all-features -- --deny warnings";
+              }
+            );
+
           devShells.default = pkgs.mkShell {
             inputsFrom = [
               config.packages.default
-- 
2.48.1

