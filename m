Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F0621D582
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549390; cv=none; b=cG9QCWfMk3584BEdl89wwrp4oK0PhJnL9aVl/gnWpdei3uyxPKR9yuBuF9nikYEcF4yGn9YAv62IgJ3tmP+mh6z4NM67Nv9+a+TcMQEngvei4aR2v9p4knYDYdWIhb6PP6HtHu8rnP6mWoBseSpk2zqVkYlEWeQVTNtZt9onfb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549390; c=relaxed/simple;
	bh=L1ZB7IHvhmlkacJhnL7G/Dfyn4/kQqfOC+YHKNEEqXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNz6yq9STTZYHZfC7UqJaixxPxIajVkOOuH6rkV6K6z7Ary/oLnywL9R/W1JMEAkyjfOs7Sk21Psr18WyqAIvGYOHsR3esjvHD45w4i+2lZQYP67hgcyyvM9rCH18ktsaHCdJsQJ9Jsd2x1kyzefUtYyDAkK4qaHH9EHwJDMoH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=UNNjpCxv; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="UNNjpCxv"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 84924240103
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549387; bh=L1ZB7IHvhmlkacJhnL7G/Dfyn4/kQqfOC+YHKNEEqXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=UNNjpCxvjLzoiu0bkAXXyDv0B5IKZeEIZCfnLZZyGiBN2qQnyyq5DrHRQphy/ZL2D
	 QvlcrbsOOPfCQ9I/GjPuvIUf1YM4tPVP0wCHBhbeXaAd19HmssLUJwgLf45d8XE3Y/
	 JvbKZX1lbvMZW88DuGZwWhonHxQhVcj6UnqgZFuA7XhRqnfG8bTyCM1732vbWa8E3H
	 kjFW/qRLGV/8QQATT2hQhv1iOeJoj1a5tARaT2BkFRbuZy2NkXawkP6bX7A0ilJjNx
	 bP//DTf703bcm33TJ6DBtMdYn1Ns0+yaW53Q7iFsWD1+a1au7MFKQCB6C05hdFongF
	 MptMnbKHgUy9w==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0W0rRjz6tvd;
	Fri, 10 Jan 2025 23:49:47 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 8/9] feat(nix): add an MSRV build to CI
Date: Fri, 10 Jan 2025 22:49:11 +0000
Message-ID: <20250110224912.445491-9-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
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
index 25a42e50..61aaf58f 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -3,7 +3,7 @@ name = "bcachefs-tools"
 version = "1.12.0"
 authors = ["Yuxuan Shui <yshuiv7@gmail.com>", "Kayla Firestack <dev@kaylafire.me>", "Kent Overstreet <kent.overstreet@linux.dev>" ]
 edition = "2021"
-rust-version = "1.77"
+rust-version = "1.77.0"
 
 [[bin]]
 name = "bcachefs"
diff --git a/flake.nix b/flake.nix
index 4f568b40..62bf40ca 100644
--- a/flake.nix
+++ b/flake.nix
@@ -260,6 +260,22 @@
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
2.47.0

