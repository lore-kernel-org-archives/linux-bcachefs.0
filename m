Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966FE4431
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574874; cv=none; b=LDNOcdFZXZf4dm+uSGJJ7AzCpQKmypqgn2rkgtSttIjvzKsfTGwhBR51cDdzYfQFvHRPHqTWeRvO8SF8QxD4pShMy6P9iYkAIPjefFYO7A1rsHKjMR2pkebL2mSpang57Q3tSjgvfdKX0QtNnIPwv2dsAdfAxNnU/OUMBkDQl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574874; c=relaxed/simple;
	bh=HTweKfCRyvMo24uCnw+u7yHla1MmwFp0dgASY94T/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxNO/ikXRX/qGG/YNWc98CBIp+5VmX5qqF6nkoX12mejdjcafn7rVZmo+Exuv5icE/p33QrDJWahRdeBgd446yKzLkytR1zToGyCXMnC3c2FcK3yRXGZLqEUG6zUYSznScOFsX0Mw5l0PyJeNk/gB+VqKGpDH1NZeBUzsmIDWkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=e5sfaYLg; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="e5sfaYLg"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 0E6C5240103
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Mar 2025 17:34:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1742574864; bh=HTweKfCRyvMo24uCnw+u7yHla1MmwFp0dgASY94T/kM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=e5sfaYLg7AfvBJMCMTUDH4VRw7EVa04FY/DnI708AWjnxwyR/TOVSDhu+umhaHffp
	 UNQxH4gFFRqS0NXb93uTM8nWZYdFx8DPUh9rmAksPcqdejJ2MboZ/n0AcERd8X/G6x
	 8WbzCR0XsN4heuemgcy3BBCtufCvjErRO4W/UyX4cxPZYksEK/gaMcEWB+cYfLIt4t
	 5AHY13EsRBc/7XHpV2i6gxsZdX3CWUMejlWgXWGsfW3Yyp7wH7mhM/yLlKFj8vAQ7q
	 qmHdqxt3Y32UfKoS6q8eH/c/iLqA9nfVw7tLQs3+vetz2+6aPMmi2PDsHrZJSGdJtR
	 4gyALT6ggNyxQ==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4ZK7M346Znz9rxM;
	Fri, 21 Mar 2025 17:34:23 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH v2 03/10] feat(nix): open up support to more architectures
Date: Fri, 21 Mar 2025 16:33:57 +0000
Message-ID: <20250321163404.353334-4-tmuehlbacher@posteo.net>
In-Reply-To: <20250321163404.353334-1-tmuehlbacher@posteo.net>
References: <20250321163404.353334-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This means that the flake can now be built for the following
architectures:

- aarch64-linux
- armv6l-linux
- armv7l-linux
- i686-linux
- powerpc64le-linux
- riscv64-linux
- x86_64-linux

It doesn't mean that it's necessarily going to work perfectly on all of
these architecture and binary cache support is not available for a lot
of them either. But at least it let's you build for them if you want to.
---
 flake.nix | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/flake.nix b/flake.nix
index d8836b87..9e09a621 100644
--- a/flake.nix
+++ b/flake.nix
@@ -34,16 +34,13 @@
       crane,
       ...
     }:
+    let
+      systems = nixpkgs.lib.filter (s: nixpkgs.lib.hasSuffix "-linux" s) nixpkgs.lib.systems.flakeExposed;
+    in
     flake-parts.lib.mkFlake { inherit inputs; } {
       imports = [ inputs.treefmt-nix.flakeModule ];
 
-      # can be extended, but these have proper binary cache support in nixpkgs
-      # as of writing.
-      systems = [
-        "aarch64-linux"
-        "x86_64-linux"
-        "i686-linux"
-      ];
+      inherit systems;
 
       perSystem =
         {
-- 
2.48.1

